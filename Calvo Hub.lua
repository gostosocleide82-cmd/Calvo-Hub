--// Moon Hub - Stable Version (Delta Compatible)
repeat task.wait() until game:IsLoaded()
task.wait(2)

-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- ================= STATE =================
getgenv().MoonHub = {
    AutoFull = false,
    Auto75 = false,
    AutoHop = false,
    Minimized = false,
    Hopping = false
}

-- ================= MOON LOGIC =================
local function GetMoonPhase()
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

-- ================= SERVER HOP =================
local function ServerHop()
    if MoonHub.Hopping then return end
    MoonHub.Hopping = true

    local servers = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
        )
    )

    for _,s in ipairs(servers.data) do
        if s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
            return
        end
    end

    MoonHub.Hopping = false
end

-- ================= UI =================
pcall(function()
    CoreGui:FindFirstChild("MoonHubUI"):Destroy()
end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "MoonHubUI"
gui.ResetOnSpawn = false

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0,330,0,270)
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

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-40,0,5)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
MinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", MinBtn)

local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0,0,0,45)
Content.Size = UDim2.new(1,0,1,-45)
Content.BackgroundTransparency = 1

local Status = Instance.new("TextLabel", Content)
Status.Size = UDim2.new(1,0,0,70)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.TextWrapped = true
Status.TextColor3 = Color3.new(1,1,1)

local function CreateToggle(text, y, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(0.9,0,0,34)
    btn.Position = UDim2.new(0.05,0,0,y)
    btn.Text = text.." : OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text.." : "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,140,255) or Color3.fromRGB(45,45,45)
        callback(state)
    end)
end

CreateToggle("🌕 Auto Find Full Moon", 80, function(v)
    MoonHub.AutoFull = v
end)

CreateToggle("🌗 Auto Find 75% Moon", 120, function(v)
    MoonHub.Auto75 = v
end)

CreateToggle("🔁 Auto Hop Moon", 160, function(v)
    MoonHub.AutoHop = v
end)

-- ================= MINIMIZAR =================
MinBtn.MouseButton1Click:Connect(function()
    MoonHub.Minimized = not MoonHub.Minimized
    Content.Visible = not MoonHub.Minimized
    Main.Size = MoonHub.Minimized and UDim2.new(0,330,0,45) or UDim2.new(0,330,0,270)
    MinBtn.Text = MoonHub.Minimized and "+" or "-"
end)

-- ================= LOOP =================
task.spawn(function()
    while task.wait(1) do
        local phase = GetMoonPhase()

        Status.Text =
            "ClockTime: "..string.format("%.2f", Lighting.ClockTime).."\n"..
            "Fase da Lua: "..phase

        if MoonHub.AutoFull and IsFullMoon() then
            Status.Text ..= "\n\n✅ FULL MOON ENCONTRADA"
        elseif MoonHub.Auto75 and Is75Moon() then
            Status.Text ..= "\n\n🌗 75% MOON (PRÓXIMA É FULL)"
        elseif MoonHub.AutoHop then
            ServerHop()
        end
    end
end)

print("✅ Moon Hub carregado com sucesso")
