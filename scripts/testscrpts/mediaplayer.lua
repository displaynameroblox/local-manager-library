-- Media Player using Local Manager Library
-- A comprehensive media player with playlist management and GUI controls

local manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/displaynameroblox/localmaner/main/localmaner.lua"))() -- load the library

-- Media Player Class
local MediaPlayer = {}
MediaPlayer.__index = MediaPlayer

-- Initialize the media player
function MediaPlayer.new()
    local self = setmetatable({}, MediaPlayer)
    
    self.playlist = {}
    self.currentIndex = 1
    self.isPlaying = false
    self.currentSound = nil
    self.volume = 0.5
    self.gui = nil
    self.settings = {}
    
    -- Load settings
    self:loadSettings()
    
    return self
end

-- Settings management
function MediaPlayer:loadSettings()
    if isfile("mediaplayer_settings.json") then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("mediaplayer_settings.json"))
        end)
        if success then
            self.settings = data
            self.volume = data.volume or 0.5
        end
    else
        self.settings = {
            volume = 0.5,
            playlists = {}
        }
        self:saveSettings()
    end
end

function MediaPlayer:saveSettings()
    self.settings.volume = self.volume
    self.settings.playlists = self.playlist
    local success = pcall(function()
        writefile("mediaplayer_settings.json", game:GetService("HttpService"):JSONEncode(self.settings))
    end)
    if not success then
        print("Failed to save settings")
    end
end

-- Playlist management
function MediaPlayer:addToPlaylist(filePath, fileName)
    local audioFile = {
        path = filePath,
        name = fileName or filePath:match("([^/\\]+)$"),
        duration = 0 -- We'll implement duration detection later
    }
    table.insert(self.playlist, audioFile)
    print("Added to playlist: " .. audioFile.name)
    self:saveSettings()
end

function MediaPlayer:removeFromPlaylist(index)
    if index > 0 and index <= #self.playlist then
        local removed = table.remove(self.playlist, index)
        print("Removed from playlist: " .. removed.name)
        if self.currentIndex > #self.playlist then
            self.currentIndex = math.max(1, #self.playlist)
        end
        self:saveSettings()
    end
end

function MediaPlayer:clearPlaylist()
    self.playlist = {}
    self.currentIndex = 1
    self:stop()
    print("Playlist cleared")
    self:saveSettings()
end

-- Media controls
function MediaPlayer:play()
    if #self.playlist == 0 then
        print("Playlist is empty!")
        return false
    end
    
    if self.currentIndex > #self.playlist then
        self.currentIndex = 1
    end
    
    local currentTrack = self.playlist[self.currentIndex]
    print("Playing: " .. currentTrack.name)
    
    -- Stop current sound if playing
    if self.currentSound then
        self:stop()
    end
    
    -- Use the library's media function to play audio
    local success, result = pcall(function()
        return manager.media(currentTrack.path, "play", "audio", false)
    end)
    
    if success and type(result) == "table" and result[2] then
        self.currentSound = result[2]
        self.currentSound.Volume = self.volume
        self.isPlaying = true
        
        -- Connect ended event to play next track
        self.currentSound.Ended:Connect(function()
            self:next()
        end)
        
        return true
    else
        print("Failed to play: " .. (result or "Unknown error"))
        return false
    end
end

function MediaPlayer:pause()
    if self.currentSound and self.isPlaying then
        self.currentSound:Pause()
        self.isPlaying = false
        print("Paused")
    end
end

function MediaPlayer:resume()
    if self.currentSound and not self.isPlaying then
        self.currentSound:Resume()
        self.isPlaying = true
        print("Resumed")
    end
end

function MediaPlayer:stop()
    if self.currentSound then
        self.currentSound:Stop()
        self.currentSound:Destroy()
        self.currentSound = nil
        self.isPlaying = false
        print("Stopped")
    end
end

function MediaPlayer:next()
    if #self.playlist == 0 then return end
    
    self:stop()
    self.currentIndex = self.currentIndex + 1
    if self.currentIndex > #self.playlist then
        self.currentIndex = 1 -- Loop back to beginning
    end
    self:play()
end

function MediaPlayer:previous()
    if #self.playlist == 0 then return end
    
    self:stop()
    self.currentIndex = self.currentIndex - 1
    if self.currentIndex < 1 then
        self.currentIndex = #self.playlist -- Loop to end
    end
    self:play()
end

function MediaPlayer:setVolume(vol)
    self.volume = math.max(0, math.min(1, vol))
    if self.currentSound then
        self.currentSound.Volume = self.volume
    end
    print("Volume set to: " .. math.floor(self.volume * 100) .. "%")
    self:saveSettings()
end

-- GUI Creation
function MediaPlayer:createGUI()
    if self.gui then
        self.gui:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MediaPlayerGUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "Media Player"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Current track info
    local trackInfo = Instance.new("TextLabel")
    trackInfo.Name = "TrackInfo"
    trackInfo.Size = UDim2.new(1, -20, 0, 30)
    trackInfo.Position = UDim2.new(0, 10, 0, 50)
    trackInfo.BackgroundTransparency = 1
    trackInfo.Text = "No track selected"
    trackInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    trackInfo.TextScaled = true
    trackInfo.Font = Enum.Font.Gotham
    trackInfo.Parent = mainFrame
    
    -- Control buttons frame
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "ControlsFrame"
    controlsFrame.Size = UDim2.new(1, -20, 0, 50)
    controlsFrame.Position = UDim2.new(0, 10, 0, 90)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = mainFrame
    
    -- Previous button
    local prevBtn = Instance.new("TextButton")
    prevBtn.Name = "PrevBtn"
    prevBtn.Size = UDim2.new(0, 60, 1, 0)
    prevBtn.Position = UDim2.new(0, 0, 0, 0)
    prevBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    prevBtn.Text = "⏮"
    prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    prevBtn.TextScaled = true
    prevBtn.Font = Enum.Font.GothamBold
    prevBtn.Parent = controlsFrame
    
    -- Play/Pause button
    local playBtn = Instance.new("TextButton")
    playBtn.Name = "PlayBtn"
    playBtn.Size = UDim2.new(0, 60, 1, 0)
    playBtn.Position = UDim2.new(0, 70, 0, 0)
    playBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    playBtn.Text = "▶"
    playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playBtn.TextScaled = true
    playBtn.Font = Enum.Font.GothamBold
    playBtn.Parent = controlsFrame
    
    -- Stop button
    local stopBtn = Instance.new("TextButton")
    stopBtn.Name = "StopBtn"
    stopBtn.Size = UDim2.new(0, 60, 1, 0)
    stopBtn.Position = UDim2.new(0, 140, 0, 0)
    stopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    stopBtn.Text = "⏹"
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.TextScaled = true
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.Parent = controlsFrame
    
    -- Next button
    local nextBtn = Instance.new("TextButton")
    nextBtn.Name = "NextBtn"
    nextBtn.Size = UDim2.new(0, 60, 1, 0)
    nextBtn.Position = UDim2.new(0, 210, 0, 0)
    nextBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    nextBtn.Text = "⏭"
    nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    nextBtn.TextScaled = true
    nextBtn.Font = Enum.Font.GothamBold
    nextBtn.Parent = controlsFrame
    
    -- Volume slider
    local volumeFrame = Instance.new("Frame")
    volumeFrame.Name = "VolumeFrame"
    volumeFrame.Size = UDim2.new(1, -20, 0, 30)
    volumeFrame.Position = UDim2.new(0, 10, 0, 150)
    volumeFrame.BackgroundTransparency = 1
    volumeFrame.Parent = mainFrame
    
    local volumeLabel = Instance.new("TextLabel")
    volumeLabel.Name = "VolumeLabel"
    volumeLabel.Size = UDim2.new(0, 80, 1, 0)
    volumeLabel.Position = UDim2.new(0, 0, 0, 0)
    volumeLabel.BackgroundTransparency = 1
    volumeLabel.Text = "Volume:"
    volumeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    volumeLabel.TextScaled = true
    volumeLabel.Font = Enum.Font.Gotham
    volumeLabel.TextXAlignment = Enum.TextXAlignment.Left
    volumeLabel.Parent = volumeFrame
    
    local volumeSlider = Instance.new("TextButton")
    volumeSlider.Name = "VolumeSlider"
    volumeSlider.Size = UDim2.new(1, -90, 0, 20)
    volumeSlider.Position = UDim2.new(0, 90, 0, 5)
    volumeSlider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    volumeSlider.Text = ""
    volumeSlider.Parent = volumeFrame
    
    local volumeFill = Instance.new("Frame")
    volumeFill.Name = "VolumeFill"
    volumeFill.Size = UDim2.new(self.volume, 0, 1, 0)
    volumeFill.Position = UDim2.new(0, 0, 0, 0)
    volumeFill.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    volumeFill.BorderSizePixel = 0
    volumeFill.Parent = volumeSlider
    
    -- Playlist display
    local playlistFrame = Instance.new("ScrollingFrame")
    playlistFrame.Name = "PlaylistFrame"
    playlistFrame.Size = UDim2.new(1, -20, 0, 100)
    playlistFrame.Position = UDim2.new(0, 10, 0, 190)
    playlistFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    playlistFrame.BorderSizePixel = 0
    playlistFrame.ScrollBarThickness = 8
    playlistFrame.Parent = mainFrame
    
    local playlistLayout = Instance.new("UIListLayout")
    playlistLayout.SortOrder = Enum.SortOrder.LayoutOrder
    playlistLayout.Parent = playlistFrame
    
    -- Add track button
    local addTrackBtn = Instance.new("TextButton")
    addTrackBtn.Name = "AddTrackBtn"
    addTrackBtn.Size = UDim2.new(1, -20, 0, 30)
    addTrackBtn.Position = UDim2.new(0, 10, 0, 250)
    addTrackBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    addTrackBtn.Text = "Add Track to Playlist"
    addTrackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addTrackBtn.TextScaled = true
    addTrackBtn.Font = Enum.Font.GothamBold
    addTrackBtn.Parent = mainFrame
    
    -- Connect button events
    prevBtn.MouseButton1Click:Connect(function()
        self:previous()
        self:updateGUI()
    end)
    
    playBtn.MouseButton1Click:Connect(function()
        if self.isPlaying then
            self:pause()
            playBtn.Text = "▶"
        else
            if self.currentSound then
                self:resume()
            else
                self:play()
            end
            playBtn.Text = "⏸"
        end
        self:updateGUI()
    end)
    
    stopBtn.MouseButton1Click:Connect(function()
        self:stop()
        playBtn.Text = "▶"
        self:updateGUI()
    end)
    
    nextBtn.MouseButton1Click:Connect(function()
        self:next()
        self:updateGUI()
    end)
    
    addTrackBtn.MouseButton1Click:Connect(function()
        local path = game:GetService("TextService"):GetStringAsync("Enter file path:")
        if path and path ~= "" then
            self:addToPlaylist(path)
            self:updatePlaylist()
        end
    end)
    
    -- Volume slider interaction
    volumeSlider.MouseButton1Click:Connect(function(x)
        local relativeX = x / volumeSlider.AbsoluteSize.X
        self:setVolume(relativeX)
        volumeFill.Size = UDim2.new(relativeX, 0, 1, 0)
    end)
    
    self.gui = screenGui
    self:updateGUI()
    self:updatePlaylist()
    
    print("Media Player GUI created!")
end

-- Update GUI elements
function MediaPlayer:updateGUI()
    if not self.gui then return end
    
    local trackInfo = self.gui.MainFrame.TrackInfo
    local playBtn = self.gui.MainFrame.ControlsFrame.PlayBtn
    
    if #self.playlist > 0 and self.currentIndex <= #self.playlist then
        local currentTrack = self.playlist[self.currentIndex]
        trackInfo.Text = currentTrack.name .. " (" .. self.currentIndex .. "/" .. #self.playlist .. ")"
    else
        trackInfo.Text = "No track selected"
    end
    
    if self.isPlaying then
        playBtn.Text = "⏸"
    else
        playBtn.Text = "▶"
    end
end

function MediaPlayer:updatePlaylist()
    if not self.gui then return end
    
    local playlistFrame = self.gui.MainFrame.PlaylistFrame
    local playlistLayout = playlistFrame.UIListLayout
    
    -- Clear existing items
    for _, child in pairs(playlistFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add playlist items
    for i, track in ipairs(self.playlist) do
        local trackFrame = Instance.new("Frame")
        trackFrame.Name = "Track" .. i
        trackFrame.Size = UDim2.new(1, 0, 0, 25)
        trackFrame.BackgroundColor3 = i == self.currentIndex and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(50, 50, 50)
        trackFrame.BorderSizePixel = 0
        trackFrame.Parent = playlistFrame
        
        local trackLabel = Instance.new("TextLabel")
        trackLabel.Name = "TrackLabel"
        trackLabel.Size = UDim2.new(1, -60, 1, 0)
        trackLabel.Position = UDim2.new(0, 5, 0, 0)
        trackLabel.BackgroundTransparency = 1
        trackLabel.Text = track.name
        trackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        trackLabel.TextScaled = true
        trackLabel.Font = Enum.Font.Gotham
        trackLabel.TextXAlignment = Enum.TextXAlignment.Left
        trackLabel.Parent = trackFrame
        
        local removeBtn = Instance.new("TextButton")
        removeBtn.Name = "RemoveBtn"
        removeBtn.Size = UDim2.new(0, 50, 1, 0)
        removeBtn.Position = UDim2.new(1, -55, 0, 0)
        removeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        removeBtn.Text = "✕"
        removeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        removeBtn.TextScaled = true
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.Parent = trackFrame
        
        removeBtn.MouseButton1Click:Connect(function()
            self:removeFromPlaylist(i)
            self:updatePlaylist()
            self:updateGUI()
        end)
        
        trackFrame.MouseButton1Click:Connect(function()
            self.currentIndex = i
            self:play()
            self:updateGUI()
            self:updatePlaylist()
        end)
    end
    
    playlistFrame.CanvasSize = UDim2.new(0, 0, 0, playlistLayout.AbsoluteContentSize.Y)
end

-- Initialize and create the media player
local player = MediaPlayer.new()
player:createGUI()

-- Example usage - add some sample tracks (you'll need to provide actual file paths)
print("Media Player initialized!")
print("Use the GUI to add tracks and control playback.")
print("Example: player:addToPlaylist('path/to/your/audio.mp3', 'Track Name')")

-- Keyboard shortcuts
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space then
        if player.isPlaying then
            player:pause()
        else
            if player.currentSound then
                player:resume()
            else
                player:play()
            end
        end
        player:updateGUI()
    elseif input.KeyCode == Enum.KeyCode.Left then
        player:previous()
        player:updateGUI()
    elseif input.KeyCode == Enum.KeyCode.Right then
        player:next()
        player:updateGUI()
    elseif input.KeyCode == Enum.KeyCode.Escape then
        player:stop()
        player:updateGUI()
    end
end)
