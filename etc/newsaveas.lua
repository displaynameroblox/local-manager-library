-- newsaveas.lua - Work in Progress
-- This file contains the experimental saveas implementation that's still being developed
-- for model and image saving capabilities.
-- 
-- Current Status:
-- - Sound saving: ✅ Working (integrated into main library)
-- - Script saving: ✅ Working (integrated into main library) 
-- - Model saving: Done mostly <-- do not trust this man its not done still experimental!
-- - Image saving: experimental
-- - video saving: work in progress
--
-- This file is kept separate for development and testing purposes.

local newsaveas = {}

function newsaveas.newsaveas(instance, path, moredebug, content)
    local tobesaved = instance
    local debug = false
    
    -- Enable debug mode if requested
    if moredebug then
        debug = true
    end
    
    -- Validate instance parameter
    if tobesaved == nil or tobesaved == false or tobesaved == "" then
        if debug then
            return "cannot saveas, did you forget to add instance?. instance found: " .. tostring(tobesaved) .. " path found: " .. tostring(path)
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
                    return "script saving requires content parameter - use newsaveas.newsaveas('script', path, moredebug, content)"
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
                    return "successfully saved script file in path: " .. tostring(err) .. " with content length: " .. tostring(#content)
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
                    return "failed to save model: tobesaved is not a Model instance. Type: " .. tostring(tobesaved and tobesaved.ClassName or "nil")
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
                savemodel:Destroy() -- Clean up model
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
                    return "successfully saved model file in path: " .. tostring(path) .. " with model: " .. tostring(tobesaved.Name)
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
                    return "failed to save image: tobesaved is not a valid image instance. Type: " .. tostring(typeInfo) .. " (Expected: ImageLabel, ImageButton, Decal, or Texture)"
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
                    return "failed to save image: invalid file format. Expected: " .. table.concat(availableformats, ", ") .. " got: " .. tostring(path)
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
                    local contentField = (tobesaved:IsA("ImageLabel") or tobesaved:IsA("ImageButton")) and "Image" or "Texture"
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
                    return "successfully saved image file in path: " .. tostring(path) .. " with " .. tostring(imageType) .. ": " .. tostring(imageName)
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
          -- alright, no one will use this, so ill do it
            if debug then
                return "🚧 VIDEO SAVING - WORK IN PROGRESS! path: " .. tostring(path) .. ", debug: " .. tostring(debug) .. " - Coming soon!"
            else
                return "🚧 VIDEO SAVING - WORK IN PROGRESS! Coming soon!"
            end
            
        else
            -- Unsupported instance type
            if debug then
                return "unsupported instance type: " .. tostring(instance) .. " path: " .. tostring(path) .. " - Supported types: Sound, script, model, image, video"
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

-- Experimental function for model saving (WORK IN PROGRESS)
function newsaveas._saveasModel(modelData, path, debug)
    -- TODO: Implement model saving
    -- This function will handle:
    -- 1. Model serialization
    -- 2. Instance creation
    -- 3. File saving
    
    if debug then
        return "🚧 _saveasModel - WORK IN PROGRESS! modelData: " .. tostring(modelData) .. " path: " .. tostring(path)
    else
        return "🚧 Model saving is work in progress!"
    end
end

-- Experimental function for image saving (WORK IN PROGRESS)
function newsaveas._saveasImage(imageData, path, debug)
    -- TODO: Implement image saving
    -- This function will handle:
    -- 1. Image format detection
    -- 2. ImageLabel creation
    -- 3. Image data processing
    
    if debug then
        return "🚧 _saveasImage - WORK IN PROGRESS! imageData length: " .. tostring(#imageData) .. " path: " .. tostring(path)
    else
        return "🚧 Image saving is work in progress!"
    end
end

-- Experimental function for video saving (WORK IN PROGRESS)
function newsaveas._saveasVideo(videoData, path, debug)
    if not videoData then
        if debug then
            return "cannot saveas, did you forget to add video data?. video found: "..tostring(videoData.Name) or tostring(videoData)
        else
            return "cannot saveas, did you to add video?"
        end
    elseif not path then
        if debug then
            return "cannot saveas, did you forget to add path?. path found was: "..tostring(path)
        end
    end
    if path and videoData then
        if videoData:IsA("video") or videoData:IsA("VideoFrame") then
            local success2, writeError1 = pcall(function()
                local data = videoData
                local videoformats ={
                    ".mp4",
                    ".mov",
                    ".avi",
                    ".mkv" -- alright who the fuck do uses these
                }
                if path:match("%"..videoformats) then
                    local videoid = videoData or getcustomasset(videoData) or data 
                    local tobesaved1 = instance.new("VideoFrame", workspace)
                    tobesaved1.Name = videoData.Name or path
                    tobesaved1.id = videoid
                    if tobesaved1 then
                        local saved1 = pcall(function()
                            local newfile = writefile(path, nil)
                            local videoitself = tobesaved1 or videoData or videoid
                            local tobereturned = writecustomasset(newfile, videoitself)
                            return tobereturned, tobesaved1
                        end)
                    end
                end
            end)
            if success2 then
                if debug then 
                    return "successfully saved file in path:"..tostring(path)
                else
                    return "successfully saved file!"
                end
            elseif writeError1 then
                if debug then 
                    return "failed to save file, error: "..tostring(writeError1).."path: "..tostring(path)
                else
                    return "failed to save file"
            end
        end
    end
end

-- Development helper function
function newsaveas.getDevelopmentStatus()
    return {
        Sound = "✅ Working (integrated into main library)",
        Script = "✅ Working (integrated into main library)",
        Model = "🚧 Experimental (basic implementation with error handling)",
        Image = "🚧 Experimental (basic implementation with error handling)", 
        Video = "🚧 Work in Progress",
        lastUpdated = "Development file - experimental features with comprehensive error handling"
    }
end

return newsaveas
