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

-- 1. WalkSpeed Kaydırıcısı
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10,100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
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
        local char = game.Players.LocalPlayer.Character
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
        local cam = workspace.CurrentCamera
        if cam then
            cam.FieldOfView = Value
        end
    end,
})

-- 4. YENİ EKLENTİ: Fly (Uçma) Açma/Kapama Tuşu
local flyConnection = nil
local flySpeed = 50 -- Uçma hızı (istenirse buna da slider eklenebilir)

PlayerTab:CreateToggle({
    Name = "Fly (Uçma)",
    CurrentValue = false,
    Callback = function(Toggled)
        local player = game.Players.LocalPlayer
        local char = player.Character
        
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local humanoid = char:FindFirstChild("Humanoid")

        if Toggled then
            if humanoid then
                humanoid.PlatformStand = true -- Karakterin yere basmasını engeller
            end
            
            -- Uçuş döngüsünü başlat
            flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                -- WASD input'una göre hareket yönünü hesapla
                local moveVector = player.MoveDirection
                local camCFrame = workspace.CurrentCamera.CFrame
                
                -- Karakteri, kamera yönüne göre hareket ettir
                local velocity = camCFrame.LookVector * moveVector.Z + camCFrame.RightVector * moveVector.X
                
                -- Yukarı (Space) ve Aşağı (Shift) tuşlarını kontrol et
                if player:GetMouse().KeyUp and player:GetMouse().KeyUp.KeyCode == Enum.KeyCode.Space then
                    velocity = velocity + Vector3.new(0, 1, 0)
                elseif player:GetMouse().KeyDown and player:GetMouse().KeyDown.KeyCode == Enum.KeyCode.LeftShift then
                    velocity = velocity + Vector3.new(0, -1, 0)
                end
                
                -- Karakteri hareket ettir
                hrp.AssemblyLinearVelocity = velocity.unit * flySpeed
            end)
        else
            -- Uçuşu durdur
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            if humanoid then
                humanoid.PlatformStand = false -- Karakteri yere indirir
            end
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- Hızı sıfırla
        end
    end,
})

-- 3. şahıs kamera (Değişmedi)
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
