-- ============================================================
--  DEMO SCRIPT #2  |  Teleport & World Hub
--  Shows: TextBox input, Dropdowns, Buttons, Sections
-- ============================================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/danilito222222/roblox-universal-ui/master/library.lua"))()

local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window   = Library:CreateWindow({ Title = "World Hub" })

-- ─── TAB: TELEPORT ───────────────────────────────────────────
local TpTab = Window:CreateTab("Teleport")

TpTab:CreateSection("By Name")

local targetInput = TpTab:CreateTextBox({
    Name    = "Player Name",
    Default = "",
    Callback = function(_) end -- will read on button click
})

TpTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        -- Note: .Text is tracked internally; we trigger sync
        local chr = LocalPlayer.Character
        if not chr then
            Library:Notify({ Title = "Error", Text = "You have no character!", Type = "error" })
            return
        end

        local root = chr:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local found = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name:lower():find(_G._tpTarget or "") and plr ~= LocalPlayer then
                found = plr
                break
            end
        end

        if found and found.Character and found.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = found.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
            Library:Notify({ Title = "Teleported", Text = "Teleported to "..found.Name, Type = "success" })
        else
            Library:Notify({ Title = "Not Found", Text = "Player not found.", Type = "error" })
        end
    end
})

-- Re-route textbox to save target globally
targetInput = TpTab:CreateTextBox({
    Name    = "Save Target",
    Default = "",
    Callback = function(text)
        _G._tpTarget = text:lower()
    end
})

TpTab:CreateSection("By Coordinates")

local xInput = TpTab:CreateTextBox({ Name = "X", Default = "0" })
local yInput = TpTab:CreateTextBox({ Name = "Y", Default = "0" })
local zInput = TpTab:CreateTextBox({ Name = "Z", Default = "0" })

TpTab:CreateButton({
    Name = "Teleport to Coordinates",
    Callback = function()
        local chr  = LocalPlayer.Character
        local root = chr and chr:FindFirstChild("HumanoidRootPart")
        if not root then return end

        -- Try to read: we store via onscreen labels
        local x = tonumber(_G._cx or "0") or 0
        local y = tonumber(_G._cy or "0") or 0
        local z = tonumber(_G._cz or "0") or 0

        root.CFrame = CFrame.new(x, y, z)
        Library:Notify({ Title = "Teleported", Text = string.format("Moved to (%.1f, %.1f, %.1f)", x, y, z), Type = "success" })
    end
})

-- Wire coordinate boxes
xInput = TpTab:CreateTextBox({ Name = "X Coord", Default = "0", Callback = function(v) _G._cx = v end })
yInput = TpTab:CreateTextBox({ Name = "Y Coord", Default = "0", Callback = function(v) _G._cy = v end })
zInput = TpTab:CreateTextBox({ Name = "Z Coord", Default = "0", Callback = function(v) _G._cz = v end })

TpTab:CreateButton({
    Name = "Copy My Position",
    Callback = function()
        local chr  = LocalPlayer.Character
        local root = chr and chr:FindFirstChild("HumanoidRootPart")
        if root then
            local p = root.Position
            _G._cx = string.format("%.1f", p.X)
            _G._cy = string.format("%.1f", p.Y)
            _G._cz = string.format("%.1f", p.Z)
            Library:Notify({
                Title = "Position Copied",
                Text  = string.format("X=%.1f  Y=%.1f  Z=%.1f", p.X, p.Y, p.Z),
                Type  = "success",
                Duration = 5
            })
        end
    end
})

-- ─── TAB: WORLD ──────────────────────────────────────────────
local WorldTab = Window:CreateTab("World")

WorldTab:CreateSection("Time & Lighting")

local lighting = game:GetService("Lighting")

WorldTab:CreateSlider({
    Name    = "Time of Day (hours)",
    Min     = 0,
    Max     = 24,
    Default = math.floor(lighting.ClockTime),
    Callback = function(val)
        lighting.ClockTime = val
    end
})

WorldTab:CreateSlider({
    Name    = "Brightness",
    Min     = 0,
    Max     = 10,
    Default = 2,
    Float   = true,
    Callback = function(val)
        lighting.Brightness = val
    end
})

WorldTab:CreateDropdown({
    Name    = "Weather Preset",
    Options = { "Clear", "Foggy", "Dark Night" },
    Callback = function(sel)
        if sel == "Clear" then
            lighting.ClockTime    = 14
            lighting.FogEnd       = 100000
            lighting.Brightness   = 2
        elseif sel == "Foggy" then
            lighting.FogStart     = 5
            lighting.FogEnd       = 80
            lighting.FogColor     = Color3.fromRGB(180,180,190)
            lighting.Brightness   = 1
        elseif sel == "Dark Night" then
            lighting.ClockTime    = 0
            lighting.Brightness   = 0.2
            lighting.FogEnd       = 100000
        end
        Library:Notify({ Title = "Weather", Text = sel.." preset applied.", Type = "success", Duration = 2 })
    end
})

WorldTab:CreateSection("Gravity")

WorldTab:CreateSlider({
    Name    = "Gravity",
    Min     = 0,
    Max     = 300,
    Default = 196,
    Callback = function(val)
        workspace.Gravity = val
    end
})

WorldTab:CreateButton({
    Name = "Reset Gravity",
    Callback = function()
        workspace.Gravity = 196
        Library:Notify({ Title = "Gravity", Text = "Reset to default (196).", Duration = 2 })
    end
})

-- ─── TAB: SETTINGS ───────────────────────────────────────────
local SettTab = Window:CreateTab("Settings")

SettTab:CreateSection("Theme")

SettTab:CreateDropdown({
    Name    = "UI Theme",
    Options = Library:GetThemes(),
    Callback = function(sel)
        Library:SetTheme(sel)
        Library:Notify({ Title = "Theme", Text = "Applied: "..sel, Duration = 2 })
    end
})

SettTab:CreateSection("About")

SettTab:CreateButton({
    Name = "Version Info",
    Callback = function()
        Library:Notify({
            Title    = "NochHawk UI v5",
            Text     = "Open-source, AI-generated. github.com/danilito222222",
            Type     = "info",
            Duration = 5
        })
    end
})
