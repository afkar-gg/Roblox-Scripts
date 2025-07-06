if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then return end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Default Config
local saved = {
	jam_selesai_joki = "1",
	no_order = "",
	nama_store = "",
	proxy_url = ""
}

-- Persistent Save Support
local configFolder = "joki_config"
local configFile = configFolder .. "/config.json"
local canSave = isfile and writefile and readfile and makefolder

if canSave and not isfolder(configFolder) then
	pcall(makefolder, configFolder)
end
if canSave and isfile(configFile) then
	local ok, data = pcall(readfile, configFile)
	if ok then
		local decoded = HttpService:JSONDecode(data)
		for k,v in pairs(decoded) do saved[k]=v end
	end
end

-- GUI Setup
pcall(function() game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI"):Destroy() end)
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,400,0,400)
frame.Position = UDim2.new(0.5,-200,0.5,-200)
frame.BackgroundColor3 = Color3.fromRGB(35,35,45)
frame.BorderColor3 = Color3.fromRGB(85,85,105)
frame.BorderSizePixel = 2
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
frame.Active = true
frame.Draggable = true

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(45,45,55)
titleBar.BorderColor3 = Color3.fromRGB(85,85,105)
-- Manual drag (optional fallback)
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local startPos = input.Position; local offset = frame.Position
		local move, release
		move = game:GetService("UserInputService").InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = i.Position - startPos
				frame.Position = UDim2.new(offset.X.Scale, offset.X.Offset + delta.X, offset.Y.Scale, offset.Y.Offset + delta.Y)
			end
		end)
		release = game:GetService("UserInputService").InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				move:Disconnect(); release:Disconnect()
			end
		end)
	end
end)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.fromScale(1,1)
titleLabel.AnchorPoint = Vector2.new(0.5,0.5)
titleLabel.Position = UDim2.fromScale(0.5,0.5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Webhook Joki Configuration"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.new(1,1,1)

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0,24,0,24)
closeButton.Position = UDim2.new(1,-6,0,3)
closeButton.AnchorPoint = Vector2.new(1,0)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 14
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.BackgroundColor3 = Color3.fromRGB(231,76,60)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0,6)
closeButton.MouseButton1Click:Connect(function() gui.Enabled = false end)

local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0,0,0,30)
content.Size = UDim2.new(1,0,1,-30)
content.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
Instance.new("UIPadding", content).PaddingTop = UDim.new(0,10)

-- Input builder helper
local function makeInput(name, placeholder, order)
	local container = Instance.new("Frame", content)
	container.Size = UDim2.new(0.9,0,0,50)
	container.LayoutOrder = order
	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1,0,0,20)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.SourceSans
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.fromRGB(220,220,220)
	local box = Instance.new("TextBox", container)
	box.Size = UDim2.new(1,0,0,30)
	box.Position = UDim2.new(0,0,0,20)
	box.BackgroundColor3 = Color3.fromRGB(25,25,35)
	box.BorderColor3 = Color3.fromRGB(85,85,105)
	box.Text = saved[name] or ""
	box.PlaceholderText = placeholder
	box.Font = Enum.Font.SourceSans
	box.TextColor3 = Color3.new(1,1,1)
	box.TextSize = 14
	box.ClearTextOnFocus = false
	box.TextWrapped = true
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)
	box:GetPropertyChangedSignal("Text"):Connect(function()
		saved[name] = box.Text
		if canSave then pcall(writefile, configFile, HttpService:JSONEncode(saved)) end
	end)
	box.FocusLost:Connect(function()
		saved[name] = box.Text
		if canSave then pcall(writefile, configFile, HttpService:JSONEncode(saved)) end
	end)
	return box
end

local jamBox = makeInput("jam_selesai_joki","e.g., 1",1)
local orderBox = makeInput("no_order","e.g., OD000001",2)
local storeBox = makeInput("nama_store","e.g., AfkarStore",3)
local urlBox = makeInput("proxy_url","https://your.proxy/send",4)

local countdownLabel = Instance.new("TextLabel", content)
countdownLabel.Size = UDim2.new(0.9,0,0,20)
countdownLabel.TextColor3 = Color3.new(1,1,1)
countdownLabel.Font = Enum.Font.SourceSans
countdownLabel.TextSize = 14
countdownLabel.BackgroundTransparency = 1
countdownLabel.LayoutOrder = 5

local executeBtn = Instance.new("TextButton", content)
executeBtn.Size = UDim2.new(0.9,0,0,40)
executeBtn.Text = "EXECUTE SCRIPT"
executeBtn.Font = Enum.Font.SourceSansBold
executeBtn.TextColor3 = Color3.new(1,1,1)
executeBtn.TextSize = 18
executeBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
executeBtn.BorderColor3 = Color3.fromRGB(120,130,255)
Instance.new("UICorner", executeBtn).CornerRadius = UDim.new(0,6)
executeBtn.LayoutOrder = 6

local jobBtn = Instance.new("TextButton", content)
jobBtn.Size = UDim2.new(0.9,0,0,30)
jobBtn.Text = "Send Job ID"
jobBtn.Font = Enum.Font.SourceSansBold
jobBtn.TextColor3 = Color3.new(1,1,1)
jobBtn.TextSize = 14
jobBtn.BackgroundColor3 = Color3.fromRGB(52,152,219)
jobBtn.BorderColor3 = Color3.fromRGB(120,160,255)
Instance.new("UICorner", jobBtn).CornerRadius = UDim.new(0,6)
jobBtn.LayoutOrder = 7

-- Execution logic
executeBtn.MouseButton1Click:Connect(function()
	local jam = tonumber(saved.jam_selesai_joki) or 1
	local order = saved.no_order
	local store = (saved.nama_store~="" and saved.nama_store) or "AfkarStore"
	local url = (saved.proxy_url~="" and saved.proxy_url) or "https://loremipsum.com"
	if order=="" or url=="" then
		executeBtn.Text="FILL ALL FIELDS"
		executeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
		wait(2)
		executeBtn.Text="EXECUTE SCRIPT"
		executeBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
		return
	end
	local resumeSuccess,resumeResult = pcall(function()
		local res = http_request({Url = url.."/resume", Method="POST", Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode({username=player.Name})})
		return HttpService:JSONDecode(res.Body)
	end)
	local endTime
	if resumeSuccess and resumeResult and resumeResult.ok and resumeResult.endTime then
		endTime = math.floor(resumeResult.endTime/1000)
		countdownLabel.Text = "🔄 Resuming session..."
	else
		http_request({Url = url.."/send", Method="POST", Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode({username=player.Name, jam_selesai_joki=jam, no_order=order, nama_store=store})})
		endTime = os.time() + jam*3600
		countdownLabel.Text = "✅ Session started."
	end
	task.spawn(function()
		while os.time()<endTime do
			local left = endTime-os.time()
			countdownLabel.Text = string.format("⏳ %02d:%02d remaining", math.floor(left/60), left%60)
			pcall(function()
				http_request({Url=url.."/check", Method="POST", Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode({username=player.Name})})
			end)
			task.wait(60)
		end
		pcall(function()
			http_request({Url=url.."/complete", Method="POST", Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode({username=player.Name, no_order=order, nama_store=store})})
			countdownLabel.Text = "✅ Completed."
		end)
	end)
end)

-- Send Job ID logic
jobBtn.MouseButton1Click:Connect(function()
	local url = (saved.proxy_url~="" and saved.proxy_url) or "https://loremipsum.com"
	local joinUrl = url.."/join?place="..tostring(game.PlaceId).."&job="..tostring(game.JobId)
	http_request({Url = url.."/send-job", Method="POST", Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode({username=player.Name, placeId=tostring(game.PlaceId), jobId=tostring(game.JobId), join_url=joinUrl})})
	jobBtn.Text="✅ Sent!"
	task.delay(2, function() jobBtn.Text="Send Job ID" end)
end)