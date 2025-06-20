--[[
    All-in-One UI Script for Webhook Execution + Infinite Yield
    Fixed layout issue where title bar was offset by UIListLayout
]]

if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then
    warn("This script must be run from a client executor.")
    return
end

-- Cleanup existing UI
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiWebhookUI_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 105)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleLabel.BorderColor3 = Color3.fromRGB(85, 85, 105)
titleLabel.BorderSizePixel = 1
titleLabel.Text = "Webhook Joki Configuration"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -4, 0, 4)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Content Frame (holds inputs + button)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Layout + Padding
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = contentFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.Parent = contentFrame

-- Helper for inputs
local function createLabeledInput(name, placeholder, order, isNumber)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = contentFrame

    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local textbox = Instance.new("TextBox")
    textbox.Name = name .. "Box"
    textbox.Size = UDim2.new(1, 0, 0, 30)
    textbox.Position = UDim2.new(0, 0, 0, 20)
    textbox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    textbox.BorderColor3 = Color3.fromRGB(85, 85, 105)
    textbox.BorderSizePixel = 1
    textbox.Font = Enum.Font.SourceSans
    textbox.PlaceholderText = placeholder
    textbox.Text = isNumber and "1" or ""
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.TextSize = 14
    textbox.ClearTextOnFocus = false
    textbox.TextWrapped = true
    textbox.Parent = container

    local textCorner = Instance.new("UICorner")
    textCorner.CornerRadius = UDim.new(0, 4)
    textCorner.Parent = textbox

    return textbox
end

-- Inputs
local jamSelesaiBox = createLabeledInput("jam_selesai_joki", "e.g., 1", 1, true)
local webhookBox = createLabeledInput("discord_webhook", "Paste your Discord Webhook URL here", 2, false)
local orderBox = createLabeledInput("no_order", "e.g., OD000000141403135", 3, false)
local storeNameBox = createLabeledInput("nama_store", "e.g., AfkarStore", 4, false)

-- Execute Button
local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(0.9, 0, 0, 40)
executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeButton.BorderColor3 = Color3.fromRGB(120, 130, 255)
executeButton.BorderSizePixel = 1
executeButton.Text = "EXECUTE SCRIPT"
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 18
executeButton.LayoutOrder = 5
executeButton.Parent = contentFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = executeButton

-- Button Logic
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

    local success1, webhookScript = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua")
    end)

    local success2, iyScript = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end)

    if not success1 or not webhookScript then
        executeButton.Text = "WEBHOOK GET FAILED"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        warn("Failed to fetch Webhook.lua:", webhookScript)
        wait(3)
        executeButton.Active = true
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    if not success2 or not iyScript then
        executeButton.Text = "INFINITE YIELD GET FAILED"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        warn("Failed to fetch Infinite Yield:", iyScript)
        wait(3)
        executeButton.Active = true
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    local finalScript = string.format([[
        local jam_selesai_joki = %s
        local discord_webhook = %q
        local no_order = %q
        local nama_store = %q

        %s

        %s
    ]], jamSelesai, webhookUrl, orderId, storeName, webhookScript, iyScript)

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
        warn("Script execution error:", loadError)
        wait(3)
    end

    executeButton.Active = true
    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)