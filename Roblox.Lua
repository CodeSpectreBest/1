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

-- Servisler ve Değişkenler
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Player tab ve sliderlar
local PlayerTab = Window:CreateTab("Player", 4483362458)

-- 1. WalkSpeed Kaydırıcısı
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10,100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(Value)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end,
})

-- 2. JumpPower Kaydırıcısı
PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {20,200},
    Increment = 5,
    Suffix = "Power",
    CurrentValue = 50,
    Callback = function(Value)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end,
})

-- 3. FOV/Zoom Ayarı Kaydırıcısı
PlayerTab:CreateSlider({
    Name = "FOV/Zoom Ayarı",
    Range = {30, 120},
    Increment = 1,
    Suffix = "Derece",
    CurrentValue = 70,
    Callback = function(Value)
        if camera then
            camera.FieldOfView = Value
        end
    end,
})

-- 4. Fly (Uçma) Açma/Kapama Tuşu (Düzeltildi)
local flyConnection = nil
local flySpeed = 50 

PlayerTab:CreateToggle({
    Name = "Fly (Uçma)",
    CurrentValue = false,
    Callback = function(Toggled)
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local humanoid = char:FindFirstChild("Humanoid")

        if Toggled then
            if humanoid then
                humanoid.PlatformStand = true
                humanoid.Sit = true -- Daha stabil olması için eklendi
            end
            
            flyConnection = runService.RenderStepped:Connect(function(dt)
                local success, err = pcall(function() -- Hata yakalama eklendi
                    local velocity = Vector3.new(0, 0, 0)
                    local camCFrame = camera.CFrame
                    local forward = camCFrame.LookVector
                    local right = camCFrame.RightVector
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + forward end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - forward end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + right end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - right end
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocity = velocity - Vector3.new(0, 1, 0) end
                    
                    if velocity.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + velocity.unit * flySpeed * dt
                    end
                end)
                if not success then warn("Fly Hata:", err) end
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            if humanoid then 
                humanoid.PlatformStand = false
                humanoid.Sit = false
            end
        end
    end,
})

-- 5. 3. Şahıs Kamera Kontrolü (Düzeltildi)
local cameraConnection = nil
local cameraDistance = 12
local cameraHeight = 3
local cameraOffset = Vector3.new(0, cameraHeight, 0)

local function updateCameraLogic()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local camPos = hrp.Position - hrp.CFrame.LookVector * cameraDistance + cameraOffset
        camera.CFrame = CFrame.new(camPos, hrp.Position + cameraOffset)
    end
end

PlayerTab:CreateToggle({
    Name = "3. Şahıs Kamera (Özel Görünüm)",
    CurrentValue = false,
    Callback = function(Toggled)
        if Toggled then
            StarterGui:SetCore("DevEnableMouseLock", false)
            camera.CameraType = Enum.CameraType.Scriptable
            
            cameraConnection = runService.RenderStepped:Connect(function()
                local success, err = pcall(updateCameraLogic) -- Hata yakalama eklendi
                if not success then warn("Kamera Hata:", err) end
            end)
        else
            camera.CameraType = Enum.CameraType.Custom
            if cameraConnection then cameraConnection:Disconnect() end
        end
    end,
})
