-- Chọn team auto (Pirates hoặc Marines)
getgenv().Team = "Marines"

-- Auto vào team khi mới vào game
pcall(function()
    if not game.Players.LocalPlayer.Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end
end)

-- Các service cần dùng
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TPService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local Hopped = {} -- Dùng để lưu các server đã ghé, tránh trùng

-- Hàm hiển thị thông báo (SendNotification)
local function Notify(title, text, duration, titleColor, textColor)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text or "",
            Duration = duration or 4,
            TextColor3 = textColor or Color3.fromRGB(255,255,0),
            BackgroundColor3 = titleColor or Color3.fromRGB(0,255,0)
        })
    end)
end

-- Thông báo khi bắt đầu script
Notify("Auto Nhặt Trái", "By: Chiriku Roblox", 5, Color3.fromRGB(0,255,0), Color3.fromRGB(255,255,0))

-- Bảng phân loại trái theo độ hiếm + màu
local RarityTable = {
    -- Common (xám)
    ["Rocket-Rocket"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Spin-Spin"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Blade-Blade"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Spring-Spring"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Bomb-Bomb"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Smoke-Smoke"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Spike-Spike"] = {"Common", Color3.fromRGB(169,169,169)},

    -- Uncommon (xanh dương)
    ["Flame-Flame"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Falcon-Falcon"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Ice-Ice"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Sand-Sand"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Dark-Dark"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Diamond-Diamond"] = {"Uncommon", Color3.fromRGB(0,191,255)},

    -- Rare (tím)
    ["Light-Light"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Rubber-Rubber"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Barrier-Barrier"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Ghost-Ghost"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Magma-Magma"] = {"Rare", Color3.fromRGB(148,0,211)},

    -- Legendary (hồng)
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

    -- Mythical (đỏ)
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

-- Tạo ESP trên trái + hiển thị khoảng cách
local function CreateESP(tool)
    if not tool:FindFirstChild("ESP") then
        local esp = Instance.new("BillboardGui", tool)
        esp.Name = "ESP"
        esp.Size = UDim2.new(0,150,0,40)
        esp.AlwaysOnTop = true
        esp.MaxDistance = 100000

        local label = Instance.new("TextLabel", esp)
        label.Size = UDim2.new(1,0,1,0)
        label.TextScaled = true
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = Color3.fromRGB(255,255,0)

        task.spawn(function()
            while esp and esp.Parent and tool:IsDescendantOf(game.Workspace) do
                local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = math.floor((tool.Handle.Position - hrp.Position).Magnitude)
                    label.Text = "[TRÁI] "..tool.Name.." | "..dist.."m"
                end
                task.wait(0.5)
            end
        end)
    end
end

-- Tìm trái trong map
local function FindFruit()
    for _,v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") and v.Name:lower():find("fruit") then
            CreateESP(v)
            return v
        end
    end
end

-- Dịch chuyển đến trái
local function Teleport(fruit)
    local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and fruit and fruit:FindFirstChild("Handle") then
        hrp.CFrame = fruit.Handle.CFrame + Vector3.new(0,2,0)
    end
end

-- Lưu trái vào storage (StoreFruit)
local function StoreFruit()
    local tool = Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
    if tool then
        local name = tool.Name
        local info = RarityTable[name] or {"Unknown", Color3.fromRGB(255,255,255)}
        local success = pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", name)
        end)
        Notify("["..info[1].."] Đã nhặt " .. name, "", 4, info[2])
        return success
    end
end

-- Smart hop: Tìm server khác chưa vào, và có slot trống
local function SmartHopWithFruitOnly()
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _,v in pairs(Servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId and not table.find(Hopped, v.id) then
            table.insert(Hopped, v.id)
            TPService:TeleportToPlaceInstance(game.PlaceId, v.id)
            break
        end
    end
end

-- Auto rejoin khi bị kick hoặc lỗi teleport
Players.LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        wait(2)
        TPService:Teleport(game.PlaceId)
    end
end)

-- Vòng lặp chính: Tìm trái → teleport → nhặt → store → hop
while true do
    local fruit = FindFruit()
    if fruit then
        Teleport(fruit)
        wait(1.5)
        firetouchinterest(fruit.Handle, Players.LocalPlayer.Character.HumanoidRootPart, 0)
        wait(1)
        if not StoreFruit() then SmartHopWithFruitOnly() end
    else
        SmartHopWithFruitOnly()
    end
end
