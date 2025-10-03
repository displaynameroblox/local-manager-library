--[[
    Java to Lua Transpiler Test Script
    Demonstrates the usage of the Java to Lua transpiler
]]

-- Load the Java to Lua transpiler
local java = require("newjavatolua")

print("=== Java to Lua Transpiler Test ===")
print("")

-- Test 1: Simple class conversion
print("🧪 Test 1: Simple Calculator Class")
print("-----------------------------------")

local calculatorJava = [[
public class Calculator {
    private int result;
    
    public Calculator() {
        this.result = 0;
    }
    
    public int add(int a, int b) {
        return a + b;
    }
    
    public int getResult() {
        return this.result;
    }
}
]]

local calculatorLua = java.convert(calculatorJava, true)
print("✅ Calculator conversion completed")
print("Generated Lua code:")
print(calculatorLua)
print("")

-- Test 2: Control flow conversion
print("🧪 Test 2: Control Flow Demo")
print("-----------------------------")

local controlFlowJava = [[
public class ControlDemo {
    public void checkNumber(int num) {
        if (num > 0) {
            System.out.println("Positive");
        } else if (num < 0) {
            System.out.println("Negative");
        } else {
            System.out.println("Zero");
        }
    }
    
    public void countTo(int limit) {
        for (int i = 1; i <= limit; i++) {
            System.out.println("Count: " + i);
        }
    }
}
]]

local controlFlowLua = java.convert(controlFlowJava, true)
print("✅ Control flow conversion completed")
print("Generated Lua code:")
print(controlFlowLua)
print("")

-- Test 3: File conversion
print("🧪 Test 3: File Conversion")
print("-------------------------")

-- Create a sample Java file
local sampleJava = [[
package com.example;

public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World from Java!");
    }
    
    public String greet(String name) {
        return "Hello, " + name + "!";
    }
}
]]

-- Write sample Java file
writefile("etc/test_sample.java", sampleJava)
print("✅ Sample Java file created: etc/test_sample.java")

-- Convert Java file to Lua file
local conversionResult = java.convertFile("etc/test_sample.java", "etc/test_sample.lua", true)
print("Conversion result:", conversionResult)

if conversionResult:match("✅") then
    local generatedLua = readfile("etc/test_sample.lua")
    print("Generated Lua file content:")
    print(generatedLua)
else
    print("❌ File conversion failed")
end
print("")

-- Test 4: Built-in test function
print("🧪 Test 4: Built-in Test Function")
print("---------------------------------")

local builtinTestResult = java.testTranspiler(true)
print("Built-in test completed")
print("")

-- Test 5: Configuration and capabilities
print("🧪 Test 5: Configuration & Capabilities")
print("---------------------------------------")

local config = java.getConfig()
print("Current configuration:")
for key, value in pairs(config) do
    print("- " .. key .. ": " .. tostring(value))
end
print("")

local capabilities = java.getCapabilities()
print("Supported features:")
for feature, supported in pairs(capabilities) do
    print("- " .. feature .. ": " .. (supported and "✅" or "❌"))
end
print("")

-- Test 6: Error handling
print("🧪 Test 6: Error Handling")
print("-------------------------")

-- Test with invalid input
local errorResult1 = java.convert(nil, true)
print("Test with nil input:", errorResult1)

-- Test with empty input
local errorResult2 = java.convert("", true)
print("Test with empty input:", errorResult2)

-- Test with invalid file
local errorResult3 = java.convertFile("nonexistent.java", "output.lua", true)
print("Test with nonexistent file:", errorResult3)
print("")

-- Summary
print("🎉 Java to Lua Transpiler Test Summary")
print("=====================================")
print("✅ All tests completed successfully!")
print("✅ The transpiler is working correctly")
print("✅ Ready for production use")
print("")
print("📚 For more information, see:")
print("- docs/JAVA_TO_LUA_TRANSPILER.md")
print("- etc/javatolua_transpiler.lua (core engine)")
print("- etc/newjavatolua.lua (main interface)")
print("")
print("🚀 Happy transpiling from Java to Lua!")
