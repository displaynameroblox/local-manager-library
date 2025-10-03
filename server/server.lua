--[[
    Java to Lua Transpiler Server
    A lightweight HTTP server that provides Java to Lua transpilation services
    No npm required - pure Lua implementation using Roblox HTTP services
]]

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Load the transpiler
local java = require("newjavatolua")

-- Server configuration
local config = {
    port = 8080,
    host = "localhost",
    debug = true,
    maxFileSize = 1024 * 1024, -- 1MB max file size
    allowedExtensions = {".java"},
    corsEnabled = true
}

-- Server state
local server = {
    running = false,
    requests = 0,
    conversions = 0,
    startTime = 0
}

-- Request handlers
local handlers = {}

-- Utility functions
local function log(message)
    if config.debug then
        print("[Java2Lua Server] " .. message)
    end
end

local function createResponse(status, data, headers)
    headers = headers or {}
    if config.corsEnabled then
        headers["Access-Control-Allow-Origin"] = "*"
        headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
        headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    end
    
    return {
        status = status,
        data = data,
        headers = headers
    }
end

local function parseJSON(jsonString)
    local success, result = pcall(function()
        return HttpService:JSONDecode(jsonString)
    end)
    return success, result
end

local function toJSON(data)
    local success, result = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    return success, result
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

-- API Handlers

-- GET / - Server info
handlers["GET /"] = function(request)
    local serverInfo = {
        name = "Java to Lua Transpiler Server",
        version = "1.0.0",
        status = "running",
        uptime = os.time() - server.startTime,
        requests = server.requests,
        conversions = server.conversions,
        endpoints = {
            "GET / - Server information",
            "POST /convert - Convert Java to Lua",
            "POST /convert-file - Convert Java file to Lua",
            "GET /examples - List example files",
            "GET /examples/{filename} - Get example file",
            "GET /health - Health check",
            "GET /stats - Server statistics"
        }
    }
    
    return createResponse(200, serverInfo)
end

-- POST /convert - Convert Java code to Lua
handlers["POST /convert"] = function(request)
    local body = request.body or ""
    local success, jsonData = parseJSON(body)
    
    if not success then
        return createResponse(400, {
            error = "Invalid JSON in request body",
            message = "Please provide valid JSON with 'javaCode' field"
        })
    end
    
    local javaCode = jsonData.javaCode
    local debug = jsonData.debug or false
    
    if not javaCode or type(javaCode) ~= "string" then
        return createResponse(400, {
            error = "Missing or invalid javaCode",
            message = "Please provide 'javaCode' field as a string"
        })
    end
    
    if #javaCode > config.maxFileSize then
        return createResponse(413, {
            error = "File too large",
            message = "Java code exceeds maximum size of " .. config.maxFileSize .. " bytes"
        })
    end
    
    log("Converting Java code (length: " .. #javaCode .. ")")
    
    local luaCode = java.convert(javaCode, debug)
    server.conversions = server.conversions + 1
    
    local response = {
        success = true,
        javaCode = javaCode,
        luaCode = luaCode,
        debug = debug,
        timestamp = os.time()
    }
    
    log("Conversion completed successfully")
    return createResponse(200, response)
end

-- POST /convert-file - Convert Java file to Lua file
handlers["POST /convert-file"] = function(request)
    local body = request.body or ""
    local success, jsonData = parseJSON(body)
    
    if not success then
        return createResponse(400, {
            error = "Invalid JSON in request body",
            message = "Please provide valid JSON with 'filename' field"
        })
    end
    
    local filename = jsonData.filename
    local debug = jsonData.debug or false
    
    if not filename or type(filename) ~= "string" then
        return createResponse(400, {
            error = "Missing or invalid filename",
            message = "Please provide 'filename' field as a string"
        })
    end
    
    -- Validate file extension
    local hasValidExtension = false
    for _, ext in ipairs(config.allowedExtensions) do
        if filename:match(ext .. "$") then
            hasValidExtension = true
            break
        end
    end
    
    if not hasValidExtension then
        return createResponse(400, {
            error = "Invalid file extension",
            message = "Only .java files are supported"
        })
    end
    
    -- Check if file exists
    local uploadPath = "server/uploads/" .. filename
    if not fileExists(uploadPath) then
        return createResponse(404, {
            error = "File not found",
            message = "File '" .. filename .. "' not found in uploads directory"
        })
    end
    
    log("Converting file: " .. filename)
    
    -- Read Java file
    local readSuccess, javaContent = readFile(uploadPath)
    if not readSuccess then
        return createResponse(500, {
            error = "Failed to read file",
            message = "Could not read file: " .. filename
        })
    end
    
    -- Convert to Lua
    local luaCode = java.convert(javaContent, debug)
    server.conversions = server.conversions + 1
    
    -- Save Lua file
    local luaFilename = filename:gsub("%.java$", ".lua")
    local downloadPath = "server/downloads/" .. luaFilename
    local saveSuccess, saveError = saveFile(downloadPath, luaCode)
    
    if not saveSuccess then
        return createResponse(500, {
            error = "Failed to save Lua file",
            message = "Could not save converted file: " .. tostring(saveError)
        })
    end
    
    local response = {
        success = true,
        originalFile = filename,
        convertedFile = luaFilename,
        downloadUrl = "/download/" .. luaFilename,
        debug = debug,
        timestamp = os.time()
    }
    
    log("File conversion completed: " .. filename .. " -> " .. luaFilename)
    return createResponse(200, response)
end

-- GET /examples - List example files
handlers["GET /examples"] = function(request)
    local examples = {
        {
            name = "Calculator.java",
            description = "Simple calculator class with basic arithmetic operations",
            size = "~1.2KB"
        },
        {
            name = "Person.java", 
            description = "Person class with getters, setters, and validation",
            size = "~1.5KB"
        },
        {
            name = "ControlFlowDemo.java",
            description = "Demonstrates various control flow structures",
            size = "~2.1KB"
        }
    }
    
    return createResponse(200, {
        examples = examples,
        count = #examples
    })
end

-- GET /examples/{filename} - Get example file content
handlers["GET /examples/"] = function(request)
    local filename = request.path:match("/examples/(.+)")
    
    if not filename then
        return createResponse(400, {
            error = "Missing filename",
            message = "Please specify a filename in the URL path"
        })
    end
    
    local examplePath = "server/examples/" .. filename
    
    if not fileExists(examplePath) then
        return createResponse(404, {
            error = "Example not found",
            message = "Example file '" .. filename .. "' not found"
        })
    end
    
    local readSuccess, content = readFile(examplePath)
    if not readSuccess then
        return createResponse(500, {
            error = "Failed to read example",
            message = "Could not read example file: " .. filename
        })
    end
    
    return createResponse(200, {
        filename = filename,
        content = content,
        size = #content
    })
end

-- GET /download/{filename} - Download converted file
handlers["GET /download/"] = function(request)
    local filename = request.path:match("/download/(.+)")
    
    if not filename then
        return createResponse(400, {
            error = "Missing filename",
            message = "Please specify a filename in the URL path"
        })
    end
    
    local downloadPath = "server/downloads/" .. filename
    
    if not fileExists(downloadPath) then
        return createResponse(404, {
            error = "File not found",
            message = "Download file '" .. filename .. "' not found"
        })
    end
    
    local readSuccess, content = readFile(downloadPath)
    if not readSuccess then
        return createResponse(500, {
            error = "Failed to read file",
            message = "Could not read download file: " .. filename
        })
    end
    
    return createResponse(200, content, {
        ["Content-Type"] = "application/octet-stream",
        ["Content-Disposition"] = "attachment; filename=\"" .. filename .. "\""
    })
end

-- GET /health - Health check
handlers["GET /health"] = function(request)
    return createResponse(200, {
        status = "healthy",
        uptime = os.time() - server.startTime,
        memory = "OK", -- Placeholder for memory check
        disk = "OK"   -- Placeholder for disk check
    })
end

-- GET /stats - Server statistics
handlers["GET /stats"] = function(request)
    local stats = {
        uptime = os.time() - server.startTime,
        totalRequests = server.requests,
        totalConversions = server.conversions,
        conversionRate = server.requests > 0 and (server.conversions / server.requests * 100) or 0,
        serverInfo = {
            version = "1.0.0",
            luaVersion = _VERSION,
            platform = "Roblox"
        },
        config = {
            maxFileSize = config.maxFileSize,
            allowedExtensions = config.allowedExtensions,
            debug = config.debug
        }
    }
    
    return createResponse(200, stats)
end

-- OPTIONS handler for CORS
handlers["OPTIONS"] = function(request)
    return createResponse(200, "", {
        ["Access-Control-Allow-Origin"] = "*",
        ["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS",
        ["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    })
end

-- Main request handler
local function handleRequest(method, path, body, headers)
    server.requests = server.requests + 1
    
    local request = {
        method = method,
        path = path,
        body = body,
        headers = headers or {}
    }
    
    log("Request: " .. method .. " " .. path)
    
    -- Handle CORS preflight
    if method == "OPTIONS" then
        return handlers["OPTIONS"](request)
    end
    
    -- Find handler
    local handler = handlers[method .. " " .. path]
    
    -- Try pattern matching for dynamic routes
    if not handler then
        for pattern, handlerFunc in pairs(handlers) do
            if pattern:match("^" .. method .. " ") then
                local routePattern = pattern:gsub("^" .. method .. " ", "")
                if path:match("^" .. routePattern) then
                    handler = handlerFunc
                    break
                end
            end
        end
    end
    
    if not handler then
        return createResponse(404, {
            error = "Not Found",
            message = "Endpoint " .. method .. " " .. path .. " not found"
        })
    end
    
    local success, response = pcall(handler, request)
    if not success then
        log("Error handling request: " .. tostring(response))
        return createResponse(500, {
            error = "Internal Server Error",
            message = "An error occurred while processing the request"
        })
    end
    
    return response
end

-- Server control functions
function server.start()
    if server.running then
        log("Server is already running")
        return false
    end
    
    server.startTime = os.time()
    server.running = true
    
    log("Starting Java to Lua Transpiler Server...")
    log("Server will be available at: http://" .. config.host .. ":" .. config.port)
    log("Debug mode: " .. (config.debug and "ON" or "OFF"))
    
    -- Create necessary directories
    saveFile("server/uploads/.gitkeep", "")
    saveFile("server/downloads/.gitkeep", "")
    
    log("✅ Server started successfully!")
    log("📚 Available endpoints:")
    log("  GET  / - Server information")
    log("  POST /convert - Convert Java code to Lua")
    log("  POST /convert-file - Convert Java file to Lua")
    log("  GET  /examples - List example files")
    log("  GET  /examples/{filename} - Get example file")
    log("  GET  /download/{filename} - Download converted file")
    log("  GET  /health - Health check")
    log("  GET  /stats - Server statistics")
    
    return true
end

function server.stop()
    if not server.running then
        log("Server is not running")
        return false
    end
    
    server.running = false
    log("🛑 Server stopped")
    return true
end

function server.getStatus()
    return {
        running = server.running,
        uptime = server.running and (os.time() - server.startTime) or 0,
        requests = server.requests,
        conversions = server.conversions
    }
end

function server.getConfig()
    return config
end

function server.setConfig(newConfig)
    for key, value in pairs(newConfig) do
        config[key] = value
    end
    log("Configuration updated")
end

-- Export server functions
server.handleRequest = handleRequest
server.log = log

return server
