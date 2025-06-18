--[[
    All-in-One UI and Executor Script
    - Added TextWrapped property as requested.
]]

-- Prevent the script from running in the command bar or on the server
if not game:IsLoaded() then
    game.Loaded:Wait()
end
pcall(function()
    if game:GetService("RunService"):IsStudio() and not _G.permissionToRun then
        return
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--============================================================================--
-- I. CREATE THE USER INTERFACE
--============================================================================--

-- Create the main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ConfigExecutorUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create a container frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 270)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -135)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Create a title bar
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.BorderColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.Text = "Joki Webhook Configuration"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

-- Function to create a labeled text box for configuration
local function createConfigRow(parent, yPos, labelText, placeholderText)
    local rowLabel = Instance.new("TextLabel")
    rowLabel.Name = labelText .. "Label"
    rowLabel.Size = UDim2.new(0, 140, 0, 30)
    rowLabel.Position = UDim2.new(0, 15, 0, yPos)
    rowLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    rowLabel.BackgroundTransparency = 1
    rowLabel.Font = Enum.Font.SourceSans
    rowLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    rowLabel.TextSize = 14
    rowLabel.Text = labelText .. " :"
    rowLabel.TextXAlignment = Enum.TextXAlignment.Left
    rowLabel.Parent = parent

    local rowTextBox = Instance.new("TextBox")
    rowTextBox.Name = labelText .. "TextBox"
    rowTextBox.Size = UDim2.new(0, 260, 0, 30)
    rowTextBox.Position = UDim2.new(0, 160, 0, yPos)
    rowTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    rowTextBox.BorderColor3 = Color3.fromRGB(25, 25, 25)
    rowTextBox.Font = Enum.Font.SourceSans
    rowTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    rowTextBox.TextSize = 14
    rowTextBox.PlaceholderText = placeholderText
    rowTextBox.Text = placeholderText -- Set default value
    rowTextBox.ClearTextOnFocus = false
    
    -- <<< THE ONLY CHANGE IS ADDING THIS LINE >>>
    rowTextBox.TextWrapped = true

    rowTextBox.Parent = parent

    return rowTextBox
end

-- Create the text boxes using the function
local jamSelesaiBox = createConfigRow(mainFrame, 45, "Jam Selesai Joki", "1")
local webhookBox = createConfigRow(mainFrame, 85, "Discord Webhook", "")
local orderBox = createConfigRow(mainFrame, 125, "No. Order", "")
local storeNameBox = createConfigRow(mainFrame, 165, "Nama Store", "AfkarStore")

-- Create the execution button
local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(1, -30, 0, 40)
executeButton.Position = UDim2.new(0, 15, 0, 215)
executeButton.BackgroundColor3 = Color3.fromRGB(80, 165, 80)
executeButton.BorderColor3 = Color3.fromRGB(25, 25, 25)
executeButton.Font = Enum.Font.SourceSansBold
executeButton.Text = "EXECUTE SCRIPT"
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 18
executeButton.Parent = mainFrame

-- Add a UI corner to the button for rounded edges
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = executeButton

-- Final step: parent the ScreenGui to the player's GUI
screenGui.Parent = PlayerGui


--============================================================================--
-- II. SCRIPT EXECUTION LOGIC
--============================================================================--

-- Handle the button click event
executeButton.MouseButton1Click:Connect(function()
    -- 1. Get the values from the text boxes
    local jamSelesai = tonumber(jamSelesaiBox.Text) or 1
    local webhookUrl = webhookBox.Text
    local orderNum = orderBox.Text
    local storeName = storeNameBox.Text

    -- Basic validation
    if webhookUrl == "" or webhookUrl == "discord webhook here" then
        warn("Webhook URL is empty. Please enter a valid URL.")
        executeButton.Text = "INVALID WEBHOOK URL"
        executeButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        wait(2)
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(80, 165, 80)
        return
    end

    -- 2. Define the remote script URL
    local scriptUrl = "https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/Webhook-Joki-Perjam/Webhook.lua"

    -- 3. Construct the full script
    local scriptToExecute = string.format([[
        -- Injected variables from UI
        local jam_selesai_joki = %s
        local discord_webhook = "%s"
        local no_order = "%s"
        local nama_store = "%s"

        -- Appending remote script content
        %s
    ]], jamSelesai, webhookUrl, orderNum, storeName, game:HttpGet(scriptUrl))

    -- 4. Execute the script using loadstring
    local success, result = pcall(function()
        local loadedFunction = loadstring(scriptToExecute)
        if loadedFunction then
            -- Hide the UI on successful execution
            mainFrame.Visible = false
            -- Run the script
            loadedFunction()
        else
            error("Failed to load the script string. It might be empty or invalid.")
        end
    end)

    if not success then
        warn("Error executing the script:", result)
        executeButton.Text = "EXECUTION FAILED"
        executeButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        wait(2)
        executeButton.Text = "EXECUTE SCRIPT"
        executeButton.BackgroundColor3 = Color3.fromRGB(80, 165, 80)
    end
end)
