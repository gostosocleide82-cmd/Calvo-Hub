--// Moon Hub - Real Working Version (Blox Fruits)
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
    AutoHop = false
}

-- ================= FUNÇÕES =================

local function IsNight()
    return Lighting.ClockTime >= 18 or Lighting.ClockTime <= 6
end

-- Full Moon ocorre por volta de meia-noite (aprox)
local function IsFullMoonWindow()
    return Lighting.ClockTime >= 23.5 or Lighting.ClockTime <= 0.5
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
Main.Size = UDim2.new(0,320,0,220)
Main.Position = UDim2.new(0.5,-160,0.15,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "🌕 MOON HUB (REAL)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(0,170,255)

local Info = Instance.new("TextLabel", Main)
Info.Position = UDim2.new(0,0,0,50)
Info.Size = UDim2.new(1,0,0,60)
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham
Info.TextSize = 14
Info.TextColor3 = Color3.new(1,1,1)
Info.TextWrapped = true
Info.Text = "Carregando..."

local function Toggle(text, y, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9,0,0,36)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text.." : OFF"
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", b)

    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = text.." : "..(on and "ON" or "OFF")
        b.BackgroundColor3 = on and Color3.fromRGB(0,140,255) or Color3.fromRGB(40,40,40)
        callback(on)
    end)
end

Toggle("🌕 Auto Find Full Moon", 120, function(v)
    MoonHub.AutoFind = v
end)

Toggle("🔁 Auto Hop Full Moon", 165, function(v)
    MoonHub.AutoHop = v
end)

-- ================= LOOP =================

task.spawn(function()
    while task.wait(1) do
        local night = IsNight()
        local fullWindow = IsFullMoonWindow()

        Info.Text =
            "ClockTime: "..string.format("%.2f", Lighting.ClockTime).."\n"..
            "Noite: "..(night and "SIM" or "NÃO").."\n"..
            "Janela Full Moon: "..(fullWindow and "SIM" or "NÃO")

        if MoonHub.AutoFind then
            if night and fullWindow then
                Info.Text = Info.Text.."\n\n✅ FULL MOON ENCONTRADA"
                MoonHub.AutoHop = false
            else
                if MoonHub.AutoHop then
                    task.wait(1)
                    ServerHop()
                end
            end
        end
    end
end)

print("✅ Moon Hub REAL carregado")
