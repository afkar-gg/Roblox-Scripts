-- Suggested content for Webhook.lua (This is what you should put at your GitHub URL)
-- This script is designed to be loaded by `loadstring` and then called as a function.

return function(
    passed_webhook_discord,     -- The webhook URL from your UI
    passed_jam_selesai_joki,    -- The "jam_selesai_joki" value from your UI
    passed_no_order,            -- The "no_order" value from your UI
    passed_nama_store           -- The "nama_store" value from your UI
)
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer -- This will be valid on the client (LocalScript context)

    -- Assign the passed arguments to local variables within this script's scope
    local webhook_discord = passed_webhook_discord
    local jam_selesai_joki = passed_jam_selesai_joki
    local no_order = passed_no_order
    local nama_store = passed_nama_store

    -- === Input Validation and Defaults ===
    if type(jam_selesai_joki) ~= "number" or jam_selesai_joki < 0 then
        warn("Invalid or missing 'jam_selesai_joki'. Defaulting to 1.")
        jam_selesai_joki = 1
    end
    if type(no_order) ~= "string" or no_order == "" then
        warn("Invalid or missing 'no_order'. Defaulting to 'N/A'.")
        no_order = "N/A"
    end
    if type(nama_store) ~= "string" or nama_store == "" then
        warn("Invalid or missing 'nama_store'. Defaulting to 'Default Store'.")
        nama_store = "Default Store"
    end
    if type(webhook_discord) ~= "string" or not webhook_discord:match("^https?://discord%.com/api/webhooks/%d+/%w+$") then
        warn("Invalid or missing 'webhook_discord' URL. Webhook will not be sent.")
        webhook_discord = ""
    end


    -- === Time Calculations ===
    local current_time = os.time()
    local wib_offset = 25200 -- UTC+7 (WIB - Western Indonesian Time) in seconds
    local wib_current_time = current_time + wib_offset
    local done_joki = wib_current_time + (3600 * jam_selesai_joki)

    local new_string = string.sub(no_order, 9)

    local username = LocalPlayer and LocalPlayer.Name or "UnknownUser"

    -- === Webhook Sending Functions ===

    -- Original SendMessage function, fixed to use HttpService:PostAsync
    function SendMessage(url, message)
        if type(url) ~= "string" or url == "" then
            warn("SendMessage: Provided URL is invalid or empty. Not sending.")
            return
        end

        local http = HttpService
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["content"] = message
        }
        local body = http:JSONEncode(data)

        local success, response = pcall(function()
            return http:PostAsync(url, body, true)
        end)

        if success then
            print("Simple Webhook Sent Successfully!")
        else
            warn("Failed to send simple webhook:", response)
        end
    end

    -- SendMessageEMBED function with original signature, but fixed to work in Roblox
    function SendMessageEMBED(url, embed)
        if type(url) ~= "string" or url == "" then
            warn("SendMessageEMBED: Provided URL is invalid or empty. Not sending.")
            return
        end

        local http = HttpService -- Use the HttpService from the outer scope
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
        local body = http:JSONEncode(data)

        -- This is the crucial part that replaces 'request' with a functional equivalent
        local success, response = pcall(function()
            -- HttpService:PostAsync sends the data to the specified URL
            return http:PostAsync(url, body, true) -- The 'url' parameter is correctly used here
        end)

        if success then
            print("Embed Webhook Sent Successfully!")
        else
            warn("Failed to send embed webhook:", response)
        end
    end


    -- === Your Webhook Execution Logic ===

    local embed = {
        ["title"] = "JOKI DIMULAI",
        ["description"] = "Username : ||" .. username .. "||",
        ["color"] = 65280, -- Green color (decimal representation for #00FF00)
        ["fields"] = {
            {
                ["name"] = "Info Order",
                ["value"] = "Nomor Order : ``" .. no_order .. "``\nLink [Riwayat pesanan](https://tokoku.itemku.com/riwayat-pesanan/rincian/" .. new_string .. ")",
                ["inline"] = false
            },
            {
                ["name"] = "Info Joki",
                ["value"] = "Waktu joki dimulai : " .. os.date("%m-%d %H:%M:%S", wib_current_time) .. "\nWaktu joki selesai : " .. os.date("%m-%d %H:%M:%S", done_joki),
                ["inline"] = false
            }
        },
        ["footer"] = {
            ["text"] = "- " .. nama_store .. " ❤️"
        }
    }

    -- Call SendMessageEMBED using the webhook_discord variable (passed into this script)
    if webhook_discord ~= "" then
        SendMessageEMBED(webhook_discord, embed) -- Pass the correct webhook_discord URL
    else
        warn("Webhook URL is empty or invalid. Cannot send webhook.")
    end

end
