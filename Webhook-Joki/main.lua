--[[
    All-in-One UI with Tabs and Executor Script
    Creates a tabbed UI to input settings and then executes the main joki webhook script.
]]

-- Create the ScreenGui to hold all UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiExecutorUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the main frame for the UI
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 360) -- Increased height for tabs
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Create a title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.BorderColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.Text = "Joki Executor"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Parent = mainFrame

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
contentContainer.Size = UDim2.new(1, 0, 1, -70) -- Adjusted size
contentContainer.Position = UDim2.new(0, 0, 0, 70)
contentContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
contentContainer.BorderSizePixel = 0
contentContainer.ClipsDescendants = true
contentContainer.Parent = mainFrame

-- ============================ TABS SETUP ============================

-- Create the Settings Tab Frame
local settingsTab = Instance.new("Frame")
settingsTab.Name = "SettingsTab"
settingsTab.Size = UDim2.new(1, 0, 1, 0)
settingsTab.Position = UDim2.new(0, 0, 0, 0)
settingsTab.BackgroundTransparency = 1
settingsTab.Parent = contentContainer

-- Create the Other Tab Frame
local otherTab = Instance.new("Frame")
otherTab.Name = "OtherTab"
otherTab.Size = UDim2.new(1, 0, 1, 0)
otherTab.Position = UDim2.new(0, 0, 0, 0)
otherTab.BackgroundTransparency = 1
otherTab.Visible = false -- Hide it by default
otherTab.Parent = contentContainer

-- ============================ TAB BUTTONS ============================

local settingsTabButton = Instance.new("TextButton")
settingsTabButton.Name = "SettingsTabButton"
settingsTabButton.Size = UDim2.new(0.5, 0, 1, 0)
settingsTabButton.Position = UDim2.new(0, 0, 0, 0)
settingsTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Active color
settingsTabButton.BorderSizePixel = 0
settingsTabButton.Font = Enum.Font.SourceSansBold
settingsTabButton.Text = "Settings"
settingsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTabButton.TextSize = 16
settingsTabButton.Parent = tabContainer

local otherTabButton = Instance.new("TextButton")
otherTabButton.Name = "OtherTabButton"
otherTabButton.Size = UDim2.new(0.5, 0, 1, 0)
otherTabButton.Position = UDim2.new(0.5, 0, 0, 0)
otherTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Inactive color
otherTabButton.BorderSizePixel = 0
otherTabButton.Font = Enum.Font.SourceSans
otherTabButton.Text = "Other"
otherTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
otherTabButton.TextSize = 16
otherTabButton.Parent = tabContainer

-- ======================= CONTENT FOR SETTINGS TAB =======================

-- Function to create a labeled textbox inside the settings tab
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

    return textbox
end

-- Create the input fields and parent them to the settingsTab
local jamSelesaiBox = createLabeledTextBox(settingsTab, 10, "Jam Selesai", "e.g., 1", "1")
local webhookBox = createLabeledTextBox(settingsTab, 50, "Discord Webhook", "Your webhook URL here", "discord webhook here")
local orderBox = createLabeledTextBox(settingsTab, 90, "No. Order", "e.g., OD000000141403135", "OD000000141403135")
local storeNameBox = createLabeledTextBox(settingsTab, 130, "Nama Store", "Your store name", "AfkarStore")

-- Create the execute button in the settingsTab
local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(1, -20, 0, 40)
executeButton.Position = UDim2.new(0, 10, 1, -50)
executeButton.BackgroundColor3 = Color3.fromRGB(80, 165, 80)
executeButton.BorderColor3 = Color3.fromRGB(25, 25, 25)
executeButton.Font = Enum.Font.SourceSansBold
executeButton.Text = "EXECUTE"
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 20
executeButton.Parent = settingsTab

-- Create a status label in the settingsTab
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
statusLabel.Parent = settingsTab

-- ======================= CONTENT FOR OTHER TAB =======================

local placeholderButton = Instance.new("TextButton")
placeholderButton.Name = "PlaceholderButton"
placeholderButton.Size = UDim2.new(0, 200, 0, 50)
placeholderButton.Position = UDim2.new(0.5, -100, 0.5, -25)
placeholderButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
placeholderButton.BorderColor3 = Color3.fromRGB(25, 25, 25)
placeholderButton.Font = Enum.Font.SourceSansBold
placeholderButton.Text = "Placeholder Button"
placeholderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
placeholderButton.TextSize = 18
placeholderButton.Parent = otherTab

placeholderButton.MouseButton1Click:Connect(function()
    print("Placeholder button was clicked!")
end)

-- ============================ EVENT HANDLERS ============================

-- Close button logic
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

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tab switching logic
local function switchTab(tabToShow)
    for _, child in ipairs(contentContainer:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false
        end
    end
    tabToShow.Visible = true

    -- Update button appearance
    if tabToShow == settingsTab then
        settingsTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        settingsTabButton.Font = Enum.Font.SourceSansBold
        otherTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        otherTabButton.Font = Enum.Font.SourceSans
    else
        settingsTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        settingsTabButton.Font = Enum.Font.SourceSans
        otherTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        otherTabButton.Font = Enum.Font.SourceSansBold
    end
end

settingsTabButton.MouseButton1Click:Connect(function() switchTab(settingsTab) end)
otherTabButton.MouseButton1Click:Connect(function() switchTab(otherTab) end)

-- Main execution logic (remains the same)
executeButton.MouseButton1Click:Connect(function()
    local jam_selesai_joki_val = tonumber(jamSelesaiBox.Text) or 1
    local discord_webhook_val = webhookBox.Text
    local no_order_val = orderBox.Text
    local nama_store_val = storeNameBox.Text

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

    statusLabel.Text = "Status: Executing script..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)

    local codeToExecute = string.format([[
        local jam_selesai_joki = %d
        local discord_webhook = "%s"
        local no_order = "%s"
        local nama_store = "%s"
    ]], jam_selesai_joki_val, discord_webhook_val, no_order_val, nama_store_val)

    local fullScript = codeToExecute .. '\nloadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki-Perjam/Webhook.lua"))();'
    
    local success, err = pcall(function()
        local func = loadstring(fullScript)
        func()
    end)

    if success then
        statusLabel.Text = "Status: Script executed successfully!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        wait(2)
        screenGui:Destroy()
    else
        statusLabel.Text = "Status: Execution failed! See output."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        warn("Execution Error:", err)
    end
end)

print("Joki Executor UI Loaded. GUI created by Gemini.")
-- Set the initial visible tab
switchTab(settingsTab)
