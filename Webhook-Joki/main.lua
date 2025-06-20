-- All-in-One UI with Config Auto Save/Load + Script Execution

if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then
    warn("Client-only script.")
    return
end

-- ==== CONFIG SETUP ====
local HttpService = game:GetService("HttpService")
local configFile = "joki_config.json"
local canUseFile = (readfile and writefile and isfile) and true or false

local savedConfig = {
    jam_selesai_joki = "1",
    discord_webhook = "",
    no_order = "",
    nama_store = ""
}

-- Load from config file
if canUseFile and isfile(configFile) then
    local success, content = pcall(readfile, configFile)
    if success then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        if ok and typeof(decoded) == "table" then
            for k, v in pairs(decoded) do
                if savedConfig[k] ~= nil then
                    savedConfig[k] = tostring(v)
                end
            end
        end
    end
end

-- ==== UI SETUP ====
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

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

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderColor3 = Color3.fromRGB(85, 85, 105)
titleBar.BorderSizePixel = 1
titleBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.fromScale(1, 1)
titleLabel.Position = UDim2.fromScale(0.5, 0.5)
titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Webhook Joki Configuration"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -6, 0, 3)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
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
local function makeInput(name, placeholder, order, defaultValue)
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
    box.Text = defaultValue or ""
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

-- Inputs with default config values
local jamSelesaiBox = makeInput("jam_selesai_joki", "e.g., 1", 1, savedConfig.jam_selesai_joki)
local webhookBox = makeInput("discord_webhook", "Paste your Discord Webhook", 2, savedConfig.discord_webhook)
local orderBox = makeInput("no_order", "e.g., OD0000000001", 3, savedConfig.no_order)
local storeBox = makeInput("nama_store", "e.g., AfkarStore", 4, savedConfig.nama_store)

-- Save Config Function
local function saveConfig()
    if not canUseFile then return end
    local data = {
        jam_selesai_joki = jamSelesaiBox.Text,
        discord_webhook = webhookBox.Text,
        no_order = orderBox.Text,
        nama_store = storeBox.Text
    }
    local success, json = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    if success then
        pcall(writefile, configFile, json)
    end
end

-- Auto-save when editing fields
jamSelesaiBox.FocusLost:Connect(saveConfig)
webhookBox.FocusLost:Connect(saveConfig)
orderBox.FocusLost:Connect(saveConfig)
storeBox.FocusLost:Connect(saveConfig)

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

    local injectedVars = string.format([[
        _G.jam_selesai_joki = %s
        _G.discord_webhook = %q
        _G.no_order = %q
        _G.nama_store = %q
    ]], jam_selesai_joki, discord_webhook, no_order, nama_store)

    local finalScript = string.format([[
    %s

    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua"))();
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))();
    ]], injectedVars)

    local func, err = loadstring(finalScript)
    if not func then
        warn("loadstring error:", err)
        return
    end

    pcall(func)
end)