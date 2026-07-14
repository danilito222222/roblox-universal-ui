-- ============================================================
--  DEMO SCRIPT #1  |  Character & Player Hub
--  Shows: Toggles, Sliders, Buttons, Sections, Notifications
-- ============================================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/danilito222222/roblox-universal-ui/master/library.lua"))()

local Players       = game:GetService("Players")
local LocalPlayer   = Players.LocalPlayer
local RunService    = game:GetService("RunService")

local Window = Library:CreateWindow({ Title = "Player Hub" })

-- ─── TAB: CHARACTER ──────────────────────────────────────────
local CharTab = Window:CreateTab("Character")

CharTab:CreateSection("Movement")

local wsToggle
local wsSlider = CharTab:CreateSlider({
    Name    = "WalkSpeed",
    Min     = 16,
    Max     = 250,
    Default = 16,
    Callback = function(val)
        local chr = LocalPlayer.Character
        if chr and chr:FindFirstChild("Humanoid") then
            chr.Humanoid.WalkSpeed = val
        end
    end
})

local jpSlider = CharTab:CreateSlider({
    Name    = "JumpPower",
    Min     = 50,
    Max     = 350,
    Default = 50,
    Callback = function(val)
        local chr = LocalPlayer.Character
        if chr and chr:FindFirstChild("Humanoid") then
            chr.Humanoid.JumpPower = val
        end
    end
})

CharTab:CreateToggle({
    Name    = "Infinite Jump",
    Default = false,
    Callback = function(state)
        if state then
            _G.InfJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                local chr = LocalPlayer.Character
                if chr and chr:FindFirstChild("Humanoid") then
                    chr.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            Library:Notify({ Title = "Infinite Jump", Text = "Enabled! Press Space anytime.", Type = "success" })
        else
            if _G.InfJumpConn then _G.InfJumpConn:Disconnect() end
            Library:Notify({ Title = "Infinite Jump", Text = "Disabled.", Type = "error" })
        end
    end
})

CharTab:CreateToggle({
    Name    = "Noclip",
    Default = false,
    Callback = function(state)
        _G.NoclipEnabled = state
        if state then
            _G.NoclipConn = RunService.Stepped:Connect(function()
                local chr = LocalPlayer.Character
                if chr then
                    for _, part in ipairs(chr:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            Library:Notify({ Title = "Noclip", Text = "You can now walk through walls.", Type = "success" })
        else
            if _G.NoclipConn then _G.NoclipConn:Disconnect() end
            Library:Notify({ Title = "Noclip", Text = "Collisions restored.", Type = "error" })
        end
    end
})

CharTab:CreateSection("Utility")

CharTab:CreateButton({
    Name = "Respawn Character",
    Callback = function()
        LocalPlayer:LoadCharacter()
        Library:Notify({ Title = "Respawned", Text = "Character has been respawned.", Type = "success", Duration = 2 })
    end
})

CharTab:CreateButton({
    Name = "Reset Stats (WalkSpeed / Jump)",
    Callback = function()
        local chr = LocalPlayer.Character
        if chr and chr:FindFirstChild("Humanoid") then
            chr.Humanoid.WalkSpeed = 16
            chr.Humanoid.JumpPower = 50
        end
        wsSlider:Set(16)
        jpSlider:Set(50)
        Library:Notify({ Title = "Reset", Text = "Stats restored to default.", Duration = 2 })
    end
})

-- ─── TAB: VISUALS ────────────────────────────────────────────
local VisTab = Window:CreateTab("Visuals")

VisTab:CreateSection("ESP")

local espToggle = VisTab:CreateToggle({
    Name    = "Player ESP (Highlight)",
    Default = false,
    Callback = function(state)
        -- Simple Highlight ESP demo
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local existing = plr.Character:FindFirstChild("ESPHighlight")
                if state then
                    if not existing then
                        local h = Instance.new("SelectionBox")
                        h.Name       = "ESPHighlight"
                        h.Adornee    = plr.Character
                        h.Color3     = Color3.fromRGB(255, 50, 50)
                        h.LineThickness = 0.04
                        h.Parent     = plr.Character
                    end
                else
                    if existing then existing:Destroy() end
                end
            end
        end
        Library:Notify({
            Title = "ESP",
            Text  = state and "Highlighting all players." or "ESP removed.",
            Type  = state and "success" or "error",
        })
    end
})

local colorPicker = VisTab:CreateColorPicker({
    Name    = "ESP Color",
    Default = Color3.fromRGB(255, 50, 50),
    Callback = function(color)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local h = plr.Character:FindFirstChild("ESPHighlight")
                if h then h.Color3 = color end
            end
        end
    end
})

VisTab:CreateSection("Camera")

VisTab:CreateSlider({
    Name    = "FOV",
    Min     = 50,
    Max     = 120,
    Default = 70,
    Callback = function(val)
        workspace.CurrentCamera.FieldOfView = val
    end
})

-- ─── TAB: SETTINGS ───────────────────────────────────────────
local SetTab = Window:CreateTab("Settings")

SetTab:CreateSection("Interface")

SetTab:CreateDropdown({
    Name    = "Theme",
    Options = Library:GetThemes(),
    Callback = function(selected)
        Library:SetTheme(selected)
        Library:Notify({ Title = "Theme", Text = "Switched to "..selected, Duration = 2 })
    end
})

SetTab:CreateKeybind({
    Name    = "Toggle Menu",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        Library:Notify({ Title = "Keybind", Text = "Menu toggled!", Duration = 1 })
    end
})

SetTab:CreateSection("Info")

SetTab:CreateButton({
    Name = "Show Welcome Notification",
    Callback = function()
        Library:Notify({ Title = "Welcome!", Text = "NochHawk UI v5 is running.", Type = "success", Duration = 4 })
    end
})

SetTab:CreateButton({
    Name = "Show Error Example",
    Callback = function()
        Library:Notify({ Title = "Error", Text = "Something went wrong (this is just a demo).", Type = "error", Duration = 4 })
    end
})
