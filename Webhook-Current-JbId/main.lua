if not game:IsLoaded() then game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === Save/Load Config ===
local configFile = "jobhook_config.json"
local canUseFile = (writefile and readfile and isfile) and true or false

local savedURL = ""
if canUseFile and isfile(configFile) then
	local ok, data = pcall(readfile, configFile)
	if ok then
		local decoded = HttpService:JSONDecode(data)
		if typeof(decoded) == "table" and decoded.webhook then
			savedURL = decoded.webhook
		end
	end
end

-- === Clean Existing GUI ===
pcall(function()
	game:GetService("CoreGui"):FindFirstChild("JobSenderUI"):Destroy()
end)

-- === GUI Setup ===
local gui = Instance.new("ScreenGui")
gui.Name = "JobSenderUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = game:GetService("CoreGui")
gui.Enabled = true

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 160)
frame.Position = UDim2.new(0.5, -180, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(88, 88, 100)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
title.BorderColor3 = Color3.fromRGB(80, 80, 100)
title.BorderSizePixel = 1
title.Font = Enum.Font.SourceSansBold
title.Text = "Send Job ID to Webhook"
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 22, 0, 22)
close.Position = UDim2.new(1, -6, 0, 4)
close.AnchorPoint = Vector2.new(1, 0)
close.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
close.Text = "X"
close.Font = Enum.Font.SourceSansBold
close.TextSize = 14
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = title

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

-- Webhook Box
local box = Instance.new("TextBox")
box.Size = UDim2.new(0.9, 0, 0, 30)
box.Position = UDim2.new(0.05, 0, 0, 50)
box.PlaceholderText = "Paste Webhook URL"
box.Text = savedURL or ""
box.Font = Enum.Font.SourceSans
box.TextSize = 14
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
box.BorderColor3 = Color3.fromRGB(85, 85, 105)
box.ClearTextOnFocus = false
box.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 4)
boxCorner.Parent = box

-- Save on FocusLost
box.FocusLost:Connect(function()
	if canUseFile then
		local url = box.Text
		local encoded = HttpService:JSONEncode({ webhook = url })
		pcall(writefile, configFile, encoded)
	end
end)

-- Send Button
local send = Instance.new("TextButton")
send.Size = UDim2.new(0.9, 0, 0, 36)
send.Position = UDim2.new(0.05, 0, 0, 100)
send.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
send.BorderColor3 = Color3.fromRGB(120, 130, 255)
send.Text = "Send Job ID"
send.Font = Enum.Font.SourceSansBold
send.TextColor3 = Color3.new(1, 1, 1)
send.TextSize = 16
send.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = send

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
			title = "📡 Roblox Job ID",
			description = string.format("**Job ID:** `%s`\n🔗 [Join Server](%s)", job, link),
			color = 0x00FFFF
		}}
	}

	local body = HttpService:JSONEncode(data)

	local success, result = pcall(function()
		return http_request({
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = body
		})
	end)

	if success then
		send.Text = "✅ Sent!"
	else
		send.Text = "❌ Failed"
	end

	wait(2)
	send.Text = "Send Job ID"
end)
