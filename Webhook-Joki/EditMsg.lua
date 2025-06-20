local HttpService = game:GetService("HttpService")

local dc_webhook = "YOUR_WEBHOOK_URL" -- e.g., "https://discord.com/api/webhooks/xxxx/yyyy"
local dc_message_id = "YOUR_MESSAGE_ID" -- your existing message ID
local new_content = "This is the updated message!"

-- Construct the edit endpoint
local edit_url = string.format("%s/messages/%s", dc_webhook, dc_message_id)

-- Data to send
local data = {
    content = new_content
}

local success, response = pcall(function()
    return HttpService:RequestAsync({
        Url = edit_url,
        Method = "PATCH",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(data)
    })
end)

if success and response.Success then
    print("Message edited successfully!")
else
    warn("Failed to edit message: ", response and response.StatusCode, response and response.Body)
end