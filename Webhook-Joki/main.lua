-- Fetch the remote script content (Webhook.lua)
local success1, webhookScript = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/Webhook-Joki/Webhook.lua")
end)

-- Fetch Infinite Yield source
local success2, iyScript = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)

if not success1 or not webhookScript then
    executeButton.Text = "WEBHOOK GET FAILED"
    executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
    warn("Failed to fetch Webhook.lua:", webhookScript)
    wait(3)
    executeButton.Active = true
    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    return
end

if not success2 or not iyScript then
    executeButton.Text = "INFINITE YIELD GET FAILED"
    executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
    warn("Failed to fetch Infinite Yield:", iyScript)
    wait(3)
    executeButton.Active = true
    executeButton.Text = "EXECUTE SCRIPT"
    executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    return
end

-- Combine: Injected Variables + Webhook + Infinite Yield
local finalScript = string.format([[
    -- User variables
    local jam_selesai_joki = %s
    local discord_webhook = %q
    local no_order = %q
    local nama_store = %q

    -- Webhook logic
    %s

    -- Infinite Yield
    %s
]], jamSelesai, webhookUrl, orderId, storeName, webhookScript, iyScript)

-- Run combined script
local loadSuccess, loadError = pcall(function()
    loadstring(finalScript)()
end)

if loadSuccess then
    executeButton.Text = "SUCCESS!"
    executeButton.BackgroundColor3 = Color3.fromRGB(87, 242, 135)
    wait(2)
else
    executeButton.Text = "EXECUTION ERROR"
    executeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
    warn("Script execution error:", loadError)
    wait(3)
end

-- Reset
executeButton.Active = true
executeButton.Text = "EXECUTE SCRIPT"
executeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)