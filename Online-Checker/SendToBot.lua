local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local username = Players.LocalPlayer and Players.LocalPlayer.Name or "Unknown"
local proxy_url = _G.proxy_url

if not proxy_url or proxy_url == "" then
	warn("❌ proxy_url not set from UI.")
	return
end

local content = "Username: " .. username .. "\nLast Checked: <t:" .. os.time() .. ":R>"

local request = request or http_request or (syn and syn.request) or
	(HttpService.RequestAsync and function(opt)
		return HttpService:RequestAsync(opt)
	end)

if not request then
	warn("❌ Executor does not support HTTP requests.")
	return
end

local success, res = pcall(function()
	return request({
		Url = proxy_url .. "/send",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = HttpService:JSONEncode({ content = content })
	})
end)

if success and res and res.Success then
	print("✅ Message sent to bot proxy.")
else
	warn("❌ Failed to send message:", res and res.StatusCode, res and res.Body)
end