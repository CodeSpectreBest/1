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
local UserInputService = game:GetService("UserInputService") -- YENİ EKLENTİ: Girişleri kontrol etmek için

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

-- 4. Fly (Uçma) Açma/Kapama Tuşu (Düzeltilmiş)
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
                humanoid.PlatformStand = true -- Karakterin yere basmasını engeller
            end
            
            -- Uçuş döngüsünü başlat
            flyConnection = runService.RenderStepped:Connect(function()
                -- Yatay hareket (WASD)
                local moveVector = player.MoveDirection
                local camCFrame = camera.CFrame
                
                -- Karakteri, kamera yönüne göre hareket ettir
                local velocity = camCFrame.LookVector * moveVector.Z + camCFrame.RightVector * moveVector.X
                
                -- Dikey hareket (Space ve Shift) - ARTIK UserInputService KULLANILIYOR
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + Vector3.new(0, 1, 0) -- Yukarı
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    velocity = velocity + Vector3.new(0, -1, 0) -- Aşağı
                end
                
                -- Karakteri hareket ettir
                if velocity.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity = velocity.unit * flySpeed
                else
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Hareketsizken durmasını sağla
                end
            end)
        else
            -- Uçuşu durdur
            if flyConnection then flyConnection:Disconnect() end
            if humanoid then humanoid.PlatformStand = false end
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end,
})

-- 5. 3. Şahıs Kamera Kontrolü
local cameraConnection = nil
local cameraDistance = 12
local cameraHeight = 3
local cameraOffset = Vector3.new(0, cameraHeight, 0)

local function updateCamera()
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
            camera.CameraType = Enum.CameraType.Scriptable
            cameraConnection = runService.RenderStepped:Connect(updateCamera)
        else
            camera.CameraType = Enum.CameraType.Custom
            if cameraConnection then cameraConnection:Disconnect() end
        end
    end,
})
