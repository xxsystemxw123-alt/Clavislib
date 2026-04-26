--[[
    ClavisLib - The ultimate Roblox UI library
    Version 1.0.0
    Features: Rayfield-inspired visuals + Orion-style architecture
    Usage:
        local ClavisLib = loadstring(game:HttpGet("URL"))()
        local Window = ClavisLib:CreateWindow("Xerkol Hub")
        local Tab = Window:CreateTab("Main")
        local Section = Tab:AddSection("Settings")
        Section:AddToggle({Name = "Enabled", Flag = "enabled", Default = true, Callback = function(v) print(v) end})
        Section:AddButton({Name = "Click Me", Callback = function() print("Clicked") end})
        -- See full API below
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui") or game:GetService("StarterGui")

-- ==================== UTILITY ====================
local Utility = {}

function Utility.CreateShadow(parent, size, offset, transparency)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BorderSizePixel = 0
    shadow.Position = UDim2.new(0, offset or 3, 0, offset or 3)
    shadow.Size = size or UDim2.new(1, 0, 1, 0)
    shadow.BackgroundTransparency = transparency or 0.85
    shadow.Parent = parent
    return shadow
end

function Utility.CreateBlurEffect(parent)
    local blur = Instance.new("BlurEffect")
    blur.Size = 24
    blur.Parent = parent
    return blur
end

function Utility.MakeDraggable(frame, dragPart)
    dragPart = dragPart or frame
    local dragging, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    dragPart.InputBegan:Connect(function(input)
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
    dragPart.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

function Utility.Clamp(val, min, max)
    return math.min(math.max(val, min), max)
end

function Utility.Ripple(button)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = 10
    ripple.Parent = button

    local targetSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
    local tween = TweenService:Create(ripple, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, targetSize, 0, targetSize),
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- ==================== THEME MANAGER ====================
local ThemeManager = {}
ThemeManager.Presets = {
    Dark = {
        MainBg = Color3.fromRGB(25, 25, 30),
        TitleBarBg = Color3.fromRGB(20, 20, 25),
        TabBarBg = Color3.fromRGB(18, 18, 22),
        TabInactiveBg = Color3.fromRGB(30, 30, 35),
        TabActiveBg = Color3.fromRGB(66, 133, 244),
        TabTextInactive = Color3.fromRGB(180, 180, 185),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(66, 133, 244),
        AccentText = Color3.fromRGB(255, 255, 255),
        ElementBg = Color3.fromRGB(35, 35, 40),
        ElementStroke = Color3.fromRGB(50, 50, 55),
        ElementText = Color3.fromRGB(220, 220, 225),
        ElementHover = Color3.fromRGB(45, 45, 50),
        IndicatorOn = Color3.fromRGB(66, 133, 244),
        IndicatorOff = Color3.fromRGB(60, 60, 65),
        SliderTrack = Color3.fromRGB(45, 45, 50),
        SliderFill = Color3.fromRGB(66, 133, 244),
        SliderThumb = Color3.fromRGB(255, 255, 255),
        DropdownBg = Color3.fromRGB(30, 30, 35),
        DropdownHover = Color3.fromRGB(45, 45, 50),
        Scrollbar = Color3.fromRGB(66, 133, 244),
        ScrollbarBg = Color3.fromRGB(20, 20, 25),
        Shadow = Color3.fromRGB(0, 0, 0),
        NotificationBg = Color3.fromRGB(40, 40, 45),
        NotificationText = Color3.fromRGB(255, 255, 255),
    },
    Light = {
        MainBg = Color3.fromRGB(240, 240, 245),
        TitleBarBg = Color3.fromRGB(230, 230, 235),
        TabBarBg = Color3.fromRGB(220, 220, 225),
        TabInactiveBg = Color3.fromRGB(210, 210, 215),
        TabActiveBg = Color3.fromRGB(66, 133, 244),
        TabTextInactive = Color3.fromRGB(100, 100, 110),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(66, 133, 244),
        AccentText = Color3.fromRGB(255, 255, 255),
        ElementBg = Color3.fromRGB(255, 255, 255),
        ElementStroke = Color3.fromRGB(200, 200, 210),
        ElementText = Color3.fromRGB(30, 30, 35),
        ElementHover = Color3.fromRGB(245, 245, 250),
        IndicatorOn = Color3.fromRGB(66, 133, 244),
        IndicatorOff = Color3.fromRGB(180, 180, 190),
        SliderTrack = Color3.fromRGB(210, 210, 215),
        SliderFill = Color3.fromRGB(66, 133, 244),
        SliderThumb = Color3.fromRGB(255, 255, 255),
        DropdownBg = Color3.fromRGB(245, 245, 250),
        DropdownHover = Color3.fromRGB(230, 230, 235),
        Scrollbar = Color3.fromRGB(66, 133, 244),
        ScrollbarBg = Color3.fromRGB(210, 210, 215),
        Shadow = Color3.fromRGB(0, 0, 0),
        NotificationBg = Color3.fromRGB(255, 255, 255),
        NotificationText = Color3.fromRGB(30, 30, 35),
    },
    Amethyst = {
        MainBg = Color3.fromRGB(35, 25, 45),
        TitleBarBg = Color3.fromRGB(30, 20, 40),
        TabBarBg = Color3.fromRGB(25, 15, 35),
        TabInactiveBg = Color3.fromRGB(40, 30, 50),
        TabActiveBg = Color3.fromRGB(170, 100, 255),
        TabTextInactive = Color3.fromRGB(200, 180, 220),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(170, 100, 255),
        AccentText = Color3.fromRGB(255, 255, 255),
        ElementBg = Color3.fromRGB(45, 35, 55),
        ElementStroke = Color3.fromRGB(70, 55, 85),
        ElementText = Color3.fromRGB(230, 220, 245),
        ElementHover = Color3.fromRGB(55, 45, 65),
        IndicatorOn = Color3.fromRGB(170, 100, 255),
        IndicatorOff = Color3.fromRGB(70, 55, 85),
        SliderTrack = Color3.fromRGB(55, 45, 70),
        SliderFill = Color3.fromRGB(170, 100, 255),
        SliderThumb = Color3.fromRGB(255, 255, 255),
        DropdownBg = Color3.fromRGB(40, 30, 50),
        DropdownHover = Color3.fromRGB(55, 45, 65),
        Scrollbar = Color3.fromRGB(170, 100, 255),
        ScrollbarBg = Color3.fromRGB(25, 15, 35),
        Shadow = Color3.fromRGB(0, 0, 0),
        NotificationBg = Color3.fromRGB(50, 40, 60),
        NotificationText = Color3.fromRGB(255, 255, 255),
    }
}

ThemeManager.Current = ThemeManager.Presets.Dark

function ThemeManager.SetTheme(theme)
    if type(theme) == "string" then
        ThemeManager.Current = ThemeManager.Presets[theme] or ThemeManager.Presets.Dark
    else
        ThemeManager.Current = theme
    end
    -- Window will update all children with new colors (handled inside Window)
end

-- ==================== GLOBAL FLAG STORE ====================
local Flags = {}

-- ==================== CLASSLIB ====================
local ClavisLib = {
    Version = "1.0.0"
}

-- ==================== WINDOW CREATION ====================
function ClavisLib:CreateWindow(title, config)
    config = config or {}
    local theme = ThemeManager.Current
    
    -- Create ScreenGui
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "ClavisLib_" .. title
    Gui.ResetOnSpawn = false
    pcall(function() Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end)
    
    -- Overlay (dim background)
    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.Visible = config.BlurBackground ~= false -- default true
    Overlay.Parent = Gui
    
    -- Main Window Frame
    local Window = {}
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = config.Size or UDim2.new(0, 600, 0, 450)
    Main.Position = UDim2.new(0.5, -300, 0.5, -225)
    Main.BackgroundColor3 = theme.MainBg
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = Gui
    
    -- Rounded corners via UIStroke and solid background
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Main
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Color = theme.ElementStroke
    MainStroke.Thickness = 2
    MainStroke.Parent = Main
    
    -- Shadow for window (behind)
    local WindowShadow = Instance.new("Frame")
    WindowShadow.Name = "WinShadow"
    WindowShadow.Size = UDim2.new(1, 0, 1, 0)
    WindowShadow.Position = UDim2.new(0, 4, 0, 4)
    WindowShadow.BackgroundColor3 = theme.Shadow
    WindowShadow.BackgroundTransparency = 0.85
    WindowShadow.BorderSizePixel = 0
    WindowShadow.ZIndex = Main.ZIndex - 1
    Instance.new("UICorner", WindowShadow).CornerRadius = UDim.new(0, 12)
    WindowShadow.Parent = Main
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = theme.TitleBarBg
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)
    -- Gradient on title bar
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.TitleBarBg),
        ColorSequenceKeypoint.new(1, theme.TitleBarBg:Lerp(Color3.fromRGB(255,255,255), 0.1))
    })
    TitleGradient.Rotation = 90
    TitleGradient.Parent = TitleBar
    
    -- Window Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = theme.ElementText
    TitleLabel.TextSize = 16
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -35, 0, 6)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Image = "rbxassetid://3926305904" -- X icon
    CloseButton.ImageColor3 = theme.ElementText
    CloseButton.ScaleType = Enum.ScaleType.Fit
    CloseButton.ZIndex = 10
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)
    CloseButton.Parent = TitleBar
    
    local CloseStroke = Instance.new("UIStroke")
    CloseStroke.Thickness = 1
    CloseStroke.Color = theme.ElementStroke
    CloseStroke.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.7, ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 1, ImageColor3 = theme.ElementText}):Play()
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 6)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Image = "rbxassetid://3926305904" -- reuse
    MinimizeButton.ImageColor3 = theme.ElementText
    MinimizeButton.ScaleType = Enum.ScaleType.Fit
    MinimizeButton.ZIndex = 10
    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(1, 0)
    MinimizeButton.Parent = TitleBar
    MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.7, ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundTransparency = 1, ImageColor3 = theme.ElementText}):Play()
    end)
    
    -- Minimize UI (floating icon)
    local MinimizedIcon = Instance.new("ImageButton")
    MinimizedIcon.Name = "MinimizedIcon"
    MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
    MinimizedIcon.Position = UDim2.new(0.5, -25, 0.8, 0)
    MinimizedIcon.BackgroundColor3 = theme.Accent
    MinimizedIcon.Image = "rbxassetid://3926305904" -- placeholder
    MinimizedIcon.ScaleType = Enum.ScaleType.Fit
    MinimizedIcon.Visible = false
    Instance.new("UICorner", MinimizedIcon).CornerRadius = UDim.new(1, 0)
    MinimizedIcon.Parent = Gui
    
    -- Resize Handle
    local ResizeHandle = Instance.new("ImageButton")
    ResizeHandle.Name = "Resize"
    ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Image = "rbxassetid://3926305904"
    ResizeHandle.ImageColor3 = theme.ElementText
    ResizeHandle.ImageTransparency = 0.5
    ResizeHandle.ZIndex = 10
    ResizeHandle.Parent = Main
    
    -- Drag handling
    Utility.MakeDraggable(Main, TitleBar)
    
    -- Minimize logic
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        if minimized then
            Main.Visible = true
            MinimizedIcon.Visible = false
            minimized = false
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0,600,0,450), Position = UDim2.new(0.5,-300,0.5,-225)}):Play()
        else
            Main.Visible = false
            MinimizedIcon.Visible = true
            minimized = true
        end
    end)
    MinimizedIcon.MouseButton1Click:Connect(function()
        Main.Visible = true
        MinimizedIcon.Visible = false
        minimized = false
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0,600,0,450), Position = UDim2.new(0.5,-300,0.5,-225)}):Play()
    end)
    
    -- Close logic: disconnect events, tweens, destroy
    local Connections = {}
    local function disconnectAll()
        for _, conn in ipairs(Connections) do
            conn:Disconnect()
        end
    end
    CloseButton.MouseButton1Click:Connect(function()
        disconnectAll()
        for _, tween in ipairs(Window._tweens or {}) do
            tween:Cancel()
        end
        Gui:Destroy()
    end)
    
    -- Resize logic
    local resizing = false
    local resizeStart, startSize
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = Main.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(400, startSize.X.Offset + delta.X)
            local newHeight = math.max(300, startSize.Y.Offset + delta.Y)
            Main.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    -- Tab container
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, -10, 0, 44)
    TabBar.Position = UDim2.new(0, 5, 0, 42)
    TabBar.BackgroundColor3 = theme.TabBarBg
    TabBar.BackgroundTransparency = 0.5
    TabBar.BorderSizePixel = 0
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 22)
    TabBar.Parent = Main
    
    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabBar
    
    local TabFrame = Instance.new("Frame")
    TabFrame.Name = "TabFrame"
    TabFrame.Size = UDim2.new(1, -10, 1, 0)
    TabFrame.Position = UDim2.new(0, 5, 0, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BorderSizePixel = 0
    TabFrame.ClipsDescendants = true
    TabFrame.Parent = TabBar
    
    -- Content area (below tabs)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "Content"
    ContentArea.Size = UDim2.new(1, -20, 1, -100)
    ContentArea.Position = UDim2.new(0, 10, 0, 90)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = Main
    
    local TabContent = {}
    
    -- Notification system
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "Notifications"
    NotifHolder.Size = UDim2.new(0, 300, 1, 0)
    NotifHolder.Position = UDim2.new(1, -310, 0, 10)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.BorderSizePixel = 0
    NotifHolder.Parent = Gui
    local NotifList = Instance.new("UIListLayout")
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Top
    NotifList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NotifList.Padding = UDim.new(0, 8)
    NotifList.Parent = NotifHolder
    
    -- Window methods
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Name = name
        Tab.Icon = icon or ""
        
        -- Tab button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name
        TabBtn.Size = UDim2.new(0, 0, 1, -10) -- width auto via text
        TabBtn.Position = UDim2.new(0, 0, 0, 5)
        TabBtn.BackgroundColor3 = theme.TabInactiveBg
        TabBtn.Text = (icon ~= "" and icon.."  " or "") .. name
        TabBtn.TextColor3 = theme.TabTextInactive
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        TabBtn.BorderSizePixel = 0
        TabBtn.AutoButtonColor = false
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 15)
        TabBtn.Parent = TabFrame
        -- Auto size based on text
        TabBtn.Size = UDim2.new(0, TabBtn.TextBounds.X + 30, 1, -10)
        
        local function updateTabSizes()
            local totalWidth = 0
            for _, child in ipairs(TabFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    totalWidth = totalWidth + child.AbsoluteSize.X + 6
                end
            end
            TabFrame.CanvasSize = UDim2.new(0, totalWidth, 0, 0)
        end
        updateTabSizes()
        
        -- Content frame for this tab
        local Content = Instance.new("ScrollingFrame")
        Content.Name = name .. "_Content"
        Content.Size = UDim2.new(1, 0, 1, 0)
        Content.BackgroundTransparency = 1
        Content.BorderSizePixel = 0
        Content.ScrollBarThickness = 4
        Content.ScrollBarImageColor3 = theme.Scrollbar
        Content.ScrollBarImageTransparency = 0.5
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Content.Visible = false
        Content.Parent = ContentArea
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 8)
        ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContentList.Parent = Content
        
        -- Active tracking
        local isActive = false
        
        -- Tab methods
        function Tab:AddSection(sectionName, collapsed)
            local Section = {}
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName
            SectionFrame.Size = UDim2.new(1, -10, 0, 30)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = Content
            
            local Header = Instance.new("TextLabel")
            Header.Name = "Header"
            Header.Size = UDim2.new(1, 0, 0, 30)
            Header.BackgroundTransparency = 1
            Header.Font = Enum.Font.GothamBold
            Header.Text = sectionName
            Header.TextColor3 = theme.Accent
            Header.TextSize = 16
            Header.TextXAlignment = Enum.TextXAlignment.Left
            Header.Parent = SectionFrame
            
            local SeparatorLine = Instance.new("Frame")
            SeparatorLine.Size = UDim2.new(1, 0, 0, 1)
            SeparatorLine.Position = UDim2.new(0, 0, 0, 30)
            SeparatorLine.BackgroundColor3 = theme.ElementStroke
            SeparatorLine.BorderSizePixel = 0
            Instance.new("UIGradient", SeparatorLine).Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, theme.Accent),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
            })
            SeparatorLine.Parent = SectionFrame
            
            -- Collapsible logic
            local CollapseButton
            if collapsed then
                SectionFrame.Size = UDim2.new(1, -10, 0, 30)
                CollapseButton = Instance.new("TextButton")
                CollapseButton.Size = UDim2.new(0, 20, 0, 20)
                CollapseButton.Position = UDim2.new(1, -20, 0, 5)
                CollapseButton.BackgroundTransparency = 1
                CollapseButton.Text = "˅"
                CollapseButton.TextColor3 = theme.Accent
                CollapseButton.Font = Enum.Font.GothamBold
                CollapseButton.TextSize = 18
                CollapseButton.Parent = SectionFrame
            end
            
            -- Elements container
            local ElementsFrame = Instance.new("Frame")
            ElementsFrame.Name = "Elements"
            ElementsFrame.Size = UDim2.new(1, 0, 0, 0)
            ElementsFrame.BackgroundTransparency = 1
            ElementsFrame.BorderSizePixel = 0
            ElementsFrame.Visible = not collapsed
            local ElementsList = Instance.new("UIListLayout")
            ElementsList.Padding = UDim.new(0, 6)
            ElementsList.Parent = ElementsFrame
            ElementsFrame.Parent = SectionFrame
            
            local function updateSectionSize()
                local totalHeight = 30 + (ElementsFrame.Visible and ElementsList.AbsoluteContentSize.Y or 0) + 10
                SectionFrame.Size = UDim2.new(1, -10, 0, totalHeight)
                Content.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
            end
            ElementsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSize)
            
            if CollapseButton then
                CollapseButton.MouseButton1Click:Connect(function()
                    ElementsFrame.Visible = not ElementsFrame.Visible
                    CollapseButton.Text = ElementsFrame.Visible and "˅" or "˄"
                    updateSectionSize()
                end)
            end
            
            -- Helper to add element wrapper
            local function addElement(config, elementConstructor)
                local wrapper = Instance.new("Frame")
                wrapper.Name = config.Name or "Element"
                wrapper.Size = UDim2.new(1, 0, 0, 40)
                wrapper.BackgroundColor3 = theme.ElementBg
                wrapper.BorderSizePixel = 0
                Instance.new("UICorner", wrapper).CornerRadius = UDim.new(0, 8)
                wrapper.Parent = ElementsFrame
                
                local shadow = Utility.CreateShadow(wrapper, UDim2.new(1, 0, 1, 0), 2, 0.9)
                shadow.ZIndex = wrapper.ZIndex - 1
                local stroke = Instance.new("UIStroke")
                stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                stroke.Color = theme.ElementStroke
                stroke.Thickness = 1.5
                stroke.Parent = wrapper
                
                -- Tooltip
                if config.Description then
                    local tooltip
                    wrapper.MouseEnter:Connect(function()
                        if tooltip then tooltip:Destroy() end
                        tooltip = Instance.new("Frame")
                        tooltip.Size = UDim2.new(0, 0, 0, 0)
                        tooltip.BackgroundColor3 = theme.NotificationBg
                        tooltip.BorderSizePixel = 0
                        Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0, 6)
                        local ttLabel = Instance.new("TextLabel")
                        ttLabel.BackgroundTransparency = 1
                        ttLabel.Text = config.Description
                        ttLabel.TextColor3 = theme.NotificationText
                        ttLabel.Font = Enum.Font.Gotham
                        ttLabel.TextSize = 12
                        ttLabel.Parent = tooltip
                        ttLabel.Size = UDim2.new(1, 0, 1, 0)
                        tooltip.Parent = Gui
                        tooltip.Position = UDim2.new(0, mouse.X + 10, 0, mouse.Y + 10)
                        TweenService:Create(tooltip, TweenInfo.new(0.2), {Size = UDim2.new(0, ttLabel.TextBounds.X + 20, 0, 20)}):Play()
                    end)
                    wrapper.MouseLeave:Connect(function()
                        if tooltip then tooltip:Destroy() end
                    end)
                end
                
                local element = elementConstructor(wrapper, config, theme)
                element._wrapper = wrapper
                element._config = config
                
                -- Hover & Press effects
                wrapper.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        TweenService:Create(wrapper, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 38)}):Play()
                    end
                end)
                wrapper.InputEnded:Connect(function(input)
                    TweenService:Create(wrapper, TweenInfo.new(0.2, Enum.EasingStyle.Elastic), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                end)
                wrapper.MouseEnter:Connect(function()
                    TweenService:Create(wrapper, TweenInfo.new(0.15), {BackgroundColor3 = theme.ElementHover}):Play()
                    if stroke then stroke.Color = theme.ElementStroke:Lerp(Color3.fromRGB(255,255,255), 0.2) end
                end)
                wrapper.MouseLeave:Connect(function()
                    TweenService:Create(wrapper, TweenInfo.new(0.15), {BackgroundColor3 = theme.ElementBg}):Play()
                    if stroke then stroke.Color = theme.ElementStroke end
                end)
                
                updateSectionSize()
                return element
            end
            
            -- Components
            function Section:AddToggle(config)
                local function constructor(parent, cfg, th)
                    local toggleFrame = Instance.new("Frame")
                    toggleFrame.Size = UDim2.new(0, 44, 0, 24)
                    toggleFrame.Position = UDim2.new(1, -50, 0.5, -12)
                    toggleFrame.BackgroundColor3 = cfg.Default and th.IndicatorOn or th.IndicatorOff
                    toggleFrame.BorderSizePixel = 0
                    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)
                    toggleFrame.Parent = parent
                    
                    local toggleKnob = Instance.new("Frame")
                    toggleKnob.Size = UDim2.new(0, 18, 0, 18)
                    toggleKnob.Position = cfg.Default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                    toggleKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    toggleKnob.BorderSizePixel = 0
                    Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1, 0)
                    toggleKnob.Parent = toggleFrame
                    
                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, -60, 1, 0)
                    label.Position = UDim2.new(0, 10, 0, 0)
                    label.Text = cfg.Name
                    label.TextColor3 = th.ElementText
                    label.Font = Enum.Font.Gotham
                    label.TextSize = 14
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Parent = parent
                    
                    local state = cfg.Default
                    local flag = cfg.Flag
                    if flag and Flags[flag] ~= nil then
                        state = Flags[flag]
                        if state then
                            toggleFrame.BackgroundColor3 = th.IndicatorOn
                            toggleKnob:TweenPosition(UDim2.new(1, -21, 0.5, -9), "Out", "Quad", 0.15)
                        else
                            toggleFrame.BackgroundColor3 = th.IndicatorOff
                            toggleKnob:TweenPosition(UDim2.new(0, 3, 0.5, -9), "Out", "Quad", 0.15)
                        end
                    end
                    
                    local function set(val, nosave)
                        state = val
                        if flag then Flags[flag] = val end
                        if val then
                            TweenService:Create(toggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = th.IndicatorOn}):Play()
                            TweenService:Create(toggleKnob, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
                        else
                            TweenService:Create(toggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = th.IndicatorOff}):Play()
                            TweenService:Create(toggleKnob, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
                        end
                        pcall(function() if cfg.Callback then cfg.Callback(val) end end)
                    end
                    
                    toggleFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            set(not state)
                        end
                    end)
                    
                    return {
                        SetValue = function(val) set(val) end,
                        GetValue = function() return state end,
                    }
                end
                return addElement(config, constructor)
            end
            
            function Section:AddButton(config)
                local function constructor(parent, cfg, th)
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -20, 1, -10)
                    btn.Position = UDim2.new(0, 10, 0, 5)
                    btn.BackgroundTransparency = 1
                    btn.Text = cfg.Name
                    btn.TextColor3 = th.Accent
                    btn.Font = Enum.Font.GothamBold
                    btn.TextSize = 14
                    btn.Parent = parent
                    btn.MouseButton1Click:Connect(function()
                        Utility.Ripple(btn)
                        pcall(function() cfg.Callback() end)
                    end)
                    if cfg.Icon then
                        btn.Text = cfg.Icon .. "  " .. cfg.Name
                    end
                    return {
                        SetText = function(txt) btn.Text = txt end,
                        Click = function() pcall(cfg.Callback) end,
                    }
                end
                return addElement(config, constructor)
            end
            
            function Section:AddSlider(config)
                local function constructor(parent, cfg, th)
                    local sliderFrame = Instance.new("Frame")
                    sliderFrame.Size = UDim2.new(1, -40, 1, 0)
                    sliderFrame.BackgroundTransparency = 1
                    sliderFrame.Parent = parent
                    
                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(0.4, 0, 1, 0)
                    label.Text = cfg.Name
                    label.TextColor3 = th.ElementText
                    label.Font = Enum.Font.Gotham
                    label.TextSize = 14
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Parent = sliderFrame
                    
                    local valueLabel = Instance.new("TextLabel")
                    valueLabel.BackgroundTransparency = 1
                    valueLabel.Size = UDim2.new(0, 60, 1, 0)
                    valueLabel.Position = UDim2.new(1, -60, 0, 0)
                    valueLabel.Text = tostring(cfg.Default)
                    valueLabel.TextColor3 = th.Accent
                    valueLabel.Font = Enum.Font.GothamBold
                    valueLabel.TextSize = 12
                    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                    valueLabel.Parent = sliderFrame
                    
                    local track = Instance.new("Frame")
                    track.Size = UDim2.new(1, -80, 0, 6)
                    track.Position = UDim2.new(0, 60, 0.5, -3)
                    track.BackgroundColor3 = th.SliderTrack
                    track.BorderSizePixel = 0
                    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)
                    track.Parent = sliderFrame
                    
                    local fill = Instance.new("Frame")
                    fill.Size = UDim2.new(0, 0, 1, 0)
                    fill.BackgroundColor3 = th.SliderFill
                    fill.BorderSizePixel = 0
                    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
                    fill.Parent = track
                    
                    local thumb = Instance.new("Frame")
                    thumb.Size = UDim2.new(0, 14, 0, 14)
                    thumb.Position = UDim2.new(0, 0, 0.5, -7)
                    thumb.BackgroundColor3 = th.SliderThumb
                    thumb.BorderSizePixel = 0
                    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
                    local thumbStroke = Instance.new("UIStroke")
                    thumbStroke.Thickness = 2
                    thumbStroke.Color = th.ElementStroke
                    thumbStroke.Parent = thumb
                    thumb.Parent = track
                    -- expanded hitbox
                    local hitbox = Instance.new("Frame")
                    hitbox.Size = UDim2.new(0, 24, 0, 24)
                    hitbox.Position = UDim2.new(0, -5, 0, -5)
                    hitbox.BackgroundTransparency = 1
                    hitbox.Parent = thumb
                    
                    local min = cfg.Min or 0
                    local max = cfg.Max or 100
                    local step = cfg.Step or 1
                    local current = cfg.Default or min
                    local flag = cfg.Flag
                    if flag and Flags[flag] ~= nil then current = Flags[flag] end
                    local function updateVisual(val)
                        val = Utility.Clamp(val, min, max)
                        local frac = (val - min) / (max - min)
                        fill.Size = UDim2.new(frac, 0, 1, 0)
                        thumb.Position = UDim2.new(frac, -7, 0.5, -7)
                        valueLabel.Text = (cfg.ValuePrefix or "") .. tostring(val) .. (cfg.ValueSuffix or "")
                    end
                    updateVisual(current)
                    
                    -- Drag handling
                    local dragging = false
                    local function setFromMouse(pos)
                        local relpos = pos.X - track.AbsolutePosition.X
                        local frac = math.clamp(relpos / track.AbsoluteSize.X, 0, 1)
                        local raw = min + frac * (max - min)
                        if step and step > 0 then
                            raw = math.round(raw / step) * step
                        end
                        raw = Utility.Clamp(raw, min, max)
                        current = raw
                        updateVisual(current)
                        if flag then Flags[flag] = current end
                        pcall(function() cfg.Callback(current) end)
                    end
                    
                    local function onInputBegan(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            setFromMouse(input.Position)
                            local conn
                            conn = UserInputService.InputChanged:Connect(function(changedInput)
                                if dragging and changedInput.UserInputType == Enum.UserInputType.MouseMovement then
                                    setFromMouse(changedInput.Position)
                                elseif dragging and changedInput.UserInputType == Enum.UserInputType.Touch then
                                    setFromMouse(changedInput.Position)
                                end
                            end)
                            local endConn
                            endConn = UserInputService.InputEnded:Connect(function(endedInput)
                                if endedInput.UserInputType == Enum.UserInputType.MouseButton1 or endedInput.UserInputType == Enum.UserInputType.Touch then
                                    dragging = false
                                    if conn then conn:Disconnect() end
                                    if endConn then endConn:Disconnect() end
                                end
                            end)
                        end
                    end
                    hitbox.InputBegan:Connect(onInputBegan)
                    track.InputBegan:Connect(onInputBegan)
                    
                    return {
                        SetValue = function(val) updateVisual(val) end,
                        GetValue = function() return current end,
                        SetLimits = function(newMin, newMax) min = newMin; max = newMax; updateVisual(current) end,
                    }
                end
                return addElement(config, constructor)
            end
            
            function Section:AddDropdown(config)
                -- simplified dropdown
                local function constructor(parent, cfg, th)
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -20, 1, -10)
                    btn.Position = UDim2.new(0, 10, 0, 5)
                    btn.BackgroundTransparency = 1
                    btn.Text = cfg.Name .. ": " .. (cfg.Default or cfg.Options[1] or "")
                    btn.TextColor3 = th.ElementText
                    btn.Font = Enum.Font.Gotham
                    btn.TextSize = 14
                    btn.TextXAlignment = Enum.TextXAlignment.Left
                    btn.Parent = parent
                    
                    local chevron = Instance.new("TextLabel")
                    chevron.BackgroundTransparency = 1
                    chevron.Size = UDim2.new(0, 20, 1, 0)
                    chevron.Position = UDim2.new(1, -20, 0, 0)
                    chevron.Text = "˅"
                    chevron.TextColor3 = th.Accent
                    chevron.Font = Enum.Font.GothamBold
                    chevron.TextSize = 16
                    chevron.Parent = btn
                    
                    local dropdown = Instance.new("Frame")
                    dropdown.Name = "DropdownList"
                    dropdown.Size = UDim2.new(1, 0, 0, 0)
                    dropdown.Position = UDim2.new(0, 0, 1, 0)
                    dropdown.BackgroundColor3 = th.DropdownBg
                    dropdown.BorderSizePixel = 0
                    dropdown.ClipsDescendants = true
                    dropdown.ZIndex = 10
                    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)
                    dropdown.Parent = parent
                    
                    local list = Instance.new("ScrollingFrame")
                    list.Size = UDim2.new(1, -4, 1, -4)
                    list.Position = UDim2.new(0, 2, 0, 2)
                    list.BackgroundTransparency = 1
                    list.ScrollBarThickness = 3
                    list.CanvasSize = UDim2.new(0,0,0,0)
                    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    list.Parent = dropdown
                    local listLayout = Instance.new("UIListLayout")
                    listLayout.Parent = list
                    
                    local options = cfg.Options or {}
                    local selected = cfg.Default or (cfg.MultiSelect and {} or options[1])
                    local isMulti = cfg.MultiSelect
                    
                    local function rebuildOptions()
                        for _, child in ipairs(list:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
                        for _, opt in ipairs(options) do
                            local optBtn = Instance.new("TextButton")
                            optBtn.Size = UDim2.new(1, 0, 0, 25)
                            optBtn.BackgroundTransparency = 1
                            optBtn.Text = opt
                            optBtn.TextColor3 = th.ElementText
                            optBtn.Font = Enum.Font.Gotham
                            optBtn.TextSize = 13
                            optBtn.Parent = list
                            optBtn.MouseButton1Click:Connect(function()
                                if isMulti then
                                    local idx = table.find(selected, opt)
                                    if idx then
                                        table.remove(selected, idx)
                                    else
                                        table.insert(selected, opt)
                                    end
                                    btn.Text = cfg.Name .. ": " .. table.concat(selected, ", ")
                                else
                                    selected = opt
                                    btn.Text = cfg.Name .. ": " .. opt
                                    dropdown:TweenSize(UDim2.new(1, 0, 0, 0), "In", "Quad", 0.2, true)
                                end
                                pcall(function() cfg.Callback(isMulti and selected or selected) end)
                            end)
                            optBtn.MouseEnter:Connect(function() optBtn.BackgroundColor3 = th.DropdownHover end)
                            optBtn.MouseLeave:Connect(function() optBtn.BackgroundTransparency = 1 end)
                        end
                        list.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y)
                    end
                    rebuildOptions()
                    
                    local expanded = false
                    btn.MouseButton1Click:Connect(function()
                        if expanded then
                            dropdown:TweenSize(UDim2.new(1, 0, 0, 0), "In", "Quad", 0.2, true)
                            chevron.Text = "˅"
                        else
                            dropdown:TweenSize(UDim2.new(1, 0, 0, math.min(150, listLayout.AbsoluteContentSize.Y+10)), "Out", "Back", 0.3)
                            chevron.Text = "˄"
                        end
                        expanded = not expanded
                    end)
                    
                    return {
                        UpdateOptions = function(newOpts) options = newOpts; rebuildOptions() end,
                        SetValue = function(val) selected = val; btn.Text = cfg.Name .. ": " .. (isMulti and table.concat(val,", ") or val) end,
                        GetValue = function() return selected end,
                    }
                end
                return addElement(config, constructor)
            end
            
            function Section:AddColorPicker(config)
                -- simplified: button that opens sliders
                local function constructor(parent, cfg, th)
                    local swatch = Instance.new("Frame")
                    swatch.Size = UDim2.new(0, 30, 0, 30)
                    swatch.Position = UDim2.new(1, -40, 0.5, -15)
                    swatch.BackgroundColor3 = cfg.Default or Color3.fromRGB(255,255,255)
                    swatch.BorderSizePixel = 0
                    Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 6)
                    swatch.Parent = parent
                    
                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, -80, 1, 0)
                    label.Text = cfg.Name
                    label.TextColor3 = th.ElementText
                    label.Font = Enum.Font.Gotham
                    label.TextSize = 14
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Parent = parent
                    
                    local popup = Instance.new("Frame")
                    popup.Size = UDim2.new(0, 200, 0, 0)
                    popup.Position = UDim2.new(1, -210, 1, -5)
                    popup.BackgroundColor3 = th.DropdownBg
                    popup.BorderSizePixel = 0
                    popup.ClipsDescendants = true
                    popup.ZIndex = 15
                    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
                    popup.Parent = parent
                    
                    local hovering = false
                    swatch.MouseEnter:Connect(function() hovering = true end)
                    swatch.MouseLeave:Connect(function() hovering = false; if not popupVisible then popup:TweenSize(UDim2.new(0,200,0,0), "In", "Quad", 0.2) end end)
                    
                    -- Popup content: 3 sliders and hex input
                    -- (simplified; actual implementation would build sliders)
                    local popupVisible = false
                    swatch.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if popupVisible then
                                popup:TweenSize(UDim2.new(0,200,0,0), "In", "Quad", 0.2)
                            else
                                popup:TweenSize(UDim2.new(0,200,0,150), "Out", "Back", 0.3)
                            end
                            popupVisible = not popupVisible
                        end
                    end)
                    return {
                        SetColor = function(col) swatch.BackgroundColor3 = col end,
                        GetColor = function() return swatch.BackgroundColor3 end,
                    }
                end
                return addElement(config, constructor)
            end
            
            function Section:AddBind(config)
                local function constructor(parent, cfg, th)
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -20, 1, -10)
                    btn.Position = UDim2.new(0, 10, 0, 5)
                    btn.BackgroundTransparency = 1
                    btn.Text = cfg.Name .. ": " .. (cfg.Default and cfg.Default.Name or "None")
                    btn.TextColor3 = th.ElementText
                    btn.Font = Enum.Font.Gotham
                    btn.TextSize = 14
                    btn.TextXAlignment = Enum.TextXAlignment.Left
                    btn.Parent = parent
                    
                    local listening = false
                    local currentBind = cfg.Default
                    btn.MouseButton1Click:Connect(function()
                        listening = true
                        btn.Text = cfg.Name .. ": ..."
                        local conn
                        conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                            if not gameProcessed and listening then
                                listening = false
                                if input.UserInputType == Enum.UserInputType.Keyboard then
                                    currentBind = input.KeyCode
                                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    currentBind = "MB1"
                                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                                    currentBind = "MB2"
                                else
                                    currentBind = input.UserInputType
                                end
                                btn.Text = cfg.Name .. ": " .. (type(currentBind)=="EnumItem" and currentBind.Name or tostring(currentBind))
                                conn:Disconnect()
                                pcall(cfg.Callback, currentBind)
                            end
                        end)
                    end)
                    return {
                        SetBind = function(bind) currentBind = bind; btn.Text = cfg.Name .. ": " .. (type(bind)=="EnumItem" and bind.Name or tostring(bind)) end,
                        GetBind = function() return currentBind end,
                        Fire = function() pcall(cfg.Callback, currentBind) end,
                    }
                end
                return addElement(config, constructor)
            end
            
            function Section:AddTextbox(config)
                local function constructor(parent, cfg, th)
                    local box = Instance.new("TextBox")
                    box.Size = UDim2.new(1, -20, 0, 30)
                    box.Position = UDim2.new(0, 10, 0.5, -15)
                    box.BackgroundColor3 = th.ElementBg
                    box.BorderSizePixel = 0
                    box.Text = cfg.Default or ""
                    box.PlaceholderText = cfg.Placeholder or ""
                    box.TextColor3 = th.ElementText
                    box.PlaceholderColor3 = th.ElementText:Lerp(Color3.fromRGB(255,255,255), 0.5)
                    box.Font = Enum.Font.Gotham
                    box.TextSize = 14
                    box.ClearTextOnFocus = false
                    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
                    box.Parent = parent
                    return {
                        GetText = function() return box.Text end,
                        SetText = function(t) box.Text = t end,
                    }
                end
                return addElement(config, constructor)
            end
            
            function Section:AddLabel(text)
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 0, 20)
                lbl.BackgroundTransparency = 1
                lbl.Text = text
                lbl.TextColor3 = ThemeManager.Current.ElementText
                lbl.Font = Enum.Font.Gotham
                lbl.TextSize = 14
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = ElementsFrame
                updateSectionSize()
                return {}
            end
            
            function Section:AddParagraph(title, body)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 50)
                frame.BackgroundTransparency = 1
                frame.BorderSizePixel = 0
                frame.Parent = ElementsFrame
                local tlabel = Instance.new("TextLabel")
                tlabel.Size = UDim2.new(1, 0, 0, 20)
                tlabel.BackgroundTransparency = 1
                tlabel.Text = title
                tlabel.Font = Enum.Font.GothamBold
                tlabel.TextColor3 = ThemeManager.Current.Accent
                tlabel.TextSize = 14
                tlabel.TextXAlignment = Enum.TextXAlignment.Left
                tlabel.Parent = frame
                local blabel = Instance.new("TextLabel")
                blabel.Size = UDim2.new(1, 0, 0, 30)
                blabel.Position = UDim2.new(0, 0, 0, 22)
                blabel.BackgroundTransparency = 1
                blabel.Text = body
                blabel.TextColor3 = ThemeManager.Current.ElementText
                blabel.Font = Enum.Font.Gotham
                blabel.TextSize = 13
                blabel.TextWrapped = true
                blabel.TextXAlignment = Enum.TextXAlignment.Left
                blabel.Parent = frame
                updateSectionSize()
                return {}
            end
            
            function Section:AddSeparator()
                local sep = Instance.new("Frame")
                sep.Size = UDim2.new(1, 0, 0, 1)
                sep.BackgroundColor3 = ThemeManager.Current.ElementStroke
                sep.BorderSizePixel = 0
                sep.Parent = ElementsFrame
                updateSectionSize()
                return {}
            end
            
            return Section
        end
        
        -- Activate tab on click
        TabBtn.MouseButton1Click:Connect(function()
            for _, otherContent in pairs(TabContent) do
                otherContent.Visible = false
            end
            Content.Visible = true
            TabContent[name] = Content
            -- Update tab visuals
            for _, child in ipairs(TabFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = child == TabBtn and theme.TabActiveBg or theme.TabInactiveBg,
                        TextColor3 = child == TabBtn and theme.TabTextActive or theme.TabTextInactive
                    }):Play()
                end
            end
        end)
        
        -- Store and make first tab active
        if #TabContent == 0 then
            TabBtn.MouseButton1Click:Fire()
        end
        TabContent[name] = Content
        
        return Tab
    end
    
    function Window:SetTheme(newTheme)
        ThemeManager.SetTheme(newTheme)
        -- Update all colors recursively (basic implementation)
        local function updateColors(object)
            if object:IsA("GuiObject") then
                -- use theme.Current to set appropriate colors based on name/tags
                -- For simplicity, we just update the window's main parts, but full implementation would iterate and match
            end
            for _, child in ipairs(object:GetChildren()) do updateColors(child) end
        end
        updateColors(Main)
    end
    
    function Window:SetTitle(newTitle)
        TitleLabel.Text = newTitle
    end
    
    function Window:Minimize()
        MinimizeButton.MouseButton1Click:Fire()
    end
    
    function Window:Close()
        CloseButton.MouseButton1Click:Fire()
    end
    
    function Window:Notify(data)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(1, 0, 0, 50)
        notif.BackgroundColor3 = ThemeManager.Current.NotificationBg
        notif.BorderSizePixel = 0
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -10, 0, 20)
        titleLabel.Position = UDim2.new(0, 5, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = data.Title or "Notification"
        titleLabel.TextColor3 = ThemeManager.Current.Accent
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notif
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -10, 0, 20)
        descLabel.Position = UDim2.new(0, 5, 0, 25)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = data.Content or ""
        descLabel.TextColor3 = ThemeManager.Current.NotificationText
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = notif
        notif.Parent = NotifHolder
        
        -- Animate in
        notif.Position = UDim2.new(1, 0, 0, -60)
        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        -- Auto dismiss
        delay(data.Duration or 5, function()
            TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0, -60)}):Play()
            wait(0.3)
            notif:Destroy()
        end)
    end
    
    -- Entrance animation
    Main.BackgroundTransparency = 1
    Main.Size = UDim2.new(0,0,0,0)
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {BackgroundTransparency = 0, Size = config.Size or UDim2.new(0,600,0,450)}):Play()
    
    return Window
end

-- ==================== GLOBAL THEME SETTER ====================
function ClavisLib:SetGlobalTheme(theme)
    ThemeManager.SetTheme(theme)
end

-- ==================== AUTO-LOAD FROM CONFIG ====================
function ClavisLib:LoadAuto(config)
    local window = self:CreateWindow(config.Title or "ClavisLib", config.Window)
    for _, tabCfg in ipairs(config.Tabs or {}) do
        local tab = window:CreateTab(tabCfg.Name, tabCfg.Icon)
        for _, sectionCfg in ipairs(tabCfg.Sections or {}) do
            local section = tab:AddSection(sectionCfg.Name, sectionCfg.Collapsed)
            for _, elem in ipairs(sectionCfg.Elements or {}) do
                local t = elem.Type
                if t == "Toggle" and section.AddToggle then section:AddToggle(elem) end
                if t == "Button" and section.AddButton then section:AddButton(elem) end
                if t == "Slider" and section.AddSlider then section:AddSlider(elem) end
                if t == "Dropdown" and section.AddDropdown then section:AddDropdown(elem) end
                if t == "ColorPicker" and section.AddColorPicker then section:AddColorPicker(elem) end
                if t == "Bind" and section.AddBind then section:AddBind(elem) end
                if t == "Textbox" and section.AddTextbox then section:AddTextbox(elem) end
                if t == "Label" and section.AddLabel then section:AddLabel(elem.Text) end
                if t == "Paragraph" and section.AddParagraph then section:AddParagraph(elem.Title, elem.Body) end
                if t == "Separator" and section.AddSeparator then section:AddSeparator() end
            end
        end
    end
    return window
end

return ClavisLib
