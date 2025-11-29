local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Helloback Ftap Hub 1.0",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Helloback Ftap Hub 1.0",
   LoadingSubtitle = "by Helloback",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"HelloBack"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local PlayerTab = Window:CreateTab("Player", 4483362458) -- Title, Image
local Slider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 10,
    Flag = "Slider1",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end,
})

local JumpSlider = PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {20, 200},
    Increment = 5,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpSlider",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end,
})

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ===== HUB GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HubGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.4,0,0.4,0)
frame.Position = UDim2.new(0.3,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0.3,0)
title.Text = "HUB MENU"
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

-- Buton örneği
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8,0,0.2,0)
button.Position = UDim2.new(0.1,0,0.5,0)
button.Text = "KAPAT / AÇ"
button.Parent = frame

-- ===== 3. ŞAHSIS KAMERA =====
camera.CameraType = Enum.CameraType.Scriptable

local function updateCamera()
    local character = player.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            -- Karakterin arkasına ve biraz yukarıya kamera
            camera.CFrame = CFrame.new(root.Position + Vector3.new(0,5,10), root.Position)
        end
    end
end

RunService.RenderStepped:Connect(updateCamera)

-- ===== HUB BUTONU İLE GİZLE/GÖSTER =====
local hubVisible = true
button.MouseButton1Click:Connect(function()
    hubVisible = not hubVisible
    frame.Visible = hubVisible
end)
