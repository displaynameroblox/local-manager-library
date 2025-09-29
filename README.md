# 📁 Local Manager Library

A comprehensive Lua library for managing local files, directories, and HTML-to-GUI conversion in Roblox environments. Built with Luau and designed for Roblox executors.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Lua](https://img.shields.io/badge/language-Luau-orange.svg)
![Roblox](https://img.shields.io/badge/platform-Roblox-red.svg)

## 🚀 Features

- **📁 File Management** - Create, move, and manage local files
- **🌐 HTTP Operations** - Download files from URLs with error handling
- **🎨 HTML to GUI** - Convert HTML content to Roblox GUI elements
- **🔍 System Diagnostics** - Comprehensive system information tool (nodefecth)
- **🛡️ Error Handling** - Robust error handling with `pcall` throughout
- **📱 GUI Support** - Full Roblox GUI and Drawing API integration

## 📦 Installation

### Method 1: Direct Load
```lua
local manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/displaynameroblox/localmaner/main/localmaner.lua"))()
```

### Method 2: From Local File
```lua
local manager = loadstring(readfile("localmaner.lua"))()
```

## 🔧 Quick Start

```lua
-- Load the library
local manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/displaynameroblox/localmaner/main/localmaner.lua"))()

-- Create a new file
manager.new("test.txt", "Hello, World!")

-- Download a file from URL
manager.download("https://example.com/file.txt", "downloaded.txt", "GET")

-- Convert HTML to GUI
local htmlContent = [[
    <div style="background-color: rgb(40, 40, 40); width: 400; height: 300;">
        <h1 style="color: white;">My Website!</h1>
        <button style="background-color: blue; color: white;">Click me!</button>
    </div>
]]
manager.html(nil, true, "template.html", true) -- Convert to GUI

-- Run system diagnostics
manager.nodefecth()
```

## 📚 API Reference

### File Operations

#### `manager.new(path, data)`
Creates a new file with the specified content.

**Parameters:**
- `path` (string) - File path where to create the file
- `data` (string) - Content to write to the file

**Returns:**
- `string` - Success message or error description

**Example:**
```lua
local result = manager.new("config.json", '{"setting": "value"}')
print(result) -- "file created successfully"
```

#### `manager.move(path, newpath)`
Moves a file from one location to another.

**Parameters:**
- `path` (string) - Source file path
- `newpath` (string) - Destination file path

**Returns:**
- `string` - Success message or error description

**Example:**
```lua
local result = manager.move("old.txt", "new.txt")
print(result) -- "file moved successfully"
```

#### `manager.dfile(path, isundo, undofile)`
Deletes files with undo functionality or restores files from backup.

**Parameters:**
- `path` (string) - Path of the file to delete/restore
- `isundo` (boolean) - If true, restores file; if false, deletes file
- `undofile` (string, optional) - Path for undo backup file

**Returns:**
- `string` - Success message or error description

**Example:**
```lua
-- Delete file with auto backup
local result = manager.dfile("config.json", false)
print(result) -- "file deleted successfully, undo backup created at: config.json.undo"

-- Restore file from backup
local result = manager.dfile("config.json", true, "config.json.undo")
print(result) -- "file restored successfully from undo backup"
```

### HTTP Operations

#### `manager.download(url, path, Method, Headers)`
Downloads a file from a URL and saves it locally.

**Parameters:**
- `url` (string) - URL to download from
- `path` (string) - Local path to save the file
- `Method` (string, optional) - HTTP method ("GET" or "POST")
- `Headers` (table, optional) - HTTP headers for POST requests

**Returns:**
- `string` - Success message or error description

**Example:**
```lua
-- Simple GET download
local result = manager.download("https://example.com/data.json", "data.json", "GET")

-- POST request with headers
local headers = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer token123"
}
local result = manager.download("https://api.example.com/upload", "response.json", "POST", headers)
```

### HTML to GUI Conversion

#### `manager.html(url, islocal, path, convertToGui, parentGui)`
Loads HTML content and optionally converts it to Roblox GUI elements.

**Parameters:**
- `url` (string, optional) - URL to load HTML from (if not local)
- `islocal` (boolean) - Whether to load from local file or URL
- `path` (string) - File path (for local) or save path (for URL)
- `convertToGui` (boolean, optional) - Whether to convert HTML to GUI
- `parentGui` (Instance, optional) - Parent GUI object for converted elements

**Returns:**
- `string` or `Instance` - HTML content or GUI object

**Example:**
```lua
-- Load HTML from URL and convert to GUI
manager.html("https://example.com/page.html", false, "downloaded.html", true)

-- Load local HTML file and convert to GUI
manager.html(nil, true, "local.html", true)

-- Just load HTML content without conversion
local htmlContent = manager.html("https://example.com/page.html", false, "downloaded.html")
```

#### `manager.createSampleHtmlGui()`
Creates a sample HTML GUI to demonstrate the conversion functionality.

**Returns:**
- `string` - Success message

**Example:**
```lua
manager.createSampleHtmlGui() -- Creates a sample GUI with buttons, inputs, etc.
```

### Media Operations

#### `manager.media(path, type, typeofmedia, isfolder, folder)`
Handles media files including audio and video playback.

**Parameters:**
- `path` (string, optional) - File path (ignored when `isfolder` is true)
- `type` (string) - Media type category
- `typeofmedia` (string) - Specific media type ("audio", "video", "image", "document")
- `isfolder` (boolean, optional) - Whether to process a folder of files
- `folder` (string, optional) - Folder path (required when `isfolder` is true)

**Returns:**
- `string` - Success message, error description, or file content
- `Instance?` - Media instance (Sound for audio, VideoFrame for video) - second return value

**Example - Audio Playback:**
```lua
local result, soundInstance = manager.media("song.mp3", "audio", "audio", false)
if soundInstance then
    soundInstance.Volume = 0.7 -- Control the sound
    soundInstance:Pause() -- Pause playback
    soundInstance:Resume() -- Resume playback
end
```

**Example - Video Playback (EXPERIMENTAL):**
```lua
local result, videoInstance = manager.media("video.mp4", "video", "video", false)
if videoInstance then
    videoInstance.Size = UDim2.new(0, 600, 0, 400) -- Resize video
    videoInstance:Pause() -- Pause video
    videoInstance:Resume() -- Resume video
end
```

**Example - Folder Audio Playback:**
```lua
local result = manager.media(nil, "audio", "audio", true, "music")
-- Plays all audio files in the "music" folder
```

### ScriptFolder Management

#### `manager.getScriptFolder()`
Gets or creates the scriptfolder in the workspace for organizing Roblox objects.

**Returns:**
- `Instance` - The scriptfolder instance or nil if creation failed

**Example:**
```lua
local scriptFolder = manager.getScriptFolder()
if scriptFolder then
    print("ScriptFolder found:", scriptFolder.Name)
end
```

#### `manager.cleanupScriptFolder()`
Destroys the entire scriptfolder and all its contents.

**Example:**
```lua
manager.cleanupScriptFolder() -- Cleans up all organized objects
```

#### `manager.listScriptFolderContents()`
Lists all contents in the scriptfolder with detailed information.

**Returns:**
- `table` - Array of objects with name, type, and children information

**Example:**
```lua
local contents = manager.listScriptFolderContents()
for _, item in ipairs(contents) do
    print("Found:", item.name, "Type:", item.type)
end
```

### System Diagnostics

#### `manager.nodefecth()`
Runs comprehensive system diagnostics and displays system information.

**Returns:**
- `table` - System information object

**Example:**
```lua
local systemInfo = manager.nodefecth()
-- Displays comprehensive system information including:
-- - Executor detection
-- - Game environment
-- - Filesystem capabilities
-- - HTTP/Network support
-- - GUI/Drawing capabilities
-- - Advanced executor features
-- - Memory/Performance stats
```

## 🎨 HTML to GUI Supported Elements

The library supports converting these HTML elements to Roblox GUI:

| HTML Element | Roblox GUI Equivalent | Supported Attributes |
|-------------|----------------------|---------------------|
| `<div>` | `Frame` | `style` |
| `<button>` | `TextButton` | `value`, `text`, `style` |
| `<input>` | `TextBox` | `placeholder`, `value`, `style` |
| `<label>` | `TextLabel` | `value`, `style` |
| `<h1>`, `<h2>`, `<h3>` | `TextLabel` | `value`, `style` |
| `<image>`, `<img>` | `ImageLabel` | `src`, `style` |
| `<list>`, `<ul>` | `ScrollingFrame` | `style` |

### Supported CSS Properties

- `background-color` - Background color (RGB, hex, named colors)
- `color` - Text color (RGB, hex, named colors)
- `width` - Element width in pixels
- `height` - Element height in pixels

### HTML Example

```html
<div style="background-color: rgb(40, 40, 40); width: 400; height: 300;">
    <h1 style="color: white;">Welcome to My App!</h1>
    <label style="color: white;">Enter your name:</label>
    <input placeholder="Your name here" style="background-color: rgb(60, 60, 60); color: white; width: 200; height: 25;"/>
    <button style="background-color: rgb(0, 120, 255); color: white; width: 100; height: 30;">Submit</button>
    <div style="background-color: rgb(20, 20, 20); width: 350; height: 100;">
        <label style="color: yellow;">This is a sample HTML to GUI conversion!</label>
    </div>
</div>
```

## 🔍 System Requirements

### Executor Requirements
- **Luau Support** - Modern Roblox executor with Luau language support
- **File System Access** - `writefile`, `readfile`, `isfile`, `listfiles`
- **HTTP Access** - `request` function or `game:HttpGet`
- **GUI Access** - `Instance.new`, `Drawing.new` (optional)

### Recommended Executors
- Wave
- Krnl
- Hydrogen

## 📝 Usage Examples

### Example 1: File Management System
```lua
local manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/displaynameroblox/localmaner/main/localmaner.lua"))()

-- Create configuration file
manager.new("config.json", '{"theme": "dark", "sound": true}')

-- Download user data
manager.download("https://api.example.com/user/123", "userdata.json", "GET")

-- Move backup files
manager.move("userdata.json", "backups/userdata_backup.json")
```

### Example 2: HTML Website Converter
```lua
local manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/displaynameroblox/localmaner/main/localmaner.lua"))()

-- Download a website and convert to GUI
local result = manager.html("https://example.com/dashboard.html", false, "dashboard.html", true)

-- Create a local HTML file and convert to GUI
local htmlContent = [[
    <div style="background-color: rgb(30, 30, 30); width: 500; height: 400;">
        <h1 style="color: white; text-align: center;">Dashboard</h1>
        <button style="background-color: green; color: white; width: 150; height: 40;">Start Game</button>
        <button style="background-color: red; color: white; width: 150; height: 40;">Settings</button>
    </div>
]]

manager.new("dashboard.html", htmlContent)
manager.html(nil, true, "dashboard.html", true)
```

### Example 3: System Diagnostics
```lua
local manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/displaynameroblox/localmaner/main/localmaner.lua"))()

-- Run system diagnostics
local systemInfo = manager.nodefecth()

-- Check specific capabilities
if systemInfo.filesystem.writefile then
    print("✅ File writing is supported")
else
    print("❌ File writing is not supported")
end

if systemInfo.http.request then
    print("✅ HTTP requests are supported")
else
    print("❌ HTTP requests are not supported")
end
```

## 🐛 Error Handling

The library includes comprehensive error handling using `pcall` throughout. All functions return descriptive error messages:

```lua
-- Example error handling
local result = manager.new("", "content") -- Empty path
print(result) -- "cannot create file, did you forget to add path?"

local result = manager.move("nonexistent.txt", "new.txt") -- File doesn't exist
print(result) -- "source file not found"
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Roblox Corporation for the Luau language
- The Roblox executor development community
- Contributors to the sUNC documentation standard

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/displaynameroblox/localmaner/issues) page
2. Create a new issue with detailed information
3. Include your executor information and error messages

---

**Made with ❤️ for the Roblox scripting community**


**hey uh, display was here i guess**