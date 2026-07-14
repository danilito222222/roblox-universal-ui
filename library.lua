-- ============================================================
--  Universal UI Library  |  by NochHawk  |  AI Generated
--  Modern, premium, open-source Roblox UI Library
-- ============================================================

local Library = {}
Library.__index = Library

local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ┌─────────────────────────────────────────────────────────┐
-- │                        THEME                            │
-- └─────────────────────────────────────────────────────────┘
local T = {
    Bg        = Color3.fromRGB(18,  18,  20 ),
    Surface   = Color3.fromRGB(26,  26,  30 ),
    Elevated  = Color3.fromRGB(34,  34,  38 ),
    Border    = Color3.fromRGB(55,  55,  62 ),
    Accent    = Color3.fromRGB(124, 58,  237),  -- violet-600
    AccentHov = Color3.fromRGB(139, 92,  246),  -- violet-500
    Success   = Color3.fromRGB(34,  197, 94 ),
    Danger    = Color3.fromRGB(239, 68,  68 ),
    Text      = Color3.fromRGB(250, 250, 252),
    TextMuted = Color3.fromRGB(150, 150, 165),
}

-- ┌─────────────────────────────────────────────────────────┐
-- │                  UTILITY / HELPERS                      │
-- └─────────────────────────────────────────────────────────┘
local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            o[k] = v
        end
    end
    if props.Parent then o.Parent = props.Parent end
    return o
end

local function Tween(obj, t, props, style, dir)
    local ti = TweenInfo.new(t, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, ti, props)
    tw:Play()
    return tw
end

local function Corner(r, parent)
    return New("UICorner", { CornerRadius = UDim.new(0, r), Parent = parent })
end

local function Stroke(c, t, parent)
    return New("UIStroke", { Color = c, Thickness = t, Parent = parent })
end

-- ┌─────────────────────────────────────────────────────────┐
-- │                   ROOT SCREENGUI                        │
-- └─────────────────────────────────────────────────────────┘
local Root = New("ScreenGui", {
    Name            = "NochHawkUI",
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn    = false,
    IgnoreGuiInset  = true,
})

local ok = pcall(function() Root.Parent = CoreGui end)
if not ok then
    Root.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- ┌─────────────────────────────────────────────────────────┐
-- │               NOTIFICATION SYSTEM                       │
-- └─────────────────────────────────────────────────────────┘
local NotifHolder = New("Frame", {
    Parent              = Root,
    BackgroundTransparency = 1,
    Position            = UDim2.new(1, -320, 1, -20),
    Size                = UDim2.new(0, 300, 1, 0),
    AnchorPoint         = Vector2.new(0, 1),
    ClipsDescendants    = false,
})
New("UIListLayout", {
    Parent             = NotifHolder,
    SortOrder          = Enum.SortOrder.LayoutOrder,
    Padding            = UDim.new(0, 8),
    VerticalAlignment  = Enum.VerticalAlignment.Bottom,
})

function Library:Notify(opts)
    local title    = opts.Title    or "Notice"
    local text     = opts.Text     or ""
    local duration = opts.Duration or 4
    local ntype    = opts.Type     or "info"   -- "info" | "success" | "error"

    local accentCol = ntype == "success" and T.Success
                   or ntype == "error"   and T.Danger
                   or T.Accent

    local Card = New("Frame", {
        Parent              = NotifHolder,
        BackgroundColor3    = T.Surface,
        Size                = UDim2.new(1, 0, 0, 76),
        BackgroundTransparency = 1,
    })
    Corner(10, Card)
    local stroke = Stroke(T.Border, 1, Card)

    -- Accent left bar
    New("Frame", {
        Parent           = Card,
        BackgroundColor3 = accentCol,
        Position         = UDim2.new(0, 0, 0.15, 0),
        Size             = UDim2.new(0, 3, 0.7, 0),
    })

    local TitleLbl = New("TextLabel", {
        Parent              = Card,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 15, 0, 10),
        Size                = UDim2.new(1, -25, 0, 20),
        Font                = Enum.Font.GothamBold,
        Text                = title,
        TextColor3          = T.Text,
        TextSize            = 14,
        TextXAlignment      = Enum.TextXAlignment.Left,
        TextTransparency    = 1,
    })
    local BodyLbl = New("TextLabel", {
        Parent              = Card,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 15, 0, 30),
        Size                = UDim2.new(1, -25, 0, 32),
        Font                = Enum.Font.Gotham,
        Text                = text,
        TextColor3          = T.TextMuted,
        TextSize            = 12,
        TextXAlignment      = Enum.TextXAlignment.Left,
        TextWrapped         = true,
        TextTransparency    = 1,
    })

    -- Timer bar
    local TimerBG = New("Frame", {
        Parent           = Card,
        BackgroundColor3 = T.Elevated,
        Position         = UDim2.new(0, 15, 1, -8),
        Size             = UDim2.new(1, -30, 0, 3),
        BackgroundTransparency = 1,
    })
    Corner(4, TimerBG)
    local TimerFill = New("Frame", {
        Parent           = TimerBG,
        BackgroundColor3 = accentCol,
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
    })
    Corner(4, TimerFill)

    -- Slide in from right
    Card.Position = UDim2.new(1, 20, 0, 0)
    Tween(Card, 0.35, { BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0) })
    Tween(stroke, 0.35, { Transparency = 0 })
    Tween(TitleLbl, 0.35, { TextTransparency = 0 })
    Tween(BodyLbl,  0.35, { TextTransparency = 0 })
    Tween(TimerBG,  0.35, { BackgroundTransparency = 0 })
    Tween(TimerFill,0.35, { BackgroundTransparency = 0 })

    -- Bug fix: use task.delay instead of Tween.Completed to avoid "Cancelled" misfire
    task.delay(0.35, function()
        Tween(TimerFill, duration, { Size = UDim2.new(0, 0, 1, 0) }, Enum.EasingStyle.Linear)
    end)

    task.delay(0.35 + duration, function()
        Tween(Card,      0.3, { BackgroundTransparency = 1, Position = UDim2.new(1, 20, 0, 0) })
        Tween(stroke,    0.3, { Transparency = 1 })
        Tween(TitleLbl,  0.3, { TextTransparency = 1 })
        Tween(BodyLbl,   0.3, { TextTransparency = 1 })
        Tween(TimerBG,   0.3, { BackgroundTransparency = 1 })
        Tween(TimerFill, 0.3, { BackgroundTransparency = 1 })
        task.delay(0.3, function() Card:Destroy() end)
    end)
end

-- ┌─────────────────────────────────────────────────────────┐
-- │                     DRAG LOGIC                          │
-- └─────────────────────────────────────────────────────────┘
local function MakeDraggable(handle, frame)
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos  = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp == dragInput then
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + d.X,
                startPos.Y.Scale,
                startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- ┌─────────────────────────────────────────────────────────┐
-- │                   CREATE WINDOW                         │
-- └─────────────────────────────────────────────────────────┘
function Library:CreateWindow(opts)
    local title   = opts.Title   or "NochHawk UI"
    local togKey  = opts.ToggleKey or Enum.KeyCode.RightShift

    -- ── Main container ──────────────────────────────────────
    local Win = New("Frame", {
        Parent           = Root,
        Name             = "Window",
        BackgroundColor3 = T.Bg,
        Position         = UDim2.new(0.5, -290, 0.5, -190),
        Size             = UDim2.new(0, 580, 0, 380),
        ClipsDescendants = true,   -- FIX: prevents elements overflowing
    })
    Corner(12, Win)
    Stroke(T.Border, 1, Win)

    -- ── Top bar ─────────────────────────────────────────────
    local Topbar = New("Frame", {
        Parent           = Win,
        BackgroundColor3 = T.Surface,
        Size             = UDim2.new(1, 0, 0, 48),
        BorderSizePixel  = 0,
    })
    -- only top corners rounded (manual via clip)
    New("Frame", {
        Parent           = Topbar,
        BackgroundColor3 = T.Surface,
        Position         = UDim2.new(0, 0, 1, -10),
        Size             = UDim2.new(1, 0, 0, 10),
        BorderSizePixel  = 0,
    })
    MakeDraggable(Topbar, Win)

    -- Accent dot decoration
    local AccentDot = New("Frame", {
        Parent           = Topbar,
        BackgroundColor3 = T.Accent,
        Position         = UDim2.new(0, 16, 0.5, -6),
        Size             = UDim2.new(0, 12, 0, 12),
    })
    Corner(6, AccentDot)

    -- Title
    New("TextLabel", {
        Parent              = Topbar,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 38, 0, 0),
        Size                = UDim2.new(1, -90, 1, 0),
        Font                = Enum.Font.GothamBold,
        Text                = title,
        TextColor3          = T.Text,
        TextSize            = 15,
        TextXAlignment      = Enum.TextXAlignment.Left,
    })

    -- Close button
    local CloseBtn = New("TextButton", {
        Parent              = Topbar,
        BackgroundColor3    = Color3.fromRGB(239, 68, 68),
        BackgroundTransparency = 1,
        Position            = UDim2.new(1, -40, 0.5, -12),
        Size                = UDim2.new(0, 24, 0, 24),
        Font                = Enum.Font.GothamBold,
        Text                = "",
        TextColor3          = T.Text,
        TextSize            = 14,
        AutoButtonColor     = false,
    })
    Corner(6, CloseBtn)

    -- X icon inside close button
    New("TextLabel", {
        Parent              = CloseBtn,
        BackgroundTransparency = 1,
        Size                = UDim2.new(1, 0, 1, 0),
        Font                = Enum.Font.GothamBold,
        Text                = "✕",
        TextColor3          = T.TextMuted,
        TextSize            = 12,
    })

    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, 0.2, { BackgroundTransparency = 0 })
        CloseBtn:FindFirstChildWhichIsA("TextLabel").TextColor3 = T.Text
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, 0.2, { BackgroundTransparency = 1 })
        CloseBtn:FindFirstChildWhichIsA("TextLabel").TextColor3 = T.TextMuted
    end)
    CloseBtn.MouseButton1Click:Connect(function() Root:Destroy() end)

    -- Separator line under topbar
    New("Frame", {
        Parent           = Win,
        BackgroundColor3 = T.Border,
        Position         = UDim2.new(0, 0, 0, 48),
        Size             = UDim2.new(1, 0, 0, 1),
        BorderSizePixel  = 0,
    })

    -- Toggle visibility keybind (fixed: check processed flag)
    UserInputService.InputBegan:Connect(function(inp, processed)
        if not processed and inp.KeyCode == togKey then
            Win.Visible = not Win.Visible
        end
    end)

    -- ── Sidebar ─────────────────────────────────────────────
    local SideW = 145

    local Sidebar = New("Frame", {
        Parent           = Win,
        BackgroundColor3 = T.Surface,
        Position         = UDim2.new(0, 0, 0, 49),
        Size             = UDim2.new(0, SideW, 1, -49),
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    })

    -- Vertical right border
    New("Frame", {
        Parent           = Sidebar,
        BackgroundColor3 = T.Border,
        Position         = UDim2.new(1, -1, 0, 0),
        Size             = UDim2.new(0, 1, 1, 0),
        BorderSizePixel  = 0,
    })

    local TabScroll = New("ScrollingFrame", {
        Parent                = Sidebar,
        Active                = true,
        BackgroundTransparency = 1,
        Position              = UDim2.new(0, 0, 0, 12),
        Size                  = UDim2.new(1, 0, 1, -44),
        ScrollBarThickness    = 0,
        AutomaticCanvasSize   = Enum.AutomaticSize.Y,
        CanvasSize            = UDim2.new(0, 0, 0, 0),
    })
    New("UIListLayout", {
        Parent            = TabScroll,
        SortOrder         = Enum.SortOrder.LayoutOrder,
        Padding           = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    })
    New("UIPadding", { Parent = TabScroll, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })

    -- Watermark at bottom of sidebar
    New("TextLabel", {
        Parent              = Sidebar,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 0, 1, -34),
        Size                = UDim2.new(1, 0, 0, 34),
        Font                = Enum.Font.Gotham,
        Text                = "by NochHawk",
        TextColor3          = T.TextMuted,
        TextSize            = 10,
        TextTransparency    = 0.4,
    })

    -- ── Content Area ────────────────────────────────────────
    local ContentArea = New("Frame", {
        Parent              = Win,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, SideW, 0, 49),
        Size                = UDim2.new(1, -SideW, 1, -49),
        ClipsDescendants    = true,
    })

    -- ── Window API ──────────────────────────────────────────
    local W = { _activeTab = nil }

    function W:CreateTab(name)
        -- Tab button
        local Btn = New("TextButton", {
            Parent              = TabScroll,
            BackgroundColor3    = T.Elevated,
            BackgroundTransparency = 1,
            Size                = UDim2.new(1, 0, 0, 34),
            Font                = Enum.Font.GothamSemibold,
            Text                = name,
            TextColor3          = T.TextMuted,
            TextSize            = 13,
            AutoButtonColor     = false,
        })
        Corner(8, Btn)

        -- Active indicator pill on the left
        local Pill = New("Frame", {
            Parent           = Btn,
            BackgroundColor3 = T.Accent,
            Position         = UDim2.new(0, 0, 0.2, 0),
            Size             = UDim2.new(0, 3, 0.6, 0),
            BackgroundTransparency = 1,
        })
        Corner(4, Pill)

        -- Content scroll
        local Scroll = New("ScrollingFrame", {
            Parent                = ContentArea,
            Active                = true,
            BackgroundTransparency = 1,
            Size                  = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness    = 3,
            ScrollBarImageColor3  = T.Accent,
            AutomaticCanvasSize   = Enum.AutomaticSize.Y,
            CanvasSize            = UDim2.new(0, 0, 0, 0),
            ScrollingDirection    = Enum.ScrollingDirection.Y,
            Visible               = false,
        })
        New("UIPadding", {
            Parent        = Scroll,
            PaddingTop    = UDim.new(0, 14),
            PaddingLeft   = UDim.new(0, 14),
            PaddingRight  = UDim.new(0, 14),
            PaddingBottom = UDim.new(0, 14),
        })
        New("UIListLayout", {
            Parent    = Scroll,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding   = UDim.new(0, 9),
        })

        local function activate()
            -- Deactivate all
            for _, c in pairs(TabScroll:GetChildren()) do
                if c:IsA("TextButton") then
                    Tween(c, 0.2, { BackgroundTransparency = 1, TextColor3 = T.TextMuted })
                    local p = c:FindFirstChild("Frame")
                    if p then Tween(p, 0.2, { BackgroundTransparency = 1 }) end
                end
            end
            for _, c in pairs(ContentArea:GetChildren()) do
                if c:IsA("ScrollingFrame") then c.Visible = false end
            end
            -- Activate this tab
            Tween(Btn, 0.2, { BackgroundTransparency = 0, TextColor3 = T.Text })
            Tween(Pill, 0.2, { BackgroundTransparency = 0 })
            Scroll.Visible = true
            W._activeTab = Btn
        end

        Btn.MouseButton1Click:Connect(activate)

        -- Auto-activate first tab
        if not W._activeTab then activate() end

        -- ── Element helpers ──────────────────────────────────
        local E = {}

        -- SECTION
        function E:CreateSection(sname)
            local Row = New("Frame", {
                Parent              = Scroll,
                BackgroundTransparency = 1,
                Size                = UDim2.new(1, 0, 0, 22),
            })
            New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Size                = UDim2.new(1, -4, 1, 0),
                Font                = Enum.Font.GothamBold,
                Text                = sname:upper(),
                TextColor3          = T.Accent,
                TextSize            = 10,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })
            New("Frame", {
                Parent           = Row,
                BackgroundColor3 = T.Border,
                Position         = UDim2.new(0, 0, 1, -1),
                Size             = UDim2.new(1, 0, 0, 1),
                BorderSizePixel  = 0,
            })
        end

        -- BUTTON
        function E:CreateButton(opts2)
            local bname = opts2.Name or "Button"
            local cb    = opts2.Callback or function() end

            local Btn2 = New("TextButton", {
                Parent           = Scroll,
                BackgroundColor3 = T.Elevated,
                Size             = UDim2.new(1, 0, 0, 36),
                Font             = Enum.Font.GothamSemibold,
                Text             = bname,
                TextColor3       = T.Text,
                TextSize         = 13,
                AutoButtonColor  = false,
            })
            Corner(8, Btn2)
            Stroke(T.Border, 1, Btn2)

            Btn2.MouseEnter:Connect(function() Tween(Btn2, 0.18, { BackgroundColor3 = T.Accent }) end)
            Btn2.MouseLeave:Connect(function() Tween(Btn2, 0.18, { BackgroundColor3 = T.Elevated }) end)
            Btn2.MouseButton1Click:Connect(function()
                Tween(Btn2, 0.08, { BackgroundColor3 = T.AccentHov })
                task.delay(0.1, function() Tween(Btn2, 0.18, { BackgroundColor3 = T.Elevated }) end)
                cb()
            end)

            return { Set = function(_, t2) Btn2.Text = t2 end }
        end

        -- TOGGLE
        function E:CreateToggle(opts2)
            local tname = opts2.Name    or "Toggle"
            local state = opts2.Default or false
            local cb    = opts2.Callback or function() end

            local Row = New("Frame", {
                Parent           = Scroll,
                BackgroundColor3 = T.Elevated,
                Size             = UDim2.new(1, 0, 0, 36),
            })
            Corner(8, Row)
            Stroke(T.Border, 1, Row)

            New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 0),
                Size                = UDim2.new(1, -62, 1, 0),
                Font                = Enum.Font.GothamSemibold,
                Text                = tname,
                TextColor3          = T.Text,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })

            local Track = New("Frame", {
                Parent           = Row,
                BackgroundColor3 = state and T.Accent or T.Border,
                Position         = UDim2.new(1, -50, 0.5, -11),
                Size             = UDim2.new(0, 38, 0, 22),
            })
            Corner(11, Track)

            local Thumb = New("Frame", {
                Parent           = Track,
                BackgroundColor3 = T.Text,
                Position         = state and UDim2.new(1, -19, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                Size             = UDim2.new(0, 18, 0, 18),
            })
            Corner(9, Thumb)

            -- FIX: invisible click zone on the track (not full row) to prevent blocking labels
            local HitZone = New("TextButton", {
                Parent              = Track,
                BackgroundTransparency = 1,
                Size                = UDim2.new(1, 0, 1, 0),
                Text                = "",
            })

            local function set(v)
                state = v
                Tween(Track, 0.2, { BackgroundColor3 = v and T.Accent or T.Border })
                Tween(Thumb, 0.2, { Position = v and UDim2.new(1, -19, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) })
                cb(v)
            end

            HitZone.MouseButton1Click:Connect(function() set(not state) end)
            set(state)

            return { Set = function(_, v) set(v) end }
        end

        -- SLIDER
        function E:CreateSlider(opts2)
            local sname   = opts2.Name    or "Slider"
            local smin    = opts2.Min     or 0
            local smax    = opts2.Max     or 100
            local sval    = math.clamp(opts2.Default or smin, smin, smax)
            local isFloat = opts2.Float   or false
            local cb      = opts2.Callback or function() end

            local Row = New("Frame", {
                Parent           = Scroll,
                BackgroundColor3 = T.Elevated,
                Size             = UDim2.new(1, 0, 0, 52),
            })
            Corner(8, Row)
            Stroke(T.Border, 1, Row)

            New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 7),
                Size                = UDim2.new(0.6, 0, 0, 18),
                Font                = Enum.Font.GothamSemibold,
                Text                = sname,
                TextColor3          = T.Text,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })

            local ValLbl = New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 7),
                Size                = UDim2.new(1, -24, 0, 18),
                Font                = Enum.Font.GothamBold,
                Text                = tostring(sval),
                TextColor3          = T.Accent,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Right,
            })

            local Track = New("Frame", {
                Parent           = Row,
                BackgroundColor3 = T.Border,
                Position         = UDim2.new(0, 12, 0, 34),
                Size             = UDim2.new(1, -24, 0, 6),
            })
            Corner(3, Track)

            local Fill = New("Frame", {
                Parent           = Track,
                BackgroundColor3 = T.Accent,
                Size             = UDim2.new((sval - smin) / (smax - smin), 0, 1, 0),
            })
            Corner(3, Fill)

            -- Thumb dot on the slider track
            local ThumbDot = New("Frame", {
                Parent           = Fill,
                BackgroundColor3 = T.Text,
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(1, 0, 0.5, 0),
                Size             = UDim2.new(0, 12, 0, 12),
            })
            Corner(6, ThumbDot)

            -- FIX: larger hit area (whole Row) to make sliding easier
            local HitBtn = New("TextButton", {
                Parent              = Track,
                BackgroundTransparency = 1,
                Size                = UDim2.new(1, 0, 4, -16), -- taller hit zone
                Position            = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint         = Vector2.new(0, 0.5),
                Text                = "",
            })

            local function round(v)
                if isFloat then
                    return tonumber(string.format("%.1f", v))
                else
                    return math.floor(v + 0.5)
                end
            end

            local function setVal(px)
                local pct = math.clamp((px - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                sval = round(smin + (smax - smin) * pct)
                Tween(Fill, 0.07, { Size = UDim2.new(pct, 0, 1, 0) }, Enum.EasingStyle.Linear)
                ValLbl.Text = tostring(sval)
                cb(sval)
            end

            local dragging = false
            HitBtn.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    setVal(inp.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
                or inp.UserInputType == Enum.UserInputType.Touch) then
                    setVal(inp.Position.X)
                end
            end)

            setVal(Track.AbsolutePosition.X + ((sval - smin) / (smax - smin)) * Track.AbsoluteSize.X)
            return { Set = function(_, v) setVal(Track.AbsolutePosition.X + ((math.clamp(v, smin, smax) - smin) / (smax - smin)) * Track.AbsoluteSize.X) end }
        end

        -- DROPDOWN
        function E:CreateDropdown(opts2)
            local dname = opts2.Name    or "Dropdown"
            local items = opts2.Options or {}
            local cb    = opts2.Callback or function() end
            local open  = false
            local selected = nil

            local Wrap = New("Frame", {
                Parent           = Scroll,
                BackgroundColor3 = T.Elevated,
                Size             = UDim2.new(1, 0, 0, 36),
                ClipsDescendants = true,
            })
            Corner(8, Wrap)
            Stroke(T.Border, 1, Wrap)

            local Header = New("TextButton", {
                Parent              = Wrap,
                BackgroundTransparency = 1,
                Size                = UDim2.new(1, 0, 0, 36),
                Font                = Enum.Font.GothamSemibold,
                Text                = "  " .. dname,
                TextColor3          = T.Text,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Left,
                AutoButtonColor     = false,
            })

            local Chevron = New("TextLabel", {
                Parent              = Wrap,
                BackgroundTransparency = 1,
                Position            = UDim2.new(1, -30, 0, 0),
                Size                = UDim2.new(0, 30, 0, 36),
                Font                = Enum.Font.GothamBold,
                Text                = "▾",
                TextColor3          = T.TextMuted,
                TextSize            = 14,
            })

            local List = New("ScrollingFrame", {
                Parent                = Wrap,
                BackgroundColor3      = T.Elevated,
                Position              = UDim2.new(0, 0, 0, 37),
                Size                  = UDim2.new(1, 0, 1, -37),
                ScrollBarThickness    = 2,
                ScrollBarImageColor3  = T.Accent,
                AutomaticCanvasSize   = Enum.AutomaticSize.Y,
                CanvasSize            = UDim2.new(0, 0, 0, 0),
            })
            New("UIListLayout", { Parent = List, SortOrder = Enum.SortOrder.LayoutOrder })

            Header.MouseButton1Click:Connect(function()
                open = not open
                local h = 36 + math.min(#items * 30, 150)
                Tween(Wrap, 0.22, { Size = open and UDim2.new(1, 0, 0, h) or UDim2.new(1, 0, 0, 36) })
                Tween(Chevron, 0.22, { Rotation = open and 180 or 0 })
            end)

            for _, item in ipairs(items) do
                local Row2 = New("TextButton", {
                    Parent              = List,
                    BackgroundColor3    = T.Accent,
                    BackgroundTransparency = 1,
                    Size                = UDim2.new(1, 0, 0, 30),
                    Font                = Enum.Font.Gotham,
                    Text                = "  " .. item,
                    TextColor3          = T.TextMuted,
                    TextSize            = 12,
                    TextXAlignment      = Enum.TextXAlignment.Left,
                    AutoButtonColor     = false,
                })
                Row2.MouseEnter:Connect(function()
                    Tween(Row2, 0.15, { BackgroundTransparency = 0.85, TextColor3 = T.Text })
                end)
                Row2.MouseLeave:Connect(function()
                    Tween(Row2, 0.15, { BackgroundTransparency = 1, TextColor3 = T.TextMuted })
                end)
                Row2.MouseButton1Click:Connect(function()
                    selected = item
                    Header.Text = "  " .. dname .. " : " .. item
                    open = false
                    Tween(Wrap, 0.22, { Size = UDim2.new(1, 0, 0, 36) })
                    Tween(Chevron, 0.22, { Rotation = 0 })
                    cb(item)
                end)
            end

            return {
                Set = function(_, v)
                    selected = v
                    Header.Text = "  " .. dname .. " : " .. v
                    cb(v)
                end,
                GetSelected = function(_) return selected end,
            }
        end

        -- TEXTBOX
        function E:CreateTextBox(opts2)
            local bname   = opts2.Name    or "TextBox"
            local default = opts2.Default or ""
            local cb      = opts2.Callback or function() end

            local Row = New("Frame", {
                Parent           = Scroll,
                BackgroundColor3 = T.Elevated,
                Size             = UDim2.new(1, 0, 0, 36),
            })
            Corner(8, Row)
            local rowStroke = Stroke(T.Border, 1, Row)

            New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 0),
                Size                = UDim2.new(0.4, 0, 1, 0),
                Font                = Enum.Font.GothamSemibold,
                Text                = bname,
                TextColor3          = T.Text,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })

            local Box = New("TextBox", {
                Parent              = Row,
                BackgroundColor3    = T.Bg,
                Position            = UDim2.new(0.42, 0, 0.5, -13),
                Size                = UDim2.new(0.56, 0, 0, 26),
                Font                = Enum.Font.Gotham,
                Text                = default,
                PlaceholderText     = "Enter text...",
                PlaceholderColor3   = T.TextMuted,
                TextColor3          = T.Text,
                TextSize            = 12,
                ClearTextOnFocus    = false,
            })
            Corner(6, Box)
            Stroke(T.Border, 1, Box)

            Box.Focused:Connect(function()
                Tween(rowStroke, 0.2, { Color = T.Accent })
            end)
            Box.FocusLost:Connect(function()
                Tween(rowStroke, 0.2, { Color = T.Border })
                cb(Box.Text)
            end)

            return { Set = function(_, v) Box.Text = v; cb(v) end }
        end

        -- KEYBIND
        function E:CreateKeybind(opts2)
            local kname  = opts2.Name     or "Keybind"
            local defKey = opts2.Default  or Enum.KeyCode.E
            local cb     = opts2.Callback or function() end
            local curKey = defKey
            local conn
            local listening = false

            local Row = New("Frame", {
                Parent           = Scroll,
                BackgroundColor3 = T.Elevated,
                Size             = UDim2.new(1, 0, 0, 36),
            })
            Corner(8, Row)
            Stroke(T.Border, 1, Row)

            New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 0),
                Size                = UDim2.new(1, -110, 1, 0),
                Font                = Enum.Font.GothamSemibold,
                Text                = kname,
                TextColor3          = T.Text,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })

            local KBtn = New("TextButton", {
                Parent           = Row,
                BackgroundColor3 = T.Bg,
                Position         = UDim2.new(1, -98, 0.5, -13),
                Size             = UDim2.new(0, 88, 0, 26),
                Font             = Enum.Font.GothamBold,
                Text             = "[" .. curKey.Name .. "]",
                TextColor3       = T.TextMuted,
                TextSize         = 11,
                AutoButtonColor  = false,
            })
            Corner(6, KBtn)
            Stroke(T.Border, 1, KBtn)

            KBtn.MouseButton1Click:Connect(function()
                if conn then conn:Disconnect() end
                listening = true
                KBtn.Text      = "[ ... ]"
                KBtn.TextColor3 = T.Accent
                conn = UserInputService.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.Keyboard
                    and inp.KeyCode ~= Enum.KeyCode.Unknown then
                        curKey         = inp.KeyCode
                        KBtn.Text      = "[" .. curKey.Name .. "]"
                        KBtn.TextColor3 = T.TextMuted
                        listening      = false
                        conn:Disconnect()
                    end
                end)
            end)

            -- FIX: only fire when not listening and not text-focused
            UserInputService.InputBegan:Connect(function(inp, processed)
                if not processed and not listening and inp.KeyCode == curKey then
                    cb()
                end
            end)

            return { Set = function(_, k) curKey = k; KBtn.Text = "[" .. k.Name .. "]" end }
        end

        -- COLOR PICKER (compact RGB input)
        function E:CreateColorPicker(opts2)
            local cname = opts2.Name     or "Color"
            local state = opts2.Default  or Color3.fromRGB(255, 80, 80)
            local cb    = opts2.Callback or function() end

            local Row = New("Frame", {
                Parent           = Scroll,
                BackgroundColor3 = T.Elevated,
                Size             = UDim2.new(1, 0, 0, 36),
            })
            Corner(8, Row)
            Stroke(T.Border, 1, Row)

            New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 0),
                Size                = UDim2.new(1, -100, 1, 0),
                Font                = Enum.Font.GothamSemibold,
                Text                = cname,
                TextColor3          = T.Text,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })

            local Preview = New("Frame", {
                Parent           = Row,
                BackgroundColor3 = state,
                Position         = UDim2.new(1, -88, 0.5, -11),
                Size             = UDim2.new(0, 30, 0, 22),
            })
            Corner(6, Preview)
            Stroke(T.Border, 1, Preview)

            -- Small hex label
            local HexLbl = New("TextButton", {
                Parent              = Row,
                BackgroundColor3    = T.Bg,
                Position            = UDim2.new(1, -55, 0.5, -11),
                Size                = UDim2.new(0, 48, 0, 22),
                Font                = Enum.Font.Code,
                Text                = string.format("#%02X%02X%02X",
                    math.floor(state.R * 255),
                    math.floor(state.G * 255),
                    math.floor(state.B * 255)),
                TextColor3          = T.TextMuted,
                TextSize            = 10,
                AutoButtonColor     = false,
            })
            Corner(6, HexLbl)
            Stroke(T.Border, 1, HexLbl)

            -- Click preview to cycle hue
            local hue = 0
            HexLbl.MouseButton1Click:Connect(function()
                hue = (hue + 0.1) % 1
                state = Color3.fromHSV(hue, 1, 1)
                Tween(Preview, 0.2, { BackgroundColor3 = state })
                HexLbl.Text = string.format("#%02X%02X%02X",
                    math.floor(state.R * 255),
                    math.floor(state.G * 255),
                    math.floor(state.B * 255))
                cb(state)
            end)

            return {
                Set = function(_, c)
                    state            = c
                    Preview.BackgroundColor3 = c
                    HexLbl.Text      = string.format("#%02X%02X%02X",
                        math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255))
                    cb(c)
                end
            }
        end

        return E
    end -- CreateTab

    return W
end -- CreateWindow

return Library
