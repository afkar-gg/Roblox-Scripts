local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Get the local player's username
local username = Players.LocalPlayer and Players.LocalPlayer.Name or "Unknown"

-- Build the message to send to the Discord bot
local content = "Username: " .. username .. "\nLast Checked: <t:" .. os.time() .. ":R>"

-- Request compatibility (for Synapse X, KRNL, etc.)
local request = request or http_request or (syn and syn.request) or
                (HttpService.RequestAsync and function(opt)
                    return HttpService:RequestAsync(opt)
                end)

if not request then
    warn("❌ Your executor does not support HTTP requests.")
    return
end

-- Send the message to the Replit server (replace with your actual working URL)
local success, res = pcall(function()
    return request({
        Url = "https://2bea6df1-6629-441f-81d4-d73bd1523fd3-00-3mudrqreqpixm.sisko.replit.dev/send",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            content = content
        })
    })
end)

-- Handle result
if success and res and res.Success then
    print("✅ Message sent via bot!")
else
    warn("❌ Failed to send message:", res and res.StatusCode, res and res.Body)
end