# 📚 Local Manager Library - API Documentation

Complete API reference for the Local Manager Library.

## Table of Contents

- [File Operations](#file-operations)
- [HTTP Operations](#http-operations)
- [HTML to GUI Conversion](#html-to-gui-conversion)
- [System Diagnostics](#system-diagnostics)
- [Error Codes](#error-codes)
- [Data Types](#data-types)

---

## File Operations

### `manager.new(path, data)`

Creates a new file with specified content.

**Signature:**
```lua
function manager.new(path: string, data: string): string
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `path` | `string` | ✅ | File path where to create the file |
| `data` | `string` | ✅ | Content to write to the file |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message or error description |

**Success Messages:**
- `"file created successfully"`

**Error Messages:**
- `"cannot create file, did you forget to add path?"` - When `path` is nil or empty
- `"cannot create file, did you forget to add data?"` - When `data` is nil or empty
- `"failed to create file"` - When file creation fails

**Example:**
```lua
local result = manager.new("config.json", '{"setting": "value"}')
-- Returns: "file created successfully"
```

---

### `manager.move(path, newpath)`

Moves a file from one location to another.

**Signature:**
```lua
function manager.move(path: string, newpath: string): string
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `path` | `string` | ✅ | Source file path |
| `newpath` | `string` | ✅ | Destination file path |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message or error description |

**Success Messages:**
- `"file moved successfully"`

**Error Messages:**
- `"cannot move file, did you forget to add source path?"` - When `path` is nil
- `"cannot move file, did you forget to add destination path?"` - When `newpath` is nil
- `"source file not found"` - When source file doesn't exist
- `"destination file already exists"` - When destination file already exists
- `"failed to read source file"` - When source file cannot be read
- `"failed to write to destination file"` - When destination file cannot be written
- `"failed to delete source file"` - When source file cannot be deleted

**Example:**
```lua
local result = manager.move("old.txt", "new.txt")
-- Returns: "file moved successfully"
```

---

## HTTP Operations

### `manager.download(url, path, Method, Headers)`

Downloads a file from a URL and saves it locally.

**Signature:**
```lua
function manager.download(url: string, path: string, Method: string?, Headers: table?): string
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `url` | `string` | ✅ | URL to download from |
| `path` | `string` | ✅ | Local path to save the file |
| `Method` | `string` | ❌ | HTTP method ("GET" or "POST"). Defaults to "GET" |
| `Headers` | `table` | ❌ | HTTP headers for requests |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message or error description |

**Success Messages:**
- `"file downloaded successfully"`

**Error Messages:**
- `"cannot download file, did you forget to add the url?"` - When `url` is nil
- `"cannot download file, did you forget to add path?"` - When `path` is nil
- `"you fucking idiot, how the fuck did you get this far?. put the url and the path"` - When both `url` and `path` are nil
- `"invalid response from server"` - When server response is invalid
- `"failed to save file"` - When file cannot be saved locally
- `"failed to download file"` - When download request fails

**Example:**
```lua
-- GET request
local result = manager.download("https://example.com/data.json", "data.json", "GET")

-- POST request with headers
local headers = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer token123"
}
local result = manager.download("https://api.example.com/upload", "response.json", "POST", headers)
```

---

## HTML to GUI Conversion

### `manager.html(url, islocal, path, convertToGui, parentGui)`

Loads HTML content and optionally converts it to Roblox GUI elements.

**Signature:**
```lua
function manager.html(url: string?, islocal: boolean, path: string, convertToGui: boolean?, parentGui: Instance?): string | Instance
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `url` | `string` | ❌ | URL to load HTML from (if not local) |
| `islocal` | `boolean` | ✅ | Whether to load from local file or URL |
| `path` | `string` | ✅ | File path (for local) or save path (for URL) |
| `convertToGui` | `boolean` | ❌ | Whether to convert HTML to GUI |
| `parentGui` | `Instance` | ❌ | Parent GUI object for converted elements |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | HTML content (when `convertToGui` is false) |
| `string` | Success message (when `convertToGui` is true) |
| `string` | Error description |

**Success Messages:**
- `"HTML converted to GUI successfully"`
- `"html content downloaded and saved successfully"`

**Error Messages:**
- `"cannot handle html, did you forget to add path?"` - When `path` is nil
- `"i won't classify that you are a programmer, put the url and the path, and say if it local or not. dont keep it empty"` - When both `islocal` and `url` are false/nil
- `"file not found, did you type the path wrong?"` - When local file doesn't exist
- `"failed to read local HTML file"` - When local file cannot be read
- `"cannot find url, did you forget to add url?"` - When URL is nil but not local
- `"failed to load HTML from URL: [url]"` - When URL request fails
- `"no HTML content available"` - When no content is available

**Example:**
```lua
-- Load HTML from URL and convert to GUI
local result = manager.html("https://example.com/page.html", false, "downloaded.html", true)

-- Load local HTML file and convert to GUI
local result = manager.html(nil, true, "local.html", true)

-- Just load HTML content without conversion
local htmlContent = manager.html("https://example.com/page.html", false, "downloaded.html")
```

---

### `manager.createSampleHtmlGui()`

Creates a sample HTML GUI to demonstrate the conversion functionality.

**Signature:**
```lua
function manager.createSampleHtmlGui(): string
```

**Parameters:** None

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message |

**Success Messages:**
- `"HTML converted to GUI successfully"`

**Example:**
```lua
local result = manager.createSampleHtmlGui()
-- Creates a sample GUI with buttons, inputs, and styling
```

---

## System Diagnostics

### `manager.nodefecth()`

Runs comprehensive system diagnostics and displays system information.

**Signature:**
```lua
function manager.nodefecth(): table
```

**Parameters:** None

**Returns:**
| Type | Description |
|------|-------------|
| `table` | System information object with detailed test results |

**System Information Structure:**
```lua
{
    executor = {
        name = "string",        -- Executor name
        version = "string",     -- Executor version
        available = boolean     -- Whether executor is detected
    },
    game = {
        available = boolean,    -- Whether game environment is available
        placeId = "string",     -- Roblox place ID
        gameId = "string"       -- Roblox game ID
    },
    filesystem = {
        listfiles = boolean,    -- Whether listfiles works
        isfile = boolean,       -- Whether isfile works
        isfolder = boolean,     -- Whether isfolder works
        readfile = boolean,     -- Whether readfile works
        writefile = boolean     -- Whether writefile works
    },
    http = {
        request = boolean,      -- Whether request function works
        ["game:HttpGet"] = boolean  -- Whether game:HttpGet works
    },
    gui = {
        ["Drawing.new"] = boolean,      -- Whether Drawing.new works
        ["Instance.new"] = boolean,     -- Whether Instance.new works
        ["ScreenGui Creation"] = boolean -- Whether ScreenGui creation works
    },
    advanced = {
        hookfunction = boolean, -- Whether hookfunction works
        getgenv = boolean,      -- Whether getgenv works
        getrenv = boolean,      -- Whether getrenv works
        loadstring = boolean    -- Whether loadstring works
    },
    memory = {
        getgc = boolean,        -- Whether getgc works
        getreg = boolean,       -- Whether getreg works
        gcCount = number,       -- Number of GC objects
        regCount = number       -- Number of registry objects
    }
}
```

**Example:**
```lua
local systemInfo = manager.nodefecth()

-- Check specific capabilities
if systemInfo.filesystem.writefile then
    print("✅ File writing is supported")
end

if systemInfo.http.request then
    print("✅ HTTP requests are supported")
end
```

---

## Error Codes

### Common Error Patterns

| Error Pattern | Cause | Solution |
|---------------|-------|----------|
| `"cannot create file, did you forget to add [parameter]?"` | Missing required parameter | Provide the required parameter |
| `"file not found"` | File doesn't exist | Check file path and existence |
| `"failed to [operation]"` | Operation failed due to permissions or system limitations | Check executor permissions |
| `"cannot find url"` | URL is invalid or unreachable | Check URL validity and network connectivity |

### Error Handling Best Practices

```lua
-- Always check return values
local result = manager.new("file.txt", "content")
if result:find("successfully") then
    print("Operation successful!")
else
    print("Error: " .. result)
end

-- Use pcall for additional error handling
local success, result = pcall(function()
    return manager.move("source.txt", "dest.txt")
end)

if not success then
    print("Exception occurred: " .. result)
end
```

---

## Data Types

### Supported HTML Elements

| HTML Element | Roblox GUI Equivalent | Supported Attributes |
|-------------|----------------------|---------------------|
| `<div>` | `Frame` | `style` |
| `<button>` | `TextButton` | `value`, `text`, `style` |
| `<input>`, `<textbox>` | `TextBox` | `placeholder`, `value`, `style` |
| `<label>`, `<span>` | `TextLabel` | `value`, `style` |
| `<h1>`, `<h2>`, `<h3>` | `TextLabel` | `value`, `style` |
| `<image>`, `<img>` | `ImageLabel` | `src`, `style` |
| `<list>`, `<ul>` | `ScrollingFrame` | `style` |

### Supported CSS Properties

| Property | Values | Description |
|----------|--------|-------------|
| `background-color` | RGB, hex, named colors | Background color of element |
| `color` | RGB, hex, named colors | Text color of element |
| `width` | Number (pixels) | Width of element |
| `height` | Number (pixels) | Height of element |

### Color Formats

| Format | Example | Description |
|--------|---------|-------------|
| RGB | `rgb(255, 0, 0)` | Red, Green, Blue values (0-255) |
| Hex | `#ff0000` | Hexadecimal color code |
| Named | `red`, `blue`, `green` | Predefined color names |

---

## Performance Considerations

### File Operations
- File operations are synchronous and may block execution
- Large files may cause performance issues
- Use appropriate error handling for file operations

### HTTP Operations
- Network requests may timeout or fail
- Always handle network errors gracefully
- Consider rate limiting for multiple requests

### GUI Conversion
- HTML parsing is basic and may not handle complex structures
- Large HTML documents may impact performance
- GUI elements are created in the main thread

---

## Compatibility

### Executor Requirements
- **Minimum:** Basic file system access (`writefile`, `readfile`)
- **Recommended:** Full executor with HTTP and GUI support
- **Language:** Luau (Roblox Lua)

### Tested Executors
- Wave ✅
- Krnl ✅
- Hydrogen ✅

---

## Changelog

### Version 1.0.0
- Initial release
- File operations (`new`, `move`)
- HTTP operations (`download`)
- HTML to GUI conversion
- System diagnostics (`nodefecth`)

---

*Last updated: 2025*
