if not game:IsLoaded() then game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Config
local configFile = "joki_proxy_config.json"
local canSave = (writefile and readfile and isfile)

local saved = {
	jam_selesai_joki = "1",
	no_order = "",
	nama_store = "",
	proxy_url = ""
}

if canSave and isfile(configFile) then
	local ok, content = pcall(readfile, configFile)
	if ok then
		local success, data = pcall(function()
			return HttpService:JSONDecode(content)
		end)
		if success and typeof(data) == "table" then
			for k, v in pairs(data) do
				if saved[k] ~= nil then
					saved[k] = tostring(v)
				end
			end
		end
	end
end

-- UI Setup
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "JokiWebhookUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 360)
frame.Position = UDim2.new(0.5, -200, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Discord Bot Joki Configuration"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -30, 0, 3)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 14
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function makeInput(labelText, placeholder, default)
	local container = Instance.new("Frame", content)
	container.Size = UDim2.new(0.9, 0, 0, 50)
	container.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Text = labelText
	label.TextSize = 14
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1

	local box = Instance.new("TextBox", container)
	box.Position = UDim2.new(0, 0, 0, 20)
	box.Size = UDim2.new(1, 0, 0, 30)
	box.Text = default or ""
	box.PlaceholderText = placeholder
	box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	box.TextColor3 = Color3.new(1,1,1)
	box.ClearTextOnFocus = false
	box.TextWrapped = true
	box.Font = Enum.Font.SourceSans
	box.TextSize = 14
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	return box
end

local jamBox = makeInput("jam_selesai_joki", "e.g., 1", saved.jam_selesai_joki)
local orderBox = makeInput("no_order", "e.g., OD123456", saved.no_order)
local storeBox = makeInput("nama_store", "e.g., AfkarStore", saved.nama_store)
local urlBox = makeInput("proxy_url", "https://yourproxy.trycloudflare.com", saved.proxy_url)

local function save()
	if not canSave then return end
	local config = {
		jam_selesai_joki = jamBox.Text,
		no_order = orderBox.Text,
		nama_store = storeBox.Text,
		proxy_url = urlBox.Text
	}
	local ok, json = pcall(function()
		return HttpService:JSONEncode(config)
	end)
	if ok then pcall(writefile, configFile, json) end
end

for _, box in ipairs({jamBox, orderBox, storeBox, urlBox}) do
	box.FocusLost:Connect(save)
end

local executeBtn = Instance.new("TextButton", content)
executeBtn.Size = UDim2.new(0.9, 0, 0, 40)
executeBtn.Text = "EXECUTE SCRIPT"
executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeBtn.TextColor3 = Color3.new(1, 1, 1)
executeBtn.TextSize = 18
executeBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", executeBtn).CornerRadius = UDim.new(0, 6)
executeBtn.Parent = content

executeBtn.MouseButton1Click:Connect(function()
	local jam = tonumber(jamBox.Text)
	local order = orderBox.Text
	local store = storeBox.Text
	local baseUrl = urlBox.Text
	local username = LocalPlayer.Name

	if not jam or order == "" or store == "" or baseUrl == "" then
		executeBtn.Text = "FILL ALL FIELDS"
		executeBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
		task.wait(2)
		executeBtn.Text = "EXECUTE SCRIPT"
		executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		return
	end

	local req = http_request or request or syn and syn.request
	if not req then
		warn("❌ Executor does not support HTTP requests.")
		return
	end

	-- Send embed (/send)
	pcall(function()
		req({
			Url = baseUrl .. "/send",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({
				username = username,
				jam_selesai_joki = jam,
				no_order = order,
				nama_store = store
			})
		})
	end)

	-- Send plain message (/check)
	pcall(function()
		req({
			Url = baseUrl .. "/check",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({
				username = username
			})
		})
	end)

	-- 🔁 Loop /check every 5 mins
	task.spawn(function()
		while true do
			pcall(function()
				req({
					Url = baseUrl .. "/check",
					Method = "POST",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode({
						username = username
					})
				})
			end)
			task.wait(300)
		end
	end)

	-- ⏰ After joki ends, send /complete
	task.spawn(function()
		task.wait(jam * 3600)
		pcall(function()
			req({
				Url = baseUrl .. "/complete",
				Method = "POST",
				Headers = {["Content-Type"] = "application/json"},
				Body = HttpService:JSONEncode({
					username = username,
					no_order = order,
					nama_store = store
				})
			})
			print("✅ Sent JOKI COMPLETED")
		end)
	end)

	executeBtn.Text = "✅ STARTED + TIMER"
	executeBtn.BackgroundColor3 = Color3.fromRGB(87, 242, 135)
	task.wait(2)
	executeBtn.Text = "EXECUTE SCRIPT"
	executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)