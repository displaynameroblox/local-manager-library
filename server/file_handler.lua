--[[
    File Handler for Java to Lua Transpiler Server
    Handles file uploads, downloads, and management
]]

local fileHandler = {}

-- Configuration
local config = {
    uploadDir = "server/uploads/",
    downloadDir = "server/downloads/",
    maxFileSize = 1024 * 1024, -- 1MB
    allowedExtensions = {".java"},
    maxFiles = 100
}

-- Utility functions
local function log(message)
    print("[FileHandler] " .. message)
end

local function createResponse(status, data, headers)
    headers = headers or {}
    if not headers["Content-Type"] then
        headers["Content-Type"] = "application/json"
    end
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
    headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    
    return {
        status = status,
        data = data,
        headers = headers
    }
end

-- File operations
local function saveFile(filename, content)
    local success, error = pcall(function()
        writefile(filename, content)
    end)
    return success, error
end

local function readFile(filename)
    local success, content = pcall(function()
        return readfile(filename)
    end)
    return success, content
end

local function fileExists(filename)
    local success, exists = pcall(function()
        return isfile(filename)
    end)
    return success and exists
end

local function deleteFile(filename)
    local success, error = pcall(function()
        delfile(filename)
    end)
    return success, error
end

local function listFiles(directory)
    local success, files = pcall(function()
        return listfiles(directory)
    end)
    return success, files or {}
end

-- Validation functions
local function validateFileExtension(filename)
    for _, ext in ipairs(config.allowedExtensions) do
        if filename:match(ext .. "$") then
            return true
        end
    end
    return false
end

local function validateFileSize(content)
    return #content <= config.maxFileSize
end

local function sanitizeFilename(filename)
    -- Remove dangerous characters and path traversal attempts
    return filename:gsub("[^%w%.%-_]", "_"):gsub("^%.+", ""):gsub("%.+$", "")
end

-- File handler functions

-- Upload file
function fileHandler.uploadFile(filename, content, contentType)
    log("Uploading file: " .. filename)
    
    -- Validate filename
    if not filename or filename == "" then
        return createResponse(400, {
            error = "MISSING_FILENAME",
            message = "Filename is required"
        })
    end
    
    -- Sanitize filename
    filename = sanitizeFilename(filename)
    
    -- Validate file extension
    if not validateFileExtension(filename) then
        return createResponse(400, {
            error = "INVALID_FILE_EXTENSION",
            message = "Only .java files are allowed"
        })
    end
    
    -- Validate file size
    if not validateFileSize(content) then
        return createResponse(413, {
            error = "FILE_TOO_LARGE",
            message = "File exceeds maximum size of " .. config.maxFileSize .. " bytes"
        })
    end
    
    -- Check upload directory file count
    local files = listFiles(config.uploadDir)
    if #files >= config.maxFiles then
        return createResponse(507, {
            error = "STORAGE_FULL",
            message = "Upload directory is full. Maximum " .. config.maxFiles .. " files allowed."
        })
    end
    
    -- Save file
    local filepath = config.uploadDir .. filename
    local saveSuccess, saveError = saveFile(filepath, content)
    
    if not saveSuccess then
        log("Failed to save file: " .. tostring(saveError))
        return createResponse(500, {
            error = "SAVE_ERROR",
            message = "Failed to save file: " .. tostring(saveError)
        })
    end
    
    log("File uploaded successfully: " .. filename)
    
    return createResponse(200, {
        success = true,
        filename = filename,
        size = #content,
        uploadPath = filepath,
        message = "File uploaded successfully"
    })
end

-- Download file
function fileHandler.downloadFile(filename)
    log("Downloading file: " .. filename)
    
    -- Validate filename
    if not filename or filename == "" then
        return createResponse(400, {
            error = "MISSING_FILENAME",
            message = "Filename is required"
        })
    end
    
    -- Sanitize filename
    filename = sanitizeFilename(filename)
    
    -- Check if file exists
    local filepath = config.downloadDir .. filename
    if not fileExists(filepath) then
        return createResponse(404, {
            error = "FILE_NOT_FOUND",
            message = "File not found: " .. filename
        })
    end
    
    -- Read file
    local readSuccess, content = readFile(filepath)
    if not readSuccess then
        log("Failed to read file: " .. filename)
        return createResponse(500, {
            error = "READ_ERROR",
            message = "Failed to read file: " .. filename
        })
    end
    
    log("File downloaded successfully: " .. filename)
    
    return createResponse(200, content, {
        ["Content-Type"] = "application/octet-stream",
        ["Content-Disposition"] = "attachment; filename=\"" .. filename .. "\"",
        ["Content-Length"] = tostring(#content)
    })
end

-- List uploaded files
function fileHandler.listUploadedFiles()
    local files = listFiles(config.uploadDir)
    local fileList = {}
    
    for _, filepath in ipairs(files) do
        local filename = filepath:match("([^/]+)$")
        if filename and filename ~= ".gitkeep" then
            local fullPath = config.uploadDir .. filename
            local readSuccess, content = readFile(fullPath)
            if readSuccess then
                table.insert(fileList, {
                    filename = filename,
                    size = #content,
                    uploadTime = os.time() -- Placeholder
                })
            end
        end
    end
    
    return createResponse(200, {
        files = fileList,
        count = #fileList,
        maxFiles = config.maxFiles
    })
end

-- List downloaded files
function fileHandler.listDownloadedFiles()
    local files = listFiles(config.downloadDir)
    local fileList = {}
    
    for _, filepath in ipairs(files) do
        local filename = filepath:match("([^/]+)$")
        if filename and filename ~= ".gitkeep" then
            local fullPath = config.downloadDir .. filename
            local readSuccess, content = readFile(fullPath)
            if readSuccess then
                table.insert(fileList, {
                    filename = filename,
                    size = #content,
                    downloadTime = os.time() -- Placeholder
                })
            end
        end
    end
    
    return createResponse(200, {
        files = fileList,
        count = #fileList
    })
end

-- Delete uploaded file
function fileHandler.deleteUploadedFile(filename)
    log("Deleting uploaded file: " .. filename)
    
    -- Validate filename
    if not filename or filename == "" then
        return createResponse(400, {
            error = "MISSING_FILENAME",
            message = "Filename is required"
        })
    end
    
    -- Sanitize filename
    filename = sanitizeFilename(filename)
    
    -- Check if file exists
    local filepath = config.uploadDir .. filename
    if not fileExists(filepath) then
        return createResponse(404, {
            error = "FILE_NOT_FOUND",
            message = "File not found: " .. filename
        })
    end
    
    -- Delete file
    local deleteSuccess, deleteError = deleteFile(filepath)
    if not deleteSuccess then
        log("Failed to delete file: " .. tostring(deleteError))
        return createResponse(500, {
            error = "DELETE_ERROR",
            message = "Failed to delete file: " .. tostring(deleteError)
        })
    end
    
    log("File deleted successfully: " .. filename)
    
    return createResponse(200, {
        success = true,
        message = "File deleted successfully"
    })
end

-- Delete downloaded file
function fileHandler.deleteDownloadedFile(filename)
    log("Deleting downloaded file: " .. filename)
    
    -- Validate filename
    if not filename or filename == "" then
        return createResponse(400, {
            error = "MISSING_FILENAME",
            message = "Filename is required"
        })
    end
    
    -- Sanitize filename
    filename = sanitizeFilename(filename)
    
    -- Check if file exists
    local filepath = config.downloadDir .. filename
    if not fileExists(filepath) then
        return createResponse(404, {
            error = "FILE_NOT_FOUND",
            message = "File not found: " .. filename
        })
    end
    
    -- Delete file
    local deleteSuccess, deleteError = deleteFile(filepath)
    if not deleteSuccess then
        log("Failed to delete file: " .. tostring(deleteError))
        return createResponse(500, {
            error = "DELETE_ERROR",
            message = "Failed to delete file: " .. tostring(deleteError)
        })
    end
    
    log("File deleted successfully: " .. filename)
    
    return createResponse(200, {
        success = true,
        message = "File deleted successfully"
    })
end

-- Clean up old files
function fileHandler.cleanupOldFiles(maxAge)
    maxAge = maxAge or 3600 -- 1 hour default
    local currentTime = os.time()
    local cleanedCount = 0
    
    -- Clean uploads
    local uploadFiles = listFiles(config.uploadDir)
    for _, filepath in ipairs(uploadFiles) do
        local filename = filepath:match("([^/]+)$")
        if filename and filename ~= ".gitkeep" then
            -- In a real implementation, you'd check file modification time
            -- For now, we'll just clean files older than maxAge
            local fullPath = config.uploadDir .. filename
            pcall(function()
                deleteFile(fullPath)
                cleanedCount = cleanedCount + 1
            end)
        end
    end
    
    -- Clean downloads
    local downloadFiles = listFiles(config.downloadDir)
    for _, filepath in ipairs(downloadFiles) do
        local filename = filepath:match("([^/]+)$")
        if filename and filename ~= ".gitkeep" then
            local fullPath = config.downloadDir .. filename
            pcall(function()
                deleteFile(fullPath)
                cleanedCount = cleanedCount + 1
            end)
        end
    end
    
    log("Cleaned up " .. cleanedCount .. " old files")
    
    return createResponse(200, {
        success = true,
        cleanedCount = cleanedCount,
        message = "Cleanup completed"
    })
end

-- Get file info
function fileHandler.getFileInfo(filename, directory)
    directory = directory or "uploads"
    local dir = directory == "downloads" and config.downloadDir or config.uploadDir
    local filepath = dir .. filename
    
    if not fileExists(filepath) then
        return createResponse(404, {
            error = "FILE_NOT_FOUND",
            message = "File not found: " .. filename
        })
    end
    
    local readSuccess, content = readFile(filepath)
    if not readSuccess then
        return createResponse(500, {
            error = "READ_ERROR",
            message = "Failed to read file: " .. filename
        })
    end
    
    return createResponse(200, {
        filename = filename,
        size = #content,
        directory = directory,
        path = filepath,
        exists = true
    })
end

-- Get configuration
function fileHandler.getConfig()
    return createResponse(200, {
        config = config,
        uploadDir = config.uploadDir,
        downloadDir = config.downloadDir,
        maxFileSize = config.maxFileSize,
        allowedExtensions = config.allowedExtensions,
        maxFiles = config.maxFiles
    })
end

-- Update configuration
function fileHandler.updateConfig(newConfig)
    for key, value in pairs(newConfig) do
        if config[key] ~= nil then
            config[key] = value
        end
    end
    
    log("Configuration updated")
    
    return createResponse(200, {
        success = true,
        config = config,
        message = "Configuration updated successfully"
    })
end

-- Initialize file handler
function fileHandler.init()
    log("Initializing file handler...")
    
    -- Create directories if they don't exist
    saveFile(config.uploadDir .. ".gitkeep", "")
    saveFile(config.downloadDir .. ".gitkeep", "")
    
    log("File handler initialized successfully")
    log("Upload directory: " .. config.uploadDir)
    log("Download directory: " .. config.downloadDir)
    log("Max file size: " .. config.maxFileSize .. " bytes")
    log("Max files: " .. config.maxFiles)
    
    return true
end

return fileHandler
