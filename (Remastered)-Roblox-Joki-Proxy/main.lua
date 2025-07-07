if not game:IsLoaded() then game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Universal HTTP
local request = http_request or syn and syn.request or request or nil
if not request then
    warn("❌ Executor doesn't support HTTP requests.")
    return
end

-- Config save
local folder = "joki_config"
local path = folder .. "/proxy_url.json"
local canSave = writefile and readfile and isfile and makefolder
if canSave and not isfolder(folder) then pcall(makefolder, folder) end

local savedUrl = ""
if canSave and isfile(path) then
    local ok, data = pcall(readfile, path)
    if ok then
        local dec = HttpService:JSONDecode(data)
        savedUrl = dec.proxy_url or ""
    end
end

pcall(function() CoreGui:FindFirstChild("JokiUI"):Destroy() end)

-- UI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "JokiUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 200)
frame.Position = UDim2.new(0.5, -180, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(35,35,45)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

-- Title & Close
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Roblox Joki Controller"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,24,0,24)
closeBtn.Position = UDim2.new(1, -28, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Proxy TextBox
local urlBox = Instance.new("TextBox", frame)
urlBox.Size = UDim2.new(0.9,0,0,30)
urlBox.Position = UDim2.new(0.05,0,0,40)
urlBox.Text = savedUrl
urlBox.PlaceholderText = "Proxy URL"
urlBox.TextColor3 = Color3.new(1,1,1)
urlBox.Font = Enum.Font.SourceSans
urlBox.TextSize = 14
urlBox.BackgroundColor3 = Color3.fromRGB(25,25,35)
Instance.new("UICorner", urlBox).CornerRadius = UDim.new(0,4)
urlBox.FocusLost:Connect(function()
    if canSave then
        pcall(writefile, path, HttpService:JSONEncode({ proxy_url = urlBox.Text }))
    end
end)

-- Status Label
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.9,0,0,20)
status.Position = UDim2.new(0.05,0,0,75)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.new(1,1,1)
status.Font = Enum.Font.SourceSans
status.TextSize = 14

-- Buttons
local execBtn = Instance.new("TextButton", frame)
execBtn.Size = UDim2.new(0.42,0,0,34)
execBtn.Position = UDim2.new(0.05,0,0,105)
execBtn.Text = "SEND /track"
execBtn.Font = Enum.Font.SourceSansBold
execBtn.TextColor3 = Color3.new(1,1,1)
execBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0,6)

local jobBtn = Instance.new("TextButton", frame)
jobBtn.Size = UDim2.new(0.42,0,0,34)
jobBtn.Position = UDim2.new(0.53,0,0,105)
jobBtn.Text = "SEND JOB ID"
jobBtn.Font = Enum.Font.SourceSansBold
jobBtn.TextColor3 = Color3.new(1,1,1)
jobBtn.BackgroundColor3 = Color3.fromRGB(52,152,219)
Instance.new("UICorner", jobBtn).CornerRadius = UDim.new(0,6)

-- Logic
local function sendTrack()
    local url = urlBox.Text
    if url == "" then status.Text = "❌ Missing URL"; return end

    local ok, res = pcall(function()
        return request({
            Url = url .. "/track",
            Method = "POST",
            Headers = {["Content-Type"]="application/json"},
            Body = HttpService:JSONEncode({ username = player.Name })
        })
    end)

    if not ok or res.StatusCode ~= 200 then
        status.Text = "❌ track failed (" .. (res and res.StatusCode or "ERR") .. ")"
        return nil
    end

    local data = HttpService:JSONDecode(res.Body)
    status.Text = "✅ Session started"
    return data.endTime
end

execBtn.MouseButton1Click:Connect(function()
    local endTime = sendTrack()
    if not endTime then return end

    task.spawn(function()
        while os.time() < math.floor(endTime/1000) do
            local left = math.floor(endTime/1000) - os.time()
            status.Text = string.format("⏳ %02d:%02d left", left//60, left%60)

            pcall(function()
                request({
                    Url = urlBox.Text .. "/check",
                    Method = "POST",
                    Headers = {["Content-Type"]="application/json"},
                    Body = HttpService:JSONEncode({ username = player.Name })
                })
            end)

            task.wait(60)
        end

        pcall(function()
            request({
                Url = urlBox.Text .. "/complete",
                Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = HttpService:JSONEncode({ username = player.Name })
            })
        end)

        status.Text = "✅ Completed"
    end)
end)

jobBtn.MouseButton1Click:Connect(function()
    local url = urlBox.Text
    if url == "" then status.Text = "❌ Missing URL"; return end

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
            Headers = {["Content-Type"]="application/json"},
            Body = body
        })
    end)

    status.Text = ok and "✅ Sent jobID" or "❌ jobID failed"
end)