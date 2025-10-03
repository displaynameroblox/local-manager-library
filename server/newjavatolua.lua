--[[
    Java to Lua Converter - Main Interface
    This script provides a simplified interface to the comprehensive Java-to-Lua transpiler
    Similar to the newsaveas.lua pattern for easy integration
]]

local java = {}

-- Load the comprehensive transpiler
local transpiler = require("javatolua_transpiler")

-- Main conversion function with simplified interface
function java.convert(javaCode, debug)
    local isloaded = javaCode and type(javaCode) == "string"
    
    if not isloaded then
        if debug then
            return "❌ Cannot convert Java code: Invalid input. Found: " .. tostring(javaCode)
        else
            return "❌ Cannot convert Java code: Invalid input"
        end
    end
    
    if javaCode:len() == 0 then
        if debug then
            return "❌ Cannot convert Java code: Empty input provided"
        else
            return "❌ Cannot convert Java code: Empty input"
        end
    end
    
    -- Use the comprehensive transpiler
    local success, result = pcall(function()
        return transpiler.convert(javaCode, debug)
    end)
    
    if not success then
        if debug then
            return "❌ Java to Lua conversion failed: " .. tostring(result)
        else
            return "❌ Java to Lua conversion failed"
        end
    end
    
    return result
end

-- Utility function to convert Java file to Lua file
function java.convertFile(javaFilePath, luaFilePath, debug)
    local success, javaContent = pcall(function()
        return readfile(javaFilePath)
    end)
    
    if not success then
        if debug then
            return "❌ Cannot read Java file: " .. tostring(javaFilePath) .. " Error: " .. tostring(javaContent)
        else
            return "❌ Cannot read Java file: " .. tostring(javaFilePath)
        end
    end
    
    local luaCode = java.convert(javaContent, debug)
    
    if luaCode:match("❌") then
        return luaCode -- Return error message
    end
    
    -- Save the converted Lua code
    local writeSuccess, writeError = pcall(function()
        writefile(luaFilePath, luaCode)
    end)
    
    if not writeSuccess then
        if debug then
            return "❌ Cannot write Lua file: " .. tostring(luaFilePath) .. " Error: " .. tostring(writeError)
        else
            return "❌ Cannot write Lua file: " .. tostring(luaFilePath)
        end
    end
    
    if debug then
        return "✅ Successfully converted Java file to Lua: " .. tostring(javaFilePath) .. " → " .. tostring(luaFilePath)
    else
        return "✅ Successfully converted Java file to Lua"
    end
end

-- Get transpiler capabilities
function java.getCapabilities()
    return transpiler.getSupportedFeatures()
end

-- Get transpiler configuration
function java.getConfig()
    return transpiler.getConfig()
end

-- Set transpiler configuration
function java.setConfig(newConfig)
    transpiler.setConfig(newConfig)
end

-- Create a sample Java class for testing
function java.createSampleJavaClass()
    local sampleJava = [[
package com.example;

import java.util.List;
import java.util.ArrayList;

public class Calculator {
    private int result;
    
    public Calculator() {
        this.result = 0;
    }
    
    public int add(int a, int b) {
        return a + b;
    }
    
    public int subtract(int a, int b) {
        return a - b;
    }
    
    public int multiply(int a, int b) {
        return a * b;
    }
    
    public int divide(int a, int b) {
        if (b == 0) {
            throw new IllegalArgumentException("Division by zero");
        }
        return a / b;
    }
    
    public int getResult() {
        return this.result;
    }
    
    public void setResult(int result) {
        this.result = result;
    }
    
    public static void main(String[] args) {
        Calculator calc = new Calculator();
        System.out.println("Calculator created");
        
        int sum = calc.add(5, 3);
        System.out.println("5 + 3 = " + sum);
        
        int diff = calc.subtract(10, 4);
        System.out.println("10 - 4 = " + diff);
    }
}
]]
    
    return sampleJava
end

-- Test the transpiler with sample code
function java.testTranspiler(debug)
    local sampleJava = java.createSampleJavaClass()
    local result = java.convert(sampleJava, debug)
    
    if debug then
        print("=== Java to Lua Transpiler Test ===")
        print("Input Java code length:", #sampleJava)
        print("Output Lua code length:", #result)
        print("Conversion successful:", not result:match("❌"))
    end
    
    return result
end

return java