local YUUGTRL = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled
local viewportSize = workspace.CurrentCamera.ViewportSize

local scale = 1
if isMobile then
    scale = math.min(viewportSize.X / 600, 0.9)
end

local splash = Instance.new("ScreenGui")
splash.Name = "YUUGTRLSplash"
splash.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
splash.DisplayOrder = 9999
splash.ResetOnSpawn = false
splash.Parent = player:WaitForChild("PlayerGui")

local splashWidth = 200 * scale
local splashHeight = 50 * scale
local splashFrame = Instance.new("Frame")
splashFrame.Size = UDim2.new(0, splashWidth, 0, splashHeight)
splashFrame.Position = UDim2.new(1, -splashWidth - 15, 0, 15)
splashFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
splashFrame.BackgroundTransparency = 0.2
splashFrame.BorderSizePixel = 0
splashFrame.Parent = splash

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10 * scale)
corner.Parent = splashFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
})
gradient.Rotation = 90
gradient.Parent = splashFrame

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0.6, -5 * scale, 1, 0)
logo.Position = UDim2.new(0, 8 * scale, 0, 0)
logo.BackgroundTransparency = 1
logo.Text = "YUUGTRL"
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 22 * scale
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.Parent = splashFrame

local loaded = Instance.new("TextLabel")
loaded.Size = UDim2.new(0.4, -5 * scale, 1, 0)
loaded.Position = UDim2.new(0.6, 0, 0, 0)
loaded.BackgroundTransparency = 1
loaded.Text = "loaded"
loaded.TextColor3 = Color3.fromRGB(255, 255, 255)
loaded.Font = Enum.Font.Gotham
loaded.TextSize = 14 * scale
loaded.TextXAlignment = Enum.TextXAlignment.Left
loaded.Parent = splashFrame

splashFrame:TweenPosition(UDim2.new(1, -splashWidth - 15, 0, 15), "Out", "Quad", 0.3, true)

task.wait(0.2)

local textColorTween = TweenService:Create(logo, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(170, 85, 255)})
textColorTween:Play()

task.wait(1.2)

local fadeTween = TweenService:Create(splashFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
    Position = UDim2.new(1, -splashWidth - 15, 1, splashHeight + 15),
    BackgroundTransparency = 1
})
fadeTween:Play()
TweenService:Create(logo, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
TweenService:Create(loaded, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()

fadeTween.Completed:Connect(function()
    splash:Destroy()
end)

local languages = {}
local currentLanguage = "English"
local translatableElements = {}
local themes = {
    dark = {
        MainColor = Color3.fromRGB(30, 30, 40),
        HeaderColor = Color3.fromRGB(40, 40, 50),
        TextColor = Color3.fromRGB(255, 255, 255),
        AccentColor = Color3.fromRGB(80, 100, 220),
        ButtonColor = Color3.fromRGB(60, 100, 200),
        FrameColor = Color3.fromRGB(35, 35, 45),
        InputColor = Color3.fromRGB(40, 40, 50),
        ScrollBarColor = Color3.fromRGB(100, 100, 150),
        DangerColor = Color3.fromRGB(255, 100, 100),
        SuccessColor = Color3.fromRGB(100, 255, 100),
        WarningColor = Color3.fromRGB(255, 200, 100)
    },
    black = {
        MainColor = Color3.fromRGB(10, 10, 10),
        HeaderColor = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(255, 255, 255),
        AccentColor = Color3.fromRGB(100, 100, 100),
        ButtonColor = Color3.fromRGB(80, 80, 80),
        FrameColor = Color3.fromRGB(15, 15, 15),
        InputColor = Color3.fromRGB(25, 25, 25),
        ScrollBarColor = Color3.fromRGB(150, 150, 150),
        DangerColor = Color3.fromRGB(255, 100, 100),
        SuccessColor = Color3.fromRGB(100, 255, 100),
        WarningColor = Color3.fromRGB(255, 200, 100)
    }
}
local currentTheme = themes.dark

local notificationHolder = Instance.new("ScreenGui")
notificationHolder.Name = "YUUGTRLNotifications"
notificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
notificationHolder.DisplayOrder = 99999
notificationHolder.ResetOnSpawn = false
notificationHolder.Parent = player:WaitForChild("PlayerGui")

local notificationList = Instance.new("Frame")
notificationList.Name = "NotificationList"
notificationList.Size = UDim2.new(0, 300 * scale, 1, -20 * scale)
notificationList.Position = UDim2.new(1, -310 * scale, 0, 10 * scale)
notificationList.BackgroundTransparency = 1
notificationList.Parent = notificationHolder

local notificationLayout = Instance.new("UIListLayout")
notificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
notificationLayout.Padding = UDim.new(0, 6 * scale)
notificationLayout.Parent = notificationList

function YUUGTRL:Notify(title, message, duration, notifyType)
    duration = duration or 3
    notifyType = notifyType or "info"
    
    local colors = {
        info = {
            main = Color3.fromRGB(80, 100, 220),
            accent = Color3.fromRGB(100, 120, 255)
        },
        success = {
            main = Color3.fromRGB(60, 180, 100),
            accent = Color3.fromRGB(80, 220, 120)
        },
        error = {
            main = Color3.fromRGB(220, 70, 70),
            accent = Color3.fromRGB(255, 100, 100)
        },
        warning = {
            main = Color3.fromRGB(255, 170, 60),
            accent = Color3.fromRGB(255, 200, 100)
        }
    }
    
    local colorSet = colors[notifyType] or colors.info
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 280 * scale, 0, 0)
    notification.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.ClipsDescendants = true
    notification.Parent = notificationList
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8 * scale)
    corner.Parent = notification
    
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(0, 4 * scale, 1, 0)
    accentLine.Position = UDim2.new(0, 0, 0, 0)
    accentLine.BackgroundColor3 = colorSet.accent
    accentLine.BorderSizePixel = 0
    accentLine.Parent = notification
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 8 * scale)
    accentCorner.Parent = accentLine
    
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 30 * scale, 0, 30 * scale)
    icon.Position = UDim2.new(0, 8 * scale, 0, 8 * scale)
    icon.BackgroundTransparency = 1
    icon.TextColor3 = colorSet.accent
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 18 * scale
    icon.Text = notifyType == "success" and "✓" or notifyType == "error" and "✗" or notifyType == "warning" and "!" or "ℹ"
    icon.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -50 * scale, 0, 18 * scale)
    titleLabel.Position = UDim2.new(0, 45 * scale, 0, 8 * scale)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14 * scale
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -50 * scale, 0, 0)
    messageLabel.Position = UDim2.new(0, 45 * scale, 0, 28 * scale)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 12 * scale
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.RichText = true
    messageLabel.Parent = notification
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 20 * scale, 0, 20 * scale)
    closeBtn.Position = UDim2.new(1, -25 * scale, 0, 8 * scale)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18 * scale
    closeBtn.Parent = notification
    
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 0, 2 * scale)
    progressBar.Position = UDim2.new(0, 0, 1, -2 * scale)
    progressBar.BackgroundColor3 = colorSet.main
    progressBar.BorderSizePixel = 0
    progressBar.Parent = notification
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 2 * scale)
    progressCorner.Parent = progressBar
    
    local textHeight = messageLabel.TextBounds.Y + 10
    messageLabel.Size = UDim2.new(1, -50 * scale, 0, textHeight)
    notification.Size = UDim2.new(0, 280 * scale, 0, textHeight + 45 * scale)
    
    notification.Position = UDim2.new(1, 50, 0, 0)
    notification.BackgroundTransparency = 1
    accentLine.BackgroundTransparency = 1
    icon.TextTransparency = 1
    titleLabel.TextTransparency = 1
    messageLabel.TextTransparency = 1
    closeBtn.TextTransparency = 1
    
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, -290 * scale, 0, 0),
        BackgroundTransparency = 0.1
    }):Play()
    
    TweenService:Create(accentLine, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(messageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(closeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        TextTransparency = 0
    }):Play()
    
    closeBtn.MouseButton1Click:Connect(function()
        YUUGTRL:HideNotification(notification)
    end)
    
    closeBtn.MouseEnter:Connect(function()
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)
    
    if duration > 0 then
        local progressTween = TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 2 * scale)
        })
        progressTween:Play()
        
        task.wait(duration)
        if notification.Parent then
            YUUGTRL:HideNotification(notification)
        end
    end
    
    return notification
end

function YUUGTRL:HideNotification(notification)
    if not notification then return end
    
    TweenService:Create(notification, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, 50, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    
    for _, v in pairs(notification:GetChildren()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                TextTransparency = 1
            }):Play()
        elseif v:IsA("Frame") and v.Name ~= "ProgressBar" then
            TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            }):Play()
        end
    end
    
    task.wait(0.2)
    if notification.Parent then
        notification:Destroy()
    end
end

function YUUGTRL:SetTheme(themeName)
    if themes[themeName] then
        currentTheme = themes[themeName]
        return true
    end
    return false
end

function YUUGTRL:GetTheme()
    return currentTheme
end

function YUUGTRL:AddTheme(name, themeTable)
    themes[name] = themeTable
end

function YUUGTRL:AddLanguage(name, translations)
    languages[name] = translations
end

function YUUGTRL:ChangeLanguage(lang)
    if languages[lang] then
        currentLanguage = lang
        self:UpdateAllTexts()
        return true
    end
    return false
end

function YUUGTRL:GetCurrentLanguage()
    return currentLanguage
end

function YUUGTRL:GetLanguages()
    local langs = {}
    for lang, _ in pairs(languages) do
        table.insert(langs, lang)
    end
    return langs
end

function YUUGTRL:GetText(key)
    return languages[currentLanguage] and languages[currentLanguage][key] or key
end

function YUUGTRL:RegisterTranslatable(element, key)
    if element and key then
        table.insert(translatableElements, {element = element, key = key})
    end
end

function YUUGTRL:UpdateAllTexts()
    for i = #translatableElements, 1, -1 do
        local item = translatableElements[i]
        if item.element and item.element.Parent then
            local newText = self:GetText(item.key)
            if newText then
                pcall(function()
                    if item.element:IsA("TextLabel") or item.element:IsA("TextButton") then
                        item.element.Text = newText
                    end
                end)
            end
        else
            table.remove(translatableElements, i)
        end
    end
end

local function Create(props)
    local obj = Instance.new(props.type)
    for i, v in pairs(props) do
        if i ~= "type" and i ~= "children" then
            obj[i] = v
        end
    end
    if props.children then
        for _, child in pairs(props.children) do
            child.Parent = obj
        end
    end
    return obj
end

function YUUGTRL:CreateButton(parent, text, callback, color, position, size)
    if not parent then return end
    
    local btnColor = color or currentTheme.ButtonColor
    
    local btn = Create({
        type = "TextButton",
        Size = size or UDim2.new(0, 120 * scale, 0, 35 * scale),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = btnColor,
        Text = text or "Button",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14 * scale,
        Parent = parent
    })
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8 * scale)
    corner.Parent = btn
    
    local darker = Color3.fromRGB(
        math.max(btnColor.R * 255 - 50, 0),
        math.max(btnColor.G * 255 - 50, 0),
        math.max(btnColor.B * 255 - 50, 0)
    )
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, btnColor),
        ColorSequenceKeypoint.new(1, darker)
    })
    gradient.Rotation = 90
    gradient.Parent = btn
    
    local brighter = Color3.fromRGB(
        math.min(btnColor.R * 255 + 200, 255),
        math.min(btnColor.G * 255 + 200, 255),
        math.min(btnColor.B * 255 + 200, 255)
    )
    btn.TextColor3 = brighter
    
    btn.MouseEnter:Connect(function()
        local hoverColor = Color3.fromRGB(
            math.min(btnColor.R * 255 + 30, 255),
            math.min(btnColor.G * 255 + 30, 255),
            math.min(btnColor.B * 255 + 30, 255)
        )
        local hoverDarker = Color3.fromRGB(
            math.max(hoverColor.R * 255 - 50, 0),
            math.max(hoverColor.G * 255 - 50, 0),
            math.max(hoverColor.B * 255 - 50, 0)
        )
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, hoverColor),
            ColorSequenceKeypoint.new(1, hoverDarker)
        })
    end)
    
    btn.MouseLeave:Connect(function()
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, btnColor),
            ColorSequenceKeypoint.new(1, darker)
        })
    end)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

function YUUGTRL:DarkenButton(button)
    if not button then return end
    local gradient = button:FindFirstChildOfClass("UIGradient")
    if gradient then
        local currentColor = gradient.Color.Keypoints[1].Value
        local darker = Color3.fromRGB(
            math.max(currentColor.R * 255 - 70, 0),
            math.max(currentColor.G * 255 - 70, 0),
            math.max(currentColor.B * 255 - 70, 0)
        )
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, darker),
            ColorSequenceKeypoint.new(1, darker)
        })
    end
end

function YUUGTRL:RestoreButtonStyle(button, color)
    if not button then return end
    local gradient = button:FindFirstChildOfClass("UIGradient")
    if gradient then
        local darker = Color3.fromRGB(
            math.max(color.R * 255 - 50, 0),
            math.max(color.G * 255 - 50, 0),
            math.max(color.B * 255 - 50, 0)
        )
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(1, darker)
        })
        local brighter = Color3.fromRGB(
            math.min(color.R * 255 + 200, 255),
            math.min(color.G * 255 + 200, 255),
            math.min(color.B * 255 + 200, 255)
        )
        button.TextColor3 = brighter
    end
end

function YUUGTRL:CreateButtonToggle(parent, text, default, callback, position, size, colors)
    if not parent then return end
    
    colors = colors or {}
    local isOn = default or false
    
    local buttonColor = colors.off or currentTheme.ButtonColor
    if colors.on then
        buttonColor = colors.on
    end
    
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 120 * scale, 0, 35 * scale)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = buttonColor
    button.Text = text or "Button"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14 * scale
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8 * scale)
    corner.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Parent = button
    
    local brighter = Color3.fromRGB(
        math.min(buttonColor.R * 255 + 200, 255),
        math.min(buttonColor.G * 255 + 200, 255),
        math.min(buttonColor.B * 255 + 200, 255)
    )
    
    local function updateGradient()
        local grad = button:FindFirstChildOfClass("UIGradient")
        if not grad then
            grad = Instance.new("UIGradient")
            grad.Rotation = 90
            grad.Parent = button
        end
        
        local currentColor = buttonColor
        local darkAmount = isOn and 70 or 50
        local darker2 = Color3.fromRGB(
            math.max(currentColor.R * 255 - darkAmount, 0),
            math.max(currentColor.G * 255 - darkAmount, 0),
            math.max(currentColor.B * 255 - darkAmount, 0)
        )
        
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, isOn and darker2 or currentColor),
            ColorSequenceKeypoint.new(1, darker2)
        })
        
        if isOn then
            button.TextColor3 = Color3.fromRGB(
                math.min(currentColor.R * 255 + 230, 255),
                math.min(currentColor.G * 255 + 230, 255),
                math.min(currentColor.B * 255 + 230, 255)
            )
        else
            button.TextColor3 = brighter
        end
    end
    
    updateGradient()
    
    button.MouseEnter:Connect(function()
        local currentColor = buttonColor
        local hoverColor = Color3.fromRGB(
            math.min(currentColor.R * 255 + 30, 255),
            math.min(currentColor.G * 255 + 30, 255),
            math.min(currentColor.B * 255 + 30, 255)
        )
        local hoverDarker = Color3.fromRGB(
            math.max(hoverColor.R * 255 - 50, 0),
            math.max(hoverColor.G * 255 - 50, 0),
            math.max(hoverColor.B * 255 - 50, 0)
        )
        
        local grad = button:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, hoverColor),
                ColorSequenceKeypoint.new(1, hoverDarker)
            })
        end
        
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    button.MouseLeave:Connect(function()
        updateGradient()
    end)
    
    button.MouseButton1Click:Connect(function()
        isOn = not isOn
        updateGradient()
        if callback then
            pcall(callback, isOn)
        end
    end)
    
    local toggleObject = {}
    
    function toggleObject:SetState(state)
        isOn = state
        updateGradient()
        if callback then pcall(callback, isOn) end
    end
    
    function toggleObject:GetState()
        return isOn
    end
    
    function toggleObject:Toggle()
        isOn = not isOn
        updateGradient()
        if callback then pcall(callback, isOn) end
    end
    
    function toggleObject:SetText(newText)
        button.Text = newText
    end
    
    function toggleObject:SetColors(newColors)
        if newColors.on then buttonColor = newColors.on end
        if newColors.off then buttonColor = newColors.off end
        updateGradient()
    end
    
    function toggleObject:Destroy()
        button:Destroy()
    end
    
    toggleObject.button = button
    
    return toggleObject
end

function YUUGTRL:CreateWindow(title, size, position, options)
    options = options or {}
    
    local screenSize = workspace.CurrentCamera.ViewportSize
    local scale = 1
    if isMobile then
        scale = math.min(screenSize.X / 600, 0.9)
    end
    
    local windowSize = size
    if size then
        windowSize = UDim2.new(size.X.Scale, size.X.Offset * scale, size.Y.Scale, size.Y.Offset * scale)
    else
        windowSize = UDim2.new(0, 350 * scale, 0, 450 * scale)
    end
    
    local windowPos = position
    if not windowPos then
        windowPos = UDim2.new(0.5, -(175 * scale), 0.5, -(225 * scale))
    elseif position then
        windowPos = UDim2.new(position.X.Scale, position.X.Offset * scale, position.Y.Scale, position.Y.Offset * scale)
    end
    
    local ScreenGui = Create({
        type = "ScreenGui",
        Name = "YUUGTRL_" .. (title:gsub("%s+", "") or "Window"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })
    
    local Main = Create({
        type = "Frame",
        Size = windowSize,
        Position = windowPos,
        BackgroundColor3 = options.MainColor or currentTheme.MainColor,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    Create({type = "UICorner",CornerRadius = UDim.new(0, 12 * scale),Parent = Main})
    
    local Header = Create({
        type = "Frame",
        Size = UDim2.new(1, 0, 0, 40 * scale),
        BackgroundColor3 = options.HeaderColor or currentTheme.HeaderColor,
        BorderSizePixel = 0,
        Parent = Main
    })
    
    Create({type = "UICorner",CornerRadius = UDim.new(0, 12 * scale),Parent = Header})
    
    local Title = self:CreateLabel(Header, title, UDim2.new(0, 15 * scale, 0, 0), UDim2.new(1, -100 * scale, 1, 0), options.TextColor or currentTheme.TextColor)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 18 * scale
    if options.titleKey then
        self:RegisterTranslatable(Title, options.titleKey)
    end
    
    local SettingsBtn
    local CloseBtn
    
    if options.ShowSettings ~= false then
        SettingsBtn = self:CreateButton(Header, "⚙", nil, options.AccentColor or currentTheme.AccentColor, UDim2.new(1, -70 * scale, 0, 5 * scale), UDim2.new(0, 30 * scale, 0, 30 * scale))
    end
    
    if options.ShowClose ~= false then
        CloseBtn = self:CreateButton(Header, "X", nil, options.CloseColor or Color3.fromRGB(255, 100, 100), UDim2.new(1, -35 * scale, 0, 5 * scale), UDim2.new(0, 30 * scale, 0, 30 * scale))
        CloseBtn.MouseButton1Click:Connect(function() 
            ScreenGui:Destroy() 
        end)
    end
    
    local dragging, dragInput, dragStart, startPos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local window = {
        ScreenGui = ScreenGui,
        Main = Main,
        Header = Header,
        Title = Title,
        SettingsBtn = SettingsBtn,
        CloseBtn = CloseBtn,
        elements = {},
        scale = scale,
        options = options
    }
    
    function window:SetMainColor(color)
        self.Main.BackgroundColor3 = color
    end
    
    function window:SetHeaderColor(color)
        self.Header.BackgroundColor3 = color
    end
    
    function window:SetTextColor(color)
        self.Title.TextColor3 = color
        for _, element in pairs(self.elements) do
            if element.type == "label" and element.obj then
                element.obj.TextColor3 = color
            end
        end
    end
    
    function window:SetCornerRadius(radius)
        for _, v in pairs(self.Main:GetChildren()) do
            if v:IsA("UICorner") then
                v.CornerRadius = UDim.new(0, radius * self.scale)
            end
        end
        for _, v in pairs(self.Header:GetChildren()) do
            if v:IsA("UICorner") then
                v.CornerRadius = UDim.new(0, radius * self.scale)
            end
        end
    end
    
    function window:CreateFrame(size, position, color, radius)
        local frameSize = size and UDim2.new(size.X.Scale, size.X.Offset * self.scale, size.Y.Scale, size.Y.Offset * self.scale) or nil
        local framePos = position and UDim2.new(position.X.Scale, position.X.Offset * self.scale, position.Y.Scale, position.Y.Offset * self.scale) or nil
        return YUUGTRL:CreateFrame(self.Main, frameSize, framePos, color, radius and radius * self.scale)
    end
    
    function window:CreateScrollingFrame(size, position, color, radius)
        local frameSize = size and UDim2.new(size.X.Scale, size.X.Offset * self.scale, size.Y.Scale, size.Y.Offset * self.scale) or nil
        local framePos = position and UDim2.new(position.X.Scale, position.X.Offset * self.scale, position.Y.Scale, position.Y.Offset * self.scale) or nil
        return YUUGTRL:CreateScrollingFrame(self.Main, frameSize, framePos, color, radius and radius * self.scale)
    end
    
    function window:CreateLabel(text, position, size, color, translationKey)
        local labelPos = position and UDim2.new(position.X.Scale, position.X.Offset * self.scale, position.Y.Scale, position.Y.Offset * self.scale) or nil
        local labelSize = size and UDim2.new(size.X.Scale, size.X.Offset * self.scale, size.Y.Scale, size.Y.Offset * self.scale) or nil
        local label = YUUGTRL:CreateLabel(self.Main, text, labelPos, labelSize, color)
        label.TextSize = label.TextSize * self.scale
        if translationKey then
            YUUGTRL:RegisterTranslatable(label, translationKey)
        end
        table.insert(self.elements, {type = "label", obj = label})
        return label
    end
    
    function window:CreateButton(text, callback, color, position, size, translationKey)
        local btnPos = position and UDim2.new(position.X.Scale, position.X.Offset * self.scale, position.Y.Scale, position.Y.Offset * self.scale) or nil
        local btnSize = size and UDim2.new(size.X.Scale, size.X.Offset * self.scale, size.Y.Scale, size.Y.Offset * self.scale) or nil
        local btn = YUUGTRL:CreateButton(self.Main, text, callback,
