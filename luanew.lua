-- init.lua
local GUI_Library = {}

function GUI_Library.CreateGUI(parent)
    local GUITOLUA = Instance.new("ScreenGui")
    GUITOLUA.Name = "GUI_TO_LUA"
    GUITOLUA.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUITOLUA.Parent = parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local VeryBackFrameTabListTabs = Instance.new("Frame")
    VeryBackFrameTabListTabs.Name = "VeryBackFrameTabListTabs"
    VeryBackFrameTabListTabs.Parent = GUITOLUA
    VeryBackFrameTabListTabs.BackgroundColor3 = Color3.fromRGB(93, 93, 93)
    VeryBackFrameTabListTabs.Position = UDim2.new(0.0936, 0, 0.306, 0)
    VeryBackFrameTabListTabs.Size = UDim2.new(0, 145, 0, 134)

    local SelectedTabVeryBack = Instance.new("Frame")
    SelectedTabVeryBack.Name = "SelectedTabVeryBack"
    SelectedTabVeryBack.Parent = VeryBackFrameTabListTabs
    SelectedTabVeryBack.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
    SelectedTabVeryBack.Position = UDim2.new(1.1, 0, 0.0627, 0)
    SelectedTabVeryBack.Size = UDim2.new(0, 391, 0, 364)

    local SelectedTabSection1 = Instance.new("Frame")
    SelectedTabSection1.Name = "SelectedTabSection1"
    SelectedTabSection1.Parent = SelectedTabVeryBack
    SelectedTabSection1.BackgroundColor3 = Color3.fromRGB(93, 93, 93)
    SelectedTabSection1.Position = UDim2.new(0.0408, 0, 0.0414, 0)
    SelectedTabSection1.Size = UDim2.new(0, 173, 0, 169)

    local SelectedTabHeader = Instance.new("Frame")
    SelectedTabHeader.Name = "SelectedTabHeader"
    SelectedTabHeader.Parent = SelectedTabVeryBack
    SelectedTabHeader.BackgroundColor3 = Color3.fromRGB(93, 93, 93)
    SelectedTabHeader.Position = UDim2.new(0, 0, -0.0658, 0)
    SelectedTabHeader.Size = UDim2.new(0, 391, 0, 24)

    local TabName = Instance.new("TextLabel")
    TabName.Name = "TabName"
    TabName.Parent = SelectedTabHeader
    TabName.BackgroundTransparency = 1
    TabName.Position = UDim2.new(0, 0, -0.028, 0)
    TabName.Size = UDim2.new(0, 109, 0, 23)
    TabName.Font = Enum.Font.SourceSansBold
    TabName.Text = "SelectedTabName"
    TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabName.TextSize = 10

    local TabDetails = Instance.new("TextLabel")
    TabDetails.Name = "TabDetails"
    TabDetails.Parent = SelectedTabHeader
    TabDetails.BackgroundTransparency = 1
    TabDetails.Position = UDim2.new(0.426, 0, 0.041, 0)
    TabDetails.Size = UDim2.new(0, 215, 0, 23)
    TabDetails.Font = Enum.Font.SourceSansBold
    TabDetails.Text = "Tab Details"
    TabDetails.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabDetails.TextSize = 10

    local MainTabListHeader = Instance.new("Frame")
    MainTabListHeader.Name = "MainTabListHeader"
    MainTabListHeader.Parent = VeryBackFrameTabListTabs
    MainTabListHeader.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
    MainTabListHeader.Position = UDim2.new(0, 0, -0.1015, 0)
    MainTabListHeader.Size = UDim2.new(0, 145, 0, 23)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = MainTabListHeader
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(0.752, 0, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 16, 0, 22)
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 16

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = MainTabListHeader
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(0.872, 0, 0, 0)
    CloseButton.Size = UDim2.new(0, 16, 0, 22)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "x"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16

    local MainTabListName = Instance.new("TextLabel")
    MainTabListName.Name = "MainTabListName"
    MainTabListName.Parent = MainTabListHeader
    MainTabListName.BackgroundTransparency = 1
    MainTabListName.Position = UDim2.new(0, 0, -0.028, 0)
    MainTabListName.Size = UDim2.new(0, 109, 0, 23)
    MainTabListName.Font = Enum.Font.SourceSansBold
    MainTabListName.Text = "Free \"Experiments\" Hub"
    MainTabListName.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTabListName.TextSize = 10

    local Tab1OpenClose = Instance.new("TextButton")
    Tab1OpenClose.Name = "Tab1OpenClose"
    Tab1OpenClose.Parent = VeryBackFrameTabListTabs
    Tab1OpenClose.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
    Tab1OpenClose.Position = UDim2.new(0.0539, 0, 0.1269, 0)
    Tab1OpenClose.Size = UDim2.new(0, 63, 0, 19)
    Tab1OpenClose.Font = Enum.Font.SourceSansBold
    Tab1OpenClose.Text = "TabName"
    Tab1OpenClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab1OpenClose.TextSize = 14

    return GUITOLUA
end

return GUI_Library
