local HttpService = game:GetService("HttpService")
local username = game.Players.LocalPlayer.Name

-- Injected from UI
local dc_webhook = _G.dc_webhook
local dc_message_id = _G.dc_message_id

-- Make sure they're not nil
if not dc_webhook or not dc_message_id or dc_webhook == "" or dc_message_id == "" then
    warn("Webhook URL or message ID not set.")
    return
end

print("Using webhook:", dc_webhook)
print("Editing message:", dc_message_id)

-- Build the edit URL
local edit_url = string.format("%s/messages/%s", dc_webhook, dc_message_id)

-- Cross-executor request function
local request = request or http_request or (syn and syn.request) or (HttpService.RequestAsync and function(opt)
    return HttpService:RequestAsync(opt)
end)

if not request then
    warn("HTTP requests are not supported on this executor.")
    return
end

-- Loop every 5 minutes
while true do
    local embedData = {
        embeds = {{
            title = "Online Checked",
            description = "Username: " .. username .. "\nLast Checked: <t:" .. os.time() .. ":R>",
            color = 16711680
        }}
    }

    local success, response = pcall(function()
        return request({
            Url = edit_url,
            Method = "PATCH",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(embedData)
        })
    end)

    if success and response and response.Success then
        print("✅ Message edited successfully!")
    else
        warn("❌ Failed to edit message:", response and response.StatusCode, response and response.Body)
    end

    task.wait(300) -- Wait 5 minutes
end