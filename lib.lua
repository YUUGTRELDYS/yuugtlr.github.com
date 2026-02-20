local YUUGTRL = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

-- Уведомление о загрузке
local function showNotify()
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "YUUGTRL_Notify"
    notifyGui.ResetOnSpawn = false
    notifyGui.Parent = player:WaitForChild("PlayerGui")
    notifyGui.IgnoreGuiInset = true
    notifyGui.DisplayOrder = 9999
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 160, 0, 36)
    frame.Position = UDim2.new(0.5, -80, 0, -40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel = 0
    frame.Parent = notifyGui
    frame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
    })
    gradient.Rotation = 45
    gradient.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -10, 1, 0)
    text.Position = UDim2.new(0, 5, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = "YUUGTRL"
    text.TextColor3 = Color3.fromRGB(170, 85, 255)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 16
    text.Parent = frame
    
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -80, 0, 20)
    })
    tweenIn:Play()
    
    task.wait(1.2)
    
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -80, 0, -40)
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        notifyGui:Destroy()
    end)
end

spawn(showNotify)

-- Вспомогательные функции
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createGradient(parent, fromColor, toColor, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, fromColor), ColorSequenceKeypoint.new(1, toColor)})
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

local function makeDraggable(frame, handle)
    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Основная функция создания окна
function YUUGTRL:CreateWindow(title, size, options)
    options = options or {}
    size = size or (isMobile and UDim2.new(0, 280, 0, 320) or UDim2.new(0, 350, 0, 400))
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "YUUGTRL_" .. title
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999
    
    -- Основное окно
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = size
    mainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    createCorner(mainFrame, 8)
    createGradient(mainFrame, Color3.fromRGB(40, 40, 50), Color3.fromRGB(25, 25, 35), 45)
    
    -- Шапка
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, isMobile and 35 or 40)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    createCorner(header, 8)
    createGradient(header, Color3.fromRGB(60, 60, 80), Color3.fromRGB(40, 40, 55))
    
    -- Заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = isMobile and 14 or 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    local windowObj = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        Header = header,
        Container = nil,
        Buttons = {},
        CloseButton = nil,
        SettingsButton = nil
    }
    
    -- Кнопки в шапке
    local buttonX = isMobile and -35 or -40
    
    if options.ShowSettings then
        local settingsBtn = Instance.new("TextButton")
        settingsBtn.Size = UDim2.new(0, isMobile and 28 or 32, 0, isMobile and 28 or 32)
        settingsBtn.Position = UDim2.new(1, buttonX, 0.5, - (isMobile and 14 or 16))
        settingsBtn.BackgroundColor3 = options.SettingsColor or Color3.fromRGB(80, 100, 220)
        settingsBtn.Text = "⚙"
        settingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        settingsBtn.Font = Enum.Font.GothamBold
        settingsBtn.TextSize = isMobile and 16 or 18
        settingsBtn.Parent = header
        createCorner(settingsBtn, 6)
        createGradient(settingsBtn, 
            Color3.fromRGB(100, 120, 240), 
            Color3.fromRGB(70, 90, 200))
        
        windowObj.SettingsButton = settingsBtn
        buttonX = buttonX - (isMobile and 35 or 40)
    end
    
    if options.ShowClose ~= false then
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, isMobile and 28 or 32, 0, isMobile and 28 or 32)
        closeBtn.Position = UDim2.new(1, buttonX, 0.5, - (isMobile and 14 or 16))
        closeBtn.BackgroundColor3 = options.CloseColor or Color3.fromRGB(200, 70, 70)
        closeBtn.Text = "×"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = isMobile and 18 or 20
        closeBtn.Parent = header
        createCorner(closeBtn, 6)
        createGradient(closeBtn, 
            Color3.fromRGB(230, 90, 90), 
            Color3.fromRGB(180, 60, 60))
        
        windowObj.CloseButton = closeBtn
    end
    
    makeDraggable(mainFrame, header)
    
    -- Контейнер для элементов
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 1, -(header.Size.Y.Offset + 20))
    container.Position = UDim2.new(0, 10, 0, header.Size.Y.Offset + 10)
    container.BackgroundTransparency = 1
    container.Parent = mainFrame
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.Parent = container
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, isMobile and 4 or 6)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Parent = scrollingFrame
    
    windowObj.Container = scrollingFrame
    windowObj.Layout = listLayout
    
    -- Метод добавления кнопки
    function windowObj:AddButton(text, color, callback)
        color = color or Color3.fromRGB(80, 100, 220)
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, isMobile and 35 or 40)
        button.BackgroundColor3 = color
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = isMobile and 12 or 14
        button.Parent = self.Container
        button.AutoButtonColor = false
        
        createCorner(button, 8)
        createGradient(button, 
            Color3.new(math.min(color.R*1.2,1), math.min(color.G*1.2,1), math.min(color.B*1.2,1)),
            Color3.new(color.R*0.8, color.G*0.8, color.B*0.8))
        
        button.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        
        table.insert(self.Buttons, button)
        self.Container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
        
        return button
    end
    
    -- Метод добавления текста
    function windowObj:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, isMobile and 20 or 25)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = isMobile and 12 or 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = self.Container
        
        self.Container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
        
        return label
    end
    
    -- Метод добавления кредита
    function windowObj:AddCredit(text, color)
        local credit = Instance.new("TextLabel")
        credit.Size = UDim2.new(1, -20, 0, 15)
        credit.Position = UDim2.new(0, 10, 1, -20)
        credit.BackgroundTransparency = 1
        credit.Text = text
        credit.TextColor3 = color or Color3.fromRGB(170, 85, 255)
        credit.Font = Enum.Font.GothamBold
        credit.TextSize = 11
        credit.TextXAlignment = Enum.TextXAlignment.Right
        credit.Parent = self.MainFrame
        return credit
    end
    
    -- Метод уничтожения
    function windowObj:Destroy()
        screenGui:Destroy()
    end
    
    return windowObj
end

-- Уведомления
function YUUGTRL:CreateNotification(title, message, duration)
    duration = duration or 3
    
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "YUUGTRL_Notification"
    notifGui.ResetOnSpawn = false
    notifGui.Parent = player:WaitForChild("PlayerGui")
    notifGui.IgnoreGuiInset = true
    notifGui.DisplayOrder = 9998
    
    local frame = Instance.new("Frame")
    frame.Size = isMobile and UDim2.new(0, 220, 0, 60) or UDim2.new(0, 260, 0, 70)
    frame.Position = UDim2.new(0.5, -130, 0, -100)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.Parent = notifGui
    frame.Draggable = true
    createCorner(frame, 8)
    createGradient(frame, Color3.fromRGB(40, 40, 50), Color3.fromRGB(25, 25, 35), 45)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, isMobile and 20 or 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = isMobile and 12 or 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, isMobile and 20 or 25)
    messageLabel.Position = UDim2.new(0, 10, 0, isMobile and 25 or 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    messageLabel.Font = Enum.Font.GothamBold
    messageLabel.TextSize = isMobile and 11 or 13
    messageLabel.Parent = frame
    
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -130, 0, 20)
    })
    tweenIn:Play()
    
    task.wait(duration)
    
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -130, 0, -100)
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        notifGui:Destroy()
    end)
end

-- Проверка на мобильное устройство
function YUUGTRL:IsMobile()
    return isMobile
end

return YUUGTRL
