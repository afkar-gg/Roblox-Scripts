if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then return end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local username = Players.LocalPlayer.Name

local configFile = "joki_config.json"
local canUseFile = (readfile and writefile and isfile) and true or false

local savedConfig = {
	jam_selesai_joki = "1",
	proxy_url = "",
	no_order = "",
	nama_store = ""
}

if canUseFile and isfile(configFile) then
	local success, content = pcall(readfile, configFile)
	if success then
		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(content)
		end)
		if ok and typeof(decoded) == "table" then
			for k, v in pairs(decoded) do
				if savedConfig[k] ~= nil then
					savedConfig[k] = tostring(v)
				end
			end
		end
	end
end

pcall(function()
	game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "JokiWebhookUI_ScreenGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 380)
frame.Position = UDim2.new(0.5, -200, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(85, 85, 105)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderColor3 = Color3.fromRGB(85, 85, 105)
titleBar.BorderSizePixel = 1

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.fromScale(1, 1)
titleLabel.Position = UDim2.fromScale(0.5, 0.5)
titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Webhook Joki Configuration"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Center

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -6, 0, 3)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 14
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

closeButton.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
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
	box.BorderSizePixel = 1
	box.Font = Enum.Font.SourceSans
	box.PlaceholderText = placeholder
	box.Text = defaultValue or ""
	box.TextColor3 = Color3.new(1, 1, 1)
	box.TextSize = 14
	box.TextWrapped = true
	box.ClearTextOnFocus = false
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	return box
end

local jamSelesaiBox = makeInput("jam_selesai_joki", "e.g., 1", 1, savedConfig.jam_selesai_joki)
local proxyBox = makeInput("proxy_url", "Paste your Proxy URL", 2, savedConfig.proxy_url)
local orderBox = makeInput("no_order", "e.g., OD123456789", 3, savedConfig.no_order)
local storeBox = makeInput("nama_store", "e.g., AfkarStore", 4, savedConfig.nama_store)

local function saveConfig()
	if not canUseFile then return end
	local data = {
		jam_selesai_joki = jamSelesaiBox.Text,
		proxy_url = proxyBox.Text,
		no_order = orderBox.Text,
		nama_store = storeBox.Text
	}
	local ok, json = pcall(function()
		return HttpService:JSONEncode(data)
	end)
	if ok then pcall(writefile, configFile, json) end
end

jamSelesaiBox.FocusLost:Connect(saveConfig)
proxyBox.FocusLost:Connect(saveConfig)
orderBox.FocusLost:Connect(saveConfig)
storeBox.FocusLost:Connect(saveConfig)

local executeBtn = Instance.new("TextButton", content)
executeBtn.Size = UDim2.new(0.9, 0, 0, 40)
executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeBtn.BorderColor3 = Color3.fromRGB(120, 130, 255)
executeBtn.BorderSizePixel = 1
executeBtn.Text = "EXECUTE SCRIPT"
executeBtn.Font = Enum.Font.SourceSansBold
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
executeBtn.TextSize = 18
executeBtn.LayoutOrder = 5
Instance.new("UICorner", executeBtn).CornerRadius = UDim.new(0, 6)

executeBtn.MouseButton1Click:Connect(function()
	local jam = tonumber(jamSelesaiBox.Text)
	local proxy_url = proxyBox.Text
	local no_order = orderBox.Text
	local nama_store = storeBox.Text

	if not jam or not proxy_url or proxy_url == "" or no_order == "" or nama_store == "" then
		executeBtn.Text = "FILL ALL FIELDS"
		executeBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
		wait(2)
		executeBtn.Text = "EXECUTE SCRIPT"
		executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		return
	end

	-- ✅ EMBED MESSAGE
	local embedPayload = {
		username = username,
		embeds = {{
			title = "JOKI STARTED",
			description = "Username: " .. username,
			color = 65280,
			fields = {
				{
					name = "Info Joki",
					value = "Nomor Order : " .. no_order .. "\nLink Pesanan : [Link Pesanan](https://tokoku.itemku.com/riwayat-pesanan/rincian/" .. string.sub(no_order, 9) .. ")"
				},
				{
					name = "Time",
					value = "Start: <t:" .. os.time() .. ":f>\nEnd: <t:" .. (os.time() + jam * 3600) .. ":f>"
				}
			},
			footer = { text = "- " .. nama_store .. " ❤️" }
		}}
	}

	local success = pcall(function()
		HttpService:PostAsync(proxy_url, HttpService:JSONEncode(embedPayload), Enum.HttpContentType.ApplicationJson)
	end)

	if success then
		executeBtn.Text = "✅ SUCCESS!"
		executeBtn.BackgroundColor3 = Color3.fromRGB(87, 242, 135)
	else
		executeBtn.Text = "FAILED TO SEND"
		executeBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
		wait(3)
	end

	wait(2)
	executeBtn.Text = "EXECUTE SCRIPT"
	executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)

	-- 🔁 LOOP
	local start = tick()
	task.spawn(function()
		while tick() - start < jam * 3600 do
			local msg = {
				username = username,
				content = "✅ Username: " .. username .. "\nLast Checked: <t:" .. os.time() .. ":R>"
			}
			pcall(function()
				HttpService:PostAsync(proxy_url, HttpService:JSONEncode(msg), Enum.HttpContentType.ApplicationJson)
			end)
			task.wait(180)
		end

		-- ✅ FINISH
		local done = {
			username = username,
			content = "@everyone ✅ Joki finished for **" .. username .. "**!"
		}
		pcall(function()
			HttpService:PostAsync(proxy_url, HttpService:JSONEncode(done), Enum.HttpContentType.ApplicationJson)
		end)
	end)
end)