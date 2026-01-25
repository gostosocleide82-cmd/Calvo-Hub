--// Calvo Hub - Chest Drop Scanner (REAL)
repeat task.wait() until game:IsLoaded()
task.wait(2)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- ================= STATE =================
getgenv().CalvoHub = {
    AutoChest = false,
    AutoHop = false,
    FoundDrop = false,
    Farming = false
}

-- ================= DROP CHECK (MAPA) =================
local function DropSpawned(name)
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and v.Name == name then
            return v
        end
    end
    return nil
end

local function GotItem(name)
    return player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
end

-- ================= CHESTS =================
local function GetChests()
    local chests = {}
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("chest") then
            table.insert(chests, v)
        end
    end
    return chests
end

-- ================= MOVE =================
local function TweenTo(pos)
    local dist = (hrp.Position - pos).Magnitude
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(dist / 280, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    )
    tween:Play()
    tween.Completed:Wait()
end

-- ================= SERVER HOP =================
local function ServerHop()
    local servers = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
        )
    )

    for _,s in ipairs(servers.data) do
        if s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
            break
        end
    end
end

-- ================= UI =================
local CoreGui = game:GetService("CoreGui")
pcall(function() CoreGui:FindFirstChild("CalvoChestHub"):Destroy() end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "CalvoChestHub"

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0,340,0,240)
Main.Position = UDim2.new(0.5,-170,0.15,0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "📦 Calvo Hub — Chest Scanner"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0,170,255)

local Status = Instance.new("TextLabel", Main)
Status.Position = UDim2.new(0,0,0,45)
Status.Size = UDim2.new(1,0,0,70)
Status.BackgroundTransparency = 1
Status.TextWrapped = true
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.TextColor3 = Color3.new(1,1,1)

local function Button(text, y, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9,0,0,34)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text.." : OFF"
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)

    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = text.." : "..(on and "ON" or "OFF")
        b.BackgroundColor3 = on and Color3.fromRGB(0,140,255) or Color3.fromRGB(40,40,40)
        callback(on)
    end)
end

Button("📦 Auto Chest", 130, function(v)
    CalvoHub.AutoChest = v
end)

Button("🔁 Auto Hop Chest", 170, function(v)
    CalvoHub.AutoHop = v
end)

-- ================= MAIN LOOP =================
task.spawn(function()
    while task.wait(1) do
        local chalice = DropSpawned("God Chalice")
        local fist = DropSpawned("Fist of Darkness")

        Status.Text =
            "God Chalice no mapa: "..(chalice and "✅ SIM" or "❌ NÃO").."\n"..
            "Fist of Darkness no mapa: "..(fist and "✅ SIM" or "❌ NÃO")

        if GotItem("God Chalice") or GotItem("Fist of Darkness") then
            CalvoHub.AutoChest = false
            CalvoHub.AutoHop = false
            Status.Text ..= "\n\n🎉 ITEM OBTIDO — PARANDO"
            break
        end

        if CalvoHub.AutoChest then
            local chests = GetChests()
            if #chests > 0 then
                for _,c in ipairs(chests) do
                    if not CalvoHub.AutoChest then break end
                    TweenTo(c.Position + Vector3.new(0,3,0))
                    task.wait(0.3)
                end
            elseif CalvoHub.AutoHop then
                ServerHop()
                break
            end
        end
    end
end)

print("✅ Calvo Hub Chest Scanner carregado")
