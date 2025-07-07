if not game:IsLoaded() then game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local saveDir = "joki_config"
local configPath = saveDir .. "/proxy_url.json"
local canSave = writefile and readfile and isfile and makefolder

if canSave and not isfolder(saveDir) then pcall(makefolder, saveDir) end

-- Load saved proxy
local savedUrl = ""
if canSave and isfile(configPath) then
	local ok, data = pcall(readfile, configPath)
	if ok then
		local decoded = HttpService:JSONDecode(data)
		savedUrl = decoded.proxy_url or ""
	end
end

-- Destroy old UI
pcall(function() CoreGui:FindFirstChild("JokiMinimalUI"):Destroy() end)

-- Create GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "JokiMinimalUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(85, 85, 105)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9, 0, 0, 30)
box.Position = UDim2.new(0.05, 0, 0, 10)
box.PlaceholderText = "Enter Proxy URL"
box.Text = savedUrl
box.Font = Enum.Font.SourceSans
box.TextSize = 14
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
box.BorderColor3 = Color3.fromRGB(85, 85, 105)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14

local execBtn = Instance.new("TextButton", frame)
execBtn.Size = UDim2.new(0.42, 0, 0, 30)
execBtn.Position = UDim2.new(0.05, 0, 0, 75)
execBtn.Text = "EXECUTE"
execBtn.Font = Enum.Font.SourceSansBold
execBtn.TextColor3 = Color3.new(1, 1, 1)
execBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 6)

local jobBtn = Instance.new("TextButton", frame)
jobBtn.Size = UDim2.new(0.42, 0, 0, 30)
jobBtn.Position = UDim2.new(0.53, 0, 0, 75)
jobBtn.Text = "SEND JOB ID"
jobBtn.Font = Enum.Font.SourceSansBold
jobBtn.TextColor3 = Color3.new(1, 1, 1)
jobBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
Instance.new("UICorner", jobBtn).CornerRadius = UDim.new(0, 6)

-- ✅ Save proxy URL when changed
box.FocusLost:Connect(function()
	if canSave then
		local toSave = HttpService:JSONEncode({ proxy_url = box.Text })
		pcall(writefile, configPath, toSave)
	end
end)

-- 🟢 EXECUTE SESSION
execBtn.MouseButton1Click:Connect(function()
	local proxyUrl = box.Text
	if proxyUrl == "" then
		execBtn.Text = "MISSING URL"
		wait(1.5)
		execBtn.Text = "EXECUTE"
		return
	end

	local success, result = pcall(function()
		return http_request({
			Url = proxyUrl .. "/track",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({ username = player.Name })
		})
	end)

	if success then
		local data = HttpService:JSONDecode(result.Body)
		local endTime = math.floor((data.endTime or (os.time() + 3600)) / 1)

		task.spawn(function()
			while os.time() < endTime do
				local remain = endTime - os.time()
				local mins = math.floor(remain / 60)
				local secs = remain % 60
				statusLabel.Text = string.format("⏳ %02d:%02d remaining", mins, secs)

				pcall(function()
					http_request({
						Url = proxyUrl .. "/check",
						Method = "POST",
						Headers = {["Content-Type"] = "application/json"},
						Body = HttpService:JSONEncode({ username = player.Name })
					})
				end)

				task.wait(60)
			end

			-- Complete
			pcall(function()
				http_request({
					Url = proxyUrl .. "/complete",
					Method = "POST",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode({ username = player.Name })
				})
			end)

			statusLabel.Text = "✅ Completed."
		end)
	else
		statusLabel.Text = "❌ Failed to start"
	end
end)

-- 🧩 SEND JOB ID
jobBtn.MouseButton1Click:Connect(function()
	local proxyUrl = box.Text
	if proxyUrl == "" then
		jobBtn.Text = "MISSING URL"
		wait(1.5)
		jobBtn.Text = "SEND JOB ID"
		return
	end

	local body = HttpService:JSONEncode({
		username = player.Name,
		placeId = tostring(game.PlaceId),
		jobId = tostring(game.JobId),
		join_url = proxyUrl .. "/join?place=" .. game.PlaceId .. "&job=" .. game.JobId
	})

	local success = pcall(function()
		http_request({
			Url = proxyUrl .. "/send-job",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = body
		})
	end)

	jobBtn.Text = success and "✅ Sent" or "❌ Failed"
	wait(2)
	jobBtn.Text = "SEND JOB ID"
end)