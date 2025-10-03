--[[
    Java to Lua Transpiler Server - Startup Script
    Simple script to start the server with default settings
]]

print("🚀 Starting Java to Lua Transpiler Server...")
print("=============================================")
print("")

-- Load the launcher
local launcher = require("launcher")

-- Set default configuration
launcher.config.port = 8080
launcher.config.host = "localhost"
launcher.config.debug = true
launcher.config.autoStart = true

-- Start the server
local success = launcher.main()

if success then
    print("✅ Server started successfully!")
    print("🌐 Web Interface: http://localhost:8080/web")
    print("📚 API Endpoints: http://localhost:8080/api/v1")
    print("🛑 Press Ctrl+C to stop the server")
else
    print("❌ Failed to start server")
end
