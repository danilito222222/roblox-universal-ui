-- ============================================================
--  DEMO SCRIPT #3  |  UI Component Showcase
--  Just a pure visual test of EVERY element in the library
-- ============================================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/danilito222222/roblox-universal-ui/master/library.lua"))()

local Window = Library:CreateWindow({ Title = "Component Showcase" })

-- ─── TAB 1: BUTTONS ──────────────────────────────────────────
local T1 = Window:CreateTab("Buttons")

T1:CreateSection("Basic Buttons")

local counter = 0
local counterBtn = T1:CreateButton({
    Name     = "Click Counter: 0",
    Callback = function()
        counter = counter + 1
        counterBtn:Set("Click Counter: "..counter)
        if counter % 5 == 0 then
            Library:Notify({ Title = "Milestone!", Text = "You clicked "..counter.." times!", Type = "success" })
        end
    end
})

T1:CreateButton({
    Name = "Success Notification",
    Callback = function()
        Library:Notify({ Title = "Success", Text = "Operation completed successfully.", Type = "success", Duration = 3 })
    end
})

T1:CreateButton({
    Name = "Error Notification",
    Callback = function()
        Library:Notify({ Title = "Error", Text = "Something went wrong!", Type = "error", Duration = 3 })
    end
})

T1:CreateButton({
    Name = "Info Notification",
    Callback = function()
        Library:Notify({ Title = "Info", Text = "This is an informational message.", Type = "info", Duration = 3 })
    end
})

T1:CreateSection("Dynamic Button")

local isActive = false
local dynBtn
dynBtn = T1:CreateButton({
    Name = "Start Process",
    Callback = function()
        isActive = not isActive
        dynBtn:Set(isActive and "Stop Process" or "Start Process")
        Library:Notify({
            Title = isActive and "Started" or "Stopped",
            Text  = isActive and "Process is now running." or "Process has been stopped.",
            Type  = isActive and "success" or "error",
            Duration = 2,
        })
    end
})

-- ─── TAB 2: TOGGLES & SLIDERS ────────────────────────────────
local T2 = Window:CreateTab("Toggles")

T2:CreateSection("Toggles")

T2:CreateToggle({
    Name    = "Feature Alpha",
    Default = false,
    Callback = function(v)
        Library:Notify({ Title = "Feature Alpha", Text = "State: "..tostring(v), Duration = 1 })
    end
})

T2:CreateToggle({
    Name    = "Feature Beta",
    Default = true,
    Callback = function(v)
        Library:Notify({ Title = "Feature Beta", Text = "State: "..tostring(v), Duration = 1 })
    end
})

local linkedToggle = T2:CreateToggle({
    Name    = "Master Switch",
    Default = false,
    Callback = function(v)
        Library:Notify({ Title = "Master", Text = v and "All systems go!" or "All systems off.", Duration = 2 })
    end
})

T2:CreateButton({
    Name = "Force Toggle ON (Setter test)",
    Callback = function()
        linkedToggle:Set(true)
        Library:Notify({ Title = "Setter", Text = "Toggle was set to TRUE from code!", Type = "success" })
    end
})

T2:CreateSection("Sliders")

T2:CreateSlider({ Name = "Integer Slider", Min = 0,   Max = 100, Default = 50, Callback = function(_) end })
T2:CreateSlider({ Name = "Float Slider",   Min = 0.0, Max = 1.0, Default = 0.5, Float = true, Callback = function(_) end })
T2:CreateSlider({ Name = "Speed",          Min = 1,   Max = 500, Default = 16,  Callback = function(_) end })

-- ─── TAB 3: INPUTS ───────────────────────────────────────────
local T3 = Window:CreateTab("Inputs")

T3:CreateSection("Text Input")

local lastInput = ""
local inputBox = T3:CreateTextBox({
    Name    = "Your Name",
    Default = "",
    Callback = function(text)
        lastInput = text
    end
})

T3:CreateButton({
    Name = "Greet Me",
    Callback = function()
        local name = lastInput ~= "" and lastInput or "Stranger"
        Library:Notify({ Title = "Hello!", Text = "Hi, "..name.."! Welcome.", Type = "success", Duration = 3 })
    end
})

T3:CreateSection("Dropdown")

T3:CreateDropdown({
    Name    = "Select Fruit",
    Options = { "Apple", "Banana", "Orange", "Mango", "Strawberry" },
    Callback = function(sel)
        Library:Notify({ Title = "Fruit Selected", Text = "You picked: "..sel, Duration = 2 })
    end
})

T3:CreateDropdown({
    Name    = "Game Mode",
    Options = { "Easy", "Normal", "Hard", "Impossible" },
    Callback = function(sel)
        Library:Notify({ Title = "Mode", Text = sel.." mode selected.", Duration = 2 })
    end
})

T3:CreateSection("Keybind")

T3:CreateKeybind({
    Name    = "Say Hello (Press Key)",
    Default = Enum.KeyCode.H,
    Callback = function()
        Library:Notify({ Title = "Keybind Fired!", Text = "H key was pressed.", Type = "success", Duration = 2 })
    end
})

-- ─── TAB 4: COLORS & THEME ───────────────────────────────────
local T4 = Window:CreateTab("Colors")

T4:CreateSection("Color Pickers")

T4:CreateColorPicker({
    Name    = "Primary Color",
    Default = Color3.fromRGB(108, 99, 255),
    Callback = function(c)
        Library:Notify({
            Title = "Color Changed",
            Text  = string.format("R=%d G=%d B=%d", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)),
            Duration = 2,
        })
    end
})

T4:CreateColorPicker({
    Name    = "Accent Color",
    Default = Color3.fromRGB(52, 211, 153),
    Callback = function(_) end
})

T4:CreateColorPicker({
    Name    = "Background Color",
    Default = Color3.fromRGB(15, 15, 18),
    Callback = function(_) end
})

T4:CreateSection("Theme Switcher")

T4:CreateDropdown({
    Name    = "Choose Theme",
    Options = Library:GetThemes(),
    Callback = function(sel)
        Library:SetTheme(sel)
        Library:Notify({ Title = "Theme", Text = "Applied: "..sel, Type = "success", Duration = 2 })
    end
})

-- Initial welcome
task.delay(0.5, function()
    Library:Notify({
        Title    = "Component Showcase",
        Text     = "All library elements are loaded. Explore the tabs!",
        Type     = "success",
        Duration = 4,
    })
end)
