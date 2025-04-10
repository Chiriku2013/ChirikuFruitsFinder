getgenv().Team = "Marines" -- Hoặc "Marines"

-- Auto Join Team
pcall(function()
    if not game.Players.LocalPlayer.Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end
end)

-- Notification function
local StarterGui = game:GetService("StarterGui")
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

-- Thêm phần giới thiệu giống Blox Fruits
local function ShowIntroNotification()
    Notify("Auto Nhặt Trái", "By: Chiriku Roblox", 5, Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 0))
end

-- Rarity Table
local RarityTable = {
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

-- ESP
local function CreateESP(tool)
    if not tool:FindFirstChild("ESP") then
        local esp = Instance.new("BillboardGui", tool)
        esp.Name = "ESP"
        esp.Size = UDim2.new(0,100,0,40)
        esp.AlwaysOnTop = true
        local label = Instance.new("TextLabel", esp)
        label.Size = UDim2.new(1,0,1,0)
        label.Text = "[TRÁI] "..tool.Name
        label.TextScaled = true
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255,255,0)
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
    return nil
end

-- Dịch chuyển
local function Teleport(fruit)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if fruit and fruit:FindFirstChild("Handle") and hrp then
        hrp.CFrame = fruit.Handle.CFrame + Vector3.new(0,2,0)
    end
end

-- Cất kho
local function StoreFruit()
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
    if tool then
        local name = tool.Name
        local info = RarityTable[name] or {"Unknown", Color3.fromRGB(255,255,255)}
        local success = pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", name)
        end)
        Notify("["..info[1].."] Đã nhặt " .. name, "", 4, info[2])
        if not success then return false end
        return true
    end
    return false
end

-- Teleport nếu lỗi
local function Hop()
    Notify("Đang chuyển server...", "Không còn trái hoặc lỗi khi cất", 3)
    wait(1)
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end

-- Vòng lặp chính
while true do
    ShowIntroNotification() -- Gọi hàm giới thiệu
    wait(5) -- Hiển thị 5 giây rồi chuyển sang tìm trái

    local fruit = FindFruit()
    if fruit then
        Teleport(fruit)
        wait(1.5)
        firetouchinterest(fruit.Handle, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
        wait(1)
        if not StoreFruit() then Hop() end
    else
        wait(5)
        Hop()
    end
    wait(1)
end
