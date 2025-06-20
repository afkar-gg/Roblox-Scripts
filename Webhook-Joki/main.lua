-- All-in-One UI: Webhook + Infinite Yield, Clean Version

if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then
    warn("Client-only script.")
    return
end

-- Destroy old UI
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

-- UI setup
local gui = Instance.new("ScreenGui")
gui.Name = "JokiWebhookUI_ScreenGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 350)
frame.Position = UDim2.new(0.5, -200, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(85, 85, 105)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderColor3 = Color3.fromRGB(85, 85, 105)
titleBar.BorderSizePixel = 1
titleBar.Parent = frame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.fromScale(1, 1)
titleText.Position = UDim2.fromScale(0.5, 0.5)
titleText.AnchorPoint = Vector2.new(0.5, 0.5)
titleText.BackgroundTransparency = 1
titleText.Text = "Webhook Joki Configuration"
titleText.Font = Enum.Font.SourceSansBold
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.TextYAlignment = Enum.TextYAlignment.Center
titleText.Parent = titleBar

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -6, 0, 3)
close.AnchorPoint = Vector2.new(1, 0)
close.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
close.Text = "X"
close.Font = Enum.Font.SourceSansBold
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 14
close.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- Content Frame
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.Parent = content

-- Input Field Helper
local function makeInput(name, placeholder, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 30)
    box.Position = UDim2.new(0, 0, 0, 20)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.BorderColor3 = Color3.fromRGB(85, 85, 105)
    box.BorderSizePixel = 1
    box.Font = Enum.Font.SourceSans
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.TextSize = 14
    box.TextWrapped = true
    box.ClearTextOnFocus = false
    box.Parent = container

    local round = Instance.new("UICorner")
    round.CornerRadius = UDim.new(0, 4)
    round.Parent = box

    return box
end

-- Inputs
local jamSelesaiBox = makeInput("jam_selesai_joki", "e.g., 1", 1)
local webhookBox = makeInput("discord_webhook", "Paste your Discord Webhook", 2)
local orderBox = makeInput("no_order", "e.g., OD0000000001", 3)
local storeBox = makeInput("nama_store", "e.g., AfkarStore", 4)

-- Execute Button
local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0.9, 0, 0, 40)
executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeBtn.BorderColor3 = Color3.fromRGB(120, 130, 255)
executeBtn.BorderSizePixel = 1
executeBtn.Text = "EXECUTE SCRIPT"
executeBtn.Font = Enum.Font.SourceSansBold
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
executeBtn.TextSize = 18
executeBtn.LayoutOrder = 5
executeBtn.Parent = content

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = executeBtn

-- Run logic
executeBtn.MouseButton1Click:Connect(function()
    local jam_selesai_joki = tonumber(jamSelesaiBox.Text) or 1
    local discord_webhook = webhookBox.Text
    local no_order = orderBox.Text
    local nama_store = storeBox.Text

    if discord_webhook == "" or no_order == "" or nama_store == "" then
        executeBtn.Text = "FILL ALL FIELDS"
        executeBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        wait(2)
        executeBtn.Text = "EXECUTE SCRIPT"
        executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    -- Build injected script
    local injectedVars = string.format([[
        local jam_selesai_joki = %s
        local discord_webhook = %q
        local no_order = %q
        local nama_store = %q
    ]], jam_selesai_joki, discord_webhook, no_order, nama_store)

    -- Webhook first, then Infinite Yield
    local finalScript = string.format([[
        %s

        loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/main.lua"))();
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))();
    ]], injectedVars)

    local func, err = loadstring(finalScript)
    if not func then
        warn("loadstring error:", err)
        return
    end

    pcall(func)
end)