--[[
MIT License

Copyright (c) 2024 Xerkol

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local ClavisLib = {}
ClavisLib.__index = ClavisLib

function ClavisLib.new(title)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	screenGui.Name = "ClavisLib"
	screenGui.ResetOnSpawn = false

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 450, 0, 380)
	main.Position = UDim2.new(0.5, -225, 0.5, -190)
	main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	main.BorderSizePixel = 0
	main.Active = true
	main.Draggable = true
	main.Parent = screenGui
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 8)
	mainCorner.Parent = main

	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 36)
	titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = main

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0, 200, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	titleLabel.TextSize = 18
	titleLabel.Font = Enum.Font.SourceSansBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titleBar
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 28, 0, 22)
	closeBtn.Position = UDim2.new(1, -34, 0, 7)
	closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	closeBtn.TextSize = 16
	closeBtn.Font = Enum.Font.SourceSansBold
	closeBtn.Parent = titleBar
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 4)
	closeCorner.Parent = closeBtn

	local tabContainer = Instance.new("Frame")
	tabContainer.Size = UDim2.new(1, -12, 0, 40)
	tabContainer.Position = UDim2.new(0, 6, 0, 42)
	tabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	tabContainer.BorderSizePixel = 0
	tabContainer.Parent = main
	local tabContainerCorner = Instance.new("UICorner")
	tabContainerCorner.CornerRadius = UDim.new(0, 8)
	tabContainerCorner.Parent = tabContainer

	local tabList = Instance.new("UIListLayout")
	tabList.FillDirection = Enum.FillDirection.Horizontal
	tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabList.VerticalAlignment = Enum.VerticalAlignment.Center
	tabList.Padding = UDim.new(0, 4)
	tabList.Parent = tabContainer

	local contentArea = Instance.new("Frame")
	contentArea.Size = UDim2.new(1, -12, 1, -88)
	contentArea.Position = UDim2.new(0, 6, 0, 86)
	contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	contentArea.BorderSizePixel = 0
	contentArea.Parent = main
	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 8)
	contentCorner.Parent = contentArea
	
	closeBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)

	local lib = {
		ScreenGui = screenGui,
		Main = main,
		TabContainer = tabContainer,
		Content = contentArea,
		Tabs = {},
		ActiveTab = nil
	}
	setmetatable(lib, ClavisLib)
	return lib
end

function ClavisLib:CreateTab(name)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 90, 0, 30)
	tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tabBtn.BorderSizePixel = 0
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	tabBtn.TextSize = 14
	tabBtn.Font = Enum.Font.SourceSans
	tabBtn.Parent = self.TabContainer
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 14)
	btnCorner.Parent = tabBtn

	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	tabContent.BorderSizePixel = 0
	tabContent.Visible = false
	tabContent.ScrollBarThickness = 4
	tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.Parent = self.Content

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = tabContent

	local tab = {
		Button = tabBtn,
		Content = tabContent,
		Layout = layout
	}
	table.insert(self.Tabs, tab)

	tabBtn.MouseButton1Click:Connect(function()
		if self.ActiveTab then
			self.ActiveTab.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			self.ActiveTab.Content.Visible = false
		end
		tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		tabContent.Visible = true
		self.ActiveTab = tab
		tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)

	if not self.ActiveTab then
		tabBtn.MouseButton1Click:Fire()
	end

	return tab
end

function ClavisLib:AddSection(tab, name)
	local section = Instance.new("Frame")
	section.Size = UDim2.new(1, -12, 0, 28)
	section.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	section.BorderSizePixel = 0
	section.Parent = tab.Content
	local sectionCorner = Instance.new("UICorner")
	sectionCorner.CornerRadius = UDim.new(0, 4)
	sectionCorner.Parent = section
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(60, 60, 60)
	stroke.Thickness = 1
	stroke.Parent = section

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextSize = 15
	label.Font = Enum.Font.SourceSansBold
	label.Parent = section

	return section
end

function ClavisLib:AddButton(tab, name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -12, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.TextSize = 14
	btn.Font = Enum.Font.SourceSans
	btn.Parent = tab.Content
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = btn
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70, 70, 70)
	stroke.Thickness = 1
	stroke.Parent = btn

	btn.MouseButton1Click:Connect(callback)
	return btn
end

function ClavisLib:AddToggle(tab, name, default, callback)
	local state = default or false
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -12, 0, 32)
	btn.BackgroundColor3 = state and Color3.fromRGB(80, 140, 80) or Color3.fromRGB(45, 45, 45)
	btn.BorderSizePixel = 0
	btn.Text = name .. (state and " [ON]" or " [OFF]")
	btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
	btn.TextSize = 14
	btn.Font = Enum.Font.SourceSans
	btn.Parent = tab.Content
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = btn
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70, 70, 70)
	stroke.Thickness = 1
	stroke.Parent = btn

	local function update()
		state = not state
		btn.Text = name .. (state and " [ON]" or " [OFF]")
		btn.BackgroundColor3 = state and Color3.fromRGB(80, 140, 80) or Color3.fromRGB(45, 45, 45)
		btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
		callback(state)
	end

	btn.MouseButton1Click:Connect(update)
	return btn
end

function ClavisLib:AddSlider(tab, name, min, max, default, callback)
	local current = default or min
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -12, 0, 32)
	frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	frame.BorderSizePixel = 0
	frame.Parent = tab.Content
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 4)
	frameCorner.Parent = frame
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70, 70, 70)
	stroke.Thickness = 1
	stroke.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 100, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextSize = 13
	label.Font = Enum.Font.SourceSans
	label.Parent = frame

	local decBtn = Instance.new("TextButton")
	decBtn.Size = UDim2.new(0, 26, 0, 22)
	decBtn.Position = UDim2.new(1, -100, 0, 5)
	decBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	decBtn.BorderSizePixel = 0
	decBtn.Text = "-"
	decBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	decBtn.TextSize = 16
	decBtn.Font = Enum.Font.SourceSansBold
	decBtn.Parent = frame
	local decCorner = Instance.new("UICorner")
	decCorner.CornerRadius = UDim.new(0, 4)
	decCorner.Parent = decBtn

	local valLabel = Instance.new("TextLabel")
	valLabel.Size = UDim2.new(0, 36, 0, 22)
	valLabel.Position = UDim2.new(1, -69, 0, 5)
	valLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	valLabel.BorderSizePixel = 0
	valLabel.Text = tostring(current)
	valLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	valLabel.TextSize = 13
	valLabel.Font = Enum.Font.SourceSans
	valLabel.Parent = frame
	local valCorner = Instance.new("UICorner")
	valCorner.CornerRadius = UDim.new(0, 4)
	valCorner.Parent = valLabel

	local incBtn = Instance.new("TextButton")
	incBtn.Size = UDim2.new(0, 26, 0, 22)
	incBtn.Position = UDim2.new(1, -28, 0, 5)
	incBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	incBtn.BorderSizePixel = 0
	incBtn.Text = "+"
	incBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	incBtn.TextSize = 16
	incBtn.Font = Enum.Font.SourceSansBold
	incBtn.Parent = frame
	local incCorner = Instance.new("UICorner")
	incCorner.CornerRadius = UDim.new(0, 4)
	incCorner.Parent = incBtn

	local function updateValue(delta)
		current = current + delta
		if current < min then current = min end
		if current > max then current = max end
		valLabel.Text = tostring(current)
		callback(current)
	end

	decBtn.MouseButton1Click:Connect(function()
		updateValue(-1)
	end)
	incBtn.MouseButton1Click:Connect(function()
		updateValue(1)
	end)

	return frame
end

return ClavisLib
