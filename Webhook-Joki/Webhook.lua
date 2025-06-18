
local Players = game:GetService("Players") -- Get the Players service
local LocalPlayer = Players.LocalPlayer -- Get the local player (the client playing the game)
local username = LocalPlayer.Name -- Get the player's username

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
    ["description"] = "Username : " .. username.. "", -- Concatenate "Username : " with the username variable
    ["color"] = 65280,
    ["fields"] = {
        {
            ["name"] = "Info Order",
            ["value"] = "Nomor Order : " ..no_order.. "\nLink [Riwayat pesanan](https://tokoku.itemku.com/riwayat-pesanan/rincian/" ..new_string.. ")"
        },
        {
            ["name"] = "Info Joki",
            ["value"] = "Waktu joki dimulai : <t:" ..os.time().. ":f> \nWaktu joki selesai : <t:" .. os.time() * jam_selesai_joki.. ":f>"
        }
    },
    ["footer"] = {
        ["text"] = "- " ..nama_store.. " ❤️"
    }
}
SendMessageEMBED(url, embed)

