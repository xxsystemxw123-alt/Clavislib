--[[
    ClavisLib - The ultimate Roblox UI library
    Version 1.0.1 (Luau optimized, error‑hardened)
    Carga: local ClavisLib = loadstring(game:HttpGet("URL"))()
           local Window = ClavisLib:CreateWindow("Title", {Theme = "Dark"})
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- ------------------- UTILITY --------------------
local Utility = {}
function Utility.CreateShadow(parent, offset, transparency)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = Color3.new(0,0,0)
    shadow.BorderSizePixel = 0
    shadow.Size = UDim2.new(1,0,1,0)
    shadow.Position = UDim2.new(0, offset or 3, 0, offset or 3)
    shadow.BackgroundTransparency = transparency or 0.9
    shadow.ZIndex = 0
    shadow.Parent = parent
    return shadow
end

function Utility.MakeDraggable(frame, dragPart)
    dragPart = dragPart or frame
    local dragging, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
    ripple.BackgroundColor3 = Color3.fromRGB(255,255,255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0,0,0,0)
    ripple.Position = UDim2.new(0.5,0,0.5,0)
    ripple.AnchorPoint = Vector2.new(0.5,0.5)
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

function Utility.GetMouseLocation()
    return UserInputService:GetMouseLocation()
end

-- ---------------- THEME MANAGER ------------------
local ThemeManager = {}
ThemeManager.Presets = {
    Dark = {
        MainBg = Color3.fromRGB(25,25,30),
        TitleBarBg = Color3.fromRGB(20,20,25),
        TabBarBg = Color3.fromRGB(18,18,22),
        TabInactiveBg = Color3.fromRGB(30,30,35),
        TabActiveBg = Color3.fromRGB(66,133,244),
        TabTextInactive = Color3.fromRGB(180,180,185),
        TabTextActive = Color3.fromRGB(255,255,255),
        Accent = Color3.fromRGB(66,133,244),
        AccentText = Color3.fromRGB(255,255,255),
        ElementBg = Color3.fromRGB(35,35,40),
        ElementStroke = Color3.fromRGB(50,50,55),
        ElementText = Color3.fromRGB(220,220,225),
        ElementHover = Color3.fromRGB(45,45,50),
        IndicatorOn = Color3.fromRGB(66,133,244),
        IndicatorOff = Color3.fromRGB(60,60,65),
        SliderTrack = Color3.fromRGB(45,45,50),
        SliderFill = Color3.fromRGB(66,133,244),
        SliderThumb = Color3.fromRGB(255,255,255),
        DropdownBg = Color3.fromRGB(30,30,35),
        DropdownHover = Color3.fromRGB(45,45,50),
        Scrollbar = Color3.fromRGB(66,133,244),
        ScrollbarBg = Color3.fromRGB(20,20,25),
        Shadow = Color3.fromRGB(0,0,0),
        NotificationBg = Color3.fromRGB(40,40,45),
        NotificationText = Color3.fromRGB(255,255,255),
    },
    Light = {
        MainBg = Color3.fromRGB(240,240,245),
        TitleBarBg = Color3.fromRGB(230,230,235),
        TabBarBg = Color3.fromRGB(220,220,225),
        TabInactiveBg = Color3.fromRGB(210,210,215),
        TabActiveBg = Color3.fromRGB(66,133,244),
        TabTextInactive = Color3.fromRGB(100,100,110),
        TabTextActive = Color3.fromRGB(255,255,255),
        Accent = Color3.fromRGB(66,133,244),
        AccentText = Color3.fromRGB(255,255,255),
        ElementBg = Color3.fromRGB(255,255,255),
        ElementStroke = Color3.fromRGB(200,200,210),
        ElementText = Color3.fromRGB(30,30,35),
        ElementHover = Color3.fromRGB(245,245,250),
        IndicatorOn = Color3.fromRGB(66,133,244),
        IndicatorOff = Color3.fromRGB(180,180,190),
        SliderTrack = Color3.fromRGB(210,210,215),
        SliderFill = Color3.fromRGB(66,133,244),
        SliderThumb = Color3.fromRGB(255,255,255),
        DropdownBg = Color3.fromRGB(245,245,250),
        DropdownHover = Color3.fromRGB(230,230,235),
        Scrollbar = Color3.fromRGB(66,133,244),
        ScrollbarBg = Color3.fromRGB(210,210,215),
        Shadow = Color3.fromRGB(0,0,0),
        NotificationBg = Color3.fromRGB(255,255,255),
        NotificationText = Color3.fromRGB(30,30,35),
    },
    Amethyst = {
        MainBg = Color3.fromRGB(35,25,45),
        TitleBarBg = Color3.fromRGB(30,20,40),
        TabBarBg = Color3.fromRGB(25,15,35),
        TabInactiveBg = Color3.fromRGB(40,30,50),
        TabActiveBg = Color3.fromRGB(170,100,255),
        TabTextInactive = Color3.fromRGB(200,180,220),
        TabTextActive = Color3.fromRGB(255,255,255),
        Accent = Color3.fromRGB(170,100,255),
        AccentText = Color3.fromRGB(255,255,255),
        ElementBg = Color3.fromRGB(45,35,55),
        ElementStroke = Color3.fromRGB(70,55,85),
        ElementText = Color3.fromRGB(230,220,245),
        ElementHover = Color3.fromRGB(55,45,65),
        IndicatorOn = Color3.fromRGB(170,100,255),
        IndicatorOff = Color3.fromRGB(70,55,85),
        SliderTrack = Color3.fromRGB(55,45,70),
        SliderFill = Color3.fromRGB(170,100,255),
        SliderThumb = Color3.fromRGB(255,255,255),
        DropdownBg = Color3.fromRGB(40,30,50),
        DropdownHover = Color3.fromRGB(55,45,65),
        Scrollbar = Color3.fromRGB(170,100,255),
        ScrollbarBg = Color3.fromRGB(25,15,35),
        Shadow = Color3.fromRGB(0,0,0),
        NotificationBg = Color3.fromRGB(50,40,60),
        NotificationText = Color3.fromRGB(255,255,255),
    }
}
ThemeManager.Current = ThemeManager.Presets.Dark

function ThemeManager.SetTheme(theme)
    if type(theme) == "string" then
        ThemeManager.Current = ThemeManager.Presets[theme] or ThemeManager.Presets.Dark
    else
        ThemeManager.Current = theme
    end
    if ThemeManager.OnThemeChanged then
        ThemeManager.OnThemeChanged()
    end
end

-- ----------------- GLOBAL FLAGS ------------------
local Flags = {}

-- ==================== CLASSLIB ====================
local ClavisLib = {
    Version = "1.0.1"
}

-- ================ WINDOW CREATION ================
function ClavisLib:CreateWindow(title, config)
    config = config or {}
    local theme = ThemeManager.Current
    if config.Theme then
        ThemeManager.SetTheme(config.Theme)
        theme = ThemeManager.Current
    end

    local connections = {}

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "ClavisLib_" .. title
    Gui.ResetOnSpawn = false
    pcall(function() Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end)

    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.Size = UDim2.new(1,0,1,0)
    Overlay.Visible = config.BlurBackground ~= false
    Overlay.Parent = Gui

    local Window = {}
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = config.Size or UDim2.new(0,600,0,450)
    Main.Position = UDim2.new(0.5, -(config.Size and config.Size.X.Offset or 600)/2, 0.5, -(config.Size and config.Size.Y.Offset or 450)/2)
    Main.BackgroundColor3 = theme.MainBg
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = Gui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,12)
    Corner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Color = theme.ElementStroke
    MainStroke.Thickness = 2
    MainStroke.Parent = Main

    local WindowShadow = Instance.new("Frame")
    WindowShadow.Name = "WinShadow"
    WindowShadow.Size = UDim2.new(1,0,1,0)
    WindowShadow.Position = UDim2.new(0,4,0,4)
    WindowShadow.BackgroundColor3 = theme.Shadow
    WindowShadow.BackgroundTransparency = 0.85
    WindowShadow.BorderSizePixel = 0
    WindowShadow.ZIndex = Main.ZIndex - 1
    Instance.new("UICorner", WindowShadow).CornerRadius = UDim.new(0,12)
    WindowShadow.Parent = Main

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1,0,0,40)
    TitleBar.BackgroundColor3 = theme.TitleBarBg
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,12)

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.TitleBarBg),
        ColorSequenceKeypoint.new(1, theme.TitleBarBg:Lerp(Color3.fromRGB(255,255,255), 0.1))
    })
    TitleGradient.Rotation = 90
    TitleGradient.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = theme.ElementText
    TitleLabel.TextSize = 16
    TitleLabel.Size = UDim2.new(1,-80,1,0)
    TitleLabel.Position = UDim2.new(0,15,0,0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0,28,0,28)
    CloseButton.Position = UDim2.new(1,-35,0,6)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255,100,100)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Image = "rbxassetid://3926305904"
    CloseButton.ImageColor3 = theme.ElementText
    CloseButton.ScaleType = Enum.ScaleType.Fit
    CloseButton.ZIndex = 10
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1,0)
    CloseButton.Parent = TitleBar

    local CloseStroke = Instance.new("UIStroke")
    CloseStroke.Thickness = 1
    CloseStroke.Color = theme.ElementStroke
    CloseStroke.Parent = CloseButton

    table.insert(connections, CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.7, ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
    end))
    table.insert(connections, CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 1, ImageColor3 = theme.ElementText}):Play()
    end))

    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0,28,0,28)
    MinimizeButton.Position = UDim2.new(1,-70,0,6)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Image = "rbxassetid://3926305904"
    MinimizeButton.ImageColor3 = theme.ElementText
    MinimizeButton.ScaleType = Enum.ScaleType.Fit
    MinimizeButton.ZIndex = 10
    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(1,0)
    MinimizeButton.Parent = TitleBar
    table.insert(connections, MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.7, ImageColor3 = Color3.fromRGB(255,255,255)}):Play()
    end))
    table.insert(connections, MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundTransparency = 1, ImageColor3 = theme.ElementText}):Play()
    end))

    local MinimizedIcon = Instance.new("ImageButton")
    MinimizedIcon.Name = "MinimizedIcon"
    MinimizedIcon.Size = UDim2.new(0,50,0,50)
    MinimizedIcon.Position = UDim2.new(0.5,-25,0.8,0)
    MinimizedIcon.BackgroundColor3 = theme.Accent
    MinimizedIcon.Image = "rbxassetid://3926305904"
    MinimizedIcon.ScaleType = Enum.ScaleType.Fit
    MinimizedIcon.Visible = false
    Instance.new("UICorner", MinimizedIcon).CornerRadius = UDim.new(1,0)
    MinimizedIcon.Parent = Gui

    -- Resize handle
    if config.Resizable ~= false then
        local ResizeHandle = Instance.new("ImageButton")
        ResizeHandle.Name = "Resize"
        ResizeHandle.Size = UDim2.new(0,20,0,20)
        ResizeHandle.Position = UDim2.new(1,-20,1,-20)
        ResizeHandle.BackgroundTransparency = 1
        ResizeHandle.Image = "rbxassetid://3926305904"
        ResizeHandle.ImageColor3 = theme.ElementText
        ResizeHandle.ImageTransparency = 0.5
        ResizeHandle.ZIndex = 10
        ResizeHandle.Parent = Main
        local resizing, resizeStart, startSize
        table.insert(connections, ResizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                resizeStart = input.Position
                startSize = Main.Size
                local conn
                conn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        resizing = false
                        if conn then conn:Disconnect() end
                    end
                end)
            end
        end))
        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - resizeStart
                local newWidth = math.max(config.MinSize and config.MinSize.X.Offset or 400, startSize.X.Offset + delta.X)
                local newHeight = math.max(config.MinSize and config.MinSize.Y.Offset or 300, startSize.Y.Offset + delta.Y)
                Main.Size = UDim2.new(0, newWidth, 0, newHeight)
            end
        end))
    end

    Utility.MakeDraggable(Main, TitleBar)

    local minimized = false
    local originalSize = Main.Size
    local originalPosition = Main.Position
    table.insert(connections, MinimizeButton.MouseButton1Click:Connect(function()
        if minimized then
            Main.Visible = true
            MinimizedIcon.Visible = false
            minimized = false
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = originalSize,
                Position = originalPosition
            }):Play()
        else
            originalSize = Main.Size
            originalPosition = Main.Position
            Main.Visible = false
            MinimizedIcon.Visible = true
            minimized = true
        end
    end))
    table.insert(connections, MinimizedIcon.MouseButton1Click:Connect(function()
        Main.Visible = true
        MinimizedIcon.Visible = false
        minimized = false
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = originalSize,
            Position = originalPosition
        }):Play()
    end))

    -- Tab bar (scrollable)
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1,-10,0,44)
    TabBar.Position = UDim2.new(0,5,0,42)
    TabBar.BackgroundColor3 = theme.TabBarBg
    TabBar.BackgroundTransparency = 0.8
    TabBar.BorderSizePixel = 0
    TabBar.ScrollBarThickness = 0
    TabBar.ClipsDescendants = true
    TabBar.CanvasSize = UDim2.new(0,0,0,0)
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0,22)
    TabBar.Parent = Main

    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center
    TabList.Padding = UDim.new(0,6)
    TabList.Parent = TabBar

    -- Fade indicators
    local LeftFade = Instance.new("Frame")
    LeftFade.Size = UDim2.new(0,20,1,0)
    LeftFade.Position = UDim2.new(0,0,0,0)
    LeftFade.BackgroundTransparency = 1
    LeftFade.BorderSizePixel = 0
    LeftFade.ZIndex = 2
    Instance.new("UIGradient", LeftFade).Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
    })
    LeftFade.Parent = TabBar
    local RightFade = Instance.new("Frame")
    RightFade.Size = UDim2.new(0,20,1,0)
    RightFade.Position = UDim2.new(1,-20,0,0)
    RightFade.BackgroundTransparency = 1
    RightFade.BorderSizePixel = 0
    RightFade.ZIndex = 2
    Instance.new("UIGradient", RightFade).Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
    })
    RightFade.Parent = TabBar

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "Content"
    ContentArea.Size = UDim2.new(1,-20,1,-100)
    ContentArea.Position = UDim2.new(0,10,0,90)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = Main

    local TabContent = {}  -- [name] = ScrollingFrame
    local activeTab = nil

    -- Notifications
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "Notifications"
    NotifHolder.Size = UDim2.new(0,300,1,0)
    NotifHolder.Position = UDim2.new(1,-310,0,10)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.BorderSizePixel = 0
    NotifHolder.Parent = Gui
    local NotifList = Instance.new("UIListLayout")
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Top
    NotifList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NotifList.Padding = UDim.new(0,8)
    NotifList.Parent = NotifHolder

    local function applyTheme()
        local th = ThemeManager.Current
        Main.BackgroundColor3 = th.MainBg
        MainStroke.Color = th.ElementStroke
        TitleBar.BackgroundColor3 = th.TitleBarBg
        TitleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, th.TitleBarBg),
            ColorSequenceKeypoint.new(1, th.TitleBarBg:Lerp(Color3.fromRGB(255,255,255), 0.1))
        })
        TitleLabel.TextColor3 = th.ElementText
        CloseButton.ImageColor3 = th.ElementText
        MinimizeButton.ImageColor3 = th.ElementText
        TabBar.BackgroundColor3 = th.TabBarBg
        WindowShadow.BackgroundColor3 = th.Shadow
    end

    local prevOnThemeChanged = ThemeManager.OnThemeChanged
    ThemeManager.OnThemeChanged = function()
        if prevOnThemeChanged then prevOnThemeChanged() end
        applyTheme()
    end

    -- Window methods
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Name = name
        Tab.Icon = icon or ""

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = "Tab_" .. name
        TabBtn.Size = UDim2.new(0,0,1,-10)
        TabBtn.BackgroundColor3 = ThemeManager.Current.TabInactiveBg
        TabBtn.Text = (icon ~= "" and icon.."  " or "") .. name
        TabBtn.TextColor3 = ThemeManager.Current.TabTextInactive
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        TabBtn.BorderSizePixel = 0
        TabBtn.AutoButtonColor = false
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0,15)
        TabBtn.Parent = TabBar

        local padding = 30
        TabBtn.Size = UDim2.new(0, TabBtn.TextBounds.X + padding, 1, -10)

        local function updateCanvas()
            local totalWidth = 0
            for _, child in ipairs(TabBar:GetChildren()) do
                if child:IsA("TextButton") then
                    totalWidth = totalWidth + child.AbsoluteSize.X + 6
                end
            end
            TabBar.CanvasSize = UDim2.new(0, totalWidth + 10, 0, 0)
        end
        updateCanvas()
        TabBtn:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas)

        local Content = Instance.new("ScrollingFrame")
        Content.Name = name .. "_Content"
        Content.Size = UDim2.new(1,0,1,0)
        Content.BackgroundTransparency = 1
        Content.BorderSizePixel = 0
        Content.ScrollBarThickness = 4
        Content.ScrollBarImageColor3 = ThemeManager.Current.Scrollbar
        Content.ScrollBarImageTransparency = 0.5
        Content.CanvasSize = UDim2.new(0,0,0,0)
        Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Content.Visible = false
        Content.Parent = ContentArea

        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0,8)
        ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContentList.Parent = Content

        local function activate()
            for _, otherContent in pairs(TabContent) do
                otherContent.Visible = false
            end
            Content.Visible = true
            activeTab = name
            for _, child in ipairs(TabBar:GetChildren()) do
                if child:IsA("TextButton") then
                    local isActive = child == TabBtn
                    TweenService:Create(child, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = isActive and ThemeManager.Current.TabActiveBg or ThemeManager.Current.TabInactiveBg,
                        TextColor3 = isActive and ThemeManager.Current.TabTextActive or ThemeManager.Current.TabTextInactive
                    }):Play()
                end
            end
        end

        table.insert(connections, TabBtn.MouseButton1Click:Connect(activate))
        TabContent[name] = Content

        if not activeTab then
            activate()
        end

        function Tab:AddSection(sectionName, collapsed)
            local Section = {}
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName
            SectionFrame.Size = UDim2.new(1,-10,0,30)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = Content

            local Header = Instance.new("TextLabel")
            Header.Name = "Header"
            Header.Size = UDim2.new(1,0,0,30)
            Header.BackgroundTransparency = 1
            Header.Font = Enum.Font.GothamBold
            Header.Text = sectionName
            Header.TextColor3 = ThemeManager.Current.Accent
            Header.TextSize = 16
            Header.TextXAlignment = Enum.TextXAlignment.Left
            Header.Parent = SectionFrame

            local SeparatorLine = Instance.new("Frame")
            SeparatorLine.Size = UDim2.new(1,0,0,1)
            SeparatorLine.Position = UDim2.new(0,0,0,30)
            SeparatorLine.BackgroundColor3 = ThemeManager.Current.ElementStroke
            SeparatorLine.BorderSizePixel = 0
            Instance.new("UIGradient", SeparatorLine).Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, ThemeManager.Current.Accent),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
            })
            SeparatorLine.Parent = SectionFrame

            local CollapseButton
            local isCollapsed = collapsed or false
            if collapsed then
                CollapseButton = Instance.new("TextButton")
                CollapseButton.Size = UDim2.new(0,20,0,20)
                CollapseButton.Position = UDim2.new(1,-20,0,5)
                CollapseButton.BackgroundTransparency = 1
                CollapseButton.Text = "▼"
                CollapseButton.TextColor3 = ThemeManager.Current.Accent
                CollapseButton.Font = Enum.Font.GothamBold
                CollapseButton.TextSize = 18
                CollapseButton.Parent = SectionFrame
            end

            local ElementsFrame = Instance.new("Frame")
            ElementsFrame.Name = "Elements"
            ElementsFrame.Size = UDim2.new(1,0,0,0)
            ElementsFrame.BackgroundTransparency = 1
            ElementsFrame.BorderSizePixel = 0
            ElementsFrame.Visible = not isCollapsed
            ElementsFrame.ClipsDescendants = true
            local ElementsList = Instance.new("UIListLayout")
            ElementsList.Padding = UDim.new(0,6)
            ElementsList.Parent = ElementsFrame
            ElementsFrame.Parent = SectionFrame

            local function updateSectionHeight()
                local headerHeight = 30
                local elementHeight = ElementsFrame.Visible and ElementsList.AbsoluteContentSize.Y or 0
                local totalHeight = headerHeight + elementHeight + (elementHeight > 0 and 10 or 0)
                SectionFrame.Size = UDim2.new(1,-10,0,totalHeight)
                Content.CanvasSize = UDim2.new(0,0,0, ContentList.AbsoluteContentSize.Y + 20)
            end

            local function collapseToggle()
                if not CollapseButton then return end
                isCollapsed = not isCollapsed
                ElementsFrame.Visible = not isCollapsed
                CollapseButton.Text = isCollapsed and "▶" or "▼"
                updateSectionHeight()
            end

            if CollapseButton then
                CollapseButton.MouseButton1Click:Connect(collapseToggle)
            end

            ElementsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionHeight)
            updateSectionHeight()

            local function addElement(config, elementConstructor)
                local wrapper = Instance.new("Frame")
                wrapper.Name = config.Name or "Element"
                wrapper.Size = UDim2.new(1,0,0,40)
                wrapper.BackgroundColor3 = ThemeManager.Current.ElementBg
                wrapper.BorderSizePixel = 0
                Instance.new("UICorner", wrapper).CornerRadius = UDim.new(0,8)
                wrapper.Parent = ElementsFrame

                local shadow = Utility.CreateShadow(wrapper, UDim2.new(1,0,1,0), 2, 0.9)
                shadow.ZIndex = wrapper.ZIndex - 1
                local stroke = Instance.new("UIStroke")
                stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                stroke.Color = ThemeManager.Current.ElementStroke
                stroke.Thickness = 1.5
                stroke.Parent = wrapper

                -- tooltip
                if config.Description then
                    local tooltip
                    local function showTooltip()
                        if tooltip then tooltip:Destroy() end
                        tooltip = Instance.new("Frame")
                        tooltip.Size = UDim2.new(0,0,0,0)
                        tooltip.BackgroundColor3 = ThemeManager.Current.NotificationBg
                        tooltip.BorderSizePixel = 0
                        Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0,6)
                        local ttLabel = Instance.new("TextLabel")
                        ttLabel.BackgroundTransparency = 1
                        ttLabel.Text = config.Description
                        ttLabel.TextColor3 = ThemeManager.Current.NotificationText
                        ttLabel.Font = Enum.Font.Gotham
                        ttLabel.TextSize = 12
                        ttLabel.Parent = tooltip
                        ttLabel.Size = UDim2.new(1,0,1,0)
                        tooltip.Parent = Gui
                        local pos = Utility.GetMouseLocation()
                        tooltip.Position = UDim2.new(0, pos.X + 10, 0, pos.Y + 10)
                        local labelWidth = ttLabel.TextBounds.X + 20
                        TweenService:Create(tooltip, TweenInfo.new(0.2), {Size = UDim2.new(0, labelWidth, 0, 20)}):Play()
                    end
                    local function hideTooltip()
                        if tooltip then
                            tooltip:Destroy()
                            tooltip = nil
                        end
                    end
                    table.insert(connections, wrapper.MouseEnter:Connect(showTooltip))
                    table.insert(connections, wrapper.MouseLeave:Connect(hideTooltip))
                end

                local element = elementConstructor(wrapper, config, ThemeManager)
                element._wrapper = wrapper
                element._config = config

                table.insert(connections, wrapper.MouseEnter:Connect(function()
                    TweenService:Create(wrapper, TweenInfo.new(0.15), {BackgroundColor3 = ThemeManager.Current.ElementHover}):Play()
                    stroke.Color = ThemeManager.Current.ElementStroke:Lerp(Color3.fromRGB(255,255,255), 0.2)
                end))
                table.insert(connections, wrapper.MouseLeave:Connect(function()
                    TweenService:Create(wrapper, TweenInfo.new(0.15), {BackgroundColor3 = ThemeManager.Current.ElementBg}):Play()
                    stroke.Color = ThemeManager.Current.ElementStroke
                end))
                table.insert(connections, wrapper.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        TweenService:Create(wrapper, TweenInfo.new(0.1), {Size = UDim2.new(1,-4,0,38)}):Play()
                    end
                end))
                table.insert(connections, wrapper.InputEnded:Connect(function(input)
                    TweenService:Create(wrapper, TweenInfo.new(0.2, Enum.EasingStyle.Elastic), {Size = UDim2.new(1,0,0,40)}):Play()
                end))

                updateSectionHeight()
                return element
            end

            -- Toggle
            function Section:AddToggle(config)
                local function constructor(parent, cfg, themeMgr)
                    local toggleFrame = Instance.new("Frame")
                    toggleFrame.Size = UDim2.new(0,44,0,24)
                    toggleFrame.Position = UDim2.new(1,-50,0.5,-12)
                    toggleFrame.BackgroundColor3 = cfg.Default and themeMgr.Current.IndicatorOn or themeMgr.Current.IndicatorOff
                    toggleFrame.BorderSizePixel = 0
                    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1,0)
                    toggleFrame.Parent = parent

                    local toggleKnob = Instance.new("Frame")
                    toggleKnob.Size = UDim2.new(0,18,0,18)
                    toggleKnob.Position = cfg.Default and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
                    toggleKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    toggleKnob.BorderSizePixel = 0
                    Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1,0)
                    toggleKnob.Parent = toggleFrame

                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1,-60,1,0)
                    label.Position = UDim2.new(0,10,0,0)
                    label.Text = cfg.Name
                    label.TextColor3 = themeMgr.Current.ElementText
                    label.Font = Enum.Font.Gotham
                    label.TextSize = 14
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Parent = parent

                    local state = cfg.Default
                    local flag = cfg.Flag
                    if flag and Flags[flag] ~= nil then
                        state = Flags[flag]
                    end
                    local function applyState()
                        if state then
                            toggleFrame.BackgroundColor3 = themeMgr.Current.IndicatorOn
                            toggleKnob:TweenPosition(UDim2.new(1,-21,0.5,-9), "Out", "Quad", 0.15)
                        else
                            toggleFrame.BackgroundColor3 = themeMgr.Current.IndicatorOff
                            toggleKnob:TweenPosition(UDim2.new(0,3,0.5,-9), "Out", "Quad", 0.15)
                        end
                    end
                    applyState()

                    local function set(val)
                        state = val
                        if flag then Flags[flag] = val end
                        if val then
                            TweenService:Create(toggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = themeMgr.Current.IndicatorOn}):Play()
                            TweenService:Create(toggleKnob, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1,-21,0.5,-9)}):Play()
                        else
                            TweenService:Create(toggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = themeMgr.Current.IndicatorOff}):Play()
                            TweenService:Create(toggleKnob, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0,3,0.5,-9)}):Play()
                        end
                        pcall(function() if cfg.Callback then cfg.Callback(val) end end)
                    end

                    table.insert(connections, toggleFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            set(not state)
                        end
                    end))

                    return {
                        SetValue = function(val) set(val) end,
                        GetValue = function() return state end,
                    }
                end
                return addElement(config, constructor)
            end

            -- Button
            function Section:AddButton(config)
                local function constructor(parent, cfg, themeMgr)
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1,-20,1,-10)
                    btn.Position = UDim2.new(0,10,0,5)
                    btn.BackgroundTransparency = 1
                    btn.Text = cfg.Name
                    btn.TextColor3 = themeMgr.Current.Accent
                    btn.Font = Enum.Font.GothamBold
                    btn.TextSize = 14
                    btn.Parent = parent
                    table.insert(connections, btn.MouseButton1Click:Connect(function()
                        Utility.Ripple(btn)
                        pcall(function() cfg.Callback() end)
                    end))
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

            -- Slider (drag)
            function Section:AddSlider(config)
                local function constructor(parent, cfg, themeMgr)
                    local sliderFrame = Instance.new("Frame")
                    sliderFrame.Size = UDim2.new(1,-40,1,0)
                    sliderFrame.BackgroundTransparency = 1
                    sliderFrame.Parent = parent

                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(0.4,0,1,0)
                    label.Text = cfg.Name
                    label.TextColor3 = themeMgr.Current.ElementText
                    label.Font = Enum.Font.Gotham
                    label.TextSize = 14
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Parent = sliderFrame

                    local valueLabel = Instance.new("TextLabel")
                    valueLabel.BackgroundTransparency = 1
                    valueLabel.Size = UDim2.new(0,60,1,0)
                    valueLabel.Position = UDim2.new(1,-60,0,0)
                    valueLabel.Text = ""
                    valueLabel.TextColor3 = themeMgr.Current.Accent
                    valueLabel.Font = Enum.Font.GothamBold
                    valueLabel.TextSize = 12
                    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                    valueLabel.Parent = sliderFrame

                    local track = Instance.new("Frame")
                    track.Size = UDim2.new(1,-80,0,6)
                    track.Position = UDim2.new(0,60,0.5,-3)
                    track.BackgroundColor3 = themeMgr.Current.SliderTrack
                    track.BorderSizePixel = 0
                    Instance.new("UICorner", track).CornerRadius = UDim.new(0,3)
                    track.Parent = sliderFrame

                    local fill = Instance.new("Frame")
                    fill.Size = UDim2.new(0,0,1,0)
                    fill.BackgroundColor3 = themeMgr.Current.SliderFill
                    fill.BorderSizePixel = 0
                    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,3)
                    fill.Parent = track

                    local thumb = Instance.new("Frame")
                    thumb.Size = UDim2.new(0,14,0,14)
                    thumb.Position = UDim2.new(0,0,0.5,-7)
                    thumb.BackgroundColor3 = themeMgr.Current.SliderThumb
                    thumb.BorderSizePixel = 0
                    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1,0)
                    local thumbStroke = Instance.new("UIStroke")
                    thumbStroke.Thickness = 2
                    thumbStroke.Color = themeMgr.Current.ElementStroke
                    thumbStroke.Parent = thumb
                    thumb.Parent = track

                    local hitbox = Instance.new("Frame")
                    hitbox.Size = UDim2.new(0,24,0,24)
                    hitbox.Position = UDim2.new(0,-5,0,-5)
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
                        fill.Size = UDim2.new(frac,0,1,0)
                        thumb.Position = UDim2.new(frac,-7,0.5,-7)
                        valueLabel.Text = (cfg.ValuePrefix or "") .. tostring(val) .. (cfg.ValueSuffix or "")
                    end
                    updateVisual(current)

                    local dragging = false
                    local inputObj = nil
                    local function setFromMouse(pos)
                        local relpos = pos.X - track.AbsolutePosition.X
                        local frac = math.clamp(relpos / track.AbsoluteSize.X, 0, 1)
                        local raw = min + frac * (max - min)
                        if step and step > 0 then
                            raw = math.round(raw / step) * step
                        end
                        raw = Utility.Clamp(raw, min, max)
                        if raw ~= current then
                            current = raw
                            updateVisual(current)
                            if flag then Flags[flag] = current end
                            pcall(function() cfg.Callback(current) end)
                        end
                    end

                    local function startDrag(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            inputObj = input
                            setFromMouse(input.Position)
                            input.Changed:Connect(function()
                                if input.UserInputState == Enum.UserInputState.End then
                                    dragging = false
                                    inputObj = nil
                                end
                            end)
                        end
                    end

                    table.insert(connections, hitbox.InputBegan:Connect(startDrag))
                    table.insert(connections, track.InputBegan:Connect(startDrag))
                    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
                        if dragging and inputObj and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            if input.UserInputType == Enum.UserInputType.Touch then
                                if input.UserInputState == Enum.UserInputState.Move and input == inputObj then
                                    setFromMouse(input.Position)
                                end
                            else
                                setFromMouse(input.Position)
                            end
                        end
                    end))
                    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
                        if input == inputObj then
                            dragging = false
                            inputObj = nil
                        end
                    end))

                    return {
                        SetValue = function(val) updateVisual(val) end,
                        GetValue = function() return current end,
                        SetLimits = function(newMin, newMax) min = newMin; max = newMax; updateVisual(current) end,
                    }
                end
                return addElement(config, constructor)
            end

            -- Dropdown
            function Section:AddDropdown(config)
                local function constructor(parent, cfg, themeMgr)
                    local mainBtn = Instance.new("TextButton")
                    mainBtn.Size = UDim2.new(1,-20,1,-10)
                    mainBtn.Position = UDim2.new(0,10,0,5)
                    mainBtn.BackgroundTransparency = 1
                    mainBtn.Text = cfg.Name .. ": " .. (cfg.Default or (cfg.MultiSelect and "" or (cfg.Options[1] or "")))
                    mainBtn.TextColor3 = themeMgr.Current.ElementText
                    mainBtn.Font = Enum.Font.Gotham
                    mainBtn.TextSize = 14
                    mainBtn.TextXAlignment = Enum.TextXAlignment.Left
                    mainBtn.Parent = parent

                    local chevron = Instance.new("TextLabel")
                    chevron.BackgroundTransparency = 1
                    chevron.Size = UDim2.new(0,20,1,0)
                    chevron.Position = UDim2.new(1,-20,0,0)
                    chevron.Text = "▼"
                    chevron.TextColor3 = themeMgr.Current.Accent
                    chevron.Font = Enum.Font.GothamBold
                    chevron.TextSize = 16
                    chevron.Parent = mainBtn

                    local dropdown = Instance.new("Frame")
                    dropdown.Name = "DropdownList"
                    dropdown.Size = UDim2.new(1,0,0,0)
                    dropdown.Position = UDim2.new(0,0,1,0)
                    dropdown.BackgroundColor3 = themeMgr.Current.DropdownBg
                    dropdown.BorderSizePixel = 0
                    dropdown.ClipsDescendants = true
                    dropdown.ZIndex = 10
                    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,6)
                    dropdown.Parent = parent

                    local list = Instance.new("ScrollingFrame")
                    list.Size = UDim2.new(1,-4,1,-4)
                    list.Position = UDim2.new(0,2,0,2)
                    list.BackgroundTransparency = 1
                    list.ScrollBarThickness = 3
                    list.CanvasSize = UDim2.new(0,0,0,0)
                    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    list.Parent = dropdown
                    local listLayout = Instance.new("UIListLayout")
                    listLayout.Parent = list

                    local options = cfg.Options or {}
                    local selected = {}
                    if cfg.MultiSelect then
                        if cfg.Default and type(cfg.Default) == "table" then
                            selected = cfg.Default
                        else
                            selected = {}
                        end
                    else
                        selected = cfg.Default or (options[1] and options[1] or "")
                    end
                    local isMulti = cfg.MultiSelect or false
                    local isSearchable = cfg.Searchable or false

                    local searchBox
                    if isSearchable then
                        searchBox = Instance.new("TextBox")
                        searchBox.Size = UDim2.new(1,-10,0,25)
                        searchBox.Position = UDim2.new(0,5,0,5)
                        searchBox.BackgroundColor3 = themeMgr.Current.ElementBg
                        searchBox.Text = ""
                        searchBox.PlaceholderText = "Search..."
                        searchBox.TextColor3 = themeMgr.Current.ElementText
                        searchBox.Font = Enum.Font.Gotham
                        searchBox.TextSize = 13
                        searchBox.BorderSizePixel = 0
                        Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,4)
                        searchBox.Parent = dropdown
                        table.insert(connections, searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                            rebuildOptions(searchBox.Text)
                        end))
                    end

                    local function rebuildOptions(filter)
                        filter = filter and filter:lower() or nil
                        for _, child in ipairs(list:GetChildren()) do
                            if child:IsA("Frame") then child:Destroy() end
                        end
                        for _, opt in ipairs(options) do
                            if filter and not opt:lower():find(filter) then continue end
                            local optFrame = Instance.new("TextButton")
                            optFrame.Size = UDim2.new(1,0,0,25)
                            optFrame.BackgroundTransparency = 1
                            optFrame.Text = ""
                            optFrame.BorderSizePixel = 0
                            optFrame.Parent = list

                            local optLabel = Instance.new("TextLabel")
                            optLabel.BackgroundTransparency = 1
                            optLabel.Size = UDim2.new(1,-30,1,0)
                            optLabel.Position = UDim2.new(0,5,0,0)
                            optLabel.Text = opt
                            optLabel.TextColor3 = themeMgr.Current.ElementText
                            optLabel.Font = Enum.Font.Gotham
                            optLabel.TextSize = 13
                            optLabel.TextXAlignment = Enum.TextXAlignment.Left
                            optLabel.Parent = optFrame

                            local selectedMark
                            if isMulti then
                                selectedMark = Instance.new("Frame")
                                selectedMark.Size = UDim2.new(0,16,0,16)
                                selectedMark.Position = UDim2.new(1,-20,0.5,-8)
                                selectedMark.BackgroundColor3 = table.find(selected, opt) and themeMgr.Current.IndicatorOn or themeMgr.Current.IndicatorOff
                                selectedMark.BorderSizePixel = 0
                                Instance.new("UICorner", selectedMark).CornerRadius = UDim.new(0,3)
                                selectedMark.Parent = optFrame
                            end

                            optFrame.MouseButton1Click:Connect(function()
                                if isMulti then
                                    local idx = table.find(selected, opt)
                                    if idx then
                                        table.remove(selected, idx)
                                    else
                                        table.insert(selected, opt)
                                    end
                                    mainBtn.Text = cfg.Name .. ": " .. table.concat(selected, ", ")
                                    if selectedMark then
                                        selectedMark.BackgroundColor3 = table.find(selected, opt) and themeMgr.Current.IndicatorOn or themeMgr.Current.IndicatorOff
                                    end
                                    pcall(function() cfg.Callback(selected) end)
                                else
                                    selected = opt
                                    mainBtn.Text = cfg.Name .. ": " .. opt
                                    dropdown:TweenSize(UDim2.new(1,0,0,0), "In", "Quad", 0.2, true)
                                    pcall(function() cfg.Callback(selected) end)
                                end
                            end)
                            optFrame.MouseEnter:Connect(function() optFrame.BackgroundColor3 = themeMgr.Current.DropdownHover end)
                            optFrame.MouseLeave:Connect(function() optFrame.BackgroundTransparency = 1 end)
                        end
                        list.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y)
                    end
                    rebuildOptions()

                    local expanded = false
                    local function toggleDropdown()
                        if expanded then
                            dropdown:TweenSize(UDim2.new(1,0,0,0), "In", "Quad", 0.2, true)
                            chevron.Text = "▼"
                        else
                            local listHeight = math.min(200, listLayout.AbsoluteContentSize.Y + (isSearchable and 30 or 0) + 10)
                            dropdown:TweenSize(UDim2.new(1,0,0,listHeight), "Out", "Back", 0.3)
                            chevron.Text = "▲"
                        end
                        expanded = not expanded
                    end
                    table.insert(connections, mainBtn.MouseButton1Click:Connect(toggleDropdown))

                    local closeConnection
                    closeConnection = UserInputService.InputBegan:Connect(function(input)
                        if expanded and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                            local pos = input.Position
                            local absPos = parent.AbsolutePosition + Vector2.new(mainBtn.Position.X.Scale * parent.AbsoluteSize.X, mainBtn.Position.Y.Scale * parent.AbsoluteSize.Y)
                            local absSize = mainBtn.AbsoluteSize
                            local inMain = pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
                            local dropAbsPos = dropdown.AbsolutePosition
                            local dropAbsSize = dropdown.AbsoluteSize
                            local inDrop = pos.X >= dropAbsPos.X and pos.X <= dropAbsPos.X + dropAbsSize.X and pos.Y >= dropAbsPos.Y and pos.Y <= dropAbsPos.Y + dropAbsSize.Y
                            if not inMain and not inDrop then
                                toggleDropdown()
                            end
                        end
                    end)
                    table.insert(connections, closeConnection)

                    return {
                        UpdateOptions = function(newOpts) options = newOpts; rebuildOptions(searchBox and searchBox.Text) end,
                        SetValue = function(val) selected = val; mainBtn.Text = cfg.Name .. ": " .. (isMulti and table.concat(val,", ") or val) end,
                        GetValue = function() return selected end,
                    }
                end
                return addElement(config, constructor)
            end

            -- ColorPicker (simple)
            function Section:AddColorPicker(config)
                local function constructor(parent, cfg, themeMgr)
                    local swatch = Instance.new("Frame")
                    swatch.Size = UDim2.new(0,30,0,30)
                    swatch.Position = UDim2.new(1,-40,0.5,-15)
                    swatch.BackgroundColor3 = cfg.Default or Color3.fromRGB(255,255,255)
                    swatch.BorderSizePixel = 0
                    Instance.new("UICorner", swatch).CornerRadius = UDim.new(0,6)
                    swatch.Parent = parent

                    local label = Instance.new("TextLabel")
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1,-80,1,0)
                    label.Text = cfg.Name
                    label.TextColor3 = themeMgr.Current.ElementText
                    label.Font = Enum.Font.Gotham
                    label.TextSize = 14
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Parent = parent

                    local popup = Instance.new("Frame")
                    popup.Size = UDim2.new(0,200,0,0)
                    popup.Position = UDim2.new(1,-210,1,-5)
                    popup.BackgroundColor3 = themeMgr.Current.DropdownBg
                    popup.BorderSizePixel = 0
                    popup.ClipsDescendants = true
                    popup.ZIndex = 15
                    Instance.new("UICorner", popup).CornerRadius = UDim.new(0,8)
                    popup.Parent = parent

                    local popupVisible = false
                    local function togglePopup()
                        if popupVisible then
                            popup:TweenSize(UDim2.new(0,200,0,0), "In", "Quad", 0.2)
                        else
                            popup:TweenSize(UDim2.new(0,200,0,130), "Out", "Back", 0.3)
                            if #popup:GetChildren() <= 1 then
                                -- Hex input
                                local hexInput = Instance.new("TextBox")
                                hexInput.Size = UDim2.new(1,-10,0,25)
                                hexInput.Position = UDim2.new(0,5,0,100)
                                hexInput.PlaceholderText = "#FFFFFF"
                                hexInput.Text = "#" .. (cfg.Default and Color3.toHex(cfg.Default) or "FFFFFF")
                                hexInput.Parent = popup
                                table.insert(connections, hexInput.FocusLost:Connect(function()
                                    local col = Color3.fromHex(hexInput.Text)
                                    if col then
                                        swatch.BackgroundColor3 = col
                                        pcall(function() cfg.Callback(col) end)
                                    end
                                end))
                            end
                        end
                        popupVisible = not popupVisible
                    end

                    table.insert(connections, swatch.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            togglePopup()
                        end
                    end))

                    return {
                        SetColor = function(col) swatch.BackgroundColor3 = col end,
                        GetColor = function() return swatch.BackgroundColor3 end,
                    }
                end
                return addElement(config, constructor)
            end

            -- Bind
            function Section:AddBind(config)
                local function constructor(parent, cfg, themeMgr)
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1,-20,1,-10)
                    btn.Position = UDim2.new(0,10,0,5)
                    btn.BackgroundTransparency = 1
                    btn.Text = cfg.Name .. ": " .. (cfg.Default and (type(cfg.Default)=="EnumItem" and cfg.Default.Name or tostring(cfg.Default)) or "None")
                    btn.TextColor3 = themeMgr.Current.ElementText
                    btn.Font = Enum.Font.Gotham
                    btn.TextSize = 14
                    btn.TextXAlignment = Enum.TextXAlignment.Left
                    btn.Parent = parent

                    local listening = false
                    local currentBind = cfg.Default
                    local function startListening()
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
                        table.insert(connections, conn)
                    end
                    table.insert(connections, btn.MouseButton1Click:Connect(startListening))
                    return {
                        SetBind = function(bind) currentBind = bind; btn.Text = cfg.Name .. ": " .. (type(bind)=="EnumItem" and bind.Name or tostring(bind)) end,
                        GetBind = function() return currentBind end,
                        Fire = function() pcall(cfg.Callback, currentBind) end,
                    }
                end
                return addElement(config, constructor)
            end

            -- Textbox
            function Section:AddTextbox(config)
                local function constructor(parent, cfg, themeMgr)
                    local box = Instance.new("TextBox")
                    box.Size = UDim2.new(1,-20,0,30)
                    box.Position = UDim2.new(0,10,0.5,-15)
                    box.BackgroundColor3 = themeMgr.Current.ElementBg
                    box.BorderSizePixel = 0
                    box.Text = cfg.Default or ""
                    box.PlaceholderText = cfg.Placeholder or ""
                    box.TextColor3 = themeMgr.Current.ElementText
                    box.PlaceholderColor3 = themeMgr.Current.ElementText:Lerp(Color3.fromRGB(255,255,255), 0.5)
                    box.Font = Enum.Font.Gotham
                    box.TextSize = 14
                    box.ClearTextOnFocus = false
                    Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)
                    box.Parent = parent
                    if cfg.MultiLine then
                        box.TextWrapped = true
                        box.TextYAlignment = Enum.TextYAlignment.Top
                    end
                    table.insert(connections, box.FocusLost:Connect(function(enterPressed)
                        pcall(function() cfg.Callback(box.Text) end)
                    end))
                    return {
                        GetText = function() return box.Text end,
                        SetText = function(t) box.Text = t end,
                    }
                end
                return addElement(config, constructor)
            end

            function Section:AddLabel(text)
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1,0,0,20)
                lbl.BackgroundTransparency = 1
                lbl.Text = text
                lbl.TextColor3 = ThemeManager.Current.ElementText
                lbl.Font = Enum.Font.Gotham
                lbl.TextSize = 14
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = ElementsFrame
                updateSectionHeight()
                return {}
            end

            function Section:AddParagraph(title, body)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1,0,0,50)
                frame.BackgroundTransparency = 1
                frame.BorderSizePixel = 0
                frame.Parent = ElementsFrame
                local tlabel = Instance.new("TextLabel")
                tlabel.Size = UDim2.new(1,0,0,20)
                tlabel.BackgroundTransparency = 1
                tlabel.Text = title
                tlabel.Font = Enum.Font.GothamBold
                tlabel.TextColor3 = ThemeManager.Current.Accent
                tlabel.TextSize = 14
                tlabel.TextXAlignment = Enum.TextXAlignment.Left
                tlabel.Parent = frame
                local blabel = Instance.new("TextLabel")
                blabel.Size = UDim2.new(1,0,0,30)
                blabel.Position = UDim2.new(0,0,0,22)
                blabel.BackgroundTransparency = 1
                blabel.Text = body
                blabel.TextColor3 = ThemeManager.Current.ElementText
                blabel.Font = Enum.Font.Gotham
                blabel.TextSize = 13
                blabel.TextWrapped = true
                blabel.TextXAlignment = Enum.TextXAlignment.Left
                blabel.Parent = frame
                updateSectionHeight()
                return {}
            end

            function Section:AddSeparator()
                local sep = Instance.new("Frame")
                sep.Size = UDim2.new(1,0,0,1)
                sep.BackgroundColor3 = ThemeManager.Current.ElementStroke
                sep.BorderSizePixel = 0
                sep.Parent = ElementsFrame
                updateSectionHeight()
                return {}
            end

            return Section
        end

        return Tab
    end

    function Window:SetTheme(newTheme)
        ThemeManager.SetTheme(newTheme)
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
        notif.Size = UDim2.new(1,0,0,60)
        notif.BackgroundColor3 = ThemeManager.Current.NotificationBg
        notif.BorderSizePixel = 0
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0,8)
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1,-10,0,20)
        titleLabel.Position = UDim2.new(0,5,0,5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = data.Title or "Notification"
        titleLabel.TextColor3 = ThemeManager.Current.Accent
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notif
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1,-10,0,30)
        descLabel.Position = UDim2.new(0,5,0,25)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = data.Content or ""
        descLabel.TextColor3 = ThemeManager.Current.NotificationText
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        descLabel.Parent = notif
        notif.Parent = NotifHolder

        notif.Position = UDim2.new(1,0,0,-60)
        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0,0,0,0)}):Play()
        task.delay(data.Duration or 5, function()
            if notif and notif.Parent then
                TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1,0,0,-60)}):Play()
                task.wait(0.3)
                if notif then notif:Destroy() end
            end
        end)
    end

    -- Entrance animation
    Main.BackgroundTransparency = 1
    Main.Size = UDim2.new(0,0,0,0)
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {BackgroundTransparency = 0, Size = config.Size or UDim2.new(0,600,0,450)}):Play()

    local function cleanup()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        Gui:Destroy()
    end
    table.insert(connections, CloseButton.MouseButton1Click:Connect(cleanup))

    return Window
end

-- ============== GLOBAL THEME SETTER ==============
function ClavisLib:SetGlobalTheme(theme)
    ThemeManager.SetTheme(theme)
end

-- ============== AUTO-LOAD FROM CONFIG ==============
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
