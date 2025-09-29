# 🔧 Troubleshooting Guide - Local Manager Library

Complete troubleshooting guide for resolving issues with the Local Manager Library.

## 📋 Table of Contents

- [Quick Diagnostics](#quick-diagnostics)
- [Error Codes Reference](#error-codes-reference)
- [File Operations Issues](#file-operations-issues)
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
| `ERR_HTML_READ_FAILED` | Failed to read local HTML file | File corruption, permission issues | Check file integrity |
| `ERR_HTML_URL_MISSING` | Cannot find url, did you forget to add url? | Missing URL for online mode | Provide valid URL |
| `ERR_HTML_DOWNLOAD_FAILED` | Failed to load HTML from URL: [url] | Network issues, invalid URL | Check internet and URL |
| `ERR_HTML_NO_CONTENT` | No HTML content available | Empty response or file | Check source content |
| `ERR_HTML_CONVERSION_FAILED` | Failed to convert HTML to GUI | HTML parsing error, GUI creation failed | Check HTML syntax and GUI permissions |

### Media Operations Error Codes

| Error Code | Description | Common Causes | Solution |
|------------|-------------|---------------|----------|
| `ERR_MEDIA_PATH_MISSING` | Cannot handle media, did you forget to add path? | Missing path parameter | Provide file path |
| `ERR_MEDIA_TYPE_MISSING` | Cannot handle media, did you forget to add type? | Missing type parameter | Provide media type |
| `ERR_MEDIA_TYPEOF_MISSING` | Cannot handle media, did you forget to add typeofmedia? | Missing typeofmedia parameter | Provide specific media type |
| `ERR_MEDIA_INVALID_TYPE` | Invalid media type | Unsupported media type | Use "audio", "video", "image", or "document" |
| `ERR_MEDIA_VIDEO_UNSUPPORTED` | Videos are not supported yet | Trying to play video files | Use audio files instead |
| `ERR_MEDIA_FOLDER_PATH_MISSING` | Cannot handle media folder, did you forget to add folder path? | Missing folder path for folder mode | Provide folder path |
| `ERR_MEDIA_FOLDER_NOT_FOUND` | Folder not found: [folder] | Specified folder doesn't exist | Check folder path and existence |
| `ERR_MEDIA_FOLDER_LIST_FAILED` | Failed to list files in folder | Folder access permission issues | Check folder permissions |
| `ERR_MEDIA_NO_AUDIO_FILES` | No audio files found in folder | Folder contains no audio files | Add audio files (.mp3, .wav, .ogg, .m4a, .aac) |
| `ERR_MEDIA_READ_FAILED` | Failed to read media file | File corruption, permission issues | Check file integrity and permissions |
| `ERR_MEDIA_ASSET_FAILED` | Failed to get custom asset for audio | Audio file format issues | Check audio file format and integrity |
| `ERR_MEDIA_PLAY_FAILED` | Failed to play audio | Audio system issues | Check Roblox audio system and file format |

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
