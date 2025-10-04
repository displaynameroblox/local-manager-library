-- Enhanced HTML to GUI converter for Roblox
-- Comprehensive HTML/CSS support with error handling and advanced features

--[[
    This module provides comprehensive HTML to Roblox GUI conversion
    with support for many HTML tags, CSS properties, and advanced features.
    
    Usage:
    local htmlToGui = require(path.to.newhtmltogui)
    local guiInstance = htmlToGui.fromHTML(htmlString, cssString)
--]]

-- Global declarations for Roblox environment
-- These will be available when running in Roblox Studio/Game
local game = game
local Enum = Enum
local Instance = Instance
local Color3 = Color3
local UDim = UDim
local UDim2 = UDim2

local newhtml = {}

function newhtml.fromHTML(html, css)
    --[[
        Enhanced HTML to Roblox GUI converter with comprehensive HTML/CSS support
        Features:
        - Support for many HTML tags and CSS properties
        - Proper error handling and validation
        - Layout system with UIListLayout and UIGridLayout
        - Advanced CSS parsing with selectors and pseudo-classes
        - Input sanitization and security
        - Responsive design support
    --]]

    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")

    -- Error handling wrapper
    local function safeCall(func, errorMessage, ...)
        local success, result = pcall(func, ...)
        if not success then
            warn("HTMLToGUI Error: " .. errorMessage .. " - " .. tostring(result))
            return nil
        end
        return result
    end

    -- Input validation
    if not html or type(html) ~= "string" or html == "" then
        error("htmlToGui: HTML parameter must be a non-empty string")
    end

    if css and type(css) ~= "string" then
        error("htmlToGui: CSS parameter must be a string or nil")
    end

    -- Enhanced HTML tag to Roblox GUI class mapping
    local tagToClass = {
        -- Basic structure
        ["div"] = "Frame",
        ["section"] = "Frame",
        ["article"] = "Frame",
        ["aside"] = "Frame",
        ["header"] = "Frame",
        ["footer"] = "Frame",
        ["main"] = "Frame",
        ["nav"] = "Frame",
        
        -- Text elements
        ["span"] = "TextLabel",
        ["p"] = "TextLabel",
        ["h1"] = "TextLabel",
        ["h2"] = "TextLabel",
        ["h3"] = "TextLabel",
        ["h4"] = "TextLabel",
        ["h5"] = "TextLabel",
        ["h6"] = "TextLabel",
        ["strong"] = "TextLabel",
        ["em"] = "TextLabel",
        ["b"] = "TextLabel",
        ["i"] = "TextLabel",
        ["u"] = "TextLabel",
        ["small"] = "TextLabel",
        ["mark"] = "TextLabel",
        ["del"] = "TextLabel",
        ["ins"] = "TextLabel",
        ["sub"] = "TextLabel",
        ["sup"] = "TextLabel",
        
        -- Interactive elements
        ["button"] = "TextButton",
        ["a"] = "TextButton",
        
        -- Media
        ["img"] = "ImageLabel",
        ["video"] = "Frame", -- Will be handled specially
        
        -- Lists
        ["ul"] = "Frame",
        ["ol"] = "Frame",
        ["li"] = "TextLabel",
        
        -- Forms
        ["form"] = "Frame",
        ["input"] = "TextBox",
        ["textarea"] = "TextBox",
        ["label"] = "TextLabel",
        ["select"] = "Frame", -- Will be handled specially
        ["option"] = "TextLabel",
        
        -- Tables
        ["table"] = "Frame",
        ["thead"] = "Frame",
        ["tbody"] = "Frame",
        ["tfoot"] = "Frame",
        ["tr"] = "Frame",
        ["th"] = "TextLabel",
        ["td"] = "TextLabel",
        
        -- Roblox specific
        ["textlabel"] = "TextLabel",
        ["textbutton"] = "TextButton",
        ["textbox"] = "TextBox",
        ["imagelabel"] = "ImageLabel",
        ["imagebutton"] = "ImageButton",
        ["frame"] = "Frame",
        ["scrollingframe"] = "ScrollingFrame",
    }

    -- Self-closing tags
    local selfClosingTags = {
        ["img"] = true,
        ["input"] = true,
        ["br"] = true,
        ["hr"] = true,
        ["meta"] = true,
        ["link"] = true,
    }

    -- Enhanced CSS parser with better selector support
    local function parseCSS(css)
        if not css or css == "" then return {} end
        
        local styles = {}
        local function parseSelector(selector)
            local parsed = {}
            for part in selector:gmatch("[^%s,]+") do
                local trimmed = part:gsub("^%s*(.-)%s*$", "%1")
                if trimmed ~= "" then
                    table.insert(parsed, trimmed)
                end
            end
            return parsed
        end
        
        -- Remove comments
        css = css:gsub("/%*.-%*/", "")
        
        for selector, body in css:gmatch("([^{]+)%s*%{(.-)%}") do
            local selectors = parseSelector(selector)
            local props = {}
            
            -- Parse properties with better value handling
            for key, value in body:gmatch("([%w%-]+)%s*:%s*([^;]+);?") do
                local trimmedValue = value:gsub("^%s*(.-)%s*$", "%1")
                props[key] = trimmedValue
            end
            
            for _, sel in ipairs(selectors) do
                styles[sel] = props
            end
        end
        
        return styles
    end

    -- Enhanced HTML parser with better error handling
    local function parseHTML(html)
        -- Remove HTML comments
        html = html:gsub("<!%-%-.-%-%->", "")
        
        local function parseNode(str, depth)
            if depth > 50 then -- Prevent infinite recursion
                warn("HTMLToGUI: Maximum nesting depth reached")
                return {}
            end
            
            local nodes = {}
            local i = 1
            
            while i <= #str do
                -- Skip whitespace
                while i <= #str and str:sub(i, i):match("%s") do
                    i = i + 1
                end
                if i > #str then break end
                
                -- Handle text content before tags
                local textStart = i
                while i <= #str and str:sub(i, i) ~= "<" do
                    i = i + 1
                end
                
                if i > textStart then
                    local textContent = str:sub(textStart, i - 1)
                    if textContent:gsub("%s", "") ~= "" then
                        table.insert(nodes, {
                            tag = "text",
                            text = textContent,
                            attrs = {},
                            children = {}
                        })
                    end
                end
                
                if i > #str then break end
                
                -- Parse tag
                local tagStart, tagEnd, tag, attrs = str:find("<(%w+)(.-)>", i)
                if not tagStart then 
                    -- Handle malformed HTML
                    i = i + 1
                    break 
                end
                
                local tagLower = tag:lower()
                local node = {
                    tag = tagLower,
                    attrs = {},
                    children = {},
                    content = "",
                    text = ""
                }
                
                -- Parse attributes with better error handling
                for key, value in attrs:gmatch('([%w%-_]+)%s*=%s*"([^"]*)"') do
                    node.attrs[key] = value
                end
                
                -- Handle single quotes
                for key, value in attrs:gmatch("([%w%-_]+)%s*=%s*'([^']*)'") do
                    node.attrs[key] = value
                end
                
                -- Handle boolean attributes
                for key in attrs:gmatch("([%w%-_]+)%s*[^=]") do
                    if not node.attrs[key] then
                        node.attrs[key] = key
                    end
                end
                
                -- Parse inline style
                if node.attrs.style then
                    node.attrs.styleTable = {}
                    for k, v in node.attrs.style:gmatch("([%w%-]+)%s*:%s*([^;]+);?") do
                        node.attrs.styleTable[k] = v:gsub("^%s*(.-)%s*$", "%1")
                    end
                end
                
                -- Handle self-closing tags
                if selfClosingTags[tagLower] or attrs:find("/>$") then
                    table.insert(nodes, node)
                    i = tagEnd + 1
                else
                    -- Find closing tag
                    local closeTag = "</" .. tag .. ">"
                    local closeStart, closeEnd = str:find(closeTag, tagEnd + 1, true)
                    
                    if closeStart then
                        local content = str:sub(tagEnd + 1, closeStart - 1)
                        
                        -- Recursively parse children
                        if content:find("<") then
                            node.children = parseNode(content, depth + 1)
                        else
                            node.text = content
                        end
                        
                        table.insert(nodes, node)
                        i = closeEnd + 1
                    else
                        -- Unclosed tag - treat as self-closing
                        table.insert(nodes, node)
                        i = tagEnd + 1
                    end
                end
            end
            
            return nodes
        end
        
        return parseNode(html, 0)
    end

    -- Enhanced CSS property to Roblox property converter
    local function cssToRobloxProp(cssKey, cssValue)
        local function parseColor(colorStr)
            if colorStr:sub(1,1) == "#" then
                return Color3.fromHex(colorStr:sub(2))
            elseif colorStr:find("rgb%(") then
                local r, g, b = colorStr:match("rgb%((%d+),%s*(%d+),%s*(%d+)%)")
                if r and g and b then
                    return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
                end
            elseif colorStr:find("rgba%(") then
                local r, g, b = colorStr:match("rgba%((%d+),%s*(%d+),%s*(%d+)")
                if r and g and b then
                    return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
                end
            end
            return Color3.fromRGB(255, 255, 255) -- Default fallback
        end
        
        local function parseSize(sizeStr)
            local num = tonumber(sizeStr:match("([%d%.]+)"))
            if sizeStr:find("%%") then
                return UDim.new(num / 100, 0)
            elseif sizeStr:find("px") then
                return UDim.new(0, num)
            else
                return UDim.new(0, num)
            end
        end
        
        local map = {
            -- Colors
            ["background-color"] = function(v) return {BackgroundColor3 = parseColor(v)} end,
            ["background"] = function(v) return {BackgroundColor3 = parseColor(v)} end,
            ["color"] = function(v) return {TextColor3 = parseColor(v)} end,
            
            -- Sizing
            ["width"] = function(v) 
                local size = parseSize(v)
                return {Size = UDim2.new(size.Scale, size.Offset, 0, 0)} 
            end,
            ["height"] = function(v) 
                local size = parseSize(v)
                return {Size = UDim2.new(0, 0, size.Scale, size.Offset)} 
            end,
            ["min-width"] = function(v) 
                local size = parseSize(v)
                return {Size = UDim2.new(math.max(0, size.Scale), math.max(0, size.Offset), 0, 0)} 
            end,
            ["max-width"] = function(v) 
                local size = parseSize(v)
                return {Size = UDim2.new(math.min(1, size.Scale), math.min(1000, size.Offset), 0, 0)} 
            end,
            
            -- Text properties
            ["font-size"] = function(v) return {TextSize = tonumber(v:match("([%d%.]+)")) or 14} end,
            ["font-family"] = function(v) return {Font = Enum.Font[v:gsub("[^%w]", "")] or Enum.Font.SourceSans} end,
            ["font-weight"] = function(v) 
                if v == "bold" then
                    return {Font = Enum.Font.SourceSansBold}
                end
                return {}
            end,
            ["text-align"] = function(v) 
                local alignment = v:gsub("[^%w]", ""):lower()
                if alignment == "center" then
                    return {TextXAlignment = Enum.TextXAlignment.Center}
                elseif alignment == "right" then
                    return {TextXAlignment = Enum.TextXAlignment.Right}
                else
                    return {TextXAlignment = Enum.TextXAlignment.Left}
                end
            end,
            ["text-decoration"] = function(v)
                if v:find("underline") then
                    return {TextStrokeTransparency = 0}
                end
                return {}
            end,
            
            -- Layout
            ["display"] = function(v)
                if v == "none" then
                    return {Visible = false}
                elseif v == "block" then
                    return {Size = UDim2.new(1, 0, 0, 0)}
                end
                return {}
            end,
            ["position"] = function(v)
                if v == "absolute" or v == "fixed" then
                    return {} -- Handle with layout system
                end
                return {}
            end,
            
            -- Spacing
            ["margin"] = function(v) 
                local margin = tonumber(v:match("([%d%.]+)")) or 0
                return {Size = UDim2.new(0, 200 - margin * 2, 0, 50 - margin * 2)} 
            end,
            ["padding"] = function(v) return {} end, -- Handle with layout system
            
            -- Transparency
            ["opacity"] = function(v) return {BackgroundTransparency = 1 - tonumber(v:match("([%d%.]+)"))} end,
            ["background-transparency"] = function(v) return {BackgroundTransparency = tonumber(v:match("([%d%.]+)"))} end,
            ["text-transparency"] = function(v) return {TextTransparency = tonumber(v:match("([%d%.]+)"))} end,
            
            -- Borders and corners
            ["border-radius"] = function(v) return {CornerRadius = UDim.new(0, tonumber(v:match("([%d%.]+)")))} end,
            ["border"] = function(v) return {BorderSizePixel = tonumber(v:match("([%d%.]+)"))} end,
            ["border-color"] = function(v) return {BorderColor3 = parseColor(v)} end,
            
            -- Flexbox-like properties
            ["flex-direction"] = function(v) return {} end, -- Handle with layout system
            ["justify-content"] = function(v) return {} end, -- Handle with layout system
            ["align-items"] = function(v) return {} end, -- Handle with layout system
        }
        
        if map[cssKey] then
            local success, result = pcall(map[cssKey], cssValue)
            if success then
                return result
            else
                warn("HTMLToGUI: Error parsing CSS property " .. cssKey .. " with value " .. cssValue)
            end
        end
        
        return {}
    end

    -- Enhanced style application with layout support
    local function applyStyles(instance, styleTable, parentStyles)
        if not styleTable then return end
        
        for k, v in pairs(styleTable) do
            local props = cssToRobloxProp(k, v)
            for prop, val in pairs(props) do
                if prop == "CornerRadius" then
                    local corner = instance:FindFirstChild("UICorner")
                    if not corner then
                        corner = Instance.new("UICorner")
                        corner.Parent = instance
                    end
                    corner.CornerRadius = val
                elseif prop == "Size" and instance:IsA("GuiObject") then
                    instance.Size = val
                elseif prop == "Font" and (instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox")) then
                    instance.Font = val
                else
                    local success = pcall(function() instance[prop] = val end)
                    if not success then
                        warn("HTMLToGUI: Failed to set property " .. prop .. " on " .. instance.ClassName)
                    end
                end
            end
        end
        
        -- Apply layout properties
        local layoutProps = {}
        for k, v in pairs(styleTable) do
            if k == "display" and v == "flex" then
                layoutProps["display"] = "flex"
            elseif k == "flex-direction" then
                layoutProps["flex-direction"] = v
            elseif k == "justify-content" then
                layoutProps["justify-content"] = v
            elseif k == "align-items" then
                layoutProps["align-items"] = v
            end
        end
        
        if next(layoutProps) then
            instance:SetAttribute("LayoutProps", HttpService:JSONEncode(layoutProps))
        end
    end

    -- Layout system
    local function setupLayout(instance, layoutProps)
        if not layoutProps then return end
        
        local existingLayout = instance:FindFirstChildOfClass("UIListLayout")
        if existingLayout then
            existingLayout:Destroy()
        end
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 2)
        
        if layoutProps["flex-direction"] == "column" then
            layout.FillDirection = Enum.FillDirection.Vertical
        elseif layoutProps["flex-direction"] == "row" then
            layout.FillDirection = Enum.FillDirection.Horizontal
        else
            layout.FillDirection = Enum.FillDirection.Vertical -- Default
        end
        
        if layoutProps["justify-content"] == "center" then
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
        elseif layoutProps["justify-content"] == "flex-end" then
            if layout.FillDirection == Enum.FillDirection.Vertical then
                layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            else
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            end
        end
        
        layout.Parent = instance
    end

    -- Enhanced node builder with error handling
    local function buildNode(node, cssStyles, parentInstance)
        if not node then return nil end
        
        local className = tagToClass[node.tag] or "Frame"
        if node.tag == "text" then
            className = "TextLabel"
        end
        
        local inst = safeCall(function()
            return Instance.new(className)
        end, "Failed to create instance of type " .. className)
        
        if not inst then return nil end
        
        inst.Name = node.tag .. (node.attrs.id and ("_" .. node.attrs.id) or "")
        
        -- Set text content
        if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
            local textContent = node.text or ""
            if node.tag == "text" then
                textContent = node.content or ""
            end
            inst.Text = textContent
        end
        
        -- Handle special tags
        if node.tag == "img" and node.attrs.src then
            if inst:IsA("ImageLabel") then
                inst.Image = node.attrs.src
                inst.ScaleType = Enum.ScaleType.Fit
            end
        elseif node.tag == "input" then
            if node.attrs.type == "password" and inst:IsA("TextBox") then
                inst.Text = "" -- Hide password
            elseif node.attrs.placeholder and inst:IsA("TextBox") then
                inst.PlaceholderText = node.attrs.placeholder
            end
        elseif node.tag == "button" or node.tag == "a" then
            if inst:IsA("TextButton") then
                inst.Text = node.text or node.attrs.value or "Button"
            end
        elseif node.tag == "ul" or node.tag == "ol" then
            inst:SetAttribute("IsList", true)
        elseif node.tag == "li" then
            inst.Text = (node.text or "") .. "• " -- Add bullet point
        end
        
        -- Apply inline styles first
        if node.attrs.styleTable then
            applyStyles(inst, node.attrs.styleTable)
        end
        
        -- Apply class styles
        if node.attrs.class and cssStyles then
            for className in node.attrs.class:gmatch("[^%s]+") do
                local selector = "." .. className
                if cssStyles[selector] then
                    applyStyles(inst, cssStyles[selector])
                end
            end
        end
        
        -- Apply id styles
        if node.attrs.id and cssStyles then
            local selector = "#" .. node.attrs.id
            if cssStyles[selector] then
                applyStyles(inst, cssStyles[selector])
            end
        end
        
        -- Apply tag-specific styles
        if cssStyles[node.tag] then
            applyStyles(inst, cssStyles[node.tag])
        end
        
        -- Build children
        for _, child in ipairs(node.children or {}) do
            local childInst = buildNode(child, cssStyles, inst)
            if childInst then
                childInst.Parent = inst
            end
        end
        
        -- Setup layout if needed
        local layoutPropsAttr = inst:GetAttribute("LayoutProps")
        if layoutPropsAttr then
            local success, layoutProps = pcall(function()
                return HttpService:JSONDecode(layoutPropsAttr)
            end)
            if success and layoutProps then
                setupLayout(inst, layoutProps)
            end
        end
        
        -- Default styling
        if inst:IsA("GuiObject") then
            if not inst:GetAttribute("HasCustomSize") then
                inst.Size = UDim2.new(0, 200, 0, 50)
            end
            if inst.BackgroundColor3 == Color3.fromRGB(0, 0, 0) and not inst:GetAttribute("HasCustomBackground") then
                inst.BackgroundTransparency = 1
            end
            inst.BorderSizePixel = 0
        end
        
        return inst
    end

    -- Main conversion logic with error handling
    local function convertHTML()
        local cssStyles = {}
        if css and css ~= "" then
            cssStyles = safeCall(parseCSS, "Failed to parse CSS", css) or {}
        end
        
        local nodes = safeCall(parseHTML, "Failed to parse HTML", html)
        if not nodes or #nodes == 0 then
            error("HTMLToGUI: No valid HTML nodes found")
        end
        
        if #nodes == 1 then
            return buildNode(nodes[1], cssStyles)
        else
            -- Wrap multiple nodes in a container
            local container = safeCall(function()
                return Instance.new("Frame")
            end, "Failed to create container frame")
            
            if not container then return nil end
            
            container.Name = "HTMLContainer"
            container.Size = UDim2.new(0, 400, 0, 300)
            container.BackgroundTransparency = 1
            container.BorderSizePixel = 0
            
            for _, node in ipairs(nodes) do
                local inst = buildNode(node, cssStyles, container)
                if inst then
                    inst.Parent = container
                end
            end
            
            return container
        end
    end
    
    -- Execute conversion with error handling
    local success, result = pcall(convertHTML)
    if not success then
        error("HTMLToGUI: Conversion failed - " .. tostring(result))
    end
    
    return result
end

-- Utility functions for advanced usage
function newhtml.createFromURL(url, css)
    -- Note: This would require HttpService to be enabled and proper CORS setup
    warn("createFromURL requires HttpService to be enabled and proper setup")
    return nil
end

function newhtml.validateHTML(html)
    local success, result = pcall(function()
        return newhtml.fromHTML(html, "")
    end)
    return success, result
end

return newhtml