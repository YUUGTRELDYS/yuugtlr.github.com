local YUUGTRL = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

local colors = {
	background = Color3.fromRGB(25, 25, 35),
	backgroundLight = Color3.fromRGB(35, 35, 45),
	backgroundDark = Color3.fromRGB(20, 20, 28),
	accent = Color3.fromRGB(80, 100, 220),
	accentHover = Color3.fromRGB(100, 120, 240),
	success = Color3.fromRGB(60, 180, 80),
	danger = Color3.fromRGB(220, 70, 70),
	warning = Color3.fromRGB(220, 180, 70),
	info = Color3.fromRGB(140, 80, 220),
	text = Color3.fromRGB(255, 255, 255),
	textDim = Color3.fromRGB(200, 200, 220)
}

local function createTween(object, properties, duration, easingStyle, easingDirection)
	return TweenService:Create(object, 
		TweenInfo.new(duration or 0.2, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out), 
		properties
	)
end

local function addGradient(parent, color1, color2, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1),
		ColorSequenceKeypoint.new(1, color2 or color1)
	})
	gradient.Rotation = rotation or 45
	gradient.Parent = parent
	return gradient
end

local function addCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

local function addShadow(parent, size, transparency)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, size or 15, 1, size or 15)
	shadow.Position = UDim2.new(0, -(size or 15)/2, 0, -(size or 15)/2)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = transparency or 0.9
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.Parent = parent
	return shadow
end

function YUUGTRL:CreateWindow(options)
	options = options or {}
	
	local window = {
		Title = options.title or "YUUGTRL Window",
		Size = options.size or {width = 350, height = 400},
		Position = options.position or {x = 0.5, y = 0.5},
		Draggable = options.draggable ~= false,
		Visible = true,
		Elements = {},
		ScreenGui = nil,
		MainFrame = nil,
		Header = nil,
		Content = nil,
		CloseCallbacks = {}
	}
	
	window.ScreenGui = Instance.new("ScreenGui")
	window.ScreenGui.Name = "YUUGTRL_" .. options.title:gsub("%s+", "")
	window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	window.ScreenGui.DisplayOrder = 999
	window.ScreenGui.ResetOnSpawn = false
	
	window.MainFrame = Instance.new("Frame")
	window.MainFrame.Name = "MainFrame"
	window.MainFrame.Size = isMobile and 
		UDim2.new(0, window.Size.width - 70, 0, window.Size.height - 80) or 
		UDim2.new(0, window.Size.width, 0, window.Size.height)
	window.MainFrame.Position = UDim2.new(window.Position.x, isMobile and -140 or -175, window.Position.y, -window.Size.height/2)
	window.MainFrame.BackgroundColor3 = colors.background
	window.MainFrame.BorderSizePixel = 0
	
	addGradient(window.MainFrame, colors.backgroundLight, colors.background, 45)
	addShadow(window.MainFrame, 15, 0.9)
	addCorner(window.MainFrame, 16)
	
	window.Header = Instance.new("Frame")
	window.Header.Name = "Header"
	window.Header.Size = UDim2.new(1, 0, 0, isMobile and 35 or 45)
	window.Header.BackgroundColor3 = colors.backgroundLight
	window.Header.BorderSizePixel = 0
	
	addGradient(window.Header, Color3.fromRGB(60, 60, 80), Color3.fromRGB(40, 40, 55))
	addCorner(window.Header, 16)
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -60, 1, 0)
	title.Position = UDim2.new(0, 12, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = window.Title
	title.TextColor3 = colors.text
	title.Font = Enum.Font.GothamBold
	title.TextSize = isMobile and 14 or 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = window.Header
	
	if options.showCredits ~= false then
		local credit = Instance.new("TextLabel")
		credit.Name = "Credit"
		credit.Size = UDim2.new(1, -60, 0, isMobile and 12 or 14)
		credit.Position = UDim2.new(0, 12, 1, isMobile and -14 or -16)
		credit.BackgroundTransparency = 1
		credit.Text = "YUUGTRL Library v1.0"
		credit.TextColor3 = Color3.fromRGB(170, 85, 255)
		credit.Font = Enum.Font.Gotham
		credit.TextSize = isMobile and 9 or 11
		credit.TextXAlignment = Enum.TextXAlignment.Left
		credit.Parent = window.Header
	end
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, isMobile and 26 or 32, 0, isMobile and 26 or 32)
	closeBtn.Position = UDim2.new(1, isMobile and -30 or -37, 0, isMobile and 4 or 6)
	closeBtn.BackgroundColor3 = colors.danger
	closeBtn.Text = "×"
	closeBtn.TextColor3 = colors.text
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = isMobile and 16 or 20
	
	addCorner(closeBtn, 8)
	
	closeBtn.MouseButton1Click:Connect(function()
		window:Close()
		for _, callback in ipairs(window.CloseCallbacks) do
			callback()
		end
	end)
	
	closeBtn.Parent = window.Header
	
	window.Content = Instance.new("Frame")
	window.Content.Name = "Content"
	window.Content.Size = UDim2.new(1, -20, 1, -(isMobile and 65 or 75))
	window.Content.Position = UDim2.new(0, 10, 0, isMobile and 45 or 55)
	window.Content.BackgroundTransparency = 1
	window.Content.Parent = window.MainFrame
	
	window.Header.Parent = window.MainFrame
	window.MainFrame.Parent = window.ScreenGui
	window.ScreenGui.Parent = player:WaitForChild("PlayerGui")
	
	if window.Draggable then
		local dragging = false
		local dragInput, dragStart, startPos
		
		local function update(input)
			local delta = input.Position - dragStart
			window.MainFrame.Position = UDim2.new(
				startPos.X.Scale, 
				startPos.X.Offset + delta.X, 
				startPos.Y.Scale, 
				startPos.Y.Offset + delta.Y
			)
		end
		
		window.Header.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = window.MainFrame.Position
				
				local connection
				connection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						connection:Disconnect()
					end
				end)
			end
		end)
		
		window.Header.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end
	
	function window:SetTitle(newTitle)
		title.Text = newTitle
		window.Title = newTitle
	end
	
	function window:SetVisible(visible)
		window.Visible = visible
		window.MainFrame.Visible = visible
	end
	
	function window:Toggle()
		window:SetVisible(not window.Visible)
	end
	
	function window:Close()
		window.ScreenGui:Destroy()
	end
	
	function window:OnClose(callback)
		table.insert(window.CloseCallbacks, callback)
	end
	
	function window:CreateSection(name)
		local section = {
			Name = name,
			Parent = window,
			Frame = nil,
			Elements = {}
		}
		
		local container = Instance.new("ScrollingFrame")
		container.Size = UDim2.new(1, 0, 1, 0)
		container.BackgroundTransparency = 1
		container.BorderSizePixel = 0
		container.ScrollBarThickness = 4
		container.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 130)
		container.Parent = window.Content
		
		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, isMobile and 4 or 6)
		layout.Parent = container
		
		if name then
			local header = Instance.new("TextLabel")
			header.Size = UDim2.new(1, 0, 0, isMobile and 20 or 25)
			header.BackgroundTransparency = 1
			header.Text = name
			header.TextColor3 = colors.text
			header.Font = Enum.Font.GothamBold
			header.TextSize = isMobile and 12 or 14
			header.TextXAlignment = Enum.TextXAlignment.Left
			header.Parent = container
		end
		
		section.Frame = container
		
		function section:AddButton(text, callback, color)
			local btn = YUUGTRL:CreateButton(text, callback, color)
			btn.Parent = container
			table.insert(section.Elements, btn)
			return btn
		end
		
		function section:AddToggle(text, defaultValue, callback)
			local toggle, label, value = YUUGTRL:CreateToggle(text, defaultValue, callback)
			toggle.Parent = container
			table.insert(section.Elements, toggle)
			return toggle, label, value
		end
		
		function section:AddLabel(text, isTitle)
			local label = YUUGTRL:CreateLabel(text, isTitle)
			label.Parent = container
			table.insert(section.Elements, label)
			return label
		end
		
		function section:AddSlider(text, min, max, default, callback)
			local slider = YUUGTRL:CreateSlider(text, min, max, default, callback)
			slider.Parent = container
			table.insert(section.Elements, slider)
			return slider
		end
		
		table.insert(window.Elements, section)
		return section
	end
	
	return window
end

function YUUGTRL:CreateButton(text, callback, color)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, isMobile and 30 or 35)
	button.BackgroundColor3 = color or colors.accent
	button.Text = text
	button.TextColor3 = colors.text
	button.Font = Enum.Font.GothamBold
	button.TextSize = isMobile and 11 or 13
	button.AutoButtonColor = false
	
	local gradient = addGradient(button, 
		Color3.fromRGB(
			math.min((color or colors.accent).R * 255 + 20, 255),
			math.min((color or colors.accent).G * 255 + 20, 255),
			math.min((color or colors.accent).B * 255 + 20, 255)
		),
		color or colors.accent,
		90
	)
	
	addCorner(button, 10)
	
	button.MouseEnter:Connect(function()
		createTween(button, {BackgroundColor3 = Color3.fromRGB(
			math.min((color or colors.accent).R * 255 + 30, 255),
			math.min((color or colors.accent).G * 255 + 30, 255),
			math.min((color or colors.accent).B * 255 + 30, 255)
		)}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		createTween(button, {BackgroundColor3 = color or colors.accent}):Play()
	end)
	
	button.MouseButton1Click:Connect(function()
		createTween(button, {BackgroundColor3 = colors.success}):Play()
		task.wait(0.1)
		createTween(button, {BackgroundColor3 = color or colors.accent}):Play()
		if callback then callback() end
	end)
	
	return button
end

function YUUGTRL:CreateToggle(text, defaultValue, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, isMobile and 25 or 30)
	frame.BackgroundTransparency = 1
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text .. ":"
	label.TextColor3 = colors.textDim
	label.Font = Enum.Font.Gotham
	label.TextSize = isMobile and 12 or 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	
	local value = Instance.new("TextLabel")
	value.Size = UDim2.new(0.45, 0, 1, 0)
	value.Position = UDim2.new(0.55, 0, 0, 0)
	value.BackgroundTransparency = 1
	value.Text = tostring(defaultValue or false)
	value.TextColor3 = (defaultValue or false) and colors.success or colors.danger
	value.Font = Enum.Font.GothamBold
	value.TextSize = isMobile and 12 or 14
	value.TextXAlignment = Enum.TextXAlignment.Left
	value.Parent = frame
	
	local enabled = defaultValue or false
	
	local function updateDisplay()
		value.Text = tostring(enabled)
		createTween(value, {TextColor3 = enabled and colors.success or colors.danger}):Play()
	end
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = frame
	
	button.MouseButton1Click:Connect(function()
		enabled = not enabled
		updateDisplay()
		if callback then callback(enabled) end
	end)
	
	updateDisplay()
	
	return frame, label, value
end

function YUUGTRL:CreateLabel(text, isTitle)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, isMobile and (isTitle and 25 or 20) or (isTitle and 30 or 25))
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = isTitle and colors.text or colors.textDim
	label.Font = isTitle and Enum.Font.GothamBold or Enum.Font.Gotham
	label.TextSize = isMobile and (isTitle and 14 or 12) or (isTitle and 16 or 14)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	
	if isTitle then
		local line = Instance.new("Frame")
		line.Size = UDim2.new(1, 0, 0, 1)
		line.Position = UDim2.new(0, 0, 1, -2)
		line.BackgroundColor3 = colors.accent
		line.BorderSizePixel = 0
		line.Parent = label
	end
	
	return label
end

function YUUGTRL:CreateSlider(text, min, max, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, isMobile and 45 or 55)
	frame.BackgroundTransparency = 1
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 0, isMobile and 15 or 18)
	label.BackgroundTransparency = 1
	label.Text = text .. ":"
	label.TextColor3 = colors.textDim
	label.Font = Enum.Font.Gotham
	label.TextSize = isMobile and 12 or 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.45, 0, 0, isMobile and 15 or 18)
	valueLabel.Position = UDim2.new(0.55, 0, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(default or min or 0)
	valueLabel.TextColor3 = colors.accent
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = isMobile and 12 or 14
	valueLabel.TextXAlignment = Enum.TextXAlignment.Left
	valueLabel.Parent = frame
	
	local sliderBg = Instance.new("Frame")
	sliderBg.Size = UDim2.new(1, 0, 0, isMobile and 16 or 20)
	sliderBg.Position = UDim2.new(0, 0, 0, isMobile and 20 or 25)
	sliderBg.BackgroundColor3 = colors.backgroundDark
	sliderBg.BorderSizePixel = 0
	sliderBg.Parent = frame
	
	addCorner(sliderBg, 10)
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.Size = UDim2.new(0, 0, 1, 0)
	sliderFill.BackgroundColor3 = colors.accent
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderBg
	
	addCorner(sliderFill, 10)
	
	local sliderButton = Instance.new("TextButton")
	sliderButton.Size = UDim2.new(0, isMobile and 16 or 20, 0, isMobile and 16 or 20)
	sliderButton.BackgroundColor3 = colors.text
	sliderButton.Text = ""
	sliderButton.BorderSizePixel = 0
	sliderButton.Parent = sliderBg
	
	addCorner(sliderButton, 10)
	
	local minVal = min or 0
	local maxVal = max or 100
	local currentVal = default or minVal
	
	local function updateSlider(posX)
		local sliderPos = sliderBg.AbsolutePosition.X
		local sliderSize = sliderBg.AbsoluteSize.X
		local relativePos = math.clamp((posX - sliderPos) / sliderSize, 0, 1)
		currentVal = minVal + (maxVal - minVal) * relativePos
		
		local fillWidth = sliderSize * relativePos
		sliderFill.Size = UDim2.new(0, fillWidth, 1, 0)
		sliderButton.Position = UDim2.new(relativePos, -10, 0, 0)
		valueLabel.Text = tostring(math.floor(currentVal))
		
		if callback then callback(currentVal) end
	end
	
	local dragging = false
	
	sliderButton.MouseButton1Down:Connect(function()
		dragging = true
	end)
	
	sliderButton.TouchLongPress:Connect(function()
		dragging = true
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input.Position.X)
		end
	end)
	
	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			updateSlider(input.Position.X)
		end
	end)
	
	local initialFillWidth = ((currentVal - minVal) / (maxVal - minVal)) * sliderBg.AbsoluteSize.X
	sliderFill.Size = UDim2.new(0, initialFillWidth, 1, 0)
	sliderButton.Position = UDim2.new((currentVal - minVal) / (maxVal - minVal), -10, 0, 0)
	
	return frame
end

return YUUGTRL
