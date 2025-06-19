-- This script adds a tabbed UI to the original webhook UI script.
-- One tab is for the webhook configuration, the other executes Infinite Yield.

if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService("Players").LocalPlayer then
    warn("This script must be run from a client executor.")
    return
end

pcall(function()
    game:GetService("CoreGui"):FindFirstChild("JokiWebhookUI_ScreenGui"):Destroy()
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JokiWebhookUI_ScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 380)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderColor3 = Color3.fromRGB(85, 85, 105)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 22, 0, 22)
closeButton.Position = UDim2.new(1, -26, 0, 4)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 14
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tabs under close button
local tabHolder = Instance.new("Frame")
tabHolder.Name = "TabHolder"
tabHolder.Size = UDim2.new(1, -32, 0, 30)
tabHolder.Position = UDim2.new(0, 4, 0, 30)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabHolder

local function createTabButton(name)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.Parent = tabHolder
    return btn
end

local webhookTabBtn = createTabButton("Webhook")
local toolsTabBtn = createTabButton("Tools")

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Position = UDim2.new(0, 0, 0, 65)
contentFrame.Size = UDim2.new(1, 0, 1, -65)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local webhookFrame = Instance.new("Frame")
webhookFrame.Name = "WebhookTab"
webhookFrame.Size = UDim2.new(1, 0, 1, 0)
webhookFrame.BackgroundTransparency = 1
webhookFrame.Visible = true
webhookFrame.Parent = contentFrame

local toolsFrame = Instance.new("Frame")
toolsFrame.Name = "ToolsTab"
toolsFrame.Size = UDim2.new(1, 0, 1, 0)
toolsFrame.BackgroundTransparency = 1
toolsFrame.Visible = false
toolsFrame.Parent = contentFrame

webhookTabBtn.MouseButton1Click:Connect(function()
    webhookFrame.Visible = true
    toolsFrame.Visible = false
end)

toolsTabBtn.MouseButton1Click:Connect(function()
    webhookFrame.Visible = false
    toolsFrame.Visible = true
end)

-- Rest of the script remains unchanged from the previous version
