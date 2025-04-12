getgenv().Team = "Marines" -- Hoặc "Marines"

-- Tự động vào team
pcall(function()
    if not game.Players.LocalPlayer.Team then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
    end
end)

-- Gửi thông báo kiểu Blox Fruits
local StarterGui = game:GetService("StarterGui")
local function Notify(title, text, duration, titleColor, textColor)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text or "",
            Duration = duration or 5,
            TextColor3 = textColor or Color3.fromRGB(255,255,0),
            BackgroundColor3 = titleColor or Color3.fromRGB(0,255,0)
        })
    end)
end

-- Gửi thông báo mở đầu
Notify("Auto Nhặt Trái", "By: Chiriku Roblox", 5, Color3.fromRGB(0,255,0), Color3.fromRGB(255,255,0))

-- Rarity + màu trái
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

-- Tạo ESP + khoảng cách
local function ESP(tool)
    if not tool:FindFirstChild("ESP") then
        local gui = Instance.new("BillboardGui", tool)
        gui.Name = "ESP"
        gui.Size = UDim2.new(0, 100, 0, 40)
        gui.AlwaysOnTop = true
        gui.MaxDistance = 1e9 -- max distance
        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = Color3.fromRGB(255,255,0)
        local dist = math.floor((tool.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        label.Text = "[TRÁI] "..tool.Name.." | "..dist.."m"
    end
end

-- Tìm trái
local function GetFruit()
    for _,v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") and string.find(v.Name:lower(), "fruit") then
            ESP(v.Handle)
            return v
        end
    end
end

-- Dịch chuyển tới trái
local function TeleportToFruit(f)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if f and f:FindFirstChild("Handle") and hrp then
        hrp.CFrame = f.Handle.CFrame + Vector3.new(0,2,0)
    end
end

-- Lưu trái vào kho
local function Store()
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
    if tool then
        local name = tool.Name
        local info = Rarity[name] or {"Unknown", Color3.fromRGB(255,255,255)}
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", name)
        end)
        Notify("["..info[1].."] Đã nhặt " .. name, "", 4, info[2])
        return true
    end
end

-- Nếu lỗi thì hop random server
local function HopServer()
    local ts = game:GetService("TeleportService")
    ts:Teleport(game.PlaceId)
end

-- Nếu bị kick thì tự rejoin
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Failed then
        wait(2)
        HopServer()
    end
end)

-- Main loop
while wait(2) do
    local fruit = GetFruit()
    if fruit then
        TeleportToFruit(fruit)
        wait(1)
        firetouchinterest(fruit.Handle, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
        wait(1)
        if not Store() then HopServer() end
    else
        HopServer()
    end
end
