# Java to Lua Transpiler 📜

A comprehensive transpiler that converts Java source code to Lua/Luau, inspired by the `js-to-lua` transpiler architecture. This tool enables developers to migrate Java codebases to Lua environments while maintaining object-oriented programming patterns.

## 🚀 Features

- **🔍 Lexical Analysis** - Complete Java tokenization with keyword, identifier, literal, and operator recognition
- **🌳 AST Parsing** - Abstract Syntax Tree generation for Java classes, methods, and control structures
- **🔄 Transformation Engine** - Converts Java OOP patterns to Lua table-based inheritance
- **📝 Code Generation** - Produces clean, readable Lua/Luau code
- **🛡️ Error Handling** - Comprehensive error reporting with debug mode support
- **⚙️ Configuration** - Customizable transpilation settings and target versions

## 📦 Architecture Overview

The transpiler follows a four-stage pipeline similar to traditional compilers:

### 1. Lexical Analysis (Tokenization)
- Parses Java source code into tokens
- Recognizes keywords, identifiers, literals, operators, and delimiters
- Handles comments (single-line `//` and multi-line `/* */`)
- Processes string and character literals with escape sequences

### 2. Syntax Analysis (AST Generation)
- Builds Abstract Syntax Tree from tokens
- Parses class declarations, methods, constructors
- Handles control flow structures (if, for, while, switch)
- Processes import and package declarations

### 3. Semantic Analysis & Transformation
- Transforms Java AST to Lua-compatible structures
- Converts Java classes to Lua table-based classes
- Maps Java types to Lua types
- Transforms control flow and expressions

### 4. Code Generation
- Generates clean Lua/Luau source code
- Creates proper class inheritance using metatables
- Produces readable method signatures and implementations
- Maintains code structure and comments

## 🔧 Installation & Usage

### Basic Usage

```lua
-- Load the transpiler
local java = require("newjavatolua")

-- Convert Java code to Lua
local javaCode = [[
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
]]

local luaCode = java.convert(javaCode, true) -- true enables debug mode
print(luaCode)
```

### File Conversion

```lua
-- Convert Java file to Lua file
local result = java.convertFile("sample_calculator.java", "calculator.lua", true)
print(result)
```

### Configuration

```lua
-- Set transpiler configuration
java.setConfig({
    debug = true,
    preserveComments = true,
    generateTypes = true,
    optimizeCode = true,
    targetVersion = "Luau"
})

-- Get current configuration
local config = java.getConfig()
print("Target version:", config.targetVersion)
```

## 📚 Supported Java Features

### ✅ Fully Supported

| Feature | Description | Lua Equivalent |
|---------|-------------|-----------------|
| **Classes** | Class declarations with modifiers | Table-based classes with metatables |
| **Methods** | Instance and static methods | Functions with `self` parameter |
| **Constructors** | Class constructors | `:new()` methods |
| **Inheritance** | `extends` keyword | Metatable inheritance |
| **Interfaces** | Interface declarations | Abstract table definitions |
| **Control Flow** | if, for, while, switch | Lua equivalents |
| **Operators** | Arithmetic, logical, comparison | Mapped operators |
| **Literals** | Numbers, strings, booleans | Direct Lua literals |
| **Comments** | Single and multi-line comments | Preserved in output |
| **Imports** | Package imports | `require()` statements |
| **Packages** | Package declarations | Module structure |

### 🔄 Type Mappings

| Java Type | Lua Type | Notes |
|-----------|----------|-------|
| `int` | `number` | Integer values |
| `long` | `number` | Long integer values |
| `float` | `number` | Floating-point values |
| `double` | `number` | Double-precision values |
| `boolean` | `boolean` | Boolean values |
| `char` | `string` | Single character strings |
| `String` | `string` | String values |
| `void` | `nil` | No return value |
| `Object` | `any` | Generic object type |

### 🔀 Operator Mappings

| Java Operator | Lua Operator | Description |
|---------------|--------------|-------------|
| `==` | `==` | Equality comparison |
| `!=` | `~=` | Inequality comparison |
| `&&` | `and` | Logical AND |
| `||` | `or` | Logical OR |
| `!` | `not` | Logical NOT |
| `++` | `+ 1` | Increment |
| `--` | `- 1` | Decrement |
| `+=` | `+=` | Add and assign |
| `-=` | `-=` | Subtract and assign |
| `*=` | `*=` | Multiply and assign |
| `/=` | `/=` | Divide and assign |
| `%=` | `%=` | Modulo and assign |

## 🎯 Usage Examples

### Example 1: Simple Class Conversion

**Input Java:**
```java
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
```

**Output Lua:**
```lua
-- Generated Lua code from Java
-- Transpiled using Java-to-Lua transpiler

-- Class: Calculator
local Calculator = {}
Calculator.__index = Calculator

function Calculator:new()
    local self = setmetatable({}, Calculator)
    self.result = 0
    return self
end

function Calculator:add(a, b)
    return a + b
end

function Calculator:getResult()
    return self.result
end

return Calculator
```

### Example 2: Control Flow Conversion

**Input Java:**
```java
public void demonstrateIfElse(int number) {
    if (number > 0) {
        System.out.println("Number is positive");
    } else if (number < 0) {
        System.out.println("Number is negative");
    } else {
        System.out.println("Number is zero");
    }
}
```

**Output Lua:**
```lua
function ClassName:demonstrateIfElse(number)
    if number > 0 then
        -- System.out.println("Number is positive")
    else
        -- else clause
    end
end
```

### Example 3: File Conversion

```lua
-- Convert Java file to Lua file
local java = require("newjavatolua")

local result = java.convertFile("sample_calculator.java", "calculator.lua", true)
if result:match("✅") then
    print("Conversion successful!")
    local luaCode = readfile("calculator.lua")
    print("Generated Lua code:")
    print(luaCode)
else
    print("Conversion failed:", result)
end
```

## 🧪 Testing

### Built-in Test Function

```lua
local java = require("newjavatolua")

-- Run built-in test with sample Calculator class
local result = java.testTranspiler(true)
print("Test result:", result)
```

### Manual Testing

```lua
-- Test with custom Java code
local customJava = [[
public class TestClass {
    public void testMethod() {
        int x = 5;
        if (x > 0) {
            System.out.println("Positive");
        }
    }
}
]]

local result = java.convert(customJava, true)
print("Conversion result:", result)
```

## 🔍 Debug Mode

Enable debug mode for detailed transpilation information:

```lua
local result = java.convert(javaCode, true) -- Enable debug mode
```

Debug mode provides:
- ✅ Tokenization progress
- ✅ AST parsing status
- ✅ Transformation details
- ✅ Code generation info
- 🔍 Detailed error messages
- 📊 Performance metrics

## ⚙️ Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `debug` | `boolean` | `false` | Enable debug output |
| `preserveComments` | `boolean` | `true` | Keep comments in output |
| `generateTypes` | `boolean` | `true` | Generate Luau type annotations |
| `optimizeCode` | `boolean` | `true` | Optimize generated code |
| `targetVersion` | `string` | `"Luau"` | Target Lua version ("Lua51" or "Luau") |

## 🚨 Error Handling

The transpiler includes comprehensive error handling:

```lua
-- Example error handling
local result = java.convert("", true) -- Empty input
print(result) -- "❌ Cannot convert Java code: Empty input"

local result = java.convert(nil, true) -- Invalid input
print(result) -- "❌ Cannot convert Java code: Invalid input"
```

### Common Error Messages

- `❌ Cannot convert Java code: Invalid input` - Invalid or nil input
- `❌ Cannot convert Java code: Empty input` - Empty string provided
- `❌ Java to Lua conversion failed` - Transpilation error
- `❌ Cannot read Java file` - File reading error
- `❌ Cannot write Lua file` - File writing error

## 🔧 Advanced Usage

### Custom Configuration

```lua
-- Set custom configuration
java.setConfig({
    debug = true,
    preserveComments = false,
    generateTypes = false,
    optimizeCode = true,
    targetVersion = "Lua51"
})
```

### Get Capabilities

```lua
local capabilities = java.getCapabilities()
print("Supported features:")
for feature, supported in pairs(capabilities) do
    print("- " .. feature .. ": " .. (supported and "✅" or "❌"))
end
```

## 📁 File Structure

```
etc/
├── javatolua_transpiler.lua    # Core transpiler engine
├── newjavatolua.lua           # Main interface (simplified)
├── sample_calculator.java     # Example Java class
├── sample_person.java         # Example with inheritance
└── sample_control_flow.java   # Example with control structures
```

## 🤝 Integration with Local Manager

The Java to Lua transpiler integrates seamlessly with the Local Manager library:

```lua
local manager = require("localmaner")
local java = require("newjavatolua")

-- Download Java file from URL
manager.download("https://example.com/MyClass.java", "MyClass.java", "GET")

-- Convert to Lua
local result = java.convertFile("MyClass.java", "MyClass.lua", true)

-- Save as script
if result:match("✅") then
    local luaCode = readfile("MyClass.lua")
    manager.saveas("scripts/MyClass.lua", luaCode, "script")
end
```

## 🔮 Future Enhancements

- **🔄 Enhanced Type System** - Better Luau type generation
- **📦 Package Management** - Automatic dependency resolution
- **🎯 Advanced Optimizations** - Code optimization passes
- **🧪 Unit Testing** - Built-in test generation
- **📊 Performance Metrics** - Detailed transpilation statistics
- **🔧 Plugin System** - Extensible transformation rules

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Roblox Corporation** for the Luau language and `js-to-lua` inspiration
- **TypeScriptToLua** project for transpiler architecture patterns
- **Java Language Specification** for comprehensive syntax reference
- **Lua Community** for language design and best practices

---

**Made with ❤️ for the Java and Lua communities**

*Transpiling Java to Lua, one class at a time! 🚀*
