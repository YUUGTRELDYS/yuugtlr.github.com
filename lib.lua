local splash = Instance.new("ScreenGui")
splash.Name = "YUUGTRLSplash"
splash.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
splash.DisplayOrder = 9999
splash.ResetOnSpawn = false
splash.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 200)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = splash

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
gradient.Rotation = 45
gradient.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(170, 85, 255)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, 0, 0, 80)
logo.Position = UDim2.new(0, 0, 0, 30)
logo.BackgroundTransparency = 1
logo.Text = "YUUGTRL"
logo.TextColor3 = Color3.fromRGB(200, 150, 255)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 60
logo.TextTransparency = 0.2
logo.Parent = mainFrame

local glow = Instance.new("ImageLabel")
glow.Size = UDim2.new(1, 100, 1, 100)
glow.Position = UDim2.new(0, -50, 0, -50)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5028857642"
glow.ImageColor3 = Color3.fromRGB(170, 85, 255)
glow.ImageTransparency = 0.8
glow.Parent = logo

local line1 = Instance.new("Frame")
line1.Size = UDim2.new(0.3, 0, 0, 2)
line1.Position = UDim2.new(0.1, 0, 0.7, 0)
line1.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
line1.BackgroundTransparency = 0.3
line1.Parent = mainFrame

local line2 = Instance.new("Frame")
line2.Size = UDim2.new(0.3, 0, 0, 2)
line2.Position = UDim2.new(0.6, 0, 0.7, 0)
line2.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
line2.BackgroundTransparency = 0.3
line2.Parent = mainFrame

local version = Instance.new("TextLabel")
version.Size = UDim2.new(1, 0, 0, 30)
version.Position = UDim2.new(0, 0, 0, 120)
version.BackgroundTransparency = 1
version.Text = "v2.0"
version.TextColor3 = Color3.fromRGB(150, 100, 200)
version.Font = Enum.Font.Gotham
version.TextSize = 20
version.TextTransparency = 0.4
version.Parent = mainFrame

local particles = {}

for i = 1, 10 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
    particle.BackgroundTransparency = 0.5
    particle.Parent = mainFrame
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    table.insert(particles, particle)
end

task.wait(1.2)

local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

for _, particle in pairs(particles) do
    TweenService:Create(particle, tweenInfo, {
        Position = UDim2.new(math.random(), 0, math.random(), 0),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
end

TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
TweenService:Create(shadow, tweenInfo, {ImageTransparency = 1}):Play()
TweenService:Create(logo, tweenInfo, {TextTransparency = 1}):Play()
TweenService:Create(version, tweenInfo, {TextTransparency = 1}):Play()
TweenService:Create(line1, tweenInfo, {BackgroundTransparency = 1}):Play()
TweenService:Create(line2, tweenInfo, {BackgroundTransparency = 1}):Play()

task.wait(1)
splash:Destroy()
