if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then return end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local username = Players.LocalPlayer.Name

local configFile = "joki_config.json"
local canUseFile = (readfile and writefile and isfile)

local savedConfig = {
	jam_selesai_joki = "1",
	proxy_url = "",
	channel_id = "",
	no_order = "",
	nama_store = ""
}

-- Load config
if canUseFile and isfile(configFile) then
	local ok, content = pcall(readfile, configFile)
	if ok then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(content)
		end)
		if success and typeof(decoded) == "table" then
			for k, v in pairs(decoded) do
				if savedConfig[k] ~= nil then
					savedConfig[k] = tostring(v)
				end
			end
		end
	end
end

-- Destroy old UI
pcall(function()
	game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI"):Destroy()
end)

local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "JokiWebhookUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 400)
frame.Position = UDim2.new(0.5, -200, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(85, 85, 105)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
title.BorderColor3 = Color3.fromRGB(85, 85, 105)
title.BorderSizePixel = 1
title.Font = Enum.Font.SourceSansBold
title.Text = "Joki Discord Bot Configuration"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Center

local closeBtn = Instance.new("TextButton", title)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -6, 0, 3)
closeBtn.AnchorPoint = Vector2.new(1, 0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function makeInput(labelText, placeholder, order, default)
	local container = Instance.new("Frame", content)
	container.Size = UDim2.new(0.9, 0, 0, 50)
	container.BackgroundTransparency = 1
	container.LayoutOrder = order

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.TextSize = 14

	local box = Instance.new("TextBox", container)
	box.Size = UDim2.new(1, 0, 0, 30)
	box.Position = UDim2.new(0, 0, 0, 20)
	box.PlaceholderText = placeholder
	box.Text = default or ""
	box.Font = Enum.Font.SourceSans
	box.TextColor3 = Color3.new(1,1,1)
	box.TextSize = 14
	box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	box.BorderColor3 = Color3.fromRGB(85, 85, 105)
	box.BorderSizePixel = 1
	box.TextWrapped = true
	box.ClearTextOnFocus = false
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	return box
end

local jamBox = makeInput("jam_selesai_joki", "e.g., 1", 1, savedConfig.jam_selesai_joki)
local proxyBox = makeInput("proxy_url", "Cloudflare Proxy URL", 2, savedConfig.proxy_url)
local chanBox = makeInput("channel_id", "Discord Channel ID", 3, savedConfig.channel_id)
local orderBox = makeInput("no_order", "e.g., OD000000141234567", 4, savedConfig.no_order)
local storeBox = makeInput("nama_store", "e.g., AfkarStore", 5, savedConfig.nama_store)

local function saveConfig()
	if not canUseFile then return end
	local data = {
		jam_selesai_joki = jamBox.Text,
		proxy_url = proxyBox.Text,
		channel_id = chanBox.Text,
		no_order = orderBox.Text,
		nama_store = storeBox.Text
	}
	local ok, json = pcall(function()
		return HttpService:JSONEncode(data)
	end)
	if ok then pcall(writefile, configFile, json) end
end

for _, box in ipairs({jamBox, proxyBox, chanBox, orderBox, storeBox}) do
	box.FocusLost:Connect(saveConfig)
end

local execBtn = Instance.new("TextButton", content)
execBtn.Size = UDim2.new(0.9, 0, 0, 40)
execBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
execBtn.BorderColor3 = Color3.fromRGB(120, 130, 255)
execBtn.BorderSizePixel = 1
execBtn.Text = "EXECUTE SCRIPT"
execBtn.Font = Enum.Font.SourceSansBold
execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
execBtn.TextSize = 18
execBtn.LayoutOrder = 6
Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 6)

execBtn.MouseButton1Click:Connect(function()
	local jam = tonumber(jamBox.Text)
	local proxy = proxyBox.Text
	local channel = chanBox.Text
	local order = orderBox.Text
	local store = storeBox.Text

	if not jam or proxy == "" or order == "" or store == "" or channel == "" then
		execBtn.Text = "FILL ALL FIELDS"
		execBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
		wait(2)
		execBtn.Text = "EXECUTE SCRIPT"
		execBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		return
	end

	local embedPayload = {
		channel_id = channel,
		username = username,
		embeds = {{
			title = "JOKI STARTED",
			description = "Username: " .. username,
			color = 65280,
			fields = {{
				name = "Info Joki",
				value = "Nomor Order : " .. order .. "\nLink Pesanan : [Link Pesanan](https://tokoku.itemku.com/riwayat-pesanan/rincian/" .. string.sub(order, 9) .. ")"
			}, {
				name = "Time",
				value = "Start: <t:" .. os.time() .. ":f>\nEnd: <t:" .. (os.time() + jam * 3600) .. ":f>"
			}},
			footer = { text = "- " .. store .. " ❤️" }
		}}
	}

	local ok, result = pcall(function()
		return HttpService:PostAsync(proxy, HttpService:JSONEncode(embedPayload), Enum.HttpContentType.ApplicationJson)
	end)

	print("[DEBUG] POST success:", ok)
	print("[DEBUG] POST result:", result)

	if ok then
		execBtn.Text = "✅ SUCCESS"
		execBtn.BackgroundColor3 = Color3.fromRGB(87, 242, 135)
	else
		execBtn.Text = "❌ FAILED"
		execBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
	end

	wait(2)
	execBtn.Text = "EXECUTE SCRIPT"
	execBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)

	-- Loop status every 3 mins
	local start = tick()
	task.spawn(function()
		while tick() - start < jam * 3600 do
			local msg = {
				channel_id = channel,
				username = username,
				content = "✅ Username: " .. username .. "\nLast Checked: <t:" .. os.time() .. ":R>"
			}
			pcall(function()
				HttpService:PostAsync(proxy, HttpService:JSONEncode(msg), Enum.HttpContentType.ApplicationJson)
			end)
			task.wait(180)
		end

		local final = {
			channel_id = channel,
			username = username,
			content = "@everyone ✅ Joki selesai untuk **" .. username .. "**!"
		}
		pcall(function()
			HttpService:PostAsync(proxy, HttpService:JSONEncode(final), Enum.HttpContentType.ApplicationJson)
		end)
	end)
end)