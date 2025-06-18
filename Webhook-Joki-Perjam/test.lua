-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MovableEditableUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame for the UI (this will be draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 320) -- Increased size to accommodate more inputs
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UI Corner for rounded edges (optional)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -20, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 10)
TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 20
TitleLabel.Text = "Editable UI Config"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = MainFrame

-- Local Variables (initial values)
local jam_selesai_joki = 1
local webhook_discord = "YOUR_WEBHOOK_URL_HERE" -- **REMEMBER TO REPLACE THIS WITH YOUR ACTUAL WEBHOOK URL**
local no_order = "OD000000141403135"
local nama_store = "AfkarStore"

-- Function to create a label and a textbox pair
local function createInputPair(parent, yOffset, labelText, initialValue)
    local label = Instance.new("TextLabel")
    label.Name = labelText:gsub(" ", "") .. "Label"
    label.Size = UDim2.new(0.3, 0, 0, 25)
    label.Position = UDim2.new(0, 10, 0, yOffset)
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Transparent-like
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = labelText .. ":"
    label.Parent = parent

    local textBox = Instance.new("TextBox")
    textBox.Name = labelText:gsub(" ", "") .. "Input"
    textBox.Size = UDim2.new(0.65, 0, 0, 25)
    textBox.Position = UDim2.new(0.35, 5, 0, yOffset) -- Aligned with label
    textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 14
    textBox.Text = tostring(initialValue) -- Set initial text
    textBox.ClearTextOnFocus = false -- Don't clear when clicked
    textBox.Parent = parent

    return textBox
end

-- Create input fields for each variable
local JamSelesaiJokiInput = createInputPair(MainFrame, 50, "Jam Selesai Joki", jam_selesai_joki)
local WebhookDiscordInput = createInputPair(MainFrame, 80, "Webhook Discord", webhook_discord)
local NoOrderInput = createInputPair(MainFrame, 110, "No. Order", no_order)
local NamaStoreInput = createInputPair(MainFrame, 140, "Nama Store", nama_store)

-- Save Changes Button
local SaveButton = Instance.new("TextButton")
SaveButton.Name = "SaveButton"
SaveButton.Size = UDim2.new(1, -20, 0, 40)
SaveButton.Position = UDim2.new(0, 10, 0, 190) -- Position below inputs
SaveButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50) -- Greenish color
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.Font = Enum.Font.SourceSansBold
SaveButton.TextSize = 18
SaveButton.Text = "Save Changes"
SaveButton.Parent = MainFrame

-- Event for the Save Changes button
SaveButton.MouseButton1Click:Connect(function()
    -- Update local variables from TextBox inputs
    local newJamSelesaiJoki = tonumber(JamSelesaiJokiInput.Text)
    if newJamSelesaiJoki and newJamSelesaiJoki >= 0 then -- Basic validation for number
        jam_selesai_joki = newJamSelesaiJoki
    else
        warn("Invalid input for 'Jam Selesai Joki'. Please enter a valid number.")
        JamSelesaiJokiInput.Text = tostring(jam_selesai_joki) -- Revert to last valid
    end

    webhook_discord = WebhookDiscordInput.Text
    no_order = NoOrderInput.Text
    nama_store = NamaStoreInput.Text

    print("Variables updated:")
    print("  Jam Selesai Joki:", jam_selesai_joki)
    print("  Webhook Discord:", webhook_discord)
    print("  No. Order:", no_order)
    print("  Nama Store:", nama_store)

    -- You could also update a 'status' label here if desired
    -- e.g., StatusLabel.Text = "Saved!"
end)


-- Button to execute the loadstring code
local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Name = "ExecuteButton"
ExecuteButton.Size = UDim2.new(1, -20, 0, 40)
ExecuteButton.Position = UDim2.new(0, 10, 0, 240) -- Position below Save button
ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.Font = Enum.Font.SourceSansBold
ExecuteButton.TextSize = 18
ExecuteButton.Text = "Execute Webhook Script"
ExecuteButton.Parent = MainFrame

-- Event for the button click
ExecuteButton.MouseButton1Click:Connect(function()
    warn("Executing loadstring code...")
    -- The external script will use the *current* values of the 'webhook_discord' variable
    -- and any other global variables it might rely on.
    -- If the webhook.lua script *itself* relies on these specific local variables
    -- (jam_selesai_joki, no_order, nama_store) being present in its scope, you'll need
    -- to modify the webhook.lua script or pass them as arguments to a function within it.
    -- For now, this assumes webhook.lua only needs the webhook_discord value,
    -- or that the webhook.lua script itself defines and uses these variables
    -- in its own way.
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki-Perjam/Webhook.lua"))();
    print("Loadstring executed!")
end)

print("Movable Editable UI loaded successfully!")
