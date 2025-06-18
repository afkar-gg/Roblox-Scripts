-- Suggested content for Webhook.lua (This is what you should put at your GitHub URL)
-- This script is designed to be loaded by `loadstring` and then called as a function.

return function(
    passed_webhook_discord,     -- The webhook URL from your UI
    passed_jam_selesai_joki,    -- The "jam_selesai_joki" value from your UI
    passed_no_order,            -- The "no_order" value from your UI
    passed_nama_store           -- The "nama_store" value from your UI
)
    print("Webhook.lua: Script started execution.") -- Debug Print
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Assign the passed arguments to local variables within this script's scope
    local webhook_discord = passed_webhook_discord
    local jam_selesai_joki = passed_jam_selesai_joki
    local no_order = passed_no_order
    local nama_store = passed_nama_store

    -- === Input Validation and Defaults ===
    if type(jam_selesai_joki) ~= "number" or jam_selesai_joki < 0 then
        warn("Webhook.lua: Invalid or missing 'jam_selesai_joki'. Defaulting to 1.")
        jam_selesai_joki = 1
    end
    if type(no_order) ~= "string" or no_order == "" then
        warn("Webhook.lua: Invalid or missing 'no_order'. Defaulting to 'N/A'.")
        no_order = "N/A"
    end
    if type(nama_store) ~= "string" or nama_store == "" then
        warn("Webhook.lua: Invalid or missing 'nama_store'. Defaulting to 'Default Store'.")
        nama_store = "Default Store"
    end
    -- More robust URL validation and warning
    local is_url_valid = type(webhook_discord) == "string" and webhook_discord:match("^https?://discord%.com/api/webhooks/%d+/%w+$")
    if not is_url_valid then
        warn("Webhook.lua: Invalid or missing 'webhook_discord' URL. Webhook will NOT be sent to Discord.")
        webhook_discord = "" -- Clear it to prevent sending to a bad URL
    end


    -- === Time Calculations ===
    local current_time = os.time()
    local wib_offset = 25200 -- UTC+7 (WIB - Western Indonesian Time) in seconds
    local wib_current_time = current_time + wib_offset
    local done_joki = wib_current_time + (3600 * jam_selesai_joki)

    local new_string = string.sub(no_order, 9)

    local username = LocalPlayer and LocalPlayer.Name or "UnknownUser"

    -- === Webhook Sending Functions ===

    function SendMessage(url, message)
        print("SendMessage: Attempting to send simple message.") -- Debug Print
        if type(url) ~= "string" or url == "" then
            warn("SendMessage: Provided URL is invalid or empty. Cannot send.")
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
            print("SendMessage: Simple Webhook Sent Successfully! Response:", response) -- Debug Print Success
        else
            warn("SendMessage: Failed to send simple webhook. Error:", response) -- Debug Print Error
        end
    end

    function SendMessageEMBED(url, embed)
        print("SendMessageEMBED: Attempting to send embed message.") -- Debug Print
        if type(url) ~= "string" or url == "" then
            warn("SendMessageEMBED: Provided URL is invalid or empty. Cannot send.")
            return
        end

        local http = HttpService
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
        print("SendMessageEMBED: Sending to URL:", url) -- Debug Print URL

        local success, response = pcall(function()
            return http:PostAsync(url, body, true)
        end)

        if success then
            print("SendMessageEMBED: Embed Webhook Sent Successfully! Response:", response) -- Debug Print Success
        else
            warn("SendMessageEMBED: Failed to send embed webhook. Error:", response) -- Debug Print Error
        end
    end


    -- === Your Webhook Execution Logic ===

    local embed = {
        ["title"] = "JOKI DIMULAI",
        ["description"] = "Username : ||" .. username .. "||",
        ["color"] = 65280,
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

    print("Webhook.lua: Checking webhook_discord URL before sending. Current URL:", webhook_discord) -- Debug Print

    if webhook_discord ~= "" then
        SendMessageEMBED(webhook_discord, embed)
    else
        warn("Webhook.lua: Final check: Webhook URL is empty or invalid. Cannot send webhook.") -- Debug Print
    end
    print("Webhook.lua: Script finished execution.") -- Debug Print

end
