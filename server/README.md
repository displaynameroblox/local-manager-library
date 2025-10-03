# 🚀 Java to Lua Transpiler Server

A lightweight, npm-free HTTP server that provides Java to Lua transpilation services. Built entirely in Lua/Luau and designed to run in Roblox environments without requiring external dependencies.

## ✨ Features

- **🌐 HTTP Server** - RESTful API for Java to Lua conversion
- **📝 Code Conversion** - Convert Java code snippets to Lua
- **📁 File Processing** - Upload Java files and download converted Lua files
- **🎨 Web Interface** - Beautiful, responsive web UI for easy usage
- **📚 Example Library** - Built-in Java examples for testing
- **🔧 Configuration** - Customizable server settings
- **📊 Statistics** - Server performance and usage metrics
- **🛡️ Error Handling** - Comprehensive error reporting and validation

## 🏗️ Architecture

```
server/
├── launcher.lua              # Main server launcher
├── server.lua                # HTTP server implementation
├── file_handler.lua          # File upload/download management
├── api/
│   └── endpoints.lua         # REST API endpoints
├── web/
│   └── index.html           # Web interface
├── uploads/                 # Uploaded Java files
├── downloads/               # Converted Lua files
├── examples/                # Example Java files
├── javatolua_transpiler.lua # Core transpiler engine
└── newjavatolua.lua        # Transpiler interface
```

## 🚀 Quick Start

### Method 1: Direct Launch
```lua
-- Load and run the server
local launcher = require("launcher")
launcher.main()
```

### Method 2: Custom Configuration
```lua
local launcher = require("launcher")

-- Customize server settings
launcher.config.port = 3000
launcher.config.host = "0.0.0.0"
launcher.config.debug = true

-- Start server
launcher.main()
```

### Method 3: Command Line Arguments
```bash
# Default settings
launcher.lua

# Custom port
launcher.lua --port 3000

# Custom host and port
launcher.lua --host 0.0.0.0 --port 8080

# Disable debug mode
launcher.lua --no-debug

# Disable web interface
launcher.lua --no-web
```

## 🌐 Web Interface

Access the web interface at `http://localhost:8080/web` for an intuitive GUI:

- **📝 Code Converter** - Paste Java code and get instant Lua conversion
- **📁 File Upload** - Upload Java files for batch conversion
- **📚 Examples** - Browse and load example Java files
- **⚙️ Settings** - Configure conversion options
- **📊 Results** - View conversion results with syntax highlighting

## 📡 API Endpoints

### Server Information
```http
GET / - Server information and status
GET /health - Health check
GET /stats - Server statistics
```

### Code Conversion
```http
POST /convert
Content-Type: application/json

{
  "javaCode": "public class HelloWorld { public static void main(String[] args) { System.out.println(\"Hello, World!\"); } }",
  "debug": true
}
```

### File Conversion
```http
POST /convert-file
Content-Type: application/json

{
  "filename": "MyClass.java",
  "debug": true
}
```

### Examples
```http
GET /examples - List available examples
GET /examples/calculator - Get Calculator.java example
```

### File Management
```http
GET /download/{filename} - Download converted file
```

## 🔧 REST API (v1)

### Base URL
```
http://localhost:8080/api/v1
```

### Endpoints

#### Convert Java Code
```http
POST /api/v1/convert
Content-Type: application/json

{
  "javaCode": "public class Test {}",
  "debug": false,
  "options": {
    "targetVersion": "Luau",
    "generateTypes": true
  }
}
```

**Response:**
```json
{
  "success": true,
  "result": {
    "javaCode": "public class Test {}",
    "luaCode": "-- Generated Lua code...",
    "debug": false,
    "options": {...}
  },
  "metadata": {
    "conversionTime": 0.123,
    "javaCodeLength": 20,
    "luaCodeLength": 150,
    "timestamp": 1640995200,
    "version": "1.0.0"
  }
}
```

#### Convert Java File
```http
POST /api/v1/convert-file
Content-Type: application/json

{
  "filename": "Calculator.java",
  "debug": true,
  "options": {
    "targetVersion": "Luau"
  }
}
```

#### Get Examples
```http
GET /api/v1/examples
```

**Response:**
```json
{
  "examples": [
    {
      "id": "calculator",
      "name": "Calculator.java",
      "description": "Simple calculator class",
      "category": "basic",
      "difficulty": "beginner",
      "size": "~1.2KB",
      "features": ["classes", "methods", "constructors"]
    }
  ],
  "count": 3,
  "categories": ["basic", "oop", "control-flow"]
}
```

#### Get Specific Example
```http
GET /api/v1/examples/calculator
```

#### Get Capabilities
```http
GET /api/v1/capabilities
```

#### Configuration Management
```http
GET /api/v1/config - Get current configuration
POST /api/v1/config - Update configuration
```

## 📁 File Management

### Upload Directory
- **Location:** `server/uploads/`
- **Purpose:** Store uploaded Java files
- **Max Files:** 100 files
- **Max Size:** 1MB per file
- **Allowed Extensions:** `.java`

### Download Directory
- **Location:** `server/downloads/`
- **Purpose:** Store converted Lua files
- **Auto-cleanup:** Files older than 1 hour are automatically removed

### Example Files
- **Location:** `server/examples/`
- **Purpose:** Provide sample Java code for testing
- **Files:**
  - `Calculator.java` - Basic arithmetic operations
  - `Person.java` - Object-oriented programming
  - `ControlFlowDemo.java` - Control structures

## ⚙️ Configuration

### Server Configuration
```lua
local config = {
    port = 8080,                    -- Server port
    host = "localhost",             -- Server host
    debug = true,                   -- Enable debug logging
    maxFileSize = 1024 * 1024,     -- Max file size (1MB)
    allowedExtensions = {".java"},  -- Allowed file extensions
    maxFiles = 100,                 -- Max files in upload directory
    corsEnabled = true              -- Enable CORS headers
}
```

### Transpiler Configuration
```lua
local transpilerConfig = {
    debug = false,                  -- Debug mode
    preserveComments = true,        -- Keep comments in output
    generateTypes = true,           -- Generate Luau type annotations
    optimizeCode = true,            -- Optimize generated code
    targetVersion = "Luau"         -- Target Lua version
}
```

## 🔍 Usage Examples

### Example 1: Convert Java Code via API
```bash
curl -X POST http://localhost:8080/api/v1/convert \
  -H "Content-Type: application/json" \
  -d '{
    "javaCode": "public class HelloWorld { public static void main(String[] args) { System.out.println(\"Hello, World!\"); } }",
    "debug": true
  }'
```

### Example 2: Convert Java File
```bash
# Upload file first (in a real implementation)
curl -X POST http://localhost:8080/api/v1/convert-file \
  -H "Content-Type: application/json" \
  -d '{
    "filename": "Calculator.java",
    "debug": false
  }'
```

### Example 3: Get Server Statistics
```bash
curl http://localhost:8080/api/v1/stats
```

### Example 4: Load Example
```bash
curl http://localhost:8080/api/v1/examples/calculator
```

## 🛡️ Error Handling

The server provides comprehensive error handling with standardized error responses:

### Error Response Format
```json
{
  "error": "ERROR_CODE",
  "message": "Human-readable error message",
  "code": 400
}
```

### Common Error Codes
- `INVALID_JSON` - Invalid JSON in request body
- `MISSING_JAVA_CODE` - Missing javaCode field
- `EMPTY_JAVA_CODE` - Empty Java code provided
- `FILE_TOO_LARGE` - File exceeds size limit
- `INVALID_FILE_EXTENSION` - Unsupported file type
- `FILE_NOT_FOUND` - File not found
- `SAVE_ERROR` - File save operation failed
- `READ_ERROR` - File read operation failed

## 📊 Monitoring & Statistics

### Server Statistics
```http
GET /stats
```

**Response:**
```json
{
  "uptime": 3600,
  "totalRequests": 150,
  "totalConversions": 45,
  "conversionRate": 30.0,
  "serverInfo": {
    "version": "1.0.0",
    "luaVersion": "Lua 5.1",
    "platform": "Roblox"
  },
  "config": {
    "maxFileSize": 1048576,
    "allowedExtensions": [".java"],
    "debug": true
  }
}
```

### Health Check
```http
GET /health
```

**Response:**
```json
{
  "status": "healthy",
  "uptime": 3600,
  "memory": "OK",
  "disk": "OK"
}
```

## 🔧 Development

### Adding New Endpoints
1. Add endpoint handler to `api/endpoints.lua`
2. Register route in `server.lua`
3. Update documentation

### Extending File Handling
1. Modify `file_handler.lua`
2. Add new validation rules
3. Update configuration options

### Customizing Web Interface
1. Edit `web/index.html`
2. Add new JavaScript functions
3. Update CSS styling

## 🚨 Troubleshooting

### Common Issues

#### Server Won't Start
- Check if port is already in use
- Verify file permissions
- Check Roblox executor capabilities

#### File Upload Fails
- Verify file extension is `.java`
- Check file size (max 1MB)
- Ensure upload directory exists

#### Conversion Errors
- Check Java syntax validity
- Verify transpiler configuration
- Enable debug mode for detailed errors

#### Web Interface Not Loading
- Check server is running
- Verify port configuration
- Check browser console for errors

### Debug Mode
Enable debug mode for detailed logging:
```lua
server.setConfig({debug = true})
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Roblox Corporation** for the Luau language
- **Java Community** for language specification
- **Lua Community** for language design
- **Web Standards** for HTTP and REST APIs

---

**Made with ❤️ for the Java and Lua communities**

*No npm required - Pure Lua power! 🚀*
