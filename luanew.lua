-- SexySleekGUI Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local SexySleekGUI = {}

-- Create the main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SexySleekGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Utility: Create UICorner for smooth rounding
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

-- Utility: Tween fade in
local function fadeIn(guiObject, time)
    guiObject.Visible = true
    guiObject.BackgroundTransparency = 1
    TweenService:Create(guiObject, TweenInfo.new(time or 0.3), {BackgroundTransparency = 0}):Play()
end

-- Utility: Tween fade out
local function fadeOut(guiObject, time)
    local tween = TweenService:Create(guiObject, TweenInfo.new(time or 0.3), {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Wait()
    guiObject.Visible = false
end

-- Create the main window frame
function SexySleekGUI:CreateWindow(title)
    local window = Instance.new("Frame")
    window.Name = title .. "_Window"
    window.Size = UDim2.new(0, 380, 0, 280)
    window.Position = UDim2.new(0.5, -190, 0.5, -140)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    window.BackgroundTransparency = 0
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.Parent = screenGui

    createUICorner(window, 14)

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 42)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    titleBar.Parent = window
    createUICorner(titleBar, 14)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 48, 0, 32)
    closeButton.Position = UDim2.new(1, -55, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(240, 60, 60)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 22
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    createUICorner(closeButton, 10)

    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 90, 90)}):Play()
    end)
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(240, 60, 60)}):Play()
    end)

    closeButton.MouseButton1Click:Connect(function()
        fadeOut(window, 0.3)
    end)

    -- Dragging
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

    -- Tabs Container (small width)
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Size = UDim2.new(0, 90, 1, -42)
    tabsContainer.Position = UDim2.new(0, 0, 0, 42)
    tabsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    tabsContainer.BorderSizePixel = 0
    tabsContainer.Parent = window
    createUICorner(tabsContainer, 14)

    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -90, 1, -42)
    contentContainer.Position = UDim2.new(0, 90, 0, 42)
    contentContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = window
    createUICorner(contentContainer, 14)

    -- Tab Buttons and Pages
    local tabs = {}
    local activeTab = nil

    local function activateTab(tab)
        for _, t in pairs(tabs) do
            t.button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            t.page.Visible = false
        end
        tab.button.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
        tab.page.Visible = true
        activeTab = tab
    end

    function SexySleekGUI:AddTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -12, 0, 45)
        tabButton.Position = UDim2.new(0, 6, 0, (#tabs) * 50 + 6)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 17
        tabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        tabButton.Parent = tabsContainer
        createUICorner(tabButton, 10)

        -- Hover effect
        tabButton.MouseEnter:Connect(function()
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
        end)
        tabButton.MouseLeave:Connect(function()
            if activeTab ~= tabs[#tabs + 1] then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
            end
        end)

        -- Content page
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 5
        page.Visible = false
        page.Parent = contentContainer

        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y

        table.insert(tabs, {button = tabButton, page = page})

        tabButton.MouseButton1Click:Connect(function()
            activateTab(tabs[#tabs])
        end)

        if #tabs == 1 then
            activateTab(tabs[1])
        end

        return page
    end

    -- Add a button to a page
    function SexySleekGUI:AddButton(page, text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.9, 0, 0, 35)
        button.Position = UDim2.new(0.05, 0, 0, (#page:GetChildren() - 2) * 45)
        button.BackgroundColor3 = Color3.fromRGB(65, 65, 80)
        button.TextColor3 = Color3.fromRGB(240, 240, 255)
        button.Font = Enum.Font.GothamSemibold
        button.TextSize = 18
        button.Text = text
        button.BorderSizePixel = 0
        button.Parent = page
        createUICorner(button, 8)

        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(90, 90, 120)}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65, 65, 80)}):Play()
        end)

        button.MouseButton1Click:Connect(function()
            callback()
        end)

        -- Adjust canvas size for scrolling
        page.CanvasSize = UDim2.new(0, 0, 0, button.Position.Y.Offset + 45)

        return button
    end

    -- Loading shimmer effect (top bar)
    local shimmer = Instance.new("Frame")
    shimmer.Size = UDim2.new(0, 100, 0, 5)
    shimmer.Position = UDim2.new(0, -100, 0, 42)
    shimmer.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    shimmer.BackgroundTransparency = 0.5
    shimmer.Rotation = 20
    shimmer.Parent = window

    createUICorner(shimmer, 3)

    -- Animate shimmer sliding across title bar
    coroutine.wrap(function()
        while window and window.Parent do
            shimmer.Position = UDim2.new(0, -100, 0, 42)
            shimmer.BackgroundTransparency = 0.5
            local tween1 = TweenService:Create(shimmer, TweenInfo.new(2.5), {Position = UDim2.new(1, 50, 0, 42), BackgroundTransparency = 1})
            tween1:Play()
            tween1.Completed:Wait()
            wait(0.3)
        end
    end)()

    return SexySleekGUI
end

return SexySleekGUI
