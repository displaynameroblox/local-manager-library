-- New saveas implementation for localmaner.lua
local saveas = {}

function saveas.newsaveas(instance, path, moredebug)
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
            if tobesaved and instance then
                local success1, err = pcall(function()
                    if tobesaved == nil or not tobesaved or instance == nil or not instance then
                        return false, "cannot save a nil!"
                    end
                    
                    -- Add .lua extension if not present
                    local finalPath = path
                    if not path:match("%.lua$") then
                        finalPath = path .. ".lua"
                    end
                    
                    writefile(finalPath, tobesaved)
                    return true, finalPath
                end)
                
                if success1 then
                    if debug then
                        return "successfully saved file in path: " .. tostring(err) .. " with content length: " .. tostring(#tobesaved)
                    else
                        return "successfully saved file"
                    end
                else
                    if debug then
                        return "unknown error. path found: " .. tostring(path) .. " instance: " .. tostring(instance) .. " error: " .. tostring(err)
                    else
                        return "unknown error"
                    end
                end
            else
                return "invalid parameters for script saving"
            end
            
        elseif instance == "video" or instance == "model" then
            -- Coming soon for video and model
            if debug then
                return "cannot saveas, more coming soon! path: " .. tostring(path) .. ", debug: " .. tostring(debug)
            else
                return "cannot saveas, more coming soon!"
            end
            
        else
            -- Unsupported instance type
            if debug then
                return "unsupported instance type: " .. tostring(instance) .. " path: " .. tostring(path)
            else
                return "unsupported instance type"
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

return saveas