# Media Player using Local Manager Library

This is a comprehensive media player built using the localmaner library for Roblox. It provides a full-featured audio player with playlist management and a modern GUI interface.

## Features

### 🎵 Audio Playback
- Play, pause, stop, next, and previous track controls
- Volume control with visual slider
- Automatic track progression
- Support for common audio formats (MP3, WAV, OGG, M4A, AAC)

### 📋 Playlist Management
- Add tracks to playlist via GUI or code
- Remove tracks from playlist
- Click on tracks to play them
- Visual indication of currently playing track
- Persistent playlist storage

### 🎮 User Interface
- Modern, dark-themed GUI
- Intuitive control buttons
- Real-time track information display
- Scrollable playlist view
- Responsive design

### ⌨️ Keyboard Shortcuts
- **Space**: Play/Pause
- **Left Arrow**: Previous track
- **Right Arrow**: Next track
- **Escape**: Stop playback

## Usage

### Quick Start
1. Run `quicktry.lua` to load the media player
2. The GUI will appear on your screen
3. Click "Add Track to Playlist" to add audio files
4. Use the control buttons to manage playback

### Programmatic Usage
```lua
-- Load the media player
loadstring(readfile("mediaplayer.lua"))()

-- Add tracks to playlist
player:addToPlaylist("path/to/audio.mp3", "Track Name")

-- Control playback
player:play()
player:pause()
player:stop()
player:next()
player:previous()

-- Adjust volume (0.0 to 1.0)
player:setVolume(0.7)

-- Clear playlist
player:clearPlaylist()
```

## File Structure

- `mediaplayer.lua` - Complete media player implementation
- `quicktry.lua` - Simple example that loads the media player
- `localmaner.lua` - The underlying library for file management

## Requirements

- Roblox environment with executor support
- Audio files in supported formats
- Local file access permissions

## Technical Details

The media player uses the localmaner library's `media()` function to handle audio playback. It creates Sound instances in a managed folder structure and provides a complete GUI interface for user interaction.

### Key Components

1. **MediaPlayer Class**: Main class handling all player functionality
2. **Settings Management**: Persistent storage of user preferences
3. **Playlist System**: Dynamic track management with add/remove capabilities
4. **GUI System**: Modern interface with real-time updates
5. **Event Handling**: Keyboard shortcuts and button interactions

## Notes

- The media player automatically saves settings and playlists
- Tracks are played using Roblox's Sound system
- The GUI is created in the player's PlayerGui
- All media files are managed through the localmaner library's file system
