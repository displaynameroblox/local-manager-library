# Changelog

All notable changes to the Local Manager Library will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
