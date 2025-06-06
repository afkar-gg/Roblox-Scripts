local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local key = "put-key-here"
local 2key = "put-2key-here"
local dc = "DISCORD_WEBHOOK"

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


local url = "dc"  -- discord webhook (optional)

coin_flip = math.random(0, 1) -- randomize key for evading blacklist (optional to do)
if coin_flip == 0 then
    script_key = key;
    (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()
else
    script_key = 2key;
    (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()
end

if LocalPlayer then
    while true do
    local playerName = LocalPlayer.Name
    task.wait(120)
    SendMessage(url, "the script has executed successfully\nCurrent User : " .. playerName .. "") -- the thing in quotation mark are the message the bot will send to, so change it
end
