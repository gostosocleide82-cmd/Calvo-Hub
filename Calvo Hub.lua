--// Calvo Hub - Auto Sail Advanced (Delta)
repeat task.wait() until game:IsLoaded()
task.wait(5)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- ================= CONFIG =================

getgenv().CalvoHub = {
    AutoSail = false,
    SelectedBoat = "Guardian"
}

local Boats = {
    "Dinghy",
    "Sloop",
    "Brigade",
    "Guardian"
}

-- ================= FUNÇÕES =================

local function FlyTo(cf)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    TweenService:Create(
        hrp,
        TweenInfo.new(dist / 200, Enum.EasingStyle.Linear),
        {CFrame = cf}
    ):Play()
    task.wait(dist / 200)
end

local function EnableNoclip(state)
    for _,v in pairs(player.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end

-- ================= AUTO SAIL =================

task.spawn(function()
    while task.wait(2) do
        if CalvoHub.AutoSail and player.Character then
            pcall(function()
                -- 1️⃣ Ir até Tiki Outpost (posição aproximada)
                EnableNoclip(true)
                FlyTo(CFrame.new(-16200, 20, -200)) -- TIKI OUTPOST
                task.wait(1)

                -- 2️⃣ Falar com vendedor de barco
                for _,npc in pairs(workspace:GetDescendants()) do
                    if npc.Name:lower():find("boat") and npc:FindFirstChild("HumanoidRootPart") then
                        FlyTo(npc.HumanoidRootPart.CFrame)
                        task.wait(0.5)

                        -- Simula interação
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.2)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        break
                    end
                end

                task.wait(1)

                -- 3️⃣ Comprar barco (simples)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.2)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

                task.wait(2)

                -- 4️⃣ Sentar no barco
                for _,v in pairs(workspace:GetChildren()) do
                    if v.Name:lower():find(CalvoHub.SelectedBoat:lower()) then
                        local seat = v:FindFirstChildWhichIsA("VehicleSeat", true)
                        if seat then
                            FlyTo(seat.CFrame)
                            task.wait(0.5)
                            seat:Sit(player.Character.Humanoid)
                            break
                        end
                    end
                end

                -- 5️⃣ Dirigir automaticamente
                EnableNoclip(false)
                while CalvoHub.AutoSail do
                    task.wait(0.2)
                    local hum = player.Character:FindFirstChild("Humanoid")
                    if hum then
                        hum:Move(Vector3.new(0,0,-1), true)
                    end
                end
            end)
        end
    end
end)

-- ================= UI =================

local CoreGui = game:GetService("CoreGui")
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "CalvoHubUI"
gui.ResetOnSpawn = false

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0,360,0,300)
Main.Position = UDim2.new(0.5,-180,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,-40,0,40)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "CALVO HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(0,170,255)

-- BOTÃO MINIMIZAR
local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0,30,0,30)
Min.Position = UDim2.new(1,-35,0,5)
Min.Text = "-"
Min.Font = Enum.Font.GothamBold
Min.TextSize = 20
Min.BackgroundColor3 = Color3.fromRGB(40,40,40)
Min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Min)

local minimized = false
Min.MouseButton1Click:Connect(function()
    minimized = not minimized
    Main.Size = minimized and UDim2.new(0,360,0,45) or UDim2.new(0,360,0,300)
    Min.Text = minimized and "+" or "-"
end)

-- DROPDOWN SIMPLES (BARCOS)
local BoatLabel = Instance.new("TextLabel", Main)
BoatLabel.Position = UDim2.new(0.05,0,0,55)
BoatLabel.Size = UDim2.new(0.9,0,0,30)
BoatLabel.Text = "Barco: "..CalvoHub.SelectedBoat
BoatLabel.BackgroundColor3 = Color3.fromRGB(35,35,35)
BoatLabel.TextColor3 = Color3.new(1,1,1)
BoatLabel.Font = Enum.Font.Gotham
BoatLabel.TextSize = 14
Instance.new("UICorner", BoatLabel)

BoatLabel.InputBegan:Connect(function()
    local idx = table.find(Boats, CalvoHub.SelectedBoat) or 1
    idx = idx + 1
    if idx > #Boats then idx = 1 end
    CalvoHub.SelectedBoat = Boats[idx]
    BoatLabel.Text = "Barco: "..CalvoHub.SelectedBoat
end)

-- TOGGLE AUTO SAIL
local Sail = Instance.new("TextButton", Main)
Sail.Position = UDim2.new(0.05,0,0,100)
Sail.Size = UDim2.new(0.9,0,0,40)
Sail.Text = "🚤 Auto Sail : OFF"
Sail.Font = Enum.Font.Gotham
Sail.TextSize = 15
Sail.TextColor3 = Color3.new(1,1,1)
Sail.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", Sail)

Sail.MouseButton1Click:Connect(function()
    CalvoHub.AutoSail = not CalvoHub.AutoSail
    Sail.Text = "🚤 Auto Sail : "..(CalvoHub.AutoSail and "ON" or "OFF")
    Sail.BackgroundColor3 = CalvoHub.AutoSail and Color3.fromRGB(0,140,255) or Color3.fromRGB(40,40,40)
end)

print("✅ Calvo Hub carregado (Auto Sail avançado)")
