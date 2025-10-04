-- Test script for the enhanced HTML to GUI converter
-- This demonstrates the new features and error handling

local newhtml = require(script.Parent.newhtmltogui)

-- Test HTML with various tags and features
local testHTML = [[
<div class="container">
    <h1>Enhanced HTML to GUI Test</h1>
    <p class="description">This demonstrates the new features:</p>
    <ul class="features">
        <li>More HTML tags support</li>
        <li>Advanced CSS properties</li>
        <li>Better error handling</li>
        <li>Layout system</li>
    </ul>
    <button class="primary-button">Click Me!</button>
    <input type="text" placeholder="Enter text here" />
    <img src="rbxasset://textures/ui/GuiImagePlaceholder.png" />
</div>
]]

-- Test CSS with various properties
local testCSS = [[
.container {
    width: 400px;
    height: 300px;
    background-color: #f0f0f0;
    border-radius: 10px;
    padding: 20px;
    display: flex;
    flex-direction: column;
}

h1 {
    color: #333;
    font-size: 24px;
    text-align: center;
    margin: 10px 0;
}

.description {
    color: #666;
    font-size: 16px;
    margin: 10px 0;
}

.features {
    background-color: #fff;
    border-radius: 5px;
    padding: 10px;
    margin: 10px 0;
}

.primary-button {
    background-color: #007bff;
    color: white;
    font-size: 16px;
    border-radius: 5px;
    padding: 10px 20px;
    margin: 10px 0;
}

input {
    background-color: white;
    border: 1px solid #ccc;
    border-radius: 3px;
    padding: 8px;
    margin: 10px 0;
}

img {
    width: 100px;
    height: 100px;
    border-radius: 5px;
}
]]

-- Test error handling
local function testErrorHandling()
    print("Testing error handling...")
    
    -- Test invalid HTML
    local success, result = pcall(function()
        return newhtml.fromHTML(nil, "")
    end)
    print("Invalid HTML test:", success == false and "PASSED" or "FAILED")
    
    -- Test invalid CSS
    success, result = pcall(function()
        return newhtml.fromHTML("<div>Test</div>", 123)
    end)
    print("Invalid CSS test:", success == false and "PASSED" or "FAILED")
    
    -- Test empty HTML
    success, result = pcall(function()
        return newhtml.fromHTML("", "")
    end)
    print("Empty HTML test:", success == false and "PASSED" or "FAILED")
end

-- Test HTML validation
local function testValidation()
    print("Testing HTML validation...")
    
    local validHTML = "<div><p>Valid HTML</p></div>"
    local success, result = newhtml.validateHTML(validHTML)
    print("Valid HTML test:", success and "PASSED" or "FAILED")
    
    local invalidHTML = "<div><p>Unclosed tag"
    success, result = newhtml.validateHTML(invalidHTML)
    print("Invalid HTML test:", success == false and "PASSED" or "FAILED")
end

-- Main test function
local function runTests()
    print("=== Enhanced HTML to GUI Converter Tests ===")
    
    -- Test basic conversion
    print("Testing basic conversion...")
    local success, gui = pcall(function()
        return newhtml.fromHTML(testHTML, testCSS)
    end)
    
    if success and gui then
        print("✓ Basic conversion: PASSED")
        print("GUI instance created:", gui.Name)
        
        -- Test error handling
        testErrorHandling()
        
        -- Test validation
        testValidation()
        
        print("=== All tests completed ===")
        
        -- Return the GUI instance for manual testing
        return gui
    else
        print("✗ Basic conversion: FAILED")
        print("Error:", gui)
    end
end

-- Run tests
return runTests()
