local tS = game:GetService(string.reverse("ecivreStropeleT"))

local __id2f = {
    [116495829188952] = function()
        _G["__k_"..math.random()] = "TqDokjuYYMVIuPOBmYZKjpWCrtnGRmiU"
        (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()
    end,

    [126884695634066] = function()
        local url = table.concat({
            "https://raw.githubusercontent.com",
            "/AhmadV99/Speed-Hub-X/main/",
            "Speed%20Hub%20X.lua"
        })
        loadstring(game:HttpGet(url, true))()
    end,

    [70876832253163] = function()
        _G["__k_"..tick()] = "TqDokjuYYMVIuPOBmYZKjpWCrtnGRmiU"
        (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))()

        task.delay(240, function()
            local plr = game:GetService("Players").LocalPlayer
            if plr then
                tS:Teleport(116495829188952, plr)
            end
        end)
    end,
}

local __pid = game.PlaceId
if __id2f[__pid] then
    (function(f) f() end)(__id2f[__pid])
end