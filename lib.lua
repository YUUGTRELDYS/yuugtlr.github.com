local Library = {}
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local colors = {
    background = Color3.fromRGB(25, 25, 35),
    header = Color3.fromRGB(35, 35, 45),
    button = {
        primary = Color3.fromRGB(80, 100, 220),
        success = Color3.fromRGB(60, 180, 80),
        warning = Color3.fromRGB(220, 70, 70)
    },
    text = {
        primary = Color3.fromRGB(255, 255, 255),
        secondary = Color3.fromRGB(200, 200, 220)
    },
    status = {
        true = Color3.fromRGB(80, 220, 100),
        false = Color3.fromRGB(220, 80, 80)
    }
}

function Library:Window(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Library"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 400, 0, 500)
    Main.Position = UDim2.new(0.5, -200, 0.5, -250)
    Main.BackgroundColor3 = colors.background
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Main
    
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = Main
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = colors.header
    Header.BackgroundTransparency = 0.1
    Header.BorderSizePixel = 0
    Header.Parent = Main
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title or "Library"
    Title.TextColor3 = colors.text.primary
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local Close = Instance.new("TextButton")
    Close.Name = "Close"
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.BackgroundColor3 = colors.button.warning
    Close.BackgroundTransparency = 0.2
    Close.Text = "X"
    Close.TextColor3 = colors.text.primary
    Close.Font = Enum.Font.SourceSansBold
    Close.TextSize = 18
    Close.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = Close
    
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = Main
    
    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 8)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    List.Parent = Container
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
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
            update(input)
        end
    end)
    
    local Window = {}
    Window.Container = Container
    Window.List = List
    Window.ScreenGui = ScreenGui
    Window.Main = Main
    
    return Window
end

function Library:Button(parent, text, callback)
    if not parent then return end
    
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.BackgroundColor3 = colors.button.primary
    Button.BackgroundTransparency = 0.2
    Button.Text = text or "Button"
    Button.TextColor3 = colors.text.primary
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 18
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    
    return Button
end

function Library:Toggle(parent, text, default, callback)
    if not parent then return end
    
    local Frame = Instance.new("Frame")
    Frame.Name = "Toggle"
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.7, -5, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text or "Toggle"
    Label.TextColor3 = colors.text.secondary
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 18
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 60, 0, 25)
    ToggleButton.Position = UDim2.new(1, -65, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = default and colors.status.true or colors.status.false
    ToggleButton.BackgroundTransparency = 0.2
    ToggleButton.Text = default and "ON" or "OFF"
    ToggleButton.TextColor3 = colors.text.primary
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 16
    ToggleButton.Parent = Frame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 4)
    ToggleCorner.Parent = ToggleButton
    
    local state = default or false
    
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.Text = state and "ON" or "OFF"
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = state and colors.status.true or colors.status.false
        }):Play()
        
        if callback then
            pcall(function() callback(state) end)
        end
    end)
    
    return ToggleButton, function() return state end
end

function Library:Slider(parent, text, min, max, default, callback)
    if not parent then return end
    
    min = min or 0
    max = max or 100
    default = default or min
    
    local Frame = Instance.new("Frame")
    Frame.Name = "Slider"
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = colors.text.secondary
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 18
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local SliderBg = Instance.new("Frame")
    SliderBg.Name = "SliderBg"
    SliderBg.Size = UDim2.new(1, 0, 0, 10)
    SliderBg.Position = UDim2.new(0, 0, 0, 25)
    SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBg.BackgroundTransparency = 0.3
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Frame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 4)
    SliderCorner.Parent = SliderBg
    
    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = colors.button.primary
    Fill.BackgroundTransparency = 0.2
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBg
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = Fill
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = input.Position.X - SliderBg.AbsolutePosition.X
        local size = SliderBg.AbsoluteSize.X
        if size <= 0 then return end
        
        local percent = math.clamp(pos / size, 0, 1)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        
        local value = min + (max - min) * percent
        value = math.floor(value * 10) / 10
        Label.Text = text .. ": " .. tostring(value)
        
        if callback then
            pcall(function() callback(value) end)
        end
    end
    
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    SliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    return Frame
end

function Library:Label(parent, text)
    if not parent then return end
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -10, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = text or "Label"
    Label.TextColor3 = colors.text.secondary
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 18
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent
    
    return Label
end

function Library:Seperator(parent)
    if not parent then return end
    
    local Seperator = Instance.new("Frame")
    Seperator.Name = "Seperator"
    Seperator.Size = UDim2.new(1, -20, 0, 1)
    Seperator.BackgroundColor3 = colors.text.secondary
    Seperator.BackgroundTransparency = 0.8
    Seperator.BorderSizePixel = 0
    Seperator.Parent = parent
    
    return Seperator
end

return Library
