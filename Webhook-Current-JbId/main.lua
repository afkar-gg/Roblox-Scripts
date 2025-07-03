if not game:IsLoaded() then game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Roblox Data
local username = player.Name
local placeId = game.PlaceId
local jobId = game.JobId
local tunnelURL = "https://your-proxy.trycloudflare.com" -- 🔁 CHANGE THIS

-- Build join link
local joinLink = ("%s/join?place=%s&job=%s"):format(tunnelURL, placeId, jobId)

-- Load webhook URL from file
local configFile = "jobhook_config.json"
local canSave = writefile and readfile and isfile
local savedWebhook = ""

if canSave and isfile(configFile) then
    local ok, content = pcall(readfile, configFile)
    if ok then
        local decoded = HttpService:JSONDecode(content)
        savedWebhook = decoded.webhook or ""
    end
end

-- Clear previous UI
pcall(function()
    CoreGui:FindFirstChild("JobHookUI"):Destroy()
end)

-- UI Setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "JobHookUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 170)
frame.Position = UDim2.new(0.5, -180, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(85, 85, 105)
frame.BorderSizePixel = 2
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Send Job ID to Webhook"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.TextWrapped = true
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -8, 0, 3)
close.Text = "X"
close.Font = Enum.Font.SourceSansBold
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 14
close.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
close.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9, 0, 0, 30)
box.Position = UDim2.new(0.05, 0, 0, 40)
box.PlaceholderText = "Paste Webhook URL"
box.Text = savedWebhook
box.Font = Enum.Font.SourceSans
box.TextSize = 14
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
box.BorderColor3 = Color3.fromRGB(85, 85, 105)
box.TextWrapped = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

box.FocusLost:Connect(function()
    if canSave then
        pcall(writefile, configFile, HttpService:JSONEncode({ webhook = box.Text }))
    end
end)

local send = Instance.new("TextButton", frame)
send.Size = UDim2.new(0.9, 0, 0, 36)
send.Position = UDim2.new(0.05, 0, 0, 90)
send.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
send.BorderColor3 = Color3.fromRGB(120, 130, 255)
send.Text = "Send Job ID"
send.Font = Enum.Font.SourceSansBold
send.TextColor3 = Color3.new(1, 1, 1)
send.TextSize = 16
Instance.new("UICorner", send).CornerRadius = UDim.new(0, 6)

send.MouseButton1Click:Connect(function()
    local url = box.Text
    if url == "" then
        send.Text = "Missing URL"
        wait(1.5)
        send.Text = "Send Job ID"
        return
    end

    local embed = {
        embeds = {{
            title = "📡 Roblox Job ID",
            description = ("**Username:** `%s`\n🔗 [Join Server](%s)"):format(username, joinLink),
            color = 0x00FFFF
        }}
    }

    local ok = pcall(function()
        (http_request or request or syn and syn.request)({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(embed)
        })
    end)

    send.Text = ok and "✅ Sent!" or "❌ Failed"
    wait(2)
    send.Text = "Send Job ID"
end)