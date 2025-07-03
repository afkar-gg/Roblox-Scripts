-- Roblox Job ID UI Sender to Discord via Proxy Tunnel
if not game:IsLoaded() then game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local placeId, jobId = game.PlaceId, game.JobId
local username = player.Name

-- Saved tunnel config
local configFile = "jobhook_config.json"
local canSave = writefile and readfile and isfile
local tunnel = ""

if canSave and isfile(configFile) then
	local ok, data = pcall(readfile, configFile)
	if ok then
		local decoded = HttpService:JSONDecode(data)
		tunnel = decoded.tunnel or ""
	end
end

-- Cleanup old UI
pcall(function() CoreGui:FindFirstChild("JobHookUI"):Destroy() end)

-- UI Setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "JobHookUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 170)
frame.Position = UDim2.new(0.5, -180, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(85, 85, 105)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Send Job ID via Tunnel"
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
close.MouseButton1Click:Connect(function() gui:Destroy() end)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

-- Tunnel input box
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9, 0, 0, 30)
box.Position = UDim2.new(0.05, 0, 0, 40)
box.PlaceholderText = "Paste your Tunnel URL (e.g. https://abc.trycloudflare.com)"
box.Text = tunnel
box.Font = Enum.Font.SourceSans
box.TextSize = 14
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
box.BorderColor3 = Color3.fromRGB(85, 85, 105)
box.TextWrapped = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

box.FocusLost:Connect(function()
	if canSave then
		pcall(writefile, configFile, HttpService:JSONEncode({ tunnel = box.Text }))
	end
end)

-- Send button
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
	local proxy = box.Text:match("^https?://.+")
	if not proxy then
		send.Text = "❌ Invalid Tunnel"
		wait(2)
		send.Text = "Send Job ID"
		return
	end

	local joinUrl = ("%s/join?place=%s&job=%s"):format(proxy, placeId, jobId)
	local body = {
		username = username,
		placeId = placeId,
		jobId = jobId,
		join_url = joinUrl
	}

	local success = pcall(function()
		http_request({
			Url = proxy .. "/send-job",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(body)
		})
	end)

	send.Text = success and "✅ Sent!" or "❌ Failed"
	wait(2)
	send.Text = "Send Job ID"
end)