# Changelog

All notable changes to the Local Manager Library will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2 Oct 2025 *major html parser overhaul and function restructuring*

### 🚀 Major Breaking Changes

#### **HTML Parser Complete Overhaul**
- **REMOVED**: Old `_htmlToGuiInternal` function (lines 1009-1283)
- **INTEGRATED**: Enhanced HTML parser from `newhtmltogui.lua` into main library
- **NEW**: `newhtml.fromHTML(html, css)` - Comprehensive HTML5 and CSS3 support
- **ENHANCED**: Support for HTML5 semantic elements, media elements, and advanced CSS properties
- **IMPROVED**: Better error handling, validation, and layout system with UIListLayout

#### **Function Renaming and Restructuring**
- **RENAMED**: `manager.newsaveas()` → `manager.saveas()`
- **REMOVED**: Old `saveas()` function (deprecated implementation)
- **INTEGRATED**: All saveas functionality into single, comprehensive function
- **ENHANCED**: Debug mode with error codes from TROUBLESHOOTING.md

#### **Debug Mode Implementation**
- **NEW**: Global debug mode system with `_DEBUG_MODE` variable
- **ENHANCED**: All functions now return detailed error codes when debug is enabled
- **INTEGRATED**: Error code mapping system referencing TROUBLESHOOTING.md
- **IMPROVED**: Comprehensive error reporting with context and troubleshooting information

### 🎯 New Features

#### **Enhanced HTML5 Support**
- **Semantic Elements**: `section`, `article`, `aside`, `header`, `footer`, `main`, `nav`, `figure`, `figcaption`
- **Media Elements**: `video`, `audio`, `source`, `track`, `canvas`, `embed`, `object`
- **Form Enhancements**: `email`, `url`, `tel`, `search`, `number`, `range`, `color`, `date`, `time`, `datetime-local`
- **Advanced Elements**: `progress`, `meter`, `details`, `summary`, `wbr`, `datalist`, `output`, `fieldset`, `legend`

#### **Comprehensive CSS3 Support**
- **Layout Properties**: `min-height`, `max-height`, `font-style`, `vertical-align`, `flex-direction`, `justify-content`, `align-items`
- **Advanced Colors**: Full hex, rgb, rgba support with Color3 conversion
- **Typography**: Enhanced font handling, text alignment, decorations
- **Spacing**: Margin, padding, border-radius with UDim2 conversion
- **Transparency**: Background and text transparency support
- **Borders**: Border size, color, and corner radius with UICorner

#### **Media and Non-UI Element Support**
- **Video Elements**: `<video>` tags create VideoFrame instances
- **Audio Elements**: `<audio>` tags create Sound instances for non-UI audio
- **Image Enhancement**: Better ImageLabel handling with scale types
- **Layout System**: UIListLayout integration for flexbox-like layouts

#### **Advanced Error Handling**
- **Safe Execution**: `pcall` wrapper for all critical operations
- **Detailed Validation**: Input sanitization and HTML structure validation
- **Graceful Degradation**: Fallback options for unsupported features
- **Comprehensive Logging**: Detailed error messages with context

### 🔧 Function Updates

#### **manager.html() Complete Rewrite**
- **NEW**: Uses enhanced HTML parser with CSS support
- **ENHANCED**: Better attribute parsing (single/double quotes, boolean attributes)
- **IMPROVED**: Inline style parsing and CSS class/id selector support
- **ADDED**: Self-closing tag support and nested structure handling
- **INTEGRATED**: Layout system with UIListLayout and UIGridLayout

#### **manager.saveas() Enhanced**
- **RENAMED**: From `manager.newsaveas()` for consistency
- **ENHANCED**: Debug mode with error codes and detailed information
- **IMPROVED**: Better parameter validation and error reporting
- **INTEGRATED**: All saveas functionality in single function
- **ADDED**: Comprehensive error handling for all instance types

#### **Debug Mode System**
- **GLOBAL**: `_DEBUG_MODE` variable controls debug output across all functions
- **ERROR CODES**: Referenced from TROUBLESHOOTING.md for consistent error handling
- **DETAILED INFO**: Enhanced error messages with context and troubleshooting steps
- **VALIDATION**: Input parameter validation with debug information

### 📚 Documentation Updates

#### **Complete Documentation Overhaul**
- **API.md**: Updated with all new function signatures and parameters
- **QUICKSTART.md**: Updated examples and quick reference table
- **ENHANCED_HTML_TO_GUI.md**: New documentation for HTML5 and CSS3 features
- **TROUBLESHOOTING.md**: Updated error codes for debug mode system
- **JAVA_TO_LUA_TRANSPILER.md**: Updated function references

#### **New Documentation Sections**
- **HTML5 Support**: Comprehensive guide for semantic and media elements
- **CSS3 Properties**: Complete reference for supported CSS properties
- **Debug Mode**: Guide for using debug mode and error codes
- **Migration Guide**: Step-by-step migration from old to new functions

### 🐛 Bug Fixes

#### **Critical Fixes**
- **FIXED**: HTML parser infinite recursion with depth limiting (max 50 levels)
- **FIXED**: CSS selector parsing with better error handling
- **FIXED**: Attribute parsing for single quotes and boolean attributes
- **FIXED**: Self-closing tag handling and malformed HTML recovery
- **FIXED**: Memory leaks in nested HTML structure parsing

#### **Function Integration Fixes**
- **FIXED**: HTML function integration with enhanced parser
- **FIXED**: Saveas function renaming and old function removal
- **FIXED**: Debug mode implementation across all functions
- **FIXED**: Error code consistency and TROUBLESHOOTING.md references

### ⚠️ Breaking Changes

#### **Function Signature Changes**
- **OLD**: `manager.newsaveas(instance, path, moredebug, content)`
- **NEW**: `manager.saveas(instance, path, debug, content)`
- **NOTE**: Function renamed, debug parameter name changed

#### **HTML Function Changes**
- **OLD**: `manager.html(url, islocal, path, convertToGui, parentGui)`
- **NEW**: Uses enhanced HTML parser with better CSS support
- **NOTE**: Internal implementation completely rewritten

#### **Debug Mode Changes**
- **OLD**: Individual debug parameters per function
- **NEW**: Global `_DEBUG_MODE` variable with error codes
- **NOTE**: Debug mode now returns error codes from TROUBLESHOOTING.md

### 🔄 Migration Guide

#### **For HTML Function Users**
```lua
-- OLD WAY (still works but uses new parser internally)
local result = manager.html(url, islocal, path, true, parentGui)

-- NEW WAY (recommended - same function, enhanced parser)
local result = manager.html(url, islocal, path, true, parentGui)
-- Now supports HTML5 and CSS3 features
```

#### **For Saveas Function Users**
```lua
-- OLD WAY (deprecated)
local result = manager.newsaveas("Sound", "path.mp3", true)

-- NEW WAY (required)
local result = manager.saveas("Sound", "path.mp3", true)
-- Same functionality, new name
```

#### **For Debug Mode Users**
```lua
-- OLD WAY (individual debug parameters)
local result = manager.newsaveas("Sound", "path.mp3", true)

-- NEW WAY (global debug mode)
manager._DEBUG_MODE = true
local result = manager.saveas("Sound", "path.mp3", false)
-- Debug mode controlled globally
```

### 🧪 Testing

#### **New Test Coverage**
- HTML5 semantic element parsing and conversion
- CSS3 property parsing and Roblox property conversion
- Media element handling (video, audio, sound)
- Debug mode error code validation
- Function renaming and integration testing

#### **Enhanced Error Handling Testing**
- Malformed HTML recovery testing
- CSS parsing error handling
- Debug mode error code consistency
- Input validation and sanitization

### 🔮 Future Plans (v2.1+)

#### **Planned Features**
- Advanced HTML5 form validation
- CSS animations and transitions
- WebGL/Canvas element support
- Advanced media element controls
- HTML5 data attribute support

#### **Improvements**
- Performance optimizations for large HTML documents
- Enhanced CSS selector specificity
- Advanced layout system improvements
- Better cross-executor compatibility

---

## [1.2.5] - 2 Oct 2025 *experimental saveas improvements and main library integration*

### 🚀 Major Integration Update

#### **Model and Image Saving Added to Main Library**
- **Integrated**: Model and Image saving functionality into main `manager.newsaveas()` function
- **Status**: Model and Image saving now available in production library
- **Error Handling**: Full comprehensive error handling from experimental implementation
- **Compatibility**: Maintains backward compatibility with existing Sound and Script saving

#### **Enhanced Main Library Functionality**
- **New Supported Types**: Model (.rbxl/.rbxlx) and Image (.png/.jpg/.jpeg/.gif/.bmp/.tiff/.ico)
- **Production Ready**: Model and Image saving moved from experimental to production
- **Comprehensive Validation**: Full input validation and error handling
- **Debug Mode**: Enhanced debug mode for troubleshooting

### 🔧 Function Updates

#### **manager.newsaveas() Enhancements**
- **Model Saving**: Full Model instance saving with workspace cleanup
- **Image Saving**: Support for ImageLabel, ImageButton, Decal, and Texture instances
- **Error Handling**: Comprehensive error handling for all instance types
- **File Format Support**: Extended file format support for models and images

#### **Supported Instance Types (Main Library)**
- ✅ **Sound**: Working (integrated)
- ✅ **Script**: Working (integrated)
- ✅ **Model**: Working (newly integrated with error handling)
- ✅ **Image**: Working (newly integrated with error handling)
- 🚧 **Video**: Work in Progress (experimental file only)

### 📋 Error Handling Integration

#### **Model Saving Error Messages**
- `"failed to save model: tobesaved is not a Model instance"`
- `"failed to save model: invalid file format"`
- `"failed to create save folder: [error]"`
- `"failed to clone model: [error]"`
- `"failed to setup cloned model: [error]"`
- `"failed to save model file to path: [path] error: [error]"`

#### **Image Saving Error Messages**
- `"failed to save image: tobesaved is not a valid image instance"`
- `"failed to save image: invalid file format"`
- `"failed to save image: no image content found"`
- `"failed to save image file to path: [path] error: [error]"`

### 📚 Documentation Updates

#### **QUICKSTART.md Updates**
- **Section 6**: Updated to include Model and Image saving examples
- **Quick Reference**: Updated table to reflect new capabilities
- **Examples**: Added practical examples for Model and Image saving
- **Status**: Removed experimental designation for Model/Image saving

#### **Usage Examples**
```lua
-- Model saving (now in main library)
local myModel = workspace:FindFirstChild("MyModel")
if myModel and myModel:IsA("Model") then
    local result = manager.newsaveas("model", "models/my_model.rbxl", true)
end

-- Image saving (now in main library)
local myImage = workspace:FindFirstChild("MyImage")
if myImage and myImage:IsA("ImageLabel") then
    local result = manager.newsaveas("image", "images/my_image.png", true)
end
```

### 🧪 Development Structure

#### **Production Library (Main)**
- `manager.newsaveas()` - Sound, Script, Model, Image saving
- Production-ready with comprehensive error handling
- Stable and tested functionality

#### **Experimental Library (Separate)**
- `newsaveas.newsaveas()` - All types including Video (WIP)
- Development and testing for upcoming features
- Video saving still work in progress

### 🔄 Migration Notes

#### **For Users**
- Model and Image saving now available directly through `manager.newsaveas()`
- No need to load separate experimental module for Model/Image saving
- Enhanced error handling and validation
- Better debugging capabilities

#### **For Developers**
- Experimental file still available for Video saving development
- Clear separation between production and experimental features
- Easy testing of new features before integration


---

## [1.2.4] - 2 Oct 2025 *saveas development*

### 🔧 Development Structure Changes

#### **Separate Development File for Advanced Features**
- **Added**: `etc/newsaveas.lua` - Separate development file for experimental saveas features
  - Contains work-in-progress implementations for model and image saving
  - Includes development helper functions and status tracking
  - Marked experimental features clearly with 🚧 emoji indicators
  - Provides detailed debug information for development testing

#### **Enhanced Development Workflow**
- **Main Library**: `manager.newsaveas()` - Production-ready Sound and Script saving
- **Development File**: `newsaveas.newsaveas()` - Experimental Model, Image, and Video saving
- **Clear Separation**: Production vs development features clearly distinguished
- **Status Tracking**: Built-in development status reporting

### 🚧 Work In Progress Features

#### **Model Saving (Experimental)**
- **Status**: 🚧 Work in Progress
- **Planned Features**:
  - Model instance creation in workspace
  - Model data serialization and file saving
  - Proper model format handling (.rbxl, .rbxlx)
  - Model hierarchy preservation

#### **Image Saving (Experimental)**
- **Status**: 🚧 Work in Progress  
- **Planned Features**:
  - ImageLabel instance creation
  - Image data handling (base64, file paths)
  - Multiple image format support (.png, .jpg, .gif)
  - Image processing and optimization

#### **Video Saving (Experimental)**
- **Status**: 🚧 Work in Progress
- **Planned Features**:
  - VideoFrame instance creation
  - Video file format support
  - Video data processing and compression
  - Video playback integration

### 📚 Documentation Updates

#### **QUICKSTART.md Enhancements**
- **Added**: Section 7 - Experimental Saveas Features
- **Development Status**: Clear indicators for work-in-progress features
- **Usage Examples**: Examples for experimental feature testing
- **Quick Reference**: Updated table with experimental function reference

#### **Development Guidelines**
- **Clear Separation**: Production vs experimental features
- **Status Tracking**: Built-in development status reporting
- **Testing Framework**: Debug mode for development testing
- **Progress Indicators**: Visual indicators for feature completion status

### 🔄 Function Architecture

#### **Production Functions (Main Library)**
- `manager.newsaveas()` - Sound and Script saving (✅ Working)
- Integrated into main library for production use
- Stable and tested functionality

#### **Development Functions (Separate File)**
- `newsaveas.newsaveas()` - All saveas types including experimental
- `newsaveas._saveasModel()` - Model saving development
- `newsaveas._saveasImage()` - Image saving development  
- `newsaveas._saveasVideo()` - Video saving development
- `newsaveas.getDevelopmentStatus()` - Development status tracking

### 🧪 Development Features

#### **Enhanced Debugging**
- **Debug Mode**: Detailed error information for all experimental features
- **Status Reporting**: Real-time development status tracking
- **Progress Indicators**: Visual progress indicators for feature development
- **Error Handling**: Comprehensive error handling for experimental features

#### **Testing Framework**
- **Development Status**: Built-in status checking
- **Feature Testing**: Easy testing of experimental features
- **Debug Information**: Detailed debug output for development
- **Progress Tracking**: Clear indication of what's working vs in development

### 📋 Migration Notes

#### **For Developers**
- Use `etc/newsaveas.lua` for experimental feature development
- Main library contains only production-ready features
- Clear separation allows for independent development and testing
- Debug mode provides detailed information for troubleshooting

#### **For Users**
- Production features available through `manager.newsaveas()`
- Experimental features available through separate module
- Clear status indicators show what's working vs in development
- Easy testing of upcoming features

---

## [1.2.3] - 2 Oct 2025 *saveas evolution*

### 🔄 Breaking Changes

#### **Save Operations Overhaul**
- **DEPRECATED**: `manager.saveas(path, content, type)` - Function is now deprecated
  - Always returns `"try using the new saveas: manager.newsaveas"`
  - Original implementation removed
  - Users must migrate to new function

- **NEW**: `manager.newsaveas(instance, path, moredebug)` - New saveas implementation
  - Improved parameter structure and validation
  - Enhanced debug mode for detailed error reporting
  - Better error handling and user feedback
  - Currently supports Sound instances only
  - Other instance types (video, model, script) planned for future versions

### 🎯 New Features

#### **Enhanced Debugging Support**
- **Debug Mode**: New `moredebug` parameter in `manager.newsaveas()`
  - Provides detailed error information when enabled
  - Shows instance and path values in error messages
  - Helps with troubleshooting and development
  - Optional parameter (defaults to false)

#### **Improved Error Handling**
- **Detailed Error Messages**: More specific error reporting
  - File existence validation with detailed feedback
  - Content validation with type information
  - Write operation failure details
  - Debug mode provides additional context

### 📚 Documentation Updates

#### **API Documentation Overhaul**
- **API.md**: Complete rewrite of saveas documentation
  - Updated `manager.saveas()` as deprecated function
  - Added comprehensive `manager.newsaveas()` documentation
  - New parameter structure and examples
  - Debug mode usage examples
  - Migration guide from old to new function

#### **Troubleshooting Guide Enhancement**
- **TROUBLESHOOTING.md**: Updated error codes and troubleshooting
  - Split saveas error codes into deprecated and new sections
  - Added 8 new error codes for `manager.newsaveas()`
  - Debug mode specific error handling
  - Migration troubleshooting section

### 🔧 Improvements

#### **Function Architecture**
- **Separate Implementation**: New saveas logic in separate `saveas.lua` file
  - Cleaner code organization
  - Easier maintenance and updates
  - Better separation of concerns
  - Future extensibility

#### **Error Message Consistency**
- **Standardized Format**: Consistent error message patterns
  - Clear parameter validation messages
  - Consistent debug mode formatting
  - Better user experience for troubleshooting

### 🐛 Bug Fixes

#### **Implementation Issues**
- **Fixed**: Original `manager.saveas()` implementation was incomplete
- **Fixed**: Inconsistent error handling across saveas functions
- **Fixed**: Missing parameter validation in original implementation
- **Fixed**: Unclear error messages for debugging

### ⚠️ Known Issues

#### **Current Limitations**
- `manager.newsaveas()` only supports Sound instances currently
- Other instance types (video, model, script) return "coming soon" messages
- Function may not be exposed through manager object yet (check separate file)
- Debug mode may not work on all executors

### 📋 Coming Soon

#### **Planned Improvements**
- Full implementation of video, model, and script instance support
- Integration of newsaveas into main manager object
- Enhanced cross-executor compatibility
- Additional debugging features

### 🔄 Migration Guide

#### **For Users of `manager.saveas()`**
```lua
-- OLD WAY (deprecated)
local result = manager.saveas("sounds/music.mp3", audioData, "Sound")
-- Returns: "try using the new saveas: manager.newsaveas"

-- NEW WAY (recommended)
local result = manager.newsaveas("Sound", "sounds/music.mp3")
-- Returns: "file saved successfully at path: sounds/music.mp3"

-- WITH DEBUG MODE
local result = manager.newsaveas("Sound", "sounds/music.mp3", true)
-- Returns detailed error information if something goes wrong
```

#### **Parameter Changes**
- **Old**: `manager.saveas(path, content, type)`
- **New**: `manager.newsaveas(instance, path, moredebug)`
- **Note**: Parameter order changed, content parameter removed, debug parameter added

### 🧪 Testing

#### **New Test Coverage**
- Deprecated function error message testing
- New function parameter validation
- Debug mode error reporting
- Error message consistency validation

#### **Migration Testing**
- Backward compatibility validation
- Error message accuracy testing
- Debug mode functionality testing

---

## [1.2.2] - 1 Oct 2025 *very very spooky, boo*

### 🎯 New Features
- Added experimental Java to Lua conversion function (`manager.javatolua`)
  - Basic Java syntax validation
  - Placeholder conversion framework
  - Execution capability for converted code
  - Error handling and validation
  - Documentation and examples

### ⚠️ Known Issues
- Java to Lua conversion is currently a placeholder
- Non-execution mode not yet implemented
- Limited Java syntax recognition
- No actual code transformation

### 📋 Coming Soon
- Proper Java parsing and AST transformation
- Non-execution mode for conversion only
- Enhanced Java syntax support
- Better error reporting and debugging

## [1.2.1] - 30 Sep 2025

### 🔧 Improvements

#### **File Operations Enhancement**
- **Completed Function**: `manager.changefile(path, newdata)` - Change file content with backup functionality
  - Reads existing file content before modification
  - Writes new content to file
  - Returns old content for backup purposes
  - Comprehensive error handling and validation
  - File existence checking before modification
  - Proper error messages for all failure scenarios

### 📚 Documentation Updates

#### **API Documentation**
- **API.md**: Added complete documentation for `manager.changefile()` function
  - Function signature and parameters
  - Return values and error messages
  - Usage examples and best practices
  - Error handling patterns

#### **Troubleshooting Guide**
- **TROUBLESHOOTING.md**: Added comprehensive troubleshooting section for changefile function
  - Common error scenarios and solutions
  - Diagnostic code examples
  - File permission and integrity checks
  - Step-by-step troubleshooting guides

### 🐛 Bug Fixes

#### **Function Completion**
- **Fixed**: `manager.changefile()` function was incomplete and non-functional
- **Fixed**: Missing error handling for file read/write operations
- **Fixed**: Incomplete return value handling
- **Fixed**: Missing file existence validation

---

## [1.2.0] - 30 Sep 2025

### 🎉 Major Features Added

#### **Save Operations System (EXPERIMENTAL)**
- **New Function**: `manager.saveas(path, content, type)` - Save content as specific instance types in game environment
  - Supports Sound instances (fully implemented)
  - Supports Model instances (highly experimental)
  - Planned support for Script and Image instances
  - Comprehensive error handling and validation
  - Automatic cleanup on failure
  - Instance organization in scriptfolder structure

- **New Function**: `manager.checkSaveasCapabilities()` - Check which saveas features are supported by current executor
  - Tests Instance creation capabilities
  - Tests Custom asset creation capabilities
  - Tests File writing capabilities
  - Returns detailed capability report

#### **Enhanced Media Operations**
- **Video Playback Support**: Added experimental video handling in `manager.media()`
  - Creates VideoFrame instances for video playback
  - Supports single video file playback
  - Returns VideoFrame instance for user control
  - Organized in scriptfolder/VideoGui/ structure
  - Auto-cleanup when video ends

- **Enhanced Audio Operations**: Improved audio handling in `manager.media()`
  - Single audio files now return Sound instance for user control
  - Folder audio playback with progress indication
  - Better error handling and validation
  - Improved file extension filtering (.mp3, .wav, .ogg, .m4a, .aac)

#### **ScriptFolder Management System**
- **New Function**: `manager.getScriptFolder()` - Get or create the scriptfolder in workspace
- **New Function**: `manager.cleanupScriptFolder()` - Clean up scriptfolder and all contents
- **New Function**: `manager.listScriptFolderContents()` - List all contents of scriptfolder
- **New Function**: `manager.createScriptFolderStructure()` - Create organized subfolder structure
  - Automatic organization: Audio/, GUIs/, Media/, Config/, Logs/, Temp/
  - All library-created instances are organized in scriptfolder
  - Prevents workspace clutter

### 🔧 Improvements

#### **Enhanced HTML to GUI Conversion**
- **Integrated HTML Parser**: HTML parsing is now integrated directly into `manager.html()`
- **New Function**: `manager.createSampleHtmlGui()` - Create sample HTML GUI for testing
- **Improved Error Handling**: Better error messages and validation
- **Enhanced Styling**: Better CSS-like styling support
- **GUI Organization**: HTML GUIs are organized in scriptfolder/GUIs/

#### **Robust Error Handling**
- **Comprehensive Validation**: Enhanced input validation across all functions
- **Better Error Messages**: More descriptive and helpful error messages
- **Automatic Cleanup**: Failed operations clean up created files/instances
- **Graceful Degradation**: Fallback options when features aren't supported

#### **System Diagnostics Enhancement**
- **Enhanced nodefecth**: More comprehensive system testing
- **Better Reporting**: Improved system status reporting
- **Capability Detection**: Tests more executor features
- **Performance Metrics**: Memory and performance information

### 🐛 Bug Fixes

#### **Critical Fixes**
- **Fixed**: Git merge conflict markers in API documentation
- **Fixed**: Media function logic error for folder operations
  - Folder operations now correctly require only `folder` parameter
  - Single file operations require only `path` parameter
- **Fixed**: HTML function syntax error in return statement
- **Fixed**: Redundant error checking in media functions

#### **Logic Improvements**
- **Fixed**: Parameter validation logic in `manager.media()`
- **Fixed**: File existence checking in move operations
- **Fixed**: Error message consistency across all functions
- **Fixed**: Return value consistency for media operations

#### **Documentation Fixes**
- **Fixed**: Merge conflict resolution in API.md
- **Fixed**: Consistent error code documentation
- **Fixed**: Function signature documentation
- **Fixed**: Example code accuracy

### 📚 Documentation Updates

#### **New Documentation**
- **API.md**: Complete documentation for all new functions
- **TROUBLESHOOTING.md**: Added Save Operations troubleshooting section
- **README.md**: Updated with new features and examples
- **QUICKSTART.md**: Added examples for new functionality

#### **Enhanced Documentation**
- **Error Codes**: Added 12 new error codes for save operations
- **Examples**: Comprehensive examples for all new functions
- **Troubleshooting**: Detailed troubleshooting guides for new features
- **Capability Checking**: Documentation for executor capability detection

### ⚠️ Breaking Changes

#### **Media Function Changes**
- `manager.media()` now returns multiple values for audio/video operations:
  - **Before**: `return "success message"`
  - **After**: `return "success message", instance` (for audio/video)

#### **Function Organization**
- All created instances are now organized in scriptfolder instead of workspace
- This may affect scripts that expect instances in specific locations

### 🔄 Deprecations

#### **Planned Future Changes**
- Model saving in `manager.saveas()` is marked as highly experimental
- Script and Image saving are planned but not yet implemented
- Some error messages may be refined in future versions

### 📋 Migration Guide

#### **For Existing Scripts Using Media Function**
```lua
-- OLD WAY (still works but deprecated)
local result = manager.media("audio.mp3", "audio", "audio", false)
print(result)

-- NEW WAY (recommended)
local result, soundInstance = manager.media("audio.mp3", "audio", "audio", false)
if soundInstance then
    -- Control the sound instance
    soundInstance.Volume = 0.8
    soundInstance:Stop()
end
```

#### **For Scripts Expecting Instances in Workspace**
```lua
-- OLD: Instances created directly in workspace
-- NEW: Check scriptfolder for organized instances
local scriptFolder = manager.getScriptFolder()
local audioFolder = scriptFolder:FindFirstChild("Audio")
-- Find your audio instances in audioFolder
```

### 🧪 Testing

#### **New Test Coverage**
- Save operations capability testing
- Media function return value testing
- ScriptFolder organization testing
- Error handling validation
- Cross-executor compatibility testing

#### **Tested Executors**
- Wave (recommended)
- Hydrogen (recommended)
- Limited testing on other major executors

### 🔮 Future Plans (v1.3+)

#### **Planned Features**
- Full Script instance creation in `manager.saveas()`
- Full Image instance creation in `manager.saveas()`
- Enhanced Model saving capabilities
- Batch operations for media files
- Advanced HTML parsing and GUI conversion
- Plugin system for custom save types
- Proper Java to Lua conversion with AST transformation

#### **Improvements**
- Performance optimizations
- Additional error recovery options
- Enhanced cross-executor compatibility
- Advanced system diagnostics

---

## [1.1.0] - 29 Sep 2025

### Added
- Initial release with basic file operations
- HTTP download functionality
- HTML to GUI conversion (basic)
- Media file handling (audio only)
- System diagnostics (nodefecth)

### Fixed
- Basic error handling implementation
- File operation validation

---

## [1.0.0] - 28 Sep 2025

### Added
- Initial release
- Core file management functions
- Basic error handling

---

**Note**: This changelog follows semantic versioning. Version 1.2.0 represents a minor version with new features and improvements while maintaining backward compatibility for most existing functionality.
```
