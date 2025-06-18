--!strict

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JokiConfigUI"
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "ConfigFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150) -- Center the frame
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true -- Make the frame draggable
MainFrame.Parent = ScreenGui

-- Add UICorner for rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Add UIListLayout for easy arrangement
local ListLayout = Instance.new("UIListLayout")
ListLayout.FillDirection = Enum.FillDirection.Vertical
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 10)
ListLayout.Parent = MainFrame

-- Function to create a labeled textbox
local function createLabeledTextbox(parent, name, initialValue, placeholderText)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 0, 50) -- Adjusted size
    Container.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Container.BorderSizePixel = 0
    Container.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Container

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = name .. ":"
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansBold
    Label.TextScaled = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Parent = Container

    local TextBox = Instance.new("TextBox")
    TextBox.Name = name
    TextBox.Size = UDim2.new(1, -20, 0, 25)
    TextBox.Position = UDim2.new(0, 10, 0, 25)
    TextBox.Text = tostring(initialValue) or ""
    TextBox.PlaceholderText = placeholderText or ""
    TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    TextBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.BorderSizePixel = 0
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 14
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = Container

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = TextBox

    return TextBox
end

-- Create TextBoxes for variables
local jamSelesaiJokiTextBox = createLabeledTextbox(MainFrame, "Jam Selesai Joki", 1, "Enter hours for joki completion")
local discordWebhookTextBox = createLabeledTextbox(MainFrame, "Discord Webhook", "discord webhook here", "Enter your Discord webhook URL")
local noOrderTextBox = createLabeledTextbox(MainFrame, "No Order", "OD000000141403135", "Enter the order number")
local namaStoreTextBox = createLabeledTextbox(MainFrame, "Nama Store", "AfkarStore", "Enter your store name")

-- Create Execute Button
local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Name = "ExecuteButton"
ExecuteButton.Size = UDim2.new(1, -20, 0, 40)
ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.Text = "Execute Joki Script"
ExecuteButton.Font = Enum.Font.SourceSansBold
ExecuteButton.TextSize = 18
ExecuteButton.BorderSizePixel = 0
ExecuteButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ExecuteButton

-- Variable to hold the loaded function
local loadedScriptFunction = nil

-- Function to fetch and execute the external script
local function executeExternalScript()
    local url = "[https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki-Perjam/Webhook.lua](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki-Perjam/Webhook.lua)"

    -- Get values from textboxes
    local jam_selesai_joki_val = tonumber(jamSelesaiJokiTextBox.Text) or 1
    local discord_webhook_val = discordWebhookTextBox.Text
    local no_order_val = noOrderTextBox.Text
    local nama_store_val = namaStoreTextBox.Text

    if not discord_webhook_val or string.len(discord_webhook_val) < 10 then -- Basic validation
        warn("Discord Webhook URL is missing or invalid!")
        return
    end

    if not loadedScriptFunction then
        print("Fetching and loading external script...")
        local success, result = pcall(function()
            return HttpService:GetAsync(url)
        end)

        if success then
            local scriptCode = result
            if scriptCode then
                -- Load the code as a function
                local loadSuccess, func = pcall(loadstring, scriptCode, "WebhookScript")
                if loadSuccess and typeof(func) == "function" then
                    loadedScriptFunction = func
                    print("Script loaded successfully!")
                else
                    warn("Failed to load script: " .. (func or "Unknown error"))
                    return
                end
            else
                warn("Failed to fetch script code: Empty response.")
                return
            end
        else
            warn("Error fetching script: " .. result)
            return
        end
    end

    if loadedScriptFunction then
        print("Executing script with provided parameters...")
        local execSuccess, execResult = pcall(loadedScriptFunction,
            jam_selesai_joki_val,
            discord_webhook_val,
            no_order_val,
            nama_store_val
        )
        if execSuccess then
            print("Script executed successfully!")
        else
            warn("Error executing script: " .. tostring(execResult))
        end
    end
end

-- Connect button click to function
ExecuteButton.MouseButton1Click:Connect(executeExternalScript)

-- You might want to add a close button or a way to toggle the UI
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.BorderSizePixel = 0
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Make the frame draggable (basic implementation)
local dragging
local dragInput
local dragStart
local startPosition

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("UI Script Loaded: JokiConfigUI ready.")
