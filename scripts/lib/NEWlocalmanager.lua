-- well well well, a rewrite of the whole fucking library. that will surly will go well right???

local manager = {}

local _debug

function _debugtoggle(_Debug)
    if _Debug == true then
        _debug = true
    elseif _Debug == false then
        _debug = false
    else
        return "invaild act"
    end
end

function manager.nodefecth(debugMode)
    -- Enhanced system diagnostics with better formatting and comprehensive testing
    local debug = debugMode or false
    
    -- Initialize debug mode
    if debugMode ~= nil then
        _debugtoggle(debugMode)
    end
    
    -- Enhanced ASCII art header
    print("╔══════════════════════════════════════════════════════════════════════════════╗")
    print("║                    🚀 NEW Local Manager Library v2.0 🚀                    ║")
    print("║                      Advanced System Diagnostics                            ║")
    print("╚══════════════════════════════════════════════════════════════════════════════╝")
    print()
    
    local systemInfo = {
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        tests = {},
        summary = {
            total = 0,
            passed = 0,
            failed = 0,
            warnings = 0
        }
    }
    
    -- Helper function to add test results
    local function addTest(category, name, success, details, warning)
        if not systemInfo.tests[category] then
            systemInfo.tests[category] = {}
        end
        
        local status = success and "✅" or "❌"
        if warning then
            status = "⚠️"
            systemInfo.summary.warnings = systemInfo.summary.warnings + 1
        end
        
        systemInfo.tests[category][name] = {
            success = success,
            details = details,
            warning = warning
        }
        
        systemInfo.summary.total = systemInfo.summary.total + 1
        if success then
            systemInfo.summary.passed = systemInfo.summary.passed + 1
        else
            systemInfo.summary.failed = systemInfo.summary.failed + 1
        end
        
        local output = status .. " " .. name
        if details then
            output = output .. ": " .. details
        end
        print(output)
    end
    
    -- Test 1: Enhanced Executor Detection
    print("🔍 Testing Executor Environment...")
    local executorSuccess, executorName, executorVersion = pcall(function()
        return identifyexecutor()
    end)
    
    if executorSuccess and executorName then
        addTest("executor", "Detection", true, executorName .. " v" .. (executorVersion or "Unknown"))
        addTest("executor", "Version", true, executorVersion or "Unknown")
        
        -- Test executor-specific features
        local features = {
            {name = "hookfunction", func = function() return hookfunction ~= nil end},
            {name = "getgenv", func = function() return getgenv ~= nil end},
            {name = "getrenv", func = function() return getrenv ~= nil end},
            {name = "loadstring", func = function() return loadstring ~= nil end},
            {name = "getcustomasset", func = function() return getcustomasset ~= nil end},
            {name = "writecustomasset", func = function() return writecustomasset ~= nil end}
        }
        
        for _, feature in ipairs(features) do
            local success = pcall(feature.func)
            addTest("executor", feature.name, success, success and "Available" or "Not Available")
        end
    else
        addTest("executor", "Detection", false, "Not detected or not available")
    end
    print()
    
    -- Test 2: Enhanced Game Environment
    print("🎮 Testing Game Environment...")
    local gameSuccess = pcall(function()
        return game ~= nil
    end)
    
    if gameSuccess and game then
        addTest("game", "Environment", true, "Available")
        addTest("game", "PlaceId", true, game.PlaceId or "Unknown")
        addTest("game", "GameId", true, game.GameId or "Unknown")
        
        -- Test game services
        local services = {
            {name = "Workspace", service = game.Workspace},
            {name = "Players", service = game.Players},
            {name = "Lighting", service = game.Lighting},
            {name = "ReplicatedStorage", service = game.ReplicatedStorage},
            {name = "ServerStorage", service = game.ServerStorage}
        }
        
        for _, service in ipairs(services) do
            local success = service.service ~= nil
            addTest("game", service.name, success, success and "Available" or "Not Available")
        end
    else
        addTest("game", "Environment", false, "Not available")
    end
    print()
    
    -- Test 3: Enhanced Filesystem Operations
    print("📁 Testing Filesystem Capabilities...")
    local fsTests = {
        {name = "listfiles", func = function() return listfiles(".") end, critical = true},
        {name = "isfile", func = function() return isfile("test.txt") end, critical = true},
        {name = "isfolder", func = function() return isfolder("test") end, critical = true},
        {name = "readfile", func = function() 
            local success = pcall(function() readfile("nonexistent.txt") end)
            return success -- Should fail but function exists
        end, critical = true},
        {name = "writefile", func = function()
            writefile("nodefecth_test.txt", "test")
            return true
        end, critical = true},
        {name = "delfile", func = function()
            pcall(function() delfile("nodefecth_test.txt") end)
            return true
        end, critical = true},
        {name = "appendfile", func = function()
            return appendfile ~= nil
        end, critical = false},
        {name = "makefolder", func = function()
            return makefolder ~= nil
        end, critical = false}
    }
    
    for _, test in ipairs(fsTests) do
        local success = pcall(test.func)
        local details = success and "Available" or "Not Available"
        if not test.critical then
            details = details .. " (Optional)"
        end
        addTest("filesystem", test.name, success, details, not test.critical and not success)
    end
    print()
    
    -- Test 4: Enhanced HTTP/Network Operations
    print("🌐 Testing Network Capabilities...")
    local httpTests = {
        {name = "request", func = function()
            request({Url = "https://httpbin.org/get", Method = "GET"})
            return true
        end, critical = true},
        {name = "game:HttpGet", func = function()
            if game and game.HttpGet then
                game:HttpGet("https://httpbin.org/get")
                return true
            end
            return false
        end, critical = false},
        {name = "game:HttpPost", func = function()
            if game and game.HttpPost then
                return true
            end
            return false
        end, critical = false}
    }
    
    for _, test in ipairs(httpTests) do
        local success = pcall(test.func)
        local details = success and "Available" or "Not Available"
        if not test.critical then
            details = details .. " (Optional)"
        end
        addTest("network", test.name, success, details, not test.critical and not success)
    end
    print()
    
    -- Test 5: Enhanced GUI/Drawing Operations
    print("🎨 Testing GUI/Drawing Capabilities...")
    local guiTests = {
        {name = "Drawing.new", func = function()
            local circle = Drawing.new("Circle")
            circle:Destroy()
            return true
        end, critical = true},
        {name = "Instance.new", func = function()
            local frame = Instance.new("Frame")
            frame:Destroy()
            return true
        end, critical = true},
        {name = "ScreenGui Creation", func = function()
            if game and game.Players and game.Players.LocalPlayer then
                local screenGui = Instance.new("ScreenGui")
                screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                screenGui:Destroy()
                return true
            end
            return false
        end, critical = false}
    }
    
    for _, test in ipairs(guiTests) do
        local success = pcall(test.func)
        local details = success and "Available" or "Not Available"
        if not test.critical then
            details = details .. " (Optional)"
        end
        addTest("gui", test.name, success, details, not test.critical and not success)
    end
    print()
    
    -- Test 6: Memory and Performance Analysis
    print("🧠 Testing Memory/Performance...")
    local memorySuccess, gc = pcall(function() return getgc() end)
    local regSuccess, reg = pcall(function() return getreg() end)
    
    addTest("memory", "getgc", memorySuccess, memorySuccess and ("Available (" .. #gc .. " objects)") or "Not Available")
    addTest("memory", "getreg", regSuccess, regSuccess and ("Available (" .. #reg .. " objects)") or "Not Available")
    
    -- Test memory usage
    if memorySuccess then
        local memoryInfo = {
            totalObjects = #gc,
            memoryUsage = "Unknown", -- Would need additional APIs
            performance = "Good" -- Placeholder
        }
        addTest("memory", "Usage", true, "Total Objects: " .. memoryInfo.totalObjects)
    end
    print()
    
    -- Test 7: Security and Permissions
    print("🔒 Testing Security Features...")
    local securityTests = {
        {name = "getfenv", func = function() return getfenv ~= nil end},
        {name = "setfenv", func = function() return setfenv ~= nil end},
        {name = "getmetatable", func = function() return getmetatable ~= nil end},
        {name = "setmetatable", func = function() return setmetatable ~= nil end},
        {name = "rawget", func = function() return rawget ~= nil end},
        {name = "rawset", func = function() return rawset ~= nil end}
    }
    
    for _, test in ipairs(securityTests) do
        local success = pcall(test.func)
        addTest("security", test.name, success, success and "Available" or "Not Available")
    end
    print()
    
    -- Enhanced System Summary
    print("╔══════════════════════════════════════════════════════════════════════════════╗")
    print("║                          📊 System Summary Report                           ║")
    print("╚══════════════════════════════════════════════════════════════════════════════╝")
    
    local successRate = systemInfo.summary.total > 0 and 
        math.floor((systemInfo.summary.passed / systemInfo.summary.total) * 100) or 0
    
    print("📈 Overall Statistics:")
    print("   Total Tests: " .. systemInfo.summary.total)
    print("   Passed: " .. systemInfo.summary.passed .. " ✅")
    print("   Failed: " .. systemInfo.summary.failed .. " ❌")
    print("   Warnings: " .. systemInfo.summary.warnings .. " ⚠️")
    print("   Success Rate: " .. successRate .. "%")
    print()
    
    -- Category breakdown
    print("📋 Category Breakdown:")
    for category, tests in pairs(systemInfo.tests) do
        local categoryPassed = 0
        local categoryTotal = 0
        for _, test in pairs(tests) do
            categoryTotal = categoryTotal + 1
            if test.success then
                categoryPassed = categoryPassed + 1
            end
        end
        local categoryRate = categoryTotal > 0 and math.floor((categoryPassed / categoryTotal) * 100) or 0
        print("   " .. category:upper() .. ": " .. categoryPassed .. "/" .. categoryTotal .. " (" .. categoryRate .. "%)")
    end
    print()
    
    -- Performance recommendations
    print("💡 Performance Recommendations:")
    if successRate >= 90 then
        print("   🟢 Excellent! Your environment is fully optimized.")
    elseif successRate >= 75 then
        print("   🟡 Good! Minor optimizations possible.")
    elseif successRate >= 50 then
        print("   🟠 Fair! Consider updating your executor or environment.")
    else
        print("   🔴 Poor! Significant issues detected. Update required.")
    end
    
    if systemInfo.summary.warnings > 0 then
        print("   ⚠️ " .. systemInfo.summary.warnings .. " optional features unavailable.")
    end
    print()
    
    -- System information
    print("ℹ️  System Information:")
    print("   Timestamp: " .. systemInfo.timestamp)
    print("   Library Version: 2.0")
    print("   Debug Mode: " .. (debug and "Enabled" or "Disabled"))
    print()
    
    print("╔══════════════════════════════════════════════════════════════════════════════╗")
    print("║                    🚀 NEW Local Manager Library v2.0 🚀                    ║")
    print("║                      Diagnostics Complete - Ready to Use!                  ║")
    print("╚══════════════════════════════════════════════════════════════════════════════╝")
    
    return systemInfo
end
return manager
