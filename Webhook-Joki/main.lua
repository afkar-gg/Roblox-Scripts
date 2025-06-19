--[[
    All-in-One UI Script with Tabs (Webhook + Tools)
    - Features: Draggable window, tab switching, Infinite Yield button.
]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end
if not game:GetService("Players").LocalPlayer then
    warn("This script must be run from a client executor.")
    return
end

pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiWebhookUI_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 370)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -185)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 105)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Tab Buttons Holder
local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, 0, 0, 30)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = mainFrame

local function createTabButton(name, position, onClick)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 120, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    button.Text = name
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Parent = tabHolder

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    button.MouseButton1Click:Connect(onClick)
    return button
end

-- Tabs (Content Frames)
local webhookTab = Instance.new("Frame")
webhookTab.Size = UDim2.new(1, 0, 1, -40)
webhookTab.Position = UDim2.new(0, 0, 0, 40)
webhookTab.BackgroundTransparency = 1
webhookTab.Parent = mainFrame

local toolsTab = webhookTab:Clone()
toolsTab.Name = "ToolsTab"
toolsTab.Visible = false
toolsTab.Parent = mainFrame

-- Tab Switching
local function showTab(tab)
    webhookTab.Visible = false
    toolsTab.Visible = false
    tab.Visible = true
end

createTabButton("Webhook", UDim2.new(0, 10, 0, 0), function() showTab(webhookTab) end)
createTabButton("Tools", UDim2.new(0, 140, 0, 0), function() showTab(toolsTab) end)

-- ============ WEBHOOK TAB CONTENT ============
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = webhookTab

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 5)
padding.Parent = webhookTab

local function createLabeledInput(name, placeholder, order, isNumber)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = webhookTab

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name
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
    textbox.Text = isNumber and "1" or ""
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.TextSize = 14
    textbox.ClearTextOnFocus = false
    textbox.TextWrapped = true
    textbox.Parent = container

    Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 4)
    return textbox
end

local jamSelesaiBox = createLabeledInput("jam_selesai_joki", "e.g., 1", 1, true)
local webhookBox = createLabeledInput("discord_webhook", "Paste your Discord Webhook URL", 2, false)
local orderBox = createLabeledInput("no_order", "e.g., OD000000141403135", 3, false)
local storeNameBox = createLabeledInput("nama_store", "e.g., AfkarStore", 4, false)

local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0.9, 0, 0, 40)
executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeButton.BorderColor3 = Color3.fromRGB(120, 130, 255)
executeButton.Text = "EXECUTE SCRIPT"
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 18
executeButton.LayoutOrder = 5
executeButton.Parent = webhookTab

Instance.new("UICorner", executeButton).CornerRadius = UDim.new(0, 6)

executeButton.MouseButton1Click:Connect(function()
    local jamSelesai = tonumber(jamSelesaiBox.Text) or 1
    local webhookUrl = webhookBox.Text
    local orderId = orderBox.Text
    local storeName = storeNameBox.Text

    if webhookUrl == "" or orderId == "" or storeName == "" then
        executeButton.Text = "PLEASE FILL ALL FIELDS"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        wait(2)
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    executeButton.Active = false
    executeButton.Text = "EXECUTING..."
    executeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)

    local remoteUrl = "https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua"
    local success, content = pcall(function() return game:HttpGet(remoteUrl) end)

    if not success then
        executeButton.Text = "HTTP GET FAILED"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        warn("Failed to fetch script:", content)
        wait(3)
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        executeButton.Active = true
        return
    end

    local finalScript = string.format([[
        local jam_selesai_joki = %s
        local discord_webhook = %q
        local no_order = %q
        local nama_store = %q
        %s
    ]], jamSelesai, webhookUrl, orderId, storeName, content)

    local ok, err = pcall(function()
        loadstring(finalScript)()
    end)

    if ok then
        executeButton.Text = "SUCCESS!"
        executeButton.BackgroundColor3 = Color3.fromRGB(87, 242, 135)
        wait(2)
    else
        executeButton.Text = "EXECUTION ERROR"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        warn("Execution error:", err)
        wait(3)
    end

    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    executeButton.Active = true
end)

-- ============ TOOLS TAB CONTENT ============
local iyButton = Instance.new("TextButton")
iyButton.Size = UDim2.new(0, 200, 0, 40)
iyButton.Position = UDim2.new(0.5, -100, 0.5, -20)
iyButton.BackgroundColor3 = Color3.fromRGB(44, 130, 201)
iyButton.Text = "Run Infinite Yield"
iyButton.Font = Enum.Font.SourceSansBold
iyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
iyButton.TextSize = 18
iyButton.Parent = toolsTab

Instance.new("UICorner", iyButton).CornerRadius = UDim.new(0, 6)

iyButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
