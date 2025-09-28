-- welcome to local manager library
-- this library is used to manage local files and directories easly
-- this library is not a file manager, it is a library
-- this library is based on luau language with a roblox executor.

local manager = {}

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

-- okay here should be a part for handling mp3 files and oher media files but im not sure how to do it

function manager.media(path, type)
    local ismedia = nil
    return path
end

-- lets add a fucking html handler, we need website within roblox right???

function manager.html(url, islocal, path, convertToGui, parentGui)
    -- error handling 
    if not path then
        return "cannot handle html, did you forget to add path?"
    elseif not islocal and not url then
        return "i won't classify that you are a programmer, put the url and the path, and say if it local or not. dont keep it empty"
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
                    table.insert(elements, {type = "text", content = text})
                end
                break
            end
            
            -- Add text before tag
            if startTag > currentPos then
                local text = html:sub(currentPos, startTag - 1):gsub("^%s*", ""):gsub("%s*$", "")
                if text ~= "" then
                    table.insert(elements, {type = "text", content = text})
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
                guiElement.Size = UDim2.new(0, tonumber(styles["width"]) or 100, guiElement.Size.Y.Scale, guiElement.Size.Y.Offset)
            end
            if styles["height"] then
                guiElement.Size = UDim2.new(guiElement.Size.X.Scale, guiElement.Size.X.Offset, 0, tonumber(styles["height"]) or 30)
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

return manager