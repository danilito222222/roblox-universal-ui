local Library = {}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(30, 30, 35),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(85, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Element = Color3.fromRGB(40, 40, 45),
    ElementHover = Color3.fromRGB(50, 50, 55),
}

-- Utility function for creating instances
local function Create(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        inst[k] = v
    end
    return inst
end

-- Dragging logic
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
        Tween:Play()
    end

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
            Update(input)
        end
    end)
end

function Library:CreateWindow(options)
    local title = options.Title or "UI Library"
    
    local ScreenGui = Create("ScreenGui", {
        Name = "UniversalLibrary",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Try to parent to CoreGui, fallback to PlayerGui
    local success, err = pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not success then
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0.5, -250, 0.5, -175),
        Size = UDim2.new(0, 500, 0, 350),
        ClipsDescendants = true
    })
    Create("UICorner", { Parent = MainFrame, CornerRadius = UDim.new(0, 8) })

    local Topbar = Create("Frame", {
        Name = "Topbar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0
    })
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
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
        Position = UDim2.new(1, -40, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Theme.TextDark,
        TextSize = 16
    })
    
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDark}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Sidebar,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 130, 1, -40),
        BorderSizePixel = 0
    })
    
    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Sidebar,
        Active = true,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -40),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    local TabListLayout = Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    local Watermark = Create("TextLabel", {
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
        Position = UDim2.new(0, 130, 0, 40),
        Size = UDim2.new(1, -130, 1, -40)
    })

    local WindowConfig = {
        CurrentTab = nil
    }

    function WindowConfig:CreateTab(tabName)
        local TabButton = Create("TextButton", {
            Name = tabName .. "Tab",
            Parent = TabContainer,
            BackgroundColor3 = Theme.Sidebar,
            Size = UDim2.new(1, -10, 0, 30),
            Font = Enum.Font.GothamSemibold,
            Text = tabName,
            TextColor3 = Theme.TextDark,
            TextSize = 14,
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
            BorderSizePixel = 0,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        Create("UIPadding", { Parent = TabContent, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10) })
        local ContentListLayout = Create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        
        ContentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentListLayout.AbsoluteContentSize.Y + 20)
        end)
        TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.2), {TextColor3 = Theme.TextDark, BackgroundTransparency = 1}):Play()
                end
            end
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundTransparency = 0, BackgroundColor3 = Theme.Element}):Play()
            TabContent.Visible = true
        end)

        if not WindowConfig.CurrentTab then
            WindowConfig.CurrentTab = TabButton
            TabButton.TextColor3 = Theme.Text
            TabButton.BackgroundTransparency = 0
            TabButton.BackgroundColor3 = Theme.Element
            TabContent.Visible = true
        end

        local Elements = {}

        function Elements:CreateButton(options)
            local btnName = options.Name or "Button"
            local callback = options.Callback or function() end

            local Button = Create("TextButton", {
                Name = "Button",
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36),
                Font = Enum.Font.GothamSemibold,
                Text = btnName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                AutoButtonColor = false
            })
            Create("UICorner", { Parent = Button, CornerRadius = UDim.new(0, 6) })

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementHover}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element}):Play()
            end)
            Button.MouseButton1Click:Connect(function()
                local ripple = Create("Frame", {
                    Parent = Button,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.8,
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5)
                })
                Create("UICorner", { Parent = ripple, CornerRadius = UDim.new(1, 0) })
                local t = TweenService:Create(ripple, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1})
                t:Play()
                t.Completed:Connect(function() ripple:Destroy() end)
                callback()
            end)
        end

        function Elements:CreateToggle(options)
            local togName = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            local state = default

            local ToggleFrame = Create("Frame", {
                Name = "ToggleFrame",
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36)
            })
            Create("UICorner", { Parent = ToggleFrame, CornerRadius = UDim.new(0, 6) })
            
            local ToggleLabel = Create("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = togName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ToggleOuter = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60, 60, 65),
                Position = UDim2.new(1, -45, 0.5, -10),
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
            
            local ToggleBtn = Create("TextButton", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(ToggleOuter, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60, 60, 65)}):Play()
                TweenService:Create(ToggleInner, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                callback(state)
            end)
            
            callback(state)
        end

        function Elements:CreateSlider(options)
            local sliderName = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end

            local SliderFrame = Create("Frame", {
                Name = "SliderFrame",
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 50)
            })
            Create("UICorner", { Parent = SliderFrame, CornerRadius = UDim.new(0, 6) })

            local SliderLabel = Create("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = sliderName .. " - " .. tostring(default),
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SliderBG = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(60, 60, 65),
                Position = UDim2.new(0, 10, 0, 30),
                Size = UDim2.new(1, -20, 0, 6)
            })
            Create("UICorner", { Parent = SliderBG, CornerRadius = UDim.new(1, 0) })

            local SliderFill = Create("Frame", {
                Parent = SliderBG,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            })
            Create("UICorner", { Parent = SliderFill, CornerRadius = UDim.new(1, 0) })

            local SliderBtn = Create("TextButton", {
                Parent = SliderBG,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            local dragging = false
            local function updateSlider(input)
                local percentage = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + ((max - min) * percentage))
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderLabel.Text = sliderName .. " - " .. tostring(value)
                callback(value)
            end

            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)
            SliderBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
        end

        function Elements:CreateDropdown(options)
            local dropName = options.Name or "Dropdown"
            local list = options.Options or {}
            local callback = options.Callback or function() end
            local isOpen = false

            local DropdownFrame = Create("Frame", {
                Name = "DropdownFrame",
                Parent = TabContent,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36),
                ClipsDescendants = true
            })
            Create("UICorner", { Parent = DropdownFrame, CornerRadius = UDim.new(0, 6) })

            local DropdownBtn = Create("TextButton", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 36),
                Font = Enum.Font.GothamSemibold,
                Text = "  " .. dropName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Icon = Create("TextLabel", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0, 30, 0, 36),
                Font = Enum.Font.GothamSemibold,
                Text = "+",
                TextColor3 = Theme.Text,
                TextSize = 18
            })

            local DropdownList = Create("ScrollingFrame", {
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 36),
                Size = UDim2.new(1, 0, 1, -36),
                ScrollBarThickness = 2,
                CanvasSize = UDim2.new(0, 0, 0, #list * 30)
            })
            local DropLayout = Create("UIListLayout", {
                Parent = DropdownList,
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            DropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local targetSize = isOpen and UDim2.new(1, 0, 0, 36 + math.min(#list * 30, 120)) or UDim2.new(1, 0, 0, 36)
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
                Icon.Text = isOpen and "-" or "+"
            end)

            for _, item in ipairs(list) do
                local ItemBtn = Create("TextButton", {
                    Parent = DropdownList,
                    BackgroundColor3 = Theme.ElementHover,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = item,
                    TextColor3 = Theme.TextDark,
                    TextSize = 13
                })
                ItemBtn.MouseEnter:Connect(function() ItemBtn.BackgroundTransparency = 0 end)
                ItemBtn.MouseLeave:Connect(function() ItemBtn.BackgroundTransparency = 1 end)
                ItemBtn.MouseButton1Click:Connect(function()
                    DropdownBtn.Text = "  " .. dropName .. " : " .. item
                    isOpen = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                    Icon.Text = "+"
                    callback(item)
                end)
            end
        end

        return Elements
    end

    return WindowConfig
end

return Library
