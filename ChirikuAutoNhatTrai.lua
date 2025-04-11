--===[ SETTINGS ]===--
getgenv().Team = "Pirates" -- Hoặc "Marines"

--===[ AUTO JOIN TEAM ]===--
pcall(function()
    if not game.Players.LocalPlayer.Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end
end)

--===[ NOTIFY FUNCTION ]===--
local function Notify(title, text, duration, titleColor, textColor)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text or "",
            Duration = duration or 4,
            TextColor3 = textColor or Color3.fromRGB(255,255,0),
            BackgroundColor3 = titleColor or Color3.fromRGB(0,255,0)
        })
    end)
end

--===[ GIỚI THIỆU ]===--
Notify("Auto Nhặt Trái", "By: Chiriku Roblox", 5, Color3.fromRGB(0,255,0), Color3.fromRGB(255,255,0))

--===[ RARITY TABLE ]===--
local Rarity = {
    Common = {Color = Color3.fromRGB(169,169,169), List = {"Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring", "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike"}},
    Uncommon = {Color = Color3.fromRGB(0,191,255), List = {"Flame-Flame", "Falcon-Falcon", "Ice-Ice", "Sand-Sand", "Dark-Dark", "Diamond-Diamond"}},
    Rare = {Color = Color3.fromRGB(148,0,211), List = {"Light-Light", "Rubber-Rubber", "Barrier-Barrier", "Ghost-Ghost", "Magma-Magma"}},
    Legendary = {Color = Color3.fromRGB(255,105,180), List = {"Quake-Quake", "Buddha-Buddha", "Love-Love", "Spider-Spider", "Sound-Sound", "Phoenix-Phoenix", "Portal-Portal", "Rumble-Rumble", "Pain-Pain", "Blizzard-Blizzard"}},
    Mythical = {Color = Color3.fromRGB(255,0,0), List = {"Gravity-Gravity", "Mammoth-Mammoth", "T-Rex-T-Rex", "Dough-Dough", "Shadow-Shadow", "Venom-Venom", "Control-Control", "Gas-Gas", "Spirit-Spirit", "Leopard-Leopard", "Yeti-Yeti", "Kitsune-Kitsune", "Dragon-Dragon"}}
}

local function GetRarity(fruitName)
    for rarity, data in pairs(Rarity) do
        for _, name in pairs(data.List) do
            if name == fruitName then
                return rarity, data.Color
            end
        end
    end
    return "Unknown", Color3.fromRGB(255,255,255)
end

--===[ ESP TRÁI ]===--
local function CreateESP(tool)
    if not tool:FindFirstChild("ESP") then
        local gui = Instance.new("BillboardGui", tool)
        gui.Name = "ESP"
        gui.Size = UDim2.new(0, 150, 0, 50)
        gui.AlwaysOnTop = true
        gui.StudsOffset = Vector3.new(0, 2, 0)
        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = Color3.fromRGB(255,255,0)

        game:GetService("RunService").RenderStepped:Connect(function()
            if tool and tool.Parent and tool:FindFirstChild("Handle") then
                local pos = tool.Handle.Position
                local myPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                local dist = math.floor((pos - myPos).Magnitude)
                label.Text = "[TRÁI] "..tool.Name.." ("..dist.."m)"
            end
        end)
    end
end

--===[ TÌM TRÁI ]===--
local function FindFruit()
    for _,v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") and v.Name:lower():find("fruit") then
            CreateESP(v)
            return v
        end
    end
    return nil
end

--===[ TELEPORT ]===--
local function TeleportToFruit(fruit)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if fruit and fruit:FindFirstChild("Handle") and hrp then
        hrp.CFrame = fruit.Handle.CFrame + Vector3.new(0,2,0)
    end
end

--===[ STORE FRUIT ]===--
local function Store()
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
    if tool then
        local rarity, color = GetRarity(tool.Name)
        local success = pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", tool.Name)
        end)
        Notify("["..rarity.."] Đã nhặt "..tool.Name, "", 4, color)
        return success
    end
    return false
end

--===[ SMART HOP ]===--
local Http = game:GetService("HttpService")
local TPService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer
local ServerList = {}
local function HopServer()
    local Servers = {}
    local req = syn and syn.request or http_request or request
    local data = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"}).Body
    local servers = Http:JSONDecode(data)

    for _,v in pairs(servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            table.insert(Servers, v.id)
        end
    end

    if #Servers > 0 then
        TPService:TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1, #Servers)], LocalPlayer)
    else
        warn("Không tìm thấy server phù hợp")
    end
end

--===[ MAIN LOOP ]===--
while task.wait(2) do
    local fruit = FindFruit()
    if fruit then
        TeleportToFruit(fruit)
        wait(1.2)
        firetouchinterest(fruit.Handle, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
        wait(1)
        if not Store() then HopServer() end
    else
        HopServer()
    end
end
