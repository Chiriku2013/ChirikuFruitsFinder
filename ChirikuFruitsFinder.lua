local placeId = game.PlaceId
local worldMap = {
    [2753915549] = true,
    [4442272183] = true,
    [7449423635] = true
}

if worldMap[placeId] then
    -- Xác định World
    if placeId == 2753915549 then
        World1 = true
    elseif placeId == 4442272183 then
        World2 = true
    elseif placeId == 7449423635 then
        World3 = true
    end

    -- Set UI text/logo - BFInfoUi
    getgenv().BFInfoTopText = "Chiriku Roblox Hub Fruits Finder"
    getgenv().BFInfoLogoId = "rbxassetid://119836305527028"

    -- Load UI song song - BFInfoUi
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Chiriku2013/BFInfoUi/refs/heads/main/BFInfoUi.lua"))()
    end)
    
--// Cấu hình chọn team
getgenv().Team = "Pirates" -- hoặc "Marines"

--// Auto vào đội
pcall(function()
    if not game.Players.LocalPlayer.Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end
end)

--// Notification (thông báo giống Blox Fruits)
local function Notify(title, text, dur, titleColor, textColor)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text or "",
            Duration = dur or 4,
            TextColor3 = textColor or Color3.fromRGB(255,255,0),
            BackgroundColor3 = titleColor or Color3.fromRGB(0,255,0)
        })
    end)
end

--// Thông báo giới thiệu
Notify("Fruits Finder", "By: Chiriku Roblox", 5, Color3.fromRGB(0,255,0), Color3.fromRGB(255,255,0))

--// Bảng độ hiếm
local Rarity = {
    ["Rocket-Rocket"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Spin-Spin"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Blade-Blade"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Spring-Spring"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Bomb-Bomb"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Smoke-Smoke"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Spike-Spike"] = {"Common", Color3.fromRGB(169,169,169)},

    ["Flame-Flame"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Falcon-Falcon"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Ice-Ice"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Sand-Sand"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Dark-Dark"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Diamond-Diamond"] = {"Uncommon", Color3.fromRGB(0,191,255)},

    ["Light-Light"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Rubber-Rubber"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Barrier-Barrier"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Ghost-Ghost"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Magma-Magma"] = {"Rare", Color3.fromRGB(148,0,211)},

    ["Quake-Quake"] = {"Legendary", Color3.fromRGB(255,105,180)},
    ["Buddha-Buddha"] = {"Legendary", Color3.fromRGB(255,105,180)},
    ["Love-Love"] = {"Legendary", Color3.fromRGB(255,105,180)},
    ["Spider-Spider"] = {"Legendary", Color3.fromRGB(255,105,180)},
    ["Sound-Sound"] = {"Legendary", Color3.fromRGB(255,105,180)},
    ["Phoenix-Phoenix"] = {"Legendary", Color3.fromRGB(255,105,180)},
    ["Portal-Portal"] = {"Legendary", Color3.fromRGB(255,105,180)},
    ["Rumble-Rumble"] = {"Legendary", Color3.fromRGB(255,105,180)},
    ["Pain-Pain"] = {"Legendary", Color3.fromRGB(255,105,180)},
    ["Blizzard-Blizzard"] = {"Legendary", Color3.fromRGB(255,105,180)},

    ["Gravity-Gravity"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Mammoth-Mammoth"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["T-Rex-T-Rex"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Dough-Dough"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Shadow-Shadow"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Venom-Venom"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Control-Control"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Gas-Gas"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Spirit-Spirit"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Leopard-Leopard"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Yeti-Yeti"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Kitsune-Kitsune"] = {"Mythical", Color3.fromRGB(255,0,0)},
    ["Dragon-Dragon"] = {"Mythical", Color3.fromRGB(255,0,0)}
}

--// Tạo ESP
local function CreateESP(fruit)
    if not fruit:FindFirstChild("ESP") then
        local dist = math.floor((fruit.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        local gui = Instance.new("BillboardGui", fruit)
        gui.Name = "ESP"
        gui.AlwaysOnTop = true
        gui.Size = UDim2.new(0,100,0,40)
        gui.StudsOffset = Vector3.new(0,2,0)

        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1,0,1,0)
        label.TextScaled = true
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = Color3.fromRGB(255,255,0)
        label.Text = "[TRÁI] "..fruit.Parent.Name.." | "..dist.."m"
    end
end

--// Tìm trái
local function FindFruit()
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") and v.Name:lower():find("fruit") then
            CreateESP(v.Handle)
            return v
        end
    end
end

--// Teleport đến trái
local function Teleport(fruit)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if fruit and hrp then
        hrp.CFrame = fruit.Handle.CFrame + Vector3.new(0,2,0)
    end
end

--// Cất trái
local function StoreFruit()
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
    if tool then
        local name = tool.Name
        local info = Rarity[name] or {"Fruits", Color3.fromRGB(255,255,255)}
        local ok = pcall(function()
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", name)
        end)
        Notify("["..info[1].."] Đã nhặt " .. name, "", 3, info[2])
        return ok
    end
end

--// Smart Hop Server
local function SmartHop()
    local HttpService = game:GetService("HttpService")
    local TPService = game:GetService("TeleportService")
    local Servers = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local data = HttpService:JSONDecode(Servers)
    for _,v in pairs(data.data) do
        if type(v) == "table" and v.playing < v.maxPlayers and v.id ~= game.JobId then
            TPService:TeleportToPlaceInstance(game.PlaceId, v.id)
            break
        end
    end
end

--// Auto Rejoin nếu bị kick
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Failed then
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
end)

--// Vòng lặp chính
while task.wait(5) do
    local fruit = FindFruit()
    if fruit then
        Teleport(fruit)
        wait(1.5)
        firetouchinterest(fruit.Handle, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
        wait(5)
        if not StoreFruit() then SmartHop() end
    else
        SmartHop()
    end
end

else
    game.Players.LocalPlayer:Kick("This script is not supported in this game, please try again with Blox Fruits!")
end
