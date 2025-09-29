# Local Manager Library — Documentation

## Media & Video Handler

This section documents the library's media handler (`manager.media`) which is intended to play and manage audio, video, image and document files from the local filesystem (as supported by your executor).

### Purpose

Use `manager.media` to:
- Play a single audio file
- Play all audio files in a folder
- Read image/document content
- (Experimental) create a `VideoFrame` for video files

### Signature

```lua
function manager.media(path: string?, type: string, typeofmedia: string, isfolder: boolean?, folder: string?): string | Instance | table
```

Parameters:
- `path` (string?) — path to a single media file. Not required when `isfolder` is true.
- `type` (string) — a media category (this parameter is present in the API; the implementation currently expects `audio`, `video`, `image`, or `document` as the `typeofmedia`).
- `typeofmedia` (string) — one of: `"audio"`, `"video"`, `"image"`, `"document"`.
- `isfolder` (boolean?) — when true, `folder` is used to list and process multiple files.
- `folder` (string?) — path to a folder containing media files (required when `isfolder` is true).

### Supported audio extensions

- `.mp3`, `.wav`, `.ogg`, `.m4a`, `.aac`

### Behavior summary

- Audio (single file): reads the file, attempts to convert it to an executor asset via `getcustomasset`, creates a `Sound` instance and plays it. The `Sound` is placed inside the library's `scriptfolder/Audio` folder if available, otherwise falls back to `workspace`.
- Audio (folder): lists files in the folder, filters by supported extensions, attempts to create assets for each file and play them sequentially (returns how many files were played successfully).
- Video: experimental — the code attempts to create a `VideoFrame` and set its `Video` property using `getcustomasset`. Video support is executor-dependent and may not work on many executors.
- Image / Document: the function returns the raw file content (binary/text) read from disk.

### Returns

- On success the function returns descriptive strings such as:
	- `"media played successfully"` (single audio)
	- `"played X/Y audio files from folder successfully"` (folder)
	- raw file content (for images/documents)
- On failure, the function returns a readable error message describing the failure (for example: `"failed to read media file"`, `"no audio files found in folder"`, or `"failed to get custom asset for audio"`).

### Examples

- Play a single audio file:

```lua
local res = manager.media("assets/song.mp3", "audio", "audio", false)
print(res) -- "media played successfully" or an error string
```

- Play all audio files in a folder:

```lua
local res = manager.media(nil, "audio", "audio", true, "music")
print(res) -- "played 5/5 audio files from folder successfully"
```

- Read an image file (returns content):

```lua
local content = manager.media("images/logo.png", "image", "image", false)
-- `content` contains binary data returned by `readfile` (executor dependent)
```

- Experimental video handling (may not be supported on your executor):

```lua
local videoFrame = manager.media("videos/clip.mp4", "video", "video", false)
-- May return a VideoFrame instance or an error string depending on support
```

### Known limitations & implementation notes

- Video support is marked experimental. Many Roblox executors do not support `VideoFrame` playback from local paths or `getcustomasset` for arbitrary video files.
- The library attempts to create assets using `getcustomasset`. If your executor does not support `getcustomasset` for the file types you use, media playback will fail.
- The implementation relies on Roblox instances (`Instance.new("Sound")`, `VideoFrame`, `ScreenGui`, etc.). Running outside a Roblox environment (or in restricted executors) will prevent GUI and audio playback.
- When playing audio, `Sound` instances are parented to `scriptfolder/Audio` for organization. Make sure `manager.createScriptFolderStructure()` has run or call `manager.getScriptFolder()` first.
- The handler reads files synchronously with `readfile`, which may block for large files.
- There are a few implementation edge-cases in the library (typos and experimental branches) — if you hit an error, check the return string for guidance and consider opening an issue with the filename and executor details.

### Recommended usage checklist

1. Ensure your executor supports file I/O (readfile/writefile), `getcustomasset`, and `Instance` creation.
2. Run `manager.createScriptFolderStructure()` once to ensure `Audio` and `GUIs` folders exist.
3. Use folder playback for playlists: call `manager.media(nil, "audio", "audio", true, "music_folder")`.
4. For single files, pass the exact path: `manager.media("song.mp3", "audio", "audio", false)`.

If you want, I can also add a short troubleshooting subsection with common error messages and steps to debug (executor checks, file permission checks, and example outputs).

---

Last updated: 2025-09-29
