repeat wait() until game:IsLoaded()

-- Cấu hình
getgenv().Team = "Marines" -- Hoặc "Marines"

-- Auto vào team
pcall(function()
    if not game.Players.LocalPlayer.Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end
end)

-- Thông báo
local StarterGui = game:GetService("StarterGui")
local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 4
        })
    end)
end

-- Giới thiệu
Notify("Auto Nhặt Trái", "By: Chiriku Roblox", 5)

-- Bảng độ hiếm + màu
local FruitRarity = {
    Common = {"Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring", "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike"},
    Uncommon = {"Flame-Flame", "Falcon-Falcon", "Ice-Ice", "Sand-Sand", "Dark-Dark", "Diamond-Diamond"},
    Rare = {"Light-Light", "Rubber-Rubber", "Barrier-Barrier", "Ghost-Ghost", "Magma-Magma"},
    Legendary = {"Quake-Quake", "Buddha-Buddha", "Love-Love", "Spider-Spider", "Sound-Sound", "Phoenix-Phoenix", "Portal-Portal", "Rumble-Rumble", "Pain-Pain", "Blizzard-Blizzard"},
    Mythical = {"Gravity-Gravity", "Mammoth-Mammoth", "T-Rex-T-Rex", "Dough-Dough", "Shadow-Shadow", "Venom-Venom", "Control-Control", "Gas-Gas", "Spirit-Spirit", "Leopard-Leopard", "Yeti-Yeti", "Kitsune-Kitsune", "Dragon-Dragon"}
}
local ColorMap = {
    Common = Color3.fromRGB(169,169,169),
    Uncommon = Color3.fromRGB(0,191,255),
    Rare = Color3.fromRGB(148,0,211),
    Legendary = Color3.fromRGB(255,105,180),
    Mythical = Color3.fromRGB(255,0,0)
}

-- Tìm độ hiếm
local function GetRarity(name)
    for rarity, list in pairs(FruitRarity) do
        for _, fruit in pairs(list) do
            if fruit == name then
                return rarity, ColorMap[rarity]
            end
        end
    end
    return "Unknown", Color3.fromRGB(255,255,255)
end

-- ESP trái
local function CreateESP(tool)
    if not tool:FindFirstChild("ESP") then
        local rarity, color = GetRarity(tool.Name)
        local gui = Instance.new("BillboardGui", tool)
        gui.Name = "ESP"
        gui.Size = UDim2.new(0,100,0,40)
        gui.AlwaysOnTop = true
        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1,0,1,0)
        label.TextScaled = true
        label.Text = "[TRÁI] "..tool.Name.." - "..rarity
        label.BackgroundTransparency = 1
        label.TextColor3 = color
        label.Font = Enum.Font.GothamBold
    end
end

-- Tìm trái
local function FindFruit()
    for _,v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") and string.find(v.Name:lower(), "fruit") then
            CreateESP(v)
            return v
        end
    end
end

-- Store trái
local function StoreFruit(fruitName)
    local suc, res = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruitName)
    end)
    if suc then
        Notify("Đã nhặt trái", fruitName.." đã được gửi vào kho", 5)
        return true
    else
        Notify("Đã nhặt trái", fruitName.." không thể gửi kho, đang chuyển server...", 4)
        wait(1.5)
        HopServer()
        return false
    end
end

-- Smart hop với tối ưu
function HopServer()
    local HttpService = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local PlaceID = game.PlaceId
    local function GetServers(cursor)
        local url = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=2&limit=100"
        if cursor then url = url.."&cursor="..cursor end
        local response = game:HttpGet(url)
        return HttpService:JSONDecode(response)
    end

    local function TeleportToServer(serverId)
        TPS:TeleportToPlaceInstance(PlaceID, serverId, game.Players.LocalPlayer)
    end

    local servers = {}
    local data, cursor = GetServers()
    while data do
        for _, server in pairs(data.data) do
            -- Lọc server không đầy người (ít người chơi)
            if server.playing < server.maxPlayers then
                table.insert(servers, server.id)
            end
        end
        if data.nextPageCursor then
            data = GetServers(data.nextPageCursor)
        else
            break
        end
    end

    -- Tránh server đã vào trước đó (nếu có)
    local visitedServers = {}  -- Lưu các server đã vào
    local function IsServerVisited(serverId)
        for _, v in pairs(visitedServers) do
            if v == serverId then
                return true
            end
        end
        return false
    end

    -- Chọn server chưa vào và ít người chơi nhất
    for _, id in pairs(servers) do
        if not IsServerVisited(id) then
            TeleportToServer(id)
            table.insert(visitedServers, id)
            wait(5)
        end
    end
end

-- Auto check & nhặt
while task.wait(3) do
    local fruit = FindFruit()
    if fruit then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = fruit.Handle.CFrame + Vector3.new(0,2,0)
            wait(1)
            firetouchinterest(char.HumanoidRootPart, fruit.Handle, 0)
            wait(0.5)
            firetouchinterest(char.HumanoidRootPart, fruit.Handle, 1)
            StoreFruit(fruit.Name)
        end
    else
        HopServer()
    end
end
