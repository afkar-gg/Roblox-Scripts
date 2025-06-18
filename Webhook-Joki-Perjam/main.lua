-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MovableEditableUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame for the UI (this will be draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 320) -- Slightly increased width for better text fit
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -160) -- Recenter with new size
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

-- Toggle Visibility Button ("-")
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 25, 0, 25)
ToggleButton.Position = UDim2.new(1, -35, 0, 5) -- Top-right corner of the frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 20
ToggleButton.Text = "-"
ToggleButton.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible -- Toggle visibility
end)

-- Local Variables (initial values)
local jam_selesai_joki = 1
local webhook_discord = "YOUR_WEBHOOK_URL_HERE" -- **REMEMBER TO REPLACE THIS WITH YOUR ACTUAL WEBHOOK URL**
local no_order = "OD000000141403135"
local nama_store = "AfkarStore"

-- Function to create a label and a textbox pair
local function createInputPair(parent, yOffset, labelText, initialValue)
    local label = Instance.new("TextLabel")
    label.Name = labelText:gsub(" ", "") .. "Label"
    label.Size = UDim2.new(0.35, 0, 0, 25) -- Increased label width slightly
    label.Position = UDim2.new(0, 10, 0, yOffset)
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = labelText .. ":"
    label.Parent = parent

    local textBox = Instance.new("TextBox")
    textBox.Name = labelText:gsub(" ", "") .. "Input"
    textBox.Size = UDim2.new(0.60, -20, 0, 25) -- Adjusted size to fit within frame with padding
    textBox.Position = UDim2.new(0.35, 10, 0, yOffset) -- Aligned with label, adjusted offset
    textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 14
    textBox.Text = tostring(initialValue)
    textBox.ClearTextOnFocus = false
    textBox.TextWrapped = true -- IMPORTANT: Wrap text if it's too long for the box
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
SaveButton.Position = UDim2.new(0, 10, 0, 190)
SaveButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.Font = Enum.Font.SourceSansBold
SaveButton.TextSize = 18
SaveButton.Text = "Save Changes"
SaveButton.Parent = MainFrame

-- Event for the Save Changes button
-- In your UI Script (LocalScript in StarterPlayerScripts)
-- Only the ExecuteButton.MouseButton1Click part is shown, the rest of your UI script stays the same.

-- ... (your existing UI setup code above this) ...

-- Button to execute the loadstring code
-- ... (ExecuteButton creation code) ...

ExecuteButton.MouseButton1Click:Connect(function()
    print("UI Script: Button clicked. Starting webhook execution process.") -- Debug 1: Confirm button click

    local loaded_script_content = nil
    local get_http_success, get_http_result = pcall(function()
        -- Attempt to download the script content from the URL
        return game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki-Perjam/Webhook.lua")
    end)

    if not get_http_success then
        -- Debug 2: HttpGet failed
        warn("UI Script: ERROR! Failed to download webhook script content via HttpGet. Error:", get_http_result)
        warn("UI Script: Please ensure 'Allow HTTP Requests' is enabled in Game Settings > Security.")
        return -- Stop execution if download fails
    end

    loaded_script_content = get_http_result
    print("UI Script: Script content downloaded successfully. Length:", #loaded_script_content, "bytes.") -- Debug 3: HttpGet success

    if #loaded_script_content == 0 then
        warn("UI Script: WARNING! Downloaded script content is empty. Cannot proceed.")
        return
    end

    -- Now try to loadstring the content
    local success, script_chunk_func = pcall(function()
        return loadstring(loaded_script_content)
    end)

    if not success then
        -- Debug 4: loadstring failed
        warn("UI Script: ERROR! Failed to loadstring the script content. Error:", script_chunk_func)
        warn("UI Script: This usually means the downloaded script has a syntax error.")
        return -- Stop execution if loadstring fails
    end

    if type(script_chunk_func) == "function" then
        print("UI Script: Script chunk loaded successfully. Attempting to execute it.") -- Debug 5: loadstring success

        local exec_success, exec_result = pcall(function()
            -- This calls the loaded chunk, which should return the main function
            return script_chunk_func()
        end)

        if exec_success and type(exec_result) == "function" then
            local webhook_executor = exec_result
            print("UI Script: Webhook executor function obtained. Calling it with UI data.") -- Debug 6: Executor obtained

            local final_call_success, final_call_result = pcall(function()
                -- Pass the current values of your UI variables to the loaded script's function
                webhook_executor(webhook_discord, jam_selesai_joki, no_order, nama_store)
            end)

            if final_call_success then
                print("UI Script: Webhook script execution completed. (Check Webhook.lua prints for send status)") -- Debug 7: Final call success
            else
                warn("UI Script: ERROR! An error occurred during the execution of the webhook_executor function itself. Error:", final_call_result) -- Debug 8: Error in webhook_executor
            end
        else
            warn("UI Script: ERROR! The loaded script did not return a function as expected. Type:", type(exec_result), "Value:", exec_result) -- Debug 9: Returned wrong type
            warn("UI Script: Please ensure Webhook.lua starts with `return function(...) ... end`.")
        end
    else
        warn("UI Script: ERROR! `loadstring` did not return a function. Type:", type(script_chunk_func), "Value:", script_chunk_func) -- Debug 10: loadstring returned non-function
        warn("UI Script: This is unexpected if loadstring didn't error. Check console for previous `loadstring` errors.")
    end
    print("UI Script: End of button click logic.") -- Debug 11: End of script
end)


-- Button to execute the loadstring code
local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Name = "ExecuteButton"
ExecuteButton.Size = UDim2.new(1, -20, 0, 40)
ExecuteButton.Position = UDim2.new(0, 10, 0, 240)
ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.Font = Enum.Font.SourceSansBold
ExecuteButton.TextSize = 18
ExecuteButton.Text = "Execute Webhook Script"
ExecuteButton.Parent = MainFrame

-- Event for the button click
ExecuteButton.MouseButton1Click:Connect(function()
    warn("Executing loadstring code...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki-Perjam/Webhook.lua"))();
    print("Loadstring executed!")
end)

print("Movable Editable UI loaded successfully!")
