local Players = game:GetService("Players") -- Get the Players service
local LocalPlayer = Players.LocalPlayer -- Get the local player (the client playing the game)
local username = LocalPlayer.Name -- Get the player's username

local jam_selesai_joki = _G.jam_selesai_joki
local discord_webhook = _G.discord_webhook
local no_order = _G.no_order
local nama_store = _G.nama_store

local new_string = string.sub(no_order, 9) -- Start from the 9th character to get the numbers after "OD000000"


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
    ["title"] = "JOKI STARTED",
    ["description"] = "Username : ||" .. username.. "||", -- Concatenate "Username : " with the username variable
    ["color"] = 65280,
    ["fields"] = {
        {
            ["name"] = "Info Order",
            ["value"] = "Nomor Order : " ..no_order.. "\nLink [Riwayat pesanan](https://tokoku.itemku.com/riwayat-pesanan/rincian/" ..new_string.. ")"
        },
        {
            ["name"] = "Info Joki",
            ["value"] = "Time Joki Started : <t:" ..os.time().. ":f> (WIB Time)\nTime Joki Ended : <t:" .. os.time() + 3600 * jam_selesai_joki.. ":f> (WIB Time)"
        }
    },
    ["footer"] = {
        ["text"] = "- " ..nama_store.. " ❤️"
    }
}
SendMessageEMBED(discord_webhook, embed)
