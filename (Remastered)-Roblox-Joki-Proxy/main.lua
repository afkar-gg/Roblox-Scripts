if not game:IsLoaded() then game.Loaded:Wait() end
local TeleportService = game:GetService("TeleportService")

local placeScripts = {

-- Dead Rails (Lobby)
[116495829188952] = function()
    script_key = "TqDokjuYYMVIuPOBmYZKjpWCrtnGRmiU"
    task.spawn(function()
        (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))
    end)
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/main/deadrails.lua"))()
    end)
end,

-- Steal a Brainrot (New Player)
[96342491571673] = function()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/main/sab.lua"))()
    end)
    task.wait(5)
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/master/NatHub.lua"))()
    end)
end,

-- Steal a Brainrot
[109983668079237] = function()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/main/sab.lua"))()
    end)
    task.wait(5)
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/master/NatHub.lua"))()
    end)
end,

-- 99 Nights In The Forest (Lobby)
[79546208627805] = function()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/main/99natf.lua"))()
    end)
    task.wait(30)
    getgenv().WebhookURL = "https://discord.com/api/webhooks/1379133678566768670/FoESNZDajE2aq8i00v1cedlbqk6NGsYim83bdIIVynkY4q877RzDyRpWUdrVjvOE_xY8"
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/main/Farm%20Diamond%20v2.lua"))()
    end)
end,

-- 99 Nights In The Forest (Game)
[126509999114328] = function()
    getgenv().WebhookURL = "https://discord.com/api/webhooks/1379133678566768670/FoESNZDajE2aq8i00v1cedlbqk6NGsYim83bdIIVynkY4q877RzDyRpWUdrVjvOE_xY8"
    getgenv().AutoFarm = true
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/main/Farm%20Diamond%20v2.lua"))()
    end)
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/main/99natf.lua"))()
    end)
    game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = "Afkar Script",
      Text = "Script loaded successfully.",
      Duration = 5
    })
end,

-- Grow a Garden
[126884695634066] = function()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/main/gag.lua"))()
    end)
    task.wait(5)
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end)
end,

-- Fish It
[121864768012064] = function()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/main/gag.lua"))()
    end)
    task.wait(5)
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mazino45/main/main/MainScript.lua"))()
    end)
end,

-- Dead Rails (Game)
[70876832253163] = function()
    script_key = "TqDokjuYYMVIuPOBmYZKjpWCrtnGRmiU"
    task.wait(5)
    task.spawn(function()
        (loadstring or load)(game:HttpGet("https://getnative.cc/script/loader"))
    end)
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/test/main/deadrails.lua"))()
    end)

    -- ⏳ Wait 4 minutes then teleport
    task.delay(240, function()
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
end