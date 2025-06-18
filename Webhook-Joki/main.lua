--[[
    All-in-One UI Script for Webhook Execution (v2)
    - Creates a UI to input custom values.
    - Features: Draggable window, text wrapping, close button.
    - Fetches a remote script, injects the custom values, and executes it.
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

-- Main Frame (the window) - Increased height from 300 to 350
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 350) -- Taller UI
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
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

-- [NEW] Close Button (X)
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

-- [NEW] Close button functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)


-- UIListLayout to automatically stack elements
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = mainFrame

-- Add padding to push content below the title bar
local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 35)
uiPadding.Parent = mainFrame


-- Helper function to create a labeled textbox
local function createLabeledInput(name, placeholder, order, isNumber)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order
    container.Parent = mainFrame

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
    textbox.TextWrapped = true -- [NEW] Added text wrapping
    if isNumber then
        textbox.Text = "1" -- Default value
    end
    textbox.Parent = container
    
    local textCorner = Instance.new("UICorner")
    textCorner.CornerRadius = UDim.new(0, 4)
    textCorner.Parent = textbox

    return textbox
end

-- Create the input fields using the helper function
local jamSelesaiBox = createLabeledInput("jam_selesai_joki", "e.g., 1", 1, true)
local webhookBox = createLabeledInput("discord_webhook", "Paste your Discord Webhook URL here", 2, false)
local orderBox = createLabeledInput("no_order", "e.g., OD000000141403135", 3, false)
local storeNameBox = createLabeledInput("nama_store", "e.g., AfkarStore", 4, false)

-- Execute Button
local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(0.9, 0, 0, 40)
executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord Blurple
executeButton.BorderColor3 = Color3.fromRGB(120, 130, 255)
executeButton.BorderSizePixel = 1
executeButton.Text = "EXECUTE SCRIPT"
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 18
executeButton.LayoutOrder = 5
executeButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = executeButton


-- =================================================================
-- BUTTON LOGIC
-- =================================================================

executeButton.MouseButton1Click:Connect(function()
    -- Get values from textboxes
    local jamSelesai = tonumber(jamSelesaiBox.Text) or 1 -- Default to 1 if input is not a valid number
    local webhookUrl = webhookBox.Text
    local orderId = orderBox.Text
    local storeName = storeNameBox.Text

    -- Basic validation
    if webhookUrl == "" or orderId == "" or storeName == "" then
        executeButton.Text = "PLEASE FILL ALL FIELDS"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69) -- Red
        wait(2)
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Restore original color
        return
    end

    -- Provide feedback to the user
    executeButton.Active = false
    executeButton.Text = "EXECUTING..."
    executeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    
    local remoteScriptUrl = "https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua"

    -- Fetch the remote script content
    local success, remoteContent = pcall(function()
        return game:HttpGet(remoteScriptUrl)
    end)

    if not success or not remoteContent then
        executeButton.Text = "HTTP GET FAILED"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69) -- Red
        warn("Failed to fetch remote script:", remoteContent)
        wait(3)
        executeButton.Active = true
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    -- Construct the final script by prepending the user-defined variables
    local finalScript = string.format([[
        -- Variables injected by the UI script
        local jam_selesai_joki = %s
        local discord_webhook = %q
        local no_order = %q
        local nama_store = %q

        -- Original remote script content begins here
        %s
    ]], jamSelesai, webhookUrl, orderId, storeName, remoteContent)
    
    -- Execute the combined script using loadstring
    local loadSuccess, loadError = pcall(function()
        loadstring(finalScript)()
    end)
    
    if loadSuccess then
        executeButton.Text = "SUCCESS!"
        executeButton.BackgroundColor3 = Color3.fromRGB(87, 242, 135) -- Green
        wait(2)
    else
        executeButton.Text = "EXECUTION ERROR"
        executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69) -- Red
        warn("Error during loadstring execution:", loadError)
        wait(3)
    end
    
    -- Reset the button state
    executeButton.Active = true
    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)

