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
    -- This makes them accessible for calculations and webhook content
    local webhook_discord = passed_webhook_discord
    local jam_selesai_joki = passed_jam_selesai_joki
    local no_order = passed_no_order
    local nama_store = passed_nama_store

    -- === Input Validation and Defaults ===
    -- Ensure jam_selesai_joki is a valid number, default to 1 if not
    if type(jam_selesai_joki) ~= "number" or jam_selesai_joki < 0 then
        warn("Invalid or missing 'jam_selesai_joki'. Defaulting to 1.")
        jam_selesai_joki = 1
    end
    -- Ensure no_order is a string, default if empty
    if type(no_order) ~= "string" or no_order == "" then
        warn("Invalid or missing 'no_order'. Defaulting to 'N/A'.")
        no_order = "N/A"
    end
    -- Ensure nama_store is a string, default if empty
    if type(nama_store) ~= "string" or nama_store == "" then
        warn("Invalid or missing 'nama_store'. Defaulting to 'Default Store'.")
        nama_store = "Default Store"
    end
    -- Ensure webhook_discord is a string and looks like a URL
    if type(webhook_discord) ~= "string" or not webhook_discord:match("^https?://discord%.com/api/webhooks/%d+/%w+$") then
        warn("Invalid or missing 'webhook_discord' URL. Webhook will not be sent.")
        webhook_discord = "" -- Clear it to prevent sending to a bad URL
    end


    -- === Time Calculations ===
    local current_time = os.time()
    local wib_offset = 25200 -- UTC+7 (WIB - Western Indonesian Time) in seconds
    local wib_current_time = current_time + wib_offset

    -- Calculate done_joki correctly using the now-validated jam_selesai_joki
    local done_joki = wib_current_time + (3600 * jam_selesai_joki)

    -- Extract part of the order number for the link
    local new_string = string.sub(no_order, 9) -- Start from the 9th character

    -- Get username (handle cases where LocalPlayer might not be available, though it should be here)
    local username = LocalPlayer and LocalPlayer.Name or "UnknownUser"

    -- === Webhook Sending Functions (Using HttpService:PostAsync) ===

    -- Function to send a simple text message (fixed)
    -- (Your example uses SendMessageEMBED, but this is fixed for completeness)
    local function SendMessage(url_target, message_content)
        if url_target == "" then
            warn("SendMessage: Webhook URL is empty. Not sending.")
            return
        end
        local headers = { ["Content-Type"] = "application/json" }
        local data = { ["content"] = message_content }
        local body = HttpService:JSONEncode(data)
        
        local success, response = pcall(function()
            return HttpService:PostAsync(url_target, body, true) -- `true` enables compression (optional)
        end)

        if success then
            print("Simple Webhook Sent Successfully!")
        else
            warn("Failed to send simple webhook:", response)
        end
    end

    -- Function to send an embed message (fixed)
    local function SendMessageEMBED(url_target, embed_table)
        if url_target == "" then
            warn("SendMessageEMBED: Webhook URL is empty. Not sending.")
            return
        end
        local headers = { ["Content-Type"] = "application/json" }
        local data = { ["embeds"] = { embed_table } } -- Directly use the single embed table

        local body = HttpService:JSONEncode(data)

        local success, response = pcall(function()
            return HttpService:PostAsync(url_target, body, true) -- `true` enables compression (optional)
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
                ["inline"] = false -- Make this field take full width
            },
            {
                ["name"] = "Info Joki",
                ["value"] = "Waktu joki dimulai : " .. os.date("%m-%d %H:%M:%S", wib_current_time) .. "\nWaktu joki selesai : " .. os.date("%m-%d %H:%M:%S", done_joki),
                ["inline"] = false -- Make this field take full width
            }
        },
        ["footer"] = {
            ["text"] = "- " .. nama_store .. " ❤️"
        }
    }

    -- Call SendMessageEMBED with the actual webhook URL passed into the script
    if webhook_discord ~= "" then
        SendMessageEMBED(webhook_discord, embed)
    else
        warn("Webhook URL is empty or invalid. Cannot send webhook.")
    end

end
