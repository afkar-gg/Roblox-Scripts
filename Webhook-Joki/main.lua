-- Webhook Joki UI (Full Version with Checker Save) by @Afkar

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- === Config ===
local configFile = "JokiConfig.json"
local defaultConfig = {
    activeTab = "Webhook",
    fields = {
        jam_selesai_joki = "1",
        discord_webhook = "",
        no_order = "",
        nama_store = ""
    },
    checker = {
        dc_webhook = "",
        dc_message_id = ""
    }
}

local function loadConfig()
    if isfile(configFile) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(configFile))
        end)
        if success then return result end
    end
    return defaultConfig
end

local function saveConfig(cfg)
    writefile(configFile, HttpService:JSONEncode(cfg))
end

local config = loadConfig()
saveConfig(config)

-- === Cleanup Old UI ===
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

-- === Base UI Setup ===
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "JokiWebhookUI_ScreenGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 360)
main.Position = UDim2.new(0.5, -200, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
main.BorderColor3 = Color3.fromRGB(85, 85, 105)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Webhook Joki By @Afkar"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextWrapped = true
title.BackgroundTransparency = 1

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 0)
close.Text = "X"
close.Font = Enum.Font.SourceSansBold
close.TextSize = 14
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
close.TextWrapped = true
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- === Tab Buttons ===
local tabHolder = Instance.new("Frame", main)
tabHolder.Size = UDim2.new(1, 0, 0, 30)
tabHolder.Position = UDim2.new(0, 0, 0, 30)
tabHolder.BackgroundTransparency = 1

local function createTabButton(text, index)
    local b = Instance.new("TextButton", tabHolder)
    b.Size = UDim2.new(1/3, 0, 1, 0)
    b.Position = UDim2.new((index - 1) / 3, 0, 0, 0)
    b.Text = text
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    b.TextWrapped = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

-- === Tab Frames ===
local function createTabFrame()
    local f = Instance.new("Frame", main)
    f.Size = UDim2.new(1, 0, 1, -60)
    f.Position = UDim2.new(0, 0, 0, 60)
    f.BackgroundTransparency = 1
    return f
end

local webhookTab = createTabFrame()
local toolsTab = createTabFrame()
local checkerTab = createTabFrame()

-- === Webhook Content ===
local webhookContent = Instance.new("Frame", webhookTab)
webhookContent.Name = "ContentHolder"
webhookContent.Size = UDim2.new(1, 0, 1, 0)
webhookContent.BackgroundTransparency = 1
Instance.new("UIPadding", webhookContent).PaddingTop = UDim.new(0, 5)
Instance.new("UIListLayout", webhookContent).Padding = UDim.new(0, 8)

local function createInput(labelText, key, order)
    local wrap = Instance.new("Frame", webhookContent)
    wrap.Size = UDim2.new(0.9, 0, 0, 50)
    wrap.BackgroundTransparency = 1
    wrap.LayoutOrder = order

    local label = Instance.new("TextLabel", wrap)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = labelText
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1

    local box = Instance.new("TextBox", wrap)
    box.Size = UDim2.new(1, 0, 0, 30)
    box.Position = UDim2.new(0, 0, 0, 20)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.BorderColor3 = Color3.fromRGB(85, 85, 105)
    box.Font = Enum.Font.SourceSans
    box.PlaceholderText = "Enter value..."
    box.Text = config.fields[key] or ""
    box.TextSize = 14
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextWrapped = true
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    box:GetPropertyChangedSignal("Text"):Connect(function()
        config.fields[key] = box.Text
        saveConfig(config)
    end)
end

createInput("jam_selesai_joki", "jam_selesai_joki", 1)
createInput("discord_webhook", "discord_webhook", 2)
createInput("no_order", "no_order", 3)
createInput("nama_store", "nama_store", 4)

local exec = Instance.new("TextButton", webhookContent)
exec.Size = UDim2.new(0.9, 0, 0, 40)
exec.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
exec.BorderColor3 = Color3.fromRGB(120, 130, 255)
exec.Text = "EXECUTE SCRIPT"
exec.Font = Enum.Font.SourceSansBold
exec.TextColor3 = Color3.fromRGB(255, 255, 255)
exec.TextSize = 18
exec.TextWrapped = true
Instance.new("UICorner", exec).CornerRadius = UDim.new(0, 6)

exec.MouseButton1Click:Connect(function()
    local f = config.fields
    if f.discord_webhook == "" or f.no_order == "" or f.nama_store == "" then
        exec.Text = "FILL ALL FIELDS"
        exec.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        wait(2)
        exec.Text = "EXECUTE SCRIPT"
        exec.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    exec.Text = "EXECUTING..."
    local ok, code = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua")
    end)

    if ok then
        local final = string.format([[
            local jam_selesai_joki = %s
            local discord_webhook = %q
            local no_order = %q
            local nama_store = %q
            %s
        ]], f.jam_selesai_joki, f.discord_webhook, f.no_order, f.nama_store, code)
        pcall(function() loadstring(final)() end)
        exec.Text = "SUCCESS!"
        exec.BackgroundColor3 = Color3.fromRGB(87, 242, 135)
    else
        exec.Text = "FAILED TO LOAD"
        exec.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
    end
    wait(2)
    exec.Text = "EXECUTE SCRIPT"
    exec.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)

-- === Tools Tab: Infinite Yield ===
local toolsContent = Instance.new("Frame", toolsTab)
toolsContent.Name = "ContentHolder"
toolsContent.Size = UDim2.new(1, 0, 1, 0)
toolsContent.BackgroundTransparency = 1

local iyBtn = Instance.new("TextButton", toolsContent)
iyBtn.Size = UDim2.new(0, 200, 0, 40)
iyBtn.Position = UDim2.new(0.5, -100, 0.5, -20)
iyBtn.BackgroundColor3 = Color3.fromRGB(44, 130, 201)
iyBtn.Text = "Infinite Yield"
iyBtn.Font = Enum.Font.SourceSansBold
iyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
iyBtn.TextSize = 18
iyBtn.TextWrapped = true
Instance.new("UICorner", iyBtn).CornerRadius = UDim.new(0, 6)
iyBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- === Checker Tab ===
local checkerContent = Instance.new("Frame", checkerTab)
checkerContent.Size = UDim2.new(1, 0, 1, 0)
checkerContent.BackgroundTransparency = 1
Instance.new("UIPadding", checkerContent).PaddingTop = UDim.new(0, 5)
Instance.new("UIListLayout", checkerContent).Padding = UDim.new(0, 8)

local function createCheckerInput(labelText, key, order)
    local wrap = Instance.new("Frame", checkerContent)
    wrap.Size = UDim2.new(0.9, 0, 0, 50)
    wrap.BackgroundTransparency = 1
    wrap.LayoutOrder = order

    local label = Instance.new("TextLabel", wrap)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = labelText
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextWrapped = true
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", wrap)
    box.Size = UDim2.new(1, 0, 0, 30)
    box.Position = UDim2.new(0, 0, 0, 20)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.BorderColor3 = Color3.fromRGB(85, 85, 105)
    box.Font = Enum.Font.SourceSans
    box.PlaceholderText = "Enter value..."
    box.TextSize = 14
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextWrapped = true
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    box.Text = config.checker[key] or ""

    box:GetPropertyChangedSignal("Text"):Connect(function()
        config.checker[key] = box.Text
        saveConfig(config)
    end)

    return box
end

local webhookBox = createCheckerInput("dc_webhook", "dc_webhook", 1)
local msgIdBox = createCheckerInput("dc_message_id", "dc_message_id", 2)

local runBtn = Instance.new("TextButton", checkerContent)
runBtn.Size = UDim2.new(0.9, 0, 0, 40)
runBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
runBtn.Text = "RUN"
runBtn.Font = Enum.Font.SourceSansBold
runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
runBtn.TextSize = 18
runBtn.TextWrapped = true
Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 6)

runBtn.MouseButton1Click:Connect(function()
    local dc_webhook = webhookBox.Text
    local dc_message_id = msgIdBox.Text

    if dc_webhook == "" or dc_message_id == "" then
        runBtn.Text = "FILL BOTH FIELDS"
        runBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        wait(2)
        runBtn.Text = "RUN"
        runBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    local final = string.format([[
        local dc_webhook = %q
        local dc_message_id = %q
        %s
    ]], dc_webhook, dc_message_id, game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/main/Webhook-Joki/EditMsg.lua"))

    pcall(function() loadstring(final)() end)
end)

-- === Tab Buttons & Logic ===
local tabButtons = {
    Webhook = createTabButton("Webhook", 1),
    Tools = createTabButton("Tools", 2),
    Checker = createTabButton("Checker", 3)
}

local function switchTab(name)
    webhookTab.Visible = false
    toolsTab.Visible = false
    checkerTab.Visible = false

    if name == "Webhook" then
        webhookTab.Visible = true
    elseif name == "Tools" then
        toolsTab.Visible = true
    elseif name == "Checker" then
        checkerTab.Visible = true
    end

    config.activeTab = name
    saveConfig(config)
end

tabButtons.Webhook.MouseButton1Click:Connect(function() switchTab("Webhook") end)
tabButtons.Tools.MouseButton1Click:Connect(function() switchTab("Tools") end)
tabButtons.Checker.MouseButton1Click:Connect(function() switchTab("Checker") end)

-- === Load Saved Tab
switchTab(config.activeTab or "Webhook")