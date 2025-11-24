--[[
    Shadow Script UI для Murder Mystery 2
    Интерфейс с вкладками, перетаскиванием, переключением страниц.
    Обновление: Anti AFK, Rejoin и Server Hop в разделе Misc
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShadowUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

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

local Tabs = {"Main", "Visual", "Combat", "Emotes", "Misc"}
local TabButtons = {}
local TabPages = {}

local PageContainer = Instance.new("Frame")
PageContainer.Parent = MainFrame
PageContainer.BackgroundTransparency = 1
PageContainer.Position = UDim2.new(0.04, 0, 0.19, 0)
PageContainer.Size = UDim2.new(0.6, 0, 0.75, 0)

local TabsContainer = Instance.new("Frame")
TabsContainer.Parent = MainFrame
TabsContainer.BackgroundTransparency = 1
TabsContainer.Position = UDim2.new(0.70, 0, 0.19, 0)
TabsContainer.Size = UDim2.new(0.27, 0, 0.75, 0)

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
    Page.Parent = PageContainer
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    local Label = Instance.new("TextLabel")
    Label.Parent = Page
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.BackgroundTransparency = 1
    Label.Text = tabName .. " Page"
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 18

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
    if typeof(identifyexecutor) == "function" then
        executor = identifyexecutor()
    elseif typeof(getexecutorname) == "function" then
        executor = getexecutorname()
    elseif syn then
        executor = "Synapse X"
    end
end)

NewInfo("Username", Player.Name, 0)
NewInfo("Display Name", Player.DisplayName, 1)
NewInfo("Roblox Version", tostring(version()), 2)
NewInfo("Executor", executor, 3)

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

local ServerHopCorner = Instance.new("UICorner")
ServerHopCorner.CornerRadius = UDim.new(0, 8)
ServerHopCorner.Parent = ServerHopButton

local ServerHopStroke = Instance.new("UIStroke")
ServerHopStroke.Parent = ServerHopButton
ServerHopStroke.Color = Color3.fromRGB(200, 50, 47)
ServerHopStroke.Thickness = 2

-- Функции для кнопок
local function RejoinGame()
    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    TeleportService:TeleportToPlaceInstance(placeId, jobId, Player)
end

local function ServerHop()
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local placeId = game.PlaceId
    
    -- Получаем список серверов
    local servers = {}
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server)
            end
        end
        
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(placeId, randomServer.id, Player)
        else
            warn("No available servers found for server hop")
        end
    else
        warn("Failed to get server list")
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
    
    AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
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
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleParentFrame

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(230, 57, 51)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleParentFrame

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

local isVisible = true
ClickButton.MouseButton1Click:Connect(function()
	isVisible = not isVisible
	MainFrame.Visible = isVisible
end)