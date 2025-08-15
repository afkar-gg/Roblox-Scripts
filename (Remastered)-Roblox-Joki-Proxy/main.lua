if not game:IsLoaded() then game.Loaded:Wait() end
local TeleportService = game:GetService("TeleportService")

local placeScripts = {
[116495829188952] = function()
    script_key = "TqDokjuYYMVIuPOBmYZKjpWCrtnGRmiU"
    (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))();
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/deadrails.lua"))();
end,

[126884695634066] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/refs/heads/main/gag.lua"))();
    task.wait(5)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))();
end,  

[70876832253163] = function()  
    script_key = "TqDokjuYYMVIuPOBmYZKjpWCrtnGRmiU"
    task.wait(5)  
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
