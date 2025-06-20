local HttpService = game:GetService("HttpService")
local username = game.Players.LocalPlayer.Name

-- Use _G values injected from the UI
local dc_webhook = _G.dc_webhook
local dc_message_id = _G.dc_message_id

-- Construct the edit endpoint
local edit_url = string.format("%s/messages/%s", dc_webhook, dc_message_id)

-- Create request function compatible with multiple executors
local request = request or http_request or (syn and syn.request) or (HttpService.RequestAsync and function(opts)
    return HttpService:RequestAsync(opts)
end)

if not request then
    warn("Your executor does not support HTTP requests.")
    return
end

-- Build embed message
local data = {
    embeds = {{
        title = "Online Checked",
        description = " Username : " .. username .. "\nLast Checked : <t:" .. os.time() .. ":R>",
        color = 16711680
    }}
}

-- Send the request
local success, response = pcall(function()
    return request({
        Url = edit_url,
        Method = "PATCH",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(data)
    })
end)

-- Log result
if success and response and response.Success then
    print("✅ Discord message edited successfully!")
else
    warn("❌ Failed to edit message:", response and response.StatusCode, response and response.Body)
end