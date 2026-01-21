--// Calvo Hub - Delta Fix 2026
repeat task.wait() until game:IsLoaded()
task.wait(5)

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

task.spawn(function()
    while task.wait(2) do
        if CalvoHub.AutoSail and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                player.Character.HumanoidRootPart.CFrame *= CFrame.new(0,0,-300)
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(4) do
        if CalvoHub.AutoMirage then
            for _,v in pairs(workspace:GetChildren()) do
                if string.find(string.lower(v.Name),"mirage") then
                    player.Character.HumanoidRootPart.CFrame = v.WorldPivot
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(3) do
        if CalvoHub.AutoGear and player.Character then
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "Blue Gear" or v.Name == "Gear" then
                    player.Character.HumanoidRootPart.CFrame = v.CFrame
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if CalvoHub.AutoMoonV3 and workspace.CurrentCamera then
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + Vector3.new(0,800,0))
        end
    end
end)

-- ================= UI (DELTA SAFE) =================

local CoreGui = game:GetService("CoreGui")
local gui = Instance.new("ScreenGui")
gui.Name = "CalvoHubUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0,340,0,280)
Main.Position = UDim2.new(0.5,-170,0.5,-140)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.Text = "CALVO HUB"
Title.TextColor3 = Color3.fromRGB(0,170,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 21

local function Toggle(txt,y,flag)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9,0,0,38)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = txt.." : OFF"
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b)

    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        CalvoHub[flag] = on
        b.Text = txt.." : "..(on and "ON" or "OFF")
        b.BackgroundColor3 = on and Color3.fromRGB(0,140,255) or Color3.fromRGB(40,40,40)
    end)
end

Toggle("🚤 Auto Sail", 55, "AutoSail")
Toggle("🌴 Auto Mirage", 105, "AutoMirage")
Toggle("⚙️ Auto Gear", 155, "AutoGear")
Toggle("🌕 Auto Moon (V3)", 205, "AutoMoonV3")

print("✅ Calvo Hub aberto (Delta OK)")
