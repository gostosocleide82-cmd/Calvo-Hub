--// Calvo Hub - Blox Fruits 2026
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

getgenv().CalvoHub = {
    AutoSail = false,
    AutoMirage = false,
    AutoGear = false,
    AutoMoonV3 = false
}

-- ================= FUNÇÕES =================

local function TP(cf)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        TweenService:Create(
            char.HumanoidRootPart,
            TweenInfo.new((char.HumanoidRootPart.Position - cf.Position).Magnitude / 250),
            {CFrame = cf}
        ):Play()
    end
end

-- AUTO SAIL
task.spawn(function()
    while true do
        task.wait(2)
        if CalvoHub.AutoSail and player.Character then
            pcall(function()
                player.Character.HumanoidRootPart.CFrame *= CFrame.new(0,0,-400)
            end)
        end
    end
end)

-- AUTO MIRAGE
task.spawn(function()
    while true do
        task.wait(5)
        if CalvoHub.AutoMirage then
            for _,v in pairs(workspace:GetChildren()) do
                if v.Name:lower():find("mirage") then
                    TP(v.WorldPivot)
                end
            end
        end
    end
end)

-- AUTO GEAR
task.spawn(function()
    while true do
        task.wait(3)
        if CalvoHub.AutoGear and player.Character then
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "Blue Gear" or v.Name == "Gear" then
                    TP(v.CFrame)
                    firetouchinterest(player.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, v, 1)
                end
            end
        end
    end
end)

-- AUTO LUA V3
task.spawn(function()
    while true do
        task.wait(1)
        if CalvoHub.AutoMoonV3 then
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(
                cam.CFrame.Position,
                cam.CFrame.Position + Vector3.new(0,1000,0)
            )
        end
    end
end)

-- ================= UI =================

local gui = Instance.new("ScreenGui")
gui.Name = "CalvoHubUI"
gui.Parent = game:GetService("CoreGui") -- MUITO IMPORTANTE
gui.ResetOnSpawn = false

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0,360,0,300)
Main.Position = UDim2.new(0.5,-180,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "🌴 CALVO HUB"
Title.TextColor3 = Color3.fromRGB(0,170,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

local function Toggle(text, y, flag)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text.." : OFF"
    b.Font = Enum.Font.Gotham
    b.TextSize = 15
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)

    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        CalvoHub[flag] = on
        b.Text = text.." : "..(on and "ON" or "OFF")
        TweenService:Create(b,TweenInfo.new(0.2),{
            BackgroundColor3 = on and Color3.fromRGB(0,140,255) or Color3.fromRGB(35,35,35)
        }):Play()
    end)
end

Toggle("🚤 Auto Sail", 60, "AutoSail")
Toggle("🌴 Auto Mirage", 110, "AutoMirage")
Toggle("⚙️ Auto Blue Gear", 160, "AutoGear")
Toggle("🌕 Auto Moon (V3)", 210, "AutoMoonV3")

print("✅ Calvo Hub carregado com sucesso")
