if not game:IsLoaded() then game.Loaded:Wait() end
local TeleportService = game:GetService("TeleportService")

local placeScripts = {
-- Dead Rails (Lobby)
[116495829188952] = function()
    script_key = "TqDokjuYYMVIuPOBmYZKjpWCrtnGRmiU"
    (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))();
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/deadrails.lua"))();
end,

-- Steal a Brainrot (New Player)
[96342491571673] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/sab.lua"))();
    task.wait(5)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatHub.lua"))();
end,

-- Steal a Brainrot
[109983668079237] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/sab.lua"))();
    task.wait(5)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatHub.lua"))();
end,

-- 99 Nights In The Forest (Lobby)
[79546208627805] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/99natf.lua"))();
    task.wait(30)
    getgenv().WebhookURL = "https://discord.com/api/webhooks/1390221900734533734/-zZqj8OROemNZ9iDolBbnxUdmXCAdKU8pF5x6ncwSBxzdKBWTI9HXRIil3EGVxaIAE6_"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Farm%20Diamond%20v2.lua"))()

end,

-- 99 Nights In The Forest (Game)
[126509999114328] = function()
    getgenv().WebhookURL = "https://discord.com/api/webhooks/1390221900734533734/-zZqj8OROemNZ9iDolBbnxUdmXCAdKU8pF5x6ncwSBxzdKBWTI9HXRIil3EGVxaIAE6_"
    task.wait(1)
 loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Farm%20Diamond%20v2.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/99natf.lua"))();
end,

-- Grow a Garden
[126884695634066] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/gag.lua"))();
    task.wait(5)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))();
end,  

-- Fish It (terpaksa nambah 🗿)
[121864768012064] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/gag.lua"))();
    task.wait(5)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/mazino45/main/refs/heads/main/MainScript.lua"))()
end,

-- Dead Rails (Game)
[70876832253163] = function()  
    script_key = "TqDokjuYYMVIuPOBmYZKjpWCrtnGRmiU"
    task.wait(5);
    (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))();
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/deadrails.lua"))();

    -- ⏳ Wait 2 minutes  
    task.delay(240, function()  
        -- 🚪 Teleport player to Dead Rails  
        local player = game:GetService("Players").LocalPlayer  
        if player then  
            TeleportService:Teleport(116495829188952, player)  
        end  
    end)  
end,

}

local runScript = placeScripts[game.PlaceId]
if runScript then
    task.wait(2)
    runScript()
else
    return
end
