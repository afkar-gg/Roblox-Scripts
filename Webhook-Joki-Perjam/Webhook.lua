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
function SendMessageEMBED(discord_webhook, embed)
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
    local body = http:JSONEncode(data)
    local response = request({
        Url = discord_webhook,
        Method = "POST",
        Headers = headers,
        Body = body
    })
    print("Sent")
end


--Examples


local embed = {
    ["title"] = "JOKI DIMULAI",
    ["description"] = "Username : " .. username, -- Concatenate "Username : " with the username variable
    ["color"] = 65280,
    ["fields"] = {
        {
            ["name"] = "Info Order",
            ["value"] = "Nomor Order : " ..no_order.. "\nLink [Riwayat pesanan](https://tokoku.itemku.com/riwayat-pesanan/rincian/" ..new_string.. ")"
        },
        {
            ["name"] = "Info Joki",
            -- 2. Use the clean time variables defined above for Discord's dynamic timestamps.
            ["value"] = "Waktu joki dimulai : <t:" .. start_timestamp .. ":f>\nWaktu joki selesai : <t:" .. end_timestamp .. ":f>"
        }
    },
    ["footer"] = {
        ["text"] = "- " ..nama_store.. " ❤️"
    }
}

-- 3. Fixed the function call to use the correct 'discord_webhook' variable.
SendMessageEMBED(discord_webhook, embed)
