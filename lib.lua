local YUUGTRL = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

local splash = Instance.new("ScreenGui")
splash.Name = "YUUGTRLSplash"
splash.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
splash.DisplayOrder = 9999
splash.ResetOnSpawn = false
splash.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.5, -100, 0.5, -40)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Parent = splash

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1, 0, 1, 0)
text.BackgroundTransparency = 1
text.Text = "YUUGTRL"
text.TextColor3 = Color3.fromRGB(170, 85, 255)
text.Font = Enum.Font.GothamBold
text.TextSize = 30
text.Parent = frame

task.wait(1.5)

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1})
tween:Play()
TweenService:Create(text, tweenInfo, {TextTransparency = 1}):Play()

task.wait(0.5)
splash:Destroy()

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

function YUUGTRL:CreateWindow(title)
    local ScreenGui = Create({
        type = "ScreenGui",
        Name = "YUUGTRL",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        ResetOnSpawn = false
    })
    
    local Main = Create({
        type = "Frame",
        Size = isMobile and UDim2.new(0, 280, 0, 400) or UDim2.new(0, 350, 0, 450),
        Position = UDim2.new(0.5, -175, 0.5, -225),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    Create({
        type = "UICorner",
        CornerRadius = UDim.new(0, 8),
        Parent = Main
    })
    
    local Header = Create({
        type = "Frame",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Parent = Main
    })
    
    Create({
        type = "UICorner",
        CornerRadius = UDim.new(0, 8),
        Parent = Header
    })
    
    Create({
        type = "TextLabel",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "YUUGTRL",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    local Close = Create({
        type = "TextButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = Header
    })
    
    Create({
        type = "UICorner",
        CornerRadius = UDim.new(0, 6),
        Parent = Close
    })
    
    local Tabs = Create({
        type = "Frame",
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Parent = Main
    })
    
    local Container = Create({
        type = "ScrollingFrame",
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 100),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150),
        Parent = Main
    })
    
    Create({
        type = "UIListLayout",
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Container
    })
    
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
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
    
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local window = {
        Main = Main,
        Tabs = Tabs,
        Container = Container,
        ScreenGui = ScreenGui,
        tabButtons = {}
    }
    
    local lastTabPosition = 0
    
    function window:CreateTab(name)
        local TabButton = Create({
            type = "TextButton",
            Size = UDim2.new(0, 80, 0, 30),
            Position = UDim2.new(0, lastTabPosition, 0, 0),
            BackgroundColor3 = Color3.fromRGB(50, 50, 60),
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = self.Tabs
        })
        
        Create({
            type = "UICorner",
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })
        
        lastTabPosition = lastTabPosition + 85
        
        local tabFrame = Create({
            type = "ScrollingFrame",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            Visible = false,
            Parent = self.Container
        })
        
        Create({
            type = "UIListLayout",
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabFrame
        })
        
        TabButton.MouseButton1Click:Connect(function()
            for _, btn in pairs(self.tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(80, 100, 220)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            for _, child in pairs(self.Container:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            tabFrame.Visible = true
        end)
        
        table.insert(self.tabButtons, TabButton)
        
        local tab = {
            Frame = tabFrame
        }
        
        function tab:CreateButton(text, callback)
            local Button = Create({
                type = "TextButton",
                Size = UDim2.new(1, -10, 0, 35),
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Parent = tabFrame
            })
            
            Create({
                type = "UICorner",
                CornerRadius = UDim.new(0, 6),
                Parent = Button
            })
            
            Button.MouseButton1Click:Connect(function()
                local success, err = pcall(callback)
                if not success then warn(err) end
            end)
            
            return Button
        end
        
        function tab:CreateToggle(text, default, callback)
            local ToggleFrame = Create({
                type = "Frame",
                Size = UDim2.new(1, -10, 0, 35),
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                Parent = tabFrame
            })
            
            Create({
                type = "UICorner",
                CornerRadius = UDim.new(0, 6),
                Parent = ToggleFrame
            })
            
            Create({
                type = "TextLabel",
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            local ToggleBtn = Create({
                type = "TextButton",
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -40, 0, 2.5),
                BackgroundColor3 = default and Color3.fromRGB(80, 220, 100) or Color3.fromRGB(220, 80, 80),
                Text = "",
                Parent = ToggleFrame
            })
            
            Create({
                type = "UICorner",
                CornerRadius = UDim.new(0, 15),
                Parent = ToggleBtn
            })
            
            local toggled = default or false
            
            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(80, 220, 100) or Color3.fromRGB(220, 80, 80)
                local success, err = pcall(callback, toggled)
                if not success then warn(err) end
            end)
            
            return ToggleBtn
        end
        
        function tab:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Create({
                type = "Frame",
                Size = UDim2.new(1, -10, 0, 50),
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                Parent = tabFrame
            })
            
            Create({
                type = "UICorner",
                CornerRadius = UDim.new(0, 6),
                Parent = SliderFrame
            })
            
            Create({
                type = "TextLabel",
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local ValueLabel = Create({
                type = "TextLabel",
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(default or 0),
                TextColor3 = Color3.fromRGB(200, 200, 255),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Parent = SliderFrame
            })
            
            local Slider = Create({
                type = "Frame",
                Size = UDim2.new(1, -30, 0, 10),
                Position = UDim2.new(0, 15, 0, 30),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Parent = SliderFrame
            })
            
            Create({
                type = "UICorner",
                CornerRadius = UDim.new(0, 5),
                Parent = Slider
            })
            
            local Fill = Create({
                type = "Frame",
                Size = UDim2.new((default or 0) / max, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(80, 100, 220),
                Parent = Slider
            })
            
            Create({
                type = "UICorner",
                CornerRadius = UDim.new(0, 5),
                Parent = Fill
            })
            
            local dragging = false
            
            Slider.InputBegan:Connect(function(input)
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
                    local pos = input.Position.X - Slider.AbsolutePosition.X
                    local size = Slider.AbsoluteSize.X
                    local percent = math.clamp(pos / size, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    local success, err = pcall(callback, value)
                    if not success then warn(err) end
                end
            end)
            
            return Slider
        end
        
        function tab:CreateLabel(text)
            local Label = Create({
                type = "TextLabel",
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(200, 200, 255),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Parent = tabFrame
            })
            
            return Label
        end
        
        return tab
    end
    
    return window
end

return YUUGTRL
