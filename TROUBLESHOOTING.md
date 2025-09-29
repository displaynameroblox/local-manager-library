# 🔧 Troubleshooting Guide - Local Manager Library

Complete troubleshooting guide for resolving issues with the Local Manager Library.

## 📋 Table of Contents

- [Quick Diagnostics](#quick-diagnostics)
- [Error Codes Reference](#error-codes-reference)
- [File Operations Issues](#file-operations-issues)
- [File Deletion Issues](#file-deletion-issues)
- [Save Operations Issues](#save-operations-issues)
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

### HTTP Operations Error Codes

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_HTTP_URL_MISSING` | Cannot download file, did you forget to add the url? | Missing URL parameter | Provide valid URL |
| `ERR_HTTP_PATH_MISSING` | Cannot download file, did you forget to add path? | Missing save path | Provide local file path |
| `ERR_HTTP_BOTH_MISSING` | You fucking idiot, how the fuck did you get this far?. put the url and the path | Both URL and path missing | Provide both URL and path |
| `ERR_HTTP_REQUEST_FAILED` | Failed to download file | Network issues, invalid URL | Check internet connection and URL |
| `ERR_HTTP_INVALID_RESPONSE` | Invalid response from server | Server error, malformed response | Try different URL or check server status |
| `ERR_HTTP_SAVE_FAILED` | Failed to save file | Disk space, permission issues | Check disk space and permissions |

### HTML to GUI Error Codes

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
| `ERR_HTML_CONVERSION_FAILED` | Failed to convert HTML to GUI | HTML parsing error, GUI creation failed | Check HTML syntax and GUI permissions |

### Media Operations Error Codes

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_MEDIA_PATH_MISSING` | Cannot handle media, did you forget to add path? | Missing path parameter | Provide file path |
| `ERR_MEDIA_TYPE_MISSING` | Cannot handle media, did you forget to add type? | Missing type parameter | Provide media type |
| `ERR_MEDIA_TYPEOF_MISSING` | Cannot handle media, did you forget to add typeofmedia? | Missing typeofmedia parameter | Provide specific media type |
| `ERR_MEDIA_INVALID_TYPE` | Invalid media type | Unsupported media type | Use "audio", "video", "image", or "document" |
| `ERR_MEDIA_VIDEO_READ_FAILED` | Failed to read video file | Video file corruption, permission issues (**EXPERIMENTAL**) | Check video file integrity and permissions |
| `ERR_MEDIA_VIDEO_PLAY_FAILED` | Failed to play video | Video format issues, VideoFrame creation failed (**EXPERIMENTAL**) | Check video file format and Roblox VideoFrame support |
| `ERR_MEDIA_FOLDER_PATH_MISSING` | Cannot handle media folder, did you forget to add folder path? | Missing folder path for folder mode | Provide folder path |
| `ERR_MEDIA_FOLDER_NOT_FOUND` | Folder not found: [folder] | Specified folder doesn't exist | Check folder path and existence |
| `ERR_MEDIA_FOLDER_LIST_FAILED` | Failed to list files in folder | Folder access permission issues | Check folder permissions |
| `ERR_MEDIA_NO_AUDIO_FILES` | No audio files found in folder | Folder contains no audio files | Add audio files (.mp3, .wav, .ogg, .m4a, .aac) |
| `ERR_MEDIA_READ_FAILED` | Failed to read media file, keep in mind this is still experimental | File corruption, permission issues | Check file integrity and permissions |
| `ERR_MEDIA_ASSET_FAILED` | Failed to get custom asset for audio | Audio file format issues | Check audio file format and integrity |
| `ERR_MEDIA_PLAY_FAILED` | Failed to play audio | Audio system issues | Check Roblox audio system and file format |
| `ERR_MEDIA_SOUND_CHECK_FAILED` | Failed to check sound: [error] | Sound validation error | Check audio file integrity and format |

### ScriptFolder Management Error Codes

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_SCRIPTFOLDER_CREATE_FAILED` | Failed to create scriptfolder | Workspace access denied, GUI creation not supported | Check executor GUI permissions and Roblox environment |

### Save Operations Error Codes

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_SAVEAS_PATH_MISSING` | Cannot save file, did you forget to add path? | Missing file path parameter | Provide valid file path |
| `ERR_SAVEAS_CONTENT_MISSING` | Cannot save file without content | Missing content parameter | Provide content to save |
| `ERR_SAVEAS_TYPE_MISSING` | Cannot save file without type specification | Missing type parameter | Specify supported type (Sound, Model, Script, Image) |
| `ERR_SAVEAS_INVALID_PATH` | Invalid file path format | Malformed file path | Use valid file path format |
| `ERR_SAVEAS_UNSUPPORTED_TYPE` | Unsupported save type | Invalid type specified | Use one of: Sound, Model, Script, Image |
| `ERR_SAVEAS_FILE_EXISTS` | File already exists at path | Target file exists | Use different path or delete existing file |
| `ERR_SAVEAS_TYPE_NOT_IMPLEMENTED` | Save type is recognized but not yet implemented | Using reserved type | Only use fully implemented types (currently Sound) |
| `ERR_SAVEAS_INVALID_CONTENT_TYPE` | Invalid content type for type | Wrong content type for specified type | Use correct content type (string for Sound/Script/Image, table/userdata for Model) |
| `ERR_SAVEAS_CONTENT_TOO_SMALL` | Content too small to be valid audio data | Audio data too small | Ensure audio content is at least 100 bytes |
| `ERR_SAVEAS_WRITE_FAILED` | Failed to write type file | File writing error | Check file permissions and disk space |
| `ERR_SAVEAS_ASSET_FAILED` | Failed to create custom asset for audio | Custom asset creation failed | Check executor custom asset support |
| `ERR_SAVEAS_INSTANCE_FAILED` | Failed to create Type instance | Instance creation failed | Check executor instance creation support |

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
