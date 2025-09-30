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

function manager.media(path, type, typeofmedia, isfolder, folder)
    local validmediatypes = {
        video = true,
        audio = true,
        image = true,
        document = true
    }

    -- error handling
    if isfolder then
        -- For folder operations, path is not required but folder is
        if not folder or folder == "" then
            return "cannot handle media folder, did you forget to add folder path?"
        end
    else
        -- For single file operations, path is required
        if not path or path == "" then
            return "cannot handle media, did you forget to add path?"
        end
    end

    if not type or type == "" then
        return "cannot handle media, did you forget to add type?"
    elseif not typeofmedia or typeofmedia == "" then
        return "cannot handle media, did you forget to add typeofmedia?"
    end

    if not validmediatypes[typeofmedia] then
        return "invalid media type"
    end

    if typeofmedia == "video" then
        -- Video handling - experimental but functional
        if isfolder then
            -- Video folder handling not supported yet
            return "video folder playback not supported yet, use single video files"
        else
            -- Handle single video file
            local readsuccess, mediacontent = pcall(function()
                return readfile(path)
            end)
            if not readsuccess then
                return "failed to read video file"
            end

            local videoFrame
            local assetSuccess, assetOrErr = pcall(function()
                return getcustomasset(path)
            end)
            if not assetSuccess then
                return "failed to get custom asset for video"
            end

            local instanceSuccess, instanceErr = pcall(function()
                videoFrame = Instance.new("VideoFrame")
                videoFrame.Name = "Video_" .. path:match("([^/\\]+)$") -- Use filename as video name
                videoFrame.Video = assetOrErr
                videoFrame.Size = UDim2.new(0, 400, 0, 300)            -- Default size
                videoFrame.Position = UDim2.new(0.5, -200, 0.5, -150)  -- Center on screen

                -- Put video in scriptfolder instead of workspace
                local scriptFolder = getScriptFolder()
                if scriptFolder then
                    local mediaFolder = scriptFolder:FindFirstChild("Media")
                    if not mediaFolder then
                        mediaFolder = Instance.new("Folder")
                        mediaFolder.Name = "Media"
                        mediaFolder.Parent = scriptFolder
                    end

                    -- Create a ScreenGui for the video if it doesn't exist
                    local videoGui = scriptFolder:FindFirstChild("VideoGui")
                    if not videoGui then
                        videoGui = Instance.new("ScreenGui")
                        videoGui.Name = "VideoGui"
                        videoGui.Parent = scriptFolder
                    end

                    videoFrame.Parent = videoGui
                else
                    -- Fallback: create ScreenGui in workspace
                    local videoGui = Instance.new("ScreenGui")
                    videoGui.Name = "VideoGui"
                    videoGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                    videoFrame.Parent = videoGui
                end

                -- Start playing the video
                videoFrame:Play()

                -- Optional: Clean up video after it finishes (if video has Ended event)
                if videoFrame.Ended then
                    videoFrame.Ended:Connect(function()
                        videoFrame:Destroy()
                    end)
                end
            end)
            if not instanceSuccess then
                return "failed to play video"
            end

            return "video played successfully", videoFrame -- Return success message and video instance
        end
    end

    if typeofmedia == "audio" then
        if isfolder then
            -- Handle folder of audio files

            local folderExists = pcall(function()
                return isfolder(folder)
            end)

            if not folderExists then
                return "folder not found: " .. folder
            end

            local listSuccess, files = pcall(function()
                return listfiles(folder)
            end)

            if not listSuccess then
                return "failed to list files in folder"
            end

            -- Filter for audio files (common audio extensions)
            local audioExtensions = { ".mp3", ".wav", ".ogg", ".m4a", ".aac" }
            local audioFiles = {}

            for _, file in ipairs(files) do
                local fileName = file:match("([^/\\]+)$") -- Get filename from path
                local extension = fileName:match("%.(%w+)$")
                if extension then
                    extension = "." .. extension:lower()
                    for _, audioExt in ipairs(audioExtensions) do
                        if extension == audioExt then
                            table.insert(audioFiles, file)
                            break
                        end
                    end
                end
            end

            if #audioFiles == 0 then
                return "no audio files found in folder"
            end

            -- Play all audio files in the folder
            local sounds = {}
            local successCount = 0

            for i, audioFile in ipairs(audioFiles) do
                local fileName = audioFile:match("([^/\\]+)$")
                print("Playing audio file " .. i .. "/" .. #audioFiles .. ": " .. fileName)

                local assetSuccess, assetOrErr = pcall(function()
                    return getcustomasset(audioFile)
                end)

                if assetSuccess then
                    local instanceSuccess = pcall(function()
                        local sound = Instance.new("Sound")
                        sound.Name = "Audio_" .. i .. "_" .. fileName
                        sound.SoundId = assetOrErr

                        -- Put sound in scriptfolder instead of workspace
                        local scriptFolder = getScriptFolder()
                        if scriptFolder then
                            local audioFolder = scriptFolder:FindFirstChild("Audio")
                            if not audioFolder then
                                audioFolder = Instance.new("Folder")
                                audioFolder.Name = "Audio"
                                audioFolder.Parent = scriptFolder
                            end
                            sound.Parent = audioFolder
                        else
                            sound.Parent = game.Workspace -- Fallback to workspace
                        end

                        sound.Volume = 0.5 -- Set reasonable volume
                        sound:Play()

                        -- Clean up sound after it finishes playing
                        sound.Ended:Connect(function()
                            sound:Destroy()
                        end)

                        table.insert(sounds, sound)
                    end)

                    if instanceSuccess then
                        successCount = successCount + 1
                    end
                end
            end

            return "played " .. successCount .. "/" .. #audioFiles .. " audio files from folder successfully"
        else
            -- Handle single audio file
            local readsuccess, mediacontent = pcall(function()
                return readfile(path)
            end)
            if not readsuccess then
                return "failed to read media file"
            end

            local sound
            local assetSuccess, assetOrErr = pcall(function()
                return getcustomasset(path)
            end)
            if not assetSuccess then
                return "failed to get custom asset for audio"
            end

            local instanceSuccess, instanceErr = pcall(function()
                sound = Instance.new("Sound")
                sound.Name = "Audio_" .. path:match("([^/\\]+)$") -- Use filename as sound name
                sound.SoundId = assetOrErr

                -- Put sound in scriptfolder instead of workspace
                local scriptFolder = getScriptFolder()
                if scriptFolder then
                    local audioFolder = scriptFolder:FindFirstChild("Audio")
                    if not audioFolder then
                        audioFolder = Instance.new("Folder")
                        audioFolder.Name = "Audio"
                        audioFolder.Parent = scriptFolder
                    end
                    sound.Parent = audioFolder
                else
                    sound.Parent = game.Workspace -- Fallback to workspace
                end

                sound.Volume = 0.5 -- Set reasonable volume
                sound:Play()

                -- Clean up sound after it finishes playing
                sound.Ended:Connect(function()
                    sound:Destroy()
                end)
            end)
            if not instanceSuccess then
                return "failed to play audio"
            end

            return "media played successfully", sound -- Return success message and sound instance
        end
    end

    -- For other media types, just return the file content for now
    local readsuccess, mediacontent = pcall(function()
        return readfile(path)
    end)
    if readsuccess then
        return mediacontent
    else
        return "failed to read media file"
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

function manager.saveas(path, content, type)
    -- ⚠️ EXPERIMENTAL FUNCTION - Use with caution
    -- This function creates instances in the game environment and may not work on all executors

    -- Input validation
    if not path or path == "" then
        return "cannot save file, did you forget to add path?"
    end

    if not content or content == "" then
        return "cannot save file without content"
    end

    if not type or type == "" then
        return "cannot save file without type specification"
    end

    -- Normalize type parameter (case-insensitive)
    type = type:lower()
    if type == "sound" then
        type = "Sound"
    elseif type == "model" then
        type = "Model"
    elseif type == "script" then
        type = "Script"
    elseif type == "image" then
        type = "Image"
    end

    -- Validate supported types
    local supportedTypes = {
        Sound = { implemented = true, experimental = true },
        Model = { implemented = false, experimental = true },
        Script = { implemented = false, experimental = true },
        Image = { implemented = false, experimental = true }
    }

    if not supportedTypes[type] then
        local typeList = {}
        for t, info in pairs(supportedTypes) do
            if info.implemented then
                table.insert(typeList, t .. " (implemented)")
            else
                table.insert(typeList, t .. " (planned)")
            end
        end
        return "unsupported save type: " .. tostring(type) .. ". Supported types: " .. table.concat(typeList, ", ")
    end

    -- Check if type is implemented
    if not supportedTypes[type].implemented then
        return "save type '" ..
            type .. "' is recognized but not yet implemented. This feature is planned for future versions."
    end

    -- Check if file already exists
    local fileExists = pcall(function()
        return isfile(path)
    end)

    if fileExists then
        return "file already exists at path: " .. path
    end

    -- Extract filename from path
    local filename = path:match("([^/\\]+)$")
    if not filename then
        return "invalid file path format: " .. path
    end

    -- Type-specific implementations
    if type == "Sound" then
        return manager._saveasSound(path, content, filename)
    elseif type == "Model" then
        return manager._saveasModel(path, content, filename)
    elseif type == "Script" then
        return manager._saveasScript(path, content, filename)
    elseif type == "Image" then
        return manager._saveasImage(path, content, filename)
    end

    return "unknown error in saveas function"
end

-- Internal function to save Sound instances
function manager._saveasSound(path, content, filename)
    -- Step 1: Validate content is valid audio data
    if type(content) ~= "string" then
        return "invalid content type for Sound: expected string, got " .. type(content)
    end

    if #content < 100 then
        return "content too small to be valid audio data (minimum 100 bytes required)"
    end

    -- Step 2: Write the raw audio file first
    local writeSuccess, writeError = pcall(function()
        return writefile(path, content)
    end)

    if not writeSuccess then
        return "failed to write audio file: " .. tostring(writeError)
    end

    -- Step 3: Create custom asset
    local assetSuccess, assetOrError = pcall(function()
        return getcustomasset(path)
    end)

    if not assetSuccess then
        -- Clean up the written file
        pcall(function() delfile(path) end)
        return "failed to create custom asset for audio: " .. tostring(assetOrError)
    end

    -- Step 4: Create Sound instance
    local instanceSuccess, instanceOrError = pcall(function()
        local sound = Instance.new("Sound")
        if not sound then
            error("Failed to create Sound instance")
        end

        sound.Name = filename:gsub("%.mp3$", ""):gsub("%.wav$", ""):gsub("%.ogg$", "") or "Audio"
        sound.SoundId = assetOrError
        sound.Volume = 0.5 -- Default volume

        -- Try to put in scriptfolder for organization
        local scriptFolder = getScriptFolder()
        if scriptFolder then
            local audioFolder = scriptFolder:FindFirstChild("Audio")
            if not audioFolder then
                audioFolder = Instance.new("Folder")
                audioFolder.Name = "Audio"
                audioFolder.Parent = scriptFolder
            end
            sound.Parent = audioFolder
        else
            -- Fallback to workspace
            sound.Parent = game.Workspace
        end

        return sound
    end)

    if not instanceSuccess then
        -- Clean up the written file
        pcall(function() delfile(path) end)
        return "failed to create Sound instance: " .. tostring(instanceOrError)
    end

    return "file saved successfully as Sound: " .. filename .. " (instance created in game environment)"
end

-- Internal function to save Model instances (EXPERIMENTAL)
function manager._saveasModel(path, content, filename)
    -- This is very experimental and may not work properly
    if type(content) ~= "table" and type(content) ~= "userdata" then
        return "invalid content type for Model: expected Model instance or table, got " .. type(content)
    end

    local success, error = pcall(function()
        local model = Instance.new("Model")
        if not model then
            error("Failed to create Model instance")
        end

        model.Name = filename:gsub("%.rbxl$", ""):gsub("%.rbxlx$", "") or "SavedModel"

        -- Try to clone content if it's a Model instance
        if content and content.Clone then
            local clone = content:Clone()
            clone.Parent = model
        elseif type(content) == "table" then
            -- Try to reconstruct model from table data (very basic)
            for _, childData in pairs(content) do
                if childData.Type and childData.Name then
                    local child = Instance.new(childData.Type)
                    child.Name = childData.Name
                    child.Parent = model
                end
            end
        end

        -- Put in scriptfolder for organization
        local scriptFolder = getScriptFolder()
        if scriptFolder then
            local modelsFolder = scriptFolder:FindFirstChild("Models")
            if not modelsFolder then
                modelsFolder = Instance.new("Folder")
                modelsFolder.Name = "Models"
                modelsFolder.Parent = scriptFolder
            end
            model.Parent = modelsFolder
        else
            model.Parent = game.Workspace
        end

        -- Save metadata to file (very basic)
        local metadata = {
            name = model.Name,
            children = #model:GetChildren(),
            timestamp = tick()
        }

        local metadataString = "Model Metadata:\n"
        metadataString = metadataString .. "Name: " .. metadata.name .. "\n"
        metadataString = metadataString .. "Children: " .. metadata.children .. "\n"
        metadataString = metadataString .. "Timestamp: " .. metadata.timestamp .. "\n"

        writefile(path, metadataString)

        return model
    end)

    if success then
        return "file saved successfully as Model: " ..
            filename .. " (EXPERIMENTAL - instance created in game environment)"
    else
        return "failed to save Model file: " .. tostring(error) .. " (EXPERIMENTAL FEATURE)"
    end
end

-- Internal function to save Script instances (PLANNED)
function manager._saveasScript(path, content, filename)
    if type(content) ~= "string" then
        return "invalid content type for Script: expected string, got " .. type(content)
    end

    -- For now, just save as a regular script file
    local writeSuccess, writeError = pcall(function()
        return writefile(path, content)
    end)

    if not writeSuccess then
        return "failed to write script file: " .. tostring(writeError)
    end

    return "file saved successfully as Script: " ..
        filename .. " (PLANNED FEATURE - instance creation not yet implemented)"
end

-- Internal function to save Image instances (PLANNED)
function manager._saveasImage(path, content, filename)
    if type(content) ~= "string" then
        return "invalid content type for Image: expected string, got " .. type(content)
    end

    -- For now, just save as a regular image file
    local writeSuccess, writeError = pcall(function()
        return writefile(path, content)
    end)

    if not writeSuccess then
        return "failed to write image file: " .. tostring(writeError)
    end

    return "file saved successfully as Image: " ..
        filename .. " (PLANNED FEATURE - instance creation not yet implemented)"
end

-- Helper function to check saveas capabilities
function manager.checkSaveasCapabilities()
    local capabilities = {
        Sound = false,
        Model = false,
        Script = false,
        Image = false,
        InstanceCreation = false,
        CustomAssets = false,
        FileWriting = false
    }

    -- Test Instance creation
    local instanceSuccess = pcall(function()
        local testInstance = Instance.new("Sound")
        testInstance:Destroy()
        return true
    end)
    capabilities.InstanceCreation = instanceSuccess

    -- Test custom asset creation (requires existing file)
    local assetSuccess = pcall(function()
        -- Try to get custom asset for a test file
        local testPath = "test_asset.mp3"
        writefile(testPath, "test audio data")
        local asset = getcustomasset(testPath)
        delfile(testPath)
        return asset ~= nil
    end)
    capabilities.CustomAssets = assetSuccess

    -- Test file writing
    local writeSuccess = pcall(function()
        writefile("test_write.txt", "test")
        local exists = isfile("test_write.txt")
        delfile("test_write.txt")
        return exists
    end)
    capabilities.FileWriting = writeSuccess

    -- Determine supported types based on capabilities
    capabilities.Sound = capabilities.InstanceCreation and capabilities.CustomAssets and capabilities.FileWriting
    capabilities.Model = capabilities.InstanceCreation and capabilities.FileWriting
    capabilities.Script = capabilities.FileWriting
    capabilities.Image = capabilities.FileWriting

    return capabilities
end

-- alright i might do the most silly thing ever, java to lua function, :p

function manager.javatolua(scripted, doexecute)
    local execte = nil
    local string = nil
    if not scripted then
        return "cannot find script, did you forget to add script?" .. scripted
    else
        local worte = pcall(function()
            if scripted then
                string = scripted
            end
        end)
        if worte then
            -- coming soon
            return "coming soon!"
        elseif not worte then
            return "something got wrong, try again. string: " .. string .. "."
        end
    end
end

return manager
