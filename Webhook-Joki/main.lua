--[[
    All-in-One UI with Tabs and Executor Script
    Creates a tabbed UI to input settings and then executes the desired script.
    UI elements now have rounded corners.
    Last Updated: June 20, 2025 (Webhook Execution Fixed)
]]

-- Services
local Players = game:GetService("Players")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create the ScreenGui to hold all UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiExecutorUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Create the main frame for the UI
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 360)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 8)
mainFrameCorner.Parent = mainFrame

-- Create a title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.Text = "Joki Executor"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Parent = mainFrame

local titleLabelCorner = Instance.new("UICorner")
titleLabelCorner.CornerRadius = UDim.new(0, 8)
titleLabelCorner.Parent = titleLabel

-- Create a container for the tab buttons
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

-- Create a container to hold the actual content of the tabs
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, 0, 1, -70)
contentContainer.Position = UDim2.new(0, 0, 0, 70)
contentContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
contentContainer.BorderSizePixel = 0
contentContainer.ClipsDescendants = true
contentContainer.Parent = mainFrame

local contentContainerCorner = Instance.new("UICorner")
contentContainerCorner.CornerRadius = UDim.new(0, 8)
contentContainerCorner.Parent = contentContainer


-- ============================ TABS SETUP ============================

local webhookTab = Instance.new("Frame")
webhookTab.Name = "WebhookTab"
webhookTab.Size = UDim2.new(1, 0, 1, 0)
webhookTab.BackgroundTransparency = 1
webhookTab.Parent = contentContainer

local otherTab = Instance.new("Frame")
otherTab.Name = "OtherTab"
otherTab.Size = UDim2.new(1, 0, 1, 0)
otherTab.BackgroundTransparency = 1
otherTab.Visible = false
otherTab.Parent = contentContainer

-- ============================ TAB BUTTONS ============================

local webhookTabButton = Instance.new("TextButton")
webhookTabButton.Name = "WebhookTabButton"
webhookTabButton.Size = UDim2.new(0.5, 0, 1, 0)
webhookTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
webhookTabButton.BorderSizePixel = 0
webhookTabButton.Font = Enum.Font.SourceSansBold
webhookTabButton.Text = "Webhook"
webhookTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
webhookTabButton.TextSize = 16
webhookTabButton.Parent = tabContainer

local webhookTabButtonCorner = Instance.new("UICorner")
webhookTabButtonCorner.CornerRadius = UDim.new(0, 8)
webhookTabButtonCorner.Parent = webhookTabButton

local otherTabButton = Instance.new("TextButton")
otherTabButton.Name = "OtherTabButton"
otherTabButton.Size = UDim2.new(0.5, 0, 1, 0)
otherTabButton.Position = UDim2.new(0.5, 0, 0, 0)
otherTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
otherTabButton.BorderSizePixel = 0
otherTabButton.Font = Enum.Font.SourceSans
otherTabButton.Text = "Other"
otherTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
otherTabButton.TextSize = 16
otherTabButton.Parent = tabContainer

local otherTabButtonCorner = Instance.new("UICorner")
otherTabButtonCorner.CornerRadius = UDim.new(0, 8)
otherTabButtonCorner.Parent = otherTabButton

-- ======================= CONTENT FOR WEBHOOK TAB =======================

local function createLabeledTextBox(parent, yPosition, labelText, placeholderText, initialText)
    local label = Instance.new("TextLabel")
    label.Name = labelText .. "Label"
    label.Size = UDim2.new(0, 130, 0, 30)
    label.Position = UDim2.new(0, 10, 0, yPosition)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.Text = labelText .. " :"
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local textbox = Instance.new("TextBox")
    textbox.Name = labelText .. "TextBox"
    textbox.Size = UDim2.new(1, -150, 0, 30)
    textbox.Position = UDim2.new(0, 140, 0, yPosition)
    textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textbox.BorderColor3 = Color3.fromRGB(25, 25, 25)
    textbox.Font = Enum.Font.SourceSans
    textbox.Text = initialText or ""
    textbox.PlaceholderText = placeholderText
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.TextSize = 16
    textbox.ClearTextOnFocus = false
    textbox.Parent = parent
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 4)
    textboxCorner.Parent = textbox

    return textbox
end

local jamSelesaiBox = createLabeledTextBox(webhookTab, 10, "Jam Selesai", "e.g., 1", "1")
local webhookBox = createLabeledTextBox(webhookTab, 50, "Discord Webhook", "Your webhook URL here", "")
local orderBox = createLabeledTextBox(webhookTab, 90, "No. Order", "e.g., OD000000141403135", "")
local storeNameBox = createLabeledTextBox(webhookTab, 130, "Nama Store", "Your store name", "")

local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(1, -20, 0, 40)
executeButton.Position = UDim2.new(0, 10, 1, -50)
executeButton.BackgroundColor3 = Color3.fromRGB(80, 165, 80)
executeButton.Font = Enum.Font.SourceSansBold
executeButton.Text = "EXECUTE"
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 20
executeButton.Parent = webhookTab

local executeButtonCorner = Instance.new("UICorner")
executeButtonCorner.CornerRadius = UDim.new(0, 8)
executeButtonCorner.Parent = executeButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 175)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 16
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = webhookTab

-- ======================= CONTENT FOR OTHER TAB =======================

local infiniteYieldButton = Instance.new("TextButton")
infiniteYieldButton.Name = "InfiniteYieldButton"
infiniteYieldButton.Size = UDim2.new(0, 200, 0, 50)
infiniteYieldButton.Position = UDim2.new(0.5, -100, 0.5, -25)
infiniteYieldButton.BackgroundColor3 = Color3.fromRGB(115, 75, 180)
infiniteYieldButton.Font = Enum.Font.SourceSansBold
infiniteYieldButton.Text = "Infinite Yield"
infiniteYieldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infiniteYieldButton.TextSize = 18
infiniteYieldButton.Parent = otherTab

local infiniteYieldButtonCorner = Instance.new("UICorner")
infiniteYieldButtonCorner.CornerRadius = UDim.new(0, 8)
infiniteYieldButtonCorner.Parent = infiniteYieldButton

infiniteYieldButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
end)

-- ============================ EVENT HANDLERS ============================

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 20
closeButton.ZIndex = 2
closeButton.Parent = mainFrame

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 6)
closeButtonCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local function switchTab(tabToShow)
    for _, child in ipairs(contentContainer:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false
        end
    end
    tabToShow.Visible = true

    if tabToShow == webhookTab then
        webhookTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        webhookTabButton.Font = Enum.Font.SourceSansBold
        otherTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        otherTabButton.Font = Enum.Font.SourceSans
    else
        webhookTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        webhookTabButton.Font = Enum.Font.SourceSans
        otherTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        otherTabButton.Font = Enum.Font.SourceSansBold
    end
end

webhookTabButton.MouseButton1Click:Connect(function() switchTab(webhookTab) end)
otherTabButton.MouseButton1Click:Connect(function() switchTab(otherTab) end)

-- FIXED EXECUTION LOGIC
executeButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Preparing..."
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

    -- Get the values from the textboxes
    local jam_selesai_joki_val = tonumber(jamSelesaiBox.Text) or 1
    local discord_webhook_val = webhookBox.Text
    local no_order_val = orderBox.Text
    local nama_store_val = storeNameBox.Text

    -- Validation remains the same
    if not discord_webhook_val or not string.match(discord_webhook_val, "https://discord.com/api/webhooks/") then
        statusLabel.Text = "Status: Error - Invalid Discord Webhook URL."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    if no_order_val == "" or nama_store_val == "" then
        statusLabel.Text = "Status: Error - Order & Store Name cannot be empty."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    statusLabel.Text = "Status: Fetching remote script..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    wait() -- Allow UI to update

    -- Wrap the entire network and execution in a pcall
    local success, result = pcall(function()
        -- 1. Fetch the script content from GitHub first
        local remoteScriptContent = game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki-Perjam/Webhook.lua")

        -- 2. Compile the remote script into a function
        local remoteFunction, compileError = loadstring(remoteScriptContent)
        if not remoteFunction then
            -- This error happens if the script from GitHub has a syntax error
            error("Failed to compile remote script: " .. tostring(compileError))
        end

        -- 3. Create a custom environment for the script to run in
        local scriptEnvironment = {
            jam_selesai_joki = jam_selesai_joki_val,
            discord_webhook = discord_webhook_val,
            no_order = no_order_val,
            nama_store = nama_store_val
        }

        -- 4. Give the custom environment access to the default globals (like 'game', 'os', 'print', 'request')
        -- Without this, the remote script wouldn't know what 'game:GetService' is.
        setmetatable(scriptEnvironment, {__index = _G})

        -- 5. Set the remote function's environment to our custom one
        setfenv(remoteFunction, scriptEnvironment)

        -- 6. Execute the function
        remoteFunction()
    end)

    if success then
        statusLabel.Text = "Status: Webhook script executed successfully!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        statusLabel.Text = "Status: Execution failed! See output."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        warn("Webhook Execution Error:", result) -- 'result' will contain the error message
    end
end)


print("Joki Executor UI Loaded. GUI created by Gemini.")
switchTab(webhookTab)

