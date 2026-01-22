--// Moon Hub - Blox Fruits (Delta Safe)
repeat task.wait() until game:IsLoaded()
task.wait(3)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- ================= CONFIG =================
getgenv().MoonHub = {
    AutoFind = false,
    AutoHop = false,
    Checking = false
}

-- ================= FUNÇÕES =================

local function GetMoonPhaseName()
    -- fallback seguro (funciona no Delta)
    local phase = Lighting.MoonPhase
    if typeof(phase) == "EnumItem" then
        return phase.Name
    end
    return "Desconhecida"
end

local function IsFullMoon()
    return GetMoonPhaseName() == "Full"
end

local function ServerHop()
    local placeId = game.PlaceId
    local servers = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
        )
    )

    for _,server in pairs(servers.data) do
        if server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
            break
        end
    end
end

-- ================= UI =================

local CoreGui = game:GetService("CoreGui")
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MoonHubUI"
gui.ResetOnSpawn = false

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0,320,0,210)
Main.Position = UDim2.new(0.5,-160,0.15,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "🌕 MOON HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(0,170,255)

local MoonLabel = Instance.new("TextLabel", Main)
MoonLabel.Position = UDim2.new(0,0,0,50)
MoonLabel.Size = UDim2.new(1,0,0,30)
MoonLabel.BackgroundTransparency = 1
MoonLabel.Font = Enum.Font.Gotham
MoonLabel.TextSize = 15
MoonLabel.TextColor3 = Color3.new(1,1,1)
MoonLabel.Text = "Lua: ..."

local Status = Instance.new("TextLabel", Main)
Status.Position = UDim2.new(0,0,0,80)
Status.Size = UDim2.new(1,0,0,30)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.TextColor3 = Color3.fromRGB(180,180,180)
Status.Text = "Status: aguardando"

local function CreateToggle(text, y, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9,0,0,36)
    btn.Position = UDim2.new(0.05,0,0,y)
    btn.Text = text.." : OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn)

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = text.." : "..(on and "ON" or "OFF")
        btn.BackgroundColor3 = on and Color3.fromRGB(0,140,255) or Color3.fromRGB(40,40,40)
        callback(on)
    end)
end

CreateToggle("🌕 Auto Find Full Moon", 115, function(v)
    MoonHub.AutoFind = v
end)

CreateToggle("🔁 Auto Hop Full Moon", 160, function(v)
    MoonHub.AutoHop = v
end)

-- ================= LOOP PRINCIPAL =================

task.spawn(function()
    while task.wait(2) do
        local phase = GetMoonPhaseName()
        MoonLabel.Text = "Lua: "..phase

        if MoonHub.AutoFind then
            if IsFullMoon() then
                Status.Text = "Status: ✅ FULL MOON!"
                Status.TextColor3 = Color3.fromRGB(0,255,120)
                MoonHub.AutoHop = false
            else
                Status.Text = "Status: ❌ não é Full Moon"
                Status.TextColor3 = Color3.fromRGB(255,120,120)

                if MoonHub.AutoHop then
                    task.wait(1)
                    ServerHop()
                end
            end
        else
            Status.Text = "Status: aguardando"
            Status.TextColor3 = Color3.fromRGB(180,180,180)
        end
    end
end)

print("✅ Moon Hub carregado com sucesso")
