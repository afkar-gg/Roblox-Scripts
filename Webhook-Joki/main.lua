
-- Webhook Joki UI (Stable Tabbed Version w/ Checker Save) by @Afkar

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local configFile = "JokiConfig.json"
local defaultConfig = {
    activeTab = "Webhook",
    fields = {
        jam_selesai_joki = "1",
        discord_webhook = "",
        no_order = "",
        nama_store = ""
    },
    checker = {
        dc_webhook = "",
        dc_message_id = ""
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

pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

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

local tabHolder = Instance.new("Frame", mainFrame)
tabHolder.Size = UDim2.new(1, 0, 0, 30)
tabHolder.Position = UDim2.new(0, 0, 0, 30)
tabHolder.BackgroundTransparency = 1

local function createTabButton(name, order)
    local button = Instance.new("TextButton", tabHolder)
    button.Size = UDim2.new(1/3, 0, 1, 0)
    button.Position = UDim2.new((order - 1) * (1/3), 0, 0, 0)
    button.Text = name
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    button.TextWrapped = true
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    return button
end
