-- This script adds a tabbed UI to the original webhook UI script.
-- One tab is for the webhook configuration, the other executes Infinite Yield.

if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then
    warn("This script must be run from a client executor.")
    return
end

pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiWebhookUI_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 380)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 105)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

local tabHolder = Instance.new("Frame")
tabHolder.Name = "TabHolder"
tabHolder.Size = UDim2.new(1, 0, 0, 30)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabHolder

local function createTabButton(name)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.Parent = tabHolder
    return btn
end

local webhookTabBtn = createTabButton("Webhook")
local toolsTabBtn = createTabButton("Tools")

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local webhookFrame = Instance.new("Frame")
webhookFrame.Name = "WebhookTab"
webhookFrame.Size = UDim2.new(1, 0, 1, 0)
webhookFrame.BackgroundTransparency = 1
webhookFrame.Visible = true
webhookFrame.Parent = contentFrame

local toolsFrame = Instance.new("Frame")
toolsFrame.Name = "ToolsTab"
toolsFrame.Size = UDim2.new(1, 0, 1, 0)
toolsFrame.BackgroundTransparency = 1
toolsFrame.Visible = false
toolsFrame.Parent = contentFrame

webhookTabBtn.MouseButton1Click:Connect(function()
    webhookFrame.Visible = true
    toolsFrame.Visible = false
end)

toolsTabBtn.MouseButton1Click:Connect(function()
    webhookFrame.Visible = false
    toolsFrame.Visible = true
end)

-- Webhook Tab UI (reuse your existing function here)
local function createLabeledInput(name, placeholder, order, isNumber)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.Position = UDim2.new(0.05, 0, 0, 10 + order * 55)
    container.BackgroundTransparency = 1
    container.Parent = webhookFrame

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
    textbox.TextColor3 = Color3.new(1, 1, 1)
    textbox.TextSize = 14
    textbox.ClearTextOnFocus = false
    textbox.TextWrapped = true
    if isNumber then textbox.Text = "1" end
    textbox.Parent = container

    local textCorner = Instance.new("UICorner")
    textCorner.CornerRadius = UDim.new(0, 4)
    textCorner.Parent = textbox

    return textbox
end

local jamSelesaiBox = createLabeledInput("jam_selesai_joki", "e.g., 1", 1, true)
local webhookBox = createLabeledInput("discord_webhook", "Paste your Discord Webhook URL here", 2, false)
local orderBox = createLabeledInput("no_order", "e.g., OD000000141403135", 3, false)
local storeNameBox = createLabeledInput("nama_store", "e.g., AfkarStore", 4, false)

local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0.9, 0, 0, 40)
executeButton.Position = UDim2.new(0.05, 0, 0, 290)
executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeButton.BorderColor3 = Color3.fromRGB(120, 130, 255)
executeButton.Text = "EXECUTE SCRIPT"
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextColor3 = Color3.new(1, 1, 1)
executeButton.TextSize = 18
executeButton.Parent = webhookFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = executeButton

-- Button Logic (reuse your existing logic here)
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

    local remoteScriptUrl = "https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua"
    local success, remoteContent = pcall(function()
        return game:HttpGet(remoteScriptUrl)
    end)

    if not success or not remoteContent then
        executeButton.Text = "HTTP GET FAILED"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        wait(3)
        executeButton.Active = true
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    local finalScript = string.format([[local jam_selesai_joki = %s
local discord_webhook = %q
local no_order = %q
local nama_store = %q
%s]], jamSelesai, webhookUrl, orderId, storeName, remoteContent)

    local loadSuccess, loadError = pcall(function()
        loadstring(finalScript)()
    end)

    if loadSuccess then
        executeButton.Text = "SUCCESS!"
        executeButton.BackgroundColor3 = Color3.fromRGB(87, 242, 135)
        wait(2)
    else
        executeButton.Text = "EXECUTION ERROR"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        warn("Execution failed:", loadError)
        wait(3)
    end

    executeButton.Active = true
    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)

-- Tools Tab: Infinite Yield Button
local iyButton = Instance.new("TextButton")
iyButton.Size = UDim2.new(0.6, 0, 0, 40)
iyButton.Position = UDim2.new(0.2, 0, 0.4, 0)
iyButton.BackgroundColor3 = Color3.fromRGB(66, 135, 245)
iyButton.Text = "Infinite Yield"
iyButton.Font = Enum.Font.SourceSansBold
iyButton.TextColor3 = Color3.new(1, 1, 1)
iyButton.TextSize = 16
iyButton.Parent = toolsFrame

local iyCorner = Instance.new("UICorner")
iyCorner.CornerRadius = UDim.new(0, 6)
iyCorner.Parent = iyButton

iyButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
