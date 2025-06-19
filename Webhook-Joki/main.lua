--[[
    All-in-One UI Script for Webhook Execution (v3 - With Tabs)
    - Creates a UI with two tabs: "Webhook" and "Admin".
    - Webhook tab allows inputting custom values for a remote script.
    - Admin tab provides quick execution for common scripts.
    - Features: Draggable window, text wrapping, close button, tabbed interface.
]]

-- Prevent the script from running in the command bar or on the server
if not game:IsLoaded() then
    game.Loaded:Wait()
end
if not game:GetService("Players").LocalPlayer then
    warn("This script must be run from a client executor.")
    return
end

-- =================================================================
-- UI CREATION
-- =================================================================

-- Clean up any previous UI with the same name
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiWebhookUI_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = game:GetService("CoreGui")

-- [MODIFIED] Increased height from 350 to 390 to accommodate the new tab bar
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 390) -- Taller UI for tabs
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -195)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 105)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add a corner radius to the frame
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
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Close Button (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 22, 0, 22)
closeButton.Position = UDim2.new(1, -16, 0.5, 0)
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Parent = titleLabel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy() -- [MODIFIED] Destroy the UI instead of just disabling it for a cleaner exit.
end)


-- [MODIFIED] =================================================================
-- TABS SYSTEM
-- =================================================================

-- Tab Colors
local activeTabColor = Color3.fromRGB(88, 101, 242)
local inactiveTabColor = Color3.fromRGB(55, 55, 65)

-- Tab Bar Container
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.Position = UDim2.new(0, 0, 0, 30) -- Positioned right below the title
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 10)
tabLayout.Parent = tabBar

-- Webhook Tab Button
local webhookTabButton = Instance.new("TextButton")
webhookTabButton.Name = "WebhookTab"
webhookTabButton.Size = UDim2.new(0, 100, 1, 0)
webhookTabButton.BackgroundColor3 = activeTabColor -- Active by default
webhookTabButton.Text = "Webhook"
webhookTabButton.Font = Enum.Font.SourceSansBold
webhookTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
webhookTabButton.TextSize = 14
webhookTabButton.LayoutOrder = 1
webhookTabButton.Parent = tabBar
local webhookTabCorner = Instance.new("UICorner")
webhookTabCorner.CornerRadius = UDim.new(0, 6)
webhookTabCorner.Parent = webhookTabButton

-- Admin Tab Button
local adminTabButton = Instance.new("TextButton")
adminTabButton.Name = "AdminTab"
adminTabButton.Size = UDim2.new(0, 100, 1, 0)
adminTabButton.BackgroundColor3 = inactiveTabColor -- Inactive by default
adminTabButton.Text = "Admin"
adminTabButton.Font = Enum.Font.SourceSansBold
adminTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
adminTabButton.TextSize = 14
adminTabButton.LayoutOrder = 2
adminTabButton.Parent = tabBar
local adminTabCorner = Instance.new("UICorner")
adminTabCorner.CornerRadius = UDim.new(0, 6)
adminTabCorner.Parent = adminTabButton


-- [MODIFIED] Page Container
local pageContainer = Instance.new("Frame")
pageContainer.Name = "PageContainer"
pageContainer.Size = UDim2.new(1, 0, 1, -65) -- Fill space below title and tabs
pageContainer.Position = UDim2.new(0, 0, 0, 65)
pageContainer.BackgroundTransparency = 1
pageContainer.Parent = mainFrame

-- Webhook Page
local webhookPage = Instance.new("Frame")
webhookPage.Name = "WebhookPage"
webhookPage.Size = UDim2.new(1, 0, 1, 0)
webhookPage.BackgroundTransparency = 1
webhookPage.Visible = true -- Visible by default
webhookPage.Parent = pageContainer

-- Admin Page
local adminPage = Instance.new("Frame")
adminPage.Name = "AdminPage"
adminPage.Size = UDim2.new(1, 0, 1, 0)
adminPage.BackgroundTransparency = 1
adminPage.Visible = false -- Hidden by default
adminPage.Parent = pageContainer


-- [MODIFIED] =================================================================
-- WEBHOOK PAGE CONTENT
-- =================================================================

-- UIListLayout for webhook elements
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = webhookPage -- [MODIFIED] Parent is now the webhook page

-- Add padding to the top of the webhook page
local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.Parent = webhookPage -- [MODIFIED] Parent is now the webhook page

-- Helper function to create a labeled textbox
local function createLabeledInput(name, placeholder, order, isNumber)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = webhookPage -- [MODIFIED] Parent is now the webhook page

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
    textbox.Text = ""
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.TextSize = 14
    textbox.ClearTextOnFocus = false
    textbox.TextWrapped = true
    if isNumber then
        textbox.Text = "1" -- Default value
    end
    textbox.Parent = container
    
    local textCorner = Instance.new("UICorner")
    textCorner.CornerRadius = UDim.new(0, 4)
    textCorner.Parent = textbox

    return textbox
end

-- Create the input fields for the webhook page
local jamSelesaiBox = createLabeledInput("jam_selesai_joki", "e.g., 1", 1, true)
local webhookBox = createLabeledInput("discord_webhook", "Paste your Discord Webhook URL here", 2, false)
local orderBox = createLabeledInput("no_order", "e.g., OD000000141403135", 3, false)
local storeNameBox = createLabeledInput("nama_store", "e.g., AfkarStore", 4, false)

-- Webhook Execute Button
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
executeButton.Parent = webhookPage -- [MODIFIED] Parent is now the webhook page

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = executeButton

-- [MODIFIED] =================================================================
-- ADMIN PAGE CONTENT
-- =================================================================

-- Infinite Yield Button
local infiniteYieldButton = Instance.new("TextButton")
infiniteYieldButton.Name = "InfiniteYieldButton"
infiniteYieldButton.Size = UDim2.new(0.8, 0, 0, 50)
infiniteYieldButton.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centered
infiniteYieldButton.AnchorPoint = Vector2.new(0.5, 0.5)
infiniteYieldButton.BackgroundColor3 = Color3.fromRGB(25, 118, 210) -- A different blue
infiniteYieldButton.BorderColor3 = Color3.fromRGB(100, 181, 246)
infiniteYieldButton.BorderSizePixel = 1
infiniteYieldButton.Text = "Infinite Yield"
infiniteYieldButton.Font = Enum.Font.SourceSansBold
infiniteYieldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infiniteYieldButton.TextSize = 20
infiniteYieldButton.Parent = adminPage -- Parent is the admin page

local iyButtonCorner = Instance.new("UICorner")
iyButtonCorner.CornerRadius = UDim.new(0, 8)
iyButtonCorner.Parent = infiniteYieldButton


-- =================================================================
-- LOGIC
-- =================================================================

-- [MODIFIED] Tab switching logic
webhookTabButton.MouseButton1Click:Connect(function()
    webhookPage.Visible = true
    adminPage.Visible = false
    webhookTabButton.BackgroundColor3 = activeTabColor
    adminTabButton.BackgroundColor3 = inactiveTabColor
end)

adminTabButton.MouseButton1Click:Connect(function()
    webhookPage.Visible = false
    adminPage.Visible = true
    webhookTabButton.BackgroundColor3 = inactiveTabColor
    adminTabButton.BackgroundColor3 = activeTabColor
end)


-- Original Webhook button logic
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
        warn("Failed to fetch remote script:", remoteContent)
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
    ]], jamSelesai, webhookUrl, orderId, storeName, remoteContent)
    
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
        warn("Error during loadstring execution:", loadError)
        wait(3)
    end
    
    executeButton.Active = true
    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)

-- [MODIFIED] Infinite Yield button logic
infiniteYieldButton.MouseButton1Click:Connect(function()
    -- Give visual feedback before executing
    local originalText = infiniteYieldButton.Text
    infiniteYieldButton.Text = "LOADING..."
    
    -- Hide the main UI so it doesn't overlap with the Infinite Yield UI
    screenGui.Enabled = false 
    
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
    
    -- This part may not run if Infinite Yield yields or errors, 
    -- but it's good practice to include it.
    wait(1)
    infiniteYieldButton.Text = originalText
    screenGui.Enabled = true -- Re-enable the UI if the user closes IY.
end)
