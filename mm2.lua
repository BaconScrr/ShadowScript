if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Функция для воспроизведения звука при нажатии
local function playButtonSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://140910211"
    sound.Volume = 1.5
    sound.Parent = SoundService
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShadowUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(230, 57, 51)
UIStroke.Thickness = 1.8
UIStroke.Transparency = 0.05
UIStroke.Parent = MainFrame

-- Заголовок
local TitleContainer = Instance.new("Frame")
TitleContainer.Parent = MainFrame
TitleContainer.BackgroundTransparency = 1
TitleContainer.Position = UDim2.new(0.04, 0, 0.05, 0)
TitleContainer.Size = UDim2.new(0.9, 0, 0, 25)

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Parent = TitleContainer
TitleIcon.Size = UDim2.new(0, 25, 0, 25)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Image = "rbxthumb://type=Asset&id=93388705336185&w=420&h=420"
TitleIcon.ImageColor3 = Color3.fromRGB(230, 57, 51)

local Title = Instance.new("TextLabel")
Title.Parent = TitleContainer
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 30, 0, 0)
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Shadow Script | Murder Mystery 2"
Title.TextColor3 = Color3.fromRGB(230, 57, 51)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local FooterLine = Instance.new("Frame")
FooterLine.Parent = MainFrame
FooterLine.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
FooterLine.BorderSizePixel = 0
FooterLine.Size = UDim2.new(0.92, 0, 0, 1)
FooterLine.Position = UDim2.new(0.04, 0, 0.155, 0)

-------------------------------------------------------------
-- ВКЛАДКИ
-------------------------------------------------------------

local Tabs = {"Main", "Visual", "Combat", "Emotes", "Teleport", "Auto Farm", "Misc"}
local TabButtons = {}
local TabPages = {}

-- Контейнер для страниц с скроллом
local PageScrollFrame = Instance.new("ScrollingFrame")
PageScrollFrame.Parent = MainFrame
PageScrollFrame.BackgroundTransparency = 1
PageScrollFrame.Position = UDim2.new(0.04, 0, 0.19, 0)
PageScrollFrame.Size = UDim2.new(0.6, 0, 0.75, 0)
PageScrollFrame.ScrollBarThickness = 4
PageScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(230, 57, 51)
PageScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PageScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Контейнер для вкладок с скроллом
local TabsScrollFrame = Instance.new("ScrollingFrame")
TabsScrollFrame.Parent = MainFrame
TabsScrollFrame.BackgroundTransparency = 1
TabsScrollFrame.Position = UDim2.new(0.70, 0, 0.19, 0)
TabsScrollFrame.Size = UDim2.new(0.27, 0, 0.75, 0)
TabsScrollFrame.ScrollBarThickness = 4
TabsScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(230, 57, 51)
TabsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
TabsScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local TabsContainer = Instance.new("Frame")
TabsContainer.Parent = TabsScrollFrame
TabsContainer.BackgroundTransparency = 1
TabsContainer.Size = UDim2.new(1, 0, 0, 0)
TabsContainer.AutomaticSize = Enum.AutomaticSize.Y

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabsContainer
TabList.Padding = UDim.new(0, 8)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

local function UpdateButtonVisual(button, isActive)
    if isActive then
        button.BackgroundTransparency = 0
        button.BackgroundColor3 = Color3.fromRGB(20,20,20)
        if button:FindFirstChild("ButtonStroke") then
            button.ButtonStroke.Thickness = 3
            button.ButtonStroke.Color = Color3.fromRGB(230,57,51)
            button.ButtonStroke.Transparency = 0
        end
    else
        button.BackgroundTransparency = 0.1
        button.BackgroundColor3 = Color3.fromRGB(15,15,15)
        if button:FindFirstChild("ButtonStroke") then
            button.ButtonStroke.Thickness = 2
            button.ButtonStroke.Color = Color3.fromRGB(200,50,47)
            button.ButtonStroke.Transparency = 0
        end
    end
end

for i, tabName in ipairs(Tabs) do
    
    local Button = Instance.new("TextButton")
    Button.Name = tabName .. "_TabButton"
    Button.Parent = TabsContainer
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Button.BackgroundTransparency = 0.1
    Button.BorderSizePixel = 0
    Button.Text = tabName
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.RichText = false
    Button.AutoButtonColor = false
    Button.LayoutOrder = i

    -- Добавляем звук при нажатии на кнопку вкладки
    Button.MouseButton1Click:Connect(function()
        playButtonSound()
    end)

    -- Добавляем иконки для всех вкладок
    if tabName == "Main" then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = Button
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxthumb://type=Asset&id=72808987642452&w=420&h=420"
    elseif tabName == "Visual" then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = Button
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxthumb://type=Asset&id=134788157396683&w=420&h=420"
    elseif tabName == "Combat" then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = Button
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxthumb://type=Asset&id=125724093327848&w=420&h=420"
    elseif tabName == "Emotes" then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = Button
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxthumb://type=Asset&id=133473827960783&w=420&h=420"
    elseif tabName == "Teleport" then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = Button
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxthumb://type=Asset&id=115511057783647&w=420&h=420"
    elseif tabName == "Auto Farm" then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = Button
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxthumb://type=Asset&id=114528728360623&w=420&h=420"
    elseif tabName == "Misc" then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Parent = Button
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxthumb://type=Asset&id=118821455550069&w=420&h=420"
    end

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 15)
    BC.Parent = Button

    local BS = Instance.new("UIStroke")
    BS.Name = "ButtonStroke"
    BS.Parent = Button
    BS.Color = Color3.fromRGB(200,50,47)
    BS.Thickness = 2
    BS.Transparency = 0
    BS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Page = Instance.new("Frame")
    Page.Parent = PageScrollFrame
    Page.Size = UDim2.new(1, 0, 0, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.AutomaticSize = Enum.AutomaticSize.Y

    TabButtons[tabName] = Button
    TabPages[tabName] = Page
end

local function SwitchTab(tab)
    for name, page in pairs(TabPages) do
        page.Visible = false
    end
    for name, btn in pairs(TabButtons) do
        UpdateButtonVisual(btn, false)
    end
    if TabPages[tab] then
        TabPages[tab].Visible = true
    end
    if TabButtons[tab] then
        UpdateButtonVisual(TabButtons[tab], true)
    end
end

SwitchTab("Main")

for tabName, button in pairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
    end)
    button.MouseEnter:Connect(function()
        if TabPages[tabName] and not TabPages[tabName].Visible then
            button.BackgroundTransparency = 0
            button.BackgroundColor3 = Color3.fromRGB(18,18,18)
        end
    end)
    button.MouseLeave:Connect(function()
        if TabPages[tabName] and not TabPages[tabName].Visible then
            button.BackgroundTransparency = 0.1
            button.BackgroundColor3 = Color3.fromRGB(15,15,15)
        end
    end
end

-------------------------------------------------------------
-- ПРОФИЛЬ ИГРОКА
-------------------------------------------------------------

local MainPage = TabPages["Main"]

local ProfileContainer = Instance.new("Frame")
ProfileContainer.Parent = MainPage
ProfileContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
ProfileContainer.BackgroundTransparency = 0.1
ProfileContainer.Size = UDim2.new(1, -10, 0, 120)
ProfileContainer.Position = UDim2.new(0, 0, 0, 40)

local PC_Corner = Instance.new("UICorner")
PC_Corner.CornerRadius = UDim.new(0, 10)
PC_Corner.Parent = ProfileContainer

local PC_Stroke = Instance.new("UIStroke")
PC_Stroke.Parent = ProfileContainer
PC_Stroke.Color = Color3.fromRGB(230,57,51)
PC_Stroke.Thickness = 1.8

local Avatar = Instance.new("ImageLabel")
Avatar.Parent = ProfileContainer
Avatar.BackgroundTransparency = 1
Avatar.Size = UDim2.new(0, 90, 0, 90)
Avatar.Position = UDim2.new(0, 10, 0, 15)
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=420&h=420"

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 8)
AvatarCorner.Parent = Avatar

local Info = Instance.new("Frame")
Info.Parent = ProfileContainer
Info.Size = UDim2.new(1, -120, 1, -20)
Info.Position = UDim2.new(0, 110, 0, 10)
Info.BackgroundTransparency = 1

local function NewInfo(name, value, order)
    local label = Instance.new("TextLabel")
    label.Parent = Info
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, order * 22)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Text = name .. ": " .. value
end

local executor = "Unknown"
pcall(function()
    if identifyexecutor and type(identifyexecutor) == "function" then
        executor = identifyexecutor()
    elseif getexecutorname and type(getexecutorname) == "function" then
        executor = getexecutorname()
    elseif syn then
        executor = "Synapse X"
    elseif PROTOSMASHER_LOADED then
        executor = "ProtoSmasher"
    elseif KRNL_LOADED then
        executor = "Krnl"
    end
end)

local robloxVersion = "Unknown"
pcall(function()
    robloxVersion = tostring(version())
end)

NewInfo("Username", Player.Name, 0)
NewInfo("Display Name", Player.DisplayName, 1)
NewInfo("Roblox Version", robloxVersion, 2)
NewInfo("Executor", executor, 3)

-------------------------------------------------------------
-- УЛУЧШЕННЫЙ АВТОФАРМ
-------------------------------------------------------------

local AutoFarmPage = TabPages["Auto Farm"]

-- Заголовок Auto Farm
local AutoFarmLabel = Instance.new("TextLabel")
AutoFarmLabel.Parent = AutoFarmPage
AutoFarmLabel.Size = UDim2.new(1, 0, 0, 30)
AutoFarmLabel.BackgroundTransparency = 1
AutoFarmLabel.Text = "Advanced Auto Farm"
AutoFarmLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmLabel.Font = Enum.Font.GothamBold
AutoFarmLabel.TextSize = 18

-- Система уведомлений
local function SendNotification(message)
    print("[Shadow Script] " .. message)
    
    -- Создаем уведомление в углу экрана
    local notification = Instance.new("TextLabel")
    notification.Parent = ScreenGui
    notification.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notification.BackgroundTransparency = 0.1
    notification.Text = message
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.Font = Enum.Font.Gotham
    notification.TextSize = 14
    notification.Size = UDim2.new(0, 300, 0, 40)
    notification.Position = UDim2.new(1, -320, 1, -50)
    notification.ZIndex = 100
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(230, 57, 51)
    stroke.Thickness = 2
    stroke.Parent = notification
    
    -- Анимация появления и исчезновения
    notification:TweenPosition(UDim2.new(1, -320, 1, -120), "Out", "Quad", 0.3)
    task.wait(3)
    notification:TweenPosition(UDim2.new(1, -320, 1, -50), "Out", "Quad", 0.3)
    task.wait(0.3)
    notification:Destroy()
end

-- Конфигурация автофарма
local ThunderHubAutoFarm = {
    Enabled = false,
    Running = false,
    Paused = false,
    
    -- Настройки
    MoveSpeed = 22,
    SafeHeight = -4,
    SearchRadius = 150,
    CollectionDelay = 100,
    
    -- Стратегия
    Strategy = "All",
    CoinPriority = "Closest",
    AvoidPlayers = true,
    
    -- Управление раундами
    EndRoundIfDead = false,
    EndRoundAction = "None",
    EndRoundTarget = "Murderer",
    
    -- Действия после фарма
    ExecuteAfterFarm = true,
    AfterFarmAction = "Continue",
    AfterFarmDelay = 2,
    
    -- Состояние
    FullBag = false,
    RoundActive = false,
    RoundEnded = true,
    CoinsCollected = 0,
    StartTime = 0,
    
    -- Производительность
    Disable3DRender = false,
    OriginalRenderQuality = 10,
    FPSBoost = 0,
    
    -- Безопасность
    SafetyMode = true,
    AntiCheatBypass = true,
    MaxSpeed = 24,
    MinSpeed = 16,
    
    -- Системные
    Threads = {},
    Connections = {},
    CurrentVelocity = nil,
    CurrentTween = nil,
    LastCoinTime = 0,
    
    -- UI элементы
    Elements = {}
}

-- Функции автофарма
local function FindAllCoins()
    local coins = {}
    
    for _, mapPart in pairs(Workspace:GetChildren()) do
        if mapPart:IsA("Model") and mapPart:FindFirstChild("CoinContainer") then
            local coinContainer = mapPart.CoinContainer
            
            for _, coin in pairs(coinContainer:GetChildren()) do
                if coin.Name == "Coin_Server" and not coin:FindFirstChild("CollectedCoin") then
                    if coin:FindFirstChild("TouchInterest") then
                        table.insert(coins, {
                            Coin = coin,
                            Position = coin.Position,
                            Map = mapPart.Name,
                            Value = 1,
                            Distance = 0
                        })
                    end
                end
            end
        end
    end
    
    return coins
end

local function FindBestCoin()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local playerPos = character.HumanoidRootPart.Position
    local allCoins = FindAllCoins()
    
    if #allCoins == 0 then
        return nil
    end
    
    for _, coinData in pairs(allCoins) do
        coinData.Distance = (playerPos - coinData.Position).Magnitude
    end
    
    local filteredCoins = {}
    for _, coinData in pairs(allCoins) do
        if coinData.Distance <= ThunderHubAutoFarm.SearchRadius then
            table.insert(filteredCoins, coinData)
        end
    end
    
    if #filteredCoins == 0 then
        table.sort(allCoins, function(a, b)
            return a.Distance < b.Distance
        end)
        return allCoins[1].Coin
    end
    
    if ThunderHubAutoFarm.CoinPriority == "Closest" then
        table.sort(filteredCoins, function(a, b)
            return a.Distance < b.Distance
        end)
        return filteredCoins[1].Coin
    elseif ThunderHubAutoFarm.CoinPriority == "HighestValue" then
        table.sort(filteredCoins, function(a, b)
            local scoreA = a.Value / (a.Distance + 1)
            local scoreB = b.Value / (b.Distance + 1)
            return scoreA > scoreB
        end)
        return filteredCoins[1].Coin
    elseif ThunderHubAutoFarm.CoinPriority == "Random" then
        return filteredCoins[math.random(1, #filteredCoins)].Coin
    end
    
    return filteredCoins[1].Coin
end

local function IsRoundActive()
    local hasCoins = false
    for _, mapPart in pairs(Workspace:GetChildren()) do
        if mapPart:FindFirstChild("CoinContainer") then
            for _, coin in pairs(mapPart.CoinContainer:GetChildren()) do
                if coin.Name == "Coin_Server" then
                    hasCoins = true
                    break
                end
            end
        end
        if hasCoins then break end
    end
    
    local playerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    if playerData and playerData[Player.Name] then
        local myData = playerData[Player.Name]
        if myData.Dead or myData.Killed then
            return false
        end
    end
    
    return hasCoins
end

local function IsPlayerAlive()
    local character = Player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    return humanoid.Health > 0
end

local function DisableCharacterCollisions()
    local character = Player.Character
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

local function UpdateMovementVelocity()
    local character = Player.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local oldVelocity = humanoidRootPart:FindFirstChild("AutoFarmVelocity")
    if oldVelocity then
        oldVelocity:Destroy()
    end
    
    local velocity = Instance.new("BodyVelocity")
    velocity.Name = "AutoFarmVelocity"
    velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    velocity.Velocity = Vector3.new(0, 0, 0)
    velocity.Parent = humanoidRootPart
    
    ThunderHubAutoFarm.CurrentVelocity = velocity
    return velocity
end

local function MoveToTarget(targetPosition)
    local character = Player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    DisableCharacterCollisions()
    
    local velocity = UpdateMovementVelocity()
    if not velocity then return false end
    
    local currentPos = humanoidRootPart.Position
    local distance = (currentPos - targetPosition).Magnitude
    
    if distance < 5 then
        humanoidRootPart.CFrame = CFrame.new(targetPosition)
        return true
    end
    
    local finalTarget = targetPosition + Vector3.new(0, ThunderHubAutoFarm.SafeHeight, 0)
    local travelTime = distance / ThunderHubAutoFarm.MoveSpeed
    travelTime = math.min(travelTime, 5)
    
    local tweenInfo = TweenInfo.new(
        travelTime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {
        CFrame = CFrame.new(finalTarget)
    })
    
    if ThunderHubAutoFarm.CurrentTween then
        ThunderHubAutoFarm.CurrentTween:Cancel()
    end
    
    ThunderHubAutoFarm.CurrentTween = tween
    tween:Play()
    
    local success, result = pcall(function()
        tween.Completed:Wait()
    end)
    
    ThunderHubAutoFarm.CurrentTween = nil
    return success
end

local function CollectCoin(coin)
    if not coin or not coin.Parent then return false end
    
    local character = Player.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    if ThunderHubAutoFarm.CollectionDelay > 0 then
        task.wait(ThunderHubAutoFarm.CollectionDelay / 1000)
    end
    
    local success = pcall(function()
        firetouchinterest(coin, humanoidRootPart, 0)
        task.wait(0.05)
        firetouchinterest(coin, humanoidRootPart, 1)
    end)
    
    if success then
        ThunderHubAutoFarm.CoinsCollected = ThunderHubAutoFarm.CoinsCollected + 1
        ThunderHubAutoFarm.LastCoinTime = tick()
        
        -- Обновляем UI статистики
        if ThunderHubAutoFarm.Elements.StatsLabel then
            ThunderHubAutoFarm.Elements.StatsLabel.Text = string.format("Coins: %d | Speed: %d", 
                ThunderHubAutoFarm.CoinsCollected, ThunderHubAutoFarm.MoveSpeed)
        end
    end
    
    return success
end

local function CollectCoinCycle()
    if not IsPlayerAlive() then
        return false
    end
    
    ThunderHubAutoFarm.RoundActive = IsRoundActive()
    if not ThunderHubAutoFarm.RoundActive then
        return false
    end
    
    if ThunderHubAutoFarm.FullBag and ThunderHubAutoFarm.ExecuteAfterFarm then
        return false
    end
    
    local targetCoin = FindBestCoin()
    if not targetCoin then
        return false
    end
    
    local moved = MoveToTarget(targetCoin.Position)
    if not moved then
        return false
    end
    
    local collected = CollectCoin(targetCoin)
    
    if ThunderHubAutoFarm.CoinsCollected >= 100 then
        ThunderHubAutoFarm.FullBag = true
        if ThunderHubAutoFarm.ExecuteAfterFarm then
            SendNotification("Bag full! Executing after farm action...")
        end
    end
    
    return collected
end

local function AutoFarmMainLoop()
    if ThunderHubAutoFarm.Running then return end
    
    ThunderHubAutoFarm.Running = true
    ThunderHubAutoFarm.StartTime = tick()
    ThunderHubAutoFarm.CoinsCollected = 0
    
    SendNotification("AutoFarm started")
    
    while ThunderHubAutoFarm.Enabled and not ThunderHubAutoFarm.Paused do
        if not ThunderHubAutoFarm.Enabled then break end
        
        if ThunderHubAutoFarm.Paused then
            task.wait(1)
            continue
        end
        
        local success = pcall(function()
            return CollectCoinCycle()
        end)
        
        if not success then
            task.wait(1)
        end
        
        task.wait(0.1)
    end
    
    -- Очистка
    if ThunderHubAutoFarm.CurrentTween then
        ThunderHubAutoFarm.CurrentTween:Cancel()
        ThunderHubAutoFarm.CurrentTween = nil
    end
    
    if ThunderHubAutoFarm.CurrentVelocity then
        ThunderHubAutoFarm.CurrentVelocity:Destroy()
        ThunderHubAutoFarm.CurrentVelocity = nil
    end
    
    ThunderHubAutoFarm.Running = false
    SendNotification("AutoFarm stopped")
end

local function StartAutoFarm()
    if ThunderHubAutoFarm.Enabled then return end
    
    ThunderHubAutoFarm.Enabled = true
    ThunderHubAutoFarm.Paused = false
    
    -- Применяем безопасные настройки
    if ThunderHubAutoFarm.SafetyMode then
        ThunderHubAutoFarm.MoveSpeed = math.clamp(ThunderHubAutoFarm.MoveSpeed, 
            ThunderHubAutoFarm.MinSpeed, ThunderHubAutoFarm.MaxSpeed)
        
        if ThunderHubAutoFarm.MoveSpeed > 24 then
            ThunderHubAutoFarm.MoveSpeed = 22
            SendNotification("Speed adjusted to safe value: 22")
        end
    end
    
    -- Запускаем основной цикл
    local mainThread = task.spawn(function()
        AutoFarmMainLoop()
    end)
    
    table.insert(ThunderHubAutoFarm.Threads, mainThread)
    
    -- Обновляем UI
    if ThunderHubAutoFarm.Elements.MainToggle then
        ThunderHubAutoFarm.Elements.MainToggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
        ThunderHubAutoFarm.Elements.MainToggle.Text = "ON"
    end
    
    SendNotification("Advanced AutoFarm enabled")
end

local function StopAutoFarm()
    ThunderHubAutoFarm.Enabled = false
    ThunderHubAutoFarm.Paused = false
    
    for _, thread in pairs(ThunderHubAutoFarm.Threads) do
        task.cancel(thread)
    end
    ThunderHubAutoFarm.Threads = {}
    
    -- Обновляем UI
    if ThunderHubAutoFarm.Elements.MainToggle then
        ThunderHubAutoFarm.Elements.MainToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ThunderHubAutoFarm.Elements.MainToggle.Text = "OFF"
    end
    
    SendNotification("Advanced AutoFarm disabled")
end

local function PauseAutoFarm()
    if not ThunderHubAutoFarm.Enabled then return end
    
    ThunderHubAutoFarm.Paused = not ThunderHubAutoFarm.Paused
    
    if ThunderHubAutoFarm.Paused then
        SendNotification("AutoFarm paused")
        if ThunderHubAutoFarm.CurrentTween then
            ThunderHubAutoFarm.CurrentTween:Pause()
        end
    else
        SendNotification("AutoFarm resumed")
        if ThunderHubAutoFarm.CurrentTween then
            ThunderHubAutoFarm.CurrentTween:Play()
        end
    end
    
    -- Обновляем UI
    if ThunderHubAutoFarm.Elements.PauseToggle then
        ThunderHubAutoFarm.Elements.PauseToggle.BackgroundColor3 = ThunderHubAutoFarm.Paused and 
            Color3.fromRGB(255, 193, 7) or Color3.fromRGB(50, 50, 50)
        ThunderHubAutoFarm.Elements.PauseToggle.Text = ThunderHubAutoFarm.Paused and "RESUME" or "PAUSE"
    end
end

-- Создание элементов управления автофармом
local function CreateAutoFarmElements()
    local yOffset = 40
    
    -- Главный переключатель
    local MainContainer = Instance.new("Frame")
    MainContainer.Parent = AutoFarmPage
    MainContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
    MainContainer.BackgroundTransparency = 0.1
    MainContainer.Size = UDim2.new(1, -10, 0, 50)
    MainContainer.Position = UDim2.new(0, 0, 0, yOffset)
    yOffset = yOffset + 60

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainContainer

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainContainer
    MainStroke.Color = Color3.fromRGB(230,57,51)
    MainStroke.Thickness = 1.8

    local MainLabel = Instance.new("TextLabel")
    MainLabel.Parent = MainContainer
    MainLabel.Size = UDim2.new(0.6, 0, 1, 0)
    MainLabel.Position = UDim2.new(0, 10, 0, 0)
    MainLabel.BackgroundTransparency = 1
    MainLabel.Font = Enum.Font.GothamBold
    MainLabel.Text = "Advanced AutoFarm"
    MainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainLabel.TextSize = 16
    MainLabel.TextXAlignment = Enum.TextXAlignment.Left

    local MainToggle = Instance.new("TextButton")
    MainToggle.Parent = MainContainer
    MainToggle.Size = UDim2.new(0, 60, 0, 30)
    MainToggle.Position = UDim2.new(1, -70, 0.5, -15)
    MainToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainToggle.BorderSizePixel = 0
    MainToggle.Text = "OFF"
    MainToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainToggle.Font = Enum.Font.GothamBold
    MainToggle.TextSize = 12
    MainToggle.AutoButtonColor = false

    MainToggle.MouseButton1Click:Connect(function()
        playButtonSound()
        if ThunderHubAutoFarm.Enabled then
            StopAutoFarm()
        else
            StartAutoFarm()
        end
    end)

    local MainToggleCorner = Instance.new("UICorner")
    MainToggleCorner.CornerRadius = UDim.new(0, 15)
    MainToggleCorner.Parent = MainToggle

    local MainToggleStroke = Instance.new("UIStroke")
    MainToggleStroke.Parent = MainToggle
    MainToggleStroke.Color = Color3.fromRGB(100, 100, 100)
    MainToggleStroke.Thickness = 2

    ThunderHubAutoFarm.Elements.MainToggle = MainToggle

    -- Кнопка паузы
    local PauseContainer = Instance.new("Frame")
    PauseContainer.Parent = AutoFarmPage
    PauseContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
    PauseContainer.BackgroundTransparency = 0.1
    PauseContainer.Size = UDim2.new(1, -10, 0, 50)
    PauseContainer.Position = UDim2.new(0, 0, 0, yOffset)
    yOffset = yOffset + 60

    local PauseCorner = Instance.new("UICorner")
    PauseCorner.CornerRadius = UDim.new(0, 10)
    PauseCorner.Parent = PauseContainer

    local PauseStroke = Instance.new("UIStroke")
    PauseStroke.Parent = PauseContainer
    PauseStroke.Color = Color3.fromRGB(230,57,51)
    PauseStroke.Thickness = 1.8

    local PauseLabel = Instance.new("TextLabel")
    PauseLabel.Parent = PauseContainer
    PauseLabel.Size = UDim2.new(0.6, 0, 1, 0)
    PauseLabel.Position = UDim2.new(0, 10, 0, 0)
    PauseLabel.BackgroundTransparency = 1
    PauseLabel.Font = Enum.Font.GothamBold
    PauseLabel.Text = "Pause/Resume"
    PauseLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PauseLabel.TextSize = 16
    PauseLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PauseToggle = Instance.new("TextButton")
    PauseToggle.Parent = PauseContainer
    PauseToggle.Size = UDim2.new(0, 80, 0, 30)
    PauseToggle.Position = UDim2.new(1, -90, 0.5, -15)
    PauseToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    PauseToggle.BorderSizePixel = 0
    PauseToggle.Text = "PAUSE"
    PauseToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PauseToggle.Font = Enum.Font.GothamBold
    PauseToggle.TextSize = 12
    PauseToggle.AutoButtonColor = false

    PauseToggle.MouseButton1Click:Connect(function()
        playButtonSound()
        PauseAutoFarm()
    end)

    local PauseToggleCorner = Instance.new("UICorner")
    PauseToggleCorner.CornerRadius = UDim.new(0, 15)
    PauseToggleCorner.Parent = PauseToggle

    local PauseToggleStroke = Instance.new("UIStroke")
    PauseToggleStroke.Parent = PauseToggle
    PauseToggleStroke.Color = Color3.fromRGB(100, 100, 100)
    PauseToggleStroke.Thickness = 2

    ThunderHubAutoFarm.Elements.PauseToggle = PauseToggle

    -- Статистика
    local StatsContainer = Instance.new("Frame")
    StatsContainer.Parent = AutoFarmPage
    StatsContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
    StatsContainer.BackgroundTransparency = 0.1
    StatsContainer.Size = UDim2.new(1, -10, 0, 50)
    StatsContainer.Position = UDim2.new(0, 0, 0, yOffset)
    yOffset = yOffset + 60

    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 10)
    StatsCorner.Parent = StatsContainer

    local StatsStroke = Instance.new("UIStroke")
    StatsStroke.Parent = StatsContainer
    StatsStroke.Color = Color3.fromRGB(230,57,51)
    StatsStroke.Thickness = 1.8

    local StatsLabel = Instance.new("TextLabel")
    StatsLabel.Parent = StatsContainer
    StatsLabel.Size = UDim2.new(1, -20, 1, 0)
    StatsLabel.Position = UDim2.new(0, 10, 0, 0)
    StatsLabel.BackgroundTransparency = 1
    StatsLabel.Font = Enum.Font.GothamBold
    StatsLabel.Text = "Coins: 0 | Speed: 22"
    StatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatsLabel.TextSize = 14
    StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

    ThunderHubAutoFarm.Elements.StatsLabel = StatsLabel

    -- Настройка скорости
    local SpeedContainer = Instance.new("Frame")
    SpeedContainer.Parent = AutoFarmPage
    SpeedContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
    SpeedContainer.BackgroundTransparency = 0.1
    SpeedContainer.Size = UDim2.new(1, -10, 0, 50)
    SpeedContainer.Position = UDim2.new(0, 0, 0, yOffset)

    local SpeedCorner = Instance.new("UICorner")
    SpeedCorner.CornerRadius = UDim.new(0, 10)
    SpeedCorner.Parent = SpeedContainer

    local SpeedStroke = Instance.new("UIStroke")
    SpeedStroke.Parent = SpeedContainer
    SpeedStroke.Color = Color3.fromRGB(230,57,51)
    SpeedStroke.Thickness = 1.8

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Parent = SpeedContainer
    SpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
    SpeedLabel.Position = UDim2.new(0, 10, 0, 0)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Font = Enum.Font.GothamBold
    SpeedLabel.Text = "Speed: " .. ThunderHubAutoFarm.MoveSpeed
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.TextSize = 16
    SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SpeedDecrease = Instance.new("TextButton")
    SpeedDecrease.Parent = SpeedContainer
    SpeedDecrease.Size = UDim2.new(0, 30, 0, 30)
    SpeedDecrease.Position = UDim2.new(1, -100, 0.5, -15)
    SpeedDecrease.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
    SpeedDecrease.BorderSizePixel = 0
    SpeedDecrease.Text = "-"
    SpeedDecrease.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedDecrease.Font = Enum.Font.GothamBold
    SpeedDecrease.TextSize = 18
    SpeedDecrease.AutoButtonColor = false

    SpeedDecrease.MouseButton1Click:Connect(function()
        playButtonSound()
        ThunderHubAutoFarm.MoveSpeed = math.max(ThunderHubAutoFarm.MinSpeed, ThunderHubAutoFarm.MoveSpeed - 1)
        SpeedLabel.Text = "Speed: " .. ThunderHubAutoFarm.MoveSpeed
        if ThunderHubAutoFarm.Elements.StatsLabel then
            ThunderHubAutoFarm.Elements.StatsLabel.Text = string.format("Coins: %d | Speed: %d", 
                ThunderHubAutoFarm.CoinsCollected, ThunderHubAutoFarm.MoveSpeed)
        end
    end)

    local SpeedIncrease = Instance.new("TextButton")
    SpeedIncrease.Parent = SpeedContainer
    SpeedIncrease.Size = UDim2.new(0, 30, 0, 30)
    SpeedIncrease.Position = UDim2.new(1, -60, 0.5, -15)
    SpeedIncrease.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
    SpeedIncrease.BorderSizePixel = 0
    SpeedIncrease.Text = "+"
    SpeedIncrease.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedIncrease.Font = Enum.Font.GothamBold
    SpeedIncrease.TextSize = 18
    SpeedIncrease.AutoButtonColor = false

    SpeedIncrease.MouseButton1Click:Connect(function()
        playButtonSound()
        ThunderHubAutoFarm.MoveSpeed = math.min(ThunderHubAutoFarm.MaxSpeed, ThunderHubAutoFarm.MoveSpeed + 1)
        SpeedLabel.Text = "Speed: " .. ThunderHubAutoFarm.MoveSpeed
        if ThunderHubAutoFarm.Elements.StatsLabel then
            ThunderHubAutoFarm.Elements.StatsLabel.Text = string.format("Coins: %d | Speed: %d", 
                ThunderHubAutoFarm.CoinsCollected, ThunderHubAutoFarm.MoveSpeed)
        end
    end)

    local SpeedDecreaseCorner = Instance.new("UICorner")
    SpeedDecreaseCorner.CornerRadius = UDim.new(0, 8)
    SpeedDecreaseCorner.Parent = SpeedDecrease

    local SpeedIncreaseCorner = Instance.new("UICorner")
    SpeedIncreaseCorner.CornerRadius = UDim.new(0, 8)
    SpeedIncreaseCorner.Parent = SpeedIncrease

    -- Эффекты при наведении
    local function SetupButtonEffects(button)
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(210, 47, 41)
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
        end)
    end

    SetupButtonEffects(SpeedDecrease)
    SetupButtonEffects(SpeedIncrease)
    SetupButtonEffects(MainToggle)
    SetupButtonEffects(PauseToggle)

    -- Anti AFK для автофарма
    Player.Idled:Connect(function()
        if ThunderHubAutoFarm.Enabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

-- Создаем элементы автофарма
CreateAutoFarmElements()

-------------------------------------------------------------
-- ESP HIGHLIGHT КОНТЕЙНЕР В VISUAL ВКЛАДКЕ
-------------------------------------------------------------

local VisualPage = TabPages["Visual"]

-- Контейнер для Esp Highlight
local EspHighlightContainer = Instance.new("Frame")
EspHighlightContainer.Parent = VisualPage
EspHighlightContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
EspHighlightContainer.BackgroundTransparency = 0.1
EspHighlightContainer.Size = UDim2.new(1, -10, 0, 240)
EspHighlightContainer.Position = UDim2.new(0, 0, 0, 40)

local EspHighlight_Corner = Instance.new("UICorner")
EspHighlight_Corner.CornerRadius = UDim.new(0, 10)
EspHighlight_Corner.Parent = EspHighlightContainer

local EspHighlight_Stroke = Instance.new("UIStroke")
EspHighlight_Stroke.Parent = EspHighlightContainer
EspHighlight_Stroke.Color = Color3.fromRGB(230,57,51)
EspHighlight_Stroke.Thickness = 1.8

-- Заголовок Esp Highlight
local EspHighlightLabel = Instance.new("TextLabel")
EspHighlightLabel.Parent = EspHighlightContainer
EspHighlightLabel.Size = UDim2.new(1, -20, 0, 30)
EspHighlightLabel.Position = UDim2.new(0, 10, 0, 0)
EspHighlightLabel.BackgroundTransparency = 1
EspHighlightLabel.Font = Enum.Font.GothamBold
EspHighlightLabel.Text = "ESP Highlight"
EspHighlightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
EspHighlightLabel.TextSize = 16
EspHighlightLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Переменные для ESP
local EspEnabled = false
local InnocentEnabled = true
local MurderEnabled = true
local SheriffEnabled = true
local HeroEnabled = true

local roles

function CreateHighlight()
    if not EspEnabled then return end
    for i, v in pairs(Players:GetChildren()) do
        if v ~= Player and v.Character and not v.Character:FindFirstChild("ShadowHighlight") then
            local Highlight = Instance.new("Highlight")
            Highlight.Name = "ShadowHighlight"
            Highlight.Parent = v.Character
            Highlight.Adornee = v.Character
            Highlight.FillTransparency = 0.5
            Highlight.OutlineTransparency = 0
        end
    end
end

function UpdateHighlights()
    if not EspEnabled then return end
    for _, v in pairs(Players:GetChildren()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("ShadowHighlight") then
            local Highlight = v.Character:FindFirstChild("ShadowHighlight")
            Highlight.Enabled = false
            
            if roles then
                local playerData = roles[v.Name]
                if playerData then
                    local role = playerData.Role
                    local isAlive = not (playerData.Killed or playerData.Dead)
                    
                    if isAlive then
                        if MurderEnabled and role == "Murderer" then
                            Highlight.Enabled = true
                            Highlight.FillColor = Color3.fromRGB(225, 0, 0)
                        elseif SheriffEnabled and role == "Sheriff" then
                            Highlight.Enabled = true
                            Highlight.FillColor = Color3.fromRGB(0, 0, 225)
                        elseif HeroEnabled and role == "Hero" then
                            Highlight.Enabled = true
                            Highlight.FillColor = Color3.fromRGB(255, 250, 0)
                        elseif InnocentEnabled and role == "Innocent" then
                            Highlight.Enabled = true
                            Highlight.FillColor = Color3.fromRGB(0, 225, 0)
                        end
                    end
                end
            end
        end
    end
end

function ClearHighlights()
    for _, v in pairs(Players:GetChildren()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("ShadowHighlight") then
            v.Character.ShadowHighlight:Destroy()
        end
    end
end

local function CreateEspToggle(name, position, defaultState)
    local ToggleContainer = Instance.new("Frame")
    ToggleContainer.Parent = EspHighlightContainer
    ToggleContainer.BackgroundColor3 = Color3.fromRGB(25,25,25)
    ToggleContainer.BackgroundTransparency = 0.1
    ToggleContainer.Size = UDim2.new(1, -20, 0, 35)
    ToggleContainer.Position = position

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 8)
    ContainerCorner.Parent = ToggleContainer

    local ContainerStroke = Instance.new("UIStroke")
    ContainerStroke.Parent = ToggleContainer
    ContainerStroke.Color = Color3.fromRGB(60,60,60)
    ContainerStroke.Thickness = 1

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleContainer
    ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Font = Enum.Font.GothamBold
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleContainer
    ToggleButton.Size = UDim2.new(0, 60, 0, 25)
    ToggleButton.Position = UDim2.new(1, -70, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(230, 57, 51) or Color3.fromRGB(50, 50, 50)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = defaultState and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 12
    ToggleButton.AutoButtonColor = false

    ToggleButton.MouseButton1Click:Connect(function()
        playButtonSound()
    end)

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleButton

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Parent = ToggleButton
    ToggleStroke.Color = defaultState and Color3.fromRGB(200, 50, 47) or Color3.fromRGB(100, 100, 100)
    ToggleStroke.Thickness = 2

    return ToggleButton
end

local InnocentToggle = CreateEspToggle("Innocent", UDim2.new(0, 0, 0, 40), true)
local MurderToggle = CreateEspToggle("Murder", UDim2.new(0, 0, 0, 80), true)
local SheriffToggle = CreateEspToggle("Sheriff", UDim2.new(0, 0, 0, 120), true)
local HeroToggle = CreateEspToggle("Hero", UDim2.new(0, 0, 0, 160), true)

local MainToggleContainer = Instance.new("Frame")
MainToggleContainer.Parent = EspHighlightContainer
MainToggleContainer.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainToggleContainer.BackgroundTransparency = 0.1
MainToggleContainer.Size = UDim2.new(1, -20, 0, 35)
MainToggleContainer.Position = UDim2.new(0, 0, 0, 200)

local MainContainerCorner = Instance.new("UICorner")
MainContainerCorner.CornerRadius = UDim.new(0, 8)
MainContainerCorner.Parent = MainToggleContainer

local MainContainerStroke = Instance.new("UIStroke")
MainContainerStroke.Parent = MainToggleContainer
MainContainerStroke.Color = Color3.fromRGB(60,60,60)
MainContainerStroke.Thickness = 1

local MainToggleLabel = Instance.new("TextLabel")
MainToggleLabel.Parent = MainToggleContainer
MainToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
MainToggleLabel.Position = UDim2.new(0, 10, 0, 0)
MainToggleLabel.BackgroundTransparency = 1
MainToggleLabel.Font = Enum.Font.GothamBold
MainToggleLabel.Text = "Enable ESP"
MainToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MainToggleLabel.TextSize = 14
MainToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

local MainToggleButton = Instance.new("TextButton")
MainToggleButton.Parent = MainToggleContainer
MainToggleButton.Size = UDim2.new(0, 60, 0, 25)
MainToggleButton.Position = UDim2.new(1, -70, 0.5, -12.5)
MainToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainToggleButton.BorderSizePixel = 0
MainToggleButton.Text = "OFF"
MainToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainToggleButton.Font = Enum.Font.GothamBold
MainToggleButton.TextSize = 12
MainToggleButton.AutoButtonColor = false

MainToggleButton.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local MainToggleCorner = Instance.new("UICorner")
MainToggleCorner.CornerRadius = UDim.new(0, 12)
MainToggleCorner.Parent = MainToggleButton

local MainToggleStroke = Instance.new("UIStroke")
MainToggleStroke.Parent = MainToggleButton
MainToggleStroke.Color = Color3.fromRGB(100, 100, 100)
MainToggleStroke.Thickness = 2

InnocentToggle.MouseButton1Click:Connect(function()
    InnocentEnabled = not InnocentEnabled
    InnocentToggle.BackgroundColor3 = InnocentEnabled and Color3.fromRGB(230, 57, 51) or Color3.fromRGB(50, 50, 50)
    InnocentToggle.Text = InnocentEnabled and "ON" or "OFF"
    InnocentToggle:FindFirstChildOfClass("UIStroke").Color = InnocentEnabled and Color3.fromRGB(200, 50, 47) or Color3.fromRGB(100, 100, 100)
    UpdateHighlights()
end)

MurderToggle.MouseButton1Click:Connect(function()
    MurderEnabled = not MurderEnabled
    MurderToggle.BackgroundColor3 = MurderEnabled and Color3.fromRGB(230, 57, 51) or Color3.fromRGB(50, 50, 50)
    MurderToggle.Text = MurderEnabled and "ON" or "OFF"
    MurderToggle:FindFirstChildOfClass("UIStroke").Color = MurderEnabled and Color3.fromRGB(200, 50, 47) or Color3.fromRGB(100, 100, 100)
    UpdateHighlights()
end)

SheriffToggle.MouseButton1Click:Connect(function()
    SheriffEnabled = not SheriffEnabled
    SheriffToggle.BackgroundColor3 = SheriffEnabled and Color3.fromRGB(230, 57, 51) or Color3.fromRGB(50, 50, 50)
    SheriffToggle.Text = SheriffEnabled and "ON" or "OFF"
    SheriffToggle:FindFirstChildOfClass("UIStroke").Color = SheriffEnabled and Color3.fromRGB(200, 50, 47) or Color3.fromRGB(100, 100, 100)
    UpdateHighlights()
end)

HeroToggle.MouseButton1Click:Connect(function()
    HeroEnabled = not HeroEnabled
    HeroToggle.BackgroundColor3 = HeroEnabled and Color3.fromRGB(230, 57, 51) or Color3.fromRGB(50, 50, 50)
    HeroToggle.Text = HeroEnabled and "ON" or "OFF"
    HeroToggle:FindFirstChildOfClass("UIStroke").Color = HeroEnabled and Color3.fromRGB(200, 50, 47) or Color3.fromRGB(100, 100, 100)
    UpdateHighlights()
end)

MainToggleButton.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    MainToggleButton.BackgroundColor3 = EspEnabled and Color3.fromRGB(230, 57, 51) or Color3.fromRGB(50, 50, 50)
    MainToggleButton.Text = EspEnabled and "ON" or "OFF"
    MainToggleButton:FindFirstChildOfClass("UIStroke").Color = EspEnabled and Color3.fromRGB(200, 50, 47) or Color3.fromRGB(100, 100, 100)
    
    if EspEnabled then
        CreateHighlight()
        UpdateHighlights()
    else
        ClearHighlights()
    end
end)

local ESPConnection
ESPConnection = RunService.RenderStepped:Connect(function()
    if EspEnabled then
        pcall(function()
            roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
            CreateHighlight()
            UpdateHighlights()
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player ~= Player and player.Character and player.Character:FindFirstChild("ShadowHighlight") then
        player.Character.ShadowHighlight:Destroy()
    end
end)

-------------------------------------------------------------
-- ДРУГИЕ ВКЛАДКИ (Coming Soon)
-------------------------------------------------------------

local function CreateComingSoonPage(page)
    local SoonLabel = Instance.new("TextLabel")
    SoonLabel.Parent = page
    SoonLabel.Size = UDim2.new(1, -10, 1, -50)
    SoonLabel.Position = UDim2.new(0, 5, 0, 40)
    SoonLabel.BackgroundTransparency = 1
    SoonLabel.Font = Enum.Font.GothamBold
    SoonLabel.Text = page.Name .. "\nComing Soon"
    SoonLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SoonLabel.TextSize = 24
    SoonLabel.TextTransparency = 0.3
    SoonLabel.TextYAlignment = Enum.TextYAlignment.Center
end

CreateComingSoonPage(TabPages["Combat"])
CreateComingSoonPage(TabPages["Emotes"])
CreateComingSoonPage(TabPages["Teleport"])

-------------------------------------------------------------
-- MISC РАЗДЕЛ
-------------------------------------------------------------

local MiscPage = TabPages["Misc"]
local AntiAFKEnabled = false
local AntiAFKConnection

-- Контейнер для Anti AFK
local AntiAFKContainer = Instance.new("Frame")
AntiAFKContainer.Parent = MiscPage
AntiAFKContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
AntiAFKContainer.BackgroundTransparency = 0.1
AntiAFKContainer.Size = UDim2.new(1, -10, 0, 50)
AntiAFKContainer.Position = UDim2.new(0, 0, 0, 40)

local AntiAFK_Corner = Instance.new("UICorner")
AntiAFK_Corner.CornerRadius = UDim.new(0, 10)
AntiAFK_Corner.Parent = AntiAFKContainer

local AntiAFK_Stroke = Instance.new("UIStroke")
AntiAFK_Stroke.Parent = AntiAFKContainer
AntiAFK_Stroke.Color = Color3.fromRGB(230,57,51)
AntiAFK_Stroke.Thickness = 1.8

local AntiAFKLabel = Instance.new("TextLabel")
AntiAFKLabel.Parent = AntiAFKContainer
AntiAFKLabel.Size = UDim2.new(0.6, 0, 1, 0)
AntiAFKLabel.Position = UDim2.new(0, 10, 0, 0)
AntiAFKLabel.BackgroundTransparency = 1
AntiAFKLabel.Font = Enum.Font.GothamBold
AntiAFKLabel.Text = "Anti AFK"
AntiAFKLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAFKLabel.TextSize = 16
AntiAFKLabel.TextXAlignment = Enum.TextXAlignment.Left

local AntiAFKToggle = Instance.new("TextButton")
AntiAFKToggle.Parent = AntiAFKContainer
AntiAFKToggle.Size = UDim2.new(0, 60, 0, 30)
AntiAFKToggle.Position = UDim2.new(1, -70, 0.5, -15)
AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AntiAFKToggle.BorderSizePixel = 0
AntiAFKToggle.Text = "OFF"
AntiAFKToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAFKToggle.Font = Enum.Font.GothamBold
AntiAFKToggle.TextSize = 12
AntiAFKToggle.AutoButtonColor = false

AntiAFKToggle.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 15)
ToggleCorner.Parent = AntiAFKToggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = AntiAFKToggle
ToggleStroke.Color = Color3.fromRGB(100, 100, 100)
ToggleStroke.Thickness = 2

-- Контейнер для Rejoin и Server Hop
local ServerButtonsContainer = Instance.new("Frame")
ServerButtonsContainer.Parent = MiscPage
ServerButtonsContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
ServerButtonsContainer.BackgroundTransparency = 0.1
ServerButtonsContainer.Size = UDim2.new(1, -10, 0, 85)
ServerButtonsContainer.Position = UDim2.new(0, 0, 0, 100)

local ServerButtons_Corner = Instance.new("UICorner")
ServerButtons_Corner.CornerRadius = UDim.new(0, 10)
ServerButtons_Corner.Parent = ServerButtonsContainer

local ServerButtons_Stroke = Instance.new("UIStroke")
ServerButtons_Stroke.Parent = ServerButtonsContainer
ServerButtons_Stroke.Color = Color3.fromRGB(230,57,51)
ServerButtons_Stroke.Thickness = 1.8

local RejoinButton = Instance.new("TextButton")
RejoinButton.Parent = ServerButtonsContainer
RejoinButton.Size = UDim2.new(0.9, 0, 0, 30)
RejoinButton.Position = UDim2.new(0.05, 0, 0, 10)
RejoinButton.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
RejoinButton.BorderSizePixel = 0
RejoinButton.Text = "Rejoin Server"
RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinButton.Font = Enum.Font.GothamBold
RejoinButton.TextSize = 14
RejoinButton.AutoButtonColor = false

RejoinButton.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 8)
RejoinCorner.Parent = RejoinButton

local RejoinStroke = Instance.new("UIStroke")
RejoinStroke.Parent = RejoinButton
RejoinStroke.Color = Color3.fromRGB(200, 50, 47)
RejoinStroke.Thickness = 2

local ServerHopButton = Instance.new("TextButton")
ServerHopButton.Parent = ServerButtonsContainer
ServerHopButton.Size = UDim2.new(0.9, 0, 0, 30)
ServerHopButton.Position = UDim2.new(0.05, 0, 0, 45)
ServerHopButton.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
ServerHopButton.BorderSizePixel = 0
ServerHopButton.Text = "Server Hop"
ServerHopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ServerHopButton.Font = Enum.Font.GothamBold
ServerHopButton.TextSize = 14
ServerHopButton.AutoButtonColor = false

ServerHopButton.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local ServerHopCorner = Instance.new("UICorner")
ServerHopCorner.CornerRadius = UDim.new(0, 8)
ServerHopCorner.Parent = ServerHopButton

local ServerHopStroke = Instance.new("UIStroke")
ServerHopStroke.Parent = ServerHopButton
ServerHopStroke.Color = Color3.fromRGB(200, 50, 47)
ServerHopStroke.Thickness = 2

local function RejoinGame()
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    local success, error = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, Player)
    end)
    
    if not success then
        warn("Rejoin failed: " .. tostring(error))
        RejoinButton.Text = "Rejoin Server"
    end
end

local function ServerHop()
    local placeId = game.PlaceId
    
    local servers = {}
    local success, result = pcall(function()
        local response = game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
        return HttpService:JSONDecode(response)
    end)
    
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server)
            end
        end
        
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            local teleportSuccess, teleportError = pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, randomServer.id, Player)
            end)
            
            if not teleportSuccess then
                warn("Server hop failed: " .. tostring(teleportError))
                ServerHopButton.Text = "Server Hop"
            end
        else
            warn("No available servers found for server hop")
            ServerHopButton.Text = "Server Hop"
        end
    else
        warn("Failed to get server list")
        ServerHopButton.Text = "Server Hop"
    end
end

RejoinButton.MouseButton1Click:Connect(function()
    RejoinButton.Text = "Rejoining..."
    task.wait(0.5)
    RejoinGame()
end)

ServerHopButton.MouseButton1Click:Connect(function()
    ServerHopButton.Text = "Hopping..."
    task.wait(0.5)
    ServerHop()
end)

RejoinButton.MouseEnter:Connect(function()
    RejoinButton.BackgroundColor3 = Color3.fromRGB(210, 47, 41)
end)

RejoinButton.MouseLeave:Connect(function()
    RejoinButton.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
end)

ServerHopButton.MouseEnter:Connect(function()
    ServerHopButton.BackgroundColor3 = Color3.fromRGB(210, 47, 41)
end)

ServerHopButton.MouseLeave:Connect(function()
    ServerHopButton.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
end)

local function EnableAntiAFK()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
    end
    
    AntiAFKConnection = Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    
    AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
    AntiAFKToggle.Text = "ON"
    ToggleStroke.Color = Color3.fromRGB(200, 50, 47)
end

local function DisableAntiAFK()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
    
    AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    AntiAFKToggle.Text = "OFF"
    ToggleStroke.Color = Color3.fromRGB(100, 100, 100)
end

AntiAFKToggle.MouseButton1Click:Connect(function()
    AntiAFKEnabled = not AntiAFKEnabled
    
    if AntiAFKEnabled then
        EnableAntiAFK()
    else
        DisableAntiAFK()
    end
end)

-------------------------------------------------------------
-- ПЕРЕТАСКИВАНИЕ ГЛАВНОГО ОКНА
-------------------------------------------------------------

local dragging = false
local dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false 
                connection:Disconnect()
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)

-------------------------------------------------------------
-- КНОПКА СКРЫТИЯ/ПОКАЗА
-------------------------------------------------------------

local ToggleParentFrame = Instance.new("Frame")
ToggleParentFrame.Parent = ScreenGui
ToggleParentFrame.Size = UDim2.new(0, 45, 0, 45)
ToggleParentFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleParentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleParentFrame.BackgroundTransparency = 0.08
ToggleParentFrame.BorderSizePixel = 0

local ToggleParentCorner = Instance.new("UICorner")
ToggleParentCorner.CornerRadius = UDim.new(0, 6)
ToggleParentCorner.Parent = ToggleParentFrame

local ToggleParentStroke = Instance.new("UIStroke")
ToggleParentStroke.Color = Color3.fromRGB(230, 57, 51)
ToggleParentStroke.Thickness = 2
ToggleParentStroke.Parent = ToggleParentFrame

local IconContainer = Instance.new("Frame")
IconContainer.Parent = ToggleParentFrame
IconContainer.Size = UDim2.new(0.7, 0, 0.7, 0)
IconContainer.Position = UDim2.new(0.15, 0, 0.15, 0)
IconContainer.BackgroundTransparency = 1

local Icon = Instance.new("ImageLabel")
Icon.Parent = IconContainer
Icon.Size = UDim2.new(1, 0, 1, 0)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxthumb://type=Asset&id=93886432127909&w=420&h=420"
Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)

local ClickButton = Instance.new("TextButton")
ClickButton.Parent = ToggleParentFrame
ClickButton.Size = UDim2.new(1, 0, 1, 0)
ClickButton.BackgroundTransparency = 1
ClickButton.Text = ""

ClickButton.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local isVisible = true
ClickButton.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    MainFrame.Visible = isVisible
end)

-------------------------------------------------------------
-- УВЕДОМЛЕНИЕ О ЗАГРУЗКЕ
-------------------------------------------------------------

SendNotification("Shadow Script loaded successfully!")
print("Shadow Script loaded for user: " .. Player.Name)
