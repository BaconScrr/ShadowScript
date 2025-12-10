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

    -- Убираем автоматический заголовок для всех вкладок
    if tabName ~= "Auto Farm" then
        local Label = Instance.new("TextLabel")
        Label.Parent = Page
        Label.Size = UDim2.new(1, 0, 0, 30)
        Label.BackgroundTransparency = 1
        Label.Text = tabName .. " Page"
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 18
    end

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
    end)
end

-------------------------------------------------------------
-- ПРОФИЛЬ ИГРОКА (без Server ID)
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
-- AUTO FARM ВКЛАДКА (исправлено - один заголовок)
-------------------------------------------------------------

local AutoFarmPage = TabPages["Auto Farm"]

-- Один заголовок для Auto Farm
local AutoFarmLabel = Instance.new("TextLabel")
AutoFarmLabel.Parent = AutoFarmPage
AutoFarmLabel.Size = UDim2.new(1, 0, 0, 30)
AutoFarmLabel.BackgroundTransparency = 1
AutoFarmLabel.Text = "Auto Farm Features"
AutoFarmLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmLabel.Font = Enum.Font.GothamBold
AutoFarmLabel.TextSize = 18

-------------------------------------------------------------
-- COIN AUTOFARM КОНТЕЙНЕР В AUTO FARM ВКЛАДКЕ (ИСПРАВЛЕННАЯ ЛОГИКА)
-------------------------------------------------------------

local CoinAutofarmContainer = Instance.new("Frame")
CoinAutofarmContainer.Parent = AutoFarmPage
CoinAutofarmContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
CoinAutofarmContainer.BackgroundTransparency = 0.1
CoinAutofarmContainer.Size = UDim2.new(1, -10, 0, 50)
CoinAutofarmContainer.Position = UDim2.new(0, 0, 0, 40)

local CoinAutofarm_Corner = Instance.new("UICorner")
CoinAutofarm_Corner.CornerRadius = UDim.new(0, 10)
CoinAutofarm_Corner.Parent = CoinAutofarmContainer

local CoinAutofarm_Stroke = Instance.new("UIStroke")
CoinAutofarm_Stroke.Parent = CoinAutofarmContainer
CoinAutofarm_Stroke.Color = Color3.fromRGB(230,57,51)
CoinAutofarm_Stroke.Thickness = 1.8

-- Текст Coin Autofarm
local CoinAutofarmLabel = Instance.new("TextLabel")
CoinAutofarmLabel.Parent = CoinAutofarmContainer
CoinAutofarmLabel.Size = UDim2.new(0.6, 0, 1, 0)
CoinAutofarmLabel.Position = UDim2.new(0, 10, 0, 0)
CoinAutofarmLabel.BackgroundTransparency = 1
CoinAutofarmLabel.Font = Enum.Font.GothamBold
CoinAutofarmLabel.Text = "Coin Autofarm"
CoinAutofarmLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CoinAutofarmLabel.TextSize = 16
CoinAutofarmLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Переключатель Coin Autofarm
local CoinAutofarmToggle = Instance.new("TextButton")
CoinAutofarmToggle.Parent = CoinAutofarmContainer
CoinAutofarmToggle.Size = UDim2.new(0, 60, 0, 30)
CoinAutofarmToggle.Position = UDim2.new(1, -70, 0.5, -15)
CoinAutofarmToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CoinAutofarmToggle.BorderSizePixel = 0
CoinAutofarmToggle.Text = "OFF"
CoinAutofarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
CoinAutofarmToggle.Font = Enum.Font.GothamBold
CoinAutofarmToggle.TextSize = 12
CoinAutofarmToggle.AutoButtonColor = false

-- Добавляем звук при нажатии на переключатель Coin Autofarm
CoinAutofarmToggle.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local CoinAutofarmToggleCorner = Instance.new("UICorner")
CoinAutofarmToggleCorner.CornerRadius = UDim.new(0, 15)
CoinAutofarmToggleCorner.Parent = CoinAutofarmToggle

local CoinAutofarmToggleStroke = Instance.new("UIStroke")
CoinAutofarmToggleStroke.Parent = CoinAutofarmToggle
CoinAutofarmToggleStroke.Color = Color3.fromRGB(100, 100, 100)
CoinAutofarmToggleStroke.Thickness = 2

-- Добавляем необходимые сервисы
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoinCollected = ReplicatedStorage.Remotes.Gameplay.CoinCollected
local RoundStart = ReplicatedStorage.Remotes.Gameplay.RoundStart
local RoundEnd = ReplicatedStorage.Remotes.Gameplay.RoundEndFade

-- Переменные для Coin Autofarm
local CoinAutofarmEnabled = false
local AutoFarmRunning = false
local farming = false
local bag_full = false
local resetting = false
local start_position = nil
local farmConnection

-- Функция для получения персонажа
local function getCharacter() 
    return Player.Character or Player.CharacterAdded:Wait() 
end

-- Функция для получения HumanoidRootPart
local function getHRP() 
    return getCharacter():WaitForChild("HumanoidRootPart") 
end

-- Обработчик сбора монет
CoinCollected.OnClientEvent:Connect(function(_, current, max)
    if current == max and not resetting and AutoResetEnabled then
        resetting = true
        bag_full = true
        local hrp = getHRP()
        if start_position then
            local tween = TweenService:Create(hrp, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = start_position})
            tween:Play()
            tween.Completed:Wait()
        end
        task.wait(0.5)
        Player.Character.Humanoid.Health = 0
        Player.CharacterAdded:Wait()
        task.wait(1.5)
        resetting = false
        bag_full = false
    end
end)

-- Обработчик начала раунда
RoundStart.OnClientEvent:Connect(function()
    farming = true
    start_position = getHRP().CFrame
end)

-- Обработчик конца раунда
RoundEnd.OnClientEvent:Connect(function()
    farming = false
end)

-- Функция для поиска ближайшей монеты
local function get_nearest_coin()
    local hrp = getHRP()
    local closest, dist = nil, math.huge
    for _, m in pairs(Workspace:GetChildren()) do
        if m:FindFirstChild("CoinContainer") then
            for _, coin in pairs(m.CoinContainer:GetChildren()) do
                if coin:IsA("BasePart") and coin:FindFirstChild("TouchInterest") then
                    local d = (hrp.Position - coin.Position).Magnitude
                    if d < dist then closest, dist = coin, d end
                end
            end
        end
    end
    return closest, dist
end

-- Основная функция автофарма
local function StartAutoFarm()
    if AutoFarmRunning then return end
    
    AutoFarmRunning = true
    
    farmConnection = task.spawn(function()
        while CoinAutofarmEnabled and AutoFarmRunning do
            if farming and not bag_full then
                local coin, dist = get_nearest_coin()
                if coin then
                    local hrp = getHRP()
                    if dist > 150 then
                        -- Телепортируемся если далеко
                        hrp.CFrame = coin.CFrame
                    else
                        -- Плавно двигаемся к монете
                        local tween = TweenService:Create(hrp, TweenInfo.new(dist / 20, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                        tween:Play()
                        
                        -- Ждем пока монета не будет собрана или фарм не остановится
                        repeat 
                            task.wait(0.1) 
                        until not coin:FindFirstChild("TouchInterest") or not farming or not CoinAutofarmEnabled
                        
                        tween:Cancel()
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end

-- Функция остановки автофарма
local function StopAutoFarm()
    AutoFarmRunning = false
    
    if farmConnection then
        task.cancel(farmConnection)
        farmConnection = nil
    end
    
    farming = false
    bag_full = false
    resetting = false
end

-- Обработчик переключателя Coin Autofarm
CoinAutofarmToggle.MouseButton1Click:Connect(function()
    CoinAutofarmEnabled = not CoinAutofarmEnabled
    
    if CoinAutofarmEnabled then
        CoinAutofarmToggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
        CoinAutofarmToggle.Text = "ON"
        CoinAutofarmToggleStroke.Color = Color3.fromRGB(200, 50, 47)
        
        -- Включаем автофарм
        StartAutoFarm()
    else
        CoinAutofarmToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        CoinAutofarmToggle.Text = "OFF"
        CoinAutofarmToggleStroke.Color = Color3.fromRGB(100, 100, 100)
        
        -- Выключаем автофарм
        StopAutoFarm()
    end
end)

-- Обработчик Anti-AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Эффекты при наведении на переключатель
CoinAutofarmToggle.MouseEnter:Connect(function()
    if not CoinAutofarmEnabled then
        CoinAutofarmToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

CoinAutofarmToggle.MouseLeave:Connect(function()
    if not CoinAutofarmEnabled then
        CoinAutofarmToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Очистка при переподключении персонажа
Player.CharacterAdded:Connect(function(character)
    task.wait(1) -- Ждем загрузки персонажа
    
    if CoinAutofarmEnabled and AutoFarmRunning then
        -- Перезапускаем фарм при появлении нового персонажа
        StopAutoFarm()
        task.wait(0.5)
        if CoinAutofarmEnabled then
            StartAutoFarm()
        end
    end
end)

-- Очистка при выходе
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if CoinAutofarmEnabled then
        StopAutoFarm()
    end
end)

game:GetService("UserInputService").WindowFocused:Connect(function()
    if CoinAutofarmEnabled and not AutoFarmRunning then
        StartAutoFarm()
    end
end)

-------------------------------------------------------------
-- AUTO RESET TO FULL КОНТЕЙНЕР В AUTO FARM ВКЛАДКЕ
-------------------------------------------------------------

local AutoResetContainer = Instance.new("Frame")
AutoResetContainer.Parent = AutoFarmPage
AutoResetContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
AutoResetContainer.BackgroundTransparency = 0.1
AutoResetContainer.Size = UDim2.new(1, -10, 0, 50)
AutoResetContainer.Position = UDim2.new(0, 0, 0, 100)

local AutoReset_Corner = Instance.new("UICorner")
AutoReset_Corner.CornerRadius = UDim.new(0, 10)
AutoReset_Corner.Parent = AutoResetContainer

local AutoReset_Stroke = Instance.new("UIStroke")
AutoReset_Stroke.Parent = AutoResetContainer
AutoReset_Stroke.Color = Color3.fromRGB(230,57,51)
AutoReset_Stroke.Thickness = 1.8

-- Текст Auto Reset to Full
local AutoResetLabel = Instance.new("TextLabel")
AutoResetLabel.Parent = AutoResetContainer
AutoResetLabel.Size = UDim2.new(0.6, 0, 1, 0)
AutoResetLabel.Position = UDim2.new(0, 10, 0, 0)
AutoResetLabel.BackgroundTransparency = 1
AutoResetLabel.Font = Enum.Font.GothamBold
AutoResetLabel.Text = "Auto Reset"
AutoResetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoResetLabel.TextSize = 16
AutoResetLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Переключатель Auto Reset to Full
local AutoResetToggle = Instance.new("TextButton")
AutoResetToggle.Parent = AutoResetContainer
AutoResetToggle.Size = UDim2.new(0, 60, 0, 30)
AutoResetToggle.Position = UDim2.new(1, -70, 0.5, -15)
AutoResetToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoResetToggle.BorderSizePixel = 0
AutoResetToggle.Text = "OFF"
AutoResetToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoResetToggle.Font = Enum.Font.GothamBold
AutoResetToggle.TextSize = 12
AutoResetToggle.AutoButtonColor = false

-- Добавляем звук при нажатии на переключатель Auto Reset
AutoResetToggle.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local AutoResetToggleCorner = Instance.new("UICorner")
AutoResetToggleCorner.CornerRadius = UDim.new(0, 15)
AutoResetToggleCorner.Parent = AutoResetToggle

local AutoResetToggleStroke = Instance.new("UIStroke")
AutoResetToggleStroke.Parent = AutoResetToggle
AutoResetToggleStroke.Color = Color3.fromRGB(100, 100, 100)
AutoResetToggleStroke.Thickness = 2

-- Переменная для состояния Auto Reset to Full
local AutoResetEnabled = false

-- Обработчик переключателя Auto Reset to Full
AutoResetToggle.MouseButton1Click:Connect(function()
    AutoResetEnabled = not AutoResetEnabled
    
    if AutoResetEnabled then
        AutoResetToggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
        AutoResetToggle.Text = "ON"
        AutoResetToggleStroke.Color = Color3.fromRGB(200, 50, 47)
    else
        AutoResetToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        AutoResetToggle.Text = "OFF"
        AutoResetToggleStroke.Color = Color3.fromRGB(100, 100, 100)
    end
end)

-- Эффекты при наведении на переключатель
AutoResetToggle.MouseEnter:Connect(function()
    if not AutoResetEnabled then
        AutoResetToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

AutoResetToggle.MouseLeave:Connect(function()
    if not AutoResetEnabled then
        AutoResetToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

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

-- > Declarations < --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local roles

-- > Functions <--
function CreateHighlight()
    if not EspEnabled then return end
    for i, v in pairs(Players:GetChildren()) do
        if v ~= LP and v.Character and not v.Character:FindFirstChild("ShadowHighlight") then
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
        if v ~= LP and v.Character and v.Character:FindFirstChild("ShadowHighlight") then
            local Highlight = v.Character:FindFirstChild("ShadowHighlight")
            
            -- Сначала скрываем всех
            Highlight.Enabled = false
            
            -- Проверяем роли и показываем соответствующих игроков
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
                            -- Герой показывается сразу при включении опции, не ждем смерти шерифа
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

function IsAlive(player)
    if not roles then return false end
    local playerData = roles[player.Name]
    if playerData then
        return not (playerData.Killed or playerData.Dead)
    end
    return false
end

function ClearHighlights()
    for _, v in pairs(Players:GetChildren()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("ShadowHighlight") then
            v.Character.ShadowHighlight:Destroy()
        end
    end
end

-- Функция для создания переключателя в стиле Anti AFK
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

    -- Добавляем звук при нажатии на переключатель
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

-- Создаем переключатели в стиле Anti AFK
local InnocentToggle = CreateEspToggle("Innocent", UDim2.new(0, 0, 0, 40), true)
local MurderToggle = CreateEspToggle("Murder", UDim2.new(0, 0, 0, 80), true)
local SheriffToggle = CreateEspToggle("Sheriff", UDim2.new(0, 0, 0, 120), true)
local HeroToggle = CreateEspToggle("Hero", UDim2.new(0, 0, 0, 160), true)

-- Главный переключатель ESP
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

-- Добавляем звук при нажатии на главный переключатель
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

-- Обработчики для переключателей
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

-- Обработчик для главного переключателя ESP
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

-- Основной цикл ESP
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

-- Очистка при выходе
Players.PlayerRemoving:Connect(function(player)
    if player ~= LP and player.Character and player.Character:FindFirstChild("ShadowHighlight") then
        player.Character.ShadowHighlight:Destroy()
    end
end)

-------------------------------------------------------------
-- GUNDROP ESP КОНТЕЙНЕР В VISUAL ВКЛАДКЕ
-------------------------------------------------------------

-- Контейнер для GunDrop Esp
local GunDropEspContainer = Instance.new("Frame")
GunDropEspContainer.Parent = VisualPage
GunDropEspContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
GunDropEspContainer.BackgroundTransparency = 0.1
GunDropEspContainer.Size = UDim2.new(1, -10, 0, 100)
GunDropEspContainer.Position = UDim2.new(0, 0, 0, 290)  -- Расположен под ESP Highlight контейнером

local GunDropEsp_Corner = Instance.new("UICorner")
GunDropEsp_Corner.CornerRadius = UDim.new(0, 10)
GunDropEsp_Corner.Parent = GunDropEspContainer

local GunDropEsp_Stroke = Instance.new("UIStroke")
GunDropEsp_Stroke.Parent = GunDropEspContainer
GunDropEsp_Stroke.Color = Color3.fromRGB(230,57,51)
GunDropEsp_Stroke.Thickness = 1.8

-- Заголовок GunDrop Esp
local GunDropEspLabel = Instance.new("TextLabel")
GunDropEspLabel.Parent = GunDropEspContainer
GunDropEspLabel.Size = UDim2.new(1, -20, 0, 30)
GunDropEspLabel.Position = UDim2.new(0, 10, 0, 0)
GunDropEspLabel.BackgroundTransparency = 1
GunDropEspLabel.Font = Enum.Font.GothamBold
GunDropEspLabel.Text = "GunDrop Esp"
GunDropEspLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GunDropEspLabel.TextSize = 16
GunDropEspLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Переменные для GunDrop ESP
local GunDropHighlightEnabled = false
local GunDropEspEnabled = false

-- Создаем переключатель GunDrop Highlight
local GunDropHighlightContainer = Instance.new("Frame")
GunDropHighlightContainer.Parent = GunDropEspContainer
GunDropHighlightContainer.BackgroundColor3 = Color3.fromRGB(25,25,25)
GunDropHighlightContainer.BackgroundTransparency = 0.1
GunDropHighlightContainer.Size = UDim2.new(1, -20, 0, 25)
GunDropHighlightContainer.Position = UDim2.new(0, 10, 0, 35)

local GunDropHighlight_Corner = Instance.new("UICorner")
GunDropHighlight_Corner.CornerRadius = UDim.new(0, 6)
GunDropHighlight_Corner.Parent = GunDropHighlightContainer

local GunDropHighlight_Stroke = Instance.new("UIStroke")
GunDropHighlight_Stroke.Parent = GunDropHighlightContainer
GunDropHighlight_Stroke.Color = Color3.fromRGB(60,60,60)
GunDropHighlight_Stroke.Thickness = 1

local GunDropHighlightLabel = Instance.new("TextLabel")
GunDropHighlightLabel.Parent = GunDropHighlightContainer
GunDropHighlightLabel.Size = UDim2.new(0.7, 0, 1, 0)
GunDropHighlightLabel.Position = UDim2.new(0, 10, 0, 0)
GunDropHighlightLabel.BackgroundTransparency = 1
GunDropHighlightLabel.Font = Enum.Font.GothamBold
GunDropHighlightLabel.Text = "GunDrop Highlight"
GunDropHighlightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GunDropHighlightLabel.TextSize = 13
GunDropHighlightLabel.TextXAlignment = Enum.TextXAlignment.Left

local GunDropHighlightToggle = Instance.new("TextButton")
GunDropHighlightToggle.Parent = GunDropHighlightContainer
GunDropHighlightToggle.Size = UDim2.new(0, 50, 0, 20)
GunDropHighlightToggle.Position = UDim2.new(1, -60, 0.5, -10)
GunDropHighlightToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GunDropHighlightToggle.BorderSizePixel = 0
GunDropHighlightToggle.Text = "OFF"
GunDropHighlightToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
GunDropHighlightToggle.Font = Enum.Font.GothamBold
GunDropHighlightToggle.TextSize = 11
GunDropHighlightToggle.AutoButtonColor = false

-- Добавляем звук при нажатии на переключатель GunDrop Highlight
GunDropHighlightToggle.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local GunDropHighlightToggleCorner = Instance.new("UICorner")
GunDropHighlightToggleCorner.CornerRadius = UDim.new(0, 10)
GunDropHighlightToggleCorner.Parent = GunDropHighlightToggle

local GunDropHighlightToggleStroke = Instance.new("UIStroke")
GunDropHighlightToggleStroke.Parent = GunDropHighlightToggle
GunDropHighlightToggleStroke.Color = Color3.fromRGB(100, 100, 100)
GunDropHighlightToggleStroke.Thickness = 2

-- Создаем переключатель GunDrop Esp
local GunDropEspToggleContainer = Instance.new("Frame")
GunDropEspToggleContainer.Parent = GunDropEspContainer
GunDropEspToggleContainer.BackgroundColor3 = Color3.fromRGB(25,25,25)
GunDropEspToggleContainer.BackgroundTransparency = 0.1
GunDropEspToggleContainer.Size = UDim2.new(1, -20, 0, 25)
GunDropEspToggleContainer.Position = UDim2.new(0, 10, 0, 65)

local GunDropEspToggle_Corner = Instance.new("UICorner")
GunDropEspToggle_Corner.CornerRadius = UDim.new(0, 6)
GunDropEspToggle_Corner.Parent = GunDropEspToggleContainer

local GunDropEspToggle_Stroke = Instance.new("UIStroke")
GunDropEspToggle_Stroke.Parent = GunDropEspToggleContainer
GunDropEspToggle_Stroke.Color = Color3.fromRGB(60,60,60)
GunDropEspToggle_Stroke.Thickness = 1

local GunDropEspToggleLabel = Instance.new("TextLabel")
GunDropEspToggleLabel.Parent = GunDropEspToggleContainer
GunDropEspToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
GunDropEspToggleLabel.Position = UDim2.new(0, 10, 0, 0)
GunDropEspToggleLabel.BackgroundTransparency = 1
GunDropEspToggleLabel.Font = Enum.Font.GothamBold
GunDropEspToggleLabel.Text = "GunDrop Esp"
GunDropEspToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GunDropEspToggleLabel.TextSize = 13
GunDropEspToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

local GunDropEspToggle = Instance.new("TextButton")
GunDropEspToggle.Parent = GunDropEspToggleContainer
GunDropEspToggle.Size = UDim2.new(0, 50, 0, 20)
GunDropEspToggle.Position = UDim2.new(1, -60, 0.5, -10)
GunDropEspToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GunDropEspToggle.BorderSizePixel = 0
GunDropEspToggle.Text = "OFF"
GunDropEspToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
GunDropEspToggle.Font = Enum.Font.GothamBold
GunDropEspToggle.TextSize = 11
GunDropEspToggle.AutoButtonColor = false

-- Добавляем звук при нажатии на переключатель GunDrop Esp
GunDropEspToggle.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local GunDropEspToggleCorner = Instance.new("UICorner")
GunDropEspToggleCorner.CornerRadius = UDim.new(0, 10)
GunDropEspToggleCorner.Parent = GunDropEspToggle

local GunDropEspToggleStroke = Instance.new("UIStroke")
GunDropEspToggleStroke.Parent = GunDropEspToggle
GunDropEspToggleStroke.Color = Color3.fromRGB(100, 100, 100)
GunDropEspToggleStroke.Thickness = 2

-- Функции для GunDrop ESP
local function EnableGunDropHighlight()
    -- Здесь добавьте логику для GunDrop Highlight
    
    GunDropHighlightToggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
    GunDropHighlightToggle.Text = "ON"
    GunDropHighlightToggleStroke.Color = Color3.fromRGB(200, 50, 47)
end

local function DisableGunDropHighlight()
    -- Здесь добавьте логику для отключения GunDrop Highlight
    
    GunDropHighlightToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    GunDropHighlightToggle.Text = "OFF"
    GunDropHighlightToggleStroke.Color = Color3.fromRGB(100, 100, 100)
end

local function EnableGunDropEsp()
    -- Здесь добавьте логику для GunDrop Esp
    
    GunDropEspToggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
    GunDropEspToggle.Text = "ON"
    GunDropEspToggleStroke.Color = Color3.fromRGB(200, 50, 47)
end

local function DisableGunDropEsp()
    -- Здесь добавьте логику для отключения GunDrop Esp
    
    GunDropEspToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    GunDropEspToggle.Text = "OFF"
    GunDropEspToggleStroke.Color = Color3.fromRGB(100, 100, 100)
end

-- Обработчики для переключателей GunDrop Highlight
GunDropHighlightToggle.MouseButton1Click:Connect(function()
    GunDropHighlightEnabled = not GunDropHighlightEnabled
    
    if GunDropHighlightEnabled then
        EnableGunDropHighlight()
    else
        DisableGunDropHighlight()
    end
end)

-- Эффекты при наведении на переключатель GunDrop Highlight
GunDropHighlightToggle.MouseEnter:Connect(function()
    if not GunDropHighlightEnabled then
        GunDropHighlightToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

GunDropHighlightToggle.MouseLeave:Connect(function()
    if not GunDropHighlightEnabled then
        GunDropHighlightToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Обработчики для переключателей GunDrop Esp
GunDropEspToggle.MouseButton1Click:Connect(function()
    GunDropEspEnabled = not GunDropEspEnabled
    
    if GunDropEspEnabled then
        EnableGunDropEsp()
    else
        DisableGunDropEsp()
    end
end)

-- Эффекты при наведении на переключатель GunDrop Esp
GunDropEspToggle.MouseEnter:Connect(function()
    if not GunDropEspEnabled then
        GunDropEspToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

GunDropEspToggle.MouseLeave:Connect(function()
    if not GunDropEspEnabled then
        GunDropEspToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-------------------------------------------------------------
-- COMBAT ВКЛАДКА (добавляем только сообщение Soon)
-------------------------------------------------------------

local CombatPage = TabPages["Combat"]

local CombatSoonLabel = Instance.new("TextLabel")
CombatSoonLabel.Parent = CombatPage
CombatSoonLabel.Size = UDim2.new(1, -10, 1, -50)
CombatSoonLabel.Position = UDim2.new(0, 5, 0, 40)
CombatSoonLabel.BackgroundTransparency = 1
CombatSoonLabel.Font = Enum.Font.GothamBold
CombatSoonLabel.Text = "Combat Features\nComing Soon"
CombatSoonLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
CombatSoonLabel.TextSize = 24
CombatSoonLabel.TextTransparency = 0.3
CombatSoonLabel.TextYAlignment = Enum.TextYAlignment.Center

-------------------------------------------------------------
-- EMOTES ВКЛАДКА (добавляем только сообщение Soon)
-------------------------------------------------------------

local EmotesPage = TabPages["Emotes"]

local EmotesSoonLabel = Instance.new("TextLabel")
EmotesSoonLabel.Parent = EmotesPage
EmotesSoonLabel.Size = UDim2.new(1, -10, 1, -50)
EmotesSoonLabel.Position = UDim2.new(0, 5, 0, 40)
EmotesSoonLabel.BackgroundTransparency = 1
EmotesSoonLabel.Font = Enum.Font.GothamBold
EmotesSoonLabel.Text = "Emotes Features\nComing Soon"
EmotesSoonLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
EmotesSoonLabel.TextSize = 24
EmotesSoonLabel.TextTransparency = 0.3
EmotesSoonLabel.TextYAlignment = Enum.TextYAlignment.Center

-------------------------------------------------------------
-- TELEPORT ВКЛАДКА (добавляем только сообщение Soon)
-------------------------------------------------------------

local TeleportPage = TabPages["Teleport"]

local TeleportSoonLabel = Instance.new("TextLabel")
TeleportSoonLabel.Parent = TeleportPage
TeleportSoonLabel.Size = UDim2.new(1, -10, 1, -50)
TeleportSoonLabel.Position = UDim2.new(0, 5, 0, 40)
TeleportSoonLabel.BackgroundTransparency = 1
TeleportSoonLabel.Font = Enum.Font.GothamBold
TeleportSoonLabel.Text = "Teleport Features\nComing Soon"
TeleportSoonLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
TeleportSoonLabel.TextSize = 24
TeleportSoonLabel.TextTransparency = 0.3
TeleportSoonLabel.TextYAlignment = Enum.TextYAlignment.Center

-------------------------------------------------------------
-- MISC РАЗДЕЛ С ANTI AFK, REJOIN И SERVER HOP
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

-- Текст Anti AFK
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

-- Переключатель Anti AFK
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

-- Добавляем звук при нажатии на переключатель Anti AFK
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

-- Кнопка Rejoin
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

-- Добавляем звук при нажатии на кнопку Rejoin
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

-- Кнопка Server Hop
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

-- Добавляем звук при нажатии на кнопку Server Hop
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

-- Функции для кнопок
local function RejoinGame()
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    local success, error = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, Player)
    end)
    
    if not success then
        RejoinButton.Text = "Rejoin Server"
    end
end

local function ServerHop()
    local placeId = game.PlaceId
    
    -- Получаем список серверов
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
                ServerHopButton.Text = "Server Hop"
            end
        else
            ServerHopButton.Text = "Server Hop"
        end
    else
        ServerHopButton.Text = "Server Hop"
    end
end

-- Обработчики нажатий кнопок
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

-- Эффекты при наведении на кнопки
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

-- Функция Anti AFK
local function EnableAntiAFK()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
    end
    
    AntiAFKConnection = Players.LocalPlayer.Idled:Connect(function()
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

-- Обработчик переключателя Anti AFK
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

-- Добавляем звук при нажатии на кнопку скрытия/показа
ClickButton.MouseButton1Click:Connect(function()
    playButtonSound()
end)

local isVisible = true
ClickButton.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    MainFrame.Visible = isVisible
end)
