--[[
    All-in-One UI and Executor Script
    Creates a UI to input settings and then executes the main joki webhook script.
]]

-- Create the ScreenGui to hold all UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiExecutorUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the main frame for the UI
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 320)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
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
titleLabel.Text = "Joki Executor Settings"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Parent = mainFrame

-- Function to create a labeled textbox
local function createLabeledTextBox(parent, yPosition, labelText, placeholderText, initialText)
    local label = Instance.new("TextLabel")
    label.Name = labelText .. "Label"
    label.Size = UDim2.new(0, 120, 0, 30)
    label.Position = UDim2.new(0, 10, 0, yPosition)
    label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.Text = labelText .. " :"
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local textbox = Instance.new("TextBox")
    textbox.Name = labelText .. "TextBox"
    textbox.Size = UDim2.new(1, -140, 0, 30)
    textbox.Position = UDim2.new(0, 130, 0, yPosition)
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

-- Create the input fields using the helper function
local jamSelesaiBox = createLabeledTextBox(mainFrame, 50, "Jam Selesai", "e.g., 1", "1")
local webhookBox = createLabeledTextBox(mainFrame, 90, "Discord Webhook", "Your webhook URL here", "discord webhook here")
local orderBox = createLabeledTextBox(mainFrame, 130, "No. Order", "e.g., OD000000141403135", "OD000000141403135")
local storeNameBox = createLabeledTextBox(mainFrame, 170, "Nama Store", "Your store name", "AfkarStore")

-- Create the execute button
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
executeButton.Parent = mainFrame

-- Create a status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 220)
statusLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 16
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Create a close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 20
closeButton.Parent = mainFrame

-- Event handlers

-- Close button logic
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Main execution logic
executeButton.MouseButton1Click:Connect(function()
    -- Get the values from the textboxes
    local jam_selesai_joki_val = tonumber(jamSelesaiBox.Text) or 1
    local discord_webhook_val = webhookBox.Text
    local no_order_val = orderBox.Text
    local nama_store_val = storeNameBox.Text

    -- Basic validation
    if not discord_webhook_val or not string.match(discord_webhook_val, "https://discord.com/api/webhooks/") then
        statusLabel.Text = "Status: Error - Invalid Discord Webhook URL."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    if no_order_val == "" or nama_store_val == "" then
        statusLabel.Text = "Status: Error - Order Number and Store Name cannot be empty."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    statusLabel.Text = "Status: Executing script..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)

    -- Construct the code to be executed as a string
    -- This string declares the variables with the user's input and then appends the HttpGet loadstring
    local codeToExecute = string.format([[
        local jam_selesai_joki = %d
        local discord_webhook = "%s"
        local no_order = "%s"
        local nama_store = "%s"

        -- The rest of your script from GitHub will be loaded and executed below
        -- and will have access to the local variables defined above.
    ]], jam_selesai_joki_val, discord_webhook_val, no_order_val, nama_store_val)

    -- Combine the user-defined variables with the remote script loader
    local fullScript = codeToExecute .. '\nloadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua"))();'
    
    -- Execute the combined script
    local success, err = pcall(function()
        local func = loadstring(fullScript)
        func()
    end)

    if success then
        statusLabel.Text = "Status: Script executed successfully!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        wait(2)
        screenGui:Destroy() -- Optional: close the UI on success
    else
        statusLabel.Text = "Status: Execution failed! Check output for errors."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        warn("Execution Error:", err)
    end
end)

print("Joki Executor UI Loaded. GUI created by Gemini.")
