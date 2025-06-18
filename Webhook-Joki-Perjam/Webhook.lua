local Players = game:GetService("Players") -- Get the Players service
local LocalPlayer = Players.LocalPlayer -- Get the local player (the client playing the game)
local username = LocalPlayer.Name -- Get the player's username

-- 1. Define start and end times clearly using UTC Unix timestamps, which Discord prefers.
local start_timestamp = os.time()
local end_timestamp = start_timestamp + (3600 * jam_selesai_joki)

-- This part is correct.
local new_string = string.sub(no_order, 9) -- Start from the 9th character to get the numbers after "OD000000"


function SendMessage(url, message)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = message
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
    print("Sent")
end

-- This function has not been changed, as requested.
-- In Webhook.lua (Corrected)
function SendMessageEMBED(url, embed)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["embeds"] = {
            {
                ["title"] = embed.title,
                ["description"] = embed.description,
                ["color"] = embed.color,
                ["fields"] = embed.fields,
                ["footer"] = {
                    ["text"] = embed.footer.text
                }
            }
        }
    }
    
    -- Encode the data table into a JSON string
    local success, body = pcall(function()
        return http:JSONEncode(data)
    end)

    if not success then
        warn("Failed to encode JSON body:", body)
        return
    end

    -- Use HttpService:PostAsync in a protected call
    local success, response = pcall(function()
        return http:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("Webhook message sent successfully.")
    else
        warn("Failed to send webhook message:", response)
    end
end


-- 3. Fixed the function call to use the correct 'discord_webhook' variable.
SendMessageEMBED(discord_webhook, embed)
