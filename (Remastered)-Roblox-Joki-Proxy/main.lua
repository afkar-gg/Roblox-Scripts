if not game:IsLoaded() then game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- 🔄 Universal HTTP Support
local request = http_request or syn and syn.request or request or nil
if not request then
	warn("❌ This executor doesn't support HTTP requests.")
	return
end

-- 📁 Save/Load Proxy URL
local folderName = "joki_config"
local configFile = folderName .. "/proxy_url.json"
local canSave = writefile and readfile and isfile and makefolder
if canSave and not isfolder(folderName) then pcall(makefolder, folderName) end

local savedUrl = ""
if canSave and isfile(configFile) then
	local ok, result = pcall(readfile, configFile)
	if ok then
		local data = HttpService:JSONDecode(result)
		savedUrl = data.proxy_url or ""
	end
end

-- 🧼 Clean old UI
pcall(function() CoreGui:FindFirstChild("JokiUI"):Destroy() end)

-- 🧱 Build GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "JokiUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 360, 0, 170)
frame.Position = UDim2.new(0.5, -180, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Roblox Joki Sender"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local urlBox = Instance.new("TextBox", frame)
urlBox.PlaceholderText = "Enter proxy URL"
urlBox.Text = savedUrl
urlBox.Size = UDim2.new(0.9, 0, 0, 30)
urlBox.Position = UDim2.new(0.05, 0, 0, 40)
urlBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
urlBox.TextColor3 = Color3.new(1, 1, 1)
urlBox.Font = Enum.Font.SourceSans
urlBox.TextSize = 14
urlBox.BorderColor3 = Color3.fromRGB(85, 85, 105)
Instance.new("UICorner", urlBox).CornerRadius = UDim.new(0, 4)

urlBox.FocusLost:Connect(function()
	if canSave then
		pcall(writefile, configFile, HttpService:JSONEncode({ proxy_url = urlBox.Text }))
	end
end)

local sendBtn = Instance.new("TextButton", frame)
sendBtn.Size = UDim2.new(0.9, 0, 0, 34)
sendBtn.Position = UDim2.new(0.05, 0, 0, 80)
sendBtn.Text = "🔗 Send Request"
sendBtn.Font = Enum.Font.SourceSansBold
sendBtn.TextSize = 16
sendBtn.TextColor3 = Color3.new(1, 1, 1)
sendBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 6)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.9, 0, 0, 20)
status.Position = UDim2.new(0.05, 0, 0, 125)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.new(1, 1, 1)
status.Font = Enum.Font.SourceSans
status.TextSize = 14

-- 🧠 Logic: On Execute
sendBtn.MouseButton1Click:Connect(function()
	local proxy = urlBox.Text
	if proxy == "" then
		status.Text = "❌ Missing URL"
		return
	end

	-- Send to /track
	local success, response = pcall(function()
		return request({
			Url = proxy .. "/track",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({ username = player.Name })
		})
	end)

	if success and response.StatusCode == 200 then
		local data = HttpService:JSONDecode(response.Body)
		local endTime = math.floor(data.endTime / 1)

		status.Text = "✅ Sent. Session started."
		task.spawn(function()
			while os.time() < endTime do
				local remaining = endTime - os.time()
				local mins = math.floor(remaining / 60)
				local secs = remaining % 60
				status.Text = string.format("⏳ %02d:%02d left", mins, secs)

				pcall(function()
					request({
						Url = proxy .. "/check",
						Method = "POST",
						Headers = {["Content-Type"] = "application/json"},
						Body = HttpService:JSONEncode({ username = player.Name })
					})
				end)

				task.wait(60)
			end

			-- Done
			pcall(function()
				request({
					Url = proxy .. "/complete",
					Method = "POST",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode({ username = player.Name })
				})
			end)
			status.Text = "✅ Joki Completed"
		end)
	else
		status.Text = "❌ Failed to send /track"
	end
end)