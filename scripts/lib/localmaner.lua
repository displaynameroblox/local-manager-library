-- welcome to local manager library
-- this library is used to manage local files and directories easly
-- this library is not a file manager, it is a library
-- this library is based on luau language with a roblox executor.

local manager = {}

-- ScriptFolder Management System
local scriptFolder = nil

local function getScriptFolder()
    if not scriptFolder or not scriptFolder.Parent then
        -- Create or find the scriptfolder
        local existingFolder = game.Workspace:FindFirstChild("scriptfolder")

        if existingFolder then
            scriptFolder = existingFolder
        else
            local success, folder = pcall(function()
                local folder = Instance.new("Folder")
                folder.Name = "scriptfolder"
                folder.Parent = game.Workspace
                return folder
            end)

            if success then
                scriptFolder = folder
                print("📁 Created scriptfolder in workspace")
            else
                print("❌ Failed to create scriptfolder:", folder)
                return nil
            end
        end
    end

    return scriptFolder
end

local function cleanupScriptFolder()
    if scriptFolder then
        local success = pcall(function()
            scriptFolder:Destroy()
        end)

        if success then
            scriptFolder = nil
            print("🧹 Cleaned up scriptfolder")
        else
            print("❌ Failed to cleanup scriptfolder")
        end
    end
end

local function nodefecth()
    -- nodefecth but for this library, funny i know right?
    print("╭─────────────────────────────────────────────────────────────╮")
    print("│                    Local Manager Library                    │")
    print("│                      System Information                     │")
    print("╰─────────────────────────────────────────────────────────────╯")
    print()

    local systemInfo = {}

    -- Test 1: Executor Detection
    print("🔍 Testing Executor...")
    local executorSuccess, executorName, executorVersion = pcall(function()
        return identifyexecutor()
    end)

    if executorSuccess and executorName then
        systemInfo.executor = {
            name = executorName,
            version = executorVersion or "Unknown",
            available = true
        }
        print("✅ Executor: " .. executorName .. " v" .. (executorVersion or "Unknown"))
    else
        systemInfo.executor = {
            name = "Unknown",
            version = "Unknown",
            available = false
        }
        print("❌ Executor: Not detected or not available")
    end
    print()

    -- Test 2: Game Environment
    print("🎮 Testing Game Environment...")
    local gameSuccess = pcall(function()
        return game ~= nil
    end)

    if gameSuccess and game then
        systemInfo.game = {
            available = true,
            placeId = game.PlaceId or "Unknown",
            gameId = game.GameId or "Unknown"
        }
        print("✅ Game Environment: Available")
        print("   Place ID: " .. (game.PlaceId or "Unknown"))
        print("   Game ID: " .. (game.GameId or "Unknown"))
    else
        systemInfo.game = {
            available = false,
            placeId = "N/A",
            gameId = "N/A"
        }
        print("❌ Game Environment: Not available")
    end
    print()

    -- Test 3: Filesystem Operations
    print("📁 Testing Filesystem...")
    local fsTests = {
        { name = "listfiles", func = function() listfiles(".") end },
        { name = "isfile",    func = function() return isfile("test.txt") end },
        { name = "isfolder",  func = function() return isfolder("test") end },
        {
            name = "readfile",
            func = function()
                local success = pcall(function() readfile("nonexistent.txt") end)
                return success -- This should fail, but the function exists
            end
        },
        {
            name = "writefile",
            func = function()
                writefile("nodefecth_test.txt", "test")
                return true
            end
        }
    }

    systemInfo.filesystem = {}
    for _, test in ipairs(fsTests) do
        local success = pcall(test.func)
        systemInfo.filesystem[test.name] = success
        if success then
            print("✅ " .. test.name .. ": Available")
        else
            print("❌ " .. test.name .. ": Not available")
        end
    end

    -- Clean up test file
    pcall(function() delfile("nodefecth_test.txt") end)
    print()

    -- Test 4: HTTP/Network Operations
    print("🌐 Testing HTTP/Network...")
    local httpTests = {
        {
            name = "request",
            func = function()
                request({ Url = "https://httpbin.org/get", Method = "GET" })
                return true
            end
        },
        {
            name = "game:HttpGet",
            func = function()
                if game and game.HttpGet then
                    game:HttpGet("https://httpbin.org/get")
                    return true
                end
                return false
            end
        }
    }

    systemInfo.http = {}
    for _, test in ipairs(httpTests) do
        local success = pcall(test.func)
        systemInfo.http[test.name] = success
        if success then
            print("✅ " .. test.name .. ": Available")
        else
            print("❌ " .. test.name .. ": Not available")
        end
    end
    print()

    -- Test 5: GUI/Drawing Operations
    print("🎨 Testing GUI/Drawing...")
    local guiTests = {
        {
            name = "Drawing.new",
            func = function()
                local circle = Drawing.new("Circle")
                circle:Destroy()
                return true
            end
        },
        {
            name = "Instance.new",
            func = function()
                local frame = Instance.new("Frame")
                frame:Destroy()
                return true
            end
        },
        {
            name = "ScreenGui Creation",
            func = function()
                if game and game.Players and game.Players.LocalPlayer then
                    local screenGui = Instance.new("ScreenGui")
                    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                    screenGui:Destroy()
                    return true
                end
                return false
            end
        }
    }

    systemInfo.gui = {}
    for _, test in ipairs(guiTests) do
        local success = pcall(test.func)
        systemInfo.gui[test.name] = success
        if success then
            print("✅ " .. test.name .. ": Available")
        else
            print("❌ " .. test.name .. ": Not available")
        end
    end
    print()

    -- Test 6: Advanced Executor Features
    print("⚡ Testing Advanced Features...")
    local advancedTests = {
        {
            name = "hookfunction",
            func = function()
                hookfunction(print, function() end)
                return true
            end
        },
        {
            name = "getgenv",
            func = function()
                getgenv()
                return true
            end
        },
        {
            name = "getrenv",
            func = function()
                getrenv()
                return true
            end
        },
        {
            name = "loadstring",
            func = function()
                loadstring("return true")()
                return true
            end
        }
    }

    systemInfo.advanced = {}
    for _, test in ipairs(advancedTests) do
        local success = pcall(test.func)
        systemInfo.advanced[test.name] = success
        if success then
            print("✅ " .. test.name .. ": Available")
        else
            print("❌ " .. test.name .. ": Not available")
        end
    end
    print()

    -- Test 7: Memory and Performance
    print("🧠 Testing Memory/Performance...")
    local memorySuccess, gc = pcall(function() return getgc() end)
    local regSuccess, reg = pcall(function() return getreg() end)

    systemInfo.memory = {
        getgc = memorySuccess,
        getreg = regSuccess,
        gcCount = memorySuccess and #gc or 0,
        regCount = regSuccess and #reg or 0
    }

    if memorySuccess then
        print("✅ getgc: Available (" .. #gc .. " objects)")
    else
        print("❌ getgc: Not available")
    end

    if regSuccess then
        print("✅ getreg: Available (" .. #reg .. " objects)")
    else
        print("❌ getreg: Not available")
    end
    print()

    -- Display System Summary
    print("╭─────────────────────────────────────────────────────────────╮")
    print("│                        System Summary                       │")
    print("╰─────────────────────────────────────────────────────────────╯")

    local totalTests = 0
    local passedTests = 0

    -- Count tests and results
    for category, tests in pairs(systemInfo) do
        if type(tests) == "table" then
            for testName, result in pairs(tests) do
                if type(result) == "boolean" then
                    totalTests = totalTests + 1
                    if result then
                        passedTests = passedTests + 1
                    end
                end
            end
        end
    end

    local successRate = totalTests > 0 and math.floor((passedTests / totalTests) * 100) or 0

    print("📊 Overall System Status:")
    print("   Tests Passed: " .. passedTests .. "/" .. totalTests)
    print("   Success Rate: " .. successRate .. "%")
    print()

    if systemInfo.executor.available then
        print("🚀 Executor: " .. systemInfo.executor.name .. " v" .. systemInfo.executor.version)
    else
        print("🚀 Executor: Unknown/Not Available")
    end

    if systemInfo.game.available then
        print("🎮 Game: Available (Place: " .. systemInfo.game.placeId .. ")")
    else
        print("🎮 Game: Not Available")
    end

    print("📁 Filesystem: " .. (systemInfo.filesystem.listfiles and "✅" or "❌") .. " Core Functions")
    print("🌐 HTTP: " .. (systemInfo.http.request and "✅" or "❌") .. " Network Access")
    print("🎨 GUI: " .. (systemInfo.gui["Drawing.new"] and "✅" or "❌") .. " Drawing Support")
    print("⚡ Advanced: " .. (systemInfo.advanced.hookfunction and "✅" or "❌") .. " Hooking")

    print()
    print("╭─────────────────────────────────────────────────────────────╮")
    print("│                    Local Manager Library                    │")
    print("│                      System Information                     │")
    print("│                        End of Report                       │")
    print("╰─────────────────────────────────────────────────────────────╯")

    return systemInfo
end

-- Make nodefecth accessible through manager
function manager.nodefecth()
    return nodefecth()
end

-- ScriptFolder Management Functions
function manager.getScriptFolder()
    return getScriptFolder()
end

function manager.cleanupScriptFolder()
    return cleanupScriptFolder()
end

function manager.listScriptFolderContents()
    local scriptFolder = getScriptFolder()
    if not scriptFolder then
        return "scriptfolder not found"
    end

    local contents = {}
    for _, child in pairs(scriptFolder:GetChildren()) do
        table.insert(contents, {
            name = child.Name,
            type = child.ClassName,
            children = child:GetChildren()
        })
    end

    return contents
end

function manager.createScriptFolderStructure()
    local scriptFolder = getScriptFolder()
    if not scriptFolder then
        return "failed to create scriptfolder"
    end

    local subFolders = {
        "Audio",  -- Audio files and sounds
        "GUIs",   -- GUI elements
        "Media",  -- Media files
        "Config", -- Configuration
        "Logs",   -- Log files
        "Temp"    -- Temporary files
    }

    local created = 0
    for _, folderName in ipairs(subFolders) do
        if not scriptFolder:FindFirstChild(folderName) then
            local success = pcall(function()
                local folder = Instance.new("Folder")
                folder.Name = folderName
                folder.Parent = scriptFolder
                return folder
            end)

            if success then
                created = created + 1
                print("📁 Created subfolder: " .. folderName)
            end
        end
    end

    return "created " .. created .. " subfolders in scriptfolder"
end

-- Auto-run nodefecth when library loads
print("🔧 Local Manager Library - Running system diagnostics...")
nodefecth()

-- Initialize scriptfolder structure
manager.createScriptFolderStructure()

function manager.new(path, data)
    if not path then
        return "cannot create file, did you forget to add path?"
    elseif not data or data == "" then
        return "cannot create file, did you forget to add data?"
    else
        local success = pcall(function()
            writefile(path, data)
        end)
        if success then
            return "file created successfully"
        else
            return "failed to create file"
        end
    end
end

function manager.move(path, newpath)
    if not path then
        return "cannot move file, did you forget to add source path?"
    elseif not newpath then
        return "cannot move file, did you forget to add destination path?"
    end

    local fileExists = pcall(function()
        return isfile(path)
    end)

    if not fileExists then
        return "source file not found"
    end

    local destExists = pcall(function()
        return isfile(newpath)
    end)

    if destExists then
        return "destination file already exists"
    end

    local readSuccess, fileContent = pcall(function()
        return readfile(path)
    end)

    if not readSuccess then
        return "failed to read source file"
    end

    local writeSuccess = pcall(function()
        writefile(newpath, fileContent)
    end)

    if not writeSuccess then
        return "failed to write to destination file"
    end

    local deleteSuccess = pcall(function()
        delfile(path)
    end)

    if not deleteSuccess then
        return "failed to delete source file"
    end

    return "file moved successfully"
end

function manager.download(url, path, Method, Headers)
    if not url then
        return "cannot download file, did you forget to add the url?"
    elseif not path then
        return "cannot download file, did you forget to add path?"
    elseif not url and not path then
        return "you fucking idiot, how the fuck did you get this far?. put the url and the path"
    end

    local success, response = pcall(function()
        if Method == "GET" then
            return request({
                Url = url,
                Method = Method,
            })
        elseif Method == "POST" then
            return request({
                Url = url,
                Method = Method,
                Headers = Headers,
            })
        else
            return request({
                Url = url,
                Method = "GET"
            })
        end
    end)

    if success then
        if response and response.Body then
            local writeSuccess = pcall(function()
                writefile(path, response.Body)
            end)
            if writeSuccess then
                return "file downloaded successfully"
            else
                return "failed to save file"
            end
        else
            return "invalid response from server"
        end
    else
        return "failed to download file"
    end
end

function manager.changefile(path, newdata)
    local datatobereturn = nil
    local oldata = nil
    -- error handler
    if not path then
        return "cannot readfile, did you forget to add path?: " .. path
    elseif not newdata then
        return "cannot changefile, did you forget to add newdata?: " .. newdata
    end

    -- Check if file exists
    local fileExists = pcall(function()
        return isfile(path)
    end)

    if not fileExists then
        return "file not found: " .. path
    end

    -- Read the old data first
    local readSuccess, oldContent = pcall(function()
        return readfile(path)
    end)

    if not readSuccess then
        return "failed to read file: " .. tostring(oldContent)
    end

    -- Store old data for return
    oldata = oldContent

    -- Write the new data
    local writeSuccess, writeError = pcall(function()
        writefile(path, newdata)
    end)

    if not writeSuccess then
        return "failed to write new data: " .. tostring(writeError)
    end

    -- Return success message with old data
    return "file changed successfully", oldata
end

function manager.dfile(path, isundo, undofile)
    if not path or path == "" then
        return "cannot delete file, did you forget to add path?"
    end

    if isundo then
        -- Undo mode: restore file from backup
        if not undofile or undofile == "" then
            return "cannot undo file deletion, did you forget to add undo file path?"
        end

        -- Check if undo file exists
        local undoExists = pcall(function()
            return isfile(undofile)
        end)

        if not undoExists then
            return "undo file not found: " .. undofile
        end

        -- Read undo file content
        local undoSuccess, undoData = pcall(function()
            return readfile(undofile)
        end)

        if not undoSuccess then
            return "failed to read undo file: " .. undoData
        end

        -- Restore original file
        local restoreSuccess, restoreError = pcall(function()
            writefile(path, undoData)
        end)

        if restoreSuccess then
            -- Delete the undo file after successful restore
            pcall(function()
                delfile(undofile)
            end)
            return "file restored successfully from undo backup"
        else
            return "failed to restore file: " .. restoreError
        end
    else
        -- Normal delete mode: delete file and create backup
        local fileExists = pcall(function()
            return isfile(path)
        end)

        if not fileExists then
            return "file not found: " .. path
        end

        -- Read file content for backup
        local readSuccess, fileData = pcall(function()
            return readfile(path)
        end)

        if not readSuccess then
            return "failed to read file: " .. fileData
        end

        -- Create undo backup file
        local undoPath = undofile or (path .. ".undo")
        local backupSuccess, backupError = pcall(function()
            writefile(undoPath, fileData)
        end)

        if not backupSuccess then
            return "failed to create undo backup: " .. backupError
        end

        -- Delete original file
        local deleteSuccess, deleteError = pcall(function()
            delfile(path)
        end)

        if deleteSuccess then
            return "file deleted successfully, undo backup created at: " .. undoPath
        else
            -- If deletion fails, clean up the backup
            pcall(function()
                delfile(undoPath)
            end)
            return "failed to delete file: " .. deleteError
        end
    end
end

-- okay here should be a part for handling mp3 files and oher media files but im not sure how to do it

function manager.media(_type, media, islocal, isroblox, debug)
    local debug = debug or false
    local typeofmedia = {
        "Audio",
        "Video", 
        "Image",
        "Document"
    }
    local tpyeofdoc = {
        ".pdf", -- somehow, pdf files in roblox. i mean roblox is full of them
        ".doc",
        ".txt",
        ".rtf" -- rich txt is roblox? i'm not quite how to do it
    }
    local tpyeofimage = {
        ".jpeg",
        ".png",
        ".gif",
        ".webP" -- who the fuck do use these?
    }
    local tpyeofvideo = {
        ".mp4",
        ".mov", -- bc i use a mac
        ".avi",
        ".wmv",
        ".mkv"
    }
    local tpyeofaudio = {
        ".mp3",
        ".acc",
        ".wav",
        ".ogg",
        ".m4a"
    }
    
    -- Helper function to check if file extension is valid for the media type
    local function isValidFileExtension(filePath, validExtensions)
        if not filePath or not validExtensions then
            return false
        end
        
        local fileExtension = filePath:match("%.(%w+)$")
        if not fileExtension then
            return false
        end
        
        fileExtension = "." .. fileExtension:lower()
        
        for _, ext in ipairs(validExtensions) do
            if ext:lower() == fileExtension then
                return true
            end
        end
        
        return false
    end

    -- Input validation
    if not islocal and not isroblox and not media then
        if debug then
            if islocal then
                return "cannot find media, did you forget to add media?. media found:" ..
                    tostring(media) .. " is local?" .. tostring(islocal)
            elseif isroblox then
                return "cannot find media, did you forget to add media?. media found:" ..
                    tostring(media) .. " is roblox id?" .. tostring(isroblox)
            end
        else
            return "cannot find media, did you forget to add media?"
        end
    end

    if not _type then
        if debug then
            return "cannot find type, did you to add type?. type found: " .. tostring(_type)
        else
            return "cannot find type, did you forget to add type?"
        end
    end

    if not media then
        if debug then
            if islocal then
                return "cannot find path to media, did you forget to add media?. path found: " .. tostring(media)
            elseif isroblox then
                return "cannot find id of media, did you forget to add media?. id found: " .. tostring(media)
            end
        else
            if islocal then
                return "cannot find path to media, did you forget to add media?"
            elseif isroblox then
                return "cannot find id of media, did you forget to add media?"
            end
        end
    end

    if not islocal and isroblox == nil then
        if debug then
            return "cannot find islocal, did you set is local?. islocal found: " .. tostring(islocal)
        else
            return "cannot find islocal, did you forget to set is local?"
        end
    elseif not isroblox and islocal == nil then
        if debug then
            return "cannot find isroblox, did you forget to set is roblox?. isroblox found: " .. tostring(isroblox)
        else
            return "cannot find isroblox, did you forget to set is roblox?"
        end
    end

    -- Validate media type
    local isValidType = false
    for _, validType in ipairs(typeofmedia) do
        if _type == validType then
            isValidType = true
            break
        end
    end

    if not isValidType then
        return "cannot load media, " .. tostring(_type) .. " is not a type of media."
    end

    -- Handle different media types
    if _type == "Audio" then
        if islocal then
            -- Check if file extension is valid for audio
            if not isValidFileExtension(media, tpyeofaudio) then
                return "cannot load audio, " .. tostring(media) .. " is not a valid audio file format. Supported formats: " .. table.concat(tpyeofaudio, ", ")
            end
            
            local soundid = getcustomasset(media)
            local sound = Instance.new("Sound")
            local soundname = media:split("/")
            sound.SoundId = soundid
            sound.Name = soundname[#soundname]
            sound.Parent = game.Workspace
            
            -- Check the sound
            if sound then
                if sound.IsLoaded then
                    local played = pcall(function()
                        sound.Volume = 1
                        sound:Play()
                    end)
                    if not played then
                        sound:Stop()
                        return "cannot play sound, " .. tostring(media) .. " is not a valid sound."
                    else
                        sound:Stop()
                        return sound
                    end
                end
            end
            return sound
        elseif isroblox then
            local soundid = nil
            if media:match("^rbxassetid://") then
                soundid = media
            else
                return "cannot play sound, " .. tostring(media) .. " is not a valid sound."
            end
            local sound = Instance.new("Sound")
            sound.SoundId = soundid
            sound.Name = soundid:split("/")
            sound.Volume = 1
            sound.Parent = game.Workspace
            if sound then
                if sound.IsLoaded then
                    local played = pcall(function()
                        sound.Volume = 0
                        sound:Play()
                    end)
                    if not played then
                        sound:Stop()
                        return "cannot play sound, " .. tostring(media) .. " is not a valid sound."
                    else
                        sound:Stop()
                        return sound
                    end
                end
            end
            return sound
        end
    elseif _type == "Video" then
        if islocal then
            -- Check if file extension is valid for video
            if not isValidFileExtension(media, tpyeofvideo) then
                return "cannot load video, " .. tostring(media) .. " is not a valid video file format. Supported formats: " .. table.concat(tpyeofvideo, ", ")
            end
            
            local videoid = getcustomasset(media)
            local video = Instance.new("VideoFrame")
            video.Video = videoid
            video.Name = videoid:split("/")
            video.Parent = game.Workspace
            video.Volume = 1
            if video then
                if video.IsLoaded then
                    local played = pcall(function()
                        video.Volume = 0
                        video:Play()
                    end)
                    if not played then
                        video:Stop()
                        return "cannot play video, " .. tostring(media) .. " is not a valid video."
                    else
                        video:Stop()
                        return video
                    end
                end
            end
            return video
        elseif isroblox then
            -- roblox videos here, keep in mind roblox don't support videos really well
            local videoid = nil
            if media:match("^rbxassetid://") then
                videoid = media
            else
                return "cannot play video, " .. tostring(media) .. " is not a valid video."
            end
            local video = Instance.new("VideoFrame")
            video.Video = videoid
            video.Name = videoid:split("/")
            video.Parent = game.Workspace
            video.Volume = 1
            if video then
                if video.IsLoaded then
                    local played = pcall(function()
                        video.Volume = 0
                        video:Play()
                    end)
                    if not played then
                        video:Stop()
                        return "cannot play video, " .. tostring(media) .. " is not a valid video."
                    else
                        video:Stop()
                        return video
                    end
                end
            end
            return video
        end
    elseif _type == "Image" then
        if islocal then
            -- Check if file extension is valid for image
            if not isValidFileExtension(media, tpyeofimage) then
                return "cannot load image, " .. tostring(media) .. " is not a valid image file format. Supported formats: " .. table.concat(tpyeofimage, ", ")
            end
            
            local imageid = getcustomasset(media)
            local image = Instance.new("ImageLabel")
            image.Image = imageid
            image.Name = imageid:split("/")
            image.Parent = game.Workspace
            return image
            -- we cannot check if the image is valid just yet, that for later
        elseif isroblox then
            local imageid = nil
            if media:match("^rbxassetid://") then
                imageid = media
            else
                return "cannot play image, " .. tostring(media) .. " is not a valid image."
            end
            local image = Instance.new("ImageLabel")
            image.Image = imageid
            image.Name = imageid:split("/")
            image.Parent = game.Workspace
            return image
        end
    elseif _type == "Document" then
        if islocal then
            -- Check if file extension is valid for document
            if not isValidFileExtension(media, tpyeofdoc) then
                return "cannot load document, " .. tostring(media) .. " is not a valid document file format. Supported formats: " .. table.concat(tpyeofdoc, ", ")
            end
            
            local imageid = getcustomasset(media)
            local image = Instance.new("TextLabel")
            image.Text = imageid
            image.Name = imageid:split("/")
            image.Parent = game.Workspace
            return image
        elseif isroblox then
            local imageid = nil
            if media:match("^rbxassetid://") then
                imageid = media
            else
                return "cannot play document, " .. tostring(media) .. " is not a valid document."
            end
            local image = Instance.new("TextLabel")
            image.Image = imageid
            image.Name = imageid:split("/")
            image.Parent = game.Workspace
            image.TextColor3 = Color3.new(1, 1, 1)
            image.TextScaled = true
            image.TextSize = 16
            image.TextStrokeTransparency = 0
            image.TextStrokeColor3 = Color3.new(0, 0, 0)
            image.TextStrokeTransparency = 0
            return image
        end
    end
end

-- lets add a fucking html handler, we need website within roblox right???

function manager.html(url, islocal, path, convertToGui, parentGui)
    -- error handling
    if not path then
        return "cannot handle html, did you forget to add path?"
    elseif not islocal and not url then
        return
        "i won't classify that you are a programmer, put the url and the path, and say if it local or not. dont keep it empty"
    end

    local htmlContent = nil

    if islocal then
        -- handle local file
        local fileExists = pcall(function()
            return isfile(path)
        end)
        if fileExists then
            local readSuccess, content = pcall(function()
                return readfile(path)
            end)
            if readSuccess then
                htmlContent = content
            else
                return "failed to read local file"
            end
        else
            return "file not found, did you type the path wrong?"
        end
    else
        -- handle online URL
        if not url then
            return "cannot find url, did you forget to add url?"
        end

        -- http handler
        -- we start of by pinging the url if the website is online
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)

        if success then
            if response and response ~= "" then
                htmlContent = response

                -- Save to file
                local writeSuccess = pcall(function()
                    writefile(path, response)
                end)
                if not writeSuccess then
                    print("Warning: Failed to save HTML to file")
                end
            else
                return "received empty response from server"
            end
        else
            return "cannot find url, or it's offline"
        end
    end

    -- If convertToGui is true, convert HTML to GUI instead of returning content
    if convertToGui and htmlContent then
        return manager._htmlToGuiInternal(htmlContent, parentGui)
    elseif htmlContent then
        return htmlContent
    else
        return "no HTML content available"
    end
end

-- Internal HTML to Roblox GUI Converter (used by html function)
function manager._htmlToGuiInternal(htmlContent, parentGui)
    if not htmlContent then
        return "cannot convert html, did you forget to add html content?"
    end

    if not parentGui then
        -- Create a default ScreenGui if no parent is provided
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "HTMLToGui_" .. tick()
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        parentGui = screenGui

        -- Also add to scriptfolder for organization
        local scriptFolder = getScriptFolder()
        if scriptFolder then
            local guiFolder = scriptFolder:FindFirstChild("GUIs")
            if not guiFolder then
                guiFolder = Instance.new("Folder")
                guiFolder.Name = "GUIs"
                guiFolder.Parent = scriptFolder
            end

            -- Create a reference in the scriptfolder
            local guiRef = Instance.new("StringValue")
            guiRef.Name = screenGui.Name
            guiRef.Value = "ScreenGui Reference"
            guiRef.Parent = guiFolder
        end
    end

    -- Simple HTML parser (basic implementation)
    local function parseHTML(html)
        local elements = {}
        local currentPos = 1

        while currentPos <= #html do
            local startTag = html:find("<", currentPos)
            if not startTag then
                -- Add remaining text as text content
                local text = html:sub(currentPos):gsub("^%s*", ""):gsub("%s*$", "")
                if text ~= "" then
                    table.insert(elements, { type = "text", content = text })
                end
                break
            end

            -- Add text before tag
            if startTag > currentPos then
                local text = html:sub(currentPos, startTag - 1):gsub("^%s*", ""):gsub("%s*$", "")
                if text ~= "" then
                    table.insert(elements, { type = "text", content = text })
                end
            end

            local endTag = html:find(">", startTag)
            if not endTag then break end

            local tagContent = html:sub(startTag + 1, endTag - 1)
            local tagName, attributes = parseTag(tagContent)

            if tagName then
                table.insert(elements, {
                    type = "element",
                    tag = tagName,
                    attributes = attributes,
                    selfClosing = tagContent:sub(-1) == "/"
                })
            end

            currentPos = endTag + 1
        end

        return elements
    end

    -- Parse tag and attributes
    local function parseTag(tagContent)
        local tagName = tagContent:match("^([%w-]+)")
        if not tagName then return nil end

        local attributes = {}
        local attrPattern = '([%w-]+)%s*=%s*["\']([^"\']*)["\']'

        for attr, value in tagContent:gmatch(attrPattern) do
            attributes[attr] = value
        end

        return tagName:lower(), attributes
    end

    -- Convert HTML elements to Roblox GUI
    local function createGuiFromElements(elements, parent)
        for _, element in ipairs(elements) do
            if element.type == "text" then
                -- Create TextLabel for text content
                local textLabel = Instance.new("TextLabel")
                textLabel.Text = element.content
                textLabel.Size = UDim2.new(1, 0, 0, 20)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.new(1, 1, 1)
                textLabel.Font = Enum.Font.SourceSans
                textLabel.TextSize = 14
                textLabel.Parent = parent
            elseif element.type == "element" then
                local guiElement = createGuiElement(element.tag, element.attributes)
                if guiElement then
                    guiElement.Parent = parent

                    -- Handle nested content (simplified)
                    if not element.selfClosing and element.children then
                        createGuiFromElements(element.children, guiElement)
                    end
                end
            end
        end
    end

    -- Create GUI element based on HTML tag
    local function createGuiElement(tagName, attributes)
        local guiElement = nil

        if tagName == "div" or tagName == "container" then
            guiElement = Instance.new("Frame")
            guiElement.Size = UDim2.new(1, 0, 1, 0)
            guiElement.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        elseif tagName == "button" then
            guiElement = Instance.new("TextButton")
            guiElement.Size = UDim2.new(0, 100, 0, 30)
            guiElement.Text = attributes.value or attributes.text or "Button"
            guiElement.BackgroundColor3 = Color3.new(0.3, 0.5, 1)
            guiElement.TextColor3 = Color3.new(1, 1, 1)
            guiElement.Font = Enum.Font.SourceSansBold
        elseif tagName == "input" or tagName == "textbox" then
            guiElement = Instance.new("TextBox")
            guiElement.Size = UDim2.new(0, 200, 0, 30)
            guiElement.PlaceholderText = attributes.placeholder or ""
            guiElement.Text = attributes.value or ""
            guiElement.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            guiElement.TextColor3 = Color3.new(1, 1, 1)
        elseif tagName == "label" or tagName == "span" then
            guiElement = Instance.new("TextLabel")
            guiElement.Size = UDim2.new(1, 0, 0, 20)
            guiElement.Text = attributes.value or ""
            guiElement.BackgroundTransparency = 1
            guiElement.TextColor3 = Color3.new(1, 1, 1)
            guiElement.Font = Enum.Font.SourceSans
        elseif tagName == "h1" or tagName == "h2" or tagName == "h3" then
            guiElement = Instance.new("TextLabel")
            guiElement.Size = UDim2.new(1, 0, 0, 30)
            guiElement.Text = attributes.value or ""
            guiElement.BackgroundTransparency = 1
            guiElement.TextColor3 = Color3.new(1, 1, 1)
            guiElement.Font = Enum.Font.SourceSansBold
            guiElement.TextSize = tagName == "h1" and 24 or (tagName == "h2" and 20 or 16)
        elseif tagName == "image" or tagName == "img" then
            guiElement = Instance.new("ImageLabel")
            guiElement.Size = UDim2.new(0, 100, 0, 100)
            guiElement.BackgroundTransparency = 1
            if attributes.src then
                guiElement.Image = attributes.src
            end
        elseif tagName == "list" or tagName == "ul" then
            guiElement = Instance.new("Frame")
            guiElement.Size = UDim2.new(1, 0, 1, 0)
            guiElement.BackgroundTransparency = 1

            -- Add ScrollingFrame for list functionality
            local scrollingFrame = Instance.new("ScrollingFrame")
            scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
            scrollingFrame.BackgroundTransparency = 1
            scrollingFrame.ScrollBarThickness = 8
            scrollingFrame.Parent = guiElement
        end

        -- Apply basic styling from attributes
        if guiElement and attributes then
            applyGuiStyling(guiElement, attributes)
        end

        return guiElement
    end

    -- Apply styling to GUI element
    local function applyGuiStyling(guiElement, attributes)
        if attributes.style then
            -- Parse basic CSS-like styling (very simplified)
            local styles = {}
            for style in attributes.style:gmatch("([^;]+)") do
                local property, value = style:match("([^:]+):([^:]+)")
                if property and value then
                    styles[property:gsub("^%s*", ""):gsub("%s*$", "")] = value:gsub("^%s*", ""):gsub("%s*$", "")
                end
            end

            -- Apply common styles
            if styles["background-color"] then
                guiElement.BackgroundColor3 = parseColor(styles["background-color"])
            end
            if styles["color"] then
                if guiElement:IsA("TextLabel") or guiElement:IsA("TextButton") or guiElement:IsA("TextBox") then
                    guiElement.TextColor3 = parseColor(styles["color"])
                end
            end
            if styles["width"] then
                guiElement.Size = UDim2.new(0, tonumber(styles["width"]) or 100, guiElement.Size.Y.Scale,
                    guiElement.Size.Y.Offset)
            end
            if styles["height"] then
                guiElement.Size = UDim2.new(guiElement.Size.X.Scale, guiElement.Size.X.Offset, 0,
                    tonumber(styles["height"]) or 30)
            end
        end
    end

    -- Parse color from string (basic implementation)
    local function parseColor(colorStr)
        if colorStr:find("rgb") then
            local r, g, b = colorStr:match("rgb%((%d+),%s*(%d+),%s*(%d+)%)")
            if r and g and b then
                return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
            end
        elseif colorStr:find("#") then
            local hex = colorStr:gsub("#", "")
            if #hex == 6 then
                local r = tonumber(hex:sub(1, 2), 16) / 255
                local g = tonumber(hex:sub(3, 4), 16) / 255
                local b = tonumber(hex:sub(5, 6), 16) / 255
                return Color3.new(r, g, b)
            end
        end

        -- Default colors for named colors
        local namedColors = {
            red = Color3.new(1, 0, 0),
            green = Color3.new(0, 1, 0),
            blue = Color3.new(0, 0, 1),
            white = Color3.new(1, 1, 1),
            black = Color3.new(0, 0, 0),
            yellow = Color3.new(1, 1, 0),
            purple = Color3.new(0.5, 0, 0.5)
        }

        return namedColors[colorStr:lower()] or Color3.new(1, 1, 1)
    end

    -- Parse HTML and create GUI
    local success, result = pcall(function()
        local elements = parseHTML(htmlContent)
        createGuiFromElements(elements, parentGui)
        return "HTML converted to GUI successfully"
    end)

    if success then
        return result
    else
        return "failed to convert HTML to GUI: " .. tostring(result)
    end
end

-- Convenience function to create a sample HTML GUI
function manager.createSampleHtmlGui()
    local sampleHtml = [[
        <div style="background-color: rgb(40, 40, 40); width: 400; height: 300;">
            <h1 style="color: white;">Welcome to HTML to GUI!</h1>
            <label style="color: white;">Enter your name:</label>
            <input placeholder="Your name here" style="background-color: rgb(60, 60, 60); color: white; width: 200; height: 25;"/>
            <button style="background-color: rgb(0, 120, 255); color: white; width: 100; height: 30;">Submit</button>
            <div style="background-color: rgb(20, 20, 20); width: 350; height: 100;">
                <label style="color: yellow;">This is a sample HTML to GUI conversion!</label>
            </div>
        </div>
    ]]

    return manager._htmlToGuiInternal(sampleHtml)
end

-- New saveas implementation - much better than the old one!
function manager.newsaveas(instance, path, moredebug, content)
    local tobesaved = instance
    local debug = false

    -- Enable debug mode if requested
    if moredebug then
        debug = true
    end

    -- Validate instance parameter
    if tobesaved == nil or tobesaved == false or tobesaved == "" then
        if debug then
            return "cannot saveas, did you forget to add instance?. instance found: " ..
            tostring(tobesaved) .. " path found: " .. tostring(path)
        else
            return "cannot saveas, did you forget to add instance?."
        end
    end

    -- Validate path and instance parameters
    if not path or not instance then
        if debug then
            return "cannot saveas, missing parameters. instance: " .. tostring(instance) .. " path: " .. tostring(path)
        else
            return "cannot saveas, missing required parameters"
        end
    end

    -- Check if file already exists
    if isfile(path) then
        if debug then
            local data = readfile(path)
            return "cannot saveas, file already exists at path: " .. tostring(path) .. " data found: " .. tostring(data)
        else
            return "cannot saveas, file already exists at path"
        end
    end

    -- Handle different instance types
    local success, result = pcall(function()
        if instance == "Sound" then
            -- Create Sound instance
            local file = writefile(path .. ".mp3", "")
            if isfile(file) then
                writecustomasset(file, instance) -- only on wave, i think
                return "file saved successfully at path: " .. tostring(path)
            else
                if debug then
                    return "unknown error. file found: " .. tostring(file) .. ", instance: " .. tostring(instance)
                else
                    return "failed to create sound file"
                end
            end
        elseif instance == "script" then
            -- Create script file
            if not content then
                if debug then
                    return "script saving requires content parameter - use manager.newsaveas('script', path, moredebug, content)"
                else
                    return "script saving requires content parameter"
                end
            end

            local success1, err = pcall(function()
                if content == nil or not content then
                    return false, "cannot save nil content!"
                end

                -- Add .lua extension if not present
                local finalPath = path
                if not path:match("%.lua$") then
                    finalPath = path .. ".lua"
                end

                writefile(finalPath, content)
                return true, finalPath
            end)

            if success1 then
                if debug then
                    return "successfully saved script file in path: " ..
                    tostring(err) .. " with content length: " .. tostring(#content)
                else
                    return "successfully saved script file"
                end
            else
                if debug then
                    return "failed to save script file. path: " .. tostring(path) .. " error: " .. tostring(err)
                else
                    return "failed to save script file"
                end
            end
        elseif instance == "model" then
            -- Model saving with comprehensive error handling
            -- i was here i remeber, meow :3

            -- Validate that tobesaved is actually a Model
            if not tobesaved or not tobesaved:IsA("Model") then
                if debug then
                    return "failed to save model: tobesaved is not a Model instance. Type: " ..
                    tostring(tobesaved and tobesaved.ClassName or "nil")
                else
                    return "failed to save model: invalid model instance"
                end
            end

            -- Validate path format
            if not path:match("%.rbxlx?$") then
                if debug then
                    return "failed to save model: invalid path format. Expected .rbxl or .rbxlx, got: " .. tostring(path)
                else
                    return "failed to save model: invalid file format"
                end
            end

            -- Create save folder with error handling
            local savefolder, folderError = pcall(function()
                local folder = Instance.new("Folder")
                folder.Name = "savefolder"
                folder.Parent = workspace
                return folder
            end)

            if not savefolder then
                if debug then
                    return "failed to create save folder: " .. tostring(folderError)
                else
                    return "failed to create save folder"
                end
            end

            local savefolder = folderError -- The actual folder instance

            -- Clone the model with error handling
            local savemodel, cloneError = pcall(function()
                return tobesaved:Clone()
            end)

            if not savemodel then
                savefolder:Destroy() -- Clean up folder
                if debug then
                    return "failed to clone model: " .. tostring(cloneError)
                else
                    return "failed to clone model"
                end
            end

            local savemodel = cloneError -- The actual cloned model

            -- Set up the cloned model
            local setupSuccess, setupError = pcall(function()
                savemodel.Parent = savefolder
                savemodel.Name = "savemodel"
            end)

            if not setupSuccess then
                savefolder:Destroy() -- Clean up folder
                savemodel:Destroy()  -- Clean up model
                if debug then
                    return "failed to setup cloned model: " .. tostring(setupError)
                else
                    return "failed to setup cloned model"
                end
            end

            -- Save the model to file with error handling
            local saveSuccess, saveError = pcall(function()
                return writefile(path, savemodel)
            end)

            -- Clean up workspace objects
            pcall(function()
                savefolder:Destroy()
            end)

            if saveSuccess then
                if debug then
                    return "successfully saved model file in path: " ..
                    tostring(path) .. " with model: " .. tostring(tobesaved.Name)
                else
                    return "successfully saved model file"
                end
            else
                if debug then
                    return "failed to save model file to path: " .. tostring(path) .. " error: " .. tostring(saveError)
                else
                    return "failed to save model file"
                end
            end
        elseif instance == "image" or instance == "ImageLabel" then
            -- Image saving with comprehensive error handling
            -- hey uh, i like cats i guess

            local availableimages = {
                "ImageLabel",
                "ImageButton",
                "Decal",
                "Texture",
            }
            local availableformats = {
                "png",
                "jpg",
                "jpeg",
                "gif",
                "bmp",
                "tiff",
                "ico",
            }

            -- Validate that tobesaved is a valid image instance
            local isValidImage = false
            for _, imageType in ipairs(availableimages) do
                if tobesaved and tobesaved:IsA(imageType) then
                    isValidImage = true
                    break
                end
            end

            if not isValidImage then
                if debug then
                    local typeInfo = tobesaved and tobesaved.ClassName or "nil"
                    return "failed to save image: tobesaved is not a valid image instance. Type: " ..
                    tostring(typeInfo) .. " (Expected: ImageLabel, ImageButton, Decal, or Texture)"
                else
                    return "failed to save image: invalid image instance"
                end
            end

            -- Validate path format
            local isValidFormat = false
            for _, format in ipairs(availableformats) do
                if path:match("%." .. format .. "$") then
                    isValidFormat = true
                    break
                end
            end

            if not isValidFormat then
                if debug then
                    return "failed to save image: invalid file format. Expected: " ..
                    table.concat(availableformats, ", ") .. " got: " .. tostring(path)
                else
                    return "failed to save image: invalid file format"
                end
            end

            -- Check if image has valid content
            local hasImageContent = false
            if tobesaved:IsA("ImageLabel") or tobesaved:IsA("ImageButton") then
                hasImageContent = tobesaved.Image ~= "" and tobesaved.Image ~= nil
            elseif tobesaved:IsA("Decal") or tobesaved:IsA("Texture") then
                hasImageContent = tobesaved.Texture ~= "" and tobesaved.Texture ~= nil
            end

            if not hasImageContent then
                if debug then
                    local contentField = (tobesaved:IsA("ImageLabel") or tobesaved:IsA("ImageButton")) and "Image" or
                    "Texture"
                    return "failed to save image: no image content found. " .. contentField .. " field is empty"
                else
                    return "failed to save image: no image content"
                end
            end

            -- Save the image with error handling
            local saveSuccess, saveError = pcall(function()
                -- Get the image content based on instance type
                local imageContent = ""
                if tobesaved:IsA("ImageLabel") or tobesaved:IsA("ImageButton") then
                    imageContent = tobesaved.Image
                elseif tobesaved:IsA("Decal") or tobesaved:IsA("Texture") then
                    imageContent = tobesaved.Texture
                end

                return writefile(path, imageContent)
            end)

            if saveSuccess then
                if debug then
                    local imageType = tobesaved.ClassName
                    local imageName = tobesaved.Name
                    return "successfully saved image file in path: " ..
                    tostring(path) .. " with " .. tostring(imageType) .. ": " .. tostring(imageName)
                else
                    return "successfully saved image file"
                end
            else
                if debug then
                    return "failed to save image file to path: " .. tostring(path) .. " error: " .. tostring(saveError)
                else
                    return "failed to save image file"
                end
            end
        elseif instance == "video" or instance == "VideoFrame" then
            -- Video saving - still work in progress
            if debug then
                return "🚧 VIDEO SAVING - WORK IN PROGRESS! path: " ..
                tostring(path) .. ", debug: " .. tostring(debug) .. " - Coming soon!"
            else
                return "🚧 VIDEO SAVING - WORK IN PROGRESS! Coming soon!"
            end
        else
            -- Unsupported instance type
            if debug then
                return "unsupported instance type: " ..
                tostring(instance) ..
                " path: " .. tostring(path) .. " - Supported types: Sound, script, model, image, video"
            else
                return "unsupported instance type - Supported: Sound, script, model, image, video"
            end
        end
    end)

    if success then
        return result
    else
        if debug then
            return "failed to save file at path: " .. tostring(path) .. " error: " .. tostring(result)
        else
            return "failed to save file at path"
        end
    end
end

-- alright i might do the most silly thing ever, java to lua function, :p

function manager.javatolua(scripted, doexecute)
    local execute = nil
    local scriptContent = nil

    -- Input validation
    if not scripted then
        return "cannot find script, did you forget to add script?: " .. tostring(scripted)
    end

    if not doexecute then
        return "cannot convert java to lua, did you forget to add doexecute parameter?: " .. tostring(doexecute)
    end

    -- Validate script content
    local validationSuccess = pcall(function()
        if scripted and type(scripted) == "string" and #scripted > 0 then
            scriptContent = scripted
            return true
        else
            return false
        end
    end)

    if not validationSuccess then
        return "invalid script content, please provide a valid string"
    end

    -- Attempt to compile the script
    local compileSuccess, compiledData = pcall(function()
        -- Note: This is a placeholder - actual Java to Lua conversion would require
        -- a proper Java parser and AST transformation
        if scriptContent then
            -- For now, we'll just validate that it looks like it could be Java code
            if scriptContent:find("class") or scriptContent:find("public") or scriptContent:find("private") then
                return "// Converted from Java to Lua (placeholder)\n" .. scriptContent
            else
                return "// Not recognized as Java code\n" .. scriptContent
            end
        else
            return nil
        end
    end)

    if not compileSuccess then
        return "failed to process script: " .. tostring(compiledData)
    end

    -- Execute the converted script if requested
    if doexecute then
        local executeSuccess, executeResult = pcall(function()
            if compiledData then
                loadstring(compiledData)()
                return "script executed successfully"
            else
                return "no compiled data to execute"
            end
        end)

        if executeSuccess then
            return "java to lua conversion completed successfully", compiledData
        else
            return "failed to execute converted script: " .. tostring(executeResult)
        end
    else
        return "java to lua conversion completed successfully", compiledData
    end
end

return manager