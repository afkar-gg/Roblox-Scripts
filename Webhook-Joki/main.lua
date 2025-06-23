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
	channel_id = "",
	proxy_url = ""
}

-- Load Config
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
local chanBox = makeInput("channel_id", "Discord Channel ID", saved.channel_id)
local urlBox = makeInput("proxy_url", "https://xxxx.trycloudflare.com/send", saved.proxy_url)

-- Save config on change
local function save()
	if not canSave then return end
	local config = {
		jam_selesai_joki = jamBox.Text,
		no_order = orderBox.Text,
		nama_store = storeBox.Text,
		channel_id = chanBox.Text,
		proxy_url = urlBox.Text
	}
	local ok, json = pcall(function()
		return HttpService:JSONEncode(config)
	end)
	if ok then pcall(writefile, configFile, json) end
end

for _, box in ipairs({jamBox, orderBox, storeBox, chanBox, urlBox}) do
	box.FocusLost:Connect(save)
end

-- Execute Button
local exec = Instance.new("TextButton", content)
exec.Size = UDim2.new(0.9, 0, 0, 40)
exec.Text = "EXECUTE SCRIPT"
exec.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
exec.TextColor3 = Color3.new(1, 1, 1)
exec.TextSize = 18
exec.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", exec).CornerRadius = UDim.new(0, 6)
exec.Parent = content

exec.MouseButton1Click:Connect(function()
	local jam = tonumber(jamBox.Text)
	local order = orderBox.Text
	local store = storeBox.Text
	local channel = chanBox.Text
	local url = urlBox.Text
	local username = LocalPlayer.Name

	if not jam or order == "" or store == "" or channel == "" or url == "" then
		exec.Text = "FILL ALL FIELDS"
		exec.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
		task.wait(2)
		exec.Text = "EXECUTE SCRIPT"
		exec.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		return
	end

	-- Send POST request to proxy
	local data = {
		jam_selesai_joki = jam,
		no_order = order,
		nama_store = store,
		channel_id = channel,
		username = username
	}

	local encoded = HttpService:JSONEncode(data)
	local req = (http_request or request or syn and syn.request)

	if not req then
		warn("❌ Executor does not support http requests.")
		exec.Text = "HTTP ERROR"
		exec.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
		return
	end

	local res = req({
		Url = url,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = encoded
	})

	exec.Text = "SENT"
	task.wait(2)
	exec.Text = "EXECUTE SCRIPT"
end)