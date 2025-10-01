-- update to saveas in the localmaner.lua, its being worked on
local saveas = {}

function saveas.newsaveas(instance, path, moredebug)
    local tobesaved = instance
    local debug = nil -- new feature, more debugging for saveas!
    if moredebug then
        debug = true
    end
    if tobesaved == nil or tobesaved == false or tobesaved == "" then
        if debug then
            return "cannot saveas, did you forget to add instance?. instance found: " .. tostring(tobesaved) .. " path found: " .. tostring(path)
        elseif not debug then
            return "cannot saveas, did you forget to add instance?."
        end
    end
    if path and tobesaved and instance then 
        local success, err = pcall(function()
            if isfile(path) then
                if debug then
                    local data = readfile(path)
                    return "cannot saveas, file already exists at path: " .. tostring(path).."data found"..tostring(data)
                elseif not debug then
                    return "cannot saveas, file already exists at path"
                elseif not isfile(path) then
                    local worte, err = pcall(function()
                        if instance == "Sound" then
                            if isfile(path) then
                                return "file already exists, cannot overwire file"
                            else
                                local file = writefile(path..".mp3",nil)
                            end
                            if isfile(file) then
                                writecustomasset(file, instance) -- only on wave, i think
                            else
                                if debug then
                                    return "unknown error. file found: "..tostring(file)..", instance:"..tostring(instance)
                                end
                            end
                        elseif instance == "script" then
                            if path and instance and tobesaved then
                                local worte1 = pcall(function()
                                    if tobesaved == nil or not tobesaved or instance == nil or not instance then
                                        return "cannot save a nil!"
                                    elseif tobesaved and instance then
                                        if isfile(path) then
                                            return "cannot saveas, file already exists"
                                        elseif not isfile(path) then 
                                            local success1 = pcall(function()
                                                if path ~= ".lua" then
                                                writefile(path, tobesaved)
                                                else
                                                    writefile(path..".lua", tobesaved)
                                                end
                                            end)
                                            if success1 then
                                                if debug then
                                                    return "successfully saved file in path: "..tostring(path).."with: "..tostring(tobesaved.name)
                                                else
                                                    return "successfully saved file"
                                                end
                                            elseif not success1 then
                                                if debug then
                                                    return "unknown error. path found: "..tostring(path).." instance: "..tostring(tobesaved.name)
                                                else
                                                    return "unknown error"
                                                end
                                            end
                                        end
                                    end
                                end)
                                if worte1 then
                                    if debug then
                                        return "saved file in: "..tostring(path)
                                    else
                                        return "successfully saved file!"
                                    end
                                end
                            end
                        elseif instance == "video" or instance == "model" or then
                            if debug then
                                return "cannot saveas, more coming soon!"..tonumber(path)..","..tostring(debug) -- coming soon thingy
                            end
                        end
                        return "file saved successfully at path: " .. tostring(path)
                    end)
                    if not worte then
                        if debug then
                            return "failed to save file at path: " .. tostring(path) .. "error: " .. tostring(err)
                        elseif not debug then
                            return "failed to save file at path"
                        end
                    end
                end
            end)
            if not success then
                if debug then
                    return "failed to save file at path: " .. tostring(path) .. "error: " .. tostring(err)
                elseif not debug then
                    return "failed to save file at path"
                end
            end
        end)
    end
end

return saveas