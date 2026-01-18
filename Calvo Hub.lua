--// Calvo Hub UI - Blox Fruits 2026

repeat task.wait() until game:IsLoaded()

local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

getgenv().CalvoHub = {
    AutoSail = false,
    AutoMirage = false,
    AutoGear = false,
    AutoMoonV3 = false
}

-- UI BASE
local gui = Instance.new("ScreenGui", Player.PlayerGui)
gui.Name = "CalvoHubUI"
gui.ResetOnSpawn = false

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 360, 0, 300)
Main.Position = UDim2.new(0.5, -180, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Name = "Main"

-- CORNER
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

-- TÍTULO
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "🌴 CALVO HUB"
Title.TextColor3 = Color3.fromRGB(0,170,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

-- FUNÇÃO BOTÃO
local function CreateToggle(text, posY, callback)
    local Button = Instance.new("TextButton", Main)
    Button.Size = UDim2.new(0.9,0,0,42)
    Button.Position = UDim2.new(0.05,0,0,posY)
    Button.Text = text .. " : OFF"
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 15
    Button.TextColor3 = Color3.new(1,1,1)
    Button.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Button.BorderSizePixel = 0
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0,10)

    local enabled = false

    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        Button.Text = text .. (enabled and " : ON" or " : OFF")
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(0,140,255) or Color3.fromRGB(35,35,35)
        }):Play()
        callback(enabled)
    end)
end

-- BOTÕES
CreateToggle("🚤 Auto Sail", 60, function(v)
    CalvoHub.AutoSail = v
end)

CreateToggle("🌴 Auto Mirage", 110, function(v)
    CalvoHub.AutoMirage = v
end)

CreateToggle("⚙️ Auto Blue Gear", 160, function(v)
    CalvoHub.AutoGear = v
end)

CreateToggle("🌕 Auto Moon (V3)", 210, function(v)
    CalvoHub.AutoMoonV3 = v
end)

-- FOOTER
local Footer = Instance.new("TextLabel", Main)
Footer.Size = UDim2.new(1,0,0,30)
Footer.Position = UDim2.new(0,0,1,-30)
Footer.BackgroundTransparency = 1
Footer.Text = "Calvo Hub • 2026"
Footer.TextColor3 = Color3.fromRGB(120,120,120)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 12

print("✅ Calvo Hub UI carregada")
