if not game:IsLoaded() then game.Loaded:Wait() end

-- Службы
local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    TeleportService = game:GetService("TeleportService"),
    HttpService = game:GetService("HttpService"),
    VirtualUser = game:GetService("VirtualUser"),
    SoundService = game:GetService("SoundService"),
    TweenService = game:GetService("TweenService"),
    Workspace = game:GetService("Workspace"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    CollectionService = game:GetService("CollectionService"),
    CoreGui = game:GetService("CoreGui"),
    Debris = game:GetService("Debris"),
    MarketplaceService = game:GetService("MarketplaceService")
}

local Player = Services.Players.LocalPlayer
local LP = Player
local CoinCollected = Services.ReplicatedStorage.Remotes.Gameplay.CoinCollected
local RoundStart = Services.ReplicatedStorage.Remotes.Gameplay.RoundStart
local RoundEnd = Services.ReplicatedStorage.Remotes.Gameplay.RoundEndFade

-- Состояния
local States = {
    autoResetEnabled = false,
    bag_full = false,
    resetting = false,
    start_position = nil,
    farming = false,
    gunDropESPToggled = false,
    shootMurdererEnabled = false,
    shootMurdererFrameSize = 10  -- Размер фрейма от 5 до 20, по умолчанию 10
}

-- Вспомогательные функции
local function playButtonSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://140910211"
    sound.Volume = 1.5
    sound.Parent = Services.SoundService
    sound:Play()
    Services.Debris:AddItem(sound, 2)
end

-- Создание элементов интерфейса
local function createElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            element[prop] = value
        end
    end
    return element
end

-- Создание UI элементов с общими свойствами
local function createUIElement(className, parent, properties)
    local element = createElement(className, properties)
    element.Parent = parent
    return element
end

-- Основной GUI
local ScreenGui = createUIElement("ScreenGui", Services.CoreGui, {
    Name = "ShadowUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 10  -- Высокий DisplayOrder для основного UI
})

local MainFrame = createUIElement("Frame", ScreenGui, {
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 500, 0, 300),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0)
})

createUIElement("UICorner", MainFrame, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", MainFrame, {
    Color = Color3.fromRGB(230, 57, 51),
    Thickness = 1.8,
    Transparency = 0.05
})

-- Заголовок
local TitleContainer = createUIElement("Frame", MainFrame, {
    BackgroundTransparency = 1,
    Position = UDim2.new(0.04, 0, 0.05, 0),
    Size = UDim2.new(0.9, 0, 0, 25)
})

local TitleIcon = createUIElement("ImageLabel", TitleContainer, {
    Size = UDim2.new(0, 25, 0, 25),
    BackgroundTransparency = 1,
    Image = "rbxthumb://type=Asset&id=93388705336185&w=420&h=420",
    ImageColor3 = Color3.fromRGB(230, 57, 51)
})

local Title = createUIElement("TextLabel", TitleContainer, {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 30, 0, 0),
    Size = UDim2.new(1, -30, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "Shadow Script | Murder Mystery 2",
    TextColor3 = Color3.fromRGB(230, 57, 51),
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left
})

createUIElement("Frame", MainFrame, {
    BackgroundColor3 = Color3.fromRGB(230, 57, 51),
    BorderSizePixel = 0,
    Size = UDim2.new(0.92, 0, 0, 1),
    Position = UDim2.new(0.04, 0, 0.155, 0)
})

-- Вкладки
local Tabs = {"Main", "Visual", "Combat", "Emotes", "Teleport", "Auto Farm", "Misc"}
local TabButtons = {}
local TabPages = {}

local PageScrollFrame = createUIElement("ScrollingFrame", MainFrame, {
    BackgroundTransparency = 1,
    Position = UDim2.new(0.04, 0, 0.19, 0),
    Size = UDim2.new(0.6, 0, 0.75, 0),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(230, 57, 51),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})

local TabsScrollFrame = createUIElement("ScrollingFrame", MainFrame, {
    BackgroundTransparency = 1,
    Position = UDim2.new(0.70, 0, 0.19, 0),
    Size = UDim2.new(0.27, 0, 0.75, 0),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(230, 57, 51),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})

local TabsContainer = createUIElement("Frame", TabsScrollFrame, {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y
})

createUIElement("UIListLayout", TabsContainer, {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
})

-- Функция обновления вида кнопок
local function UpdateButtonVisual(button, isActive)
    button.BackgroundTransparency = isActive and 0 or 0.1
    button.BackgroundColor3 = isActive and Color3.fromRGB(20,20,20) or Color3.fromRGB(15,15,15)
    
    local stroke = button:FindFirstChild("ButtonStroke")
    if stroke then
        stroke.Thickness = isActive and 3 or 2
        stroke.Color = isActive and Color3.fromRGB(230,57,51) or Color3.fromRGB(200,50,47)
    end
end

-- Таблица иконок для вкладок
local tabIcons = {
    ["Main"] = "rbxthumb://type=Asset&id=72808987642452&w=420&h=420",
    ["Visual"] = "rbxthumb://type=Asset&id=134788157396683&w=420&h=420",
    ["Combat"] = "rbxthumb://type=Asset&id=125724093327848&w=420&h=420",
    ["Emotes"] = "rbxthumb://type=Asset&id=133473827960783&w=420&h=420",
    ["Teleport"] = "rbxthumb://type=Asset&id=115511057783647&w=420&h=420",
    ["Auto Farm"] = "rbxthumb://type=Asset&id=114528728360623&w=420&h=420",
    ["Misc"] = "rbxthumb://type=Asset&id=118821455550069&w=420&h=420"
}

-- Создание кнопок вкладок
for i, tabName in ipairs(Tabs) do
    local Button = createUIElement("TextButton", TabsContainer, {
        Name = tabName .. "_TabButton",
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Text = tabName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        RichText = false,
        AutoButtonColor = false,
        LayoutOrder = i
    })

    Button.MouseButton1Click:Connect(playButtonSound)

    -- Добавление иконки
    local iconId = tabIcons[tabName]
    if iconId then
        createUIElement("ImageLabel", Button, {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0.5, -10),
            BackgroundTransparency = 1,
            Image = iconId
        })
    end

    -- Стилизация кнопки
    createUIElement("UICorner", Button, {CornerRadius = UDim.new(0, 15)})
    createUIElement("UIStroke", Button, {
        Name = "ButtonStroke",
        Color = Color3.fromRGB(200,50,47),
        Thickness = 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    -- Создание страницы
    local Page = createUIElement("Frame", PageScrollFrame, {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.Y
    })

    TabButtons[tabName] = Button
    TabPages[tabName] = Page
end

-- Переключение вкладок
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

-- Обработчики кнопок вкладок
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

-- Страница Main
local MainPage = TabPages["Main"]

-- Заголовок для Main страницы
createUIElement("TextLabel", MainPage, {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "Main Page",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Position = UDim2.new(0, 0, 0, 0)
})

local ProfileContainer = createUIElement("Frame", MainPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 0, 120),
    Position = UDim2.new(0, 0, 0, 40)
})

createUIElement("UICorner", ProfileContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", ProfileContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

local Avatar = createUIElement("ImageLabel", ProfileContainer, {
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 90, 0, 90),
    Position = UDim2.new(0, 10, 0, 15),
    Image = "rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=420&h=420"
})

createUIElement("UICorner", Avatar, {CornerRadius = UDim.new(0, 8)})

local Info = createUIElement("Frame", ProfileContainer, {
    Size = UDim2.new(1, -120, 1, -20),
    Position = UDim2.new(0, 110, 0, 10),
    BackgroundTransparency = 1
})

-- Функция добавления информации
local function NewInfo(name, value, order)
    return createUIElement("TextLabel", Info, {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, order * 22),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Text = name .. ": " .. value
    })
end

-- Информация об исполнителе
local executor = "Unknown"
pcall(function()
    local executors = {
        {func = identifyexecutor, type = "function"},
        {func = getexecutorname, type = "function"},
        {check = syn, name = "Synapse X"},
        {check = PROTOSMASHER_LOADED, name = "ProtoSmasher"},
        {check = KRNL_LOADED, name = "Krnl"}
    }
    
    for _, exec in ipairs(executors) do
        if exec.func and type(exec.func) == exec.type then
            executor = exec.func()
            break
        elseif exec.check then
            executor = exec.name
            break
        end
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

-- Speed and Jump Sliders Container
local SpeedJumpContainer = createUIElement("Frame", MainPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 0, 170),
    Position = UDim2.new(0, 0, 0, 170)
})

createUIElement("UICorner", SpeedJumpContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", SpeedJumpContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

-- Speed Slider
local SpeedContainer = createUIElement("Frame", SpeedJumpContainer, {
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -20, 0, 45),
    Position = UDim2.new(0, 10, 0, 10)
})

createUIElement("UICorner", SpeedContainer, {CornerRadius = UDim.new(0, 8)})

local SpeedLabel = createUIElement("TextLabel", SpeedContainer, {
    Size = UDim2.new(0.6, 0, 0, 20),
    Position = UDim2.new(0, 10, 0, 5),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Speed: 16",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

local speedSliderFrame = createUIElement("Frame", SpeedContainer, {
    Size = UDim2.new(0.9, 0, 0, 15),
    Position = UDim2.new(0.05, 0, 0, 25),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0
})

createUIElement("UICorner", speedSliderFrame, {CornerRadius = UDim.new(0, 7)})

local speedSliderTrack = createUIElement("Frame", speedSliderFrame, {
    Size = UDim2.new(0.08, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(230, 57, 51),
    BorderSizePixel = 0
})

createUIElement("UICorner", speedSliderTrack, {CornerRadius = UDim.new(0, 7)})

local speedSliderButton = createUIElement("TextButton", speedSliderFrame, {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(0.08, -10, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false
})

createUIElement("UICorner", speedSliderButton, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", speedSliderButton, {
    Color = Color3.fromRGB(200, 200, 200),
    Thickness = 2
})

-- Jump Slider
local JumpContainer = createUIElement("Frame", SpeedJumpContainer, {
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -20, 0, 45),
    Position = UDim2.new(0, 10, 0, 65)
})

createUIElement("UICorner", JumpContainer, {CornerRadius = UDim.new(0, 8)})

local JumpLabel = createUIElement("TextLabel", JumpContainer, {
    Size = UDim2.new(0.6, 0, 0, 20),
    Position = UDim2.new(0, 10, 0, 5),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Jump: 50",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

local jumpSliderFrame = createUIElement("Frame", JumpContainer, {
    Size = UDim2.new(0.9, 0, 0, 15),
    Position = UDim2.new(0.05, 0, 0, 25),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0
})

createUIElement("UICorner", jumpSliderFrame, {CornerRadius = UDim.new(0, 7)})

local jumpSliderTrack = createUIElement("Frame", jumpSliderFrame, {
    Size = UDim2.new(0.25, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(230, 57, 51),
    BorderSizePixel = 0
})

createUIElement("UICorner", jumpSliderTrack, {CornerRadius = UDim.new(0, 7)})

local jumpSliderButton = createUIElement("TextButton", jumpSliderFrame, {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(0.25, -10, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false
})

createUIElement("UICorner", jumpSliderButton, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", jumpSliderButton, {
    Color = Color3.fromRGB(200, 200, 200),
    Thickness = 2
})

-- Reset Button
local ResetButton = createUIElement("TextButton", SpeedJumpContainer, {
    Size = UDim2.new(0.9, 0, 0, 35),
    Position = UDim2.new(0.05, 0, 0, 120),
    BackgroundColor3 = Color3.fromRGB(230, 57, 51),
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    Text = "Reset",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    AutoButtonColor = false
})

ResetButton.MouseButton1Click:Connect(playButtonSound)

createUIElement("UICorner", ResetButton, {CornerRadius = UDim.new(0, 8)})
createUIElement("UIStroke", ResetButton, {
    Color = Color3.fromRGB(200, 50, 47),
    Thickness = 2
})

-- Hover эффекты для Reset Button
ResetButton.MouseEnter:Connect(function()
    ResetButton.BackgroundColor3 = Color3.fromRGB(210, 47, 41)
end)

ResetButton.MouseLeave:Connect(function()
    ResetButton.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
end)

-- Функции для обновления значений слайдеров
local function updateSpeedSlider(value)
    -- Ограничиваем значение от 0 до 1
    local normalizedValue = math.clamp(value, 0, 1)
    
    -- Обновляем визуальные элементы
    speedSliderTrack.Size = UDim2.new(normalizedValue, 0, 1, 0)
    speedSliderButton.Position = UDim2.new(normalizedValue, -10, 0.5, -10)
    
    -- Обновляем текст (от 1 до 200)
    local speedValue = math.floor(1 + normalizedValue * 199)
    SpeedLabel.Text = "Speed: " .. speedValue
    
    -- ЛОГИКА ИЗ ПРИВЕДЕННОГО КОДА: Изменяем скорость персонажа
    if Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedValue
        end
    end
end

local function updateJumpSlider(value)
    -- Ограничиваем значение от 0 до 1
    local normalizedValue = math.clamp(value, 0, 1)
    
    -- Обновляем визуальные элементы
    jumpSliderTrack.Size = UDim2.new(normalizedValue, 0, 1, 0)
    jumpSliderButton.Position = UDim2.new(normalizedValue, -10, 0.5, -10)
    
    -- Обновляем текст (от 1 до 200)
    local jumpValue = math.floor(1 + normalizedValue * 199)
    JumpLabel.Text = "Jump: " .. jumpValue
    
    -- ЛОГИКА ИЗ ПРИВЕДЕННОГО КОДА: Изменяем прыжок персонажа
    if Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = jumpValue
        end
    end
end

-- Переменные для отслеживания перетаскивания
local draggingSpeed = false
local draggingJump = false
local currentTouchId = nil

-- Функции для работы со слайдерами (работают на ПК и телефоне)
local function beginDrag(sliderType, input)
    -- Проверяем тип ввода
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Для мыши
        if sliderType == "speed" then
            draggingSpeed = true
        else
            draggingJump = true
        end
        return true
    elseif input.UserInputType == Enum.UserInputType.Touch then
        -- Для телефона
        if currentTouchId == nil then
            currentTouchId = input
            if sliderType == "speed" then
                draggingSpeed = true
            else
                draggingJump = true
            end
            return true
        end
    end
    return false
end

local function endDrag(sliderType, input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if sliderType == "speed" then
            draggingSpeed = false
        else
            draggingJump = false
        end
        currentTouchId = nil
    elseif input.UserInputType == Enum.UserInputType.Touch then
        -- Проверяем, что это тот же тач
        if currentTouchId == input then
            if sliderType == "speed" then
                draggingSpeed = false
            else
                draggingJump = false
            end
            currentTouchId = nil
        end
    end
end

local function updateSliderPosition(sliderType, input)
    -- Проверяем, какой слайдер активен
    local isDragging = false
    local sliderFrame = nil
    local updateFunction = nil
    
    if sliderType == "speed" then
        isDragging = draggingSpeed
        sliderFrame = speedSliderFrame
        updateFunction = updateSpeedSlider
    else
        isDragging = draggingJump
        sliderFrame = jumpSliderFrame
        updateFunction = updateJumpSlider
    end
    
    if not isDragging then return end
    
    -- Для тача проверяем, что это тот же тач
    if input.UserInputType == Enum.UserInputType.Touch and currentTouchId ~= input then
        return
    end
    
    -- Вычисляем относительную позицию
    local relativeX = (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X
    updateFunction(relativeX)
end

-- Обработчики для Speed Slider
speedSliderButton.InputBegan:Connect(function(input)
    if beginDrag("speed", input) then
        playButtonSound()
    end
end)

speedSliderButton.InputEnded:Connect(function(input)
    endDrag("speed", input)
end)

speedSliderFrame.InputBegan:Connect(function(input)
    if beginDrag("speed", input) then
        playButtonSound()
        updateSliderPosition("speed", input)
    end
end)

speedSliderFrame.InputEnded:Connect(function(input)
    endDrag("speed", input)
end)

-- Обработчики для Jump Slider
jumpSliderButton.InputBegan:Connect(function(input)
    if beginDrag("jump", input) then
        playButtonSound()
    end
end)

jumpSliderButton.InputEnded:Connect(function(input)
    endDrag("jump", input)
end)

jumpSliderFrame.InputBegan:Connect(function(input)
    if beginDrag("jump", input) then
        playButtonSound()
        updateSliderPosition("jump", input)
    end
end)

jumpSliderFrame.InputEnded:Connect(function(input)
    endDrag("jump", input)
end)

-- Обработка перемещения
Services.UserInputService.InputChanged:Connect(function(input)
    if draggingSpeed then
        updateSliderPosition("speed", input)
    end
    if draggingJump then
        updateSliderPosition("jump", input)
    end
end)

-- Обработка окончания тача
Services.UserInputService.TouchEnded:Connect(function(input)
    if currentTouchId == input then
        if draggingSpeed then
            endDrag("speed", input)
        end
        if draggingJump then
            endDrag("jump", input)
        end
    end
end)

-- Улучшаем отзывчивость для телефона
speedSliderButton.Active = true
speedSliderButton.Selectable = true
speedSliderFrame.Active = true

jumpSliderButton.Active = true
jumpSliderButton.Selectable = true
jumpSliderFrame.Active = true

-- Функция сброса слайдеров
ResetButton.MouseButton1Click:Connect(function()
    -- Сброс Speed слайдера
    updateSpeedSlider(0.075) -- 16/200 ≈ 0.08
    updateJumpSlider(0.246)  -- 50/200 ≈ 0.25
end)

-- Эффекты при наведении на кнопки слайдеров (только для ПК)
speedSliderButton.MouseEnter:Connect(function()
    if not draggingSpeed then
        speedSliderButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    end
end)

speedSliderButton.MouseLeave:Connect(function()
    if not draggingSpeed then
        speedSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

jumpSliderButton.MouseEnter:Connect(function()
    if not draggingJump then
        jumpSliderButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    end
end)

jumpSliderButton.MouseLeave:Connect(function()
    if not draggingJump then
        jumpSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Применяем настройки при появлении нового персонажа (ЛОГИКА ИЗ ПРИВЕДЕННОГО КОДА)
Player.CharacterAdded:Connect(function(character)
    task.wait(0.5) -- Ждем загрузки персонажа
    
    -- Восстанавливаем сохраненные значения скорости и прыжка
    local speedValue = tonumber(SpeedLabel.Text:match("%d+")) or 16
    local jumpValue = tonumber(JumpLabel.Text:match("%d+")) or 50
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedValue
        humanoid.JumpPower = jumpValue
    end
end)

-- Инициализация текущего персонажа
if Player.Character then
    local speedValue = tonumber(SpeedLabel.Text:match("%d+")) or 16
    local jumpValue = tonumber(JumpLabel.Text:match("%d+")) or 50
    
    local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedValue
        humanoid.JumpPower = jumpValue
    end
end

-- Auto Farm Page
local AutoFarmPage = TabPages["Auto Farm"]

-- Заголовок для Auto Farm страницы
createUIElement("TextLabel", AutoFarmPage, {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "Auto Farm Features",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Position = UDim2.new(0, 0, 0, 0)
})

-- Вспомогательные функции для персонажа
local function getCharacter() 
    return Player.Character or Player.CharacterAdded:Wait() 
end

local function getHRP() 
    return getCharacter():WaitForChild("HumanoidRootPart") 
end

-- Обработчики событий
CoinCollected.OnClientEvent:Connect(function(_, current, max)
    if current == max and not States.resetting and States.autoResetEnabled then
        States.resetting = true
        States.bag_full = true
        
        local hrp = getHRP()
        
        if States.start_position then
            local tween = Services.TweenService:Create(
                hrp, 
                TweenInfo.new(2, Enum.EasingStyle.Linear), 
                {CFrame = States.start_position}
            )
            tween:Play()
            tween.Completed:Wait()
        end
        
        task.wait(0.5)
        Player.Character.Humanoid.Health = 0
        Player.CharacterAdded:Wait()
        task.wait(1.5)
        
        States.resetting = false
        States.bag_full = false
    end
end)

RoundStart.OnClientEvent:Connect(function()
    States.farming = true
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        States.start_position = Player.Character.HumanoidRootPart.CFrame
    end
end)

RoundEnd.OnClientEvent:Connect(function()
    States.farming = false
end)

-- Создание переключателей
local function createToggle(parent, name, position, defaultState, callback)
    local Container = createUIElement("Frame", parent, {
        BackgroundColor3 = Color3.fromRGB(20,20,20),
        BackgroundTransparency = 0.1,
        Size = UDim2.new(1, -10, 0, 50),
        Position = position
    })

    createUIElement("UICorner", Container, {CornerRadius = UDim.new(0, 10)})
    createUIElement("UIStroke", Container, {
        Color = Color3.fromRGB(230,57,51),
        Thickness = 1.8
    })

    createUIElement("TextLabel", Container, {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Toggle = createUIElement("TextButton", Container, {
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(1, -70, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Text = "OFF",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = false
    })

    Toggle.MouseButton1Click:Connect(playButtonSound)

    createUIElement("UICorner", Toggle, {CornerRadius = UDim.new(0, 15)})
    local ToggleStroke = createUIElement("UIStroke", Toggle, {
        Color = Color3.fromRGB(100, 100, 100),
        Thickness = 2
    })

    local state = defaultState or false
    
    local function updateToggle()
        if state then
            Toggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
            Toggle.Text = "ON"
            ToggleStroke.Color = Color3.fromRGB(200, 50, 47)
        else
            Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Toggle.Text = "OFF"
            ToggleStroke.Color = Color3.fromRGB(100, 100, 100)
        end
    end

    updateToggle()

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        if callback then callback(state) end
    end)

    Toggle.MouseEnter:Connect(function()
        if not state then
            Toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
    end)

    Toggle.MouseLeave:Connect(function()
        if not state then
            Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)

    return Toggle, function() return state end
end

-- Coin Autofarm
local CoinAutofarmToggle, getCoinAutofarmState = createToggle(AutoFarmPage, "Coin Autofarm", UDim2.new(0, 0, 0, 40), false)

-- Auto Reset
local AutoResetToggle, getAutoResetState = createToggle(AutoFarmPage, "Auto Reset", UDim2.new(0, 0, 0, 100), false, function(state)
    States.autoResetEnabled = state
end)

-- Auto Farm логика
local AutoFarmRunning = false
local farmConnection

local function get_nearest_coin()
    local hrp = getHRP()
    local closest, dist = nil, math.huge
    
    for _, m in pairs(Services.Workspace:GetChildren()) do
        if m:FindFirstChild("CoinContainer") then
            for _, coin in pairs(m.CoinContainer:GetChildren()) do
                if coin:IsA("BasePart") and coin:FindFirstChild("TouchInterest") then
                    local d = (hrp.Position - coin.Position).Magnitude
                    if d < dist then 
                        closest, dist = coin, d 
                    end
                end
            end
        end
    end
    return closest, dist
end

local function StartAutoFarm()
    if AutoFarmRunning then return end
    
    AutoFarmRunning = true
    
    farmConnection = task.spawn(function()
        while getCoinAutofarmState() and AutoFarmRunning do
            if States.farming and not States.bag_full then
                local coin, dist = get_nearest_coin()
                if coin then
                    local hrp = getHRP()
                    if dist > 150 then
                        hrp.CFrame = coin.CFrame
                    else
                        local tween = Services.TweenService:Create(hrp, TweenInfo.new(dist / 20, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
                        tween:Play()
                        
                        repeat 
                            task.wait(0.1) 
                        until not coin:FindFirstChild("TouchInterest") or not States.farming or not getCoinAutofarmState()
                        
                        tween:Cancel()
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end

local function StopAutoFarm()
    AutoFarmRunning = false
    
    if farmConnection then
        task.cancel(farmConnection)
        farmConnection = nil
    end
end

-- Обновление состояния Coin Autofarm
CoinAutofarmToggle:GetPropertyChangedSignal("Text"):Connect(function()
    if getCoinAutofarmState() then
        StartAutoFarm()
    else
        StopAutoFarm()
    end
end)

-- Anti-AFK
Player.Idled:Connect(function()
    Services.VirtualUser:CaptureController()
    Services.VirtualUser:ClickButton2(Vector2.new())
end)

-- Обработчики персонажа
Player.CharacterAdded:Connect(function()
    task.wait(1)
    
    if getCoinAutofarmState() and AutoFarmRunning then
        StopAutoFarm()
        task.wait(0.5)
        if getCoinAutofarmState() then
            StartAutoFarm()
        end
    end
    
    States.resetting = false
    States.bag_full = false
end)

-- Обработчики фокуса окна
Services.UserInputService.WindowFocusReleased:Connect(function()
    if getCoinAutofarmState() then
        StopAutoFarm()
    end
end)

Services.UserInputService.WindowFocused:Connect(function()
    if getCoinAutofarmState() and not AutoFarmRunning then
        StartAutoFarm()
    end
end)

-- Visual Page
local VisualPage = TabPages["Visual"]

-- Заголовок для Visual страницы
createUIElement("TextLabel", VisualPage, {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "Visual Features",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Position = UDim2.new(0, 0, 0, 0)
})

-- ESP Highlight (ИСПРАВЛЕННАЯ ВЕРСИЯ - работает как в примере)
local EspHighlightContainer = createUIElement("Frame", VisualPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 0, 240),
    Position = UDim2.new(0, 0, 0, 40)
})

createUIElement("UICorner", EspHighlightContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", EspHighlightContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

createUIElement("TextLabel", EspHighlightContainer, {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "ESP Highlight",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- ESP состояния
local EspStates = {
    Enabled = false,
    Innocent = true,
    Murder = true,
    Sheriff = true,
    Hero = true
}

-- Глобальные переменные для ролей (как в примере)
local Murder = ""
local Sheriff = ""
local Hero = ""
local roles = {}

-- ESP функции (как в примере)
function CreateHighlight() -- make any new highlights for new players
    if not EspStates.Enabled then return end
    
    for i, v in pairs(Services.Players:GetChildren()) do
        if v ~= LP and v.Character and not v.Character:FindFirstChild("ShadowHighlight") then
            local Highlight = Instance.new("Highlight")
            Highlight.Name = "ShadowHighlight"
            Highlight.Adornee = v.Character
            Highlight.FillTransparency = 0.7
            Highlight.OutlineTransparency = 0.3
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.Parent = v.Character
        end
    end
end

function UpdateHighlights() -- Get Current Role Colors (как в примере)
    if not EspStates.Enabled then return end
    
    for _, v in pairs(Services.Players:GetChildren()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("ShadowHighlight") then
            local Highlight = v.Character:FindFirstChild("ShadowHighlight")
            
            if v.Name == Murder and IsAlive(v) then
                Highlight.FillColor = Color3.fromRGB(225, 0, 0)
                Highlight.OutlineColor = Color3.fromRGB(225, 0, 0)
                Highlight.Enabled = EspStates.Murder
            elseif v.Name == Sheriff and IsAlive(v) then
                Highlight.FillColor = Color3.fromRGB(0, 0, 225)
                Highlight.OutlineColor = Color3.fromRGB(0, 0, 225)
                Highlight.Enabled = EspStates.Sheriff
            elseif v.Name == Hero and IsAlive(v) and not IsAlive(game.Players[Sheriff]) then
                Highlight.FillColor = Color3.fromRGB(255, 250, 0)
                Highlight.OutlineColor = Color3.fromRGB(255, 250, 0)
                Highlight.Enabled = EspStates.Hero
            else
                Highlight.FillColor = Color3.fromRGB(0, 225, 0)
                Highlight.OutlineColor = Color3.fromRGB(0, 225, 0)
                Highlight.Enabled = EspStates.Innocent
            end
        end
    end
end

function IsAlive(Player) -- Simple sexy function (как в примере)
    if roles and roles[Player.Name] then
        local playerData = roles[Player.Name]
        if not playerData.Killed and not playerData.Dead then
            return true
        else
            return false
        end
    end
    return false
end

-- Создание переключателей ESP
local espToggles = {
    {"Innocent", UDim2.new(0, 0, 0, 40), "Innocent"},
    {"Murder", UDim2.new(0, 0, 0, 80), "Murder"},
    {"Sheriff", UDim2.new(0, 0, 0, 120), "Sheriff"},
    {"Hero", UDim2.new(0, 0, 0, 160), "Hero"}
}

local function createEspToggle(name, position, stateKey)
    local Container = createUIElement("Frame", EspHighlightContainer, {
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        BackgroundTransparency = 0.1,
        Size = UDim2.new(1, -20, 0, 35),
        Position = position
    })

    createUIElement("UICorner", Container, {CornerRadius = UDim.new(0, 8)})
    createUIElement("UIStroke", Container, {
        Color = Color3.fromRGB(60,60,60),
        Thickness = 1
    })

    createUIElement("TextLabel", Container, {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Toggle = createUIElement("TextButton", Container, {
        Size = UDim2.new(0, 60, 0, 25),
        Position = UDim2.new(1, -70, 0.5, -12.5),
        BackgroundColor3 = EspStates[stateKey] and Color3.fromRGB(230, 57, 51) or Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Text = EspStates[stateKey] and "ON" or "OFF",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = false
    })

    Toggle.MouseButton1Click:Connect(playButtonSound)

    createUIElement("UICorner", Toggle, {CornerRadius = UDim.new(0, 12)})
    local ToggleStroke = createUIElement("UIStroke", Toggle, {
        Color = EspStates[stateKey] and Color3.fromRGB(200, 50, 47) or Color3.fromRGB(100, 100, 100),
        Thickness = 2
    })

    Toggle.MouseButton1Click:Connect(function()
        EspStates[stateKey] = not EspStates[stateKey]
        Toggle.BackgroundColor3 = EspStates[stateKey] and Color3.fromRGB(230, 57, 51) or Color3.fromRGB(50, 50, 50)
        Toggle.Text = EspStates[stateKey] and "ON" or "OFF"
        ToggleStroke.Color = EspStates[stateKey] and Color3.fromRGB(200, 50, 47) or Color3.fromRGB(100, 100, 100)
        if EspStates.Enabled then
            UpdateHighlights()
        end
    end)

    return Toggle
end

-- Создание всех ESP переключателей
local toggleButtons = {}
for _, toggleInfo in ipairs(espToggles) do
    toggleButtons[toggleInfo[3]] = createEspToggle(toggleInfo[1], toggleInfo[2], toggleInfo[3])
end

-- Главный переключатель ESP
local MainToggleContainer = createUIElement("Frame", EspHighlightContainer, {
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -20, 0, 35),
    Position = UDim2.new(0, 0, 0, 200)
})

createUIElement("UICorner", MainToggleContainer, {CornerRadius = UDim.new(0, 8)})
createUIElement("UIStroke", MainToggleContainer, {
    Color = Color3.fromRGB(60,60,60),
    Thickness = 1
})

createUIElement("TextLabel", MainToggleContainer, {
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Enable ESP",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

local MainToggle = createUIElement("TextButton", MainToggleContainer, {
    Size = UDim2.new(0, 60, 0, 25),
    Position = UDim2.new(1, -70, 0.5, -12.5),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0,
    Text = "OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false
})

MainToggle.MouseButton1Click:Connect(playButtonSound)

createUIElement("UICorner", MainToggle, {CornerRadius = UDim.new(0, 12)})
local MainToggleStroke = createUIElement("UIStroke", MainToggle, {
    Color = Color3.fromRGB(100, 100, 100),
    Thickness = 2
})

MainToggle.MouseButton1Click:Connect(function()
    EspStates.Enabled = not EspStates.Enabled
    MainToggle.BackgroundColor3 = EspStates.Enabled and Color3.fromRGB(230, 57, 51) or Color3.fromRGB(50, 50, 50)
    MainToggle.Text = EspStates.Enabled and "ON" or "OFF"
    MainToggleStroke.Color = EspStates.Enabled and Color3.fromRGB(200, 50, 47) or Color3.fromRGB(100, 100, 100)
    
    if EspStates.Enabled then
        -- Запускаем ESP систему
        CreateHighlight()
        UpdateHighlights()
    else
        -- Очищаем все подсветки
        for _, v in pairs(Services.Players:GetChildren()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("ShadowHighlight") then
                v.Character.ShadowHighlight:Destroy()
            end
        end
    end
end)

-- Основной цикл обновления ESP (как в примере)
Services.RunService.RenderStepped:Connect(function()
    if EspStates.Enabled then
        -- Получаем роли
        local success, result = pcall(function()
            return Services.ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        end)
        
        if success then
            roles = result
            
            -- Обновляем имена ролей
            for i, v in pairs(roles) do
                if v.Role == "Murderer" then
                    Murder = i
                elseif v.Role == 'Sheriff' then
                    Sheriff = i
                elseif v.Role == 'Hero' then
                    Hero = i
                end
            end
            
            CreateHighlight()
            UpdateHighlights()
        end
    end
end)

-- Очистка ESP при выходе игрока
Services.Players.PlayerRemoving:Connect(function(player)
    if player ~= LP and player.Character and player.Character:FindFirstChild("ShadowHighlight") then
        player.Character.ShadowHighlight:Destroy()
    end
end)

-- GunDrop ESP функции
local function highlightGunDrop(part)
    if part and not part:FindFirstChild("ShadowGunDropESP") then
        local billboardGui = createElement("BillboardGui", {
            Name = "ShadowGunDropESP",
            Size = UDim2.new(0, 120, 0, 40),
            StudsOffset = Vector3.new(0, 3, 0),
            AlwaysOnTop = true,
            MaxDistance = 200,
            Enabled = States.gunDropESPToggled,
            Adornee = part
        })
        
        createUIElement("TextLabel", billboardGui, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "🔫 Dropped Gun",
            TextColor3 = Color3.fromRGB(255, 50, 50),
            TextStrokeTransparency = 0,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            TextScaled = true,
            Font = Enum.Font.GothamBold,
            ZIndex = 10
        })
        
        billboardGui.Parent = part
    end
end

local function stopGunDropESP()
    for _, gunDrop in pairs(Services.CollectionService:GetTagged("GunDrop")) do
        local espGui = gunDrop:FindFirstChild("ShadowGunDropESP")
        if espGui then
            espGui:Destroy()
        end
    end
end

local function startGunDropESP()
    for _, gunDrop in pairs(Services.CollectionService:GetTagged("GunDrop")) do
        highlightGunDrop(gunDrop)
    end
end

-- GunDrop ESP UI
local GunDropEspContainer = createUIElement("Frame", VisualPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 0, 100),
    Position = UDim2.new(0, 0, 0, 290)
})

createUIElement("UICorner", GunDropEspContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", GunDropEspContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

createUIElement("TextLabel", GunDropEspContainer, {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "GunDrop ESP",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
})

local GunDropEspToggleContainer = createUIElement("Frame", GunDropEspContainer, {
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -20, 0, 35),
    Position = UDim2.new(0, 10, 0, 40)
})

createUIElement("UICorner", GunDropEspToggleContainer, {CornerRadius = UDim.new(0, 8)})
createUIElement("UIStroke", GunDropEspToggleContainer, {
    Color = Color3.fromRGB(60,60,60),
    Thickness = 1
})

createUIElement("TextLabel", GunDropEspToggleContainer, {
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "GunDrop ESP",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

local GunDropEspToggle = createUIElement("TextButton", GunDropEspToggleContainer, {
    Size = UDim2.new(0, 60, 0, 25),
    Position = UDim2.new(1, -70, 0.5, -12.5),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0,
    Text = "OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false
})

GunDropEspToggle.MouseButton1Click:Connect(playButtonSound)

createUIElement("UICorner", GunDropEspToggle, {CornerRadius = UDim.new(0, 12)})
local GunDropEspToggleStroke = createUIElement("UIStroke", GunDropEspToggle, {
    Color = Color3.fromRGB(100, 100, 100),
    Thickness = 2
})

local gunDropConnections = {}

GunDropEspToggle.MouseButton1Click:Connect(function()
    States.gunDropESPToggled = not States.gunDropESPToggled
    
    if States.gunDropESPToggled then
        GunDropEspToggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
        GunDropEspToggle.Text = "ON"
        GunDropEspToggleStroke.Color = Color3.fromRGB(200, 50, 47)
        
        -- Подключение обработчиков
        gunDropConnections.added = Services.CollectionService:GetInstanceAddedSignal("GunDrop"):Connect(function(addedPart)
            if States.gunDropESPToggled then
                highlightGunDrop(addedPart)
            end
        end)
        
        gunDropConnections.removed = Services.CollectionService:GetInstanceRemovedSignal("GunDrop"):Connect(function(removedPart)
            if States.gunDropESPToggled and removedPart:FindFirstChild("ShadowGunDropESP") then
                removedPart.ShadowGunDropESP:Destroy()
            end
        end)
        
        -- Добавление ESP для существующих
        startGunDropESP()
    else
        GunDropEspToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        GunDropEspToggle.Text = "OFF"
        GunDropEspToggleStroke.Color = Color3.fromRGB(100, 100, 100)
        
        -- Отключение обработчиков
        for _, conn in pairs(gunDropConnections) do
            conn:Disconnect()
        end
        gunDropConnections = {}
        
        -- Удаление ESP
        stopGunDropESP()
    end
end)

-- Hover эффекты для GunDrop ESP
GunDropEspToggle.MouseEnter:Connect(function()
    if not States.gunDropESPToggled then
        GunDropEspToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

GunDropEspToggle.MouseLeave:Connect(function()
    if not States.gunDropESPToggled then
        GunDropEspToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Emotes Page
local EmotesPage = TabPages["Emotes"]

-- Заголовок страницы Emotes
createUIElement("TextLabel", EmotesPage, {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "Emotes Page",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Position = UDim2.new(0, 0, 0, 0)
})

-- Получаем Remote для эмотов
local PlayEmoteRemote = Services.ReplicatedStorage.Remotes.Misc.PlayEmote

-- Список эмотов
local Emotes = {
    "wave",
    "cheer",
    "laugh", 
    "sit",
    "ninja",
    "dab",
    "zen",
    "floss",
    "zombie",
    "headless"
}

-- Функция для воспроизведения эмота
local function playEmote(emoteName)
    pcall(function()
        PlayEmoteRemote:Fire(emoteName)
    end)
end

-- Контейнер для кнопок эмотов
local EmotesContainer = createUIElement("Frame", EmotesPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 1, -50),
    Position = UDim2.new(0, 0, 0, 40)
})

createUIElement("UICorner", EmotesContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", EmotesContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

-- Создаем UIListLayout для кнопок
local EmotesGrid = createUIElement("UIGridLayout", EmotesContainer, {
    CellSize = UDim2.new(0, 110, 0, 40),
    CellPadding = UDim2.new(0, 10, 0, 10),
    StartCorner = Enum.StartCorner.TopLeft,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

-- Увеличиваем контейнер, чтобы вместить все кнопки
EmotesContainer.Size = UDim2.new(1, -10, 0, 300)
EmotesContainer.AutomaticSize = Enum.AutomaticSize.None

-- Создаем кнопки для каждого эмота
for i, emoteName in ipairs(Emotes) do
    local EmoteButton = createUIElement("TextButton", EmotesContainer, {
        Size = UDim2.new(0, 110, 0, 40),
        BackgroundColor3 = Color3.fromRGB(230, 57, 51),
        BorderSizePixel = 0,
        Text = emoteName:upper(),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false,
        LayoutOrder = i
    })

    EmoteButton.MouseButton1Click:Connect(playButtonSound)

    createUIElement("UICorner", EmoteButton, {CornerRadius = UDim.new(0, 8)})
    createUIElement("UIStroke", EmoteButton, {
        Color = Color3.fromRGB(200, 50, 47),
        Thickness = 2
    })

    -- Hover эффекты
    EmoteButton.MouseEnter:Connect(function()
        EmoteButton.BackgroundColor3 = Color3.fromRGB(210, 47, 41)
    end)

    EmoteButton.MouseLeave:Connect(function()
        EmoteButton.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
    end)

    -- Обработчик клика
    EmoteButton.MouseButton1Click:Connect(function()
        playEmote(emoteName)
    end)
end

-- Combat Page (теперь с Shoot Murderer Button)
local CombatPage = TabPages["Combat"]

-- Заголовок для Combat страницы
createUIElement("TextLabel", CombatPage, {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "Combat Features",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Position = UDim2.new(0, 0, 0, 0)
})

-- Shoot Murderer Button Toggle
local ShootMurdererContainer = createUIElement("Frame", CombatPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 0, 50),
    Position = UDim2.new(0, 0, 0, 40)
})

createUIElement("UICorner", ShootMurdererContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", ShootMurdererContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

createUIElement("TextLabel", ShootMurdererContainer, {
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Shoot Murderer Button",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
})

local ShootMurdererToggle = createUIElement("TextButton", ShootMurdererContainer, {
    Size = UDim2.new(0, 60, 0, 30),
    Position = UDim2.new(1, -70, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0,
    Text = "OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false
})

ShootMurdererToggle.MouseButton1Click:Connect(playButtonSound)

createUIElement("UICorner", ShootMurdererToggle, {CornerRadius = UDim.new(0, 15)})
local ShootMurdererStroke = createUIElement("UIStroke", ShootMurdererToggle, {
    Color = Color3.fromRGB(100, 100, 100),
    Thickness = 2
})

-- Shoot Murderer Frame (код из вашего примера)
local ShootMurdererFrame = nil

local function createShootMurdererUI()
    if ShootMurdererFrame then
        ShootMurdererFrame:Destroy()
        ShootMurdererFrame = nil
    end
    
    if not States.shootMurdererEnabled then
        return
    end
    
    -- Создаем ScreenGui с низким ZIndex (ниже чем у основного UI)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ShootMurdererUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 0  -- Устанавливаем низкий DisplayOrder
    ScreenGui.Parent = game.CoreGui

    -- Рассчитываем размер на основе значения (от 5 до 20)
    local baseWidth = 150  -- Базовая ширина
    local baseHeight = 80  -- Базовая высота
    local sizeMultiplier = States.shootMurdererFrameSize / 10  -- Делим на 10 чтобы 10 было 100%
    
    -- Создаем маленький фрейм
    local smallFrame = Instance.new("Frame")
    smallFrame.Name = "SmallFrame"
    smallFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    smallFrame.BackgroundTransparency = 0.08
    smallFrame.BorderSizePixel = 0
    smallFrame.Size = UDim2.new(0, baseWidth * sizeMultiplier, 0, baseHeight * sizeMultiplier)
    smallFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    smallFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    smallFrame.ZIndex = 1  -- Низкий ZIndex для самого фрейма
    smallFrame.Parent = ScreenGui

    -- Добавляем закругленные края
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = smallFrame

    -- Добавляем обводку
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(230, 57, 51)
    stroke.Thickness = 1.8
    stroke.Transparency = 0.05
    stroke.Parent = smallFrame

    -- Добавляем текст
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "Shoot Murderer"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 1  -- Низкий ZIndex для текста
    label.Parent = smallFrame

    -- Добавляем квадрат для перемещения (выходит за границы фрейма)
    local dragSquare = Instance.new("Frame")
    dragSquare.Name = "DragSquare"
    dragSquare.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
    dragSquare.BackgroundTransparency = 0.4
    dragSquare.BorderSizePixel = 0
    dragSquare.Size = UDim2.new(0, 25 * sizeMultiplier, 0, 25 * sizeMultiplier) -- Чуть больше
    dragSquare.Position = UDim2.new(0, -10 * sizeMultiplier, 0, -10 * sizeMultiplier) -- Выступает за левый верхний угол
    dragSquare.ZIndex = 2  -- У квадрата ZIndex выше, чтобы его можно было захватить
    dragSquare.Parent = smallFrame

    -- Добавляем закругленные края для квадрата
    local dragCorner = Instance.new("UICorner")
    dragCorner.CornerRadius = UDim.new(0, 5)
    dragCorner.Parent = dragSquare

    -- Добавляем обводку для квадрата
    local dragStroke = Instance.new("UIStroke")
    dragStroke.Color = Color3.fromRGB(255, 255, 255)
    dragStroke.Thickness = 1.5
    dragStroke.Transparency = 0.3
    dragStroke.Parent = dragSquare

    -- Переменные для перемещения фрейма
    local currentTouchId = nil  -- ID текущего касания для квадрата
    local dragStart
    local startPos
    local UserInputService = game:GetService("UserInputService")

    -- Функция для обновления позиции при перемещении
    local function updateTouchPosition(touchPosition)
        if not dragStart or not startPos then return end
        
        local delta = touchPosition - dragStart
        smallFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end

    -- Функция для начала перемещения (работает на ПК и телефоне)
    local function beginDrag(input)
        -- Если уже есть активное касание для этого квадрата, игнорируем новое
        if currentTouchId ~= nil and input.UserInputType == Enum.UserInputType.Touch then
            return false
        end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            -- Запоминаем ID касания (для телефона)
            if input.UserInputType == Enum.UserInputType.Touch then
                currentTouchId = input
            end
            
            dragStart = input.Position
            startPos = smallFrame.Position
            
            -- Эффект при нажатии на квадрат
            dragSquare.BackgroundTransparency = 0.2
            dragSquare.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            
            return true
        end
        return false
    end

    -- Функция для завершения перемещения
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            -- Проверяем, что это тот же тач, который начал перемещение
            if currentTouchId == input then
                currentTouchId = nil
            else
                return  -- Игнорируем другие тачи
            end
        else
            currentTouchId = nil  -- Для мыши тоже сбрасываем
        end
        
        -- Возвращаем цвет квадрата
        dragSquare.BackgroundTransparency = 0.4
        dragSquare.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
        
        dragStart = nil
        startPos = nil
    end

    -- Обработчики для квадрата
    dragSquare.InputBegan:Connect(function(input)
        beginDrag(input)
    end)

    dragSquare.InputEnded:Connect(function(input)
        endDrag(input)
    end)

    -- Обработка изменения позиции тача/мыши
    UserInputService.InputChanged:Connect(function(input)
        -- Для мыши
        if input.UserInputType == Enum.UserInputType.MouseMovement and currentTouchId == nil then
            if dragStart and startPos then
                updateTouchPosition(input.Position)
            end
        
        -- Для тача - проверяем, что это тот же тач, который начал перемещение
        elseif input.UserInputType == Enum.UserInputType.Touch then
            if currentTouchId == input and dragStart and startPos then
                updateTouchPosition(input.Position)
            end
        end
    end)

    -- Эффект при наведении на квадрат (только для ПК)
    dragSquare.MouseEnter:Connect(function()
        if currentTouchId == nil then  -- Только если нет активного тача
            dragSquare.BackgroundTransparency = 0.3
        end
    end)

    dragSquare.MouseLeave:Connect(function()
        if currentTouchId == nil then  -- Только если нет активного тача
            dragSquare.BackgroundTransparency = 0.4
        end
    end)

    -- Переменные для стрельбы
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local isShooting = false

    -- Функция проверки инструмента
    local function HasTool(player, toolName)
        if not player then return false end
        local character = player.Character
        local backpack = player:FindFirstChild("Backpack")
        
        if character and character:FindFirstChild(toolName) then
            return true
        elseif backpack and backpack:FindFirstChild(toolName) then
            return true
        end
        return false
    end

    -- Функция стрельбы
    local function ShootMurder()
        if isShooting then
            return
        end
        
        isShooting = true
        
        -- Анимация нажатия фрейма
        smallFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        local localCharacter = LocalPlayer.Character
        
        if not localCharacter then
            warn("Character not found!")
            task.wait(0.2)
            smallFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            isShooting = false
            return
        end
        
        -- Проверяем наличие оружия
        if HasTool(LocalPlayer, "Gun") then
            local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or localCharacter:FindFirstChild("Gun")
            local humanoid = localCharacter:FindFirstChildOfClass("Humanoid")
            
            if gun and humanoid then
                humanoid:EquipTool(gun)
            end
        else
            warn("You don't have a Gun")
            task.wait(0.2)
            smallFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            isShooting = false
            return
        end
        
        -- Поиск убийцы (игрока с ножом)
        local players = Players
        local murderer = nil
        
        for _, player in pairs(players:GetPlayers()) do
            if player ~= LocalPlayer and HasTool(player, "Knife") then
                murderer = player
                break
            end
        end
        
        -- Стрельба по убийце
        if murderer and murderer.Character then
            local humanoidRootPart = murderer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local shootArgs = {
                    1,
                    humanoidRootPart.Position,
                    "AH2"
                }
                
                -- Пытаемся выполнить стрельбу
                local success, errorMsg = pcall(function()
                    if localCharacter and localCharacter:FindFirstChild("Gun") then
                        localCharacter.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(shootArgs))
                    end
                end)
                
                if not success then
                    warn("Shooting error: " .. tostring(errorMsg))
                else
                    print("Successfully shot at murderer!")
                end
            else
                warn("Murderer has no HumanoidRootPart")
            end
        else
            warn("No murderer found")
        end
        
        -- Ждем 0.2 секунды перед возвращением цвета
        task.wait(0.2)
        
        -- Возвращаем фрейм в исходное состояние
        smallFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        isShooting = false
    end

    -- Создаем невидимую кнопку поверх всего фрейма
    local clickDetector = Instance.new("TextButton")
    clickDetector.Name = "ClickDetector"
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.BorderSizePixel = 0
    clickDetector.Text = ""
    clickDetector.AutoButtonColor = false
    clickDetector.ZIndex = 2  -- ZIndex выше, чтобы можно было кликать
    clickDetector.Parent = smallFrame

    -- Подключаем функцию к клику (работает на ПК и телефоне)
    clickDetector.InputBegan:Connect(function(input)
        if currentTouchId == nil and (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                                      input.UserInputType == Enum.UserInputType.Touch) then
            -- Воспроизводим звук при нажатии (тот же самый звук rbxassetid://140910211)
            playButtonSound()
            ShootMurder()
        end
    end)

    -- Также добавляем возможность стрелять по клавише E (только для ПК)
    UserInputService.InputBegan:Connect(function(input, isTyping)
        if not isTyping then
            if input.KeyCode == Enum.KeyCode.E then
                -- Воспроизводим звук при нажатии E
                playButtonSound()
                ShootMurder()
            end
        end
    end)

    -- Добавляем эффекты при наведении курсора (только для ПК)
    clickDetector.MouseEnter:Connect(function()
        if not isShooting and currentTouchId == nil then
            smallFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        end
    end)

    clickDetector.MouseLeave:Connect(function()
        if not isShooting then
            smallFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        end
    end)

    -- Делаем квадрат для телефона более чувствительным
    dragSquare.Active = true
    dragSquare.Selectable = true

    -- Защита от множественных касаний: если другой палец касается экрана, он не влияет на квадрат
    UserInputService.TouchStarted:Connect(function(touch, wasProcessed)
        -- Этот обработчик просто гарантирует, что другие тачи не мешают
    end)
    
    ShootMurdererFrame = ScreenGui
end

-- Функция обновления размера фрейма Shoot Murderer
local function updateShootMurdererFrameSize()
    if States.shootMurdererEnabled and ShootMurdererFrame then
        local smallFrame = ShootMurdererFrame:FindFirstChild("SmallFrame")
        if smallFrame then
            local sizeMultiplier = States.shootMurdererFrameSize / 10
            smallFrame.Size = UDim2.new(0, 150 * sizeMultiplier, 0, 80 * sizeMultiplier)
            
            -- Обновляем размер квадрата для перемещения
            local dragSquare = smallFrame:FindFirstChild("DragSquare")
            if dragSquare then
                dragSquare.Size = UDim2.new(0, 25 * sizeMultiplier, 0, 25 * sizeMultiplier)
                dragSquare.Position = UDim2.new(0, -10 * sizeMultiplier, 0, -10 * sizeMultiplier)
            end
        end
    end
end

-- Обработчик переключателя Shoot Murderer
ShootMurdererToggle.MouseButton1Click:Connect(function()
    States.shootMurdererEnabled = not States.shootMurdererEnabled
    
    if States.shootMurdererEnabled then
        ShootMurdererToggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
        ShootMurdererToggle.Text = "ON"
        ShootMurdererStroke.Color = Color3.fromRGB(200, 50, 47)
        createShootMurdererUI()
    else
        ShootMurdererToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ShootMurdererToggle.Text = "OFF"
        ShootMurdererStroke.Color = Color3.fromRGB(100, 100, 100)
        if ShootMurdererFrame then
            ShootMurdererFrame:Destroy()
            ShootMurdererFrame = nil
        end
    end
end)

-- Hover эффекты для Shoot Murderer Toggle
ShootMurdererToggle.MouseEnter:Connect(function()
    if not States.shootMurdererEnabled then
        ShootMurdererToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

ShootMurdererToggle.MouseLeave:Connect(function()
    if not States.shootMurdererEnabled then
        ShootMurdererToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Shoot Murderer Frame Size Slider (в Combat вкладке после тоггла)
local FrameSizeContainer = createUIElement("Frame", CombatPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 0, 80),
    Position = UDim2.new(0, 0, 0, 100)
})

createUIElement("UICorner", FrameSizeContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", FrameSizeContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

local sizeLabel = createUIElement("TextLabel", FrameSizeContainer, {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Frame Size: " .. States.shootMurdererFrameSize,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Слайдер для изменения размера фрейма
local sliderFrame = createUIElement("Frame", FrameSizeContainer, {
    Size = UDim2.new(0.9, 0, 0, 20),
    Position = UDim2.new(0.05, 0, 0.6, -10),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0
})

createUIElement("UICorner", sliderFrame, {CornerRadius = UDim.new(0, 10)})

-- Рассчитываем позицию для текущего значения (от 5 до 20)
local sliderValue = (States.shootMurdererFrameSize - 5) / 15  -- Нормализуем от 0 до 1

local sliderTrack = createUIElement("Frame", sliderFrame, {
    Size = UDim2.new(sliderValue, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(230, 57, 51),
    BorderSizePixel = 0
})

createUIElement("UICorner", sliderTrack, {CornerRadius = UDim.new(0, 10)})

local sliderButton = createUIElement("TextButton", sliderFrame, {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(sliderValue, -12.5, 0.5, -12.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false
})

createUIElement("UICorner", sliderButton, {CornerRadius = UDim.new(0, 12)})
createUIElement("UIStroke", sliderButton, {
    Color = Color3.fromRGB(200, 200, 200),
    Thickness = 2
})

-- Функция обновления слайдера
local function updateSlider(value)
    -- Ограничиваем значение от 0 до 1
    local normalizedValue = math.clamp(value, 0, 1)
    
    -- Преобразуем в значение от 5 до 20
    States.shootMurdererFrameSize = math.floor(5 + normalizedValue * 15)
    
    -- Обновляем позицию слайдера
    sliderTrack.Size = UDim2.new(normalizedValue, 0, 1, 0)
    sliderButton.Position = UDim2.new(normalizedValue, -12.5, 0.5, -12.5)
    
    -- Обновляем текст
    sizeLabel.Text = "Frame Size: " .. States.shootMurdererFrameSize
    
    -- Обновляем размер фрейма Shoot Murderer
    updateShootMurdererFrameSize()
end

-- Обработчики для слайдера (работают и на ПК, и на телефоне)
local draggingSlider = false
local currentDragTouchId = nil -- Для отслеживания конкретного касания

local function beginSliderDrag(input)
    -- Проверяем тип ввода
    local isValidInput = false
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Для мыши
        isValidInput = true
    elseif input.UserInputType == Enum.UserInputType.Touch then
        -- Для телефона - проверяем, что нет другого активного касания
        if currentDragTouchId == nil then
            currentDragTouchId = input
            isValidInput = true
        end
    end
    
    if isValidInput then
        draggingSlider = true
        playButtonSound()
        return true
    end
    
    return false
end

local function endSliderDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
        currentDragTouchId = nil
    elseif input.UserInputType == Enum.UserInputType.Touch then
        -- Проверяем, что это тот же тач, который начал перетаскивание
        if currentDragTouchId == input then
            draggingSlider = false
            currentDragTouchId = nil
        end
    end
end

local function updateSliderFromInput(input)
    if not draggingSlider then return end
    
    -- Для тача проверяем, что это тот же тач
    if input.UserInputType == Enum.UserInputType.Touch and currentDragTouchId ~= input then
        return
    end
    
    local relativeX = (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X
    updateSlider(relativeX)
end

-- Обработчики для кнопки слайдера
sliderButton.InputBegan:Connect(function(input)
    beginSliderDrag(input)
end)

sliderButton.InputEnded:Connect(function(input)
    endSliderDrag(input)
end)

-- Также позволяем перетаскивать, начиная с самого трека слайдера
sliderFrame.InputBegan:Connect(function(input)
    if beginSliderDrag(input) then
        -- Если начали перетаскивание с трека, сразу обновляем позицию
        updateSliderFromInput(input)
    end
end)

sliderFrame.InputEnded:Connect(function(input)
    endSliderDrag(input)
end)

-- Обработка перемещения (для мыши и тача)
Services.UserInputService.InputChanged:Connect(function(input)
    updateSliderFromInput(input)
end)

-- Также обрабатываем отпускание тача в любом месте
Services.UserInputService.TouchEnded:Connect(function(input)
    if currentDragTouchId == input then
        endSliderDrag(input)
    end
end)

-- Улучшаем отзывчивость для телефона
sliderButton.Active = true
sliderButton.Selectable = true
sliderFrame.Active = true

-- Teleport Page
local TeleportPage = TabPages["Teleport"]

-- 1. Murderer функция
function GetMurder()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Backpack and player.Backpack:FindFirstChild("Knife") then
            return player
        end
        if player.Character and player.Character:FindFirstChild("Knife") then
            return player
        end
    end
    if vu654 then
        for playerName, data in pairs(vu654) do
            if data.Role == "Murderer" then
                return game.Players:FindFirstChild(playerName)
            end
        end
    end
    return nil
end

-- 2. GunDrop функция (только Touch метод)
function GrabGunRemote()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("GunDrop") then
            local gun = obj.GunDrop
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            firetouchinterest(hrp, gun, 0)
            task.wait(0.1)
            firetouchinterest(hrp, gun, 1)
            return true
        end
    end
    return false
end

-- 3. Sheriff функция
function GetSheriff()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Backpack and player.Backpack:FindFirstChild("Gun") then
            return player
        end
        if player.Character and player.Character:FindFirstChild("Gun") then
            return player
        end
    end
    if vu654 then
        for playerName, data in pairs(vu654) do
            if data.Role == "Sheriff" then
                return game.Players:FindFirstChild(playerName)
            end
        end
    end
    return nil
end

-- 4. Map функции
function TeleportToMap()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant.Name == "Spawn" or descendant.Name == "PlayerSpawn" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = 
                CFrame.new(descendant.Position) * CFrame.new(0, 2.5, 0)
            return true
        end
    end
    return false
end

function getMap()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:FindFirstChild("CoinContainer") and obj:FindFirstChild("Spawns") then
            return obj
        end
    end
    return nil
end

function Teleport_to_map()
    local map = getMap()
    if map then
        local spawns = map:FindFirstChild("Spawns")
        if spawns then
            local spawnPoints = spawns:GetChildren()
            if #spawnPoints > 0 then
                local randomSpawn = spawnPoints[math.random(1, #spawnPoints)]
                game.Players.LocalPlayer.Character:MoveTo(randomSpawn.Position)
                return true
            end
        end
    end
    return false
end

-- 5. Lobby функция
function TeleportToLobby()
    local lobby = workspace:FindFirstChild("Lobby")
    if lobby and lobby:FindFirstChild("Spawns") then
        local spawns = lobby.Spawns:GetChildren()
        if #spawns > 0 then
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            hrp.CFrame = spawns[math.random(#spawns)].CFrame + Vector3.new(0, 3, 0)
            return true
        end
    end
    return false
end

-- 6. Voting Room функция
function TeleportToVote()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(14, 508, 36)
    return true
end

-- Заголовок для Teleport страницы
createUIElement("TextLabel", TeleportPage, {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "Teleport Features",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Position = UDim2.new(0, 0, 0, 0)
})

-- Контейнер для кнопок телепортации (увеличиваем высоту, так как убрали текстовый контейнер)
local TeleportButtonsContainer = createUIElement("Frame", TeleportPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 1, -50),  -- Теперь занимает всю высоту страницы
    Position = UDim2.new(0, 0, 0, 40)
})

createUIElement("UICorner", TeleportButtonsContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", TeleportButtonsContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

-- Создаем UIListLayout для вертикального расположения кнопок (как в Misc вкладке)
local TeleportButtonsLayout = createUIElement("UIListLayout", TeleportButtonsContainer, {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top
})

-- Добавляем небольшой отступ сверху для кнопок
createUIElement("UIPadding", TeleportButtonsContainer, {
    PaddingTop = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 0),
    PaddingRight = UDim.new(0, 0),
    PaddingBottom = UDim.new(0, 10)
})

-- Функция для создания кнопок телепортации в стиле Rejoin
local function createTeleportButton(text, teleportFunction, order)
    local button = createUIElement("TextButton", TeleportButtonsContainer, {
        Size = UDim2.new(0.9, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(230, 57, 51),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false,
        LayoutOrder = order
    })

    button.MouseButton1Click:Connect(playButtonSound)

    createUIElement("UICorner", button, {CornerRadius = UDim.new(0, 8)})
    createUIElement("UIStroke", button, {
        Color = Color3.fromRGB(200, 50, 47),
        Thickness = 2
    })

    -- Градиентный эффект при наведении (как в кнопках Rejoin)
    button.MouseEnter:Connect(function()
        local tween = Services.TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(210, 47, 41),
            BackgroundTransparency = 0
        })
        tween:Play()
    end)

    button.MouseLeave:Connect(function()
        local tween = Services.TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(230, 57, 51),
            BackgroundTransparency = 0
        })
        tween:Play()
    end)

    -- Эффект нажатия (немного прозрачнее)
    button.MouseButton1Down:Connect(function()
        button.BackgroundTransparency = 0.2
    end)

    button.MouseButton1Up:Connect(function()
        button.BackgroundTransparency = 0
    end)

    button.MouseButton1Click:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            -- Эффект нажатия
            button.Text = "Teleporting..."
            
            -- Запускаем телепортацию
            teleportFunction()
            
            -- Возвращаем текст через 0.5 секунды
            task.wait(0.5)
            button.Text = text
        end
    end)

    return button
end

-- Создаем кнопки телепортации в стиле Rejoin
createTeleportButton("Teleport to Murderer", function()
    local murderer = GetMurder()
    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        hrp.CFrame = murderer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end, 1)

createTeleportButton("Teleport to Sheriff", function()
    local sheriff = GetSheriff()
    if sheriff and sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        hrp.CFrame = sheriff.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end, 2)

createTeleportButton("Grab Gun", GrabGunRemote, 3)

createTeleportButton("Teleport to Map Spawn", TeleportToMap, 4)

createTeleportButton("Teleport to Random Map", Teleport_to_map, 5)

createTeleportButton("Teleport to Lobby", TeleportToLobby, 6)

createTeleportButton("Teleport to Voting Room", TeleportToVote, 7)

-- Misc Page
local MiscPage = TabPages["Misc"]

-- Заголовок для Misc страницы
createUIElement("TextLabel", MiscPage, {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "Misc Features",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Position = UDim2.new(0, 0, 0, 0)
})

-- Anti AFK
local AntiAFKContainer = createUIElement("Frame", MiscPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 0, 50),
    Position = UDim2.new(0, 0, 0, 40)
})

createUIElement("UICorner", AntiAFKContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", AntiAFKContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

createUIElement("TextLabel", AntiAFKContainer, {
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Anti AFK",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
})

local AntiAFKToggle = createUIElement("TextButton", AntiAFKContainer, {
    Size = UDim2.new(0, 60, 0, 30),
    Position = UDim2.new(1, -70, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0,
    Text = "OFF",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false
})

AntiAFKToggle.MouseButton1Click:Connect(playButtonSound)

createUIElement("UICorner", AntiAFKToggle, {CornerRadius = UDim.new(0, 15)})
local AntiAFKStroke = createUIElement("UIStroke", AntiAFKToggle, {
    Color = Color3.fromRGB(100, 100, 100),
    Thickness = 2
})

local AntiAFKConnection
local AntiAFKEnabled = false

AntiAFKToggle.MouseButton1Click:Connect(function()
    AntiAFKEnabled = not AntiAFKEnabled
    
    if AntiAFKEnabled then
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
        end
        
        AntiAFKConnection = Services.Players.LocalPlayer.Idled:Connect(function()
            Services.VirtualUser:Button2Down(Vector2.new(0,0), Services.Workspace.CurrentCamera.CFrame)
            task.wait(1)
            Services.VirtualUser:Button2Up(Vector2.new(0,0), Services.Workspace.CurrentCamera.CFrame)
        end)
        
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
        AntiAFKToggle.Text = "ON"
        AntiAFKStroke.Color = Color3.fromRGB(200, 50, 47)
    else
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
        end
        
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        AntiAFKToggle.Text = "OFF"
        AntiAFKStroke.Color = Color3.fromRGB(100, 100, 100)
    end
end)

-- Server Buttons
local ServerButtonsContainer = createUIElement("Frame", MiscPage, {
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.1,
    Size = UDim2.new(1, -10, 0, 85),
    Position = UDim2.new(0, 0, 0, 100)
})

createUIElement("UICorner", ServerButtonsContainer, {CornerRadius = UDim.new(0, 10)})
createUIElement("UIStroke", ServerButtonsContainer, {
    Color = Color3.fromRGB(230,57,51),
    Thickness = 1.8
})

-- Функция создания серверных кнопок
local function createServerButton(text, position, callback)
    local button = createUIElement("TextButton", ServerButtonsContainer, {
        Size = UDim2.new(0.9, 0, 0, 30),
        Position = position,
        BackgroundColor3 = Color3.fromRGB(230, 57, 51),
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false
    })

    button.MouseButton1Click:Connect(playButtonSound)

    createUIElement("UICorner", button, {CornerRadius = UDim.new(0, 8)})
    createUIElement("UIStroke", button, {
        Color = Color3.fromRGB(200, 50, 47),
        Thickness = 2
    })

    -- Hover эффекты
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(210, 47, 41)
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(230, 57, 51)
    end)

    return button
end

-- Rejoin функция (рабочая)
local function RejoinGame()
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    local success, errorMsg = pcall(function()
        Services.TeleportService:TeleportToPlaceInstance(placeId, jobId, Player)
    end)
    
    if not success then
        pcall(function()
            Services.TeleportService:Teleport(placeId)
        end)
    end
end

-- Server Hop функция (рабочая)
local function ServerHop()
    local placeId = game.PlaceId
    
    local success, serverList = pcall(function()
        local success2, result = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
            local response = game:HttpGet(url)
            return Services.HttpService:JSONDecode(response)
        end)
        
        if success2 and result and result.data then
            return result.data
        end
        
        return nil
    end)
    
    if success and serverList then
        local availableServers = {}
        
        for _, server in ipairs(serverList) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(availableServers, server)
            end
        end
        
        if #availableServers > 0 then
            local randomServer = availableServers[math.random(1, #availableServers)]
            
            pcall(function()
                Services.TeleportService:TeleportToPlaceInstance(placeId, randomServer.id, Player)
            end)
        else
            pcall(function()
                Services.TeleportService:Teleport(placeId)
            end)
        end
    else
        pcall(function()
            Services.TeleportService:Teleport(placeId)
        end)
    end
end

-- Создание кнопок с рабочими обработчиками
local RejoinButton = createServerButton("Rejoin Server", UDim2.new(0.05, 0, 0, 10))
local ServerHopButton = createServerButton("Server Hop", UDim2.new(0.05, 0, 0, 45))

-- Обработчики для кнопок
RejoinButton.MouseButton1Click:Connect(function()
    RejoinButton.Text = "Rejoining..."
    playButtonSound()
    
    task.spawn(function()
        task.wait(0.5)
        RejoinGame()
    end)
end)

ServerHopButton.MouseButton1Click:Connect(function()
    ServerHopButton.Text = "Hopping..."
    playButtonSound()
    
    task.spawn(function()
        task.wait(0.5)
        ServerHop()
    end)
end)

-- Перетаскивание окна
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

Services.UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)

-- Кнопка сворачивания/разворачивания
local ToggleParentFrame = createUIElement("Frame", ScreenGui, {
    Size = UDim2.new(0, 45, 0, 45),
    Position = UDim2.new(0.05, 0, 0.05, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0
})

createUIElement("UICorner", ToggleParentFrame, {CornerRadius = UDim.new(0, 6)})
createUIElement("UIStroke", ToggleParentFrame, {
    Color = Color3.fromRGB(230, 57, 51),
    Thickness = 2
})

local IconContainer = createUIElement("Frame", ToggleParentFrame, {
    Size = UDim2.new(0.7, 0, 0.7, 0),
    Position = UDim2.new(0.15, 0, 0.15, 0),
    BackgroundTransparency = 1
})

createUIElement("ImageLabel", IconContainer, {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image = "rbxthumb://type=Asset&id=93886432127909&w=420&h=420",
    ImageColor3 = Color3.fromRGB(255, 255, 255)
})

local ClickButton = createUIElement("TextButton", ToggleParentFrame, {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = ""
})

ClickButton.MouseButton1Click:Connect(playButtonSound)

local isVisible = true
ClickButton.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    MainFrame.Visible = isVisible
end)

-- Очистка ESP при смене персонажа
Services.Players.LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function()
    if not States.gunDropESPToggled then
        stopGunDropESP()
    end
end)

-- Защита от ошибок при перезагрузке
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == Player then
        -- Очистка всех соединений при выходе
        if farmConnection then
            task.cancel(farmConnection)
        end
        for _, conn in pairs(gunDropConnections) do
            conn:Disconnect()
        end
        if ShootMurdererFrame then
            ShootMurdererFrame:Destroy()
        end
    end
end)
