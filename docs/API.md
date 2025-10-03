# 📚 Local Manager Library - API Documentation
*keep in mind, any new stuff might not be here or not well documented*
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

### `manager.saveas(instance, path, debug, content)` ✅ PRODUCTION

**[PRODUCTION FUNCTION]** The enhanced implementation of saveas functionality with comprehensive error handling, debug mode, and support for multiple instance types.

**⚠️ Note:** This function has been completely rewritten from the deprecated version with new parameters and capabilities.

**Signature:**
```lua
function manager.saveas(instance: string, path: string, debug: boolean?, content: string?): string
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `instance` | `string` | ✅ | Type of instance to create ("Sound", "model", "image", "video", "script") |
| `path` | `string` | ✅ | File path where to save the instance |
| `debug` | `boolean` | ❌ | Enable debug mode for detailed error messages and error codes |
| `content` | `string` | ❌ | Content for script saving (required when instance is "script") |

**Returns:**
| Type | Description |
|------|-------------|
| `string` | Success message or error description with error codes (when debug enabled) |

**Supported Instance Types:**
- ✅ `"Sound"` - Creates a Sound instance (FULLY IMPLEMENTED)
- ✅ `"model"` - Saves Model instances as .rbxl/.rbxlx files (FULLY IMPLEMENTED)
- ✅ `"image"` - Saves ImageLabel/ImageButton/Decal/Texture instances (FULLY IMPLEMENTED)
- 🚧 `"video"` - Video saving (WORK IN PROGRESS)
- ✅ `"script"` - Saves Lua script content (FULLY IMPLEMENTED)

**Success Messages:**
- `"file saved successfully at path: [path]"` - Sound/Model/Image saved successfully
- `"successfully saved script file"` - Script saved successfully
- `"successfully saved script file in path: [path] with content length: [length]"` - Script saved (debug mode)

**Error Messages (Standard Mode):**
- `"cannot saveas, did you forget to add instance?."` - Missing instance parameter
- `"cannot saveas, missing required parameters"` - Missing required parameters
- `"cannot saveas, file already exists at path"` - Target file already exists
- `"failed to save model: invalid model instance"` - Invalid model for saving
- `"failed to save model: invalid file format"` - Wrong file format for model
- `"failed to save image: invalid image instance"` - Invalid image instance
- `"failed to save image: invalid file format"` - Wrong file format for image
- `"script saving requires content parameter"` - Missing content for script
- `"🚧 VIDEO SAVING - WORK IN PROGRESS! Coming soon!"` - Video saving not implemented
- `"unsupported instance type - Supported: Sound, script, model, image, video"` - Invalid instance type

**Error Messages (Debug Mode):**
- `"cannot saveas, missing parameters. instance: [instance] path: [path]"` - Detailed parameter info
- `"cannot saveas, file already exists at path: [path] data found: [data]"` - Detailed file conflict info
- `"failed to save model: tobesaved is not a Model instance. Type: [type]"` - Detailed model validation
- `"failed to save model: invalid path format. Expected .rbxl or .rbxlx, got: [path]"` - Detailed format validation
- `"failed to save image: tobesaved is not a valid image instance. Type: [type]"` - Detailed image validation
- `"failed to save image: invalid file format. Expected: [formats], got: [path]"` - Detailed format validation
- `"script saving requires content parameter - use manager.saveas('script', path, debug, content)"` - Detailed script guidance

**Example - Sound Saving:**
```lua
local result = manager.saveas("Sound", "sounds/music.mp3")
-- Returns: "file saved successfully at path: sounds/music.mp3"
```

**Example - Model Saving:**
```lua
local myModel = workspace:FindFirstChild("MyModel")
if myModel and myModel:IsA("Model") then
    local result = manager.saveas("model", "models/my_model.rbxl", false, myModel)
    -- Returns: "file saved successfully at path: models/my_model.rbxl"
end
```

**Example - Image Saving:**
```lua
local myImage = workspace:FindFirstChild("MyImage")
if myImage and myImage:IsA("ImageLabel") then
    local result = manager.saveas("image", "images/my_image.png", false, myImage)
    -- Returns: "file saved successfully at path: images/my_image.png"
end
```

**Example - Script Saving:**
```lua
local scriptContent = [[
print("Hello World")
local x = 10
print("Value:", x)
]]

local result = manager.saveas("script", "scripts/my_script.lua", false, scriptContent)
-- Returns: "successfully saved script file"
```

**Example - Debug Mode:**
```lua
-- Enable debug mode for detailed error information
local result = manager.saveas("model", "models/test.rbxl", true, myModel)
-- Returns detailed error codes and troubleshooting information if something goes wrong
```

**Implementation Notes:**
- ✅ PRODUCTION READY - All major instance types implemented
- Comprehensive error handling with automatic cleanup
- Debug mode provides error codes referencing TROUBLESHOOTING.md
- Model saving includes workspace cleanup and proper cloning
- Image saving supports multiple Roblox image instance types
- Script saving with automatic .lua extension handling
- Video saving marked as work in progress

**File Format Support:**
- **Models**: `.rbxl`, `.rbxlx`
- **Images**: `.png`, `.jpg`, `.jpeg`, `.gif`, `.bmp`, `.tiff`, `.ico`
- **Scripts**: `.lua` (auto-added if missing)
- **Sounds**: `.mp3`, `.wav`, `.ogg`, `.m4a`, `.aac`

**Debug Mode Features:**
- Error codes from TROUBLESHOOTING.md
- Detailed parameter validation information
- File content and format validation details
- Instance type and property validation
- Comprehensive error context for troubleshooting

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

### `manager.html(url, islocal, path, convertToGui, parentGui)` ✅ ENHANCED

Loads HTML content and optionally converts it to Roblox GUI elements using the enhanced HTML5 and CSS3 parser.

**⚠️ Enhanced:** Now uses comprehensive HTML5 and CSS3 support with advanced error handling and media element support.

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
| `Instance` | Roblox GUI instance (when `convertToGui` is true) |
| `string` | Error description with error codes (when debug mode enabled) |

**Enhanced Features:**
- ✅ **HTML5 Support**: Semantic elements (`section`, `article`, `aside`, `header`, `footer`, `main`, `nav`, `figure`, `figcaption`)
- ✅ **Media Elements**: `<video>` creates VideoFrame, `<audio>` creates Sound instances
- ✅ **Advanced CSS3**: Layout properties, transparency, borders, flexbox-like layouts
- ✅ **Form Enhancements**: HTML5 input types (`email`, `url`, `tel`, `search`, `number`, `range`, `color`, `date`, `time`)
- ✅ **Error Handling**: Comprehensive validation with error codes from TROUBLESHOOTING.md
- ✅ **Layout System**: UIListLayout integration for responsive designs

**Success Messages:**
- Returns Roblox GUI instance - When HTML is successfully converted to GUI
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
- `"HTMLToGUI: Conversion failed - [error]"` - When HTML parsing or GUI creation fails

**Example - Basic HTML5:**
```lua
-- Load HTML with HTML5 semantic elements
local result = manager.html("https://example.com/page.html", false, "downloaded.html", true)
-- Returns: Roblox GUI instance with semantic elements converted
```

**Example - HTML5 with CSS3:**
```lua
-- Load local HTML with advanced CSS
local result = manager.html(nil, true, "advanced.html", true)
-- Returns: Roblox GUI with CSS3 properties applied
```

**Example - Media Elements:**
```lua
-- HTML with video and audio elements
local htmlWithMedia = [[
<video src="video.mp4" controls></video>
<audio src="audio.mp3" controls></audio>
]]
local result = manager.html(nil, true, "media.html", true)
-- Creates VideoFrame for video and Sound instance for audio
```

**Example - Debug Mode:**
```lua
-- Enable debug mode for detailed error information
manager._DEBUG_MODE = true
local result = manager.html("https://example.com/page.html", false, "downloaded.html", true)
-- Returns detailed error codes and troubleshooting information if something goes wrong
```

**Supported HTML5 Elements:**
- **Semantic**: `section`, `article`, `aside`, `header`, `footer`, `main`, `nav`, `figure`, `figcaption`, `time`, `progress`, `meter`, `details`, `summary`, `wbr`
- **Media**: `video`, `audio`, `source`, `track`, `canvas`, `embed`, `object`
- **Forms**: `email`, `url`, `tel`, `search`, `number`, `range`, `color`, `date`, `time`, `datetime-local`, `month`, `week`, `file`, `datalist`, `output`, `fieldset`, `legend`
- **Advanced**: `progress`, `meter`, `details`, `summary`, `wbr`

**Supported CSS3 Properties:**
- **Layout**: `min-height`, `max-height`, `font-style`, `vertical-align`, `flex-direction`, `justify-content`, `align-items`
- **Colors**: Full hex, rgb, rgba support with Color3 conversion
- **Typography**: Enhanced font handling, text alignment, decorations
- **Spacing**: Margin, padding, border-radius with UDim2 conversion
- **Transparency**: Background and text transparency support
- **Borders**: Border size, color, and corner radius with UICorner

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

### `manager.media(_type, media, islocal, isroblox, debug)` ✅ ENHANCED

Handles media files including audio, video, image, and document playback with enhanced error handling and file format validation.

**⚠️ Enhanced:** Complete rewrite with new parameter structure, comprehensive file format validation, and improved error handling.

**Signature:**
```lua
function manager.media(_type: string, media: string, islocal: boolean, isroblox: boolean, debug: boolean?): Instance | string
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `_type` | `string` | ✅ | Media type ("Audio", "Video", "Image", "Document") |
| `media` | `string` | ✅ | File path (for local) or Roblox asset ID (for Roblox) |
| `islocal` | `boolean` | ✅ | Whether to load from local file |
| `isroblox` | `boolean` | ✅ | Whether to load from Roblox asset ID |
| `debug` | `boolean` | ❌ | Enable debug mode for detailed error messages |

**Returns:**
| Type | Description |
|------|-------------|
| `Instance` | Media instance (Sound, VideoFrame, ImageLabel, TextLabel) |
| `string` | Error description with error codes (when debug enabled) |

**Supported Media Types:**
- ✅ `"Audio"` - Audio files (.mp3, .acc, .wav, .ogg, .m4a)
- ✅ `"Video"` - Video files (.mp4, .mov, .avi, .wmv, .mkv)
- ✅ `"Image"` - Image files (.jpeg, .png, .gif, .webP)
- ✅ `"Document"` - Document files (.pdf, .doc, .txt, .rtf)

**Success Messages:**
- Returns media instance directly for successful operations

**Error Messages (Standard Mode):**
- `"cannot find media, did you forget to add media?"` - When `media` is nil
- `"cannot find type, did you forget to add type?"` - When `_type` is nil
- `"cannot find path to media, did you forget to add media?"` - When local media path is missing
- `"cannot find id of media, did you forget to add media?"` - When Roblox media ID is missing
- `"cannot find islocal, did you forget to set is local?"` - When `islocal` is nil
- `"cannot find isroblox, did you forget to set is roblox?"` - When `isroblox` is nil
- `"cannot load media, [type] is not a type of media."` - When `_type` is not supported
- `"cannot load audio, [path] is not a valid audio file format. Supported formats: [formats]"` - Invalid audio format
- `"cannot load video, [path] is not a valid video file format. Supported formats: [formats]"` - Invalid video format
- `"cannot load image, [path] is not a valid image file format. Supported formats: [formats]"` - Invalid image format
- `"cannot load document, [path] is not a valid document file format. Supported formats: [formats]"` - Invalid document format
- `"cannot play sound, [media] is not a valid sound."` - Invalid sound file
- `"cannot play video, [media] is not a valid video."` - Invalid video file
- `"cannot play image, [media] is not a valid image."` - Invalid image file
- `"cannot play document, [media] is not a valid document."` - Invalid document file

**Error Messages (Debug Mode):**
- `"cannot find media, did you forget to add media?. media found: [media] is local? [islocal]"` - Detailed media info
- `"cannot find type, did you to add type?. type found: [type]"` - Detailed type info
- `"cannot find path to media, did you forget to add media?. path found: [path]"` - Detailed path info
- `"cannot find id of media, did you forget to add media?. id found: [id]"` - Detailed ID info
- `"cannot find islocal, did you set is local?. islocal found: [islocal]"` - Detailed islocal info
- `"cannot find isroblox, did you forget to set is roblox?. isroblox found: [isroblox]"` - Detailed isroblox info

**Example - Local Audio File:**
```lua
local soundInstance = manager.media("Audio", "sounds/music.mp3", true, false)
-- Returns: Sound instance

-- Control the sound instance
if soundInstance then
    soundInstance.Volume = 0.8
    soundInstance:Play()
    soundInstance:Stop()
end
```

**Example - Roblox Audio Asset:**
```lua
local soundInstance = manager.media("Audio", "rbxassetid://123456789", false, true)
-- Returns: Sound instance with Roblox asset
```

**Example - Local Video File:**
```lua
local videoInstance = manager.media("Video", "videos/movie.mp4", true, false)
-- Returns: VideoFrame instance

-- Control the video instance
if videoInstance then
    videoInstance.Size = UDim2.new(0, 800, 0, 600)
    videoInstance:Play()
    videoInstance:Stop()
end
```

**Example - Local Image File:**
```lua
local imageInstance = manager.media("Image", "images/photo.png", true, false)
-- Returns: ImageLabel instance

-- Control the image instance
if imageInstance then
    imageInstance.Size = UDim2.new(0, 400, 0, 300)
    imageInstance.Position = UDim2.new(0.5, -200, 0.5, -150)
end
```

**Example - Local Document File:**
```lua
local documentInstance = manager.media("Document", "docs/readme.txt", true, false)
-- Returns: TextLabel instance with document content
```

**Example - Debug Mode:**
```lua
local result = manager.media("Audio", "invalid.mp3", true, false, true)
-- Returns detailed error information if something goes wrong
```

**File Format Support:**
- **Audio**: `.mp3`, `.acc`, `.wav`, `.ogg`, `.m4a`
- **Video**: `.mp4`, `.mov`, `.avi`, `.wmv`, `.mkv`
- **Image**: `.jpeg`, `.png`, `.gif`, `.webP`
- **Document**: `.pdf`, `.doc`, `.txt`, `.rtf`

**Implementation Notes:**
- ✅ **Enhanced Error Handling**: Comprehensive input validation and file format checking
- ✅ **File Format Validation**: Automatic validation of file extensions against supported formats
- ✅ **Debug Mode**: Detailed error messages with parameter information
- ✅ **Roblox Asset Support**: Full support for `rbxassetid://` URLs
- ✅ **Instance Creation**: Creates appropriate Roblox instances for each media type
- ✅ **Workspace Integration**: All instances are created in game.Workspace
- ✅ **Volume Control**: Audio and video instances have volume control
- ✅ **Playback Testing**: Automatic playback testing for audio and video files

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

**[EXPERIMENTAL FEATURE]** Converts Java code to Lua format and optionally executes it. This is a placeholder implementation that provides basic Java-like syntax recognition with enhanced error handling.

**⚠️ Warning:** This is an experimental function with limited Java parsing capabilities. It's primarily a proof-of-concept and may not handle complex Java code correctly. Enhanced with debug mode support.

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

**Error Messages (Standard Mode):**
- `"cannot find script, did you forget to add script?"` - When `scripted` is nil
- `"cannot convert java to lua, did you forget to add doexecute parameter?"` - When `doexecute` is nil
- `"invalid script content, please provide a valid string"` - When script content is invalid
- `"failed to process script: [error]"` - When script processing fails
- `"failed to execute converted script: [error]"` - When script execution fails

**Error Messages (Debug Mode):**
- `"cannot find script, did you forget to add script?: [scripted]"` - When `scripted` is nil (debug mode)
- `"cannot convert java to lua, did you forget to add doexecute parameter?: [doexecute]"` - When `doexecute` is nil (debug mode)
- `"invalid script content, please provide a valid string - content type: [type], length: [length]"` - When script content is invalid (debug mode)
- `"failed to process script: [error] - script length: [length]"` - When script processing fails (debug mode)
- `"failed to execute converted script: [error] - converted code: [code]"` - When script execution fails (debug mode)

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

**Example - Debug Mode:**
```lua
-- Enable debug mode for detailed error information
manager._DEBUG_MODE = true
local result, luaCode = manager.javatolua(javaCode, false)
-- Returns detailed error codes and troubleshooting information if something goes wrong
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
