-- INSANE EXOTIC GUI LIBRARY (INSANEGUI)
local InsaneGUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Gui = Instance.new("ScreenGui")
Gui.Name = "InsaneExoticGUI"
Gui.ResetOnSpawn = false
Gui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 450, 0, 300)
mainFrame.Position = UDim2.new(0.3, math.random(-100,100), 0.3, math.random(-100,100))
mainFrame.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = Gui

-- Neon glow effect
local UIStroke = Instance.new("UIStroke", mainFrame)
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 20, 147)

-- Random drifting
local driftSpeed = Vector2.new(math.random() - 0.5, math.random() - 0.5) * 5
RunService.Heartbeat:Connect(function(dt)
    local pos = mainFrame.Position
    local newX = pos.X.Scale + driftSpeed.X * dt * 0.01
    local newY = pos.Y.Scale + driftSpeed.Y * dt * 0.01
    mainFrame.Position = UDim2.new(newX % 1, pos.X.Offset, newY % 1, pos.Y.Offset)
end)

-- Tab shuffle
local tabs = {"AimBot", "ESP", "AutoFarm", "Noclip", "WeirdStuff"}
local tabButtons = {}

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0,0,0,0)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

-- Shuffles tab names
local function shuffle(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

shuffle(tabs)

-- Create buttons
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = tabName
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*90, 0, 0)
    btn.BackgroundColor3 = Color3.fromHSV(math.random(), 0.8, 1)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = tabFrame

    -- Random button jitter
    RunService.Heartbeat:Connect(function()
        btn.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset + math.sin(tick()*math.random())*2, 0, btn.Position.Y.Offset + math.cos(tick()*math.random())*2)
    end)

    tabButtons[tabName] = btn
end

-- Container for cheats
local cheatContainer = Instance.new("Frame")
cheatContainer.Size = UDim2.new(1, 0, 1, -40)
cheatContainer.Position = UDim2.new(0, 0, 0, 40)
cheatContainer.BackgroundTransparency = 0.5
cheatContainer.BackgroundColor3 = Color3.fromRGB(10,10,10)
cheatContainer.Parent = mainFrame

-- Obscure toggle function
local function weirdToggle(cheatName)
    print("Toggling cheat: " .. cheatName)
    -- Randomly enable/disable other toggles
    for name, btn in pairs(tabButtons) do
        if name ~= cheatName then
            btn.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
        end
    end
end

-- Connect buttons to toggles
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        weirdToggle(name)
    end)
end

-- Public API to load cheats
function InsaneGUI.LoadCheat(name, func)
    local cheatLabel = Instance.new("TextLabel")
    cheatLabel.Text = name .. " [INSANE MODE]"
    cheatLabel.Size = UDim2.new(0.9, 0, 0, 30)
    cheatLabel.Position = UDim2.new(0.05, 0, 0, (#cheatContainer:GetChildren() - 1) * 35)
    cheatLabel.TextColor3 = Color3.fromHSV(math.random(), 1, 1)
    cheatLabel.BackgroundTransparency = 1
    cheatLabel.Parent = cheatContainer

    local cheatToggle = Instance.new("TextButton")
    cheatToggle.Text = "Enable"
    cheatToggle.Size = UDim2.new(0.2, 0, 0, 30)
    cheatToggle.Position = UDim2.new(0.8, 0, 0, (#cheatContainer:GetChildren() - 1) * 35)
    cheatToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    cheatToggle.Parent = cheatContainer

    local enabled = false
    cheatToggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        cheatToggle.Text = enabled and "Disable" or "Enable"
        cheatToggle.BackgroundColor3 = enabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
        if enabled then
            func(true)
        else
            func(false)
        end
    end)
end

return InsaneGUI
