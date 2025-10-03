--[[
    Java to Lua Transpiler Server Launcher
    Main entry point for the server application
    No npm required - pure Lua implementation
]]

-- Load required modules
local server = require("server")
local fileHandler = require("file_handler")
local API = require("api.endpoints")

-- Server configuration
local config = {
    port = 8080,
    host = "localhost",
    debug = true,
    autoStart = true,
    webInterface = true,
    apiEnabled = true
}

-- Initialize server
local function initializeServer()
    print("🚀 Java to Lua Transpiler Server")
    print("==================================")
    print("")
    
    -- Initialize file handler
    print("📁 Initializing file handler...")
    local fileHandlerSuccess = fileHandler.init()
    if not fileHandlerSuccess then
        print("❌ Failed to initialize file handler")
        return false
    end
    print("✅ File handler initialized")
    
    -- Initialize server
    print("🌐 Initializing HTTP server...")
    local serverSuccess = server.start()
    if not serverSuccess then
        print("❌ Failed to start server")
        return false
    end
    print("✅ HTTP server initialized")
    
    -- Display server information
    print("")
    print("🎉 Server is running!")
    print("====================")
    print("📍 Server URL: http://" .. config.host .. ":" .. config.port)
    print("🌐 Web Interface: http://" .. config.host .. ":" .. config.port .. "/web")
    print("📚 API Endpoints: http://" .. config.host .. ":" .. config.port .. "/api/v1")
    print("")
    print("📋 Available Endpoints:")
    print("  GET  / - Server information")
    print("  POST /convert - Convert Java code to Lua")
    print("  POST /convert-file - Convert Java file to Lua")
    print("  GET  /examples - List example files")
    print("  GET  /examples/{filename} - Get example file")
    print("  GET  /download/{filename} - Download converted file")
    print("  GET  /health - Health check")
    print("  GET  /stats - Server statistics")
    print("")
    print("🔧 API Endpoints:")
    print("  GET  /api/v1/info - API information")
    print("  POST /api/v1/convert - Convert Java code to Lua")
    print("  POST /api/v1/convert-file - Convert Java file to Lua")
    print("  GET  /api/v1/examples - List example files")
    print("  GET  /api/v1/examples/{id} - Get specific example")
    print("  GET  /api/v1/capabilities - Get transpiler capabilities")
    print("  GET  /api/v1/config - Get server configuration")
    print("  POST /api/v1/config - Update server configuration")
    print("")
    print("💡 Usage Examples:")
    print("  curl -X POST http://localhost:8080/api/v1/convert \\")
    print("    -H 'Content-Type: application/json' \\")
    print("    -d '{\"javaCode\":\"public class Test {}\",\"debug\":true}'")
    print("")
    print("🛑 Press Ctrl+C to stop the server")
    print("")
    
    return true
end

-- Handle server shutdown
local function shutdownServer()
    print("")
    print("🛑 Shutting down server...")
    
    local stopSuccess = server.stop()
    if stopSuccess then
        print("✅ Server stopped successfully")
    else
        print("❌ Error stopping server")
    end
    
    print("👋 Goodbye!")
end

-- Main function
local function main()
    -- Parse command line arguments
    local args = {...}
    
    for i, arg in ipairs(args) do
        if arg == "--port" and args[i + 1] then
            config.port = tonumber(args[i + 1])
        elseif arg == "--host" and args[i + 1] then
            config.host = args[i + 1]
        elseif arg == "--no-debug" then
            config.debug = false
        elseif arg == "--no-web" then
            config.webInterface = false
        elseif arg == "--no-api" then
            config.apiEnabled = false
        elseif arg == "--help" then
            print("Java to Lua Transpiler Server")
            print("Usage: launcher.lua [options]")
            print("")
            print("Options:")
            print("  --port <number>    Set server port (default: 8080)")
            print("  --host <string>    Set server host (default: localhost)")
            print("  --no-debug         Disable debug mode")
            print("  --no-web           Disable web interface")
            print("  --no-api           Disable API endpoints")
            print("  --help             Show this help message")
            print("")
            print("Examples:")
            print("  launcher.lua")
            print("  launcher.lua --port 3000")
            print("  launcher.lua --host 0.0.0.0 --port 8080")
            return
        end
    end
    
    -- Set server configuration
    server.setConfig({
        port = config.port,
        host = config.host,
        debug = config.debug
    })
    
    -- Initialize and start server
    local success = initializeServer()
    if not success then
        print("❌ Failed to start server")
        return
    end
    
    -- Keep server running
    if config.autoStart then
        -- In a real implementation, you'd have an event loop here
        -- For Roblox, we'll just keep the script running
        print("🔄 Server is running... (Press Ctrl+C to stop)")
        
        -- Simulate server running
        while server.getStatus().running do
            wait(1) -- Wait 1 second
        end
    end
end

-- Handle graceful shutdown
local function onShutdown()
    shutdownServer()
end

-- Export functions for external use
local launcher = {
    main = main,
    initializeServer = initializeServer,
    shutdownServer = shutdownServer,
    config = config
}

-- Run main function if this script is executed directly
if script and script.Parent == nil then
    main()
end

return launcher
