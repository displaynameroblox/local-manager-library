````markdown
# Changelog

All notable changes to the Local Manager Library will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
