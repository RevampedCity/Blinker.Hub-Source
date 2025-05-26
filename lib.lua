-- ExoticGUI Library
local ExoticGUI = {}

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create main ScreenGui container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExoticGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Utility function for color cycling (neon glow effect)
local function neonColorCycle(speed)
    local hue = 0
    return function(dt)
        hue = (hue + dt * speed) % 1
        return Color3.fromHSV(hue, 0.8, 1)
    end
end

-- Base Window creation function
function ExoticGUI:CreateWindow(title)
    local window = Instance.new("Frame")
    window.Name = title .. "_Window"
    window.Size = UDim2.new(0, 500, 0, 350)
    window.Position = UDim2.new(0.3, 0, 0.3, 0)
    window.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    window.BackgroundTransparency = 0.15
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.Parent = screenGui

    -- Glass effect (blur + transparency)
    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = game:GetService("Lighting")

    local blurFrame = Instance.new("Frame")
    blurFrame.Size = UDim2.new(1, 0, 1, 0)
    blurFrame.BackgroundTransparency = 0.7
    blurFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    blurFrame.BorderSizePixel = 0
    blurFrame.Parent = window

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 60, 1, 0)
    closeButton.Position = UDim2.new(1, -70, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "Close"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = titleBar

    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
    end)

    closeButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    -- Dragging functionality for the window
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 120, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = window

    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -120, 1, -40)
    contentContainer.Position = UDim2.new(0, 120, 0, 40)
    contentContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = window

    -- Tab management
    local tabs = {}
    local activeTab = nil

    -- Create tab button function
    function ExoticGUI:AddTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 18
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 220)
        tabButton.Parent = tabContainer

        -- Position tab buttons stacked vertically
        tabButton.LayoutOrder = #tabs + 1

        -- Create content page for tab
        local contentPage = Instance.new("Frame")
        contentPage.Size = UDim2.new(1, 0, 1, 0)
        contentPage.BackgroundTransparency = 1
        contentPage.Visible = false
        contentPage.Parent = contentContainer

        table.insert(tabs, {
            button = tabButton,
            page = contentPage,
        })

        -- Tab switching logic
        tabButton.MouseButton1Click:Connect(function()
            if activeTab then
                activeTab.page.Visible = false
                activeTab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                activeTab.button.TextColor3 = Color3.fromRGB(200, 200, 220)
            end

            activeTab = tabs[#tabs]
            activeTab.page.Visible = true
            activeTab.button.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
            activeTab.button.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        -- Auto-activate first tab
        if #tabs == 1 then
            tabButton:Activate()
            tabButton.MouseButton1Click:Wait() -- Wait for first click to activate
            tabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            contentPage.Visible = true
            activeTab = tabs[1]
        end

        -- Return tab page so user can add buttons etc.
        return contentPage
    end

    -- Store window functions and objects
    window._tabs = tabs
    window._activeTab = activeTab
    window._tabContainer = tabContainer
    window._contentContainer = contentContainer

    return window
end

-- Button creation for tabs
function ExoticGUI:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = UDim2.new(0.05, 0, 0, (#parent:GetChildren() - 1) * 40)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 18
    button.Text = text
    button.BorderSizePixel = 0
    button.Parent = parent

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 140)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 90)}):Play()
    end)

    button.MouseButton1Click:Connect(function()
        callback()
    end)

    return button
end

-- Toggle creation for tabs
function ExoticGUI:CreateToggle(parent, text, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.9, 0, 0, 35)
    toggleFrame.Position = UDim2.new(0.05, 0, 0, (#parent:GetChildren() - 1) * 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 18
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.2, 0, 1, 0)
    toggleButton.Position = UDim2.new(0.8, 0, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
    toggleButton.Text = "OFF"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 16
    toggleButton.TextColor3 = Color3.new(1,1,1)
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame

    local toggled = false
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleButton.Text = toggled and "ON" or "OFF"
        toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 150)
        callback(toggled)
    end)

    return toggleFrame
end

return ExoticGUI
