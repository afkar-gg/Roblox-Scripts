--!/usr/bin/env luau

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local username = LocalPlayer.Name

local current_time = os.time()

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiInfoUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") -- Or game:GetService("StarterGui") if you want it there initially

-- Create the TextBox
local infoTextBox = Instance.new("TextBox")
infoTextBox.Name = "InfoDisplayTextBox"
infoTextBox.Size = UDim2.new(0.3, 0, 0.2, 0) -- Example size: 30% width, 20% height
infoTextBox.Position = UDim2.new(0.35, 0, 0.1, 0) -- Example position: centered horizontally, a bit down from top
infoTextBox.Text = "Username: " .. username .. "\nCurrent Time: " .. os.date("%Y-%m-%d %H:%M:%S", current_time)
infoTextBox.PlaceholderText = "Joki Information"
infoTextBox.ClearTextOnFocus = false
infoTextBox.MultiLine = true
infoTextBox.TextWrapped = true
infoTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
infoTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
infoTextBox.BorderColor3 = Color3.fromRGB(70, 70, 70)
infoTextBox.BorderSizePixel = 2
infoTextBox.Font = Enum.Font.SourceSansBold
infoTextBox.TextSize = 16
infoTextBox.Parent = screenGui

-- Create the Execute Button
local executeButton = Instance.new("TextButton)
executeButton.Name = "ExecuteWebhookButton"
executeButton.Size = UDim2.new(0.2, 0, 0.05, 0) -- Example size
executeButton.Position = UDim2.new(0.4, 0, 0.35, 0) -- Position below the textbox
executeButton.Text = "Execute Webhook Script"
executeButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.BorderColor3 = Color3.fromRGB(50, 100, 150)
executeButton.BorderSizePixel = 1
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextSize = 18
executeButton.Parent = screenGui

-- Function to execute the external script
local function executeExternalScript()
    local HttpService = game:GetService("HttpService")
    local success, response = pcall(function()
        return HttpService:GetAsync("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki-Perjam/Webhook.lua")
    end)

    if success then
        if response then
            local func, err = loadstring(response)
            if func then
                pcall(func) -- Execute the loaded function
                print("Webhook script executed successfully!")
            else
                warn("Error loading script:", err)
            end
        else
            warn("Failed to get script content from URL.")
        end
    else
        warn("HTTP request failed:", response)
    end
end

-- Connect the button to the execution function
executeButton.MouseButton1Click:Connect(executeExternalScript)

print("UI Script Loaded!")

