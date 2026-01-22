--// Auto Full Moon Finder - Blox Fruits
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- ================= CONFIG =================
getgenv().MoonHub = {
    AutoHop = true,      -- trocar de servidor automaticamente
    CheckDelay = 5       -- segundos entre checagens
}

-- ================= FUNÇÕES =================

local function GetMoonStage()
    -- Roblox nativo
    return Lighting:GetMoonPhase()
end

local function IsFullMoon()
    return GetMoonStage() == Enum.MoonPhase.Full
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
            task.wait(2)
        end
    end
end

-- ================= UI SIMPLES =================

local CoreGui = game:GetService("CoreGui")
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MoonHubUI"
gui.ResetOnSpawn = false

local Frame = Instance.new("Frame", gui)
Frame.Size = UDim2.new(0,300,0,140)
Frame.Position = UDim2.new(0.5,-150,0.1,0)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundTransparency = 1
Title.Text = "🌕 Moon Finder"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0,170,255)

local Status = Instance.new("TextLabel", Frame)
Status.Position = UDim2.new(0,0,0,45)
Status.Size = UDim2.new(1,0,0,30)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.TextColor3 = Color3.new(1,1,1)
Status.Text = "Lua: ..."

local Info = Instance.new("TextLabel", Frame)
Info.Position = UDim2.new(0,0,0,80)
Info.Size = UDim2.new(1,0,0,40)
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham
Info.TextSize = 13
Info.TextColor3 = Color3.fromRGB(180,180,180)
Info.TextWrapped = true
Info.Text = "Procurando Full Moon..."

-- ================= LOOP PRINCIPAL =================

task.spawn(function()
    while task.wait(MoonHub.CheckDelay) do
        local stage = GetMoonStage()
        Status.Text = "Lua: "..stage.Name

        if IsFullMoon() then
            Info.Text = "✅ FULL MOON ENCONTRADA!"
            Info.TextColor3 = Color3.fromRGB(0,255,120)
            MoonHub.AutoHop = false
            break
        else
            Info.Text = "❌ Não é Full Moon"
            Info.TextColor3 = Color3.fromRGB(255,100,100)

            if MoonHub.AutoHop then
                task.wait(2)
                ServerHop()
                break
            end
        end
    end
end)

print("✅ Moon Finder carregado")
