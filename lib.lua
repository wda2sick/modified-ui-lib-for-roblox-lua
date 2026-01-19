local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LibraryUI = Instance.new("ScreenGui")

local Holder = Instance.new("Frame")
local TabLayout = Instance.new("UIListLayout")

local Library = {
    Colors = {
        Body = Color3.fromRGB(35, 35, 35);
        Button = Color3.fromRGB(45, 45, 45);
        ColorPickerMarker = Color3.fromRGB(150, 150, 150);
        SliderBackground = Color3.fromRGB(50, 50, 50);
        Slider = Color3.fromRGB(255, 255, 255);
        Dropdown = Color3.fromRGB(45, 45, 45);
        DropdownButton = Color3.fromRGB(35, 35, 35);
        DropdownButtonHover = Color3.fromRGB(45, 45, 45);
        Underline = Color3.fromRGB(255, 255, 255);
        Border = Color3.fromRGB(0, 0, 0);
        Text = Color3.fromRGB(255, 255, 255);
        PlaceholderText = Color3.fromRGB(255, 255, 255);
        ToggleGradientStart = Color3.fromRGB(0, 255, 255);
        ToggleGradientEnd = Color3.fromRGB(135, 206, 250);
    };

    Settings = {
        MainTextSize = 15;
        MainTweenTime = 1;
        RippleTweenTime = 1;
        ToggleTweenTime = 0.5;
        ColorPickerTweenTime = 0.5;
        DropdownTweenTime = 0.5;
        DropdownButtonColorHoverTweenTime = 0.5;
        MainTextFont = Enum.Font.SourceSans;
        UIToggleKey = Enum.KeyCode.RightControl;
        TweenEasingStyle = Enum.EasingStyle.Quart;
    }
}

LibraryUI.Name = "LibraryUI"
LibraryUI.Parent = game:GetService("CoreGui")
LibraryUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Holder.Name = "Holder"
Holder.Parent = LibraryUI
Holder.BackgroundColor3 = Color3.new(0, 0, 0)
Holder.BackgroundTransparency = 1
Holder.BorderColor3 = Color3.new(0, 0, 0)
Holder.BorderSizePixel = 0
Holder.Size = UDim2.new(1, 0, 1, 0)

TabLayout.Name = "TabLayout"
TabLayout.Parent = Holder
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 10)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Library.Settings.UIToggleKey then
        LibraryUI.Enabled = not LibraryUI.Enabled
    end
end)

local function AddDragFunctionality(frame)
    local dragging = false
    local dragStart = nil
    local frameStart = nil

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = UserInputService:GetMouseLocation()
            frameStart = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local currentMouse = UserInputService:GetMouseLocation()
            local delta = currentMouse - dragStart
            frame.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
end

function Library:CreateTab(tabtitle, tabdescription)
    local TabContainer = Instance.new("Frame")
    local TabTitleBar = Instance.new("Frame")
    local TabTitleText = Instance.new("TextLabel")
    local TabContentFrame = Instance.new("Frame")
    local BodyLayout = Instance.new("UIListLayout")

    local BodyYSize = 0
    local toggles = {}

    TabContainer.Name = (tabtitle .. "TabContainer")
    TabContainer.Parent = Holder
    TabContainer.BackgroundColor3 = Color3.new(0, 0, 0)
    TabContainer.BackgroundTransparency = 0.3
    TabContainer.BorderSizePixel = 0
    TabContainer.Size = UDim2.new(0, 250, 0, 50)
    TabContainer.Position = UDim2.new(0.05, 0, 0.05, 0)
    TabContainer.LayoutOrder = 1
    TabContainer.ZIndex = 10

    local ContainerBlur = Instance.new("BlurEffect")
    ContainerBlur.Parent = LibraryUI
    ContainerBlur.Size = 24
    ContainerBlur.Enabled = true

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.Parent = TabContainer
    ContainerCorner.CornerRadius = UDim.new(0, 8)

    local ContainerStroke = Instance.new("UIStroke")
    ContainerStroke.Parent = TabContainer
    ContainerStroke.Thickness = 1
    ContainerStroke.Color = Color3.fromRGB(0, 255, 255)
    ContainerStroke.Transparency = 0.5

    local GradientBg = Instance.new("UIGradient")
    GradientBg.Parent = TabContainer
    GradientBg.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Library.Colors.ToggleGradientStart),
        ColorSequenceKeypoint.new(1, Library.Colors.Body)
    }
    GradientBg.Rotation = 90

    TabTitleBar.Name = "TitleBar"
    TabTitleBar.Parent = TabContainer
    TabTitleBar.BackgroundColor3 = Library.Colors.Body
    TabTitleBar.BackgroundTransparency = 0
    TabTitleBar.BorderSizePixel = 0
    TabTitleBar.Size = UDim2.new(1, 0, 0, 35)
    TabTitleBar.ZIndex = 11

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.Parent = TabTitleBar
    TitleBarCorner.CornerRadius = UDim.new(0, 8)

    local TitleBarStroke = Instance.new("UIStroke")
    TitleBarStroke.Parent = TabTitleBar
    TitleBarStroke.Thickness = 1
    TitleBarStroke.Color = Color3.fromRGB(0, 255, 255)

    TabTitleText.Name = "TitleText"
    TabTitleText.Parent = TabTitleBar
    TabTitleText.BackgroundTransparency = 1
    TabTitleText.BorderSizePixel = 0
    TabTitleText.Position = UDim2.new(0.05, 0, 0, 0)
    TabTitleText.Size = UDim2.new(0.9, 0, 1, 0)
    TabTitleText.Font = Library.Settings.MainTextFont
    TabTitleText.Text = tabtitle
    TabTitleText.TextColor3 = Library.Colors.Text
    TabTitleText.TextSize = Library.Settings.MainTextSize
    TabTitleText.TextXAlignment = Enum.TextXAlignment.Left
    TabTitleText.TextYAlignment = Enum.TextYAlignment.Center
    TabTitleText.ZIndex = 11

    TabContentFrame.Name = "ContentFrame"
    TabContentFrame.Parent = TabContainer
    TabContentFrame.BackgroundTransparency = 1
    TabContentFrame.BorderSizePixel = 0
    TabContentFrame.Position = UDim2.new(0, 0, 0, 35)
    TabContentFrame.Size = UDim2.new(1, 0, 0, BodyYSize)
    TabContentFrame.ClipsDescendants = true

    BodyLayout.Name = "BodyLayout"
    BodyLayout.Parent = TabContentFrame
    BodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BodyLayout.Padding = UDim.new(0, 5)

    local function ExtendBodySize(value)
        BodyYSize = BodyYSize + value
        TweenService:Create(TabContentFrame, TweenInfo.new(0.5, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, BodyYSize)}):Play()
        TweenService:Create(TabContainer, TweenInfo.new(0.5, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 35 + BodyYSize)}):Play()
    end

    local function UnExtendBodySize(value)
        BodyYSize = BodyYSize - value
        TweenService:Create(TabContentFrame, TweenInfo.new(0.5, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, BodyYSize)}):Play()
        TweenService:Create(TabContainer, TweenInfo.new(0.5, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 35 + BodyYSize)}):Play()
    end

    TweenService:Create(TabContainer, TweenInfo.new(0.6, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()

    AddDragFunctionality(TabTitleBar)

    local CoastsLibrary = {}

    function CoastsLibrary:AddToggle(toggleConfig)
        local toggleName = toggleConfig[1]
        local toggleValue = toggleConfig[2]
        local callback = toggleConfig["Callback"]

        local ToggleHolder = Instance.new("Frame")
        local ToggleName = Instance.new("TextLabel")
        local ToggleButton = Instance.new("TextButton")
        local ToggleFill = Instance.new("Frame")
        local ToggleFillGradient = Instance.new("UIGradient")
        local ChildrenFrame = Instance.new("Frame")
        local ChildrenLayout = Instance.new("UIListLayout")

        local isEnabled = toggleValue or false

        ToggleHolder.Name = (toggleName .. "ToggleHolder")
        ToggleHolder.Parent = TabContentFrame
        ToggleHolder.BackgroundColor3 = Library.Colors.Body
        ToggleHolder.BorderColor3 = Color3.fromRGB(100, 100, 100)
        ToggleHolder.BorderSizePixel = 1
        ToggleHolder.Size = UDim2.new(1, -10, 0, 40)
        ToggleHolder.ClipsDescendants = false
        ToggleHolder.ZIndex = 12
        ToggleHolder.LayoutOrder = 1

        local HolderCorner = Instance.new("UICorner")
        HolderCorner.Parent = ToggleHolder
        HolderCorner.CornerRadius = UDim.new(0, 6)

        local HolderStroke = Instance.new("UIStroke")
        HolderStroke.Parent = ToggleHolder
        HolderStroke.Thickness = 1
        HolderStroke.Color = Library.Colors.ToggleGradientStart
        HolderStroke.Transparency = 0.3

        local HolderShadow = Instance.new("Frame")
        HolderShadow.Name = "Shadow"
        HolderShadow.Parent = ToggleHolder
        HolderShadow.BackgroundColor3 = Color3.new(0, 0, 0)
        HolderShadow.BorderSizePixel = 0
        HolderShadow.ZIndex = 11
        HolderShadow.Size = ToggleHolder.Size
        HolderShadow.Position = UDim2.new(0, 3, 0, 3)

        local ShadowCorner = Instance.new("UICorner")
        ShadowCorner.Parent = HolderShadow
        ShadowCorner.CornerRadius = UDim.new(0, 6)

        ToggleName.Name = "ToggleName"
        ToggleName.Parent = ToggleHolder
        ToggleName.BackgroundColor3 = Library.Colors.Body
        ToggleName.BackgroundTransparency = 1
        ToggleName.BorderColor3 = Library.Colors.Border
        ToggleName.BorderSizePixel = 0
        ToggleName.Position = UDim2.new(0.05, 0, 0.15, 0)
        ToggleName.Size = UDim2.new(0.7, 0, 0.7, 0)
        ToggleName.Font = Library.Settings.MainTextFont
        ToggleName.Text = toggleName
        ToggleName.TextColor3 = Library.Colors.Text
        ToggleName.TextSize = 14
        ToggleName.TextXAlignment = Enum.TextXAlignment.Left
        ToggleName.TextYAlignment = Enum.TextYAlignment.Center
        ToggleName.ZIndex = 13

        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleHolder
        ToggleButton.BackgroundColor3 = Library.Colors.Body
        ToggleButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
        ToggleButton.BorderSizePixel = 1
        ToggleButton.Position = UDim2.new(0.75, 0, 0.15, 0)
        ToggleButton.Size = UDim2.new(0.2, 0, 0.7, 0)
        ToggleButton.AutoButtonColor = false
        ToggleButton.Font = Library.Settings.MainTextFont
        ToggleButton.Text = ""
        ToggleButton.TextColor3 = Library.Colors.Text
        ToggleButton.TextSize = Library.Settings.MainTextSize
        ToggleButton.ZIndex = 13

        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.Name = "ToggleButtonCorner"
        ToggleButtonCorner.Parent = ToggleButton
        ToggleButtonCorner.CornerRadius = UDim.new(0, 4)

        ToggleFill.Name = "ToggleFill"
        ToggleFill.Parent = ToggleButton
        ToggleFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        ToggleFill.BorderColor3 = Library.Colors.Border
        ToggleFill.BorderSizePixel = 0
        ToggleFill.Position = UDim2.new(0, 0, 0, 0)
        ToggleFill.Size = UDim2.new(0, 0, 1, 0)
        ToggleFill.ZIndex = 12
        ToggleFill.ClipsDescendants = true

        local ToggleFillCorner = Instance.new("UICorner")
        ToggleFillCorner.Name = "ToggleFillCorner"
        ToggleFillCorner.Parent = ToggleFill
        ToggleFillCorner.CornerRadius = UDim.new(0, 4)

        ToggleFillGradient.Name = "ToggleFillGradient"
        ToggleFillGradient.Parent = ToggleFill
        ToggleFillGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Library.Colors.ToggleGradientStart),
            ColorSequenceKeypoint.new(1, Library.Colors.ToggleGradientEnd)
        }

        ChildrenFrame.Name = "ChildrenFrame"
        ChildrenFrame.Parent = ToggleHolder
        ChildrenFrame.BackgroundTransparency = 1
        ChildrenFrame.BorderSizePixel = 0
        ChildrenFrame.Position = UDim2.new(0, 0, 1, 5)
        ChildrenFrame.Size = UDim2.new(1, 0, 0, 0)
        ChildrenFrame.ClipsDescendants = true
        ChildrenFrame.ZIndex = 12

        ChildrenLayout.Name = "ChildrenLayout"
        ChildrenLayout.Parent = ChildrenFrame
        ChildrenLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ChildrenLayout.Padding = UDim.new(0, 5)

        local childrenYSize = 0
        local childrenVisible = false

        local function ExpandChildren()
            childrenVisible = true
            TweenService:Create(ChildrenFrame, TweenInfo.new(0.4, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, childrenYSize)}):Play()
            ExtendBodySize(childrenYSize + 10)
        end

        local function CollapseChildren()
            childrenVisible = false
            TweenService:Create(ChildrenFrame, TweenInfo.new(0.4, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            UnExtendBodySize(childrenYSize + 10)
            childrenYSize = 0
        end

        ToggleButton.MouseButton2Click:Connect(function()
            if not childrenVisible then
                ExpandChildren()
            else
                CollapseChildren()
            end
        end)

        ToggleButton.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled

            if isEnabled then
                TweenService:Create(ToggleFill, TweenInfo.new(Library.Settings.ToggleTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            else
                TweenService:Create(ToggleFill, TweenInfo.new(Library.Settings.ToggleTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0)}):Play()
            end

            if callback then
                callback(isEnabled)
            end
        end)

        if isEnabled then
            TweenService:Create(ToggleFill, TweenInfo.new(0, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        end

        ExtendBodySize(45)

        local ToggleAPI = {}

        function ToggleAPI:AddToggle(toggleConfig2)
            local childToggle = CoastsLibrary:AddToggle(toggleConfig2)
            childrenYSize = childrenYSize + 45
            if childrenVisible then
                TweenService:Create(ChildrenFrame, TweenInfo.new(0.4, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, childrenYSize)}):Play()
                ExtendBodySize(45)
            end
            return childToggle
        end

        function ToggleAPI:CreateSlider(slidername, minimumvalue, maximumvalue, startvalue, precisevalue, action)
            local SliderHolder = Instance.new("Frame")
            local SliderBackground = Instance.new("Frame")
            local SlidingSlider = Instance.new("Frame")
            local SliderValueText = Instance.new("TextLabel")

            local Dragging = false
            local PreciseSliderValue = precisevalue

            SliderHolder.Name = (slidername .. "SliderHolder")
            SliderHolder.Parent = ChildrenFrame
            SliderHolder.BackgroundColor3 = Library.Colors.Body
            SliderHolder.BorderColor3 = Color3.fromRGB(100, 100, 100)
            SliderHolder.BorderSizePixel = 1
            SliderHolder.Size = UDim2.new(1, -10, 0, 35)
            SliderHolder.LayoutOrder = 1
            SliderHolder.ZIndex = 12

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.Parent = SliderHolder
            SliderCorner.CornerRadius = UDim.new(0, 6)

            local SliderShadow = Instance.new("Frame")
            SliderShadow.Name = "Shadow"
            SliderShadow.Parent = SliderHolder
            SliderShadow.BackgroundColor3 = Color3.new(0, 0, 0)
            SliderShadow.BorderSizePixel = 0
            SliderShadow.ZIndex = 11
            SliderShadow.Size = SliderHolder.Size
            SliderShadow.Position = UDim2.new(0, 3, 0, 3)

            local SliderShadowCorner = Instance.new("UICorner")
            SliderShadowCorner.Parent = SliderShadow
            SliderShadowCorner.CornerRadius = UDim.new(0, 6)

            local SliderName = Instance.new("TextLabel")
            SliderName.Name = "SliderName"
            SliderName.Parent = SliderHolder
            SliderName.BackgroundTransparency = 1
            SliderName.BorderSizePixel = 0
            SliderName.Position = UDim2.new(0.05, 0, 0.05, 0)
            SliderName.Size = UDim2.new(0.6, 0, 0.9, 0)
            SliderName.Font = Library.Settings.MainTextFont
            SliderName.Text = slidername
            SliderName.TextColor3 = Library.Colors.Text
            SliderName.TextSize = 12
            SliderName.TextXAlignment = Enum.TextXAlignment.Left
            SliderName.TextYAlignment = Enum.TextYAlignment.Center
            SliderName.ZIndex = 13

            SliderBackground.Name = (slidername .. "SliderBackground")
            SliderBackground.Parent = SliderHolder
            SliderBackground.BackgroundColor3 = Library.Colors.SliderBackground
            SliderBackground.BorderColor3 = Library.Colors.Border
            SliderBackground.BorderSizePixel = 0
            SliderBackground.ClipsDescendants = true
            SliderBackground.Position = UDim2.new(0.05, 0, 0.55, 0)
            SliderBackground.Size = UDim2.new(0.7, 0, 0.25, 0)
            SliderBackground.ZIndex = 12

            local BgCorner = Instance.new("UICorner")
            BgCorner.Parent = SliderBackground
            BgCorner.CornerRadius = UDim.new(0, 4)

            SlidingSlider.Name = (slidername .. "SlidingSlider")
            SlidingSlider.Parent = SliderBackground
            SlidingSlider.BackgroundColor3 = Library.Colors.Slider
            SlidingSlider.BorderColor3 = Library.Colors.Border
            SlidingSlider.BorderSizePixel = 0
            SlidingSlider.Position = UDim2.new(0, 0, 0, 0)
            SlidingSlider.Size = UDim2.new((startvalue or 0) / maximumvalue, 0, 1, 0)

            SliderValueText.Name = (slidername .. "SliderValueText")
            SliderValueText.Parent = SliderHolder
            SliderValueText.BackgroundTransparency = 1
            SliderValueText.BorderColor3 = Library.Colors.Border
            SliderValueText.BorderSizePixel = 0
            SliderValueText.Position = UDim2.new(0.78, 0, 0.05, 0)
            SliderValueText.Size = UDim2.new(0.2, 0, 0.9, 0)
            SliderValueText.Font = Library.Settings.MainTextFont
            SliderValueText.Text = tostring(startvalue or PreciseSliderValue and tonumber(string.format("%.2f", startvalue)))
            SliderValueText.TextColor3 = Library.Colors.Text
            SliderValueText.TextSize = 12
            SliderValueText.TextXAlignment = Enum.TextXAlignment.Right
            SliderValueText.TextYAlignment = Enum.TextYAlignment.Center
            SliderValueText.ZIndex = 13

            local function Sliding(input)
                local Pos = UDim2.new(math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SlidingSlider.Size = Pos

                local NonSliderPreciseValue = math.floor(((Pos.X.Scale * maximumvalue) / maximumvalue) * (maximumvalue - minimumvalue) + minimumvalue)
                local SliderPreciseValue = ((Pos.X.Scale * maximumvalue) / maximumvalue) * (maximumvalue - minimumvalue) + minimumvalue

                local Value = (PreciseSliderValue and SliderPreciseValue or NonSliderPreciseValue)
                Value = tonumber(string.format("%.2f", Value))

                SliderValueText.Text = tostring(Value)
                action(Value)
            end

            SliderBackground.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                end
            end)

            SliderBackground.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)

            SliderBackground.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Sliding(input)
                end
            end)

            childrenYSize = childrenYSize + 40
            if childrenVisible then
                ExtendBodySize(40)
            end

            return SliderHolder
        end

        function ToggleAPI:CreateDropdown(dropdownname, dropdownlistoptions, dropdownlistpresetnumber, action)
            local DropdownHolder = Instance.new("Frame")
            local SelectedOption = Instance.new("TextLabel")
            local DropdownButton = Instance.new("TextButton")
            local DropdownMain = Instance.new("Frame")
            local SelectionOrganizer = Instance.new("UIListLayout")

            local DropdownYSize = 0
            local IsDropdownOpen = false

            DropdownHolder.Name = (dropdownname .. "DropdownHolder")
            DropdownHolder.Parent = ChildrenFrame
            DropdownHolder.BackgroundColor3 = Library.Colors.Body
            DropdownHolder.BorderColor3 = Color3.fromRGB(100, 100, 100)
            DropdownHolder.BorderSizePixel = 1
            DropdownHolder.Size = UDim2.new(1, -10, 0, 35)
            DropdownHolder.LayoutOrder = 1
            DropdownHolder.ZIndex = 12
            DropdownHolder.ClipsDescendants = false

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.Parent = DropdownHolder
            DropdownCorner.CornerRadius = UDim.new(0, 6)

            local DropdownShadow = Instance.new("Frame")
            DropdownShadow.Name = "Shadow"
            DropdownShadow.Parent = DropdownHolder
            DropdownShadow.BackgroundColor3 = Color3.new(0, 0, 0)
            DropdownShadow.BorderSizePixel = 0
            DropdownShadow.ZIndex = 11
            DropdownShadow.Size = DropdownHolder.Size
            DropdownShadow.Position = UDim2.new(0, 3, 0, 3)

            local DropdownShadowCorner = Instance.new("UICorner")
            DropdownShadowCorner.Parent = DropdownShadow
            DropdownShadowCorner.CornerRadius = UDim.new(0, 6)

            SelectedOption.Name = (dropdownname .. "SelectedOption")
            SelectedOption.Parent = DropdownHolder
            SelectedOption.BackgroundTransparency = 1
            SelectedOption.BorderSizePixel = 0
            SelectedOption.Position = UDim2.new(0.05, 0, 0.1, 0)
            SelectedOption.Size = UDim2.new(0.85, 0, 0.8, 0)
            SelectedOption.Font = Library.Settings.MainTextFont
            SelectedOption.Text = dropdownlistoptions[dropdownlistpresetnumber]
            SelectedOption.TextColor3 = Library.Colors.Text
            SelectedOption.TextSize = 12
            SelectedOption.TextXAlignment = Enum.TextXAlignment.Left
            SelectedOption.TextYAlignment = Enum.TextYAlignment.Center
            SelectedOption.ZIndex = 13

            DropdownButton.Name = (dropdownname .. "DropdownButton")
            DropdownButton.Parent = DropdownHolder
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Position = UDim2.new(0.9, 0, 0.1, 0)
            DropdownButton.Size = UDim2.new(0.08, 0, 0.8, 0)
            DropdownButton.ZIndex = 13
            DropdownButton.Font = Library.Settings.MainTextFont
            DropdownButton.Text = "v"
            DropdownButton.TextColor3 = Library.Colors.Text
            DropdownButton.TextSize = 12

            DropdownMain.Name = (dropdownname .. "DropdownMain")
            DropdownMain.Parent = DropdownHolder
            DropdownMain.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
            DropdownMain.BorderColor3 = Library.Colors.Border
            DropdownMain.BorderSizePixel = 0
            DropdownMain.ClipsDescendants = true
            DropdownMain.Position = UDim2.new(0, 0, 1, 5)
            DropdownMain.Size = UDim2.new(1, 0, 0, DropdownYSize)
            DropdownMain.ZIndex = 12

            local DropdownMainCorner = Instance.new("UICorner")
            DropdownMainCorner.Parent = DropdownMain
            DropdownMainCorner.CornerRadius = UDim.new(0, 6)

            SelectionOrganizer.Name = (dropdownname .. "SelectionOrganizer")
            SelectionOrganizer.Parent = DropdownMain
            SelectionOrganizer.SortOrder = Enum.SortOrder.LayoutOrder

            for i, v in pairs(dropdownlistoptions) do
                local DropdownListOptionButton = Instance.new("TextButton")

                DropdownListOptionButton.Name = (v .. "DropdownButton")
                DropdownListOptionButton.Parent = DropdownMain
                DropdownListOptionButton.BackgroundColor3 = Library.Colors.DropdownButton
                DropdownListOptionButton.BorderColor3 = Library.Colors.Border
                DropdownListOptionButton.BorderSizePixel = 0
                DropdownListOptionButton.Size = UDim2.new(1, 0, 0, 30)
                DropdownListOptionButton.AutoButtonColor = false
                DropdownListOptionButton.Font = Library.Settings.MainTextFont
                DropdownListOptionButton.Text = v
                DropdownListOptionButton.TextColor3 = Library.Colors.Text
                DropdownListOptionButton.TextSize = 12
                DropdownListOptionButton.ZIndex = 12

                DropdownYSize = DropdownYSize + 30

                DropdownListOptionButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        TweenService:Create(DropdownListOptionButton, TweenInfo.new(Library.Settings.DropdownButtonColorHoverTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Colors.DropdownButtonHover}):Play()
                    end
                end)

                DropdownListOptionButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        TweenService:Create(DropdownListOptionButton, TweenInfo.new(Library.Settings.DropdownButtonColorHoverTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Colors.DropdownButton}):Play()
                    end
                end)

                DropdownListOptionButton.MouseButton1Click:Connect(function()
                    action(v)
                    SelectedOption.Text = v
                    TweenService:Create(DropdownMain, TweenInfo.new(Library.Settings.DropdownTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    TweenService:Create(DropdownButton, TweenInfo.new(Library.Settings.DropdownTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                    IsDropdownOpen = false
                end)
            end

            DropdownButton.MouseButton1Click:Connect(function()
                if IsDropdownOpen then
                    TweenService:Create(DropdownMain, TweenInfo.new(Library.Settings.DropdownTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    TweenService:Create(DropdownButton, TweenInfo.new(Library.Settings.DropdownTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                    IsDropdownOpen = false
                elseif not IsDropdownOpen then
                    TweenService:Create(DropdownMain, TweenInfo.new(Library.Settings.DropdownTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, DropdownYSize)}):Play()
                    TweenService:Create(DropdownButton, TweenInfo.new(Library.Settings.DropdownTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Rotation = -90}):Play()
                    IsDropdownOpen = true
                end
            end)

            childrenYSize = childrenYSize + 40
            if childrenVisible then
                ExtendBodySize(40)
            end

            return DropdownHolder
        end

        function ToggleAPI:CreateColorPicker(colorpickername, colorpickerpresetcolor, action)
            local ColorPickerHolder = Instance.new("Frame")
            local ColorPickerButton = Instance.new("TextButton")
            local ColorPickerMain = Instance.new("Frame")
            local ColorPallete = Instance.new("ImageLabel")
            local ColorPalleteMarker = Instance.new("ImageLabel")
            local ColorBrightness = Instance.new("ImageLabel")
            local ColorBrightnessMarker = Instance.new("Frame")
            local ColorRed = Instance.new("TextLabel")
            local ColorGreen = Instance.new("TextLabel")
            local ColorBlue = Instance.new("TextLabel")

            local HSD = false
            local VD = false

            ColorPickerHolder.Name = (colorpickername .. "ColorPickerHolder")
            ColorPickerHolder.Parent = ChildrenFrame
            ColorPickerHolder.BackgroundColor3 = Library.Colors.Body
            ColorPickerHolder.BorderColor3 = Color3.fromRGB(100, 100, 100)
            ColorPickerHolder.BorderSizePixel = 1
            ColorPickerHolder.Size = UDim2.new(1, -10, 0, 35)
            ColorPickerHolder.LayoutOrder = 1
            ColorPickerHolder.ZIndex = 12

            local PickerCorner = Instance.new("UICorner")
            PickerCorner.Parent = ColorPickerHolder
            PickerCorner.CornerRadius = UDim.new(0, 6)

            local PickerShadow = Instance.new("Frame")
            PickerShadow.Name = "Shadow"
            PickerShadow.Parent = ColorPickerHolder
            PickerShadow.BackgroundColor3 = Color3.new(0, 0, 0)
            PickerShadow.BorderSizePixel = 0
            PickerShadow.ZIndex = 11
            PickerShadow.Size = ColorPickerHolder.Size
            PickerShadow.Position = UDim2.new(0, 3, 0, 3)

            local PickerShadowCorner = Instance.new("UICorner")
            PickerShadowCorner.Parent = PickerShadow
            PickerShadowCorner.CornerRadius = UDim.new(0, 6)

            local ColorPickerName = Instance.new("TextLabel")
            ColorPickerName.Name = "ColorPickerName"
            ColorPickerName.Parent = ColorPickerHolder
            ColorPickerName.BackgroundTransparency = 1
            ColorPickerName.BorderSizePixel = 0
            ColorPickerName.Position = UDim2.new(0.05, 0, 0.1, 0)
            ColorPickerName.Size = UDim2.new(0.6, 0, 0.8, 0)
            ColorPickerName.Font = Library.Settings.MainTextFont
            ColorPickerName.Text = colorpickername
            ColorPickerName.TextColor3 = Library.Colors.Text
            ColorPickerName.TextSize = 12
            ColorPickerName.TextXAlignment = Enum.TextXAlignment.Left
            ColorPickerName.TextYAlignment = Enum.TextYAlignment.Center
            ColorPickerName.ZIndex = 13

            ColorPickerButton.Name = "ColorPickerButton"
            ColorPickerButton.Parent = ColorPickerHolder
            ColorPickerButton.BackgroundColor3 = colorpickerpresetcolor or Color3.fromRGB(255, 255, 255)
            ColorPickerButton.BorderColor3 = Library.Colors.Border
            ColorPickerButton.BorderSizePixel = 0
            ColorPickerButton.Position = UDim2.new(0.7, 0, 0.15, 0)
            ColorPickerButton.Size = UDim2.new(0.25, 0, 0.7, 0)
            ColorPickerButton.AutoButtonColor = false
            ColorPickerButton.Font = Library.Settings.MainTextFont
            ColorPickerButton.Text = ""
            ColorPickerButton.TextColor3 = Color3.new(255, 255, 255)
            ColorPickerButton.TextSize = Library.Settings.MainTextSize
            ColorPickerButton.ZIndex = 13

            local PickerBtnCorner = Instance.new("UICorner")
            PickerBtnCorner.Parent = ColorPickerButton
            PickerBtnCorner.CornerRadius = UDim.new(0, 4)

            local Red, Green, Blue = colorpickerpresetcolor.r * 255, colorpickerpresetcolor.g * 255, colorpickerpresetcolor.b * 255

            ColorPickerMain.Name = "ColorPickerMain"
            ColorPickerMain.Parent = ColorPickerHolder
            ColorPickerMain.BackgroundColor3 = Library.Colors.Body
            ColorPickerMain.BorderColor3 = Library.Colors.Border
            ColorPickerMain.BorderSizePixel = 0
            ColorPickerMain.ClipsDescendants = true
            ColorPickerMain.Position = UDim2.new(0, 0, 1, 5)
            ColorPickerMain.Size = UDim2.new(1, 0, 0, 0)
            ColorPickerMain.ZIndex = 12

            local PickerMainCorner = Instance.new("UICorner")
            PickerMainCorner.Parent = ColorPickerMain
            PickerMainCorner.CornerRadius = UDim.new(0, 6)

            ColorPallete.Name = "ColorPallete"
            ColorPallete.Parent = ColorPickerMain
            ColorPallete.BackgroundColor3 = Library.Colors.Border
            ColorPallete.BackgroundTransparency = 1
            ColorPallete.BorderColor3 = Library.Colors.Border
            ColorPallete.BorderSizePixel = 0
            ColorPallete.Position = UDim2.new(0, 5, 0, 4)
            ColorPallete.Size = UDim2.new(0, 149, 0, 151)
            ColorPallete.ZIndex = 13
            ColorPallete.Image = "rbxassetid://4477380641"

            ColorPalleteMarker.Name = "ColorPalleteMarker"
            ColorPalleteMarker.Parent = ColorPallete
            ColorPalleteMarker.BackgroundColor3 = Library.Colors.Border
            ColorPalleteMarker.BackgroundTransparency = 1
            ColorPalleteMarker.BorderColor3 = Library.Colors.Border
            ColorPalleteMarker.BorderSizePixel = 0
            ColorPalleteMarker.Position = UDim2.new(colorpickerpresetcolor and select(1, Color3.toHSV(colorpickerpresetcolor)) or 0, 0, colorpickerpresetcolor and 1 - select(2, Color3.toHSV(colorpickerpresetcolor)) or 0, 0)
            ColorPalleteMarker.Size = UDim2.new(0, 0, 0.200000003, 0)
            ColorPalleteMarker.ZIndex = 13
            ColorPalleteMarker.Image = "rbxassetid://4409133510"
            ColorPalleteMarker.ScaleType = Enum.ScaleType.Crop

            ColorBrightness.Name = "ColorBrightness"
            ColorBrightness.Parent = ColorPickerMain
            ColorBrightness.AnchorPoint = Vector2.new(1, 0)
            ColorBrightness.BackgroundColor3 = Library.Colors.Border
            ColorBrightness.BorderColor3 = Library.Colors.Border
            ColorBrightness.BorderSizePixel = 0
            ColorBrightness.Position = UDim2.new(0, 195, 0, 4)
            ColorBrightness.Size = UDim2.new(0, 34, 0, 151)
            ColorBrightness.ZIndex = 13
            ColorBrightness.Image = "rbxassetid://4477380092"
            ColorBrightness.ScaleType = Enum.ScaleType.Crop

            ColorBrightnessMarker.Name = "ColorBrightnessMarker"
            ColorBrightnessMarker.Parent = ColorBrightness
            ColorBrightnessMarker.AnchorPoint = Vector2.new(0, 0.5)
            ColorBrightnessMarker.BackgroundColor3 = Library.Colors.ColorPickerMarker
            ColorBrightnessMarker.BorderColor3 = Library.Colors.Border
            ColorBrightnessMarker.BorderSizePixel = 0
            ColorBrightnessMarker.Position = UDim2.new(0, 0, 0.013245035, 0)
            ColorBrightnessMarker.Size = UDim2.new(1, 0, 0.0280000009, 0)
            ColorBrightnessMarker.ZIndex = 13

            ColorRed.Name = "ColorRed"
            ColorRed.Parent = ColorPickerMain
            ColorRed.BackgroundColor3 = Library.Colors.Border
            ColorRed.BackgroundTransparency = 1
            ColorRed.BorderColor3 = Library.Colors.Border
            ColorRed.BorderSizePixel = 0
            ColorRed.Position = UDim2.new(0, 5, 0, 155)
            ColorRed.Size = UDim2.new(0, 55, 0, 20)
            ColorRed.Font = Library.Settings.MainTextFont
            ColorRed.Text = ("R: " .. math.floor(Red))
            ColorRed.TextColor3 = Color3.new(1, 1, 1)
            ColorRed.TextSize = 12
            ColorRed.TextXAlignment = Enum.TextXAlignment.Left
            ColorRed.ZIndex = 13

            ColorGreen.Name = "ColorGreen"
            ColorGreen.Parent = ColorPickerMain
            ColorGreen.BackgroundColor3 = Library.Colors.Border
            ColorGreen.BackgroundTransparency = 1
            ColorGreen.BorderColor3 = Library.Colors.Border
            ColorGreen.BorderSizePixel = 0
            ColorGreen.Position = UDim2.new(0, 72, 0, 155)
            ColorGreen.Size = UDim2.new(0, 55, 0, 20)
            ColorGreen.Font = Library.Settings.MainTextFont
            ColorGreen.Text = ("G: " .. math.floor(Green))
            ColorGreen.TextColor3 = Color3.new(1, 1, 1)
            ColorGreen.TextSize = 12
            ColorGreen.TextXAlignment = Enum.TextXAlignment.Left
            ColorGreen.ZIndex = 13

            ColorBlue.Name = "ColorBlue"
            ColorBlue.Parent = ColorPickerMain
            ColorBlue.BackgroundColor3 = Library.Colors.Border
            ColorBlue.BackgroundTransparency = 1
            ColorBlue.BorderColor3 = Library.Colors.Border
            ColorBlue.BorderSizePixel = 0
            ColorBlue.Position = UDim2.new(0, 145, 0, 155)
            ColorBlue.Size = UDim2.new(0, 55, 0, 20)
            ColorBlue.Font = Library.Settings.MainTextFont
            ColorBlue.Text = ("B: " .. math.floor(Blue))
            ColorBlue.TextColor3 = Color3.new(1, 1, 1)
            ColorBlue.TextSize = 12
            ColorBlue.TextXAlignment = Enum.TextXAlignment.Left
            ColorBlue.ZIndex = 13

            ColorPickerButton.MouseButton1Click:Connect(function()
                if ColorPickerMain.Size.Y.Offset == 0 then
                    TweenService:Create(ColorPickerMain, TweenInfo.new(Library.Settings.ColorPickerTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 175)}):Play()
                else
                    TweenService:Create(ColorPickerMain, TweenInfo.new(Library.Settings.ColorPickerTweenTime, Library.Settings.TweenEasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                end
            end)

            ColorPallete.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    HSD = true
                end
            end)

            ColorPallete.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    HSD = false
                end
            end)

            ColorBrightness.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    VD = true
                end
            end)

            ColorBrightness.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    VD = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if HSD and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Red, Green, Blue = ColorPickerButton.BackgroundColor3.r * 255, ColorPickerButton.BackgroundColor3.g * 255, ColorPickerButton.BackgroundColor3.b * 255

                    ColorRed.Text = ("R: " .. math.floor(Red))
                    ColorGreen.Text = ("G: " .. math.floor(Green))
                    ColorBlue.Text = ("B: " .. math.floor(Blue))

                    ColorPalleteMarker.Position = UDim2.new(math.clamp((input.Position.X - ColorPallete.AbsolutePosition.X) / ColorPallete.AbsoluteSize.X, 0, 1), 0, math.clamp((input.Position.Y - ColorPallete.AbsolutePosition.Y) / ColorPallete.AbsoluteSize.Y, 0, 1), 0)

                    ColorPickerButton.BackgroundColor3 = Color3.fromHSV(ColorPalleteMarker.Position.X.Scale, 1 - ColorPalleteMarker.Position.Y.Scale, 1 - ColorBrightnessMarker.Position.Y.Scale)

                    action(ColorPickerButton.BackgroundColor3)
                elseif VD and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Red, Green, Blue = ColorPickerButton.BackgroundColor3.r * 255, ColorPickerButton.BackgroundColor3.g * 255, ColorPickerButton.BackgroundColor3.b * 255

                    ColorRed.Text = ("R: " .. math.floor(Red))
                    ColorGreen.Text = ("G: " .. math.floor(Green))
                    ColorBlue.Text = ("B: " .. math.floor(Blue))

                    ColorBrightnessMarker.Position = UDim2.new(0, 0, math.clamp((input.Position.Y - ColorBrightness.AbsolutePosition.Y) / ColorBrightness.AbsoluteSize.Y, 0, 1), 0)

                    ColorPickerButton.BackgroundColor3 = Color3.fromHSV(ColorPalleteMarker.Position.X.Scale, 1 - ColorPalleteMarker.Position.Y.Scale, 1 - ColorBrightnessMarker.Position.Y.Scale)

                    action(ColorPickerButton.BackgroundColor3)
                end
            end)

            childrenYSize = childrenYSize + 40
            if childrenVisible then
                ExtendBodySize(40)
            end

            return ColorPickerHolder
        end

        return ToggleAPI
    end

    return CoastsLibrary
end

return Library
