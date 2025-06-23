if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Config save/load
local configFile = "joki_config.json"
local canSave = (writefile and readfile and isfile)

local saved = {
	jam_selesai_joki = "1",
	no_order = "",
	nama_store = ""
}

if canSave and isfile(configFile) then
	local ok, json = pcall(readfile, configFile)
	if ok then
		local decode = pcall(function() return HttpService:JSONDecode(json) end)
		if decode then
			for k, v in pairs(decode) do
				if saved[k] ~= nil then
					saved[k] = tostring(v)
				end
			end
		end
	end
end

-- UI setup
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "JokiWebhookUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Webhook Joki Configuration"
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

-- Layout
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

-- Input fields
local jamBox = makeInput("jam_selesai_joki", "e.g., 1", saved.jam_selesai_joki)
local orderBox = makeInput("no_order", "e.g., OD123456", saved.no_order)
local storeBox = makeInput("nama_store", "e.g., AfkarStore", saved.nama_store)

-- Auto-save
local function save()
	if not canSave then return end
	local data = {
		jam_selesai_joki = jamBox.Text,
		no_order = orderBox.Text,
		nama_store = storeBox.Text
	}
	local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
	if ok then pcall(writefile, configFile, encoded) end
end

jamBox.FocusLost:Connect(save)
orderBox.FocusLost:Connect(save)
storeBox.FocusLost:Connect(save)

-- Execute Button
local exec = Instance.new("TextButton", content)
exec.Size = UDim2.new(0.9, 0, 0, 40)
exec.Text = "EXECUTE SCRIPT"
exec.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
exec.TextColor3 = Color3.new(1, 1, 1)
exec.TextSize = 18
exec.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", exec).CornerRadius = UDim.new(0, 6)

exec.MouseButton1Click:Connect(function()
	local data = {
		jam_selesai_joki = tonumber(jamBox.Text) or 1,
		no_order = orderBox.Text,
		nama_store = storeBox.Text,
		username = player.Name
	}

	if data.no_order == "" or data.nama_store == "" then
		exec.Text = "FILL ALL FIELDS"
		exec.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
		task.wait(2)
		exec.Text = "EXECUTE SCRIPT"
		exec.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		return
	end

	local remote = ReplicatedStorage:WaitForChild("SendWebhookData")
	remote:FireServer(data)
	exec.Text = "SENT"
	task.wait(1)
	exec.Text = "EXECUTE SCRIPT"
end)