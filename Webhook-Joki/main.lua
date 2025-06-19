--[[
    Webhook Joki UI (Persistent Save Version) By @Afkar
]]

if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then
    warn("This script must be run from a client executor.")
    return
end

local HttpService = game:GetService("HttpService")

-- ==== Persistent Config Load ====
local configFile = "JokiConfig.json"
local defaultConfig = {
    activeTab = "Webhook",
    minimized = false,
    fields = {
        jam_selesai_joki = "1",
        discord_webhook = "",
        no_order = "",
        nama_store = ""
    }
}

local function loadConfig()
    local success, data = pcall(function()
        if isfile(configFile) then
            return HttpService:JSONDecode(readfile(configFile))
        end
    end)
    return success and data or defaultConfig
end

local function saveConfig(data)
    pcall(function()
        writefile(configFile, HttpService:JSONEncode(data))
    end)
end

local state = loadConfig()
saveConfig(state) -- Write back in case file didn't exist before

-- ==== UI Setup ====
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiWebhookUI_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, state.minimized and 40 or 380)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 105)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderColor3 = Color3.fromRGB(85, 85, 105)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Webhook Joki By @Afkar"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close + Minimize Buttons
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -6, 0, 3)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Position = UDim2.new(1, -36, 0, 3)
minimizeButton.AnchorPoint = Vector2.new(1, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
minimizeButton.Text = "–"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 16
minimizeButton.Parent = titleBar
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)

local fullHeight = 380
local minimizedHeight = 40

minimizeButton.MouseButton1Click:Connect(function()
    state.minimized = not state.minimized
    saveConfig(state)

    local targetSize = state.minimized and UDim2.new(0, 400, 0, minimizedHeight) or UDim2.new(0, 400, 0, fullHeight)
    TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = targetSize}):Play()

    tabHolder.Visible = not state.minimized

    -- Hide all children in both tabs (textboxes, buttons, etc.)
    for _, child in pairs(webhookTab:GetChildren()) do
        if child:IsA("GuiObject") then
            child.Visible = not state.minimized and state.activeTab == "Webhook"
        end
    end
    for _, child in pairs(toolsTab:GetChildren()) do
        if child:IsA("GuiObject") then
            child.Visible = not state.minimized and state.activeTab == "Tools"
        end
    end
end)

-- Tab Setup
local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, 0, 0, 30)
tabHolder.Position = UDim2.new(0, 0, 0, 30)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = mainFrame

local webhookTab = Instance.new("Frame")
webhookTab.Size = UDim2.new(1, 0, 1, -60)
webhookTab.Position = UDim2.new(0, 0, 0, 60)
webhookTab.BackgroundTransparency = 1
webhookTab.Parent = mainFrame

local toolsTab = webhookTab:Clone()
toolsTab.Name = "ToolsTab"
toolsTab.Parent = mainFrame

local function animateTabSwitch(showTab, hideTab)
    hideTab.Visible = true
    showTab.Visible = true
    TweenService:Create(hideTab, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    TweenService:Create(showTab, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
    wait(0.25)
    hideTab.Visible = false
end

local function showTab(name)
    state.activeTab = name
    saveConfig(state)
    if name == "Webhook" then
        animateTabSwitch(webhookTab, toolsTab)
    else
        animateTabSwitch(toolsTab, webhookTab)
    end
end

local function createTabButton(name, index)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, 0, 1, 0)
    button.Position = UDim2.new((index - 1) * 0.5, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    button.Text = name
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Parent = tabHolder
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    button.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

createTabButton("Webhook", 1)
createTabButton("Tools", 2)

-- Load saved tab
if state.activeTab == "Tools" then
    toolsTab.Visible = true
    webhookTab.Visible = false
else
    webhookTab.Visible = true
    toolsTab.Visible = false
end

-- Webhook Tab Inputs
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = webhookTab
Instance.new("UIPadding", webhookTab).PaddingTop = UDim.new(0, 5)

local function createLabeledInput(labelText, placeholder, key, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = webhookTab

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, 0, 0, 30)
    textbox.Position = UDim2.new(0, 0, 0, 20)
    textbox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    textbox.BorderColor3 = Color3.fromRGB(85, 85, 105)
    textbox.Font = Enum.Font.SourceSans
    textbox.PlaceholderText = placeholder
    textbox.Text = state.fields[key] or ""
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.TextSize = 14
    textbox.ClearTextOnFocus = false
    textbox.TextWrapped = true
    textbox.Parent = container
    Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 4)

    textbox:GetPropertyChangedSignal("Text"):Connect(function()
        state.fields[key] = textbox.Text
        saveConfig(state)
    end)

    return textbox
end

local jamSelesaiBox = createLabeledInput("jam_selesai_joki", "e.g., 1", "jam_selesai_joki", 1)
local webhookBox = createLabeledInput("discord_webhook", "Paste Discord Webhook", "discord_webhook", 2)
local orderBox = createLabeledInput("no_order", "e.g., OD000000123", "no_order", 3)
local storeNameBox = createLabeledInput("nama_store", "e.g., AfkarStore", "nama_store", 4)

-- Run Infinite Yield in Tools Tab
local iyButton = Instance.new("TextButton")
iyButton.Size = UDim2.new(0, 200, 0, 40)
iyButton.Position = UDim2.new(0.5, -100, 0.5, -20)
iyButton.BackgroundColor3 = Color3.fromRGB(44, 130, 201)
iyButton.Text = "Infinite Yield"
iyButton.Font = Enum.Font.SourceSansBold
iyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
iyButton.TextSize = 18
iyButton.Parent = toolsTab
Instance.new("UICorner", iyButton).CornerRadius = UDim.new(0, 6)
iyButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
