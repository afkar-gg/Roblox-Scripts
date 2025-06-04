local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if LocalPlayer then
    local playerName = LocalPlayer.Name
    print("Hello, " .. playerName .. "!")
end

local MarketplaceService = game:GetService("MarketplaceService")

local success, productInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Place)
end)


-- webhook stuff (dw im not gonna hack u)

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
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end


local url = "DISCORD_WEBHOOK"  -- discord webhook (optional)

while true do
    if LocalPlayer and ToggleWebhook then
        local playerName = LocalPlayer.Name
        task.wait(120)
        SendMessage(url, "the script has executed successfully\nCurrent User : " .. playerName .. "") -- the thing in quotation mark are the message the bot will send to, so change it
    end
end

loadstring(game:HttpGet("https://get.nathub.xyz/loader"))();