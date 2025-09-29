# 📚 Local Manager Library - API Documentation

Complete API reference for the Local Manager Library.

## Table of Contents

- [File Operations](#file-operations)
- [HTTP Operations](#http-operations)
- [HTML to GUI Conversion](#html-to-gui-conversion)
- [Media Operations](#media-operations)
- [ScriptFolder Management](#scriptfolder-management)
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

### `manager.dfile(path, isundo, undofile)`

Deletes files with undo functionality or restores files from backup.

**Signature:**
```lua
function manager.dfile(path: string, isundo: boolean, undofile: string?): string
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `path` | `string` | ✅ | Path of the file to delete/restore |
| `isundo` | `boolean` | ✅ | If true, restores file; if false, deletes file |
| `undofile` | `string` | ❌ | Path for undo backup file (auto-generated if not provided) |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message or error description |

**Success Messages:**
- `"file deleted successfully, undo backup created at: [path]"` - File deleted with backup
- `"file restored successfully from undo backup"` - File restored from backup

**Error Messages:**
- `"cannot delete file, did you forget to add path?"` - Missing file path
- `"cannot undo file deletion, did you forget to add undo file path?"` - Missing undo file path
- `"file not found: [path]"` - File doesn't exist
- `"undo file not found: [path]"` - Undo backup doesn't exist
- `"failed to read file: [error]"` - File read error
- `"failed to read undo file: [error]"` - Undo file read error
- `"failed to create undo backup: [error]"` - Backup creation error
- `"failed to delete file: [error]"` - File deletion error
- `"failed to restore file: [error]"` - File restoration error

**Example - Delete File with Auto Backup:**
```lua
local result = manager.dfile("config.json", false)
-- Returns: "file deleted successfully, undo backup created at: config.json.undo"
```

**Example - Delete File with Custom Backup:**
```lua
local result = manager.dfile("data.txt", false, "backups/data_backup.txt")
-- Returns: "file deleted successfully, undo backup created at: backups/data_backup.txt"
```

**Example - Restore File:**
```lua
local result = manager.dfile("config.json", true, "config.json.undo")
-- Returns: "file restored successfully from undo backup"
```

### `manager.saveas(path, content, type)`

Saves content as a specific type of instance (Sound, Model, etc.) in the game environment.

**Signature:**
```lua
function manager.saveas(path: string, content: string, type: string): string
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `path` | `string` | ✅ | File path where to save the instance |
| `content` | `string` | ✅ | Content to save (binary/text data) |
| `type` | `string` | ✅ | Type of instance to create ("Sound", "Model", "Script", "Image") |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message or error description |

**Supported Types:**
- `"Sound"` - Creates a Sound instance (fully implemented)
- `"Model"` - Reserved for future implementation
- `"Script"` - Reserved for future implementation
- `"Image"` - Reserved for future implementation

**Success Messages:**
- `"file saved successfully as Sound"` - When Sound instance is created and saved

**Error Messages:**
- `"cannot save file, did you forget to add path?"` - When `path` is nil or empty
- `"cannot save file without content"` - When `content` is nil or empty
- `"cannot save file without type specification"` - When `type` is nil or empty
- `"unsupported save type: [type]"` - When type is not in supported types list
- `"file already exists at path: [path]"` - When target file already exists
- `"failed to save Sound file: [details]"` - When Sound creation/saving fails
- `"save type '[type]' is recognized but not yet implemented"` - When using a reserved type

**Example - Save Sound File:**
```lua
-- Read an audio file
local audioData = readfile("audio.mp3")

-- Save it as a Sound instance
local result = manager.saveas("sounds/music.mp3", audioData, "Sound")
-- Returns: "file saved successfully as Sound"
```

**Example - Error Handling:**
```lua
-- Try to save with unsupported type
local result = manager.saveas("test.txt", "content", "InvalidType")
-- Returns: "unsupported save type: InvalidType. Supported types: Sound, Model, Script, Image"

-- Try to save to existing file
local result = manager.saveas("existing.mp3", audioData, "Sound")
-- Returns: "file already exists at path: existing.mp3"
```

**Implementation Notes:**
- Sound instances are created using `Instance.new("Sound")`
- Custom assets are created using `getcustomasset`
- Files are written using `writecustomasset` (if available) or `writefile`
- The function uses nested `pcall` blocks for comprehensive error handling
- Future type implementations will follow the same pattern but with type-specific logic

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
- `"HTML converted to GUI successfully"` - When HTML is successfully converted to GUI
- Returns HTML content as string - When HTML is loaded without GUI conversion

**Error Messages:**
- `"cannot handle html, did you forget to add path?"` - When `path` is nil
- `"i won't classify that you are a programmer, put the url and the path, and say if it local or not. dont keep it empty"` - When both `islocal` and `url` are false/nil
- `"file not found, did you type the path wrong?"` - When local file doesn't exist
- `"failed to read local file"` - When local file cannot be read
- `"cannot find url, did you forget to add url?"` - When URL is nil but not local
- `"cannot find url, or it's offline"` - When URL request fails or URL is offline
- `"received empty response from server"` - When server returns empty content
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

## Media Operations

### `manager.media(path, type, typeofmedia, isfolder, folder)`

Handles media files including audio playback for single files or entire folders.

**Signature:**
```lua
function manager.media(path: string?, type: string, typeofmedia: string, isfolder: boolean?, folder: string?): (string, Instance?)
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `path` | `string` | ❌ | File path (ignored when `isfolder` is true) |
| `type` | `string` | ✅ | Media type category |
| `typeofmedia` | `string` | ✅ | Specific media type ("audio", "video", "image", "document") |
| `isfolder` | `boolean` | ❌ | Whether to process a folder of files |
| `folder` | `string` | ❌ | Folder path (required when `isfolder` is true) |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message, error description, or file content |
| `Instance?` | Media instance (Sound for audio, VideoFrame for video) - second return value |

**Supported Media Types:**
- `"audio"` - Audio files (.mp3, .wav, .ogg, .m4a, .aac)
- `"video"` - Video files (**EXPERIMENTAL** - this is still experimental you may see errors)
- `"image"` - Image files (returns content)
- `"document"` - Document files (returns content)

**Success Messages:**
- `"media played successfully"` - Single audio file played
- `"video played successfully"` - Single video file played (**EXPERIMENTAL**)
- `"played X/Y audio files from folder successfully"` - Folder playback results
- Returns file content for non-audio/video media types

**Error Messages:**
- `"cannot handle media, did you forget to add path?"` - When `path` is nil or empty
- `"cannot handle media, did you forget to add type?"` - When `type` is nil or empty
- `"cannot handle media, did you forget to add typeofmedia?"` - When `typeofmedia` is nil or empty
- `"invalid media type"` - When `typeofmedia` is not supported
- `"failed to read video file"` - When video file cannot be read (**EXPERIMENTAL**)
- `"failed to play video"` - When video playback fails (**EXPERIMENTAL**)
- `"cannot handle media folder, did you forget to add folder path?"` - When folder path is missing
- `"folder not found: [folder]"` - When specified folder doesn't exist
- `"failed to list files in folder"` - When folder access fails
- `"no audio files found in folder"` - When folder contains no audio files
- `"failed to read media file"` - When single file cannot be read
- `"failed to get custom asset for audio"` - When audio asset creation fails
- `"failed to play audio"` - When audio playback fails

**Example - Single Audio File:**
```lua
local result, soundInstance = manager.media("song.mp3", "audio", "audio", false)
-- Returns: "media played successfully", soundInstance
-- soundInstance is a Sound object that you can control

-- Control the sound instance
if soundInstance then
    soundInstance.Volume = 0.8
    soundInstance.Pitch = 1.2
    soundInstance:Pause()
    soundInstance:Resume()
    soundInstance:Stop()
end
```

**Example - Single Video File (EXPERIMENTAL):**
```lua
local result, videoInstance = manager.media("video.mp4", "video", "video", false)
-- Returns: "video played successfully", videoInstance (EXPERIMENTAL - this is still experimental you may see errors)
-- videoInstance is a VideoFrame object that you can control

-- Control the video instance
if videoInstance then
    videoInstance.Size = UDim2.new(0, 800, 0, 600) -- Resize video
    videoInstance.Position = UDim2.new(0, 100, 0, 100) -- Reposition video
    videoInstance:Pause()
    videoInstance:Resume()
    videoInstance:Stop()
end
```

**Example - Folder Audio Playback:**
```lua
local result = manager.media(nil, "audio", "audio", true, "music")
-- Returns: "played 5/5 audio files from folder successfully"
```

**Example - Image File:**
```lua
local result = manager.media("image.png", "image", "image", false)
-- Returns: Binary content of the image file
```

**Example - Document File:**
```lua
local result = manager.media("document.txt", "document", "document", false)
-- Returns: Text content of the document
```

---

## ScriptFolder Management

### `manager.getScriptFolder()`

Gets or creates the scriptfolder in the workspace for organizing Roblox objects.

**Signature:**
```lua
function manager.getScriptFolder(): Instance?
```

**Parameters:** None

**Returns:**
| Type | Description |
|------|-------------|
| `Instance` | The scriptfolder instance or nil if creation failed |

**Example:**
```lua
local scriptFolder = manager.getScriptFolder()
if scriptFolder then
    print("ScriptFolder found:", scriptFolder.Name)
end
```

---

### `manager.cleanupScriptFolder()`

Destroys the entire scriptfolder and all its contents.

**Signature:**
```lua
function manager.cleanupScriptFolder(): ()
```

**Parameters:** None

**Returns:** None (prints cleanup status)

**Example:**
```lua
manager.cleanupScriptFolder() -- Prints: "🧹 Cleaned up scriptfolder"
```

---

### `manager.listScriptFolderContents()`

Lists all contents in the scriptfolder with detailed information.

**Signature:**
```lua
function manager.listScriptFolderContents(): table
```

**Parameters:** None

**Returns:**
| Type | Description |
|------|-------------|
| `table` | Array of objects with name, type, and children information |

**Example:**
```lua
local contents = manager.listScriptFolderContents()
for _, item in ipairs(contents) do
    print("Found:", item.name, "Type:", item.type)
end
```

---

### `manager.createScriptFolderStructure()`

Creates the organized subfolder structure within the scriptfolder.

**Signature:**
```lua
function manager.createScriptFolderStructure(): string
```

**Parameters:** None

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message with count of created folders |

**Creates Subfolders:**
- `Audio` - Audio files and sounds
- `GUIs` - GUI elements
- `Media` - Media files
- `Config` - Configuration
- `Logs` - Log files
- `Temp` - Temporary files

**Example:**
```lua
local result = manager.createScriptFolderStructure()
-- Returns: "created 6 subfolders in scriptfolder"
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

### Save Operation Errors

| Error Pattern | Cause | Solution |
|---------------|-------|----------|
| `"cannot save file, did you forget to add path?"` | Missing file path | Provide a valid file path |
| `"cannot save file without content"` | Missing content | Provide content to save |
| `"cannot save file without type specification"` | Missing type parameter | Specify a supported type (e.g., "Sound") |
| `"unsupported save type: [type]"` | Invalid type specified | Use one of: Sound, Model, Script, Image |
| `"file already exists at path: [path]"` | Target file exists | Use a different path or delete existing file |
| `"failed to save Sound file: [details]"` | Sound creation failed | Check file format and executor capabilities |
| `"save type '[type]' is recognized but not yet implemented"` | Using reserved type | Only use fully implemented types (currently "Sound") |

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
