local Library = {}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Theme = {
    Background = Color3.fromRGB(24, 24, 27),
    Sidebar = Color3.fromRGB(20, 20, 22),
    Accent = Color3.fromRGB(99, 102, 241), -- Indigo-500
    Text = Color3.fromRGB(244, 244, 245),
    TextDark = Color3.fromRGB(161, 161, 170),
    Element = Color3.fromRGB(39, 39, 42),
    ElementHover = Color3.fromRGB(49, 49, 53),
    Outline = Color3.fromRGB(63, 63, 70),
    Error = Color3.fromRGB(239, 68, 68)
}

-- Utility function
local function Create(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        if k ~= "Parent" then inst[k] = v end
    end
    if properties.Parent then inst.Parent = properties.Parent end
    return inst
end

local ScreenGui = Create("ScreenGui", {
    Name = "UniversalLibraryV2",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

local NotificationContainer = Create("Frame", {
    Name = "Notifications",
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -320, 1, -20),
    Size = UDim2.new(0, 300, 1, 0),
    AnchorPoint = Vector2.new(0, 1)
})
local NotifLayout = Create("UIListLayout", {
    Parent = NotificationContainer,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10),
    VerticalAlignment = Enum.VerticalAlignment.Bottom
})

function Library:Notify(options)
    local title = options.Title or "Notification"
    local text = options.Text or "This is a notification."
    local duration = options.Duration or 3

    local NotifFrame = Create("Frame", {
        Parent = NotificationContainer,
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundTransparency = 1
    })
    Create("UICorner", {Parent = NotifFrame, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = NotifFrame, Color = Theme.Outline, Thickness = 1, Transparency = 1})

    local TitleLabel = Create("TextLabel", {
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    })

    local TextLabel = Create("TextLabel", {
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(1, -30, 0, 35),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.TextDark,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextTransparency = 1
    })

    local TimerBG = Create("Frame", {
        Parent = NotifFrame,
        BackgroundColor3 = Theme.Element,
        Position = UDim2.new(0, 15, 1, -8),
        Size = UDim2.new(1, -30, 0, 3),
        BackgroundTransparency = 1
    })
    Create("UICorner", {Parent = TimerBG, CornerRadius = UDim.new(1, 0)})

    local TimerFill = Create("Frame", {
        Parent = TimerBG,
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    })
    Create("UICorner", {Parent = TimerFill, CornerRadius = UDim.new(1, 0)})

    -- Fade in
    TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(NotifFrame.UIStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(TextLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(TimerBG, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(TimerFill, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()

    -- Timer shrink
    local timerTween = TweenService:Create(TimerFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})
    timerTween:Play()

    timerTween.Completed:Connect(function()
        -- Fade out
        TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(NotifFrame.UIStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(TextLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(TimerBG, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(TimerFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        NotifFrame:Destroy()
    end)
end

-- Dragging logic
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
    end)
end

function Library:CreateWindow(options)
    local title = options.Title or "Universal UI"
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0.5, -275, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 350)
    })
    Create("UICorner", { Parent = MainFrame, CornerRadius = UDim.new(0, 10) })
    Create("UIStroke", { Parent = MainFrame, Color = Theme.Outline, Thickness = 1 })

    local Topbar = Create("Frame", {
        Name = "Topbar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(1, 0, 0, 45),
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    })
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(1, -70, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local CloseBtn = Create("TextButton", {
        Name = "CloseBtn",
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -45, 0, 0),
        Size = UDim2.new(0, 45, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "✕",
        TextColor3 = Theme.TextDark,
        TextSize = 18
    })
    CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Error}):Play() end)
    CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDark}):Play() end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local Divider = Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Theme.Outline,
        Position = UDim2.new(0, 0, 0, 44),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0
    })
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Sidebar,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, 140, 1, -45),
        BorderSizePixel = 0
    })
    Create("UICorner", { Parent = Sidebar, CornerRadius = UDim.new(0, 10) })
    -- Hide right side corners of sidebar to blend
    local BlockCorner = Create("Frame", { Parent = Sidebar, BackgroundColor3 = Theme.Sidebar, Position = UDim2.new(1, -10, 0, 0), Size = UDim2.new(0, 10, 1, 0), BorderSizePixel = 0 })
    local BlockCorner2 = Create("Frame", { Parent = Sidebar, BackgroundColor3 = Theme.Sidebar, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, 10), BorderSizePixel = 0 })

    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Sidebar,
        Active = true,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -45),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    Create("UIListLayout", { Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center })

    Create("TextLabel", {
        Name = "Watermark",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, -30),
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.Gotham,
        Text = "by NochHawk",
        TextColor3 = Theme.TextDark,
        TextSize = 11,
        TextTransparency = 0.5
    })

    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 140, 0, 45),
        Size = UDim2.new(1, -140, 1, -45)
    })

    local WindowConfig = { CurrentTab = nil }

    function WindowConfig:CreateTab(tabName)
        local TabButton = Create("TextButton", {
            Name = tabName .. "Tab",
            Parent = TabContainer,
            BackgroundColor3 = Theme.ElementHover,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -16, 0, 32),
            Font = Enum.Font.GothamSemibold,
            Text = tabName,
            TextColor3 = Theme.TextDark,
            TextSize = 13,
            AutoButtonColor = false
        })
        Create("UICorner", { Parent = TabButton, CornerRadius = UDim.new(0, 6) })

        local TabContent = Create("ScrollingFrame", {
            Name = tabName .. "Content",
            Parent = ContentContainer,
            Active = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false
        })
        Create("UIPadding", { Parent = TabContent, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15) })
        Create("UIListLayout", { Parent = TabContent, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })

        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.2), {TextColor3 = Theme.TextDark, BackgroundTransparency = 1}):Play()
                end
            end
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Theme.Accent, BackgroundTransparency = 0}):Play()
            TabContent.Visible = true
        end)

        if not WindowConfig.CurrentTab then
            WindowConfig.CurrentTab = TabButton
            TabButton.TextColor3 = Theme.Accent
            TabButton.BackgroundTransparency = 0
            TabContent.Visible = true
        end

        local Elements = {}
        
        function Elements:CreateSection(name)
            local SectionLabel = Create("TextLabel", {
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.GothamBold,
                Text = name:upper(),
                TextColor3 = Theme.TextDark,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            Create("Frame", {
                Parent = SectionLabel,
                BackgroundColor3 = Theme.Outline,
                Position = UDim2.new(0, 0, 1, -2),
                Size = UDim2.new(1, 0, 0, 1),
                BorderSizePixel = 0
            })
        end

        function Elements:CreateButton(options)
            local btnName = options.Name or "Button"
            local callback = options.Callback or function() end

            local Button = Create("TextButton", {
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36),
                Font = Enum.Font.GothamSemibold,
                Text = btnName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                AutoButtonColor = false
            })
            Create("UICorner", { Parent = Button, CornerRadius = UDim.new(0, 6) })
            Create("UIStroke", { Parent = Button, Color = Theme.Outline, Thickness = 1 })

            Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover}):Play() end)
            Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element}):Play() end)
            Button.MouseButton1Click:Connect(callback)
            
            return {
                Set = function(self, newText)
                    Button.Text = newText
                end
            }
        end

        function Elements:CreateToggle(options)
            local togName = options.Name or "Toggle"
            local state = options.Default or false
            local callback = options.Callback or function() end

            local ToggleFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36)
            })
            Create("UICorner", { Parent = ToggleFrame, CornerRadius = UDim.new(0, 6) })
            Create("UIStroke", { Parent = ToggleFrame, Color = Theme.Outline, Thickness = 1 })
            
            Create("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = togName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ToggleOuter = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(63, 63, 70),
                Position = UDim2.new(1, -48, 0.5, -10),
                Size = UDim2.new(0, 36, 0, 20)
            })
            Create("UICorner", { Parent = ToggleOuter, CornerRadius = UDim.new(1, 0) })

            local ToggleInner = Create("Frame", {
                Parent = ToggleOuter,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            Create("UICorner", { Parent = ToggleInner, CornerRadius = UDim.new(1, 0) })
            
            local ToggleBtn = Create("TextButton", { Parent = ToggleFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })

            local function updateToggle(newState)
                state = newState
                TweenService:Create(ToggleOuter, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(63, 63, 70)}):Play()
                TweenService:Create(ToggleInner, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                callback(state)
            end

            ToggleBtn.MouseButton1Click:Connect(function() updateToggle(not state) end)
            updateToggle(state)

            return { Set = function(self, newState) updateToggle(newState) end }
        end

        function Elements:CreateSlider(options)
            local sliderName = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local state = options.Default or min
            local isFloat = options.Float or false
            local callback = options.Callback or function() end

            local SliderFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 50)
            })
            Create("UICorner", { Parent = SliderFrame, CornerRadius = UDim.new(0, 6) })
            Create("UIStroke", { Parent = SliderFrame, Color = Theme.Outline, Thickness = 1 })

            local SliderLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 5),
                Size = UDim2.new(1, -24, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = sliderName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 5),
                Size = UDim2.new(1, -24, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(state),
                TextColor3 = Theme.TextDark,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local SliderBG = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(63, 63, 70),
                Position = UDim2.new(0, 12, 0, 32),
                Size = UDim2.new(1, -24, 0, 6)
            })
            Create("UICorner", { Parent = SliderBG, CornerRadius = UDim.new(1, 0) })

            local SliderFill = Create("Frame", {
                Parent = SliderBG,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((state - min) / (max - min), 0, 1, 0)
            })
            Create("UICorner", { Parent = SliderFill, CornerRadius = UDim.new(1, 0) })

            local SliderBtn = Create("TextButton", { Parent = SliderBG, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })

            local function updateSlider(value)
                state = math.clamp(value, min, max)
                if not isFloat then state = math.floor(state) else state = tonumber(string.format("%.1f", state)) end
                local percent = (state - min) / (max - min)
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(state)
                callback(state)
            end

            local dragging = false
            local function move(input)
                local percent = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                updateSlider(min + ((max - min) * percent))
            end

            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; move(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then move(input) end
            end)

            updateSlider(state)
            return { Set = function(self, val) updateSlider(val) end }
        end

        function Elements:CreateDropdown(options)
            local dropName = options.Name or "Dropdown"
            local list = options.Options or {}
            local callback = options.Callback or function() end
            local isOpen = false

            local DropdownFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36),
                ClipsDescendants = true
            })
            Create("UICorner", { Parent = DropdownFrame, CornerRadius = UDim.new(0, 6) })
            Create("UIStroke", { Parent = DropdownFrame, Color = Theme.Outline, Thickness = 1 })

            local DropdownBtn = Create("TextButton", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 36),
                Font = Enum.Font.GothamSemibold,
                Text = "  " .. dropName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            local Icon = Create("TextLabel", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0, 30, 0, 36),
                Font = Enum.Font.GothamSemibold,
                Text = "▼",
                TextColor3 = Theme.TextDark,
                TextSize = 10
            })

            local DropdownList = Create("ScrollingFrame", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 36),
                Size = UDim2.new(1, 0, 1, -36),
                ScrollBarThickness = 2,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0,0,0,0)
            })
            Create("UIListLayout", { Parent = DropdownList, SortOrder = Enum.SortOrder.LayoutOrder })

            DropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local targetSize = isOpen and UDim2.new(1, 0, 0, 36 + math.min(#list * 30, 120)) or UDim2.new(1, 0, 0, 36)
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
                Icon.Text = isOpen and "▲" or "▼"
            end)

            for _, item in ipairs(list) do
                local ItemBtn = Create("TextButton", {
                    Parent = DropdownList,
                    BackgroundColor3 = Theme.ElementHover,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = "  " .. item,
                    TextColor3 = Theme.TextDark,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ItemBtn.MouseEnter:Connect(function() ItemBtn.BackgroundTransparency = 0; ItemBtn.TextColor3 = Theme.Text end)
                ItemBtn.MouseLeave:Connect(function() ItemBtn.BackgroundTransparency = 1; ItemBtn.TextColor3 = Theme.TextDark end)
                ItemBtn.MouseButton1Click:Connect(function()
                    DropdownBtn.Text = "  " .. dropName .. " : " .. item
                    isOpen = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                    Icon.Text = "▼"
                    callback(item)
                end)
            end
            
            return {
                Set = function(self, val)
                    DropdownBtn.Text = "  " .. dropName .. " : " .. val
                    callback(val)
                end
            }
        end

        function Elements:CreateTextBox(options)
            local boxName = options.Name or "TextBox"
            local default = options.Default or ""
            local callback = options.Callback or function() end

            local BoxFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36)
            })
            Create("UICorner", { Parent = BoxFrame, CornerRadius = UDim.new(0, 6) })
            Create("UIStroke", { Parent = BoxFrame, Color = Theme.Outline, Thickness = 1 })

            Create("TextLabel", {
                Parent = BoxFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = boxName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local TextBox = Create("TextBox", {
                Parent = BoxFrame,
                BackgroundColor3 = Theme.Background,
                Position = UDim2.new(1, -120, 0.5, -12),
                Size = UDim2.new(0, 110, 0, 24),
                Font = Enum.Font.Gotham,
                Text = default,
                TextColor3 = Theme.Text,
                TextSize = 12,
                ClearTextOnFocus = false
            })
            Create("UICorner", { Parent = TextBox, CornerRadius = UDim.new(0, 4) })
            Create("UIStroke", { Parent = TextBox, Color = Theme.Outline, Thickness = 1 })

            TextBox.FocusLost:Connect(function()
                callback(TextBox.Text)
            end)
            
            return { Set = function(self, val) TextBox.Text = val; callback(val) end }
        end

        function Elements:CreateKeybind(options)
            local bindName = options.Name or "Keybind"
            local currentKey = options.Default or Enum.KeyCode.E
            local callback = options.Callback or function() end

            local BindFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36)
            })
            Create("UICorner", { Parent = BindFrame, CornerRadius = UDim.new(0, 6) })
            Create("UIStroke", { Parent = BindFrame, Color = Theme.Outline, Thickness = 1 })

            Create("TextLabel", {
                Parent = BindFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = bindName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local BindBtn = Create("TextButton", {
                Parent = BindFrame,
                BackgroundColor3 = Theme.Background,
                Position = UDim2.new(1, -90, 0.5, -12),
                Size = UDim2.new(0, 80, 0, 24),
                Font = Enum.Font.GothamBold,
                Text = currentKey.Name,
                TextColor3 = Theme.TextDark,
                TextSize = 12
            })
            Create("UICorner", { Parent = BindBtn, CornerRadius = UDim.new(0, 4) })
            Create("UIStroke", { Parent = BindBtn, Color = Theme.Outline, Thickness = 1 })

            local Connection
            local Listening = false

            BindBtn.MouseButton1Click:Connect(function()
                Listening = true
                BindBtn.Text = "..."
                BindBtn.TextColor3 = Theme.Accent
                if Connection then Connection:Disconnect() end
                Connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        BindBtn.Text = currentKey.Name
                        BindBtn.TextColor3 = Theme.TextDark
                        Listening = false
                        Connection:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if not processed and not Listening and input.KeyCode == currentKey then
                    callback()
                end
            end)

            return { Set = function(self, key) currentKey = key; BindBtn.Text = key.Name end }
        end

        function Elements:CreateColorPicker(options)
            local colorName = options.Name or "Color Picker"
            local state = options.Default or Color3.fromRGB(255, 255, 255)
            local callback = options.Callback or function() end

            local ColorFrame = Create("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36)
            })
            Create("UICorner", { Parent = ColorFrame, CornerRadius = UDim.new(0, 6) })
            Create("UIStroke", { Parent = ColorFrame, Color = Theme.Outline, Thickness = 1 })

            Create("TextLabel", {
                Parent = ColorFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = colorName,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local DisplayColor = Create("Frame", {
                Parent = ColorFrame,
                BackgroundColor3 = state,
                Position = UDim2.new(1, -40, 0.5, -10),
                Size = UDim2.new(0, 30, 0, 20)
            })
            Create("UICorner", { Parent = DisplayColor, CornerRadius = UDim.new(0, 4) })
            Create("UIStroke", { Parent = DisplayColor, Color = Theme.Outline, Thickness = 1 })

            local ClickBtn = Create("TextButton", { Parent = ColorFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })

            ClickBtn.MouseButton1Click:Connect(function()
                -- For simplicity in a single file library, clicking cycle random colors or predefined ones
                -- A full RGB UI is bulky. Here we just set random color for demonstration.
                local c = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
                state = c
                TweenService:Create(DisplayColor, TweenInfo.new(0.2), {BackgroundColor3 = state}):Play()
                callback(state)
            end)

            return { Set = function(self, color) state = color; DisplayColor.BackgroundColor3 = color; callback(color) end }
        end

        return Elements
    end

    return WindowConfig
end

return Library
