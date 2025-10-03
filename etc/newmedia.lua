-- update for the manger.media function, better error handling and sound and video

local media = {}

function newmedia(_type, media, islocal, isroblox)
    local debug = nil
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
    if not islocal and not isroblox and not media then
        if debug then
            if islocal then
                return "cannot find media, did you forget to add media?. media found:" ..
                    tostring(media) .. " is local?" .. tostring(islocal)
            elseif isroblox then
                return "cannot find media, did you forget to add media?. media found:" ..
                    tostring(media) .. " is roblox id?" .. tostring(isroblox)
            end
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
        elseif not debug then
            return "cannot find islocal, did you forget to set is local?"
        end
    elseif not isroblox and islocal == nil then
        if debug then
            return "cannot find isroblox, did you forget to set is roblox?. isroblox found: " .. tostring(isroblox)
        end
    end
    if media and _type then
        if _type == typeofmedia then
            if _type == "Audio" then -- audio, yay
                if islocal then
                    -- Check if file extension is valid for audio
                    if not isValidFileExtension(media, tpyeofaudio) then
                        return "cannot load audio, " .. tostring(media) .. " is not a valid audio file format. Supported formats: " .. table.concat(tpyeofaudio, ", ")
                    end
                    
                    local soundid = getcustomasset(media)
                    local sound = instance.new("Sound")
                    local soundname = media:split("/")
                    sound.SoundId = soundid
                    sound.Name = soundname[#soundname]
                    sound.Parent = game.Workspace
                    -- we check the sound,
                    if sound then
                        if sound.IsLoaded then
                            local played = pcall(function()
                                sound.Volume = 1
                                sound:play()
                            end)
                            if not played then
                                sound:stop()
                                return "cannot play sound, " .. tostring(media) .. " is not a valid sound."
                            else
                                sound:stop()
                                return sound
                            end
                        end
                    end
                    return sound
                end
                elseif isroblox then
                    local soundid = nil
                    if media:match("^rbxassetid://") then
                        soundid = media
                    else
                        return "cannot play sound, " .. tostring(media) .. " is not a valid sound."
                    end
                    local sound = instance.new("Sound")
                    sound.SoundId = soundid
                    sound.Name = soundid:split("/")
                    sound.Volume = 1
                    sound.Parent = game.Workspace
                    if sound then
                        if sound.IsLoaded then
                            local played = pcall(function()
                                sound.Volume = 0
                                sound:play()
                            end)
                            if not played then
                                sound:stop()
                                return "cannot play sound, " .. tostring(media) .. " is not a valid sound."
                            else
                                sound:stop()
                                return sound
                            end
                        end
                    end
                    return sound
                end
                if _type == "Video" then
                    if islocal then
                        -- Check if file extension is valid for video
                        if not isValidFileExtension(media, tpyeofvideo) then
                            return "cannot load video, " .. tostring(media) .. " is not a valid video file format. Supported formats: " .. table.concat(tpyeofvideo, ", ")
                        end
                        
                        local videoid = getcustomasset(media)
                        local video = instance.new("VideoFrame")
                        video.VideoId = videoid
                        video.Name = videoid:split("/")
                        video.Parent = game.Workspace
                        video.Volume = 1
                        if video then
                            if video.IsLoaded then
                                local played = pcall(function()
                                    video.Volume = 0
                                    video:play()
                                end)
                                if not played then
                                    video:stop()
                                    return "cannot play video, " .. tostring(media) .. " is not a valid video."
                                else
                                    video:stop()
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
                        local video = instance.new("VideoFrame")
                        video.VideoId = videoid
                        video.Name = videoid:split("/")
                        video.Parent = game.Workspace
                        video.Volume = 1
                        if video then
                            if video.IsLoaded then
                                local played = pcall(function()
                                    video.Volume = 0
                                    video:play()
                                end)
                            end
                            if not played then
                                video:stop()
                                return "cannot play video, " .. tostring(media) .. " is not a valid video."
                            else
                                video:stop()
                                return video
                            end
                        end
                        return video
                    end
                end
            if _type == "Image" then
                if islocal then
                    -- Check if file extension is valid for image
                    if not isValidFileExtension(media, tpyeofimage) then
                        return "cannot load image, " .. tostring(media) .. " is not a valid image file format. Supported formats: " .. table.concat(tpyeofimage, ", ")
                    end
                    
                    local imageid = getcustomasset(media)
                    local image = instance.new("ImageLabel")
                    image.Image = imageid
                    image.Name = imageid:split("/")
                    image.Parent = game.Workspace
                    image.Volume = 1
                    return image
                    -- we cannot check if the image is valid just yet, that for later
                elseif isroblox then
                    local imageid = nil
                    if media:match("^rbxassetid://") then
                        imageid = media
                    else
                        return "cannot play image, " .. tostring(media) .. " is not a valid image."
                    end
                    local image = instance.new("ImageLabel")
                    image.Image = imageid
                    image.Name = imageid:split("/")
                    image.Parent = game.Workspace
                    image.Volume = 1
                    return image
                end
            end
            if _type == "Document" then
                if islocal then
                    -- Check if file extension is valid for document
                    if not isValidFileExtension(media, tpyeofdoc) then
                        return "cannot load document, " .. tostring(media) .. " is not a valid document file format. Supported formats: " .. table.concat(tpyeofdoc, ", ")
                    end
                    
                    local imageid = getcustomasset(media)
                    local image = instance.new("TextLabel")
                    image.Text = imageid
                    image.Name = imageid:split("/")
                    image.Parent = game.Workspace
                    image.Volume = 1
                    return image
                elseif isroblox then
                    local imageid = nil
                    if media:match("^rbxassetid://") then
                        imageid = media
                    else
                        return "cannot play document, " .. tostring(media) .. " is not a valid document."
                    end
                    local image = instance.new("TextLabel")
                    image.Image = imageid
                    image.Name = imageid:split("/")
                    image.Parent = game.Workspace
                    image.TextColor3 = Color3.new(1, 1, 1)
                    image.TextScaled = true
                    image.TextSize = 16
                    image.TextStrokeTransparency = 0
                    image.TextStrokeColor3 = Color3.new(0, 0, 0)
                    image.TextStrokeTransparency = 0
                    image.Volume = 1
                    return image
                end
            end
        else
            return "cannot load media, " .. tostring(_type) .. " is not a type of media."
        end
    end
end

return media
