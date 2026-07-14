-- ============================================================
--  Universal UI Library  |  by NochHawk  |  AI Generated
--  v4 - Clean modern design, no broken icons
-- ============================================================

local Library = {}

local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ─────────────────────────────────────────────────────────────
--  THEME
-- ─────────────────────────────────────────────────────────────
local T = {
    Bg       = Color3.fromRGB(15,  15,  18 ),
    Panel    = Color3.fromRGB(22,  22,  26 ),
    Card     = Color3.fromRGB(30,  30,  35 ),
    CardHov  = Color3.fromRGB(38,  38,  44 ),
    Border   = Color3.fromRGB(50,  50,  58 ),
    Accent   = Color3.fromRGB(108, 99,  255),
    AccentHi = Color3.fromRGB(138, 132, 255),
    Green    = Color3.fromRGB(52,  211, 153),
    Red      = Color3.fromRGB(248, 113, 113),
    Text     = Color3.fromRGB(245, 245, 250),
    Muted    = Color3.fromRGB(130, 130, 150),
}

-- ─────────────────────────────────────────────────────────────
--  HELPERS
-- ─────────────────────────────────────────────────────────────
local function New(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props) do
        if k ~= "Parent" then o[k] = v end
    end
    if props.Parent then o.Parent = props.Parent end
    return o
end

local function Tween(obj, dur, goal, style)
    local tw = TweenService:Create(
        obj,
        TweenInfo.new(dur, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        goal
    )
    tw:Play()
    return tw
end

local function Corner(r, p) New("UICorner", { CornerRadius = UDim.new(0,r), Parent = p }) end
local function Stroke(col, th, p) New("UIStroke", { Color = col, Thickness = th, Parent = p }) end

-- ─────────────────────────────────────────────────────────────
--  SCREENGUI ROOT
-- ─────────────────────────────────────────────────────────────
local Root = New("ScreenGui", {
    Name           = "NochHawkUI_v4",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn   = false,
    IgnoreGuiInset = true,
})
local ok = pcall(function() Root.Parent = CoreGui end)
if not ok then
    Root.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- ─────────────────────────────────────────────────────────────
--  NOTIFICATIONS
-- ─────────────────────────────────────────────────────────────
local NotifHolder = New("Frame", {
    Parent              = Root,
    BackgroundTransparency = 1,
    Position            = UDim2.new(1, -316, 1, -16),
    Size                = UDim2.new(0, 300, 1, 0),
    AnchorPoint         = Vector2.new(0, 1),
})
New("UIListLayout", {
    Parent            = NotifHolder,
    SortOrder         = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding           = UDim.new(0, 8),
})

function Library:Notify(opts)
    local title    = opts.Title    or "Notice"
    local body     = opts.Text     or ""
    local dur      = opts.Duration or 4
    local ntype    = opts.Type     or "info"

    local barCol = (ntype == "success") and T.Green
               or (ntype == "error")   and T.Red
               or T.Accent

    -- Card
    local Card = New("Frame", {
        Parent              = NotifHolder,
        BackgroundColor3    = T.Panel,
        Size                = UDim2.new(1, 0, 0, 72),
        BackgroundTransparency = 1,
        ClipsDescendants    = true,
    })
    Corner(10, Card)
    local cs = Stroke(T.Border, 1, Card)

    -- Left accent strip
    New("Frame", {
        Parent           = Card,
        BackgroundColor3 = barCol,
        Position         = UDim2.new(0, 0, 0.1, 0),
        Size             = UDim2.new(0, 3, 0.8, 0),
        BorderSizePixel  = 0,
    })

    local TLbl = New("TextLabel", {
        Parent              = Card,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 16, 0, 10),
        Size                = UDim2.new(1, -20, 0, 18),
        Font                = Enum.Font.GothamBold,
        Text                = title,
        TextColor3          = T.Text,
        TextSize            = 13,
        TextXAlignment      = Enum.TextXAlignment.Left,
        TextTransparency    = 1,
    })
    local BLbl = New("TextLabel", {
        Parent              = Card,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 16, 0, 29),
        Size                = UDim2.new(1, -20, 0, 28),
        Font                = Enum.Font.Gotham,
        Text                = body,
        TextColor3          = T.Muted,
        TextSize            = 12,
        TextXAlignment      = Enum.TextXAlignment.Left,
        TextWrapped         = true,
        TextTransparency    = 1,
    })

    -- Timer bar at bottom
    local TimerTrack = New("Frame", {
        Parent           = Card,
        BackgroundColor3 = T.Card,
        Position         = UDim2.new(0, 16, 1, -7),
        Size             = UDim2.new(1, -32, 0, 3),
        BackgroundTransparency = 1,
    })
    Corner(2, TimerTrack)
    local TimerFill = New("Frame", {
        Parent           = TimerTrack,
        BackgroundColor3 = barCol,
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
    })
    Corner(2, TimerFill)

    -- Slide in from right
    Card.Position = UDim2.new(1, 16, 0, 0)
    Tween(Card,       0.3, { BackgroundTransparency = 0, Position = UDim2.new(0,0,0,0) })
    Tween(cs,         0.3, { Transparency = 0 })
    Tween(TLbl,       0.3, { TextTransparency = 0 })
    Tween(BLbl,       0.3, { TextTransparency = 0 })
    Tween(TimerTrack, 0.3, { BackgroundTransparency = 0 })
    Tween(TimerFill,  0.3, { BackgroundTransparency = 0 })

    task.delay(0.3, function()
        Tween(TimerFill, dur, { Size = UDim2.new(0,0,1,0) }, Enum.EasingStyle.Linear)
    end)
    task.delay(0.3 + dur, function()
        Tween(Card, 0.3, { BackgroundTransparency = 1, Position = UDim2.new(1,16,0,0) })
        Tween(cs,   0.3, { Transparency = 1 })
        Tween(TLbl, 0.3, { TextTransparency = 1 })
        Tween(BLbl, 0.3, { TextTransparency = 1 })
        Tween(TimerTrack, 0.3, { BackgroundTransparency = 1 })
        Tween(TimerFill,  0.3, { BackgroundTransparency = 1 })
        task.delay(0.31, function() Card:Destroy() end)
    end)
end

-- ─────────────────────────────────────────────────────────────
--  DRAG
-- ─────────────────────────────────────────────────────────────
local function MakeDraggable(handle, frame)
    local active, start, origin
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            active = true
            start  = inp.Position
            origin = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then active = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if active and (inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - start
            frame.Position = UDim2.new(
                origin.X.Scale, origin.X.Offset + d.X,
                origin.Y.Scale, origin.Y.Offset + d.Y
            )
        end
    end)
end

-- ─────────────────────────────────────────────────────────────
--  CREATE WINDOW
-- ─────────────────────────────────────────────────────────────
function Library:CreateWindow(opts)
    local title  = opts.Title     or "NochHawk UI"
    local togKey = opts.ToggleKey or Enum.KeyCode.RightShift

    -- Main window frame
    local Win = New("Frame", {
        Parent           = Root,
        BackgroundColor3 = T.Bg,
        Position         = UDim2.new(0.5, -285, 0.5, -185),
        Size             = UDim2.new(0, 570, 0, 370),
        ClipsDescendants = true,
    })
    Corner(12, Win)
    Stroke(T.Border, 1, Win)

    -- ── TOP BAR ──────────────────────────────────────────────
    local Topbar = New("Frame", {
        Parent           = Win,
        BackgroundColor3 = T.Panel,
        Size             = UDim2.new(1, 0, 0, 46),
        BorderSizePixel  = 0,
    })
    MakeDraggable(Topbar, Win)

    -- Topbar bottom border
    New("Frame", {
        Parent           = Win,
        BackgroundColor3 = T.Border,
        Position         = UDim2.new(0, 0, 0, 46),
        Size             = UDim2.new(1, 0, 0, 1),
        BorderSizePixel  = 0,
    })

    -- Accent bar on the left of topbar
    New("Frame", {
        Parent           = Topbar,
        BackgroundColor3 = T.Accent,
        Position         = UDim2.new(0, 0, 0.2, 0),
        Size             = UDim2.new(0, 3, 0.6, 0),
        BorderSizePixel  = 0,
    })

    -- Title text
    New("TextLabel", {
        Parent              = Topbar,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 18, 0, 0),
        Size                = UDim2.new(1, -80, 1, 0),
        Font                = Enum.Font.GothamBold,
        Text                = title,
        TextColor3          = T.Text,
        TextSize            = 15,
        TextXAlignment      = Enum.TextXAlignment.Left,
    })

    -- Close button — plain square, NO broken unicode
    local CloseBox = New("TextButton", {
        Parent              = Topbar,
        BackgroundColor3    = T.Card,
        Position            = UDim2.new(1, -38, 0.5, -14),
        Size                = UDim2.new(0, 28, 0, 28),
        Font                = Enum.Font.GothamBold,
        Text                = "X",
        TextColor3          = T.Muted,
        TextSize            = 13,
        AutoButtonColor     = false,
    })
    Corner(6, CloseBox)
    Stroke(T.Border, 1, CloseBox)

    CloseBox.MouseEnter:Connect(function()
        Tween(CloseBox, 0.18, { BackgroundColor3 = T.Red, TextColor3 = T.Text })
    end)
    CloseBox.MouseLeave:Connect(function()
        Tween(CloseBox, 0.18, { BackgroundColor3 = T.Card, TextColor3 = T.Muted })
    end)
    CloseBox.MouseButton1Click:Connect(function() Root:Destroy() end)

    -- Toggle visibility
    UserInputService.InputBegan:Connect(function(inp, proc)
        if not proc and inp.KeyCode == togKey then
            Win.Visible = not Win.Visible
        end
    end)

    -- ── SIDEBAR ───────────────────────────────────────────────
    local SIDE_W = 140

    local Sidebar = New("Frame", {
        Parent           = Win,
        BackgroundColor3 = T.Panel,
        Position         = UDim2.new(0, 0, 0, 47),
        Size             = UDim2.new(0, SIDE_W, 1, -47),
        ClipsDescendants = true,
        BorderSizePixel  = 0,
    })

    -- Right border of sidebar
    New("Frame", {
        Parent           = Sidebar,
        BackgroundColor3 = T.Border,
        Position         = UDim2.new(1, -1, 0, 0),
        Size             = UDim2.new(0, 1, 1, 0),
        BorderSizePixel  = 0,
    })

    local TabList = New("ScrollingFrame", {
        Parent               = Sidebar,
        BackgroundTransparency = 1,
        Position             = UDim2.new(0, 0, 0, 10),
        Size                 = UDim2.new(1, 0, 1, -42),
        ScrollBarThickness   = 0,
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        CanvasSize           = UDim2.new(0,0,0,0),
        Active               = true,
    })
    New("UIListLayout", {
        Parent  = TabList,
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    })
    New("UIPadding", {
        Parent       = TabList,
        PaddingLeft  = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    })

    -- Watermark
    New("TextLabel", {
        Parent              = Sidebar,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 0, 1, -32),
        Size                = UDim2.new(1, 0, 0, 32),
        Font                = Enum.Font.Gotham,
        Text                = "by NochHawk",
        TextColor3          = T.Muted,
        TextSize            = 10,
        TextTransparency    = 0.5,
    })

    -- ── CONTENT AREA ─────────────────────────────────────────
    local Content = New("Frame", {
        Parent              = Win,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, SIDE_W, 0, 47),
        Size                = UDim2.new(1, -SIDE_W, 1, -47),
        ClipsDescendants    = true,
    })

    -- ── WINDOW OBJECT ─────────────────────────────────────────
    local W = { _firstTab = true }

    function W:CreateTab(tabName)
        -- Sidebar button
        local Btn = New("TextButton", {
            Parent              = TabList,
            BackgroundColor3    = T.Accent,
            BackgroundTransparency = 1,
            Size                = UDim2.new(1, 0, 0, 32),
            Font                = Enum.Font.GothamSemibold,
            Text                = tabName,
            TextColor3          = T.Muted,
            TextSize            = 13,
            AutoButtonColor     = false,
        })
        Corner(7, Btn)

        -- Content scroll pane
        local Pane = New("ScrollingFrame", {
            Parent               = Content,
            BackgroundTransparency = 1,
            Size                 = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness   = 3,
            ScrollBarImageColor3 = T.Accent,
            AutomaticCanvasSize  = Enum.AutomaticSize.Y,
            CanvasSize           = UDim2.new(0,0,0,0),
            ScrollingDirection   = Enum.ScrollingDirection.Y,
            Visible              = false,
            Active               = true,
        })
        New("UIPadding", {
            Parent        = Pane,
            PaddingTop    = UDim.new(0, 12),
            PaddingLeft   = UDim.new(0, 12),
            PaddingRight  = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
        })
        New("UIListLayout", {
            Parent    = Pane,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding   = UDim.new(0, 8),
        })

        local function activate()
            for _, c in ipairs(TabList:GetChildren()) do
                if c:IsA("TextButton") then
                    Tween(c, 0.18, { BackgroundTransparency = 1, TextColor3 = T.Muted })
                end
            end
            for _, c in ipairs(Content:GetChildren()) do
                if c:IsA("ScrollingFrame") then c.Visible = false end
            end
            Tween(Btn, 0.18, { BackgroundTransparency = 0, TextColor3 = T.Text })
            Pane.Visible = true
        end

        Btn.MouseButton1Click:Connect(activate)
        if W._firstTab then W._firstTab = false; activate() end

        -- ── ELEMENTS ─────────────────────────────────────────
        local E = {}

        -- ── Section label ──────────────────────────────────
        function E:CreateSection(sname)
            local F = New("Frame", {
                Parent              = Pane,
                BackgroundTransparency = 1,
                Size                = UDim2.new(1, 0, 0, 20),
            })
            New("TextLabel", {
                Parent              = F,
                BackgroundTransparency = 1,
                Size                = UDim2.new(1, 0, 1, 0),
                Font                = Enum.Font.GothamBold,
                Text                = sname:upper(),
                TextColor3          = T.Accent,
                TextSize            = 10,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })
            New("Frame", {
                Parent           = F,
                BackgroundColor3 = T.Border,
                Position         = UDim2.new(0, 0, 1, -1),
                Size             = UDim2.new(1, 0, 0, 1),
                BorderSizePixel  = 0,
            })
        end

        -- ── Button ─────────────────────────────────────────
        function E:CreateButton(opts2)
            local bname = opts2.Name or "Button"
            local cb    = opts2.Callback or function() end

            local B = New("TextButton", {
                Parent           = Pane,
                BackgroundColor3 = T.Card,
                Size             = UDim2.new(1, 0, 0, 36),
                Font             = Enum.Font.GothamSemibold,
                Text             = bname,
                TextColor3       = T.Text,
                TextSize         = 13,
                AutoButtonColor  = false,
            })
            Corner(8, B)
            Stroke(T.Border, 1, B)

            B.MouseEnter:Connect(function() Tween(B, 0.15, { BackgroundColor3 = T.Accent }) end)
            B.MouseLeave:Connect(function() Tween(B, 0.15, { BackgroundColor3 = T.Card }) end)
            B.MouseButton1Click:Connect(function()
                Tween(B, 0.07, { BackgroundColor3 = T.AccentHi })
                task.delay(0.12, function() Tween(B, 0.15, { BackgroundColor3 = T.Card }) end)
                cb()
            end)
            return { Set = function(_, t2) B.Text = t2 end }
        end

        -- ── Toggle ─────────────────────────────────────────
        function E:CreateToggle(opts2)
            local tname = opts2.Name or "Toggle"
            local state = opts2.Default or false
            local cb    = opts2.Callback or function() end

            local Row = New("Frame", {
                Parent           = Pane,
                BackgroundColor3 = T.Card,
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

            -- Track
            local Track = New("Frame", {
                Parent           = Row,
                BackgroundColor3 = state and T.Accent or T.Border,
                Position         = UDim2.new(1, -52, 0.5, -11),
                Size             = UDim2.new(0, 40, 0, 22),
            })
            Corner(11, Track)

            -- Thumb
            local Thumb = New("Frame", {
                Parent           = Track,
                BackgroundColor3 = T.Text,
                Size             = UDim2.new(0, 18, 0, 18),
                Position         = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
            })
            Corner(9, Thumb)

            -- Click zone on track only
            local Hit = New("TextButton", {
                Parent              = Track,
                BackgroundTransparency = 1,
                Size                = UDim2.new(1, 0, 1, 0),
                Text                = "",
            })

            local function setToggle(v)
                state = v
                Tween(Track, 0.18, { BackgroundColor3 = v and T.Accent or T.Border })
                Tween(Thumb, 0.18, { Position = v and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9) })
                cb(v)
            end

            Hit.MouseButton1Click:Connect(function() setToggle(not state) end)
            setToggle(state)

            return { Set = function(_, v) setToggle(v) end }
        end

        -- ── Slider ─────────────────────────────────────────
        function E:CreateSlider(opts2)
            local sname   = opts2.Name     or "Slider"
            local smin    = opts2.Min      or 0
            local smax    = opts2.Max      or 100
            local sval    = math.clamp(opts2.Default or smin, smin, smax)
            local isFloat = opts2.Float    or false
            local cb      = opts2.Callback or function() end

            local Row = New("Frame", {
                Parent           = Pane,
                BackgroundColor3 = T.Card,
                Size             = UDim2.new(1, 0, 0, 50),
            })
            Corner(8, Row)
            Stroke(T.Border, 1, Row)

            New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 6),
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
                Position            = UDim2.new(0, 12, 0, 6),
                Size                = UDim2.new(1, -24, 0, 18),
                Font                = Enum.Font.GothamBold,
                Text                = tostring(sval),
                TextColor3          = T.Accent,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Right,
            })

            -- Track background
            local Track = New("Frame", {
                Parent           = Row,
                BackgroundColor3 = T.Border,
                Position         = UDim2.new(0, 12, 0, 34),
                Size             = UDim2.new(1, -24, 0, 6),
            })
            Corner(3, Track)

            -- Fill
            local Fill = New("Frame", {
                Parent           = Track,
                BackgroundColor3 = T.Accent,
                Size             = UDim2.new(math.clamp((sval-smin)/(smax-smin),0,1), 0, 1, 0),
            })
            Corner(3, Fill)

            -- Thumb dot
            local Dot = New("Frame", {
                Parent           = Fill,
                BackgroundColor3 = T.Text,
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(1, 0, 0.5, 0),
                Size             = UDim2.new(0, 14, 0, 14),
            })
            Corner(7, Dot)

            -- Hit zone — expanded height for easy clicking
            local Hit = New("TextButton", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 26),
                Size                = UDim2.new(1, -24, 0, 22),
                Text                = "",
            })

            local function round(v)
                return isFloat and tonumber(string.format("%.1f", v)) or math.floor(v + 0.5)
            end

            local function setSlider(px)
                local pct = math.clamp((px - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                sval = round(smin + (smax - smin) * pct)
                Tween(Fill, 0.05, { Size = UDim2.new(pct, 0, 1, 0) }, Enum.EasingStyle.Linear)
                ValLbl.Text = tostring(sval)
                cb(sval)
            end

            local dragging = false
            Hit.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; setSlider(inp.Position.X)
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
                    setSlider(inp.Position.X)
                end
            end)

            return {
                Set = function(_, v)
                    local pct = math.clamp((v - smin) / (smax - smin), 0, 1)
                    sval = round(v)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    ValLbl.Text = tostring(sval)
                    cb(sval)
                end
            }
        end

        -- ── Dropdown ───────────────────────────────────────
        function E:CreateDropdown(opts2)
            local dname = opts2.Name     or "Dropdown"
            local items = opts2.Options  or {}
            local cb    = opts2.Callback or function() end
            local open  = false
            local itemH = 28

            local Wrap = New("Frame", {
                Parent           = Pane,
                BackgroundColor3 = T.Card,
                Size             = UDim2.new(1, 0, 0, 36),
                ClipsDescendants = true,
            })
            Corner(8, Wrap)
            Stroke(T.Border, 1, Wrap)

            -- Header row
            local Header = New("Frame", {
                Parent           = Wrap,
                BackgroundTransparency = 1,
                Size             = UDim2.new(1, 0, 0, 36),
            })

            New("TextLabel", {
                Parent              = Header,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 0),
                Size                = UDim2.new(1, -50, 1, 0),
                Font                = Enum.Font.GothamSemibold,
                Text                = dname,
                TextColor3          = T.Text,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })

            -- Arrow indicator — use simple text, no broken unicode
            local Arrow = New("TextLabel", {
                Parent              = Header,
                BackgroundTransparency = 1,
                Position            = UDim2.new(1, -36, 0, 0),
                Size                = UDim2.new(0, 30, 1, 0),
                Font                = Enum.Font.GothamBold,
                Text                = "v",
                TextColor3          = T.Muted,
                TextSize            = 12,
            })

            local HeaderBtn = New("TextButton", {
                Parent              = Header,
                BackgroundTransparency = 1,
                Size                = UDim2.new(1, 0, 1, 0),
                Text                = "",
            })

            -- Separator line
            New("Frame", {
                Parent           = Wrap,
                BackgroundColor3 = T.Border,
                Position         = UDim2.new(0, 8, 0, 36),
                Size             = UDim2.new(1, -16, 0, 1),
                BorderSizePixel  = 0,
            })

            -- Items
            local ItemHolder = New("Frame", {
                Parent           = Wrap,
                BackgroundTransparency = 1,
                Position         = UDim2.new(0, 0, 0, 37),
                Size             = UDim2.new(1, 0, 1, -37),
            })
            New("UIListLayout", { Parent = ItemHolder, SortOrder = Enum.SortOrder.LayoutOrder })

            local selectedLabel = New("TextLabel", {
                Parent              = Header,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 0),
                Size                = UDim2.new(1, -50, 1, 0),
                Font                = Enum.Font.Gotham,
                Text                = "",
                TextColor3          = T.Muted,
                TextSize            = 12,
                TextXAlignment      = Enum.TextXAlignment.Right,
                Visible             = false,
            })

            HeaderBtn.MouseButton1Click:Connect(function()
                open = not open
                local h = 36 + 1 + math.min(#items * itemH, 5 * itemH)
                Tween(Wrap, 0.2, { Size = open and UDim2.new(1,0,0,h) or UDim2.new(1,0,0,36) })
                Arrow.Text = open and "^" or "v"
            end)

            for _, item in ipairs(items) do
                local IBtn = New("TextButton", {
                    Parent              = ItemHolder,
                    BackgroundColor3    = T.Accent,
                    BackgroundTransparency = 1,
                    Size                = UDim2.new(1, 0, 0, itemH),
                    Font                = Enum.Font.Gotham,
                    Text                = "  " .. item,
                    TextColor3          = T.Muted,
                    TextSize            = 12,
                    TextXAlignment      = Enum.TextXAlignment.Left,
                    AutoButtonColor     = false,
                })
                IBtn.MouseEnter:Connect(function()
                    Tween(IBtn, 0.12, { BackgroundTransparency = 0.85, TextColor3 = T.Text })
                end)
                IBtn.MouseLeave:Connect(function()
                    Tween(IBtn, 0.12, { BackgroundTransparency = 1, TextColor3 = T.Muted })
                end)
                IBtn.MouseButton1Click:Connect(function()
                    selectedLabel.Text    = item
                    selectedLabel.Visible = true
                    open = false
                    Arrow.Text = "v"
                    Tween(Wrap, 0.2, { Size = UDim2.new(1,0,0,36) })
                    cb(item)
                end)
            end

            return {
                Set = function(_, v)
                    selectedLabel.Text    = v
                    selectedLabel.Visible = true
                    cb(v)
                end,
                GetSelected = function(_) return selectedLabel.Text end,
            }
        end

        -- ── TextBox ────────────────────────────────────────
        function E:CreateTextBox(opts2)
            local bname = opts2.Name    or "Input"
            local def   = opts2.Default or ""
            local cb    = opts2.Callback or function() end

            local Row = New("Frame", {
                Parent           = Pane,
                BackgroundColor3 = T.Card,
                Size             = UDim2.new(1, 0, 0, 36),
            })
            Corner(8, Row)
            local rs = Stroke(T.Border, 1, Row)

            New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 0),
                Size                = UDim2.new(0.4, -4, 1, 0),
                Font                = Enum.Font.GothamSemibold,
                Text                = bname,
                TextColor3          = T.Text,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })

            local Box = New("TextBox", {
                Parent            = Row,
                BackgroundColor3  = T.Bg,
                Position          = UDim2.new(0.42, 0, 0.5, -12),
                Size              = UDim2.new(0.56, 0, 0, 24),
                Font              = Enum.Font.Gotham,
                Text              = def,
                PlaceholderText   = "Enter...",
                PlaceholderColor3 = T.Muted,
                TextColor3        = T.Text,
                TextSize          = 12,
                ClearTextOnFocus  = false,
            })
            Corner(6, Box)
            Stroke(T.Border, 1, Box)

            Box.Focused:Connect(function()    Tween(rs, 0.18, { Color = T.Accent }) end)
            Box.FocusLost:Connect(function()  Tween(rs, 0.18, { Color = T.Border }); cb(Box.Text) end)

            return { Set = function(_, v) Box.Text = v; cb(v) end }
        end

        -- ── Keybind ────────────────────────────────────────
        function E:CreateKeybind(opts2)
            local kname  = opts2.Name     or "Keybind"
            local defKey = opts2.Default  or Enum.KeyCode.E
            local cb     = opts2.Callback or function() end
            local curKey = defKey
            local conn
            local listening = false

            local Row = New("Frame", {
                Parent           = Pane,
                BackgroundColor3 = T.Card,
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
                Position         = UDim2.new(1, -100, 0.5, -12),
                Size             = UDim2.new(0, 90, 0, 24),
                Font             = Enum.Font.GothamBold,
                Text             = "[" .. curKey.Name .. "]",
                TextColor3       = T.Muted,
                TextSize         = 11,
                AutoButtonColor  = false,
            })
            Corner(6, KBtn)
            Stroke(T.Border, 1, KBtn)

            KBtn.MouseButton1Click:Connect(function()
                if conn then conn:Disconnect() end
                listening = true
                KBtn.Text       = "[ ... ]"
                KBtn.TextColor3 = T.Accent
                conn = UserInputService.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.Keyboard
                    and inp.KeyCode ~= Enum.KeyCode.Unknown then
                        curKey          = inp.KeyCode
                        KBtn.Text       = "[" .. curKey.Name .. "]"
                        KBtn.TextColor3 = T.Muted
                        listening       = false
                        conn:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(inp, proc)
                if not proc and not listening and inp.KeyCode == curKey then cb() end
            end)

            return { Set = function(_, k) curKey = k; KBtn.Text = "[" .. k.Name .. "]" end }
        end

        -- ── Color Picker ───────────────────────────────────
        function E:CreateColorPicker(opts2)
            local cname = opts2.Name     or "Color"
            local state = opts2.Default  or Color3.fromRGB(108, 99, 255)
            local cb    = opts2.Callback or function() end

            local Row = New("Frame", {
                Parent           = Pane,
                BackgroundColor3 = T.Card,
                Size             = UDim2.new(1, 0, 0, 36),
            })
            Corner(8, Row)
            Stroke(T.Border, 1, Row)

            New("TextLabel", {
                Parent              = Row,
                BackgroundTransparency = 1,
                Position            = UDim2.new(0, 12, 0, 0),
                Size                = UDim2.new(1, -120, 1, 0),
                Font                = Enum.Font.GothamSemibold,
                Text                = cname,
                TextColor3          = T.Text,
                TextSize            = 13,
                TextXAlignment      = Enum.TextXAlignment.Left,
            })

            local Preview = New("Frame", {
                Parent           = Row,
                BackgroundColor3 = state,
                Position         = UDim2.new(1, -44, 0.5, -11),
                Size             = UDim2.new(0, 32, 0, 22),
            })
            Corner(6, Preview)
            Stroke(T.Border, 1, Preview)

            local HexBtn = New("TextButton", {
                Parent           = Row,
                BackgroundColor3 = T.Bg,
                Position         = UDim2.new(1, -100, 0.5, -11),
                Size             = UDim2.new(0, 52, 0, 22),
                Font             = Enum.Font.Code,
                Text             = string.format("#%02X%02X%02X",
                    math.floor(state.R*255), math.floor(state.G*255), math.floor(state.B*255)),
                TextColor3       = T.Muted,
                TextSize         = 10,
                AutoButtonColor  = false,
            })
            Corner(6, HexBtn)
            Stroke(T.Border, 1, HexBtn)

            local hue = 0
            HexBtn.MouseButton1Click:Connect(function()
                hue   = (hue + 0.12) % 1
                state = Color3.fromHSV(hue, 0.85, 1)
                Tween(Preview, 0.2, { BackgroundColor3 = state })
                HexBtn.Text = string.format("#%02X%02X%02X",
                    math.floor(state.R*255), math.floor(state.G*255), math.floor(state.B*255))
                cb(state)
            end)

            return {
                Set = function(_, c)
                    state = c
                    Preview.BackgroundColor3 = c
                    HexBtn.Text = string.format("#%02X%02X%02X",
                        math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
                    cb(c)
                end
            }
        end

        return E
    end -- CreateTab

    return W
end -- CreateWindow

return Library
