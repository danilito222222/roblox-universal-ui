-- ============================================================
--  Universal UI Library  |  by NochHawk  |  AI Generated
--  v5 - Working theme switcher + full color picker popup
-- ============================================================

local Library = {}

local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ─────────────────────────────────────────────────────────────
--  THEME REGISTRY
-- ─────────────────────────────────────────────────────────────
local Themes = {
    Dark = {
        Bg      = Color3.fromRGB(15,  15,  18 ),
        Panel   = Color3.fromRGB(22,  22,  26 ),
        Card    = Color3.fromRGB(30,  30,  35 ),
        CardHov = Color3.fromRGB(40,  40,  46 ),
        Border  = Color3.fromRGB(50,  50,  58 ),
        Accent  = Color3.fromRGB(108, 99,  255),
        AccHi   = Color3.fromRGB(138, 132, 255),
        Green   = Color3.fromRGB(52,  211, 153),
        Red     = Color3.fromRGB(248, 113, 113),
        Text    = Color3.fromRGB(245, 245, 250),
        Muted   = Color3.fromRGB(130, 130, 150),
    },
    Midnight = {
        Bg      = Color3.fromRGB(8,   10,  20 ),
        Panel   = Color3.fromRGB(12,  16,  30 ),
        Card    = Color3.fromRGB(18,  22,  42 ),
        CardHov = Color3.fromRGB(26,  30,  55 ),
        Border  = Color3.fromRGB(40,  45,  80 ),
        Accent  = Color3.fromRGB(56,  189, 248),
        AccHi   = Color3.fromRGB(125, 211, 252),
        Green   = Color3.fromRGB(52,  211, 153),
        Red     = Color3.fromRGB(248, 113, 113),
        Text    = Color3.fromRGB(240, 245, 255),
        Muted   = Color3.fromRGB(100, 120, 160),
    },
    Slate = {
        Bg      = Color3.fromRGB(30,  34,  40 ),
        Panel   = Color3.fromRGB(38,  43,  50 ),
        Card    = Color3.fromRGB(48,  54,  62 ),
        CardHov = Color3.fromRGB(58,  65,  74 ),
        Border  = Color3.fromRGB(70,  78,  90 ),
        Accent  = Color3.fromRGB(74,  222, 128),
        AccHi   = Color3.fromRGB(134, 239, 172),
        Green   = Color3.fromRGB(52,  211, 153),
        Red     = Color3.fromRGB(248, 113, 113),
        Text    = Color3.fromRGB(248, 250, 252),
        Muted   = Color3.fromRGB(150, 163, 175),
    },
    Rose = {
        Bg      = Color3.fromRGB(20,  10,  14 ),
        Panel   = Color3.fromRGB(28,  16,  20 ),
        Card    = Color3.fromRGB(36,  22,  28 ),
        CardHov = Color3.fromRGB(46,  30,  36 ),
        Border  = Color3.fromRGB(70,  40,  50 ),
        Accent  = Color3.fromRGB(251, 113, 133),
        AccHi   = Color3.fromRGB(253, 164, 175),
        Green   = Color3.fromRGB(52,  211, 153),
        Red     = Color3.fromRGB(248, 113, 113),
        Text    = Color3.fromRGB(255, 245, 248),
        Muted   = Color3.fromRGB(180, 140, 150),
    },
}

-- Active theme (mutable copy)
local T = {}
for k, v in pairs(Themes.Dark) do T[k] = v end

-- Theme update callbacks (registered by each element)
local _themeCallbacks = {}
local function onTheme(cb) table.insert(_themeCallbacks, cb) end

function Library:SetTheme(name)
    local th = Themes[name]
    if not th then return end
    for k, v in pairs(th) do T[k] = v end
    for _, cb in ipairs(_themeCallbacks) do pcall(cb) end
end

function Library:GetThemes()
    local list = {}
    for k in pairs(Themes) do table.insert(list, k) end
    return list
end

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

local function Tw(obj, dur, goal, style)
    TweenService:Create(obj, TweenInfo.new(dur,
        style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal):Play()
end

local function Corner(r, p)  New("UICorner", { CornerRadius = UDim.new(0,r), Parent = p }) end
local function Stroke(c,t,p) New("UIStroke", { Color=c, Thickness=t, Parent=p }) end

-- HSV → Color3
local function hsv(h,s,v) return Color3.fromHSV(h,s,v) end

-- Color3 → hex string
local function toHex(c)
    return string.format("%02X%02X%02X",
        math.floor(c.R*255+.5), math.floor(c.G*255+.5), math.floor(c.B*255+.5))
end

-- hex string → Color3 (returns nil on bad input)
local function fromHex(str)
    str = str:gsub("#","")
    if #str ~= 6 then return nil end
    local r,g,b = str:sub(1,2), str:sub(3,4), str:sub(5,6)
    local ri,gi,bi = tonumber(r,16), tonumber(g,16), tonumber(b,16)
    if not ri then return nil end
    return Color3.fromRGB(ri,gi,bi)
end

-- ─────────────────────────────────────────────────────────────
--  SCREENGUI ROOT
-- ─────────────────────────────────────────────────────────────
local Root = New("ScreenGui", {
    Name           = "NochHawkUI_v5",
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
    local title  = opts.Title    or "Notice"
    local body   = opts.Text     or ""
    local dur    = opts.Duration or 4
    local ntype  = opts.Type     or "info"
    local barCol = (ntype == "success") and T.Green
                or (ntype == "error")   and T.Red
                or T.Accent

    -- FIX 1: No TextTransparency animation — set text visible immediately
    -- FIX 2: No Position animation — UIListLayout controls position, setting it breaks things
    -- FIX 3: Use spawn+wait instead of task.delay for maximum executor compatibility

    local Card = New("Frame", {
        Parent           = NotifHolder,
        BackgroundColor3 = T.Panel,
        Size             = UDim2.new(1, 0, 0, 72),
        ClipsDescendants = false,
    })
    Corner(10, Card)
    Stroke(T.Border, 1, Card)

    -- Left accent bar
    New("Frame", {
        Parent           = Card,
        BackgroundColor3 = barCol,
        Position         = UDim2.new(0, 0, 0.1, 0),
        Size             = UDim2.new(0, 3, 0.8, 0),
        BorderSizePixel  = 0,
    })

    -- Title — immediately visible (no TextTransparency trickery)
    New("TextLabel", {
        Parent              = Card,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 16, 0, 8),
        Size                = UDim2.new(1, -20, 0, 20),
        Font                = Enum.Font.GothamBold,
        Text                = title,
        TextColor3          = T.Text,
        TextSize            = 13,
        TextXAlignment      = Enum.TextXAlignment.Left,
    })

    -- Body text — immediately visible
    New("TextLabel", {
        Parent              = Card,
        BackgroundTransparency = 1,
        Position            = UDim2.new(0, 16, 0, 28),
        Size                = UDim2.new(1, -20, 0, 30),
        Font                = Enum.Font.Gotham,
        Text                = body,
        TextColor3          = T.Muted,
        TextSize            = 12,
        TextXAlignment      = Enum.TextXAlignment.Left,
        TextWrapped         = true,
    })

    -- Timer bar background
    local TBG = New("Frame", {
        Parent           = Card,
        BackgroundColor3 = T.Card,
        Position         = UDim2.new(0, 16, 1, -7),
        Size             = UDim2.new(1, -32, 0, 3),
    })
    Corner(2, TBG)
    local TFill = New("Frame", {
        Parent           = TBG,
        BackgroundColor3 = barCol,
        Size             = UDim2.new(1, 0, 1, 0),
    })
    Corner(2, TFill)

    -- Fade in the card background only
    Card.BackgroundTransparency = 1
    TweenService:Create(Card, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()

    -- Start timer bar shrink after fade-in
    TweenService:Create(
        TFill,
        TweenInfo.new(dur, Enum.EasingStyle.Linear),
        { Size = UDim2.new(0, 0, 1, 0) }
    ):Play()

    -- Auto-remove using spawn+wait (works on all executors)
    spawn(function()
        wait(dur)
        -- Fade out
        local fadeOut = TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        fadeOut:Play()
        wait(0.35)
        if Card and Card.Parent then
            Card:Destroy()
        end
    end)
end


-- ─────────────────────────────────────────────────────────────
--  COLOR PICKER POPUP
-- ─────────────────────────────────────────────────────────────
local function CreateColorPickerPopup(initialColor, onConfirm)
    -- Decode initial color to HSV
    local pH, pS, pV = Color3.toHSV(initialColor)

    local Overlay = New("Frame", {
        Parent              = Root,
        BackgroundColor3    = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.5,
        Size                = UDim2.new(1,0,1,0),
        ZIndex              = 10,
    })

    local Pop = New("Frame", {
        Parent           = Overlay,
        BackgroundColor3 = T.Panel,
        Position         = UDim2.new(0.5,-130,0.5,-195),
        Size             = UDim2.new(0,260,0,390),
        ZIndex           = 11,
        ClipsDescendants = true,
    })
    Corner(12, Pop)
    Stroke(T.Border, 1, Pop)

    -- Title bar
    local TBar = New("Frame",{Parent=Pop,BackgroundColor3=T.Bg,
        Size=UDim2.new(1,0,0,38),ZIndex=11,BorderSizePixel=0})
    New("TextLabel",{Parent=TBar,BackgroundTransparency=1,
        Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-50,1,0),
        Font=Enum.Font.GothamBold,Text="Color Picker",
        TextColor3=T.Text,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=12})

    local CloseP = New("TextButton",{Parent=TBar,BackgroundColor3=T.Card,
        Position=UDim2.new(1,-34,0.5,-12),Size=UDim2.new(0,24,0,24),
        Font=Enum.Font.GothamBold,Text="X",TextColor3=T.Muted,TextSize=12,
        AutoButtonColor=false,ZIndex=12})
    Corner(6,CloseP)
    CloseP.MouseEnter:Connect(function() Tw(CloseP,0.15,{BackgroundColor3=T.Red,TextColor3=T.Text}) end)
    CloseP.MouseLeave:Connect(function() Tw(CloseP,0.15,{BackgroundColor3=T.Card,TextColor3=T.Muted}) end)

    -- Separator
    New("Frame",{Parent=Pop,BackgroundColor3=T.Border,
        Position=UDim2.new(0,0,0,38),Size=UDim2.new(1,0,0,1),BorderSizePixel=0,ZIndex=11})

    local SQ = 220  -- SV square size
    local PAD = 20  -- side padding

    -- ── SV SQUARE ────────────────────────────────────────────
    local SqContainer = New("Frame",{
        Parent=Pop, BackgroundColor3=Color3.fromRGB(255,0,0),
        Position=UDim2.new(0,PAD,0,48),
        Size=UDim2.new(0,SQ,0,SQ),
        ZIndex=11, ClipsDescendants=true
    })
    Corner(6, SqContainer)

    -- White-to-hueColor gradient (horizontal)
    local SqGrad = New("UIGradient",{
        Parent=SqContainer,
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, hsv(pH,1,1)),
        }),
        Rotation=0,
    })

    -- Black overlay (vertical, transparent top → black bottom)
    local SqDark = New("Frame",{
        Parent=SqContainer,
        BackgroundColor3=Color3.fromRGB(0,0,0),
        BackgroundTransparency=0,
        Size=UDim2.new(1,0,1,0),
        ZIndex=12,
    })
    New("UIGradient",{
        Parent=SqDark,
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
        }),
        Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Rotation=90,
    })

    -- Cursor dot on SV square
    local SqCursor = New("Frame",{
        Parent=SqContainer,
        BackgroundColor3=Color3.fromRGB(255,255,255),
        AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.new(pS, 0, 1-pV, 0),
        Size=UDim2.new(0,12,0,12),
        ZIndex=15,
    })
    Corner(6, SqCursor)
    Stroke(Color3.fromRGB(0,0,0), 2, SqCursor)

    -- Hit zone over SV square
    local SqHit = New("TextButton",{
        Parent=SqContainer,
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,0),
        Text="", ZIndex=16,
    })

    -- ── HUE BAR ──────────────────────────────────────────────
    local HueBar = New("Frame",{
        Parent=Pop,
        BackgroundColor3=Color3.fromRGB(255,255,255),
        Position=UDim2.new(0,PAD,0,SQ+58),
        Size=UDim2.new(0,SQ,0,16),
        ZIndex=11,ClipsDescendants=true,
    })
    Corner(4, HueBar)

    New("UIGradient",{
        Parent=HueBar,
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0/6,  Color3.fromRGB(255,0,0)),
            ColorSequenceKeypoint.new(1/6,  Color3.fromRGB(255,255,0)),
            ColorSequenceKeypoint.new(2/6,  Color3.fromRGB(0,255,0)),
            ColorSequenceKeypoint.new(3/6,  Color3.fromRGB(0,255,255)),
            ColorSequenceKeypoint.new(4/6,  Color3.fromRGB(0,0,255)),
            ColorSequenceKeypoint.new(5/6,  Color3.fromRGB(255,0,255)),
            ColorSequenceKeypoint.new(6/6,  Color3.fromRGB(255,0,0)),
        }),
    })

    -- Hue cursor
    local HueCursor = New("Frame",{
        Parent=HueBar,
        BackgroundColor3=Color3.fromRGB(255,255,255),
        AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.new(pH,0,0.5,0),
        Size=UDim2.new(0,6,0,22),
        ZIndex=14,
    })
    Corner(3, HueCursor)
    Stroke(Color3.fromRGB(0,0,0), 1.5, HueCursor)

    local HueHit = New("TextButton",{
        Parent=HueBar,BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,0),Text="",ZIndex=15,
    })

    -- ── RGB SLIDERS ──────────────────────────────────────────
    local function makeRGBSlider(label, yOff, initVal, col)
        local y = SQ + 84 + yOff
        New("TextLabel",{Parent=Pop,BackgroundTransparency=1,
            Position=UDim2.new(0,PAD,0,y),Size=UDim2.new(0,14,0,16),
            Font=Enum.Font.GothamBold,Text=label,TextColor3=col,TextSize=12,ZIndex=12})

        local Track = New("Frame",{Parent=Pop,BackgroundColor3=T.Card,
            Position=UDim2.new(0,PAD+20,0,y+4),
            Size=UDim2.new(0,SQ-56,0,8),ZIndex=12})
        Corner(4,Track)

        local Fill = New("Frame",{Parent=Track,BackgroundColor3=col,
            Size=UDim2.new(initVal/255,0,1,0),ZIndex=13})
        Corner(4,Fill)

        local ValLbl = New("TextLabel",{Parent=Pop,BackgroundTransparency=1,
            Position=UDim2.new(0,PAD+SQ-34,0,y),Size=UDim2.new(0,34,0,16),
            Font=Enum.Font.GothamBold,Text=tostring(initVal),TextColor3=T.Text,TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Right,ZIndex=12})

        local Hit = New("TextButton",{Parent=Track,BackgroundTransparency=1,
            Position=UDim2.new(0,0,0.5,-8),Size=UDim2.new(1,0,0,16),
            Text="",ZIndex=14})

        local val = initVal
        local function set(px)
            local pct = math.clamp((px - Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)
            val = math.floor(pct*255+0.5)
            Fill.Size = UDim2.new(pct,0,1,0)
            ValLbl.Text = tostring(val)
        end
        local drag=false
        Hit.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;set(i.Position.X) end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and i.UserInputType==Enum.UserInputType.MouseMovement then set(i.Position.X) end
        end)

        local function refresh(newVal)
            val = newVal
            Fill.Size = UDim2.new(newVal/255,0,1,0)
            ValLbl.Text = tostring(newVal)
        end

        return function() return val end, refresh
    end

    local curColor = initialColor
    local getR, refreshR = makeRGBSlider("R", 0,  math.floor(initialColor.R*255+.5), Color3.fromRGB(255,100,100))
    local getG, refreshG = makeRGBSlider("G", 24, math.floor(initialColor.G*255+.5), Color3.fromRGB(100,220,100))
    local getB, refreshB = makeRGBSlider("B", 48, math.floor(initialColor.B*255+.5), Color3.fromRGB(100,150,255))

    -- ── HEX INPUT + PREVIEW + OK ──────────────────────────────
    local previewY = SQ + 84 + 80

    local HexBox = New("TextBox",{
        Parent=Pop,BackgroundColor3=T.Card,
        Position=UDim2.new(0,PAD,0,previewY),
        Size=UDim2.new(0,SQ-52,0,28),
        Font=Enum.Font.Code,Text=toHex(initialColor),
        PlaceholderText="RRGGBB",PlaceholderColor3=T.Muted,
        TextColor3=T.Text,TextSize=13,ClearTextOnFocus=false,ZIndex=12
    })
    Corner(6,HexBox); Stroke(T.Border,1,HexBox)

    local PreviewBox = New("Frame",{
        Parent=Pop,BackgroundColor3=initialColor,
        Position=UDim2.new(0,PAD+SQ-48,0,previewY),
        Size=UDim2.new(0,28,0,28),ZIndex=12
    })
    Corner(6,PreviewBox); Stroke(T.Border,1,PreviewBox)

    -- OK button
    local OkBtn = New("TextButton",{
        Parent=Pop,BackgroundColor3=T.Accent,
        Position=UDim2.new(0,PAD,0,previewY+38),
        Size=UDim2.new(0,SQ,0,30),
        Font=Enum.Font.GothamBold,Text="Apply",TextColor3=T.Text,TextSize=13,
        AutoButtonColor=false,ZIndex=12
    })
    Corner(8,OkBtn)

    -- ── STATE SYNC ────────────────────────────────────────────
    local function syncFromHSV()
        curColor = hsv(pH,pS,pV)
        -- Update SV square hue
        SqGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, hsv(pH,1,1)),
        })
        -- Update cursors
        SqCursor.Position = UDim2.new(pS,0,1-pV,0)
        HueCursor.Position = UDim2.new(pH,0,0.5,0)
        -- Update preview & hex
        PreviewBox.BackgroundColor3 = curColor
        HexBox.Text = toHex(curColor)
        -- Refresh RGB sliders
        refreshR(math.floor(curColor.R*255+.5))
        refreshG(math.floor(curColor.G*255+.5))
        refreshB(math.floor(curColor.B*255+.5))
    end

    local function syncFromRGB()
        curColor = Color3.fromRGB(getR(), getG(), getB())
        pH, pS, pV = Color3.toHSV(curColor)
        syncFromHSV()
    end

    -- SV square interaction
    local sqDrag = false
    SqHit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            sqDrag=true
            local px = math.clamp((i.Position.X - SqContainer.AbsolutePosition.X)/SqContainer.AbsoluteSize.X,0,1)
            local py = math.clamp((i.Position.Y - SqContainer.AbsolutePosition.Y)/SqContainer.AbsoluteSize.Y,0,1)
            pS, pV = px, 1-py
            syncFromHSV()
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then sqDrag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sqDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local px = math.clamp((i.Position.X - SqContainer.AbsolutePosition.X)/SqContainer.AbsoluteSize.X,0,1)
            local py = math.clamp((i.Position.Y - SqContainer.AbsolutePosition.Y)/SqContainer.AbsoluteSize.Y,0,1)
            pS, pV = px, 1-py
            syncFromHSV()
        end
    end)

    -- Hue bar interaction
    local hueDrag = false
    HueHit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            hueDrag=true
            pH = math.clamp((i.Position.X - HueBar.AbsolutePosition.X)/HueBar.AbsoluteSize.X,0,1)
            syncFromHSV()
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then hueDrag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if hueDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
            pH = math.clamp((i.Position.X - HueBar.AbsolutePosition.X)/HueBar.AbsoluteSize.X,0,1)
            syncFromHSV()
        end
    end)

    -- RGB sliders change → update everything
    -- (we patch the hit buttons to also call syncFromRGB)
    -- Note: RGB drag already calls set() internally; we hook InputChanged globally
    local rDrag,gDrag,bDrag = false,false,false
    -- We'll use a polling approach via InputChanged to keep it simple
    local prevR,prevG,prevB = getR(),getG(),getB()
    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement then
            local r,g,b = getR(),getG(),getB()
            if r~=prevR or g~=prevG or b~=prevB then
                prevR,prevG,prevB = r,g,b
                syncFromRGB()
            end
        end
    end)

    -- Hex input
    HexBox.FocusLost:Connect(function()
        local c = fromHex(HexBox.Text)
        if c then
            curColor = c
            pH,pS,pV = Color3.toHSV(c)
            syncFromHSV()
        else
            HexBox.Text = toHex(curColor)
        end
    end)

    -- Close / OK
    local function closePopup() Overlay:Destroy() end
    CloseP.MouseButton1Click:Connect(closePopup)
    Overlay.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            -- close if clicked outside Pop
            local mx,my = i.Position.X, i.Position.Y
            local px,py = Pop.AbsolutePosition.X, Pop.AbsolutePosition.Y
            local pw,ph2 = Pop.AbsoluteSize.X, Pop.AbsoluteSize.Y
            if mx<px or mx>px+pw or my<py or my>py+ph2 then
                closePopup()
            end
        end
    end)
    OkBtn.MouseButton1Click:Connect(function()
        onConfirm(curColor)
        closePopup()
    end)

    -- Hover on OK
    OkBtn.MouseEnter:Connect(function() Tw(OkBtn,0.15,{BackgroundColor3=T.AccHi}) end)
    OkBtn.MouseLeave:Connect(function() Tw(OkBtn,0.15,{BackgroundColor3=T.Accent}) end)

    syncFromHSV()
end

-- ─────────────────────────────────────────────────────────────
--  DRAG
-- ─────────────────────────────────────────────────────────────
local function MakeDraggable(handle, frame)
    local active, start, origin
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1
        or inp.UserInputType==Enum.UserInputType.Touch then
            active=true; start=inp.Position; origin=frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then active=false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if active and (inp.UserInputType==Enum.UserInputType.MouseMovement
        or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=inp.Position-start
            frame.Position=UDim2.new(origin.X.Scale,origin.X.Offset+d.X,
                origin.Y.Scale,origin.Y.Offset+d.Y)
        end
    end)
end

-- ─────────────────────────────────────────────────────────────
--  CREATE WINDOW
-- ─────────────────────────────────────────────────────────────
function Library:CreateWindow(opts)
    local title  = opts.Title     or "NochHawk UI"
    local togKey = opts.ToggleKey or Enum.KeyCode.RightShift

    -- ── Main Frame ───────────────────────────────────────────
    local Win = New("Frame",{
        Parent=Root, BackgroundColor3=T.Bg,
        Position=UDim2.new(0.5,-285,0.5,-185),
        Size=UDim2.new(0,570,0,370),
        ClipsDescendants=true,
    })
    Corner(12,Win)
    local winStroke = Stroke(T.Border,1,Win)
    onTheme(function() Win.BackgroundColor3=T.Bg; winStroke.Color=T.Border end)

    -- ── Topbar ───────────────────────────────────────────────
    local Topbar = New("Frame",{
        Parent=Win,BackgroundColor3=T.Panel,
        Size=UDim2.new(1,0,0,46),BorderSizePixel=0,
    })
    MakeDraggable(Topbar,Win)
    onTheme(function() Topbar.BackgroundColor3=T.Panel end)

    New("Frame",{Parent=Win,BackgroundColor3=T.Border,
        Position=UDim2.new(0,0,0,46),Size=UDim2.new(1,0,0,1),BorderSizePixel=0})

    -- Left accent stripe
    local topStripe = New("Frame",{Parent=Topbar,BackgroundColor3=T.Accent,
        Position=UDim2.new(0,0,0.2,0),Size=UDim2.new(0,3,0.6,0),BorderSizePixel=0})
    onTheme(function() topStripe.BackgroundColor3=T.Accent end)

    New("TextLabel",{Parent=Topbar,BackgroundTransparency=1,
        Position=UDim2.new(0,18,0,0),Size=UDim2.new(1,-80,1,0),
        Font=Enum.Font.GothamBold,Text=title,TextColor3=T.Text,TextSize=15,
        TextXAlignment=Enum.TextXAlignment.Left})

    local CloseBox = New("TextButton",{
        Parent=Topbar,BackgroundColor3=T.Card,
        Position=UDim2.new(1,-38,0.5,-14),Size=UDim2.new(0,28,0,28),
        Font=Enum.Font.GothamBold,Text="X",TextColor3=T.Muted,TextSize=13,
        AutoButtonColor=false,
    })
    Corner(6,CloseBox); Stroke(T.Border,1,CloseBox)
    CloseBox.MouseEnter:Connect(function() Tw(CloseBox,0.15,{BackgroundColor3=T.Red,TextColor3=T.Text}) end)
    CloseBox.MouseLeave:Connect(function() Tw(CloseBox,0.15,{BackgroundColor3=T.Card,TextColor3=T.Muted}) end)
    CloseBox.MouseButton1Click:Connect(function() Root:Destroy() end)

    UserInputService.InputBegan:Connect(function(inp,proc)
        if not proc and inp.KeyCode==togKey then Win.Visible=not Win.Visible end
    end)

    -- ── Sidebar ──────────────────────────────────────────────
    local SIDE_W = 140
    local Sidebar = New("Frame",{
        Parent=Win,BackgroundColor3=T.Panel,
        Position=UDim2.new(0,0,0,47),
        Size=UDim2.new(0,SIDE_W,1,-47),
        ClipsDescendants=true,BorderSizePixel=0,
    })
    onTheme(function() Sidebar.BackgroundColor3=T.Panel end)

    New("Frame",{Parent=Sidebar,BackgroundColor3=T.Border,
        Position=UDim2.new(1,-1,0,0),Size=UDim2.new(0,1,1,0),BorderSizePixel=0})

    local TabList = New("ScrollingFrame",{
        Parent=Sidebar,BackgroundTransparency=1,
        Position=UDim2.new(0,0,0,10),Size=UDim2.new(1,0,1,-42),
        ScrollBarThickness=0,AutomaticCanvasSize=Enum.AutomaticSize.Y,
        CanvasSize=UDim2.new(0,0,0,0),Active=true,
    })
    New("UIListLayout",{Parent=TabList,Padding=UDim.new(0,4),
        HorizontalAlignment=Enum.HorizontalAlignment.Center})
    New("UIPadding",{Parent=TabList,PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)})

    New("TextLabel",{Parent=Sidebar,BackgroundTransparency=1,
        Position=UDim2.new(0,0,1,-32),Size=UDim2.new(1,0,0,32),
        Font=Enum.Font.Gotham,Text="by NochHawk",TextColor3=T.Muted,
        TextSize=10,TextTransparency=0.5})

    -- ── Content Area ─────────────────────────────────────────
    local Content = New("Frame",{
        Parent=Win,BackgroundTransparency=1,
        Position=UDim2.new(0,SIDE_W,0,47),
        Size=UDim2.new(1,-SIDE_W,1,-47),
        ClipsDescendants=true,
    })

    -- ── Window object ────────────────────────────────────────
    local W = { _first = true }

    function W:CreateTab(tabName)
        local Btn = New("TextButton",{
            Parent=TabList,BackgroundColor3=T.Accent,
            BackgroundTransparency=1,Size=UDim2.new(1,0,0,32),
            Font=Enum.Font.GothamSemibold,Text=tabName,
            TextColor3=T.Muted,TextSize=13,AutoButtonColor=false,
        })
        Corner(7,Btn)
        onTheme(function()
            Tw(Btn,0.3,{TextColor3= (Btn.BackgroundTransparency<0.5) and T.Text or T.Muted})
            if Btn.BackgroundTransparency < 0.5 then
                Tw(Btn,0.3,{BackgroundColor3=T.Accent})
            end
        end)

        local Pane = New("ScrollingFrame",{
            Parent=Content,BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0),ScrollBarThickness=3,
            ScrollBarImageColor3=T.Accent,
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            CanvasSize=UDim2.new(0,0,0,0),
            ScrollingDirection=Enum.ScrollingDirection.Y,
            Visible=false,Active=true,
        })
        New("UIPadding",{Parent=Pane,PaddingTop=UDim.new(0,12),PaddingLeft=UDim.new(0,12),
            PaddingRight=UDim.new(0,12),PaddingBottom=UDim.new(0,12)})
        New("UIListLayout",{Parent=Pane,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8)})
        onTheme(function() Pane.ScrollBarImageColor3=T.Accent end)

        local function activate()
            for _,c in ipairs(TabList:GetChildren()) do
                if c:IsA("TextButton") then
                    Tw(c,0.18,{BackgroundTransparency=1,TextColor3=T.Muted})
                end
            end
            for _,c in ipairs(Content:GetChildren()) do
                if c:IsA("ScrollingFrame") then c.Visible=false end
            end
            Tw(Btn,0.18,{BackgroundTransparency=0,TextColor3=T.Text,BackgroundColor3=T.Accent})
            Pane.Visible=true
        end

        Btn.MouseButton1Click:Connect(activate)
        if W._first then W._first=false; activate() end

        -- ── Elements ─────────────────────────────────────────
        local E = {}

        -- helper: base card frame
        local function Card(h)
            local f = New("Frame",{Parent=Pane,BackgroundColor3=T.Card,Size=UDim2.new(1,0,0,h)})
            Corner(8,f); Stroke(T.Border,1,f)
            onTheme(function() f.BackgroundColor3=T.Card; f.UIStroke.Color=T.Border end)
            return f
        end

        -- SECTION
        function E:CreateSection(sname)
            local F = New("Frame",{Parent=Pane,BackgroundTransparency=1,Size=UDim2.new(1,0,0,20)})
            local L = New("TextLabel",{Parent=F,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
                Font=Enum.Font.GothamBold,Text=sname:upper(),TextColor3=T.Accent,
                TextSize=10,TextXAlignment=Enum.TextXAlignment.Left})
            New("Frame",{Parent=F,BackgroundColor3=T.Border,
                Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),BorderSizePixel=0})
            onTheme(function() L.TextColor3=T.Accent end)
        end

        -- BUTTON
        function E:CreateButton(o2)
            local bname = o2.Name or "Button"
            local cb    = o2.Callback or function() end
            local B = New("TextButton",{Parent=Pane,BackgroundColor3=T.Card,
                Size=UDim2.new(1,0,0,36),Font=Enum.Font.GothamSemibold,
                Text=bname,TextColor3=T.Text,TextSize=13,AutoButtonColor=false})
            Corner(8,B); Stroke(T.Border,1,B)
            onTheme(function() B.BackgroundColor3=T.Card; B.TextColor3=T.Text; B.UIStroke.Color=T.Border end)
            B.MouseEnter:Connect(function() Tw(B,0.15,{BackgroundColor3=T.Accent}) end)
            B.MouseLeave:Connect(function() Tw(B,0.15,{BackgroundColor3=T.Card}) end)
            B.MouseButton1Click:Connect(function()
                Tw(B,0.07,{BackgroundColor3=T.AccHi})
                task.delay(0.12,function() Tw(B,0.15,{BackgroundColor3=T.Card}) end)
                cb()
            end)
            return {Set=function(_,t2) B.Text=t2 end}
        end

        -- TOGGLE
        function E:CreateToggle(o2)
            local tname = o2.Name or "Toggle"
            local state = o2.Default or false
            local cb    = o2.Callback or function() end
            local Row = Card(36)
            New("TextLabel",{Parent=Row,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-62,1,0),
                Font=Enum.Font.GothamSemibold,Text=tname,TextColor3=T.Text,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left})
            local Track = New("Frame",{Parent=Row,BackgroundColor3=state and T.Accent or T.Border,
                Position=UDim2.new(1,-52,0.5,-11),Size=UDim2.new(0,40,0,22)})
            Corner(11,Track)
            local Thumb = New("Frame",{Parent=Track,BackgroundColor3=T.Text,
                Size=UDim2.new(0,18,0,18),
                Position=state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)})
            Corner(9,Thumb)
            local Hit = New("TextButton",{Parent=Track,BackgroundTransparency=1,
                Size=UDim2.new(1,0,1,0),Text=""})
            local function setT(v)
                state=v
                Tw(Track,0.18,{BackgroundColor3=v and T.Accent or T.Border})
                Tw(Thumb,0.18,{Position=v and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)})
                cb(v)
            end
            Hit.MouseButton1Click:Connect(function() setT(not state) end)
            onTheme(function()
                Track.BackgroundColor3 = state and T.Accent or T.Border
                Thumb.BackgroundColor3 = T.Text
            end)
            setT(state)
            return {Set=function(_,v) setT(v) end}
        end

        -- SLIDER
        function E:CreateSlider(o2)
            local sname   = o2.Name or "Slider"
            local smin    = o2.Min or 0
            local smax    = o2.Max or 100
            local sval    = math.clamp(o2.Default or smin,smin,smax)
            local isFloat = o2.Float or false
            local cb      = o2.Callback or function() end
            local Row = Card(50)
            New("TextLabel",{Parent=Row,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,6),Size=UDim2.new(0.6,0,0,18),
                Font=Enum.Font.GothamSemibold,Text=sname,TextColor3=T.Text,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left})
            local ValLbl = New("TextLabel",{Parent=Row,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,6),Size=UDim2.new(1,-24,0,18),
                Font=Enum.Font.GothamBold,Text=tostring(sval),TextColor3=T.Accent,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Right})
            local Track = New("Frame",{Parent=Row,BackgroundColor3=T.Border,
                Position=UDim2.new(0,12,0,34),Size=UDim2.new(1,-24,0,6)})
            Corner(3,Track)
            local Fill = New("Frame",{Parent=Track,BackgroundColor3=T.Accent,
                Size=UDim2.new(math.clamp((sval-smin)/(smax-smin),0,1),0,1,0)})
            Corner(3,Fill)
            local Dot = New("Frame",{Parent=Fill,BackgroundColor3=T.Text,
                AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.new(0,14,0,14)})
            Corner(7,Dot)
            local Hit = New("TextButton",{Parent=Row,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,26),Size=UDim2.new(1,-24,0,22),Text=""})
            onTheme(function()
                Track.BackgroundColor3=T.Border; Fill.BackgroundColor3=T.Accent
                ValLbl.TextColor3=T.Accent; Dot.BackgroundColor3=T.Text
            end)
            local function rnd(v) return isFloat and tonumber(string.format("%.1f",v)) or math.floor(v+.5) end
            local function setS(px)
                local pct=math.clamp((px-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1)
                sval=rnd(smin+(smax-smin)*pct)
                Tw(Fill,0.05,{Size=UDim2.new(pct,0,1,0)},Enum.EasingStyle.Linear)
                ValLbl.Text=tostring(sval); cb(sval)
            end
            local drag=false
            Hit.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;setS(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if drag and i.UserInputType==Enum.UserInputType.MouseMovement then setS(i.Position.X) end
            end)
            return {Set=function(_,v)
                local pct=math.clamp((v-smin)/(smax-smin),0,1)
                sval=rnd(v); Fill.Size=UDim2.new(pct,0,1,0); ValLbl.Text=tostring(sval); cb(sval)
            end}
        end

        -- DROPDOWN
        function E:CreateDropdown(o2)
            local dname = o2.Name or "Dropdown"
            local items = o2.Options or {}
            local cb    = o2.Callback or function() end
            local open  = false
            local itemH = 28
            local Wrap = New("Frame",{Parent=Pane,BackgroundColor3=T.Card,
                Size=UDim2.new(1,0,0,36),ClipsDescendants=true})
            Corner(8,Wrap); Stroke(T.Border,1,Wrap)
            onTheme(function() Wrap.BackgroundColor3=T.Card; Wrap.UIStroke.Color=T.Border end)

            local Hdr = New("Frame",{Parent=Wrap,BackgroundTransparency=1,Size=UDim2.new(1,0,0,36)})
            local NameLbl = New("TextLabel",{Parent=Hdr,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-50,1,0),
                Font=Enum.Font.GothamSemibold,Text=dname,TextColor3=T.Text,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left})
            local SelLbl = New("TextLabel",{Parent=Hdr,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-50,1,0),
                Font=Enum.Font.Gotham,Text="",TextColor3=T.Muted,TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Right,Visible=false})
            local Arrow = New("TextLabel",{Parent=Hdr,BackgroundTransparency=1,
                Position=UDim2.new(1,-32,0,0),Size=UDim2.new(0,26,1,0),
                Font=Enum.Font.GothamBold,Text="v",TextColor3=T.Muted,TextSize=11})
            local HBtn = New("TextButton",{Parent=Hdr,BackgroundTransparency=1,
                Size=UDim2.new(1,0,1,0),Text=""})
            New("Frame",{Parent=Wrap,BackgroundColor3=T.Border,
                Position=UDim2.new(0,8,0,36),Size=UDim2.new(1,-16,0,1),BorderSizePixel=0})
            local IHolder = New("Frame",{Parent=Wrap,BackgroundTransparency=1,
                Position=UDim2.new(0,0,0,37),Size=UDim2.new(1,0,1,-37)})
            New("UIListLayout",{Parent=IHolder,SortOrder=Enum.SortOrder.LayoutOrder})
            onTheme(function()
                NameLbl.TextColor3=T.Text; SelLbl.TextColor3=T.Muted; Arrow.TextColor3=T.Muted
            end)
            HBtn.MouseButton1Click:Connect(function()
                open=not open
                local h=36+1+math.min(#items*itemH,5*itemH)
                Tw(Wrap,0.2,{Size=open and UDim2.new(1,0,0,h) or UDim2.new(1,0,0,36)})
                Arrow.Text=open and "^" or "v"
            end)
            for _,item in ipairs(items) do
                local IB = New("TextButton",{Parent=IHolder,BackgroundColor3=T.Accent,
                    BackgroundTransparency=1,Size=UDim2.new(1,0,0,itemH),
                    Font=Enum.Font.Gotham,Text="  "..item,TextColor3=T.Muted,TextSize=12,
                    TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false})
                IB.MouseEnter:Connect(function() Tw(IB,0.12,{BackgroundTransparency=0.85,TextColor3=T.Text}) end)
                IB.MouseLeave:Connect(function() Tw(IB,0.12,{BackgroundTransparency=1,TextColor3=T.Muted}) end)
                IB.MouseButton1Click:Connect(function()
                    SelLbl.Text=item; SelLbl.Visible=true
                    open=false; Arrow.Text="v"
                    Tw(Wrap,0.2,{Size=UDim2.new(1,0,0,36)}); cb(item)
                end)
                onTheme(function() IB.BackgroundColor3=T.Accent; IB.TextColor3=T.Muted end)
            end
            return {
                Set=function(_,v) SelLbl.Text=v; SelLbl.Visible=true; cb(v) end,
                GetSelected=function(_) return SelLbl.Text end,
            }
        end

        -- TEXTBOX
        function E:CreateTextBox(o2)
            local bname = o2.Name or "Input"
            local def   = o2.Default or ""
            local cb    = o2.Callback or function() end
            local Row = Card(36)
            New("TextLabel",{Parent=Row,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,0),Size=UDim2.new(0.4,-4,1,0),
                Font=Enum.Font.GothamSemibold,Text=bname,TextColor3=T.Text,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left})
            local Box = New("TextBox",{Parent=Row,BackgroundColor3=T.Bg,
                Position=UDim2.new(0.42,0,0.5,-12),Size=UDim2.new(0.56,0,0,24),
                Font=Enum.Font.Gotham,Text=def,PlaceholderText="Enter...",
                PlaceholderColor3=T.Muted,TextColor3=T.Text,TextSize=12,ClearTextOnFocus=false})
            Corner(6,Box)
            local bs=Stroke(T.Border,1,Box)
            Box.Focused:Connect(function() Tw(bs,0.18,{Color=T.Accent}) end)
            Box.FocusLost:Connect(function() Tw(bs,0.18,{Color=T.Border}); cb(Box.Text) end)
            onTheme(function() Box.BackgroundColor3=T.Bg; Box.TextColor3=T.Text end)
            return {Set=function(_,v) Box.Text=v; cb(v) end}
        end

        -- KEYBIND
        function E:CreateKeybind(o2)
            local kname  = o2.Name or "Keybind"
            local defKey = o2.Default or Enum.KeyCode.E
            local cb     = o2.Callback or function() end
            local curKey = defKey
            local conn; local listening=false
            local Row = Card(36)
            New("TextLabel",{Parent=Row,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-110,1,0),
                Font=Enum.Font.GothamSemibold,Text=kname,TextColor3=T.Text,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left})
            local KBtn = New("TextButton",{Parent=Row,BackgroundColor3=T.Bg,
                Position=UDim2.new(1,-100,0.5,-12),Size=UDim2.new(0,90,0,24),
                Font=Enum.Font.GothamBold,Text="["..curKey.Name.."]",
                TextColor3=T.Muted,TextSize=11,AutoButtonColor=false})
            Corner(6,KBtn); Stroke(T.Border,1,KBtn)
            KBtn.MouseButton1Click:Connect(function()
                if conn then conn:Disconnect() end
                listening=true; KBtn.Text="[ ... ]"; KBtn.TextColor3=T.Accent
                conn=UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.Keyboard
                    and i.KeyCode~=Enum.KeyCode.Unknown then
                        curKey=i.KeyCode; KBtn.Text="["..curKey.Name.."]"
                        KBtn.TextColor3=T.Muted; listening=false; conn:Disconnect()
                    end
                end)
            end)
            UserInputService.InputBegan:Connect(function(i,proc)
                if not proc and not listening and i.KeyCode==curKey then cb() end
            end)
            onTheme(function() KBtn.BackgroundColor3=T.Bg; KBtn.TextColor3=T.Muted end)
            return {Set=function(_,k) curKey=k; KBtn.Text="["..k.Name.."]" end}
        end

        -- COLOR PICKER
        function E:CreateColorPicker(o2)
            local cname = o2.Name or "Color"
            local state = o2.Default or Color3.fromRGB(108,99,255)
            local cb    = o2.Callback or function() end

            local Row = Card(36)
            New("TextLabel",{Parent=Row,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-120,1,0),
                Font=Enum.Font.GothamSemibold,Text=cname,TextColor3=T.Text,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left})

            local Preview = New("Frame",{Parent=Row,BackgroundColor3=state,
                Position=UDim2.new(1,-44,0.5,-11),Size=UDim2.new(0,32,0,22)})
            Corner(6,Preview); Stroke(T.Border,1,Preview)

            local HexLbl = New("TextLabel",{Parent=Row,BackgroundTransparency=1,
                Position=UDim2.new(1,-106,0.5,-9),Size=UDim2.new(0,58,0,18),
                Font=Enum.Font.Code,Text="#"..toHex(state),TextColor3=T.Muted,TextSize=11})
            onTheme(function() HexLbl.TextColor3=T.Muted end)

            -- Click → open full popup
            local ClickBtn = New("TextButton",{Parent=Row,BackgroundTransparency=1,
                Size=UDim2.new(1,0,1,0),Text=""})
            ClickBtn.MouseButton1Click:Connect(function()
                CreateColorPickerPopup(state, function(newColor)
                    state = newColor
                    Preview.BackgroundColor3 = newColor
                    HexLbl.Text = "#"..toHex(newColor)
                    cb(newColor)
                end)
            end)

            return {
                Set=function(_,c)
                    state=c; Preview.BackgroundColor3=c
                    HexLbl.Text="#"..toHex(c); cb(c)
                end
            }
        end

        return E
    end -- CreateTab

    return W
end -- CreateWindow

return Library
