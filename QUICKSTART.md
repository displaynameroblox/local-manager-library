# 🚀 Quick Start Guide - Local Manager Library

Get up and running with the Local Manager Library in just a few minutes!

## 📋 Prerequisites

Before you start, make sure you have:
- ✅ A Roblox executor (Script-Ware, Krnl, Synapse X, etc.)
- ✅ Basic knowledge of Lua/Luau
- ✅ Roblox game access

## ⚡ 5-Minute Setup

### Step 1: Load the Library

```lua
-- Copy and paste this line into your executor
local manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/displaynameroblox/localmaner/main/localmaner.lua"))()
```

**That's it!** The library is now loaded and ready to use. You should see system diagnostics running automatically.

### Step 2: Your First File Operation

```lua
-- Create your first file
local result = manager.new("my_first_file.txt", "Hello, Local Manager!")
print(result) -- Should print: "file created successfully"

-- Delete a file safely with undo
local result = manager.dfile("my_first_file.txt", false)
print(result) -- Should print: "file deleted successfully, undo backup created at: my_first_file.txt.undo"
```

### Step 3: Download Something from the Internet

```lua
-- Download a file from the web
local result = manager.download("https://httpbin.org/json", "downloaded.json", "GET")
print(result) -- Should print: "file downloaded successfully"
```

### Step 4: Create a Simple GUI

```lua
-- Create a simple HTML GUI (organized in scriptfolder)
manager.createSampleHtmlGui()

-- Check what's in your scriptfolder
local contents = manager.listScriptFolderContents()
for _, item in ipairs(contents) do
    print("Found:", item.name, "Type:", item.type)
end
```

## 🎯 Common Use Cases

### 1. Configuration Files

```lua
-- Create a config file
local config = {
    theme = "dark",
    sound = true,
    username = "Player123"
}
manager.new("config.json", game:GetService("HttpService"):JSONEncode(config))
```

### 2. Safe File Deletion with Undo

```lua
-- Delete a file safely with automatic backup
manager.dfile("config.json", false) -- Creates config.json.undo

-- Later, restore it if needed
manager.dfile("config.json", true, "config.json.undo")
```

### 3. Download and Use Data

```lua
-- Download user data and use it
manager.download("https://api.example.com/user/data", "userdata.json", "GET")

-- Later, read the data
local userData = readfile("userdata.json")
local decoded = game:GetService("HttpService"):JSONDecode(userData)
print("User level:", decoded.level)
```

### 4. Create Custom Interfaces

```lua
-- Create a custom HTML interface (organized in scriptfolder)
local htmlContent = [[
    <div style="background-color: rgb(20, 20, 20); width: 400; height: 300;">
        <h1 style="color: white;">My Custom Interface</h1>
        <button style="background-color: green; color: white; width: 150; height: 40;">Start</button>
        <button style="background-color: red; color: white; width: 150; height: 40;">Stop</button>
    </div>
]]

-- Save and convert to GUI (GUI references stored in scriptfolder/GUIs/)
manager.new("interface.html", htmlContent)
manager.html(nil, true, "interface.html", true)
```

### 5. Play Audio Files

```lua
-- Play single audio file (organized in scriptfolder/Audio/)
manager.media("song.mp3", "audio", "audio", false)

-- Play all audio files in a folder (organized in scriptfolder/Audio/)
manager.media(nil, "audio", "audio", true, "music")
```

## 🔧 System Check

Run this to see what your executor can do:

```lua
local systemInfo = manager.nodefecth()

-- Check what's available
if systemInfo.filesystem.writefile then
    print("✅ You can create files!")
end

if systemInfo.http.request then
    print("✅ You can download from the internet!")
end

if systemInfo.gui["Drawing.new"] then
    print("✅ You can create custom GUIs!")
end
```

## ❓ Troubleshooting

### "Cannot create file" Error
```lua
-- Make sure you're providing both parameters
manager.new("filename.txt", "content") -- ✅ Correct
manager.new("filename.txt") -- ❌ Missing content
```

### "Failed to download file" Error
```lua
-- Check your internet connection and URL
manager.download("https://example.com/file.txt", "downloaded.txt", "GET") -- ✅ Correct
manager.download("invalid-url", "downloaded.txt", "GET") -- ❌ Invalid URL
```

### GUI Not Showing
```lua
-- Make sure you're in a Roblox game with PlayerGui access
if game and game.Players and game.Players.LocalPlayer then
    manager.createSampleHtmlGui() -- Should work
else
    print("Not in a valid Roblox game environment")
end
```

## 📚 Next Steps

Now that you're up and running:

1. **Read the full documentation**: Check out [README.md](README.md) for complete features
2. **Explore the API**: See [API.md](API.md) for detailed function reference
3. **Try examples**: Experiment with the examples in the documentation
4. **Join the community**: Share your creations and get help

## 🎉 You're Ready!

You now know the basics of the Local Manager Library. Start building amazing things with file management, HTTP operations, and HTML-to-GUI conversion!

### Quick Reference

| Function | What it does | Example |
|----------|-------------|---------|
| `manager.new()` | Create a file | `manager.new("file.txt", "content")` |
| `manager.move()` | Move a file | `manager.move("old.txt", "new.txt")` |
| `manager.dfile()` | Delete file with undo | `manager.dfile("file.txt", false)` |
| `manager.download()` | Download from URL | `manager.download("https://example.com/file.txt", "local.txt", "GET")` |
| `manager.html()` | Load HTML or convert to GUI | `manager.html(nil, true, "page.html", true)` |
| `manager.media()` | Play audio files | `manager.media("song.mp3", "audio", "audio", false)` |
| `manager.getScriptFolder()` | Get scriptfolder | `manager.getScriptFolder()` |
| `manager.nodefecth()` | Check system capabilities | `manager.nodefecth()` |

---

**Happy scripting! 🚀**
