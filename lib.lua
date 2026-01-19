local lib = {}

local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AcidUILib"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local blurFrame = Instance.new("Frame")
blurFrame.Size = UDim2.new(1, 0, 1, 0)
blurFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blurFrame.BackgroundTransparency = 1
blurFrame.Parent = screenGui

local gradientFrame = Instance.new("Frame")
gradientFrame.Size = UDim2.new(1, 0, 1, 0)
gradientFrame.BackgroundColor3 = Color3.new(0, 0, 0)
gradientFrame.BackgroundTransparency = 1
gradientFrame.Parent = screenGui
local gradient = Instance.new("UIGradient")
gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.67, 1), NumberSequenceKeypoint.new(1, 0.5)})
gradient.Parent = gradientFrame

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(60, 60, 60)

local openTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local openTween = tweenService:Create(mainFrame, openTweenInfo, {Size = UDim2.new(0, 600, 0, 400)})
local closeTween = tweenService:Create(mainFrame, openTweenInfo, {Size = UDim2.new(0, 0, 0, 0)})

local menuKey = Enum.KeyCode.RightControl
userInputService.InputBegan:Connect(function(input)
	if input.KeyCode == menuKey then
		mainFrame.Visible = not mainFrame.Visible
		if mainFrame.Visible then
			blurFrame.BackgroundTransparency = 0.7
			tweenService:Create(blurFrame, openTweenInfo, {BackgroundTransparency = 0.5}):Play()
			openTween:Play()
		else
			closeTween:Play()
			tweenService:Create(blurFrame, openTweenInfo, {BackgroundTransparency = 1}):Play()
		end
	end
end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame
Instance.new("UIListLayout", tabBar).FillDirection = Enum.FillDirection.Horizontal

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.Parent = mainFrame

local currentContent = nil
local accent1 = Color3.fromRGB(100, 180, 255)
local accent2 = Color3.fromRGB(0, 255, 255)

local arrayListFrame = Instance.new("Frame")
arrayListFrame.Size = UDim2.new(0, 220, 1, 0)
arrayListFrame.Position = UDim2.new(1, -230, 0, 0)
arrayListFrame.BackgroundTransparency = 0.25
arrayListFrame.Visible = false
arrayListFrame.Parent = screenGui
Instance.new("UICorner", arrayListFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", arrayListFrame).Color = accent1
Instance.new("UIStroke", arrayListFrame).Transparency = 0.4
Instance.new("UIListLayout", arrayListFrame).SortOrder = Enum.SortOrder.LayoutOrder

local arrayListEnabledToggles = {}

function lib.addTab(name)
	local tabButton = Instance.new("TextButton")
	tabButton.Size = UDim2.new(0, 120, 1, 0)
	tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	tabButton.Text = name
	tabButton.TextColor3 = Color3.new(1, 1, 1)
	tabButton.Parent = tabBar

	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.ScrollBarThickness = 4
	tabContent.Visible = false
	tabContent.Parent = contentFrame

	tabButton.MouseButton1Click:Connect(function()
		if currentContent then currentContent.Visible = false end
		tabContent.Visible = true
		currentContent = tabContent
	end)

	local tab = {content = tabContent}

	function tab.addToggle(name, default, callback)
		local state = default or false
		local toggleFrame = Instance.new("Frame")
		toggleFrame.Size = UDim2.new(1, 0, 0, 35)
		toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		toggleFrame.Parent = tabContent
		Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -50, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = toggleFrame

		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0, 24, 0, 24)
		knob.Position = UDim2.new(1, -32, 0.5, -12)
		knob.AnchorPoint = Vector2.new(1, 0.5)
		knob.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		knob.Parent = toggleFrame
		Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 12)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = accent1
		fill.Parent = knob
		Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 12)

		local subFrame = Instance.new("Frame")
		subFrame.Size = UDim2.new(1, 0, 0, 0)
		subFrame.BackgroundTransparency = 1
		subFrame.Visible = false
		subFrame.Parent = tabContent
		Instance.new("UIListLayout", subFrame)

		local toggleObj = {
			state = state,
			addSlider = function(self, n, def, mn, mx, cb)
				local sliderFrame = Instance.new("Frame")
				sliderFrame.Size = UDim2.new(1, 0, 0, 30)
				sliderFrame.BackgroundTransparency = 1
				sliderFrame.Parent = subFrame
				-- full slider implementation omitted for brevity (bar + draggable knob + value label + tween on change)
				local sObj = {value = def or mn, callback = cb}
				return sObj
			end,
			addColorpicker = function(self, n, def, cb)
				local cpFrame = Instance.new("Frame")
				cpFrame.Size = UDim2.new(1, 0, 0, 30)
				cpFrame.BackgroundTransparency = 1
				cpFrame.Parent = subFrame
				-- full color picker (preview + RGB sliders or wheel) omitted for brevity
				local cObj = {color = def or Color3.new(1, 1, 1), callback = cb}
				return cObj
			end,
			addSubToggle = function(self, n, def, cb)
				local subState = def or false
				local subToggleFrame = Instance.new("Frame")
				subToggleFrame.Size = UDim2.new(1, 0, 0, 28)
				subToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				subToggleFrame.Parent = subFrame
				-- similar knob + fill as main toggle but smaller
				local subObj = {state = subState, callback = cb}
				return subObj
			end
		}

		local function updateState()
			if state then
				tweenService:Create(fill, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 1, 0)}):Play()
				table.insert(arrayListEnabledToggles, {name = name, length = #name})
			else
				tweenService:Create(fill, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 1, 0)}):Play()
				for i, t in ipairs(arrayListEnabledToggles) do
					if t.name == name then table.remove(arrayListEnabledToggles, i) break end
				end
			end
			callback(state)
			table.sort(arrayListEnabledToggles, function(a, b) return a.length > b.length end)
			-- rebuild arrayListFrame children from arrayListEnabledToggles
		end
		updateState()

		toggleFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				state = not state
				updateState()
			elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
				toggleObj.expanded = not toggleObj.expanded
				subFrame.Visible = toggleObj.expanded
				subFrame.Size = toggleObj.expanded and UDim2.new(1, 0, 0, #toggleObj.subElements * 32) or UDim2.new(1, 0, 0, 0)
			end
		end)

		return toggleObj
	end

	return tab
end

function lib.buildThemeSettings(tab)
	tab.addToggle("ClickGUI", true, function(v) mainFrame.Visible = v end)
	tab.addToggle("ArrayList", false, function(v) arrayListFrame.Visible = v end)
	local t1 = tab.addToggle("Accent 1", false, function() end)
	t1.addColorpicker("Color", accent1, function(c) accent1 = c end)
	local t2 = tab.addToggle("Accent 2", false, function() end)
	t2.addColorpicker("Color", accent2, function(c) accent2 = c end)
end

function lib.buildKeybindSettings(tab)
	-- todo keybind picker UI
end

function lib.notify(name, content, duration)
	local nf = Instance.new("Frame")
	nf.Size = UDim2.new(0, 280, 0, 70)
	nf.Position = UDim2.new(1, -290, 1, -80)
	nf.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	nf.BackgroundTransparency = 0.3
	nf.Parent = screenGui
	Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", nf).Color = accent1

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.new(1, 1, 1)
	fill.Parent = nf
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(accent1, accent2)
	g.Parent = fill

	-- name & content labels

	tweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()
	task.delay(duration, function()
		tweenService:Create(nf, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
		task.delay(0.6, function() nf:Destroy() end)
	end)
end

return lib
