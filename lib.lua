local YUUGTRL = loadstring(game:HttpGet("https://raw.githubusercontent.com/YUUGTRELDYS/YUUGTRL.github.io/refs/heads/main/lib.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local ALLOWED_PLACE_ID = 7346416636
if game.PlaceId ~= ALLOWED_PLACE_ID then return end

local currentLanguage = "English"
local scriptVisible = true
local currentTransparency = 0
local isMobile = UserInputService.TouchEnabled

local languages = {
    English = {
        title = "TRADE SCRIPT",
        onBoard = "On Board",
        accepted = "Accepted",
        scamMode = "Scam Mode",
        autoGroup = "Auto Group",
        autoVip = "Auto Vip/Gold",
        xray = "XRAY",
        jump = "JUMP",
        enableScam = "ENABLE SCAM (G)",
        disableScam = "DISABLE SCAM (G)",
        xrayBtn = "XRAY",
        jumpBtn = "JUMP",
        resetBtn = "RESET",
        settings = "Settings",
        transparency = "Transparency",
        language = "Language"
    },
    Russian = {
        title = "ТРЕЙД СКРИПТ",
        onBoard = "На доске",
        accepted = "Принято",
        scamMode = "Режим скама",
        autoGroup = "Авто группа",
        autoVip = "Авто Vip/Золото",
        xray = "РЕНТГЕН",
        jump = "ПРЫЖОК",
        enableScam = "ВКЛ СКАМ (G)",
        disableScam = "ВЫКЛ СКАМ (G)",
        xrayBtn = "РЕНТГЕН",
        jumpBtn = "ПРЫЖОК",
        resetBtn = "СБРОС",
        settings = "Настройки",
        transparency = "Прозрачность",
        language = "Язык"
    }
}

-- КАСТОМНАЯ ТЕМА - ЗДЕСЬ МОЖНО МЕНЯТЬ ВСЁ!!!
local customTheme = {
    -- Основные цвета
    BackgroundColor = Color3.fromRGB(20, 20, 30),      -- Главный фон
    SecondaryColor = Color3.fromRGB(35, 35, 50),      -- Заголовок
    AccentColor = Color3.fromRGB(100, 80, 255),       -- Акцентный цвет
    TextColor = Color3.fromRGB(255, 255, 255),        -- Основной текст
    TextSecondaryColor = Color3.fromRGB(180, 180, 220), -- Второстепенный текст
    SuccessColor = Color3.fromRGB(80, 255, 120),      -- Успех
    ErrorColor = Color3.fromRGB(255, 70, 70),         -- Ошибка
    
    -- Размеры окна
    WindowWidth = isMobile and 300 or 380,
    WindowHeight = isMobile and 480 or 520,
    CornerRadius = 12,                                  -- Скругление углов
    
    -- Кнопки
    ButtonHeight = isMobile and 40 or 44,
    ButtonStyle = {
        CornerRadius = 8,                               -- Скругление кнопок
        Font = Enum.Font.GothamBold,                    -- Шрифт
        FontSize = isMobile and 12 or 14,               -- Размер шрифта
        HoverBrightness = 0.3,                           -- Яркость при наведении
    },
    
    -- Панель статуса
    StatusPanel = {
        Height = isMobile and 160 or 190,
        BackgroundColor = Color3.fromRGB(30, 30, 40),
        ItemHeight = isMobile and 22 or 26,
        Spacing = 3,
    },
    
    -- Анимации
    AnimationsEnabled = true,
    AnimationSpeed = 0.2,
}

-- Создаем окно с кастомной темой
local window = YUUGTRL:CreateWindow(languages.English.title, nil, {
    ShowClose = true,
    ShowSettings = true,
    CloseColor = Color3.fromRGB(255, 70, 70),
    SettingsColor = Color3.fromRGB(100, 80, 255),
    Position = isMobile and UDim2.new(1, -310, 0.5, -240) or UDim2.new(1, -400, 0.5, -260),
    Theme = customTheme
})

window:AddCredit("by YUUGTRELDYS v3.0", Color3.fromRGB(180, 100, 255))

-- Создаем переменные
local Board = Instance.new("ObjectValue")
local YourSide = Instance.new("ObjectValue")
local TheirSide = Instance.new("ObjectValue")
local onV = Instance.new("BoolValue")
local enV = Instance.new("BoolValue")
local theyV = Instance.new("BoolValue")
local xrayV = Instance.new("BoolValue")

onV.Value = false
theyV.Value = false
enV.Value = false
xrayV.Value = false

-- СОЗДАЕМ ПАНЕЛЬ СТАТУСА
local statusPanel, statusBg, statusScroll, statusLayout, createStatusItem, statusItems = window:CreateStatusPanel()

-- Создаем элементы статуса
local onBoardItem, onBoardLabel, onBoardValue = createStatusItem(languages.English.onBoard)
local acceptedItem, acceptedLabel, acceptedValue = createStatusItem(languages.English.accepted)
local scamItem, scamLabel, scamValue = createStatusItem(languages.English.scamMode)
local autoGroupItem, autoGroupLabel, autoGroupValue = createStatusItem(languages.English.autoGroup)
local autoVipItem, autoVipLabel, autoVipValue = createStatusItem(languages.English.autoVip)
local xrayItem, xrayLabel, xrayValue = createStatusItem(languages.English.xray)
local jumpItem, jumpLabel, jumpValue = createStatusItem(languages.English.jump)

-- Устанавливаем начальные значения
autoGroupValue.Text = "true"
autoGroupValue.TextColor3 = customTheme.SuccessColor
autoVipValue.Text = "true"
autoVipValue.TextColor3 = customTheme.SuccessColor

-- СОЗДАЕМ КНОПКИ
local toggleButton = window:AddButton(languages.English.enableScam, Color3.fromRGB(100, 80, 255), function()
    enV.Value = not enV.Value
    updateUI()
end)

local xrayButton = window:AddButton(languages.English.xrayBtn, Color3.fromRGB(150, 100, 255), function()
    xrayV.Value = not xrayV.Value
    if player.Character and player.Character:FindFirstChild("XRay") then
        player.Character.XRay.Value = xrayV.Value
    end
    updateUI()
end)

local jumpButton = window:AddButton(languages.English.jumpBtn, Color3.fromRGB(80, 200, 150), function()
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    jumpValue.Text = "true"
    jumpValue.TextColor3 = customTheme.SuccessColor
    task.wait(0.5)
    jumpValue.Text = "false"
    jumpValue.TextColor3 = customTheme.ErrorColor
end)

local resetButton = window:AddButton(languages.English.resetBtn, Color3.fromRGB(220, 70, 70), function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
    end
end)

-- СОЗДАЕМ ОКНО НАСТРОЕК
local settingsFrame, settingsHeader, settingsTitle, settingsClose = window:CreateSettingsWindow()

-- Добавляем элементы в окно настроек
local languageLabel = Instance.new("TextLabel")
languageLabel.Size = UDim2.new(1, -16, 0, 20)
languageLabel.Position = UDim2.new(0, 8, 0, 40)
languageLabel.BackgroundTransparency = 1
languageLabel.Text = languages.English.language .. ":"
languageLabel.TextColor3 = customTheme.TextSecondaryColor
languageLabel.Font = customTheme.ButtonStyle.Font
languageLabel.TextSize = customTheme.ButtonStyle.FontSize - 1
languageLabel.TextXAlignment = Enum.TextXAlignment.Left
languageLabel.Parent = settingsFrame

local englishBtn = Instance.new("TextButton")
englishBtn.Size = UDim2.new(0.4, 0, 0, 28)
englishBtn.Position = UDim2.new(0.3, 0, 0, 65)
englishBtn.BackgroundColor3 = customTheme.AccentColor
englishBtn.Text = "English"
englishBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
englishBtn.Font = customTheme.ButtonStyle.Font
englishBtn.TextSize = customTheme.ButtonStyle.FontSize - 1
englishBtn.Parent = settingsFrame

local englishCorner = Instance.new("UICorner")
englishCorner.CornerRadius = UDim.new(0, customTheme.ButtonStyle.CornerRadius)
englishCorner.Parent = englishBtn

local russianBtn = Instance.new("TextButton")
russianBtn.Size = UDim2.new(0.4, 0, 0, 28)
russianBtn.Position = UDim2.new(0.3, 0, 0, 100)
russianBtn.BackgroundColor3 = customTheme.SecondaryColor
russianBtn.Text = "Русский"
russianBtn.TextColor3 = customTheme.TextSecondaryColor
russianBtn.Font = customTheme.ButtonStyle.Font
russianBtn.TextSize = customTheme.ButtonStyle.FontSize - 1
russianBtn.Parent = settingsFrame

local russianCorner = Instance.new("UICorner")
russianCorner.CornerRadius = UDim.new(0, customTheme.ButtonStyle.CornerRadius)
russianCorner.Parent = russianBtn

-- Слайдер прозрачности
local transContainer, transLabel, transBg, transFill, transDrag = window:CreateSlider(settingsFrame, languages.English.transparency, 0, 100, 0, function(value)
    currentTransparency = value
    local val = value / 100
    window.MainFrame.BackgroundTransparency = val
    statusBg.BackgroundTransparency = val
end)

transContainer.Position = UDim2.new(0, 8, 0, 140)

-- Функции обновления
local function updateLanguage()
    local lang = languages[currentLanguage]
    
    -- Обновляем текст
    onBoardLabel.Text = lang.onBoard .. ":"
    acceptedLabel.Text = lang.accepted .. ":"
    scamLabel.Text = lang.scamMode .. ":"
    autoGroupLabel.Text = lang.autoGroup .. ":"
    autoVipLabel.Text = lang.autoVip .. ":"
    xrayLabel.Text = lang.xray .. ":"
    jumpLabel.Text = lang.jump .. ":"
    
    xrayButton.Text = lang.xrayBtn
    jumpButton.Text = lang.jumpBtn
    resetButton.Text = lang.resetBtn
    toggleButton.Text = enV.Value and lang.disableScam or lang.enableScam
    
    settingsTitle.Text = lang.settings
    languageLabel.Text = lang.language .. ":"
    transLabel.Text = lang.transparency .. ": " .. currentTransparency
end

local function setLanguage(lang)
    currentLanguage = lang
    updateLanguage()
    
    -- Обновляем цвета кнопок
    englishBtn.BackgroundColor3 = lang == "English" and customTheme.AccentColor or customTheme.SecondaryColor
    russianBtn.BackgroundColor3 = lang == "Russian" and customTheme.AccentColor or customTheme.SecondaryColor
    englishBtn.TextColor3 = lang == "English" and Color3.fromRGB(255,255,255) or customTheme.TextSecondaryColor
    russianBtn.TextColor3 = lang == "Russian" and Color3.fromRGB(255,255,255) or customTheme.TextSecondaryColor
end

local function toggleScriptVisibility()
    scriptVisible = not scriptVisible
    window.MainFrame.Visible = scriptVisible
end

local function updateUI()
    -- Обновляем значения статусов
    onBoardValue.Text = tostring(onV.Value)
    onBoardValue.TextColor3 = onV.Value and customTheme.SuccessColor or customTheme.ErrorColor
    
    acceptedValue.Text = tostring(theyV.Value)
    acceptedValue.TextColor3 = theyV.Value and customTheme.SuccessColor or customTheme.ErrorColor
    
    scamValue.Text = tostring(enV.Value)
    scamValue.TextColor3 = enV.Value and customTheme.SuccessColor or customTheme.ErrorColor
    
    xrayValue.Text = tostring(xrayV.Value)
    xrayValue.TextColor3 = xrayV.Value and customTheme.SuccessColor or customTheme.ErrorColor
    
    -- Обновляем текст кнопки
    local lang = languages[currentLanguage]
    toggleButton.Text = enV.Value and lang.disableScam or lang.enableScam
end

local function monitorBoards()
    while true do
        task.wait(0.5)
        local found = false
        if workspace:FindFirstChild("Boards") then
            for _, v in pairs(workspace.Boards:GetChildren()) do
                if v:FindFirstChild("Player1") and (v.Player1.Value == player or v.Player2.Value == player) then
                    onV.Value = true
                    found = true
                    break
                end
            end
        end
        if not found then onV.Value = false end
        updateUI()
    end
end

-- Подключаем события
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        enV.Value = not enV.Value
        updateUI()
    end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        toggleScriptVisibility()
    end
end)

window.CloseButton.MouseButton1Click:Connect(function()
    window:Destroy()
    script:Destroy()
end)

window.SettingsButton.MouseButton1Click:Connect(function()
    settingsFrame.Visible = true
end)

settingsClose.MouseButton1Click:Connect(function()
    settingsFrame.Visible = false
end)

englishBtn.MouseButton1Click:Connect(function()
    setLanguage("English")
end)

russianBtn.MouseButton1Click:Connect(function()
    setLanguage("Russian")
end)

-- Инициализация
setLanguage("English")
updateUI()
coroutine.wrap(monitorBoards)()

-- ПРИМЕР КАК МЕНЯТЬ ТЕМУ ДИНАМИЧЕСКИ (можно раскомментировать)
--[[
task.wait(5)
window:UpdateTheme({
    BackgroundColor = Color3.fromRGB(40, 20, 40),
    AccentColor = Color3.fromRGB(255, 100, 200),
    ButtonStyle = {
        CornerRadius = 4,
        FontSize = 16
    }
})
--]]
