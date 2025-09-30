-- Quick Try - Media Player Example
-- This file demonstrates how to use the localmaner library for media playback

-- Load the localmaner library
local manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/displaynameroblox/localmaner/main/localmaner.lua"))()

-- Load the media player
loadstring(readfile("mediaplayer.lua"))()

print("Media Player loaded successfully!")
print("The GUI should now be visible on your screen.")
print("You can:")
print("- Click 'Add Track to Playlist' to add audio files")
print("- Use the control buttons to play, pause, stop, next, previous")
print("- Adjust volume with the slider")
print("- Click on tracks in the playlist to play them")
print("- Use keyboard shortcuts: Space (play/pause), Left/Right arrows (previous/next), Escape (stop)")

-- Example: Add a sample track (replace with actual file path)
-- player:addToPlaylist("path/to/your/audio.mp3", "Sample Track")