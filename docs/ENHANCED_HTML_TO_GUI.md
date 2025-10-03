# Enhanced HTML to GUI Converter

## Overview

The Enhanced HTML to GUI Converter is a comprehensive Roblox Lua module that converts HTML and CSS into Roblox GUI instances. This version includes significant improvements over the basic implementation, featuring extensive HTML/CSS support, robust error handling, and advanced layout systems.

## Features

### 🏷️ HTML Tag Support

#### Structural Tags
- `div`, `section`, `article`, `aside`, `header`, `footer`, `main`, `nav`
- All convert to Roblox `Frame` instances

#### Text Elements
- `span`, `p`, `h1-h6`, `strong`, `em`, `b`, `i`, `u`, `small`, `mark`, `del`, `ins`, `sub`, `sup`
- All convert to Roblox `TextLabel` instances

#### Interactive Elements
- `button`, `a` → `TextButton`
- `input`, `textarea` → `TextBox`
- `img` → `ImageLabel`

#### Lists
- `ul`, `ol` → `Frame` with list attributes
- `li` → `TextLabel` with bullet points

#### Forms
- `form`, `label` → `Frame` and `TextLabel`
- `select`, `option` → Special handling for dropdowns

#### Tables
- `table`, `thead`, `tbody`, `tfoot`, `tr`, `th`, `td`
- All convert to `Frame` and `TextLabel` instances

### 🎨 CSS Property Support

#### Colors
- `background-color`, `background`, `color`
- Support for hex (`#ffffff`), rgb (`rgb(255,255,255)`), and rgba formats

#### Sizing
- `width`, `height` with pixel and percentage support
- `min-width`, `max-width` for responsive design

#### Typography
- `font-size` → `TextSize`
- `font-family` → `Font` (maps to Roblox font enums)
- `font-weight` → Bold font variants
- `text-align` → `TextXAlignment` and `TextYAlignment`
- `text-decoration` → Text stroke effects

#### Layout
- `display` → Visibility and sizing control
- `position` → Absolute/fixed positioning support
- `flex-direction`, `justify-content`, `align-items` → Layout system

#### Spacing
- `margin` → Size adjustments
- `padding` → Layout system integration

#### Visual Effects
- `opacity` → `BackgroundTransparency`
- `border-radius` → `UICorner`
- `border` → `BorderSizePixel`
- `border-color` → `BorderColor3`

### 🛡️ Error Handling

#### Input Validation
- HTML parameter must be a non-empty string
- CSS parameter must be a string or nil
- Automatic sanitization of malformed input

#### Parsing Error Recovery
- Graceful handling of unclosed tags
- Safe parsing of malformed HTML/CSS
- Maximum nesting depth protection (50 levels)

#### Runtime Error Handling
- Safe property assignment with pcall
- Comprehensive error messages with context
- Fallback values for invalid CSS properties

### 🏗️ Layout System

#### Flexbox-like Behavior
- `display: flex` enables layout system
- `flex-direction: column/row` controls orientation
- `justify-content` for alignment
- Automatic `UIListLayout` application

#### Responsive Design
- Percentage-based sizing support
- Automatic layout updates
- Container-based organization

### 🔧 Advanced Features

#### Self-Closing Tags
- `img`, `input`, `br`, `hr`, `meta`, `link`
- Proper handling without closing tags

#### Special Tag Handling
- Image tags with `src` attribute
- Input fields with `type`, `placeholder`
- Lists with automatic bullet points
- Form elements with proper labeling

#### CSS Selector Support
- Class selectors (`.className`)
- ID selectors (`#elementId`)
- Tag selectors (`div`, `p`, etc.)
- Multiple selector support

## Usage

### Basic Usage

```lua
local newhtml = require(path.to.newhtmltogui)

local html = [[
<div class="container">
    <h1>Hello World</h1>
    <p>This is a test</p>
    <button>Click me!</button>
</div>
]]

local css = [[
.container {
    background-color: #f0f0f0;
    border-radius: 10px;
    padding: 20px;
}

h1 {
    color: #333;
    font-size: 24px;
    text-align: center;
}

button {
    background-color: #007bff;
    color: white;
    border-radius: 5px;
}
]]

local guiInstance = newhtml.fromHTML(html, css)
guiInstance.Parent = game.Players.LocalPlayer.PlayerGui
```

### Error Handling

```lua
-- Validate HTML before conversion
local isValid, result = newhtml.validateHTML(html)
if isValid then
    local gui = newhtml.fromHTML(html, css)
    gui.Parent = parentGui
else
    warn("Invalid HTML:", result)
end
```

### Advanced Layout

```lua
local html = [[
<div class="flex-container">
    <div class="item">Item 1</div>
    <div class="item">Item 2</div>
    <div class="item">Item 3</div>
</div>
]]

local css = [[
.flex-container {
    display: flex;
    flex-direction: row;
    justify-content: center;
    background-color: #fff;
    padding: 20px;
}

.item {
    background-color: #007bff;
    color: white;
    margin: 5px;
    padding: 10px;
    border-radius: 5px;
}
]]
```

## API Reference

### Functions

#### `newhtml.fromHTML(html, css)`
Converts HTML and CSS to Roblox GUI instances.

**Parameters:**
- `html` (string): HTML content to convert
- `css` (string, optional): CSS styles to apply

**Returns:**
- `Instance`: Roblox GUI instance representing the converted HTML

**Errors:**
- Throws error for invalid input parameters
- Returns nil for parsing failures

#### `newhtml.validateHTML(html)`
Validates HTML content without creating GUI instances.

**Parameters:**
- `html` (string): HTML content to validate

**Returns:**
- `boolean`: True if HTML is valid
- `string|nil`: Error message if validation fails

#### `newhtml.createFromURL(url, css)`
*Note: Requires HttpService setup and proper CORS configuration*

**Parameters:**
- `url` (string): URL to fetch HTML from
- `css` (string, optional): CSS styles to apply

**Returns:**
- `Instance|nil`: GUI instance or nil if failed

## Best Practices

### Performance
- Use specific CSS selectors for better performance
- Avoid deeply nested HTML structures
- Minimize the use of complex CSS properties

### Security
- Sanitize HTML input from external sources
- Validate CSS to prevent malicious content
- Use the validation function before conversion

### Layout
- Use the flexbox layout system for responsive design
- Test layouts with different screen sizes
- Consider Roblox's UI scaling limitations

## Limitations

### HTML/CSS Features Not Supported
- JavaScript functionality
- Complex CSS animations
- CSS Grid layout
- CSS transforms
- Media queries
- CSS variables

### Roblox-Specific Limitations
- Limited font support (only Roblox fonts)
- No support for external images (use Roblox assets)
- UI scaling behavior may differ from web browsers
- Limited color format support

## Migration from Basic Version

The enhanced version is backward compatible with the basic implementation. Key differences:

1. **Error Handling**: New version includes comprehensive error handling
2. **Tag Support**: Significantly more HTML tags supported
3. **CSS Properties**: Many more CSS properties available
4. **Layout System**: Advanced layout system with flexbox-like behavior
5. **Validation**: Built-in HTML validation functions

## Troubleshooting

### Common Issues

#### "HTMLToGUI Error: Failed to parse HTML"
- Check for unclosed tags
- Ensure HTML is properly formatted
- Use the validation function to identify issues

#### "HTMLToGUI Error: Failed to create instance"
- Verify Roblox environment is properly set up
- Check for invalid GUI class names
- Ensure proper service initialization

#### Layout Issues
- Use the flexbox layout system for complex layouts
- Check CSS property values for typos
- Verify UDim2 calculations for sizing

### Debug Tips
- Use `newhtml.validateHTML()` before conversion
- Check the console for detailed error messages
- Test with simple HTML first, then add complexity
- Verify CSS property mappings in the source code

## Contributing

To extend the converter:

1. Add new HTML tags to the `tagToClass` mapping
2. Add CSS properties to the `cssToRobloxProp` function
3. Update the layout system for new layout properties
4. Add tests for new functionality

## License

This enhanced HTML to GUI converter is part of the L0cal.test project and follows the same licensing terms.
