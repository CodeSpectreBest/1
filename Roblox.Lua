-- Rayfield kütüphanesini yükle
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Pencere oluştur
local Window = Rayfield:CreateWindow({
    Name = "Helloback Ftap Hub 1.0",
    LoadingTitle = "Helloback Ftap Hub 1.0",
    LoadingSubtitle = "by Helloback",
    Theme = "Ocean",
    ToggleUIKeybind = "K",
    KeySystem = true,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        Key = {"HelloBack"}
    }
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)

-- WalkSpeed Slider
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 10,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end,
})

-- JumpPower Slider
PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {20, 200},
    Increment = 5,
    Suffix = "Power",
    CurrentValue = 50,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end,
})

-- HUB GUI
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

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

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8,0,0.2,0)
button.Position = UDim2.new(0.1,0,0.5,0)
button.Text = "KAPAT / AÇ"
button.Parent = frame

-- 3. şahıs kamera
camera.CameraType = Enum.CameraType.Scriptable
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            camera.CFrame = CFrame.new(root.Position + Vector3.new(0,5,10), root.Position)
        end
    end
end)

-- HUB buton gizle/göster
local hubVisible = true
button.MouseButton1Click:Connect(function()
    hubVisible = not hubVisible
    frame.Visible = hubVisible
end)
