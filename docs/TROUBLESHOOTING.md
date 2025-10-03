# 🔧 Troubleshooting Guide - Local Manager Library
# ✅ Error codes now available in v2.0.0 with debug mode support

Complete troubleshooting guide for resolving issues with the Local Manager Library.

## 📋 Table of Contents

- [Quick Diagnostics](#quick-diagnostics)
- [Error Codes Reference](#error-codes-reference)
- [File Operations Issues](#file-operations-issues)
- [File Deletion Issues](#file-deletion-issues)
- [Save Operations Issues](#save-operations-issues)
- [Script Conversion Issues](#script-conversion-issues)
- [HTTP/Network Issues](#httpnetwork-issues)
- [HTML to GUI Issues](#html-to-gui-issues)
- [Media Operations Issues](#media-operations-issues)
- [System Diagnostics Issues](#system-diagnostics-issues)
- [Executor-Specific Issues](#executor-specific-issues)
- [Performance Issues](#performance-issues)
- [Advanced Troubleshooting](#advanced-troubleshooting)

---

## 🚨 Quick Diagnostics

### Step 1: Run System Check
```lua
local manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/displaynameroblox/localmaner/main/localmaner.lua"))()
local systemInfo = manager.nodefecth()
```

### Step 2: Check Basic Functionality
```lua
-- Test file creation
local result = manager.new("test.txt", "test content")
print("File creation:", result)

-- Test HTTP (if available)
if systemInfo.http.request then
    local result = manager.download("https://httpbin.org/get", "test.json", "GET")
    print("HTTP test:", result)
end
```

### Step 3: Verify Environment
```lua
-- Check if you're in a valid Roblox game
if game and game.Players and game.Players.LocalPlayer then
    print("✅ Valid Roblox environment")
else
    print("❌ Invalid environment - not in Roblox game")
end
```

---

## 📊 Error Codes Reference

### File Operations Error Codes

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_FILE_PATH_MISSING` | Cannot create file, did you forget to add path? | Empty or nil path parameter | Provide valid file path |
| `ERR_FILE_DATA_MISSING` | Cannot create file, did you forget to add data? | Empty or nil data parameter | Provide file content |
| `ERR_FILE_CREATE_FAILED` | Failed to create file | Permission issues, invalid path | Check path validity and permissions |
| `ERR_FILE_MOVE_SOURCE_MISSING` | Cannot move file, did you forget to add source path? | Missing source path | Provide source file path |
| `ERR_FILE_MOVE_DEST_MISSING` | Cannot move file, did you forget to add destination path? | Missing destination path | Provide destination file path |
| `ERR_FILE_NOT_FOUND` | Source file not found | File doesn't exist | Verify file exists and path is correct |
| `ERR_FILE_EXISTS` | Destination file already exists | Target file already exists | Delete existing file or use different name |
| `ERR_FILE_READ_FAILED` | Failed to read source file | File corruption, permission issues | Check file integrity and permissions |
| `ERR_FILE_WRITE_FAILED` | Failed to write to destination file | Disk space, permission issues | Check disk space and permissions |
| `ERR_FILE_DELETE_FAILED` | Failed to delete source file | File in use, permission issues | Close file handles and check permissions |
| `ERR_FILE_CHANGE_PATH_MISSING` | Cannot readfile, did you forget to add path? | Missing file path for changefile | Provide valid file path |
| `ERR_FILE_CHANGE_DATA_MISSING` | Cannot changefile, did you forget to add newdata? | Missing new data for changefile | Provide new file content |
| `ERR_FILE_CHANGE_NOT_FOUND` | File not found: [path] | File doesn't exist for changefile | Verify file exists before changing |
| `ERR_FILE_CHANGE_READ_FAILED` | Failed to read file: [error] | File read error during changefile | Check file permissions and integrity |
| `ERR_FILE_CHANGE_WRITE_FAILED` | Failed to write new data: [error] | File write error during changefile | Check write permissions and disk space |

### HTTP Operations Error Codes

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_HTTP_URL_MISSING` | Cannot download file, did you forget to add the url? | Missing URL parameter | Provide valid URL |
| `ERR_HTTP_PATH_MISSING` | Cannot download file, did you forget to add path? | Missing save path | Provide local file path |
| `ERR_HTTP_BOTH_MISSING` | You fucking idiot, how the fuck did you get this far?. put the url and the path | Both URL and path missing | Provide both URL and path |
| `ERR_HTTP_REQUEST_FAILED` | Failed to download file | Network issues, invalid URL | Check internet connection and URL |
| `ERR_HTTP_INVALID_RESPONSE` | Invalid response from server | Server error, malformed response | Try different URL or check server status |
| `ERR_HTTP_SAVE_FAILED` | Failed to save file | Disk space, permission issues | Check disk space and permissions |

### HTML to GUI Error Codes (v2.0.0 Enhanced)

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_HTML_PATH_MISSING` | Cannot handle html, did you forget to add path? | Missing path parameter | Provide file path |
| `ERR_HTML_PARAMS_MISSING` | I won't classify that you are a programmer, put the url and the path, and say if it local or not | Missing required parameters | Provide URL/path and islocal parameter |
| `ERR_HTML_FILE_NOT_FOUND` | File not found, did you type the path wrong? | Local file doesn't exist | Check file path and existence |
| `ERR_HTML_READ_FAILED` | Failed to read local file | File corruption, permission issues | Check file integrity |
| `ERR_HTML_URL_MISSING` | Cannot find url, did you forget to add url? | Missing URL for online mode | Provide valid URL |
| `ERR_HTML_DOWNLOAD_FAILED` | Cannot find url, or it's offline | Network issues, invalid URL | Check internet and URL |
| `ERR_HTML_EMPTY_RESPONSE` | Received empty response from server | Server returns empty content | Check server status and URL |
| `ERR_HTML_NO_CONTENT` | No HTML content available | Empty response or file | Check source content |
| `ERR_HTML_CONVERSION_FAILED` | HTMLToGUI: Conversion failed - [error] | HTML parsing error, GUI creation failed | Check HTML syntax and GUI permissions |
| `ERR_HTML_PARSING_FAILED` | HTMLToGUI: Failed to parse HTML - [error] | Malformed HTML, parsing depth exceeded | Check HTML structure and nesting |
| `ERR_HTML_CSS_PARSING_FAILED` | HTMLToGUI: Failed to parse CSS - [error] | Invalid CSS syntax | Check CSS syntax and properties |
| `ERR_HTML_GUI_CREATION_FAILED` | HTMLToGUI: Failed to create GUI instance - [error] | GUI creation failed | Check Roblox environment and permissions |
| `ERR_HTML_ATTRIBUTE_PARSING_FAILED` | HTMLToGUI: Failed to parse attributes - [error] | Invalid HTML attributes | Check HTML attribute syntax |
| `ERR_HTML_MEDIA_ELEMENT_FAILED` | HTMLToGUI: Failed to create media element - [error] | Media element creation failed | Check media file paths and formats |
| `ERR_HTML_LAYOUT_SETUP_FAILED` | HTMLToGUI: Failed to setup layout - [error] | Layout system failure | Check CSS layout properties |

### Media Operations Error Codes (v2.0.0 Enhanced)

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_MEDIA_MEDIA_MISSING` | Cannot find media, did you forget to add media? | Missing media parameter | Provide file path or Roblox asset ID |
| `ERR_MEDIA_MEDIA_MISSING_DEBUG` | Cannot find media, did you forget to add media?. media found: [media] is local? [islocal] | Missing media parameter (debug mode) | Provide file path or Roblox asset ID |
| `ERR_MEDIA_TYPE_MISSING` | Cannot find type, did you forget to add type? | Missing _type parameter | Provide media type ("Audio", "Video", "Image", "Document") |
| `ERR_MEDIA_TYPE_MISSING_DEBUG` | Cannot find type, did you to add type?. type found: [type] | Missing _type parameter (debug mode) | Provide media type |
| `ERR_MEDIA_PATH_MISSING` | Cannot find path to media, did you forget to add media? | Missing local media path | Provide local file path |
| `ERR_MEDIA_PATH_MISSING_DEBUG` | Cannot find path to media, did you forget to add media?. path found: [path] | Missing local media path (debug mode) | Provide local file path |
| `ERR_MEDIA_ID_MISSING` | Cannot find id of media, did you forget to add media? | Missing Roblox media ID | Provide Roblox asset ID |
| `ERR_MEDIA_ID_MISSING_DEBUG` | Cannot find id of media, did you forget to add media?. id found: [id] | Missing Roblox media ID (debug mode) | Provide Roblox asset ID |
| `ERR_MEDIA_ISLOCAL_MISSING` | Cannot find islocal, did you forget to set is local? | Missing islocal parameter | Provide boolean value for local file |
| `ERR_MEDIA_ISLOCAL_MISSING_DEBUG` | Cannot find islocal, did you set is local?. islocal found: [islocal] | Missing islocal parameter (debug mode) | Provide boolean value for local file |
| `ERR_MEDIA_ISROBLOX_MISSING` | Cannot find isroblox, did you forget to set is roblox? | Missing isroblox parameter | Provide boolean value for Roblox asset |
| `ERR_MEDIA_ISROBLOX_MISSING_DEBUG` | Cannot find isroblox, did you forget to set is roblox?. isroblox found: [isroblox] | Missing isroblox parameter (debug mode) | Provide boolean value for Roblox asset |
| `ERR_MEDIA_INVALID_TYPE` | Cannot load media, [type] is not a type of media. | Unsupported media type | Use "Audio", "Video", "Image", or "Document" |
| `ERR_MEDIA_AUDIO_FORMAT_INVALID` | Cannot load audio, [path] is not a valid audio file format. Supported formats: [formats] | Invalid audio file extension | Use .mp3, .acc, .wav, .ogg, or .m4a |
| `ERR_MEDIA_VIDEO_FORMAT_INVALID` | Cannot load video, [path] is not a valid video file format. Supported formats: [formats] | Invalid video file extension | Use .mp4, .mov, .avi, .wmv, or .mkv |
| `ERR_MEDIA_IMAGE_FORMAT_INVALID` | Cannot load image, [path] is not a valid image file format. Supported formats: [formats] | Invalid image file extension | Use .jpeg, .png, .gif, or .webP |
| `ERR_MEDIA_DOCUMENT_FORMAT_INVALID` | Cannot load document, [path] is not a valid document file format. Supported formats: [formats] | Invalid document file extension | Use .pdf, .doc, .txt, or .rtf |
| `ERR_MEDIA_AUDIO_INVALID` | Cannot play sound, [media] is not a valid sound. | Invalid audio file or Roblox asset | Check audio file integrity and format |
| `ERR_MEDIA_VIDEO_INVALID` | Cannot play video, [media] is not a valid video. | Invalid video file or Roblox asset | Check video file integrity and format |
| `ERR_MEDIA_IMAGE_INVALID` | Cannot play image, [media] is not a valid image. | Invalid image file or Roblox asset | Check image file integrity and format |
| `ERR_MEDIA_DOCUMENT_INVALID` | Cannot play document, [media] is not a valid document. | Invalid document file or Roblox asset | Check document file integrity and format |

### ScriptFolder Management Error Codes

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_SCRIPTFOLDER_CREATE_FAILED` | Failed to create scriptfolder | Workspace access denied, GUI creation not supported | Check executor GUI permissions and Roblox environment |

### Save Operations Error Codes

#### Deprecated `manager.saveas()` Function

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_SAVEAS_DEPRECATED` | Try using the new saveas: manager.newsaveas | Using deprecated function | Use manager.newsaveas instead |

#### Enhanced `manager.saveas()` Function (v2.0.0)

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_SAVEAS_INSTANCE_MISSING` | Cannot saveas, did you forget to add instance? | Missing instance parameter | Provide instance type (Sound, model, image, video, script) |
| `ERR_SAVEAS_INSTANCE_MISSING_DEBUG` | Cannot saveas, missing parameters. instance: [instance] path: [path] | Missing instance parameter (debug mode) | Provide instance type and check parameters |
| `ERR_SAVEAS_FILE_EXISTS` | Cannot saveas, file already exists at path | Target file already exists | Use different path or delete existing file |
| `ERR_SAVEAS_FILE_EXISTS_DEBUG` | Cannot saveas, file already exists at path: [path] data found: [data] | Target file already exists (debug mode) | Use different path or delete existing file |
| `ERR_SAVEAS_MODEL_INVALID` | Failed to save model: invalid model instance | Invalid model for saving | Ensure tobesaved is a Model instance |
| `ERR_SAVEAS_MODEL_INVALID_DEBUG` | Failed to save model: tobesaved is not a Model instance. Type: [type] | Invalid model for saving (debug mode) | Check model type and ensure it's a Model |
| `ERR_SAVEAS_MODEL_FORMAT_INVALID` | Failed to save model: invalid file format | Wrong file format for model | Use .rbxl or .rbxlx extension |
| `ERR_SAVEAS_MODEL_FORMAT_INVALID_DEBUG` | Failed to save model: invalid path format. Expected .rbxl or .rbxlx, got: [path] | Wrong file format for model (debug mode) | Check file extension and format |
| `ERR_SAVEAS_IMAGE_INVALID` | Failed to save image: invalid image instance | Invalid image for saving | Ensure tobesaved is ImageLabel, ImageButton, Decal, or Texture |
| `ERR_SAVEAS_IMAGE_INVALID_DEBUG` | Failed to save image: tobesaved is not a valid image instance. Type: [type] | Invalid image for saving (debug mode) | Check image type and ensure it's valid |
| `ERR_SAVEAS_IMAGE_FORMAT_INVALID` | Failed to save image: invalid file format | Wrong file format for image | Use .png, .jpg, .jpeg, .gif, .bmp, .tiff, or .ico |
| `ERR_SAVEAS_IMAGE_FORMAT_INVALID_DEBUG` | Failed to save image: invalid file format. Expected: [formats], got: [path] | Wrong file format for image (debug mode) | Check file extension and supported formats |
| `ERR_SAVEAS_SCRIPT_CONTENT_MISSING` | Script saving requires content parameter | Missing content for script | Provide script content as string |
| `ERR_SAVEAS_SCRIPT_CONTENT_MISSING_DEBUG` | Script saving requires content parameter - use manager.saveas('script', path, debug, content) | Missing content for script (debug mode) | Provide script content parameter |
| `ERR_SAVEAS_VIDEO_WIP` | 🚧 VIDEO SAVING - WORK IN PROGRESS! Coming soon! | Using video saving (not implemented) | Video saving is work in progress |
| `ERR_SAVEAS_TYPE_UNSUPPORTED` | Unsupported instance type - Supported: Sound, script, model, image, video | Invalid instance type | Use supported instance types |
| `ERR_SAVEAS_WRITE_FAILED` | Failed to save file at path | File writing error | Check file permissions and disk space |
| `ERR_SAVEAS_WRITE_FAILED_DEBUG` | Failed to save file at path: [path] error: [error] | File writing error (debug mode) | Check file permissions, disk space, and error details |

### Script Conversion Error Codes (v2.0.0 Enhanced)

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_JAVATOLUA_SCRIPT_MISSING` | Cannot find script, did you forget to add script? | Missing script parameter | Provide Java code as string |
| `ERR_JAVATOLUA_SCRIPT_MISSING_DEBUG` | Cannot find script, did you forget to add script?: [scripted] | Missing script parameter (debug mode) | Provide Java code as string |
| `ERR_JAVATOLUA_EXECUTE_MISSING` | Cannot convert java to lua, did you forget to add doexecute parameter? | Missing doexecute parameter | Provide boolean value for execution |
| `ERR_JAVATOLUA_EXECUTE_MISSING_DEBUG` | Cannot convert java to lua, did you forget to add doexecute parameter?: [doexecute] | Missing doexecute parameter (debug mode) | Provide boolean value for execution |
| `ERR_JAVATOLUA_INVALID_SCRIPT` | Invalid script content, please provide a valid string | Invalid script content | Provide valid string with Java code |
| `ERR_JAVATOLUA_INVALID_SCRIPT_DEBUG` | Invalid script content, please provide a valid string - content type: [type], length: [length] | Invalid script content (debug mode) | Provide valid string with Java code |
| `ERR_JAVATOLUA_PROCESS_FAILED` | Failed to process script | Script processing error | Check Java code syntax and format |
| `ERR_JAVATOLUA_PROCESS_FAILED_DEBUG` | Failed to process script: [error] - script length: [length] | Script processing error (debug mode) | Check Java code syntax and format |
| `ERR_JAVATOLUA_EXECUTE_FAILED` | Failed to execute converted script | Script execution error | Check executor loadstring support |
| `ERR_JAVATOLUA_EXECUTE_FAILED_DEBUG` | Failed to execute converted script: [error] - converted code: [code] | Script execution error (debug mode) | Check executor loadstring support and converted code |

### File Deletion Error Codes

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_DFILE_PATH_MISSING` | Cannot delete file, did you forget to add path? | Missing file path parameter | Provide file path |
| `ERR_DFILE_UNDO_PATH_MISSING` | Cannot undo file deletion, did you forget to add undo file path? | Missing undo file path for restore | Provide undo file path |
| `ERR_DFILE_NOT_FOUND` | File not found: [path] | File doesn't exist | Check file path and existence |
| `ERR_DFILE_UNDO_NOT_FOUND` | Undo file not found: [path] | Undo backup doesn't exist | Check undo file path |
| `ERR_DFILE_READ_FAILED` | Failed to read file: [error] | File read error | Check file permissions and integrity |
| `ERR_DFILE_UNDO_READ_FAILED` | Failed to read undo file: [error] | Undo file read error | Check undo file permissions |
| `ERR_DFILE_BACKUP_FAILED` | Failed to create undo backup: [error] | Backup creation error | Check disk space and permissions |
| `ERR_DFILE_DELETE_FAILED` | Failed to delete file: [error] | File deletion error | Check file permissions and locks |
| `ERR_DFILE_RESTORE_FAILED` | Failed to restore file: [error] | File restoration error | Check write permissions |

### Debug Mode Error Codes (v2.0.0)

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_DEBUG_MODE_ENABLED` | Debug mode enabled - detailed error information available | Global debug mode activated | Review detailed error messages and error codes |
| `ERR_DEBUG_ERROR_CODE_REFERENCE` | Error code: [code] - see TROUBLESHOOTING.md for details | Debug mode provides error codes | Reference TROUBLESHOOTING.md for specific error code solutions |
| `ERR_DEBUG_PARAMETER_VALIDATION` | Parameter validation failed - [parameter]: [value] | Invalid parameter provided | Check parameter types and values |
| `ERR_DEBUG_FUNCTION_CONTEXT` | Function context: [function] - [context] | Function execution context error | Review function usage and parameters |
| `ERR_DEBUG_SYSTEM_STATE` | System state: [state] - [details] | System state validation failed | Check system capabilities and environment |

**Debug Mode Usage:**
```lua
-- Enable global debug mode
manager._DEBUG_MODE = true

-- All functions will now return detailed error codes and information
local result = manager.saveas("model", "test.rbxl", false, myModel)
-- Returns detailed error information if something goes wrong

-- Disable debug mode
manager._DEBUG_MODE = false
```

---

## 📁 File Operations Issues

### Issue: "Cannot create file, did you forget to add path?"

**Symptoms:**
- Function returns error message
- No file is created

**Diagnosis:**
```lua
-- Check if path is provided
local path = "test.txt"  -- Make sure this is not nil or empty
local data = "content"

if not path or path == "" then
    print("❌ Path is missing or empty")
else
    print("✅ Path is valid:", path)
end
```

**Solutions:**
1. **Provide valid path:**
   ```lua
   manager.new("myfile.txt", "content")  -- ✅ Correct
   manager.new("", "content")            -- ❌ Empty path
   manager.new(nil, "content")           -- ❌ Nil path
   ```

2. **Check path format:**
   ```lua
   manager.new("folder/file.txt", "content")     -- ✅ Valid
   manager.new("folder\\file.txt", "content")    -- ❌ Wrong separator
   manager.new("/folder/file.txt", "content")    -- ❌ Absolute path
   ```

### Issue: "Failed to create file"

**Symptoms:**
- Path and data are provided correctly
- Function returns "failed to create file"

**Diagnosis:**
```lua
-- Test file creation with error handling
local success, result = pcall(function()
    return manager.new("test.txt", "test content")
end)

if success then
    print("✅ File creation successful:", result)
else
    print("❌ File creation failed:", result)
end
```

**Solutions:**
1. **Check executor permissions:**
   ```lua
   -- Run system diagnostics
   local systemInfo = manager.nodefecth()
   if not systemInfo.filesystem.writefile then
       print("❌ Executor doesn't support file writing")
   end
   ```

2. **Try different path:**
   ```lua
   manager.new("simple.txt", "content")  -- Simple filename
   ```

3. **Check disk space and permissions**

### Issue: "Source file not found"

**Symptoms:**
- File move operation fails
- Error message indicates source file doesn't exist

**Diagnosis:**
```lua
-- Check if source file exists
local sourcePath = "source.txt"
local fileExists = isfile(sourcePath)

if fileExists then
    print("✅ Source file exists")
else
    print("❌ Source file not found:", sourcePath)
end
```

**Solutions:**
1. **Verify file path:**
   ```lua
   -- List files in directory
   local files = listfiles(".")
   for _, file in ipairs(files) do
       print("Found file:", file)
   end
   ```

2. **Create source file first:**
   ```lua
   manager.new("source.txt", "content")  -- Create source file
   manager.move("source.txt", "dest.txt") -- Then move it
   ```

### Issue: "Cannot changefile, did you forget to add newdata?"

**Symptoms:**
- Function returns error about missing newdata parameter
- No file modification occurs

**Diagnosis:**
```lua
-- Check if newdata is provided
local path = "config.json"
local newdata = '{"setting": "new_value"}'  -- Make sure this is not nil or empty

if not newdata or newdata == "" then
    print("❌ Newdata is missing or empty")
else
    print("✅ Newdata is valid:", newdata)
end
```

**Solutions:**
1. **Provide new file content:**
   ```lua
   manager.changefile("config.json", '{"setting": "new_value"}')  -- ✅ Correct
   manager.changefile("config.json", "")                          -- ❌ Empty content
   manager.changefile("config.json", nil)                         -- ❌ Nil content
   ```

2. **Check content type:**
   ```lua
   -- Ensure newdata is a string
   local newdata = "new file content"
   if type(newdata) == "string" then
       manager.changefile("file.txt", newdata)
   else
       print("❌ Newdata must be a string")
   end
   ```

### Issue: "File not found: [path]" for changefile

**Symptoms:**
- Function returns file not found error
- File modification fails

**Diagnosis:**
```lua
-- Check if file exists before changing
local path = "config.json"
local fileExists = isfile(path)

if fileExists then
    print("✅ File exists:", path)
else
    print("❌ File not found:", path)
end
```

**Solutions:**
1. **Create file first:**
   ```lua
   -- Create file if it doesn't exist
   if not isfile("config.json") then
       manager.new("config.json", '{"setting": "default"}')
   end
   -- Then change it
   manager.changefile("config.json", '{"setting": "new_value"}')
   ```

2. **Verify file path:**
   ```lua
   -- List files to find correct path
   local files = listfiles(".")
   for _, file in ipairs(files) do
       print("Found file:", file)
   end
   ```

### Issue: "Failed to write new data: [error]"

**Symptoms:**
- File exists and can be read
- New content cannot be written
- Function returns write error

**Diagnosis:**
```lua
-- Test file write permissions
local testPath = "test_write.txt"
local success, error = pcall(function()
    writefile(testPath, "test content")
    delfile(testPath)
end)

if success then
    print("✅ File writing works")
else
    print("❌ File writing failed:", error)
end
```

**Solutions:**
1. **Check disk space:**
   ```lua
   -- Ensure sufficient disk space for file modification
   ```

2. **Check file permissions:**
   ```lua
   -- Verify write access to the file
   local success, content = pcall(function()
       return readfile("config.json")
   end)
   
   if success then
       print("✅ File is readable, checking write access...")
       -- Try to write back the same content
       local writeSuccess = pcall(function()
           writefile("config.json", content)
       end)
       
       if writeSuccess then
           print("✅ File is writable")
       else
           print("❌ File write access denied")
       end
   end
   ```

3. **Check if file is locked:**
   ```lua
   -- Make sure no other process is using the file
   -- Close any open file handles
   ```

### Issue: "Failed to read file: [error]"

**Symptoms:**
- File exists but cannot be read
- Function returns read error

**Diagnosis:**
```lua
-- Test file read access
local path = "config.json"
local success, content = pcall(function()
    return readfile(path)
end)

if success then
    print("✅ File readable, size:", #content)
else
    print("❌ File read failed:", content)
end
```

**Solutions:**
1. **Check file integrity:**
   ```lua
   -- Verify file is not corrupted
   local success, content = pcall(function()
       return readfile("config.json")
   end)
   
   if success and content and #content > 0 then
       print("✅ File is valid")
   else
       print("❌ File is corrupted or empty")
   end
   ```

2. **Check file permissions:**
   ```lua
   -- Ensure read access to the file
   ```

---

## 🌐 HTTP/Network Issues

### Issue: "Failed to download file"

**Symptoms:**
- HTTP request fails
- No file is downloaded

**Diagnosis:**
```lua
-- Test HTTP connectivity
local systemInfo = manager.nodefecth()
if not systemInfo.http.request then
    print("❌ HTTP requests not supported by executor")
else
    print("✅ HTTP requests supported")
end
```

**Solutions:**
1. **Check internet connection:**
   ```lua
   -- Test with a reliable endpoint
   manager.download("https://httpbin.org/get", "test.json", "GET")
   ```

2. **Verify URL format:**
   ```lua
   manager.download("https://example.com/file.txt", "file.txt", "GET")  -- ✅ Correct
   manager.download("example.com/file.txt", "file.txt", "GET")          -- ❌ Missing protocol
   manager.download("http://example.com/file.txt", "file.txt", "GET")   -- ✅ HTTP also works
   ```

3. **Try different HTTP method:**
   ```lua
   manager.download("https://example.com/api", "response.json", "POST")
   ```

### Issue: "Invalid response from server"

**Symptoms:**
- HTTP request succeeds but response is malformed
- GUI conversion fails

**Diagnosis:**
```lua
-- Test server response
local success, response = pcall(function()
    return request({
        Url = "https://your-url.com",
        Method = "GET"
    })
end)

if success and response and response.Body then
    print("✅ Valid response received")
    print("Response length:", #response.Body)
else
    print("❌ Invalid or empty response")
end
```

**Solutions:**
1. **Check server response format:**
   ```lua
   -- For HTML content
   if response.Body:find("<html") then
       print("✅ HTML content detected")
   else
       print("❌ Not HTML content")
   end
   ```

2. **Use alternative endpoints:**
   ```lua
   manager.download("https://httpbin.org/html", "test.html", "GET")
   ```

---

## 🎨 HTML to GUI Issues

### Issue: "Failed to convert HTML to GUI"

**Symptoms:**
- HTML loads successfully but GUI conversion fails
- No GUI elements appear

**Diagnosis:**
```lua
-- Test GUI capabilities
local systemInfo = manager.nodefecth()
if not systemInfo.gui["Instance.new"] then
    print("❌ GUI creation not supported")
else
    print("✅ GUI creation supported")
end
```

**Solutions:**
1. **Check HTML syntax:**
   ```lua
   -- Simple HTML test
   local simpleHTML = [[
       <div>
           <h1>Test</h1>
       </div>
   ]]
   manager._htmlToGuiInternal(simpleHTML)
   ```

2. **Verify Roblox environment:**
   ```lua
   if game and game.Players and game.Players.LocalPlayer then
       print("✅ Valid Roblox environment for GUI")
   else
       print("❌ Invalid environment for GUI creation")
   end
   ```

3. **Test with sample GUI:**
   ```lua
   manager.createSampleHtmlGui()  -- Should work if GUI is supported
   ```

### Issue: HTML Elements Not Converting

**Symptoms:**
- Some HTML elements don't appear in GUI
- Missing styling or layout

**Solutions:**
1. **Check supported elements:**
   ```lua
   -- Only these elements are supported:
   -- <div>, <button>, <input>, <label>, <h1-h3>, <image>, <list>
   ```

2. **Verify CSS properties:**
   ```lua
   -- Supported CSS properties:
   -- background-color, color, width, height
   local htmlWithCSS = [[
       <div style="background-color: rgb(40, 40, 40); width: 400; height: 300;">
           <h1 style="color: white;">Title</h1>
       </div>
   ]]
   ```

---

## 🗑️ File Deletion Issues

### Issue: "Cannot delete file, did you forget to add path?"

**Symptoms:**
- Function returns error about missing path parameter
- No file deletion occurs

**Diagnosis:**
```lua
-- Check if path is provided
local path = "file.txt"  -- Make sure this is not nil or empty

if not path or path == "" then
    print("❌ Path is missing or empty")
else
    print("✅ Path is valid:", path)
end
```

**Solutions:**
1. **Provide file path:**
   ```lua
   manager.dfile("config.json", false)  -- ✅ Correct
   manager.dfile("", false)             -- ❌ Empty path
   manager.dfile(nil, false)            -- ❌ Nil path
   ```

2. **Check file existence:**
   ```lua
   if isfile("config.json") then
       manager.dfile("config.json", false)
   else
       print("File doesn't exist")
   end
   ```

### Issue: "File not found: [path]"

**Symptoms:**
- Function returns file not found error
- Deletion fails

**Diagnosis:**
```lua
-- Check if file exists
local path = "config.json"
local fileExists = isfile(path)

if fileExists then
    print("✅ File exists:", path)
else
    print("❌ File not found:", path)
end
```

**Solutions:**
1. **Verify file path:**
   ```lua
   -- List files to find correct path
   local files = listfiles(".")
   for _, file in ipairs(files) do
       print("Found file:", file)
   end
   ```

2. **Check file permissions:**
   ```lua
   -- Test file access
   local success, content = pcall(function()
       return readfile("config.json")
   end)
   
   if success then
       print("✅ File is readable")
   else
       print("❌ File access denied:", content)
   end
   ```

### Issue: "Failed to create undo backup: [error]"

**Symptoms:**
- File deletion fails due to backup creation error
- No undo functionality available

**Diagnosis:**
```lua
-- Test backup creation
local testPath = "test_backup.txt"
local success, error = pcall(function()
    writefile(testPath, "test content")
end)

if success then
    print("✅ Backup creation works")
    -- Clean up test file
    pcall(function() delfile(testPath) end)
else
    print("❌ Backup creation failed:", error)
end
```

**Solutions:**
1. **Check disk space:**
   ```lua
   -- Ensure sufficient disk space for backup
   ```

2. **Use custom backup path:**
   ```lua
   -- Specify backup location
   manager.dfile("config.json", false, "backups/config_backup.json")
   ```

3. **Check write permissions:**
   ```lua
   -- Test write access to backup location
   local testSuccess = pcall(function()
       writefile("test_write.txt", "test")
       delfile("test_write.txt")
   end)
   ```

### Issue: "Undo file not found: [path]"

**Symptoms:**
- Undo operation fails
- Error message shows missing undo file

**Diagnosis:**
```lua
-- Check if undo file exists
local undoPath = "config.json.undo"
local undoExists = isfile(undoPath)

if undoExists then
    print("✅ Undo file exists:", undoPath)
else
    print("❌ Undo file not found:", undoPath)
end
```

**Solutions:**
1. **Verify undo file path:**
   ```lua
   -- List all .undo files
   local files = listfiles(".")
   for _, file in ipairs(files) do
       if file:find("%.undo$") then
           print("Found undo file:", file)
       end
   end
   ```

2. **Check backup location:**
   ```lua
   -- If using custom backup path, verify it exists
   local backupPath = "backups/config_backup.json"
   if isfile(backupPath) then
       manager.dfile("config.json", true, backupPath)
   end
   ```

### Issue: "Failed to restore file: [error]"

**Symptoms:**
- File restoration fails
- Undo operation unsuccessful

**Diagnosis:**
```lua
-- Test file restoration
local undoPath = "config.json.undo"
local targetPath = "config.json"

-- Check undo file content
local undoSuccess, undoData = pcall(function()
    return readfile(undoPath)
end)

if undoSuccess then
    print("✅ Undo file readable, size:", #undoData)
else
    print("❌ Undo file read failed:", undoData)
end
```

**Solutions:**
1. **Check write permissions:**
   ```lua
   -- Test write access to target location
   local writeSuccess = pcall(function()
       writefile("test_restore.txt", "test")
       delfile("test_restore.txt")
   end)
   ```

2. **Verify undo file integrity:**
   ```lua
   -- Check if undo file is corrupted
   local success, content = pcall(function()
       return readfile("config.json.undo")
   end)
   
   if success and content and #content > 0 then
       print("✅ Undo file is valid")
   else
       print("❌ Undo file is corrupted or empty")
   end
   ```

---

## 💾 Save Operations Issues

### Issue: "Cannot save file, did you forget to add path?"

**Symptoms:**
- Function returns error about missing path parameter
- No file saving occurs

**Diagnosis:**
```lua
-- Check if path is provided
local path = "sounds/music.mp3"  -- Make sure this is not nil or empty

if not path or path == "" then
    print("❌ Path is missing or empty")
else
    print("✅ Path is valid:", path)
end
```

**Solutions:**
1. **Provide file path:**
   ```lua
   local result = manager.saveas("sounds/music.mp3", audioData, "Sound")  -- ✅ Correct
   local result = manager.saveas("", audioData, "Sound")                   -- ❌ Empty path
   local result = manager.saveas(nil, audioData, "Sound")                  -- ❌ Nil path
   ```

2. **Check path format:**
   ```lua
   -- Ensure path has valid format
   local path = "folder/subfolder/file.mp3"  -- ✅ Valid
   local path = "file.mp3"                   -- ✅ Valid
   local path = "/invalid/path"              -- ❌ Invalid format
   ```

### Issue: "Invalid content type for Sound: expected string, got number"

**Symptoms:**
- Function returns content type error
- Saving fails due to wrong data type

**Diagnosis:**
```lua
-- Check content type
local content = readfile("audio.mp3")  -- Should be string
local contentType = type(content)

print("Content type:", contentType)
if contentType ~= "string" then
    print("❌ Wrong content type for Sound")
else
    print("✅ Correct content type for Sound")
end
```

**Solutions:**
1. **Use correct content type for each save type:**
   ```lua
   -- Sound: string (binary audio data)
   local audioData = readfile("music.mp3")
   manager.saveas("sound.mp3", audioData, "Sound")
   
   -- Model: table or userdata (Model instance)
   local modelInstance = game.Workspace:FindFirstChild("MyModel")
   manager.saveas("model.rbxl", modelInstance, "Model")
   
   -- Script: string (Lua source code)
   local scriptCode = "print('Hello World')"
   manager.saveas("script.lua", scriptCode, "Script")
   
   -- Image: string (binary image data)
   local imageData = readfile("image.png")
   manager.saveas("image.png", imageData, "Image")
   ```

### Issue: "Failed to create custom asset for audio"

**Symptoms:**
- File is written but custom asset creation fails
- Sound instance creation fails

**Diagnosis:**
```lua
-- Test custom asset capabilities
local capabilities = manager.checkSaveasCapabilities()

if capabilities.CustomAssets then
    print("✅ Custom asset creation is supported")
else
    print("❌ Custom asset creation is not supported")
end

if capabilities.InstanceCreation then
    print("✅ Instance creation is supported")
else
    print("❌ Instance creation is not supported")
end
```

**Solutions:**
1. **Check executor capabilities:**
   ```lua
   -- Run capability check
   local capabilities = manager.checkSaveasCapabilities()
   
   if not capabilities.Sound then
       print("❌ Sound saving not supported on this executor")
       return
   end
   
   if not capabilities.CustomAssets then
       print("❌ Custom asset creation not supported")
       return
   end
   ```

2. **Use alternative approach:**
   ```lua
   -- If saveas fails, use regular file operations
   local audioData = readfile("music.mp3")
   local result = manager.new("backup_music.mp3", audioData)
   print("Saved as regular file:", result)
   ```

### Issue: "Save type 'Model' is recognized but not yet implemented"

**Symptoms:**
- Function returns not implemented error
- Model saving fails

**Diagnosis:**
```lua
-- Check which types are implemented
local capabilities = manager.checkSaveasCapabilities()

print("Implemented types:")
for type, supported in pairs(capabilities) do
    if type ~= "InstanceCreation" and type ~= "CustomAssets" and type ~= "FileWriting" then
        print("  " .. type .. ":", supported and "✅" or "❌")
    end
end
```

**Solutions:**
1. **Use only implemented types:**
   ```lua
   -- Currently only Sound is fully implemented
   local result = manager.saveas("audio.mp3", audioData, "Sound")  -- ✅ Works
   
   -- These are not yet implemented:
   -- local result = manager.saveas("model.rbxl", modelData, "Model")     -- ❌ Not implemented
   -- local result = manager.saveas("script.lua", scriptCode, "Script")   -- ❌ Not implemented
   -- local result = manager.saveas("image.png", imageData, "Image")      -- ❌ Not implemented
   ```

2. **Use alternative methods:**
   ```lua
   -- For models, save as regular file for now
   local modelData = "Model metadata here"
   local result = manager.new("model_data.txt", modelData)
   
   -- For scripts, save as regular file
   local scriptCode = "print('Hello World')"
   local result = manager.new("script.lua", scriptCode)
   ```

### Issue: "Content too small to be valid audio data"

**Symptoms:**
- Audio file validation fails
- Error about minimum size requirement

**Diagnosis:**
```lua
-- Check content size
local audioData = readfile("audio.mp3")
local dataSize = #audioData

print("Audio data size:", dataSize, "bytes")
if dataSize < 100 then
    print("❌ Audio data too small (minimum 100 bytes required)")
else
    print("✅ Audio data size is sufficient")
end
```

**Solutions:**
1. **Ensure valid audio data:**
   ```lua
   -- Make sure you're reading actual audio file
   local audioData = readfile("music.mp3")
   
   -- Check if file exists and has content
   if not audioData or #audioData < 100 then
       print("❌ Invalid or corrupted audio file")
       return
   end
   
   -- Now try to save
   local result = manager.saveas("saved_music.mp3", audioData, "Sound")
   ```

2. **Validate audio file format:**
   ```lua
   -- Check file extension and content
   local path = "audio.mp3"
   local extension = path:match("%.(%w+)$")
   
   if not extension or not (extension:lower() == "mp3" or extension:lower() == "wav" or extension:lower() == "ogg") then
       print("❌ Unsupported audio format")
       return
   end
   ```

---

## 🎵 Media Operations Issues

### Issue: "Cannot handle media, did you forget to add [parameter]?"

**Symptoms:**
- Function returns error about missing parameters
- No media processing occurs

**Diagnosis:**
```lua
-- Check required parameters
local path = "song.mp3"        -- Make sure this is not nil or empty
local type = "audio"           -- Make sure this is not nil or empty
local typeofmedia = "audio"    -- Make sure this is not nil or empty

if not path or path == "" then
    print("❌ Path is missing or empty")
end
if not type or type == "" then
    print("❌ Type is missing or empty")
end
if not typeofmedia or typeofmedia == "" then
    print("❌ Typeofmedia is missing or empty")
end
```

**Solutions:**
1. **Provide all required parameters:**
   ```lua
   manager.media("song.mp3", "audio", "audio", false)  -- ✅ Correct
   manager.media("", "audio", "audio", false)          -- ❌ Empty path
   manager.media("song.mp3", "", "audio", false)       -- ❌ Empty type
   ```

2. **Check parameter order:**
   ```lua
   -- Correct parameter order: path, type, typeofmedia, isfolder, folder
   manager.media("song.mp3", "audio", "audio", false)
   ```

### Issue: "Invalid media type"

**Symptoms:**
- Function returns "invalid media type"
- Media processing fails

**Diagnosis:**
```lua
-- Check supported media types
local supportedTypes = {"audio", "video", "image", "document"}
local typeofmedia = "audio"  -- Your media type

local isValid = false
for _, supportedType in ipairs(supportedTypes) do
    if typeofmedia == supportedType then
        isValid = true
        break
    end
end

if not isValid then
    print("❌ Invalid media type:", typeofmedia)
else
    print("✅ Valid media type:", typeofmedia)
end
```

**Solutions:**
1. **Use supported media types:**
   ```lua
   manager.media("song.mp3", "audio", "audio", false)     -- ✅ Correct
   manager.media("song.mp3", "audio", "music", false)     -- ❌ Invalid type
   ```

2. **Check case sensitivity:**
   ```lua
   manager.media("song.mp3", "audio", "audio", false)     -- ✅ Correct
   manager.media("song.mp3", "audio", "Audio", false)     -- ❌ Wrong case
   ```

### Issue: "Folder not found: [folder]"

**Symptoms:**
- Folder audio playback fails
- Error message shows folder path

**Diagnosis:**
```lua
-- Check if folder exists
local folderPath = "music"
local folderExists = isfolder(folderPath)

if folderExists then
    print("✅ Folder exists:", folderPath)
else
    print("❌ Folder not found:", folderPath)
end

-- List available folders
local files = listfiles(".")
for _, file in ipairs(files) do
    print("Available:", file)
end
```

**Solutions:**
1. **Verify folder path:**
   ```lua
   -- Check current directory structure
   local files = listfiles(".")
   for _, file in ipairs(files) do
       print("Found:", file)
   end
   ```

2. **Create folder if needed:**
   ```lua
   -- Create folder first
   makefolder("music")
   -- Then use it
   manager.media(nil, "audio", "audio", true, "music")
   ```

### Issue: "No audio files found in folder"

**Symptoms:**
- Folder exists but contains no audio files
- Function returns "no audio files found in folder"

**Diagnosis:**
```lua
-- Check folder contents
local folderPath = "music"
local files = listfiles(folderPath)

print("Files in folder:", folderPath)
for _, file in ipairs(files) do
    local fileName = file:match("([^/\\]+)$")
    local extension = fileName:match("%.(%w+)$")
    print("File:", fileName, "Extension:", extension)
end

-- Check for audio extensions
local audioExtensions = {".mp3", ".wav", ".ogg", ".m4a", ".aac"}
local hasAudio = false

for _, file in ipairs(files) do
    local fileName = file:match("([^/\\]+)$")
    local extension = fileName:match("%.(%w+)$")
    if extension then
        extension = "." .. extension:lower()
        for _, audioExt in ipairs(audioExtensions) do
            if extension == audioExt then
                hasAudio = true
                break
            end
        end
    end
end

if hasAudio then
    print("✅ Audio files found")
else
    print("❌ No audio files found")
end
```

**Solutions:**
1. **Add audio files to folder:**
   ```lua
   -- Add audio files with supported extensions
   manager.new("music/song1.mp3", "audio content")
   manager.new("music/song2.wav", "audio content")
   ```

2. **Check file extensions:**
   ```lua
   -- Use supported audio extensions
   -- .mp3, .wav, .ogg, .m4a, .aac
   ```

### Issue: "Failed to play audio"

**Symptoms:**
- Audio file exists but won't play
- Function returns "failed to play audio"

**Diagnosis:**
```lua
-- Test audio system
local systemInfo = manager.nodefecth()
if not systemInfo.gui["Instance.new"] then
    print("❌ GUI creation not supported - needed for audio")
else
    print("✅ GUI creation supported")
end

-- Test custom asset
local assetSuccess, asset = pcall(function()
    return getcustomasset("song.mp3")
end)

if assetSuccess then
    print("✅ Custom asset created successfully")
else
    print("❌ Custom asset creation failed:", asset)
end
```

**Solutions:**
1. **Check audio file format:**
   ```lua
   -- Ensure audio file is valid and supported format
   -- Test with a known working audio file
   ```

2. **Check Roblox environment:**
   ```lua
   -- Make sure you're in a valid Roblox game
   if game and game.Workspace then
       print("✅ Valid Roblox environment")
   else
       print("❌ Invalid environment")
   end
   ```

3. **Test with simple audio:**
   ```lua
   -- Try with a basic audio file first
   manager.media("simple.mp3", "audio", "audio", false)
   ```

---

## 🔄 Script Conversion Issues

### Issue: "Cannot find script, did you forget to add script?"

**Symptoms:**
- Function returns error about missing script parameter
- No conversion occurs

**Diagnosis:**
```lua
-- Check if script is provided
local script = "public class Test {}"  -- Make sure this is not nil or empty

if not script or script == "" then
    print("❌ Script is missing or empty")
else
    print("✅ Script is valid:", script)
end
```

**Solutions:**
1. **Provide Java code:**
   ```lua
   local javaCode = "public class HelloWorld { public static void main(String[] args) { System.out.println(\"Hello\"); } }"
   local result = manager.javatolua(javaCode, false)  -- ✅ Correct
   local result = manager.javatolua("", false)        -- ❌ Empty script
   local result = manager.javatolua(nil, false)       -- ❌ Nil script
   ```

2. **Check script format:**
   ```lua
   -- Ensure script is a valid string
   if type(script) == "string" then
       local result = manager.javatolua(script, false)
   else
       print("❌ Script must be a string")
   end
   ```

### Issue: "Cannot convert java to lua, did you forget to add doexecute parameter?"

**Symptoms:**
- Function returns error about missing doexecute parameter
- No conversion occurs

**Diagnosis:**
```lua
-- Check if doexecute is provided
local doexecute = true  -- Make sure this is not nil

if doexecute == nil then
    print("❌ doexecute parameter is missing")
else
    print("✅ doexecute parameter is valid:", doexecute)
end
```

**Solutions:**
1. **Provide doexecute parameter:**
   ```lua
   local result = manager.javatolua(javaCode, true)   -- ✅ Execute the converted code
   local result = manager.javatolua(javaCode, false)  -- ✅ Just convert, don't execute
   local result = manager.javatolua(javaCode, nil)    -- ❌ Nil parameter
   ```

2. **Understand the parameter:**
   ```lua
   -- true = convert and execute the Lua code
   -- false = convert to Lua but don't execute
   local result = manager.javatolua("print('Hello')", true)  -- Will execute the converted code
   ```

### Issue: "Invalid script content, please provide a valid string"

**Symptoms:**
- Function returns error about invalid script content
- Script validation fails

**Diagnosis:**
```lua
-- Check script content
local script = "public class Test {}"
local isValid = script and type(script) == "string" and #script > 0

if isValid then
    print("✅ Script content is valid")
else
    print("❌ Script content is invalid")
    print("Type:", type(script))
    print("Length:", script and #script or "nil")
end
```

**Solutions:**
1. **Ensure valid script content:**
   ```lua
   -- Provide non-empty string
   local javaCode = "public class Test { public void method() { } }"  -- ✅ Valid
   local javaCode = ""                                               -- ❌ Empty string
   local javaCode = nil                                              -- ❌ Nil value
   ```

2. **Check script content:**
   ```lua
   -- Make sure script contains actual Java-like code
   local javaCode = "public class HelloWorld { }"  -- ✅ Contains Java keywords
   local javaCode = "just some text"               -- ❌ No Java keywords
   ```

### Issue: "Failed to process script"

**Symptoms:**
- Script validation passes but processing fails
- Function returns processing error

**Diagnosis:**
```lua
-- Test script processing
local javaCode = "public class Test { }"
local success, result = pcall(function()
    return manager.javatolua(javaCode, false)
end)

if success then
    print("✅ Script processing successful:", result)
else
    print("❌ Script processing failed:", result)
end
```

**Solutions:**
1. **Check Java code syntax:**
   ```lua
   -- Use simple Java-like syntax
   local javaCode = "public class Simple { }"  -- ✅ Simple syntax
   local javaCode = "complex; invalid; syntax" -- ❌ Invalid syntax
   ```

2. **Test with minimal code:**
   ```lua
   -- Start with very simple Java code
   local javaCode = "class Test {}"
   local result = manager.javatolua(javaCode, false)
   ```

### Issue: "Failed to execute converted script"

**Symptoms:**
- Conversion succeeds but execution fails
- Function returns execution error

**Diagnosis:**
```lua
-- Test execution capabilities
local success, result = pcall(function()
    loadstring("print('test')")()
    return true
end)

if success then
    print("✅ Script execution is supported")
else
    print("❌ Script execution not supported:", result)
end
```

**Solutions:**
1. **Check executor capabilities:**
   ```lua
   -- Test if loadstring is available
   if loadstring then
       print("✅ loadstring is available")
   else
       print("❌ loadstring not available - execution will fail")
   end
   ```

2. **Use conversion without execution:**
   ```lua
   -- If execution fails, just convert without executing
   local result, luaCode = manager.javatolua(javaCode, false)
   print("Converted code:", luaCode)
   
   -- Then execute manually if needed
   if loadstring then
       local success, err = pcall(function()
           loadstring(luaCode)()
       end)
   end
   ```

3. **Note: This is experimental - errors are expected**
   ```lua
   -- Java to Lua conversion is experimental
   -- Consider using pure Lua code instead for production use
   ```

---

## 🎵 Media Operations Issues

### Issue: "Failed to read video file" (EXPERIMENTAL)

**Symptoms:**
- Video file exists but cannot be read
- Function returns "failed to read video file"

**Diagnosis:**
```lua
-- Check video file accessibility
local videoPath = "video.mp4"
local fileExists = isfile(videoPath)

if fileExists then
    print("✅ Video file exists:", videoPath)
    
    -- Test file read access
    local readSuccess, content = pcall(function()
        return readfile(videoPath)
    end)
    
    if readSuccess then
        print("✅ Video file readable, size:", #content)
    else
        print("❌ Video file read failed:", content)
    end
else
    print("❌ Video file not found:", videoPath)
end
```

**Solutions:**
1. **Check video file format:**
   ```lua
   -- Ensure video file is in supported format
   -- Test with a known working video file first
   ```

2. **Check file permissions:**
   ```lua
   -- Verify file is not corrupted or locked
   local success, content = pcall(function()
       return readfile("video.mp4")
   end)
   ```

3. **Note: This is experimental - errors are expected**

### Issue: "Failed to play video" (EXPERIMENTAL)

**Symptoms:**
- Video file reads successfully but playback fails
- Function returns "failed to play video"

**Diagnosis:**
```lua
-- Test VideoFrame creation
local success, video = pcall(function()
    local videoFrame = Instance.new("VideoFrame")
    videoFrame:Destroy()
    return true
end)

if success then
    print("✅ VideoFrame creation supported")
else
    print("❌ VideoFrame creation not supported:", video)
end

-- Test Roblox environment
if game and game.Workspace then
    print("✅ Valid Roblox environment for video")
else
    print("❌ Invalid environment for video playback")
end
```

**Solutions:**
1. **Check Roblox VideoFrame support:**
   ```lua
   -- VideoFrame is a Roblox feature that may not be available in all environments
   if game and game.Workspace then
       print("✅ Roblox environment available")
   end
   ```

2. **Check video file format:**
   ```lua
   -- Ensure video is in a format supported by Roblox VideoFrame
   -- Common formats: .mp4, .webm
   ```

3. **Note: This is experimental - errors are expected**
   ```lua
   -- Video handling is still experimental and may have issues
   -- Consider using audio files for more reliable playback
   ```

---

## 🔍 System Diagnostics Issues

### Issue: nodefecth() Shows Errors

**Symptoms:**
- System diagnostics fail
- Missing test results

**Diagnosis:**
```lua
-- Run diagnostics with error handling
local success, result = pcall(function()
    return manager.nodefecth()
end)

if success then
    print("✅ Diagnostics completed")
else
    print("❌ Diagnostics failed:", result)
end
```

**Solutions:**
1. **Check executor compatibility:**
   ```lua
   -- Basic executor test
   local executorSuccess, name, version = pcall(function()
       return identifyexecutor()
   end)
   
   if executorSuccess then
       print("Executor:", name, version)
   else
       print("❌ Executor not detected")
   end
   ```

2. **Test individual components:**
   ```lua
   -- Test filesystem
   local fsSuccess = pcall(function()
       listfiles(".")
   end)
   print("Filesystem:", fsSuccess and "✅" or "❌")
   
   -- Test HTTP
   local httpSuccess = pcall(function()
       request({Url = "https://httpbin.org/get", Method = "GET"})
   end)
   print("HTTP:", httpSuccess and "✅" or "❌")
   ```

---

## 🎯 Executor-Specific Issues

### Wave Executor Issues

**Common Problems:**
- File operations may require specific permissions
- HTTP requests might be rate-limited

**Solutions:**
```lua
-- Enable file system access in Wave settings
-- Check if Wave has HTTP enabled

-- Test Wave-specific features
if identifyexecutor and identifyexecutor() == "Wave" then
    print("Running on Wave executor")
    -- Wave-specific optimizations
end
```

### Krnl Executor Issues

**Common Problems:**
- Some advanced features may not be available
- GUI creation might have limitations

**Solutions:**
```lua
-- Krnl compatibility check
local systemInfo = manager.nodefecth()
if not systemInfo.advanced.hookfunction then
    print("⚠️ Advanced features not available on Krnl")
end
```

### Hydrogen Executor Issues

**Common Problems:**
- New executor with potential compatibility issues
- Some features still in development

**Solutions:**
```lua
-- Check Hydrogen version and capabilities
local executorSuccess, name, version = pcall(function()
    return identifyexecutor()
end)

if name == "Hydrogen" then
    print("Hydrogen version:", version)
    -- Test specific features
end
```

---

## ⚡ Performance Issues

### Issue: Slow File Operations

**Symptoms:**
- File creation/moving takes too long
- Script freezes during operations

**Solutions:**
1. **Optimize file sizes:**
   ```lua
   -- For large files, process in chunks
   local largeData = string.rep("data", 10000)
   manager.new("large.txt", largeData)  -- May be slow
   ```

2. **Use asynchronous operations:**
   ```lua
   -- Process files in background
   spawn(function()
       manager.new("background.txt", "content")
   end)
   ```

### Issue: Memory Usage

**Symptoms:**
- High memory consumption
- Script crashes with large files

**Solutions:**
1. **Monitor memory usage:**
   ```lua
   local gc = getgc()
   print("GC objects:", #gc)
   
   -- Clean up after operations
   collectgarbage()
   ```

2. **Limit file sizes:**
   ```lua
   local maxSize = 1024 * 1024  -- 1MB limit
   if #data > maxSize then
       print("⚠️ File too large, truncating")
       data = data:sub(1, maxSize)
   end
   ```

---

## 🔧 Advanced Troubleshooting

### Debug Mode

Enable detailed logging for troubleshooting:

```lua
-- Enable debug mode
local DEBUG = true

local function debugLog(message)
    if DEBUG then
        print("[DEBUG]", message)
    end
end

-- Use in functions
debugLog("Creating file: " .. path)
local result = manager.new(path, data)
debugLog("Result: " .. result)
```

### Custom Error Handling

```lua
-- Enhanced error handling
local function safeOperation(operation, ...)
    local success, result = pcall(operation, ...)
    
    if not success then
        print("❌ Operation failed:", result)
        print("Stack trace:", debug.traceback())
        return nil, result
    end
    
    return result
end

-- Usage
local result, error = safeOperation(manager.new, "test.txt", "content")
if not result then
    print("Error:", error)
end
```

### Environment Validation

```lua
-- Comprehensive environment check
local function validateEnvironment()
    local issues = {}
    
    -- Check executor
    if not identifyexecutor then
        table.insert(issues, "Executor not detected")
    end
    
    -- Check game environment
    if not game then
        table.insert(issues, "Not in Roblox game")
    end
    
    -- Check filesystem
    local fsSuccess = pcall(function()
        listfiles(".")
    end)
    if not fsSuccess then
        table.insert(issues, "Filesystem not available")
    end
    
    -- Check HTTP
    local httpSuccess = pcall(function()
        request({Url = "https://httpbin.org/get", Method = "GET"})
    end)
    if not httpSuccess then
        table.insert(issues, "HTTP not available")
    end
    
    if #issues > 0 then
        print("⚠️ Environment issues found:")
        for _, issue in ipairs(issues) do
            print("  -", issue)
        end
    else
        print("✅ Environment validation passed")
    end
    
    return #issues == 0
end

-- Run validation
validateEnvironment()
```

---

## 📞 Getting Help

### Before Asking for Help

1. **Run system diagnostics:**
   ```lua
   manager.nodefecth()
   ```

2. **Check error messages carefully**
3. **Verify your environment setup**
4. **Test with simple examples first**

### Information to Include

When reporting issues, include:
- Executor name and version
- Error messages (exact text)
- Steps to reproduce
- System diagnostics output
- Code that's causing issues

### Common Solutions Checklist

- [ ] Check parameter types and values
- [ ] Verify file paths and URLs
- [ ] Test with simple examples
- [ ] Run system diagnostics
- [ ] Check executor permissions
- [ ] Verify Roblox environment
- [ ] Test internet connectivity

---

**Need more help?** Check the [Issues](https://github.com/displaynameroblox/localmaner/issues) page or create a new issue with detailed information.

---

*Last updated: 2025*
