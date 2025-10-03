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
                    -- local files here
                elseif isroblox then
                    -- roblox audio here
                end
                if _type == "Video" then
                    if islocal then
                        -- local files here
                    elseif isroblox then
                        -- roblox videos here, keep in mind roblox don't support videos really well
                    end
                end
            end
        else
            return "cannot load media, " .. tostring(_type) .. " is not a type of media."
        end
    end
end

return media
