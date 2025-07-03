if not game:IsLoaded() then game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local configFile = "jobhook_config.json"
local canUseFile = (writefile and readfile and isfile) and true or false

-- Load saved webhook
local savedWebhook = ""
if canUseFile and isfile(configFile) then
	local ok, result = pcall(readfile, configFile)
	if ok then
		local decoded = HttpService:JSONDecode(result)
		if typeof(decoded) == "table" and decoded.webhook then
			savedWebhook = decoded.webhook
		end
	end
end

-- === UI ===
pcall(function()
	game:GetService("CoreGui"):FindFirstChild("JobSenderUI"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "JobSenderUI"
gui.Parent = game:GetService("CoreGui")
gui.Enabled = true

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 160)
frame.Position = UDim2.new(0.5, -180, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(85, 85, 105)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
title.BorderColor3 = Color3.fromRGB(80, 80, 100)
title.BorderSizePixel = 1
title.Font = Enum.Font.SourceSansBold
title.Text = "Send Roblox Job ID to Discord"
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)

local close = Instance.new("TextButton", title)
close.Size = UDim2.new(0, 22, 0, 22)
close.Position = UDim2.new(1, -6, 0, 4)
close.AnchorPoint = Vector2.new(1, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
close.Font = Enum.Font.SourceSansBold
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 14
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 5)

-- Webhook Input
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9, 0, 0, 30)
box.Position = UDim2.new(0.05, 0, 0, 50)
box.PlaceholderText = "Paste Discord Webhook"
box.Text = savedWebhook
box.Font = Enum.Font.SourceSans
box.TextSize = 14
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
box.BorderColor3 = Color3.fromRGB(85, 85, 105)
box.ClearTextOnFocus = false
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

box.FocusLost:Connect(function()
	if canUseFile then
		local newData = HttpService:JSONEncode({ webhook = box.Text })
		pcall(writefile, configFile, newData)
	end
end)

-- Send Button
local send = Instance.new("TextButton", frame)
send.Size = UDim2.new(0.9, 0, 0, 36)
send.Position = UDim2.new(0.05, 0, 0, 100)
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
		send.Text = "NO URL"
		send.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
		wait(2)
		send.Text = "Send Job ID"
		send.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		return
	end

	local job = game.JobId
	local place = game.PlaceId
	local link = string.format("https://www.roblox.com/games/%s?jobId=%s", place, job)

	local data = {
		embeds = {{
			title = "🛰️ Roblox Job ID",
			description = string.format("**Job ID:** `%s`\n🔗 [Join Game](%s)", job, link),
			color = 0x00FFFF
		}}
	}

	local ok, err = pcall(function()
		http_request({
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(data)
		})
	end)

	if ok then
		send.Text = "✅ Sent!"
	else
		send.Text = "❌ Failed"
	end

	wait(2)
	send.Text = "Send Job ID"
end)