if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then return end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ==== CONFIG ====
local configFile = "joki_config.json"
local canUseFile = (writefile and readfile and isfile) and true or false
local savedConfig = {
	jam_selesai_joki = "1",
	no_order = "",
	nama_store = "",
	proxy_url = ""
}

if canUseFile and isfile(configFile) then
	local ok, json = pcall(readfile, configFile)
	if ok then
		local decoded = HttpService:JSONDecode(json)
		for k, v in pairs(decoded) do
			savedConfig[k] = tostring(v)
		end
	end
end

-- ==== GUI ====
pcall(function() game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI"):Destroy() end)

local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "JokiWebhookUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 350)
frame.Position = UDim2.new(0.5, -200, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(85, 85, 105)
frame.BorderSizePixel = 2
frame.Draggable = true
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderColor3 = Color3.fromRGB(85, 85, 105)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.fromScale(1, 1)
titleLabel.Position = UDim2.fromScale(0.5, 0.5)
titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Webhook Joki Configuration"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 16

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -6, 0, 3)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 14
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

closeButton.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

Instance.new("UIPadding", content).PaddingTop = UDim.new(0, 10)

local function makeInput(name, placeholder, order, defaultValue)
	local container = Instance.new("Frame", content)
	container.Size = UDim2.new(0.9, 0, 0, 50)
	container.BackgroundTransparency = 1
	container.LayoutOrder = order

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.SourceSans
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left

	local box = Instance.new("TextBox", container)
	box.Size = UDim2.new(1, 0, 0, 30)
	box.Position = UDim2.new(0, 0, 0, 20)
	box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	box.BorderColor3 = Color3.fromRGB(85, 85, 105)
	box.Text = defaultValue or ""
	box.PlaceholderText = placeholder
	box.Font = Enum.Font.SourceSans
	box.TextColor3 = Color3.new(1, 1, 1)
	box.TextSize = 14
	box.ClearTextOnFocus = false
	box.TextWrapped = true
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	return box
end

local jamBox = makeInput("jam_selesai_joki", "e.g., 1", 1, savedConfig.jam_selesai_joki)
local orderBox = makeInput("no_order", "e.g., OD000001", 2, savedConfig.no_order)
local storeBox = makeInput("nama_store", "e.g., AfkarStore", 3, savedConfig.nama_store)
local urlBox = makeInput("proxy_url", "e.g., https://your.proxy/send", 4, savedConfig.proxy_url)

local function save()
	if not canUseFile then return end
	local data = {
		jam_selesai_joki = jamBox.Text,
		no_order = orderBox.Text,
		nama_store = storeBox.Text,
		proxy_url = urlBox.Text
	}
	local ok, result = pcall(function()
		return HttpService:JSONEncode(data)
	end)
	if ok then pcall(writefile, configFile, result) end
end

jamBox.FocusLost:Connect(save)
orderBox.FocusLost:Connect(save)
storeBox.FocusLost:Connect(save)
urlBox.FocusLost:Connect(save)

-- ==== Execute Button ====
local executeBtn = Instance.new("TextButton", content)
executeBtn.Size = UDim2.new(0.9, 0, 0, 40)
executeBtn.Text = "EXECUTE SCRIPT"
executeBtn.Font = Enum.Font.SourceSansBold
executeBtn.TextColor3 = Color3.new(1, 1, 1)
executeBtn.TextSize = 18
executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeBtn.BorderColor3 = Color3.fromRGB(120, 130, 255)
Instance.new("UICorner", executeBtn).CornerRadius = UDim.new(0, 6)

-- Countdown label
local countdownLabel = Instance.new("TextLabel", content)
countdownLabel.Size = UDim2.new(0.9, 0, 0, 20)
countdownLabel.Text = ""
countdownLabel.TextColor3 = Color3.new(1, 1, 1)
countdownLabel.Font = Enum.Font.SourceSans
countdownLabel.TextSize = 14
countdownLabel.BackgroundTransparency = 1
countdownLabel.LayoutOrder = 6

-- ==== Execute Logic ====
executeBtn.MouseButton1Click:Connect(function()
	local jam = tonumber(jamBox.Text) or 1
	local order = orderBox.Text
	local store = storeBox.Text ~= "" and storeBox.Text or "AfkarStore"
	local url = urlBox.Text ~= "" and urlBox.Text or "https://loremipsum.com"
	local fullURL = url .. "/send"

	if order == "" then
		executeBtn.Text = "FILL ALL FIELDS"
		executeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		wait(2)
		executeBtn.Text = "EXECUTE SCRIPT"
		executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		return
	end

	local payload = HttpService:JSONEncode({
		username = player.Name,
		jam_selesai_joki = jam,
		no_order = order,
		nama_store = store
	})

	pcall(function()
		http_request({
			Url = fullURL,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = payload
		})
	end)

	local endTime = os.time() + jam * 3600
	task.spawn(function()
		while os.time() < endTime do
			local left = endTime - os.time()
			local mins = math.floor(left / 60)
			local secs = left % 60
			countdownLabel.Text = string.format("⏳ Time left: %02d:%02d", mins, secs)

			pcall(function()
				http_request({
					Url = url .. "/check",
					Method = "POST",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode({ username = player.Name })
				})
			end)

			task.wait(60)
		end

		-- Auto-complete
		http_request({
			Url = url .. "/complete",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({
				username = player.Name,
				no_order = order,
				nama_store = store
			})
		})
		countdownLabel.Text = "✅ Completed."
	end)
end)

-- Disconnection ping to /cancel
local function sendCancel()
	pcall(function()
		local url = urlBox.Text ~= "" and urlBox.Text or "https://loremipsum.com"
		http_request({
			Url = url .. "/cancel",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({ username = player.Name })
		})
	end)
end

player.OnTeleport:Connect(sendCancel)
player.AncestryChanged:Connect(function()
	if not player:IsDescendantOf(game) then sendCancel() end
end)
RunService.Stepped:Connect(function()
	if not player or not player.Parent then sendCancel() end
end)