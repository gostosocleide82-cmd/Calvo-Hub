--// Moon Hub - Fixed & Functional Version
repeat task.wait() until game:IsLoaded()
task.wait(2)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- ================= CONFIG =================
getgenv().MoonHub = {
    AutoFull = false,
    Auto75 = false,
    AutoHop = false
}

-- ================= FUNÇÕES DE LUA =================

local function IsNight()
    return Lighting.ClockTime >= 18 or Lighting.ClockTime <= 6
end

local function GetMoonPhaseName()
    local t = Lighting.ClockTime

    if t >= 6 and t < 18 then
        return "☀️ Day"
    elseif t >= 18 and t < 23 then
        return "🌘 Waxing Moon"
    elseif t >= 23 and t < 23.5 then
        return "🌗 75% Moon"
    elseif t >= 23.5 or t <= 0.5 then
        return "🌕 Full Moon"
    elseif t > 0.5 and t <= 4 then
        return "🌖 Waning Moon"
    else
        return "🌑 Night"
    end
end

local function IsFullMoon()
    return Lighting.ClockTime >= 23.5 or Lighting.ClockTime <= 0.5
end

local function Is75Moon()
    return Lighting.ClockTime >= 23 and Lighting.ClockTime < 23.5
end

local function ServerHop()
    local placeId = game.PlaceId
    local servers = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
    )

    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(placeId, s.id, player)
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
Main.Size = UDim2.new(0,330,0,260)
Main.Position = UDim2.new(0.5,-165,0.15,0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "🌙 MOON HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(0,170,255)

local Status = Instance.new("TextLabel", Main)
Status.Position = UDim2.new(0,0,0,45)
Status.Size = UDim2.new(1,0,0,80)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.TextWrapped = true
Status.TextColor3 = Color3.new(1,1,1)

local function Toggle(text, y, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9,0,0,34)
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

Toggle("🌕 Auto Find Full Moon", 135, function(v)
    MoonHub.AutoFull = v
end)

Toggle("🌗 Auto Find 75% Moon", 175, function(v)
    MoonHub.Auto75 = v
end)

Toggle("🔁 Auto Hop Moon", 215, function(v)
    MoonHub.AutoHop = v
end)

-- ================= LOOP =================

task.spawn(function()
    while task.wait(1) do
        local phase = GetMoonPhaseName()

        Status.Text =
            "ClockTime: "..string.format("%.2f", Lighting.ClockTime).."\n"..
            "Fase da Lua: "..phase

        if MoonHub.AutoFull and IsNight() then
            if IsFullMoon() then
                Status.Text ..= "\n\n✅ FULL MOON ENCONTRADA"
                MoonHub.AutoHop = false
            elseif MoonHub.AutoHop then
                ServerHop()
                break
            end
        end

        if MoonHub.Auto75 and IsNight() then
            if Is75Moon() then
                Status.Text ..= "\n\n🌗 75% MOON (PRÓXIMA É FULL)"
                MoonHub.AutoHop = false
            elseif MoonHub.AutoHop then
                ServerHop()
                break
            end
        end
    end
end)

print("✅ Moon Hub carregado corretamente")
