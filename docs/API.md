# 📚 Local Manager Library - API Documentation

Complete API reference for the Local Manager Library.

## Table of Contents

- [File Operations](#file-operations)
- [HTTP Operations](#http-operations)
- [HTML to GUI Conversion](#html-to-gui-conversion)
- [Media Operations](#media-operations)
- [ScriptFolder Management](#scriptfolder-management)
- [Script Conversion](#script-conversion)
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

### `manager.changefile(path, newdata)`

Changes the content of an existing file and returns the old content for backup purposes.

**Signature:**
```lua
function manager.changefile(path: string, newdata: string): (string, string)
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `path` | `string` | ✅ | Path of the file to modify |
| `newdata` | `string` | ✅ | New content to write to the file |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message or error description |
| `string` | Old file content (second return value) |

**Success Messages:**
- `"file changed successfully"` - File content updated successfully

**Error Messages:**
- `"cannot readfile, did you forget to add path?: [path]"` - When `path` is nil
- `"cannot changefile, did you forget to add newdata?: [newdata]"` - When `newdata` is nil
- `"file not found: [path]"` - When file doesn't exist
- `"failed to read file: [error]"` - When file cannot be read
- `"failed to write new data: [error]"` - When new content cannot be written

**Example:**
```lua
-- Change file content and get the old data back
local success, oldData = manager.changefile("config.json", '{"setting": "new_value"}')
print(success) -- "file changed successfully"
print(oldData) -- The previous content of the file
```

---

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

### `manager.saveas(path, content, type)` ⚠️ DEPRECATED

**[DEPRECATED FUNCTION]** This function has been deprecated and now returns an error message directing users to use the new implementation.

**⚠️ Warning:** This function is no longer functional and will always return an error message.

**Current Behavior:** Always returns `"try using the new saveas: manager.newsaveas"`

**Signature:**
```lua
function manager.saveas(path: string, content: string|table|userdata, type: string): string
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `path` | `string` | ✅ | File path where to save the instance |
| `content` | `string\|table\|userdata` | ✅ | Content to save (varies by type) |
| `type` | `string` | ✅ | Type of instance to create ("Sound", "Model", "Script", "Image") |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Always returns `"try using the new saveas: manager.newsaveas"` |

**Error Messages:**
- `"try using the new saveas: manager.newsaveas"` - Always returned (deprecated function)

**Example - Deprecated Function:**
```lua
-- This function is deprecated and always returns an error message
local result = manager.saveas("sounds/music.mp3", audioData, "Sound")
-- Returns: "try using the new saveas: manager.newsaveas"

-- Note: Use manager.newsaveas instead (when implemented)
```

### `manager.newsaveas(instance, path, moredebug)` ⚠️ EXPERIMENTAL

**[EXPERIMENTAL FEATURE]** The new implementation of saveas functionality. This function is designed to replace the deprecated `manager.saveas` function with improved error handling and debugging capabilities.

**⚠️ Warning:** This function is currently under development and may not be fully implemented in the main library yet.

**Signature:**
```lua
function manager.newsaveas(instance: string, path: string, moredebug: boolean?): string
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `instance` | `string` | ✅ | Type of instance to create ("Sound", "video", "model", "script") |
| `path` | `string` | ✅ | File path where to save the instance |
| `moredebug` | `boolean` | ❌ | Enable debug mode for detailed error messages |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message or error description |

**Supported Instance Types:**
- `"Sound"` - Creates a Sound instance (IMPLEMENTED - experimental)
- `"video"` - Video handling (COMING SOON)
- `"model"` - Model handling (COMING SOON)
- `"script"` - Script handling (COMING SOON)

**Success Messages:**
- `"file saved successfully at path: [path]"` - File saved successfully

**Error Messages:**
- `"cannot saveas, did you forget to add instance?."` - When `instance` is nil or empty
- `"cannot saveas, did you forget to add instance?. instance found: [instance] path found: [path]"` - Debug mode version
- `"cannot saveas, file already exists at path"` - When target file already exists
- `"cannot saveas, file already exists at path: [path]data found[data]"` - Debug mode version
- `"file already exists, cannot overwire file"` - When trying to overwrite existing file
- `"cannot saveas, more coming soon![path],[debug]"` - When using unsupported instance types
- `"failed to save file at path"` - When file saving fails
- `"failed to save file at path: [path]error: [error]"` - Debug mode version

**Example - Basic Usage:**
```lua
-- Save a Sound instance
local result = manager.newsaveas("Sound", "sounds/music.mp3")
-- Returns: "file saved successfully at path: sounds/music.mp3"
```

**Example - With Debug Mode:**
```lua
-- Save with debug information
local result = manager.newsaveas("Sound", "sounds/music.mp3", true)
-- Returns detailed error messages if something goes wrong
```

**Example - Error Handling:**
```lua
-- Try with missing instance type
local result = manager.newsaveas(nil, "test.mp3")
-- Returns: "cannot saveas, did you forget to add instance?."

-- Try with unsupported type
local result = manager.newsaveas("video", "test.mp4")
-- Returns: "cannot saveas, more coming soon!test.mp4,false"
```

**Implementation Notes:**
- ⚠️ EXPERIMENTAL IMPLEMENTATION
- Currently only supports Sound instances
- Uses `writecustomasset` for Sound creation (Wave executor specific)
- Debug mode provides detailed error information
- Other instance types are planned but not yet implemented
- Function may not be available in main library yet (check separate saveas.lua file)

**Known Limitations:**
1. Only Sound instances are currently implemented
2. May not be exposed through manager object yet
3. Debug mode may not work on all executors
4. Custom asset creation is executor-dependent
5. Other instance types are not yet supported

### `manager.checkSaveasCapabilities()`

Checks which saveas features are supported by the current executor environment.

**Signature:**
```lua
function manager.checkSaveasCapabilities(): table
```

**Returns:**
| Type | Description |
|------|-------------|
| `table` | Capabilities object with boolean values for each feature |

**Capabilities Object:**
```lua
{
    Sound = boolean,           -- Sound instance creation support
    Model = boolean,           -- Model instance creation support
    Script = boolean,          -- Script file writing support
    Image = boolean,           -- Image file writing support
    InstanceCreation = boolean, -- General instance creation support
    CustomAssets = boolean,    -- Custom asset creation support
    FileWriting = boolean      -- File writing support
}
```

**Example:**
```lua
local capabilities = manager.checkSaveasCapabilities()

if capabilities.Sound then
    print("✅ Sound saving is supported")
else
    print("❌ Sound saving is not supported")
end

if capabilities.InstanceCreation then
    print("✅ Instance creation is supported")
else
    print("❌ Instance creation is not supported")
end
```

**Implementation Notes:**
- ⚠️ EXPERIMENTAL IMPLEMENTATION
- Sound instances are created using `Instance.new("Sound")` (executor-dependent)
- Custom assets are created using `getcustomasset` (may not work on all executors)
- Files are written using `writefile` with comprehensive error handling
- The function uses nested `pcall` blocks for robust error handling
- Automatic cleanup on failure (removes files if instance creation fails)
- Instance organization in scriptfolder when available
- Case-insensitive type parameter handling
- Content validation for each type

**Known Limitations:**
1. Sound creation may fail on certain executors
2. Custom asset creation is highly dependent on executor capabilities
3. Model saving is highly experimental and may not work properly
4. Some executors may not support all required functions
5. May conflict with game anti-cheat systems
6. Performance impact not fully tested

**Testing Status:**
- Sound: Limited testing on major executors
- Model: Very limited testing, highly experimental
- Script/Image: Basic file writing only, no instance creation yet
- Behavior in game environments varies significantly

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

## Script Conversion

### `manager.javatolua(scripted, doexecute)` ⚠️ EXPERIMENTAL

**[EXPERIMENTAL FEATURE]** Converts Java code to Lua format and optionally executes it. This is a placeholder implementation that provides basic Java-like syntax recognition.

**⚠️ Warning:** This is an experimental function with limited Java parsing capabilities. It's primarily a proof-of-concept and may not handle complex Java code correctly.

**Signature:**
```lua
function manager.javatolua(scripted: string, doexecute: boolean): (string, string?)
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `scripted` | `string` | ✅ | Java code to convert to Lua |
| `doexecute` | `boolean` | ✅ | Whether to execute the converted Lua code |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message or error description |
| `string?` | Converted Lua code (second return value) |

**Success Messages:**
- `"java to lua conversion completed successfully"` - Conversion completed without execution
- `"java to lua conversion completed successfully"` - Conversion and execution completed

**Error Messages:**
- `"cannot find script, did you forget to add script?: [scripted]"` - When `scripted` is nil
- `"cannot convert java to lua, did you forget to add doexecute parameter?: [doexecute]"` - When `doexecute` is nil
- `"invalid script content, please provide a valid string"` - When script content is invalid
- `"failed to process script: [error]"` - When script processing fails
- `"failed to execute converted script: [error]"` - When script execution fails

**Example - Convert Without Execution:**
```lua
local javaCode = [[
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
]]

local result, luaCode = manager.javatolua(javaCode, false)
-- Returns: "java to lua conversion completed successfully", converted Lua code
print("Converted code:", luaCode)
```

**Example - Convert and Execute:**
```lua
local javaCode = "print('Hello from Java-like code')"
local result = manager.javatolua(javaCode, true)
-- Returns: "java to lua conversion completed successfully"
```

**Implementation Notes:**
- ⚠️ EXPERIMENTAL IMPLEMENTATION
- Currently only recognizes basic Java keywords (`class`, `public`, `private`)
- Conversion is a placeholder - actual Java parsing not implemented
- Uses `loadstring()` for execution (executor-dependent)
- Limited error handling for complex Java syntax
- May not work correctly with all Java code structures

**Known Limitations:**
1. No actual Java parser - just keyword recognition
2. Complex Java syntax not supported
3. No AST transformation
4. Limited error reporting
5. Execution depends on executor capabilities
6. Placeholder conversion logic

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
