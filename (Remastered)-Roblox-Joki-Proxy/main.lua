if not game:IsLoaded() then game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local request = http_request or syn and syn.request or request
if not request then
	warn("❌ This executor doesn't support HTTP requests.")
	return
end

-- Config
local folder = "joki_config"
local file = folder .. "/proxy_url.json"
local canSave = writefile and readfile and isfile and makefolder
if canSave and not isfolder(folder) then pcall(makefolder, folder) end

local savedUrl = ""
if canSave and isfile(file) then
	local ok, result = pcall(readfile, file)
	if ok then
		local data = HttpService:JSONDecode(result)
		savedUrl = data.proxy_url or ""
	end
end

-- Destroy existing UI
pcall(function() CoreGui:FindFirstChild("JokiUI"):Destroy() end)

-- GUI setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "JokiUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 210)
frame.Position = UDim2.new(0.5, -180, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Roblox Joki Panel"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -28, 0, 3)
close.Text = "X"
close.Font = Enum.Font.SourceSansBold
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 14
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local urlBox = Instance.new("TextBox", frame)
urlBox.Size = UDim2.new(0.9, 0, 0, 30)
urlBox.Position = UDim2.new(0.05, 0, 0, 40)
urlBox.PlaceholderText = "Paste Proxy URL (https://...)"
urlBox.Text = savedUrl
urlBox.Font = Enum.Font.SourceSans
urlBox.TextSize = 14
urlBox.TextColor3 = Color3.new(1, 1, 1)
urlBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", urlBox).CornerRadius = UDim.new(0, 4)

urlBox.FocusLost:Connect(function()
	if canSave then
		pcall(writefile, file, HttpService:JSONEncode({ proxy_url = urlBox.Text }))
	end
end)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.9, 0, 0, 20)
status.Position = UDim2.new(0.05, 0, 0, 75)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.new(1, 1, 1)
status.Font = Enum.Font.SourceSans
status.TextSize = 14

local execBtn = Instance.new("TextButton", frame)
execBtn.Size = UDim2.new(0.42, 0, 0, 34)
execBtn.Position = UDim2.new(0.05, 0, 0, 105)
execBtn.Text = "🚀 Send"
execBtn.Font = Enum.Font.SourceSansBold
execBtn.TextColor3 = Color3.new(1, 1, 1)
execBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 6)

local jobBtn = Instance.new("TextButton", frame)
jobBtn.Size = UDim2.new(0.42, 0, 0, 34)
jobBtn.Position = UDim2.new(0.53, 0, 0, 105)
jobBtn.Text = "🧩 Send Job ID"
jobBtn.Font = Enum.Font.SourceSansBold
jobBtn.TextColor3 = Color3.new(1, 1, 1)
jobBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
Instance.new("UICorner", jobBtn).CornerRadius = UDim.new(0, 6)

-- Send Job ID
jobBtn.MouseButton1Click:Connect(function()
	local url = urlBox.Text
	if url == "" then status.Text = "❌ URL missing"; return end

	local body = HttpService:JSONEncode({
		username = player.Name,
		placeId = tostring(game.PlaceId),
		jobId = tostring(game.JobId),
		join_url = url .. "/join?place=" .. game.PlaceId .. "&job=" .. game.JobId
	})

	local ok = pcall(function()
		request({
			Url = url .. "/send-job",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = body
		})
	end)

	status.Text = ok and "✅ Job ID sent!" or "❌ Failed to send Job ID"
end)

-- Send /track and loop /check
execBtn.MouseButton1Click:Connect(function()
	local proxy = urlBox.Text
	if proxy == "" then status.Text = "❌ Missing URL"; return end

	local success, response = pcall(function()
		return request({
			Url = proxy .. "/track",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({ username = player.Name })
		})
	end)

	if not success or response.StatusCode ~= 200 then
		status.Text = "❌ /track failed (" .. (response and response.StatusCode or "?") .. ")"
		return
	end

	local data = HttpService:JSONDecode(response.Body)
	local endTime = tonumber(data.endTime)

	if not endTime then
		status.Text = "❌ No endTime received"
		return
	end

	status.Text = "✅ Session started"

	task.spawn(function()
		while os.time() < math.floor(endTime / 1000) do
			local left = math.floor(endTime / 1000) - os.time()
			status.Text = string.format("⏳ %02d:%02d left", left // 60, left % 60)

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

		pcall(function()
			request({
				Url = proxy .. "/complete",
				Method = "POST",
				Headers = {["Content-Type"] = "application/json"},
				Body = HttpService:JSONEncode({ username = player.Name })
			})
		end)

		status.Text = "✅ Joki completed"
	end)
end)