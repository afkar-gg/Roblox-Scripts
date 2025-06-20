-- Webhook Edit UI with Auto Save/Load and Script Execution

if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then
    warn("Client-only script.")
    return
end

-- ==== CONFIG ====
local HttpService = game:GetService("HttpService")
local configFile = "webhook_edit.json"
local canUseFile = (readfile and writefile and isfile) and true or false

local savedConfig = {
	dc_webhook = "",
	dc_message_id = ""
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

-- ==== UI ====
pcall(function()
	game:GetService("CoreGui"):FindFirstChild("WebhookEditorUI"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "WebhookEditorUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = game:GetService("CoreGui")
gui.Enabled = true

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 250)
frame.Position = UDim2.new(0.5, -200, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderColor3 = Color3.fromRGB(85, 85, 105)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- ==== Title Bar ====
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderColor3 = Color3.fromRGB(85, 85, 105)
titleBar.BorderSizePixel = 1
titleBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.fromScale(1, 1)
titleLabel.Position = UDim2.fromScale(0.5, 0.5)
titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Edit Webhook Configuration"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -6, 0, 3)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 14
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

closeButton.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

-- ==== Content ====
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.Parent = content

-- ==== Input Helper ====
local function makeInput(name, placeholder, order, defaultValue)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.9, 0, 0, 50)
	container.BackgroundTransparency = 1
	container.LayoutOrder = order
	container.Parent = content

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.SourceSans
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local box = Instance.new("TextBox")
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
	box.Parent = container

	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	return box
end

-- Input Fields
local webhookBox = makeInput("dc_webhook", "Paste webhook URL", 1, savedConfig.dc_webhook)
local messageIdBox = makeInput("dc_message_id", "Enter message ID", 2, savedConfig.dc_message_id)

-- ==== Save Config ====
local function saveConfig()
	if not canUseFile then return end
	local data = {
		dc_webhook = webhookBox.Text,
		dc_message_id = messageIdBox.Text
	}
	local ok, json = pcall(function()
		return HttpService:JSONEncode(data)
	end)
	if ok then
		pcall(writefile, configFile, json)
	end
end

webhookBox.FocusLost:Connect(saveConfig)
messageIdBox.FocusLost:Connect(saveConfig)

-- ==== Execute Button ====
local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0.9, 0, 0, 40)
executeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
executeBtn.BorderColor3 = Color3.fromRGB(120, 130, 255)
executeBtn.BorderSizePixel = 1
executeBtn.Text = "EXECUTE SCRIPT"
executeBtn.Font = Enum.Font.SourceSansBold
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
executeBtn.TextSize = 18
executeBtn.LayoutOrder = 3
executeBtn.Parent = content
Instance.new("UICorner", executeBtn).CornerRadius = UDim.new(0, 6)

executeBtn.MouseButton1Click:Connect(function()
	_G.dc_webhook = webhookBox.Text
	_G.dc_message_id = messageIdBox.Text

	loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Online-Checker/Editmsg.lua"))();
end)
