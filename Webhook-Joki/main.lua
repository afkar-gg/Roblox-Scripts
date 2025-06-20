-- Webhook Joki UI (Clean Version w/ Text Wrapping) by @Afkar

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- === Persistent Config ===
local configFile = "JokiConfig.json"
local defaultConfig = {
    activeTab = "Webhook",
    fields = {
        jam_selesai_joki = "1",
        discord_webhook = "",
        no_order = "",
        nama_store = ""
    }
}

local function loadConfig()
    if isfile(configFile) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(configFile))
        end)
        if success then return result end
    end
    return defaultConfig
end

local function saveConfig(config)
    writefile(configFile, HttpService:JSONEncode(config))
end

local config = loadConfig()
saveConfig(config)

-- === Cleanup Old UI ===
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

-- === UI Setup ===
local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
screenGui.Name = "JokiWebhookUI_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 360)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 105)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Title bar
local titleBar = Instance.new("TextLabel", mainFrame)
titleBar.Size = UDim2.new(1, -40, 0, 30)
titleBar.Position = UDim2.new(0, 10, 0, 0)
titleBar.Text = "Webhook Joki By @Afkar"
titleBar.TextSize = 16
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.BackgroundTransparency = 1
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.TextWrapped = true

-- Close button (X)
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 14
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextWrapped = true
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tab selector
local tabHolder = Instance.new("Frame", mainFrame)
tabHolder.Size = UDim2.new(1, 0, 0, 30)
tabHolder.Position = UDim2.new(0, 0, 0, 30)
tabHolder.BackgroundTransparency = 1

local function createTabButton(name, order)
    local button = Instance.new("TextButton", tabHolder)
    button.Size = UDim2.new(0.5, 0, 1, 0)
    button.Position = UDim2.new((order - 1) * 0.5, 0, 0, 0)
    button.Text = name
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    button.TextWrapped = true
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    return button
end

-- Tabs
local webhookTab = Instance.new("Frame", mainFrame)
webhookTab.Size = UDim2.new(1, 0, 1, -60)
webhookTab.Position = UDim2.new(0, 0, 0, 60)
webhookTab.BackgroundTransparency = 1

local toolsTab = webhookTab:Clone()
toolsTab.Name = "ToolsTab"
toolsTab.Parent = mainFrame

-- Checker Tab
local checkerTab = webhookTab:Clone()
checkerTab.Name = "CheckerTab"
checkerTab.Parent = mainFrame

local checkerContent = checkerTab:FindFirstChild("ContentHolder")
checkerContent:ClearAllChildren()

local checkerLayout = Instance.new("UIListLayout", checkerContent)
checkerLayout.Padding = UDim.new(0, 8)
checkerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", checkerContent).PaddingTop = UDim.new(0, 5)

-- Checker Inputs
local function createCheckerInput(labelText, order)
    local container = Instance.new("Frame", checkerContent)
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = labelText
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true

    local box = Instance.new("TextBox", container)
    box.Size = UDim2.new(1, 0, 0, 30)
    box.Position = UDim2.new(0, 0, 0, 20)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.BorderColor3 = Color3.fromRGB(85, 85, 105)
    box.Font = Enum.Font.SourceSans
    box.PlaceholderText = "Enter value..."
    box.Text = ""
    box.TextSize = 14
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextWrapped = true
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    return box
end

local webhookCheckerBox = createCheckerInput("dc_webhook", 1)
local messageCheckerBox = createCheckerInput("dc_message_id", 2)

-- RUN Button
local runCheckerButton = Instance.new("TextButton", checkerContent)
runCheckerButton.Size = UDim2.new(0.9, 0, 0, 40)
runCheckerButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
runCheckerButton.BorderColor3 = Color3.fromRGB(120, 130, 255)
runCheckerButton.Text = "RUN"
runCheckerButton.Font = Enum.Font.SourceSansBold
runCheckerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
runCheckerButton.TextSize = 18
runCheckerButton.TextWrapped = true
Instance.new("UICorner", runCheckerButton).CornerRadius = UDim.new(0, 6)

runCheckerButton.MouseButton1Click:Connect(function()
    local dc_webhook = webhookCheckerBox.Text
    local dc_message_id = messageCheckerBox.Text

    if dc_webhook == "" or dc_message_id == "" then
        runCheckerButton.Text = "FILL BOTH FIELDS"
        runCheckerButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        wait(2)
        runCheckerButton.Text = "RUN"
        runCheckerButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    local scriptToRun = string.format([[
        local dc_webhook = %q
        local dc_message_id = %q
        %s
    ]],
        dc_webhook,
        dc_message_id,
        game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/main/Webhook-Joki/EditMsg.lua")
    )

    pcall(function()
        loadstring(scriptToRun)()
    end)
end)
local webhookContent = Instance.new("Frame", webhookTab)
webhookContent.Name = "ContentHolder"
webhookContent.Size = UDim2.new(1, 0, 1, 0)
webhookContent.BackgroundTransparency = 1

local toolsContent = Instance.new("Frame", toolsTab)
toolsContent.Name = "ContentHolder"
toolsContent.Size = UDim2.new(1, 0, 1, 0)
toolsContent.BackgroundTransparency = 1

-- Webhook UI
local listLayout = Instance.new("UIListLayout", webhookContent)
listLayout.Padding = UDim.new(0, 8)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", webhookContent).PaddingTop = UDim.new(0, 5)

local function createInput(labelText, key, order)
    local container = Instance.new("Frame", webhookContent)
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = labelText
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true

    local box = Instance.new("TextBox", container)
    box.Size = UDim2.new(1, 0, 0, 30)
    box.Position = UDim2.new(0, 0, 0, 20)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.BorderColor3 = Color3.fromRGB(85, 85, 105)
    box.Font = Enum.Font.SourceSans
    box.PlaceholderText = "Enter value..."
    box.Text = config.fields[key] or ""
    box.TextSize = 14
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextWrapped = true
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    box:GetPropertyChangedSignal("Text"):Connect(function()
        config.fields[key] = box.Text
        saveConfig(config)
    end)
end

createInput("jam_selesai_joki", "jam_selesai_joki", 1)
createInput("discord_webhook", "discord_webhook", 2)
createInput("no_order", "no_order", 3)
createInput("nama_store", "nama_store", 4)

-- Execute Button
local executeButton = Instance.new("TextButton", webhookContent)
executeButton.Size = UDim2.new(0.9, 0, 0, 40)
executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeButton.BorderColor3 = Color3.fromRGB(120, 130, 255)
executeButton.Text = "EXECUTE SCRIPT"
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 18
executeButton.TextWrapped = true
Instance.new("UICorner", executeButton).CornerRadius = UDim.new(0, 6)

executeButton.MouseButton1Click:Connect(function()
    local fields = config.fields
    if fields.discord_webhook == "" or fields.no_order == "" or fields.nama_store == "" then
        executeButton.Text = "FILL ALL FIELDS"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        wait(2)
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    executeButton.Text = "EXECUTING..."
    local success, content = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua")
    end)

    if success then
        local final = string.format([[
            local jam_selesai_joki = %s
            local discord_webhook = %q
            local no_order = %q
            local nama_store = %q
            %s
        ]], fields.jam_selesai_joki, fields.discord_webhook, fields.no_order, fields.nama_store, content)
        pcall(function() loadstring(final)() end)
        executeButton.Text = "SUCCESS!"
        executeButton.BackgroundColor3 = Color3.fromRGB(87, 242, 135)
    else
        executeButton.Text = "FAILED TO LOAD"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
    end
    wait(2)
    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)

-- Tools Tab: Infinite Yield
local iyButton = Instance.new("TextButton", toolsContent)
iyButton.Size = UDim2.new(0, 200, 0, 40)
iyButton.Position = UDim2.new(0.5, -100, 0.5, -20)
iyButton.BackgroundColor3 = Color3.fromRGB(44, 130, 201)
iyButton.Text = "Infinite Yield"
iyButton.Font = Enum.Font.SourceSansBold
iyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
iyButton.TextSize = 18
iyButton.TextWrapped = true
Instance.new("UICorner", iyButton).CornerRadius = UDim.new(0, 6)

iyButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- Tab Buttons
local webhookBtn = createTabButton("Webhook", 1)
local toolsBtn = createTabButton("Tools", 2)

local function switchTab(tab)
    webhookTab.Visible = tab == "Webhook"
    toolsTab.Visible = tab == "Tools"
    config.activeTab = tab
    saveConfig(config)
end

webhookBtn.MouseButton1Click:Connect(function() switchTab("Webhook") end)
toolsBtn.MouseButton1Click:Connect(function() switchTab("Tools") end)

-- Load saved tab
switchTab(config.activeTab or "Webhook")