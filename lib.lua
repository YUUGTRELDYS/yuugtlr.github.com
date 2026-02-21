local YUUGTRL = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled
local viewportSize = workspace.CurrentCamera.ViewportSize

local scale = 1
if isMobile then
    scale = math.min(viewportSize.X / 500, 1)
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

function YUUGTRL:ApplyButtonStyle(button, color)
    if not button then return end
    for _, v in pairs(button:GetChildren()) do
        if v:IsA("UIGradient") then
            v:Destroy()
        end
    end
    local darker = Color3.fromRGB(math.max(color.R * 255 - 50, 0), math.max(color.G * 255 - 50, 0), math.max(color.B * 255 - 50, 0))
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color),ColorSequenceKeypoint.new(1, darker)})
    gradient.Rotation = 90
    gradient.Parent = button
    local brighter = Color3.fromRGB(math.min(color.R * 255 + 120, 255), math.min(color.G * 255 + 120, 255), math.min(color.B * 255 + 120, 255))
    button.TextColor3 = brighter
    button.Font = Enum.Font.GothamBold
    return button
end

function YUUGTRL:DarkenButton(button)
    if not button or not button:FindFirstChild("UIGradient") then return end
    local gradient = button:FindFirstChild("UIGradient")
    local color = gradient.Color.Keypoints[1].Value
    local darker = Color3.fromRGB(math.max(color.R * 255 - 90, 0), math.max(color.G * 255 - 90, 0), math.max(color.B * 255 - 90, 0))
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, darker),ColorSequenceKeypoint.new(1, darker)})
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
end

function YUUGTRL:LightenButton(button)
    if not button or not button:FindFirstChild("UIGradient") then return end
    local gradient = button:FindFirstChild("UIGradient")
    local color = gradient.Color.Keypoints[1].Value
    local lighter = Color3.fromRGB(math.min(color.R * 255 + 90, 255), math.min(color.G * 255 + 90, 255), math.min(color.B * 255 + 90, 255))
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, lighter),ColorSequenceKeypoint.new(1, lighter)})
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
end

function YUUGTRL:RestoreButtonStyle(button, color)
    if not button or not button:FindFirstChild("UIGradient") then return end
    local gradient = button:FindFirstChild("UIGradient")
    local darker = Color3.fromRGB(math.max(color.R * 255 - 50, 0), math.max(color.G * 255 - 50, 0), math.max(color.B * 255 - 50, 0))
    local brighter = Color3.fromRGB(math.min(color.R * 255 + 120, 255), math.min(color.G * 255 + 120, 255), math.min(color.B * 255 + 120, 255))
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color),ColorSequenceKeypoint.new(1, darker)})
    button.TextColor3 = brighter
end

function YUUGTRL:MakeButton(button, color, style)
    if not button then return end
    local btnColor = color or Color3.fromRGB(60, 100, 200)
    local btnStyle = style or "darken"
    
    self:ApplyButtonStyle(button, btnColor)
    
    if btnStyle == "darken" then
        button.MouseButton1Down:Connect(function() 
            self:DarkenButton(button) 
        end)
        button.MouseButton1Up:Connect(function() 
            self:RestoreButtonStyle(button, btnColor) 
        end)
    elseif btnStyle == "lighten" then
        button.MouseButton1Down:Connect(function() 
            self:LightenButton(button) 
        end)
        button.MouseButton1Up:Connect(function() 
            self:RestoreButtonStyle(button, btnColor) 
        end)
    elseif btnStyle == "hover" then
        button.MouseEnter:Connect(function() 
            self:LightenButton(button) 
        end)
        button.MouseLeave:Connect(function() 
            self:RestoreButtonStyle(button, btnColor) 
        end)
    elseif btnStyle == "hover-dark" then
        button.MouseEnter:Connect(function() 
            self:DarkenButton(button) 
        end)
        button.MouseLeave:Connect(function() 
            self:RestoreButtonStyle(button, btnColor) 
        end)
    end
    
    return button
end

function YUUGTRL:CreateWindow(title, size, position, options)
    options = options or {}
    
    local screenSize = workspace.CurrentCamera.ViewportSize
    local scale = 1
    if isMobile then
        scale = math.min(screenSize.X / 500, 1)
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
        BackgroundColor3 = options.MainColor or Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    Create({type = "UICorner",CornerRadius = UDim.new(0, 12 * scale),Parent = Main})
    
    local Header = Create({
        type = "Frame",
        Size = UDim2.new(1, 0, 0, 40 * scale),
        BackgroundColor3 = options.HeaderColor or Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Parent = Main
    })
    
    Create({type = "UICorner",CornerRadius = UDim.new(0, 12 * scale),Parent = Header})
    
    local Title = self:CreateLabel(Header, title, UDim2.new(0, 15 * scale, 0, 0), UDim2.new(1, -100 * scale, 1, 0), options.TextColor or Color3.fromRGB(255, 255, 255))
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 18 * scale
    if options.titleKey then
        self:RegisterTranslatable(Title, options.titleKey)
    end
    
    local SettingsBtn
    local CloseBtn
    
    if options.ShowSettings ~= false then
        SettingsBtn = self:CreateButton(Header, "⚙", nil, options.AccentColor or Color3.fromRGB(80, 100, 220), UDim2.new(1, -70 * scale, 0, 5 * scale), UDim2.new(0, 30 * scale, 0, 30 * scale), "darken")
    end
    
    if options.ShowClose ~= false then
        CloseBtn = self:CreateButton(Header, "X", nil, options.CloseColor or Color3.fromRGB(255, 100, 100), UDim2.new(1, -35 * scale, 0, 5 * scale), UDim2.new(0, 30 * scale, 0, 30 * scale), "darken")
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
    
    function window:CreateButton(text, callback, color, position, size, style, translationKey)
        local btnPos = position and UDim2.new(position.X.Scale, position.X.Offset * self.scale, position.Y.Scale, position.Y.Offset * self.scale) or nil
        local btnSize = size and UDim2.new(size.X.Scale, size.X.Offset * self.scale, size.Y.Scale, size.Y.Offset * self.scale) or nil
        local btn = YUUGTRL:CreateButton(self.Main, text, callback, color, btnPos, btnSize, style)
        btn.TextSize = btn.TextSize * self.scale
        if translationKey then
            YUUGTRL:RegisterTranslatable(btn, translationKey)
        end
        table.insert(self.elements, {type = "button", obj = btn})
        return btn
    end
    
    function window:CreateSlider(text, min, max, default, callback, position, size)
        local sliderPos = position and UDim2.new(position.X.Scale, position.X.Offset * self.scale, position.Y.Scale, position.Y.Offset * self.scale) or nil
        local sliderSize = size and UDim2.new(size.X.Scale, size.X.Offset * self.scale, size.Y.Scale, size.Y.Offset * self.scale) or nil
        return YUUGTRL:CreateSlider(self.Main, text, min, max, default, callback, sliderPos, sliderSize)
    end
    
    function window:SetSettingsCallback(callback)
        if SettingsBtn then
            SettingsBtn.MouseButton1Click:Connect(callback)
        end
    end
    
    function window:SetCloseCallback(callback)
        if CloseBtn then
            CloseBtn.MouseButton1Click:Connect(callback)
        end
    end
    
    function window:Destroy()
        ScreenGui:Destroy()
    end
    
    function window:UpdateLanguage()
        YUUGTRL:UpdateAllTexts()
    end
    
    return window
end

function YUUGTRL:CreateFrame(parent, size, position, color, radius)
    if not parent then return end
    local frame = Create({
        type = "Frame",
        Size = size or UDim2.new(0, 100, 0, 100),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = color or Color3.fromRGB(35, 35, 45),
        BorderSizePixel = 0,
        Parent = parent
    })
    
    Create({type = "UICorner",CornerRadius = UDim.new(0, radius or 12),Parent = frame})
    
    return frame
end

function YUUGTRL:CreateScrollingFrame(parent, size, position, color, radius)
    if not parent then return end
    local frame = Instance.new("ScrollingFrame")
    frame.Size = size or UDim2.new(0, 200, 0, 200)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = color or Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.Parent = parent
    
    if radius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius)
        corner.Parent = frame
    end
    
    return frame
end

function YUUGTRL:CreateLabel(parent, text, position, size, color)
    if not parent then return end
    return Create({
        type = "TextLabel",
        Size = size or UDim2.new(0, 100, 0, 30),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text or "Label",
        TextColor3 = color or Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent
    })
end

function YUUGTRL:CreateButton(parent, text, callback, color, position, size, style)
    if not parent then return end
    local btn = Create({
        type = "TextButton",
        Size = size or UDim2.new(0, 100, 0, 35),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = color or Color3.fromRGB(60, 100, 200),
        Text = text or "Button",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = parent
    })
    
    Create({type = "UICorner",CornerRadius = UDim.new(0, 8),Parent = btn})
    self:MakeButton(btn, color, style)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

function YUUGTRL:CreateSlider(parent, text, min, max, default, callback, position, size)
    if not parent then return end
    local frame = self:CreateFrame(parent, size or UDim2.new(0, 200, 0, 50), position, Color3.fromRGB(45, 45, 55), 8)
    
    self:CreateLabel(frame, text or "", UDim2.new(0, 10, 0, 5), UDim2.new(1, -60, 0, 20))
    
    local valueLabel = self:CreateLabel(frame, tostring(default or 0), UDim2.new(1, -50, 0, 5), UDim2.new(0, 40, 0, 20))
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local slider = self:CreateFrame(frame, UDim2.new(1, -20, 0, 8), UDim2.new(0, 10, 0, 30), Color3.fromRGB(60, 60, 70), 4)
    
    local fill = self:CreateFrame(slider, UDim2.new((default or 0) / max, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(80, 100, 220), 4)
    
    local dragging = false
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position.X - slider.AbsolutePosition.X
            local size = slider.AbsoluteSize.X
            local percent = math.clamp(pos / size, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(value)
            if callback then callback(value) end
        end
    end)
    
    return slider
end

-- Различные типы toggle
function YUUGTRL:CreateToggle(parent, text, default, callback, position, size, toggleType, colors)
    if not parent then return end
    
    colors = colors or {}
    local toggleState = default or false
    local toggleType = toggleType or "modern" -- modern, classic, switch, checkbox, ios, minimal, neon, glass, material, retro
    
    -- Создаем основной фрейм
    local frame = self:CreateFrame(parent, 
        size or UDim2.new(0, 220, 0, 40), 
        position or UDim2.new(0, 0, 0, 0), 
        Color3.fromRGB(45, 45, 55), 
        8
    )
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Toggle"
    label.TextColor3 = colors.text or Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = frame
    
    -- Создаем toggle в зависимости от типа
    local toggleObj
    
    if toggleType == "modern" then
        toggleObj = self:CreateModernToggle(frame, colors, toggleState)
    elseif toggleType == "classic" then
        toggleObj = self:CreateClassicToggle(frame, colors, toggleState)
    elseif toggleType == "switch" then
        toggleObj = self:CreateSwitchToggle(frame, colors, toggleState)
    elseif toggleType == "checkbox" then
        toggleObj = self:CreateCheckboxToggle(frame, colors, toggleState)
    elseif toggleType == "ios" then
        toggleObj = self:CreateIOSToggle(frame, colors, toggleState)
    elseif toggleType == "minimal" then
        toggleObj = self:CreateMinimalToggle(frame, colors, toggleState)
    elseif toggleType == "neon" then
        toggleObj = self:CreateNeonToggle(frame, colors, toggleState)
    elseif toggleType == "glass" then
        toggleObj = self:CreateGlassToggle(frame, colors, toggleState)
    elseif toggleType == "material" then
        toggleObj = self:CreateMaterialToggle(frame, colors, toggleState)
    elseif toggleType == "retro" then
        toggleObj = self:CreateRetroToggle(frame, colors, toggleState)
    else
        toggleObj = self:CreateModernToggle(frame, colors, toggleState)
    end
    
    local toggleBg = toggleObj.bg
    local knob = toggleObj.knob
    
    local function updateToggle(state)
        toggleState = state
        
        if toggleObj.update then
            toggleObj:update(state)
        else
            -- Стандартное обновление для простых toggle
            toggleBg.BackgroundColor3 = state and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or (colors.toggleOff or Color3.fromRGB(100, 100, 100))
            
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
        end
        
        if callback then
            pcall(callback, state)
        end
    end
    
    button.MouseButton1Click:Connect(function()
        updateToggle(not toggleState)
    end)
    
    button.TouchTap:Connect(function()
        updateToggle(not toggleState)
    end)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
    end)
    
    local toggle = {
        frame = frame,
        label = label,
        toggleBg = toggleBg,
        knob = knob,
        button = button,
        toggleObj = toggleObj,
        toggleType = toggleType
    }
    
    function toggle:SetState(state)
        updateToggle(state)
    end
    
    function toggle:GetState()
        return toggleState
    end
    
    function toggle:Toggle()
        updateToggle(not toggleState)
    end
    
    function toggle:SetColors(newColors)
        colors = newColors
        if toggleObj.setColors then
            toggleObj:setColors(newColors)
        end
        label.TextColor3 = newColors.text or label.TextColor3
    end
    
    function toggle:SetText(newText)
        label.Text = newText
    end
    
    function toggle:Destroy()
        frame:Destroy()
    end
    
    return toggle
end

-- Modern Toggle (стандартный)
function YUUGTRL:CreateModernToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 40, 0, 20)
    toggleBg.Position = UDim2.new(1, -45, 0.5, -10)
    toggleBg.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or (colors.toggleOff or Color3.fromRGB(100, 100, 100))
    toggleBg.BackgroundTransparency = 0
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = initialState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = colors.knob or Color3.fromRGB(255, 255, 255)
    knob.BackgroundTransparency = 0
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    return {
        bg = toggleBg,
        knob = knob,
        update = function(self, state)
            toggleBg.BackgroundColor3 = state and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or (colors.toggleOff or Color3.fromRGB(100, 100, 100))
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
        end,
        setColors = function(self, newColors)
            colors = newColors
            toggleBg.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or (colors.toggleOff or Color3.fromRGB(100, 100, 100))
            knob.BackgroundColor3 = colors.knob or Color3.fromRGB(255, 255, 255)
        end
    }
end

-- Classic Toggle (старый стиль)
function YUUGTRL:CreateClassicToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 50, 0, 24)
    toggleBg.Position = UDim2.new(1, -55, 0.5, -12)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggleBg.BackgroundTransparency = 0
    toggleBg.BorderSizePixel = 2
    toggleBg.BorderColor3 = Color3.fromRGB(80, 80, 90)
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = initialState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = colors.knob or Color3.fromRGB(200, 200, 200)
    knob.BackgroundTransparency = 0
    knob.BorderSizePixel = 1
    knob.BorderColor3 = Color3.fromRGB(150, 150, 150)
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 2)
    knobCorner.Parent = knob
    
    local stateIndicator = Instance.new("Frame")
    stateIndicator.Size = UDim2.new(0, 6, 0, 6)
    stateIndicator.Position = UDim2.new(0.5, -3, 0.5, -3)
    stateIndicator.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(150, 150, 150)
    stateIndicator.BackgroundTransparency = 0
    stateIndicator.BorderSizePixel = 0
    stateIndicator.Parent = knob
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = stateIndicator
    
    return {
        bg = toggleBg,
        knob = knob,
        indicator = stateIndicator,
        update = function(self, state)
            stateIndicator.BackgroundColor3 = state and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(150, 150, 150)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local targetPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
        end,
        setColors = function(self, newColors)
            colors = newColors
            stateIndicator.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(150, 150, 150)
        end
    }
end

-- Switch Toggle (как выключатель)
function YUUGTRL:CreateSwitchToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 60, 0, 30)
    toggleBg.Position = UDim2.new(1, -65, 0.5, -15)
    toggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    toggleBg.BackgroundTransparency = 0
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 26, 0, 26)
    knob.Position = initialState and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
    knob.BackgroundColor3 = colors.knob or Color3.fromRGB(255, 255, 255)
    knob.BackgroundTransparency = 0
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local onText = Instance.new("TextLabel")
    onText.Size = UDim2.new(0, 20, 1, 0)
    onText.Position = UDim2.new(0, 5, 0, 0)
    onText.BackgroundTransparency = 1
    onText.Text = "ON"
    onText.TextColor3 = initialState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
    onText.Font = Enum.Font.GothamBold
    onText.TextSize = 10
    onText.TextXAlignment = Enum.TextXAlignment.Left
    onText.Parent = toggleBg
    
    local offText = Instance.new("TextLabel")
    offText.Size = UDim2.new(0, 25, 1, 0)
    offText.Position = UDim2.new(1, -25, 0, 0)
    offText.BackgroundTransparency = 1
    offText.Text = "OFF"
    offText.TextColor3 = initialState and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(255, 255, 255)
    offText.Font = Enum.Font.GothamBold
    offText.TextSize = 10
    offText.TextXAlignment = Enum.TextXAlignment.Right
    offText.Parent = toggleBg
    
    return {
        bg = toggleBg,
        knob = knob,
        onText = onText,
        offText = offText,
        update = function(self, state)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local targetPos = state and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
            
            onText.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
            offText.TextColor3 = state and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(255, 255, 255)
        end,
        setColors = function(self, newColors)
            colors = newColors
            knob.BackgroundColor3 = colors.knob or Color3.fromRGB(255, 255, 255)
        end
    }
end

-- Checkbox Toggle
function YUUGTRL:CreateCheckboxToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 24, 0, 24)
    toggleBg.Position = UDim2.new(1, -29, 0.5, -12)
    toggleBg.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(60, 60, 70)
    toggleBg.BackgroundTransparency = 0
    toggleBg.BorderSizePixel = 2
    toggleBg.BorderColor3 = Color3.fromRGB(80, 80, 90)
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBg
    
    local checkmark = Instance.new("Frame")
    checkmark.Size = UDim2.new(0, 14, 0, 14)
    checkmark.Position = UDim2.new(0.5, -7, 0.5, -7)
    checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    checkmark.BackgroundTransparency = initialState and 0 or 1
    checkmark.BorderSizePixel = 0
    checkmark.Parent = toggleBg
    
    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 2)
    checkCorner.Parent = checkmark
    
    local checkLine1 = Instance.new("Frame")
    checkLine1.Size = UDim2.new(0, 8, 0, 2)
    checkLine1.Position = UDim2.new(0, 2, 0, 7)
    checkLine1.BackgroundColor3 = colors.checkColor or Color3.fromRGB(80, 200, 120)
    checkLine1.BackgroundTransparency = initialState and 0 or 1
    checkLine1.BorderSizePixel = 0
    checkLine1.Rotation = 45
    checkLine1.Parent = checkmark
    
    local checkLine2 = Instance.new("Frame")
    checkLine2.Size = UDim2.new(0, 4, 0, 2)
    checkLine2.Position = UDim2.new(0, 1, 0, 9)
    checkLine2.BackgroundColor3 = colors.checkColor or Color3.fromRGB(80, 200, 120)
    checkLine2.BackgroundTransparency = initialState and 0 or 1
    checkLine2.BorderSizePixel = 0
    checkLine2.Rotation = 45
    checkLine2.Parent = checkmark
    
    return {
        bg = toggleBg,
        checkmark = checkmark,
        checkLine1 = checkLine1,
        checkLine2 = checkLine2,
        update = function(self, state)
            toggleBg.BackgroundColor3 = state and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(60, 60, 70)
            checkmark.BackgroundTransparency = state and 0 or 1
            checkLine1.BackgroundTransparency = state and 0 or 1
            checkLine2.BackgroundTransparency = state and 0 or 1
        end,
        setColors = function(self, newColors)
            colors = newColors
            toggleBg.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(60, 60, 70)
            checkLine1.BackgroundColor3 = colors.checkColor or Color3.fromRGB(80, 200, 120)
            checkLine2.BackgroundColor3 = colors.checkColor or Color3.fromRGB(80, 200, 120)
        end
    }
end

-- iOS Toggle
function YUUGTRL:CreateIOSToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 51, 0, 31)
    toggleBg.Position = UDim2.new(1, -56, 0.5, -15.5)
    toggleBg.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(52, 199, 89)) or Color3.fromRGB(60, 60, 70)
    toggleBg.BackgroundTransparency = 0
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 27, 0, 27)
    knob.Position = initialState and UDim2.new(1, -29, 0.5, -13.5) or UDim2.new(0, 2, 0.5, -13.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BackgroundTransparency = 0
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local shadow = Instance.new("UIGradient")
    shadow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
    })
    shadow.Transparency = NumberSequence.new(0.8)
    shadow.Rotation = 90
    shadow.Parent = knob
    
    return {
        bg = toggleBg,
        knob = knob,
        update = function(self, state)
            toggleBg.BackgroundColor3 = state and (colors.toggleOn or Color3.fromRGB(52, 199, 89)) or Color3.fromRGB(60, 60, 70)
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Spring, Enum.EasingDirection.Out)
            local targetPos = state and UDim2.new(1, -29, 0.5, -13.5) or UDim2.new(0, 2, 0.5, -13.5)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
        end,
        setColors = function(self, newColors)
            colors = newColors
            toggleBg.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(52, 199, 89)) or Color3.fromRGB(60, 60, 70)
        end
    }
end

-- Minimal Toggle
function YUUGTRL:CreateMinimalToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 44, 0, 4)
    toggleBg.Position = UDim2.new(1, -49, 0.5, -2)
    toggleBg.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(100, 100, 100)
    toggleBg.BackgroundTransparency = 0.5
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = initialState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = colors.knob or Color3.fromRGB(200, 200, 200)
    knob.BackgroundTransparency = 0
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    return {
        bg = toggleBg,
        knob = knob,
        update = function(self, state)
            toggleBg.BackgroundColor3 = state and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(100, 100, 100)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
        end,
        setColors = function(self, newColors)
            colors = newColors
            toggleBg.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(80, 200, 120)) or Color3.fromRGB(100, 100, 100)
            knob.BackgroundColor3 = colors.knob or Color3.fromRGB(200, 200, 200)
        end
    }
end

-- Neon Toggle
function YUUGTRL:CreateNeonToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 50, 0, 24)
    toggleBg.Position = UDim2.new(1, -55, 0.5, -12)
    toggleBg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    toggleBg.BackgroundTransparency = 0
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBg
    
    local glow = Instance.new("UIGradient")
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, initialState and (colors.toggleOn or Color3.fromRGB(0, 255, 255)) or Color3.fromRGB(100, 100, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    glow.Transparency = NumberSequence.new(0.8)
    glow.Rotation = 90
    glow.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = initialState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BackgroundTransparency = 0
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
    knobCorner.Parent = knob
    
    local knobGlow = Instance.new("UIGradient")
    knobGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, initialState and (colors.toggleOn or Color3.fromRGB(0, 255, 255)) or Color3.fromRGB(150, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    knobGlow.Rotation = 45
    knobGlow.Parent = knob
    
    return {
        bg = toggleBg,
        knob = knob,
        glow = glow,
        knobGlow = knobGlow,
        update = function(self, state)
            glow.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, state and (colors.toggleOn or Color3.fromRGB(0, 255, 255)) or Color3.fromRGB(100, 100, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
            })
            knobGlow.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, state and (colors.toggleOn or Color3.fromRGB(0, 255, 255)) or Color3.fromRGB(150, 150, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
            
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local targetPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
        end,
        setColors = function(self, newColors)
            colors = newColors
            self:update(initialState)
        end
    }
end

-- Glass Toggle
function YUUGTRL:CreateGlassToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 50, 0, 24)
    toggleBg.Position = UDim2.new(1, -55, 0.5, -12)
    toggleBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleBg.BackgroundTransparency = 0.9
    toggleBg.BorderSizePixel = 1
    toggleBg.BorderColor3 = Color3.fromRGB(255, 255, 255)
    toggleBg.BorderColor3 = Color3.fromRGB(255, 255, 255)
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBg
    
    local glassEffect = Instance.new("UIGradient")
    glassEffect.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 255))
    })
    glassEffect.Transparency = NumberSequence.new(0.8)
    glassEffect.Rotation = 45
    glassEffect.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = initialState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BackgroundTransparency = 0.3
    knob.BorderSizePixel = 1
    knob.BorderColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
    knobCorner.Parent = knob
    
    local knobGlass = Instance.new("UIGradient")
    knobGlass.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 255))
    })
    knobGlass.Transparency = NumberSequence.new(0.5)
    knobGlass.Rotation = 45
    knobGlass.Parent = knob
    
    return {
        bg = toggleBg,
        knob = knob,
        glassEffect = glassEffect,
        update = function(self, state)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local targetPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
        end
    }
end

-- Material Design Toggle
function YUUGTRL:CreateMaterialToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 58, 0, 32)
    toggleBg.Position = UDim2.new(1, -63, 0.5, -16)
    toggleBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    toggleBg.BackgroundTransparency = 0
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 16)
    toggleCorner.Parent = toggleBg
    
    local rippleEffect = Instance.new("Frame")
    rippleEffect.Size = UDim2.new(0, 0, 0, 0)
    rippleEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
    rippleEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    rippleEffect.BackgroundTransparency = 0.5
    rippleEffect.BorderSizePixel = 0
    rippleEffect.Visible = false
    rippleEffect.Parent = toggleBg
    
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(1, 0)
    rippleCorner.Parent = rippleEffect
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 28, 0, 28)
    knob.Position = initialState and UDim2.new(1, -30, 0.5, -14) or UDim2.new(0, 2, 0.5, -14)
    knob.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(98, 0, 238)) or Color3.fromRGB(150, 150, 150)
    knob.BackgroundTransparency = 0
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local elevation = Instance.new("UIGradient")
    elevation.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
    })
    elevation.Transparency = NumberSequence.new(0.5)
    elevation.Rotation = 90
    elevation.Parent = knob
    
    return {
        bg = toggleBg,
        knob = knob,
        ripple = rippleEffect,
        update = function(self, state)
            knob.BackgroundColor3 = state and (colors.toggleOn or Color3.fromRGB(98, 0, 238)) or Color3.fromRGB(150, 150, 150)
            
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local targetPos = state and UDim2.new(1, -30, 0.5, -14) or UDim2.new(0, 2, 0.5, -14)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
            
            -- Ripple effect
            rippleEffect.Visible = true
            rippleEffect.Size = UDim2.new(0, 40, 0, 40)
            TweenService:Create(rippleEffect, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            rippleEffect.Visible = false
        end,
        setColors = function(self, newColors)
            colors = newColors
            knob.BackgroundColor3 = initialState and (colors.toggleOn or Color3.fromRGB(98, 0, 238)) or Color3.fromRGB(150, 150, 150)
        end
    }
end

-- Retro Toggle
function YUUGTRL:CreateRetroToggle(parent, colors, initialState)
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 48, 0, 22)
    toggleBg.Position = UDim2.new(1, -53, 0.5, -11)
    toggleBg.BackgroundColor3 = Color3.fromRGB(80, 60, 40)
    toggleBg.BackgroundTransparency = 0
    toggleBg.BorderSizePixel = 2
    toggleBg.BorderColor3 = Color3.fromRGB(120, 80, 50)
    toggleBg.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = initialState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(200, 180, 150)
    knob.BackgroundTransparency = 0
    knob.BorderSizePixel = 1
    knob.BorderColor3 = Color3.fromRGB(100, 70, 40)
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 2)
    knobCorner.Parent = knob
    
    local rivet1 = Instance.new("Frame")
    rivet1.Size = UDim2.new(0, 4, 0, 4)
    rivet1.Position = UDim2.new(0, 3, 0.5, -2)
    rivet1.BackgroundColor3 = Color3.fromRGB(150, 120, 90)
    rivet1.BorderSizePixel = 0
    rivet1.Parent = knob
    
    local rivet1Corner = Instance.new("UICorner")
    rivet1Corner.CornerRadius = UDim.new(1, 0)
    rivet1Corner.Parent = rivet1
    
    local rivet2 = Instance.new("Frame")
    rivet2.Size = UDim2.new(0, 4, 0, 4)
    rivet2.Position = UDim2.new(1, -7, 0.5, -2)
    rivet2.BackgroundColor3 = Color3.fromRGB(150, 120, 90)
    rivet2.BorderSizePixel = 0
    rivet2.Parent = knob
    
    local rivet2Corner = Instance.new("UICorner")
    rivet2Corner.CornerRadius = UDim.new(1, 0)
    rivet2Corner.Parent = rivet2
    
    local led = Instance.new("Frame")
    led.Size = UDim2.new(0, 6, 0, 6)
    led.Position = UDim2.new(0.5, -3, 0, 2)
    led.BackgroundColor3 = initialState and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 100, 100)
    led.BorderSizePixel = 0
    led.Parent = knob
    
    local ledCorner = Instance.new("UICorner")
    ledCorner.CornerRadius = UDim.new(1, 0)
    ledCorner.Parent = led
    
    return {
        bg = toggleBg,
        knob = knob,
        led = led,
        rivet1 = rivet1,
        rivet2 = rivet2,
        update = function(self, state)
            led.BackgroundColor3 = state and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 100, 100)
            
            local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
            local targetPos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            local tween = TweenService:Create(knob, tweenInfo, {Position = targetPos})
            tween:Play()
        end
    }
end

local originalCreateWindow = YUUGTRL.CreateWindow
YUUGTRL.CreateWindow = function(title, size, position, options)
    local window = originalCreateWindow(title, size, position, options)
    
    function window:CreateToggle(text, default, callback, position, size, toggleType, colors, translationKey)
        local togglePos = position and UDim2.new(position.X.Scale, position.X.Offset * self.scale, position.Y.Scale, position.Y.Offset * self.scale) or nil
        local toggleSize = size and UDim2.new(size.X.Scale, size.X.Offset * self.scale, size.Y.Scale, size.Y.Offset * self.scale) or nil
        
        local toggle = YUUGTRL:CreateToggle(self.Main, text, default, callback, togglePos, toggleSize, toggleType, colors)
        
        if translationKey then
            YUUGTRL:RegisterTranslatable(toggle.label, translationKey)
        end
        
        table.insert(self.elements, {type = "toggle", obj = toggle})
        return toggle
    end
    
    return window
end

return YUUGTRL
