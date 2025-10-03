--[[
    Java to Lua Transpiler API Endpoints
    RESTful API endpoints for the transpiler server
]]

local HttpService = game:GetService("HttpService")

-- API version and metadata
local API = {
    version = "1.0.0",
    basePath = "/api/v1",
    endpoints = {}
}

-- Utility functions
local function createResponse(status, data, headers)
    headers = headers or {}
    headers["Content-Type"] = "application/json"
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
    headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    
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

-- Load transpiler
local java = require("newjavatolua")

-- API Endpoints

-- GET /api/v1/info - API information
API.endpoints["GET /api/v1/info"] = function(request)
    local info = {
        name = "Java to Lua Transpiler API",
        version = API.version,
        description = "RESTful API for converting Java code to Lua",
        endpoints = {
            "GET /api/v1/info - API information",
            "POST /api/v1/convert - Convert Java code to Lua",
            "POST /api/v1/convert-file - Convert Java file to Lua",
            "GET /api/v1/examples - List example files",
            "GET /api/v1/examples/{id} - Get specific example",
            "GET /api/v1/capabilities - Get transpiler capabilities",
            "GET /api/v1/config - Get server configuration",
            "POST /api/v1/config - Update server configuration"
        },
        features = {
            "Java to Lua transpilation",
            "File conversion",
            "Example code library",
            "Configuration management",
            "Health monitoring"
        }
    }
    
    return createResponse(200, info)
end

-- POST /api/v1/convert - Convert Java code to Lua
API.endpoints["POST /api/v1/convert"] = function(request)
    local body = request.body or "{}"
    local success, jsonData = parseJSON(body)
    
    if not success then
        return createResponse(400, {
            error = "INVALID_JSON",
            message = "Request body must be valid JSON",
            code = 400
        })
    end
    
    local javaCode = jsonData.javaCode
    local debug = jsonData.debug or false
    local options = jsonData.options or {}
    
    -- Validation
    if not javaCode or type(javaCode) ~= "string" then
        return createResponse(400, {
            error = "MISSING_JAVA_CODE",
            message = "Field 'javaCode' is required and must be a string",
            code = 400
        })
    end
    
    if #javaCode == 0 then
        return createResponse(400, {
            error = "EMPTY_JAVA_CODE",
            message = "Java code cannot be empty",
            code = 400
        })
    end
    
    if #javaCode > 1024 * 1024 then -- 1MB limit
        return createResponse(413, {
            error = "FILE_TOO_LARGE",
            message = "Java code exceeds maximum size of 1MB",
            code = 413
        })
    end
    
    -- Apply options if provided
    if options.targetVersion then
        java.setConfig({targetVersion = options.targetVersion})
    end
    
    if options.generateTypes ~= nil then
        java.setConfig({generateTypes = options.generateTypes})
    end
    
    -- Perform conversion
    local startTime = os.clock()
    local luaCode = java.convert(javaCode, debug)
    local endTime = os.clock()
    
    local response = {
        success = true,
        result = {
            javaCode = javaCode,
            luaCode = luaCode,
            debug = debug,
            options = options
        },
        metadata = {
            conversionTime = endTime - startTime,
            javaCodeLength = #javaCode,
            luaCodeLength = #luaCode,
            timestamp = os.time(),
            version = API.version
        }
    }
    
    return createResponse(200, response)
end

-- POST /api/v1/convert-file - Convert Java file to Lua file
API.endpoints["POST /api/v1/convert-file"] = function(request)
    local body = request.body or "{}"
    local success, jsonData = parseJSON(body)
    
    if not success then
        return createResponse(400, {
            error = "INVALID_JSON",
            message = "Request body must be valid JSON",
            code = 400
        })
    end
    
    local filename = jsonData.filename
    local debug = jsonData.debug or false
    local options = jsonData.options or {}
    
    -- Validation
    if not filename or type(filename) ~= "string" then
        return createResponse(400, {
            error = "MISSING_FILENAME",
            message = "Field 'filename' is required and must be a string",
            code = 400
        })
    end
    
    -- Validate file extension
    if not filename:match("%.java$") then
        return createResponse(400, {
            error = "INVALID_FILE_EXTENSION",
            message = "Only .java files are supported",
            code = 400
        })
    end
    
    -- Check if file exists
    local uploadPath = "server/uploads/" .. filename
    local fileExists = pcall(function()
        return isfile(uploadPath)
    end)
    
    if not fileExists then
        return createResponse(404, {
            error = "FILE_NOT_FOUND",
            message = "File '" .. filename .. "' not found in uploads directory",
            code = 404
        })
    end
    
    -- Read file
    local readSuccess, javaContent = pcall(function()
        return readfile(uploadPath)
    end)
    
    if not readSuccess then
        return createResponse(500, {
            error = "FILE_READ_ERROR",
            message = "Could not read file: " .. filename,
            code = 500
        })
    end
    
    -- Apply options
    if options.targetVersion then
        java.setConfig({targetVersion = options.targetVersion})
    end
    
    -- Convert to Lua
    local startTime = os.clock()
    local luaCode = java.convert(javaContent, debug)
    local endTime = os.clock()
    
    -- Save Lua file
    local luaFilename = filename:gsub("%.java$", ".lua")
    local downloadPath = "server/downloads/" .. luaFilename
    local saveSuccess, saveError = pcall(function()
        writefile(downloadPath, luaCode)
    end)
    
    if not saveSuccess then
        return createResponse(500, {
            error = "FILE_SAVE_ERROR",
            message = "Could not save converted file: " .. tostring(saveError),
            code = 500
        })
    end
    
    local response = {
        success = true,
        result = {
            originalFile = filename,
            convertedFile = luaFilename,
            downloadUrl = "/api/v1/download/" .. luaFilename,
            debug = debug,
            options = options
        },
        metadata = {
            conversionTime = endTime - startTime,
            javaCodeLength = #javaContent,
            luaCodeLength = #luaCode,
            timestamp = os.time(),
            version = API.version
        }
    }
    
    return createResponse(200, response)
end

-- GET /api/v1/examples - List example files
API.endpoints["GET /api/v1/examples"] = function(request)
    local examples = {
        {
            id = "calculator",
            name = "Calculator.java",
            description = "Simple calculator class with basic arithmetic operations",
            category = "basic",
            difficulty = "beginner",
            size = "~1.2KB",
            features = {"classes", "methods", "constructors", "arithmetic"}
        },
        {
            id = "person",
            name = "Person.java",
            description = "Person class with getters, setters, and validation",
            category = "oop",
            difficulty = "intermediate",
            size = "~1.5KB",
            features = {"classes", "getters", "setters", "validation", "inheritance"}
        },
        {
            id = "control-flow",
            name = "ControlFlowDemo.java",
            description = "Demonstrates various control flow structures",
            category = "control-flow",
            difficulty = "beginner",
            size = "~2.1KB",
            features = {"if-else", "for-loops", "while-loops", "switch-statements"}
        }
    }
    
    return createResponse(200, {
        examples = examples,
        count = #examples,
        categories = {"basic", "oop", "control-flow", "advanced"}
    })
end

-- GET /api/v1/examples/{id} - Get specific example
API.endpoints["GET /api/v1/examples/"] = function(request)
    local exampleId = request.path:match("/api/v1/examples/(.+)")
    
    if not exampleId then
        return createResponse(400, {
            error = "MISSING_EXAMPLE_ID",
            message = "Example ID is required in the URL path",
            code = 400
        })
    end
    
    local filename = exampleId .. ".java"
    local examplePath = "server/examples/" .. filename
    
    local fileExists = pcall(function()
        return isfile(examplePath)
    end)
    
    if not fileExists then
        return createResponse(404, {
            error = "EXAMPLE_NOT_FOUND",
            message = "Example '" .. exampleId .. "' not found",
            code = 404
        })
    end
    
    local readSuccess, content = pcall(function()
        return readfile(examplePath)
    end)
    
    if not readSuccess then
        return createResponse(500, {
            error = "FILE_READ_ERROR",
            message = "Could not read example file: " .. filename,
            code = 500
        })
    end
    
    -- Get example metadata
    local metadata = {
        calculator = {
            name = "Calculator.java",
            description = "Simple calculator class with basic arithmetic operations",
            category = "basic",
            difficulty = "beginner"
        },
        person = {
            name = "Person.java",
            description = "Person class with getters, setters, and validation",
            category = "oop",
            difficulty = "intermediate"
        },
        ["control-flow"] = {
            name = "ControlFlowDemo.java",
            description = "Demonstrates various control flow structures",
            category = "control-flow",
            difficulty = "beginner"
        }
    }
    
    local exampleMetadata = metadata[exampleId] or {
        name = filename,
        description = "Example Java file",
        category = "unknown",
        difficulty = "unknown"
    }
    
    return createResponse(200, {
        id = exampleId,
        filename = filename,
        content = content,
        metadata = exampleMetadata,
        size = #content
    })
end

-- GET /api/v1/capabilities - Get transpiler capabilities
API.endpoints["GET /api/v1/capabilities"] = function(request)
    local capabilities = java.getCapabilities()
    
    return createResponse(200, {
        capabilities = capabilities,
        supportedFeatures = {
            "Java classes and inheritance",
            "Method declarations and constructors",
            "Control flow structures (if, for, while)",
            "Type system conversion",
            "Operator mapping",
            "Comment preservation",
            "Import/package handling"
        },
        limitations = {
            "Advanced Java features (generics, annotations)",
            "Complex exception handling",
            "Reflection and dynamic features",
            "Native method calls"
        }
    })
end

-- GET /api/v1/config - Get server configuration
API.endpoints["GET /api/v1/config"] = function(request)
    local config = java.getConfig()
    
    return createResponse(200, {
        config = config,
        availableOptions = {
            debug = "boolean - Enable debug output",
            preserveComments = "boolean - Keep comments in output",
            generateTypes = "boolean - Generate Luau type annotations",
            optimizeCode = "boolean - Optimize generated code",
            targetVersion = "string - Target Lua version (Lua51 or Luau)"
        }
    })
end

-- POST /api/v1/config - Update server configuration
API.endpoints["POST /api/v1/config"] = function(request)
    local body = request.body or "{}"
    local success, jsonData = parseJSON(body)
    
    if not success then
        return createResponse(400, {
            error = "INVALID_JSON",
            message = "Request body must be valid JSON",
            code = 400
        })
    end
    
    local newConfig = jsonData.config or {}
    
    -- Validate configuration options
    local validOptions = {
        debug = "boolean",
        preserveComments = "boolean",
        generateTypes = "boolean",
        optimizeCode = "boolean",
        targetVersion = "string"
    }
    
    for key, value in pairs(newConfig) do
        if validOptions[key] then
            local expectedType = validOptions[key]
            if expectedType == "boolean" and type(value) ~= "boolean" then
                return createResponse(400, {
                    error = "INVALID_CONFIG_VALUE",
                    message = "Config option '" .. key .. "' must be a boolean",
                    code = 400
                })
            elseif expectedType == "string" and type(value) ~= "string" then
                return createResponse(400, {
                    error = "INVALID_CONFIG_VALUE",
                    message = "Config option '" .. key .. "' must be a string",
                    code = 400
                })
            end
        else
            return createResponse(400, {
                error = "INVALID_CONFIG_OPTION",
                message = "Unknown config option: " .. key,
                code = 400
            })
        end
    end
    
    -- Apply configuration
    java.setConfig(newConfig)
    
    local updatedConfig = java.getConfig()
    
    return createResponse(200, {
        success = true,
        message = "Configuration updated successfully",
        config = updatedConfig
    })
end

-- GET /api/v1/download/{filename} - Download converted file
API.endpoints["GET /api/v1/download/"] = function(request)
    local filename = request.path:match("/api/v1/download/(.+)")
    
    if not filename then
        return createResponse(400, {
            error = "MISSING_FILENAME",
            message = "Filename is required in the URL path",
            code = 400
        })
    end
    
    local downloadPath = "server/downloads/" .. filename
    
    local fileExists = pcall(function()
        return isfile(downloadPath)
    end)
    
    if not fileExists then
        return createResponse(404, {
            error = "FILE_NOT_FOUND",
            message = "Download file '" .. filename .. "' not found",
            code = 404
        })
    end
    
    local readSuccess, content = pcall(function()
        return readfile(downloadPath)
    end)
    
    if not readSuccess then
        return createResponse(500, {
            error = "FILE_READ_ERROR",
            message = "Could not read download file: " .. filename,
            code = 500
        })
    end
    
    return createResponse(200, content, {
        ["Content-Type"] = "application/octet-stream",
        ["Content-Disposition"] = "attachment; filename=\"" .. filename .. "\""
    })
end

-- Export API
return API
