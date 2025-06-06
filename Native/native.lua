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
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
    print("Sent")
end


local url = "DISCORD_WEBHOOK"  -- discord webhook (optional)

coin_flip = math.random(0, 1) -- randomize key for evading blacklist (optional to do)
if coin_flip == 0 then
    if ToggleRandomKey then
        script_key = put-key-here;
        (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()
    else
        script_key = put-2key-here;
        (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()
    end
end

if LocalPlayer and ToggleWebhook then
    local playerName = LocalPlayer.Name
    SendMessage(url, "the script has executed successfully\nCurrent User : " .. playerName .. "") -- the thing in quotation mark are the message the bot will send to, so change it
    if OnLoop then
        task.wait(1)
    end
end
