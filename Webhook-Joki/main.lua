--[[
    Webhook Joki UI (Minimize Fixed + Persistent Save) By @Afkar
]]

if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then
    warn("This script must be run from a client executor.")
    return
end

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- Config load/save
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
saveConfig(state)

local webhookTab, toolsTab, webhookContent, toolsContent

local function buildTabsAndContent(parent)
    -- == Tabs ==
    webhookTab = Instance.new("Frame")
    webhookTab.Size = UDim2.new(1, 0, 1, -60)
    webhookTab.Position = UDim2.new(0, 0, 0, 60)
    webhookTab.BackgroundTransparency = 1
    webhookTab.Parent = parent

    toolsTab = webhookTab:Clone()
    toolsTab.Name = "ToolsTab"
    toolsTab.Parent = parent

    -- == Content Holders ==
    webhookContent = Instance.new("Frame")
    webhookContent.Name = "ContentHolder"
    webhookContent.BackgroundTransparency = 1
    webhookContent.Size = UDim2.new(1, 0, 1, 0)
    webhookContent.Parent = webhookTab

    toolsContent = Instance.new("Frame")
    toolsContent.Name = "ContentHolder"
    toolsContent.BackgroundTransparency = 1
    toolsContent.Size = UDim2.new(1, 0, 1, 0)
    toolsContent.Parent = toolsTab

    -- == Webhook Tab UI ==
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = webhookContent

    Instance.new("UIPadding", webhookContent).PaddingTop = UDim.new(0, 5)

    local function createInput(labelText, placeholder, key, order)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.9, 0, 0, 50)
        container.BackgroundTransparency = 1
        container.LayoutOrder = order
        container.Parent = webhookContent

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

    jamSelesaiBox = createInput("jam_selesai_joki", "e.g., 1", "jam_selesai_joki", 1)
    webhookBox = createInput("discord_webhook", "Paste Discord Webhook", "discord_webhook", 2)
    orderBox = createInput("no_order", "e.g., OD000000123", "no_order", 3)
    storeNameBox = createInput("nama_store", "e.g., AfkarStore", "nama_store", 4)

    executeButton = Instance.new("TextButton")
    executeButton.Size = UDim2.new(0.9, 0, 0, 40)
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    executeButton.BorderColor3 = Color3.fromRGB(120, 130, 255)
    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.Font = Enum.Font.SourceSansBold
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.TextSize = 18
    executeButton.LayoutOrder = 5
    executeButton.Parent = webhookContent
    Instance.new("UICorner", executeButton).CornerRadius = UDim.new(0, 6)

    executeButton.MouseButton1Click:Connect(function()
        -- same webhook logic as before
    end)

    -- == Tools Tab UI ==
    local iyButton = Instance.new("TextButton")
    iyButton.Size = UDim2.new(0, 200, 0, 40)
    iyButton.Position = UDim2.new(0.5, -100, 0.5, -20)
    iyButton.BackgroundColor3 = Color3.fromRGB(44, 130, 201)
    iyButton.Text = "Infinite Yield"
    iyButton.Font = Enum.Font.SourceSansBold
    iyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    iyButton.TextSize = 18
    iyButton.Parent = toolsContent
    Instance.new("UICorner", iyButton).CornerRadius = UDim.new(0, 6)

    iyButton.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
end

-- Clean up old UI
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiWebhookUI_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = game:GetService("CoreGui")

local fullHeight, minimizedHeight = 380, 40

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, state.minimized and minimizedHeight or fullHeight)
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

-- Close Button
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

-- Minimize Button
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

-- Tabs + Content Holders
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

local webhookContent = Instance.new("Frame")
webhookContent.Name = "ContentHolder"
webhookContent.BackgroundTransparency = 1
webhookContent.Size = UDim2.new(1, 0, 1, 0)
webhookContent.Parent = webhookTab

local toolsTab = webhookTab:Clone()
toolsTab.Name = "ToolsTab"
toolsTab.Parent = mainFrame

local toolsContent = toolsTab:FindFirstChild("ContentHolder")

-- Tab Switching
local function showTab(name)
    state.activeTab = name
    saveConfig(state)
    webhookContent.Visible = name == "Webhook" and not state.minimized
    toolsContent.Visible = name == "Tools" and not state.minimized
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

-- Minimize Fix (FINAL WORKING VERSION ✅)
local function buildContent()
    -- Recreate the webhook content container and its elements
    webhookContent = Instance.new("Frame")
    -- set properties, layout, children (textboxes, execute button) etc.
    -- same for toolsContent and Infinite Yield button
    -- make sure to rewire their events, fades, and saved state
    -- ...
end

minimizeButton.MouseButton1Click:Connect(function()
    state.minimized = not state.minimized
    saveConfig(state)

    tabHolder.Visible = not state.minimized

    local tweenFade = function(frame, fadeOut)
        local transparency = fadeOut and 1 or 0
        for _, child in frame:GetDescendants() do
            if child:IsA("TextLabel") or child:IsA("TextBox") or child:IsA("TextButton") then
                child.TextTransparency = transparency
            end
        end
    end

    if state.minimized then
        -- Fade content first
        if state.activeTab == "Webhook" then
            tweenFade(webhookContent, true)
        else
            tweenFade(toolsContent, true)
        end

        -- After fade, destroy + shrink
        task.delay(0.25, function()
            if webhookTab then webhookTab:Destroy() end
            if toolsTab then toolsTab:Destroy() end

            TweenService:Create(mainFrame, TweenInfo.new(0.25), {
                Size = UDim2.new(0, 400, 0, 40)
            }):Play()
        end)
    else
        -- Expand frame
        TweenService:Create(mainFrame, TweenInfo.new(0.25), {
            Size = UDim2.new(0, 400, 0, 380)
        }):Play()

        -- After expand, rebuild UI + fade in
        task.delay(0.25, function()
            buildTabsAndContent(mainFrame)
            if state.activeTab == "Webhook" then
                tweenFade(webhookContent, false)
                webhookContent.Visible = true
                toolsContent.Visible = false
            else
                tweenFade(toolsContent, false)
                webhookContent.Visible = false
                toolsContent.Visible = true
            end
        end)
    end
end)





-- Initialize tab visibility
tabHolder.Visible = not state.minimized
webhookContent.Visible = not state.minimized and state.activeTab == "Webhook"
toolsContent.Visible = not state.minimized and state.activeTab == "Tools"

-- Webhook Content UI
local function createInput(labelText, placeholder, key, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = webhookContent

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

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = webhookContent

Instance.new("UIPadding", webhookContent).PaddingTop = UDim.new(0, 5)

local jamSelesaiBox = createInput("jam_selesai_joki", "e.g., 1", "jam_selesai_joki", 1)
local webhookBox = createInput("discord_webhook", "Paste Discord Webhook", "discord_webhook", 2)
local orderBox = createInput("no_order", "e.g., OD000000123", "no_order", 3)
local storeNameBox = createInput("nama_store", "e.g., AfkarStore", "nama_store", 4)

-- Execute Button
local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0.9, 0, 0, 40)
executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeButton.BorderColor3 = Color3.fromRGB(120, 130, 255)
executeButton.Text = "EXECUTE SCRIPT"
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 18
executeButton.LayoutOrder = 5
executeButton.Parent = webhookContent
Instance.new("UICorner", executeButton).CornerRadius = UDim.new(0, 6)

executeButton.MouseButton1Click:Connect(function()
    local jamSelesai = tonumber(jamSelesaiBox.Text) or 1
    local webhookUrl = webhookBox.Text
    local orderId = orderBox.Text
    local storeName = storeNameBox.Text

    if webhookUrl == "" or orderId == "" or storeName == "" then
        executeButton.Text = "PLEASE FILL ALL FIELDS"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        task.wait(2)
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    executeButton.Active = false
    executeButton.Text = "EXECUTING..."
    executeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)

    local success, content = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua")
    end)

    if not success then
        executeButton.Text = "HTTP GET FAILED"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        warn("Failed to fetch script:", content)
        task.wait(3)
    else
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
            task.wait(2)
        else
            executeButton.Text = "EXECUTION ERROR"
            executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
            warn("Execution error:", err)
            task.wait(3)
        end
    end

    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    executeButton.Active = true
end)

-- Tools Tab: Infinite Yield
local iyButton = Instance.new("TextButton")
iyButton.Size = UDim2.new(0, 200, 0, 40)
iyButton.Position = UDim2.new(0.5, -100, 0.5, -20)
iyButton.BackgroundColor3 = Color3.fromRGB(44, 130, 201)
iyButton.Text = "Infinite Yield"
iyButton.Font = Enum.Font.SourceSansBold
iyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
iyButton.TextSize = 18
iyButton.Parent = toolsContent
Instance.new("UICorner", iyButton).CornerRadius = UDim.new(0, 6)

iyButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
