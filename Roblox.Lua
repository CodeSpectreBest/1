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
        FileName = "Key",
        SaveKey = true,
        Key = {"HelloBack"}
    }
})

-- Player tab ve sliderlar
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10,100},
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
PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {20,200},
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

-- 3. şahıs kamera
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local cameraDistance = 12
local cameraHeight = 3
local cameraOffset = Vector3.new(0, cameraHeight, 0)

local gui = player:WaitForChild("PlayerGui"):WaitForChild("ThirdPersonHubGUI")
local button = gui:WaitForChild("EnableButton")

local cameraActive = false
local updateConnection

local function updateCamera()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local camPos = hrp.Position - hrp.CFrame.LookVector * cameraDistance + cameraOffset
        camera.CFrame = CFrame.new(camPos, hrp.Position + cameraOffset)
    end
end

button.MouseButton1Click:Connect(function()
    cameraActive = not cameraActive
    if cameraActive then
        button.Text = "3rd Person Açık"
        updateConnection = runService.RenderStepped:Connect(updateCamera)
    else
        button.Text = "3rd Person Aç"
        if updateConnection then updateConnection:Disconnect() end
    end
end)
