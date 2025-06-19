-- A more compatible function to find the executor's HTTP request method
local function getHttpRequestFunction()
    if syn and syn.request then
        return syn.request
    elseif http and http.request then
        return http.request
    elseif request then
        return request
    end
    return nil -- Return nil if no function is found
end

local httpRequest = getHttpRequestFunction()

function SendMessage(url, message)
    -- Check if a valid request function was found
    if not httpRequest then
        warn("HTTP Request function (e.g., syn.request) not found.")
        return
    end

    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = message
    }
    local body = http:JSONEncode(data)
    
    -- Use the compatible httpRequest function
    local success, response = pcall(httpRequest, {
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })

    if success then
        print("Sent")
    else
        warn("Failed to send message:", response)
    end
end

function SendMessageEMBED(url, embed)
    -- Check if a valid request function was found
    if not httpRequest then
        warn("HTTP Request function (e.g., syn.request) not found.")
        return
    end

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

    -- Use the compatible httpRequest function
    local success, response = pcall(httpRequest, {
        Url = discord_webhook, -- Using the global discord_webhook variable as intended
        Method = "POST",
        Headers = headers,
        Body = body
    })

    if success then
        print("Sent Embed")
    else
        warn("Failed to send embed:", response)
    end
end
