-- Auto Nhặt Trái FULL | By: Chiriku Roblox
-- Hỗ trợ: Solara v2.22, Delta, PC & Mobile
-- Tính năng: ESP nhìn xa + khoảng cách, tự nhặt + cất trái, smart hop, auto rejoin, auto team

-- // Cấu hình
getgenv().Team = "Marines" -- Hoặc "Marines"

-- // Auto Join Team
pcall(function()
    if not game.Players.LocalPlayer.Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end
end)

-- // Notification giống Blox Fruits
local StarterGui = game:GetService("StarterGui")
local function Notify(title, text, duration, titleColor, textColor)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "",
            Text = text or "",
            Duration = duration or 4,
            TextColor3 = textColor or Color3.fromRGB(255,255,0),
            BackgroundColor3 = titleColor or Color3.fromRGB(0,255,0)
        })
    end)
end

Notify("Auto Nhặt Trái", "By: Chiriku Roblox", 5)

-- // Bảng độ hiếm trái
local Rarity = {
    -- Common (Xám)
    ["Rocket-Rocket"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Spin-Spin"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Blade-Blade"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Spring-Spring"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Bomb-Bomb"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Smoke-Smoke"] = {"Common", Color3.fromRGB(169,169,169)},
    ["Spike-Spike"] = {"Common", Color3.fromRGB(169,169,169)},

    -- Uncommon (Xanh dương)
    ["Flame-Flame"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Falcon-Falcon"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Ice-Ice"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Sand-Sand"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Dark-Dark"] = {"Uncommon", Color3.fromRGB(0,191,255)},
    ["Diamond-Diamond"] = {"Uncommon", Color3.fromRGB(0,191,255)},

    -- Rare (Tím)
    ["Light-Light"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Rubber-Rubber"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Barrier-Barrier"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Ghost-Ghost"] = {"Rare", Color3.fromRGB(148,0,211)},
    ["Magma-Magma"] = {"Rare", Color3.fromRGB(148,0,211)},

    -- Legendary (Hồng)
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

    -- Mythical (Đỏ)
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

-- // Smart Hop (chống trùng server)
local Hopped = {}
local function SmartHop()
    local Http = game:GetService("HttpService")
    local Servers = game:GetService("HttpService"):JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    )

    for _, v in pairs(Servers.data) do
        if type(v) == "table" and v.playing < v.maxPlayers and v.id ~= game.JobId and not Hopped[v.id] then
            Hopped[v.id] = true
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id)
            break
        end
    end
end

-- // Tạo ESP nhìn xa và có khoảng cách
local function CreateESP(fruit)
    if not fruit:FindFirstChild("ESP") then
        local dist = math.floor((fruit.Handle.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        local esp = Instance.new("BillboardGui", fruit)
        esp.Name = "ESP"
        esp.Size = UDim2.new(0,100,0,40)
        esp.AlwaysOnTop = true
        local label = Instance.new("TextLabel", esp)
        label.Size = UDim2.new(1,0,1,0)
        label.Text = "[TRÁI] "..fruit.Name.." ("..dist.."m)"
        label.TextScaled = true
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255,255,0)
        label.Font = Enum.Font.GothamBold
    end
end

-- // Tìm trái
local function FindFruit()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") and string.find(v.Name:lower(), "fruit") then
            CreateESP(v)
            return v
        end
    end
    return nil
end

-- // Teleport tới trái
local function TeleportToFruit(fruit)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if fruit and fruit:FindFirstChild("Handle") and hrp then
        hrp.CFrame = fruit.Handle.CFrame + Vector3.new(0, 2, 0)
    end
end

-- // Cất kho trái
local function StoreFruit()
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
    if tool then
        local name = tool.Name
        local info = Rarity[name] or {"Unknown", Color3.fromRGB(255,255,255)}
        local success = pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", name)
        end)
        Notify("["..info[1].."] Đã nhặt " .. name, "", 4, info[2])
        if not success then return false end
        return true
    end
    return false
end

-- // Auto rejoin nếu bị kick
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" then
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
end)

-- // Vòng lặp chính
while true do
    local fruit = FindFruit()
    if fruit then
        TeleportToFruit(fruit)
        wait(1.5)
        firetouchinterest(fruit.Handle, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
        wait(1)
        if not StoreFruit() then SmartHop() end
    else
        SmartHop()
    end
    wait(1)
end
