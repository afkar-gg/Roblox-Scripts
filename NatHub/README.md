Modified to send webhook and put config when executed

```lua
DISCORD_WEBHOOK = "YOUR-WEBHOOK-URL" -- your webhook url
ToggleWebhook = true -- turn on webhook or turn it off (false)
-- webhook message : The script has executed successfully\nCurrent User : " .. playerName .. "

getgenv().Configs = {
    ["AutoPlant"] = {
        ["Enabled"] = false, -- true/false
    },
    ["AutoCollect"] = {
        ["Enabled"] = true, -- true/false
        ["Teleport"] = false, -- true/false
        ["Filter"] = {
            ["Enabled"] = true,
            ["Mutations"] = {Pollinated}, -- { "Frozen", "Shocked" }
            ["Type"] = "whitelist", -- whitelist/blacklist
        },
        ["CollectSeed"] = false, -- true/false
    },
    ["AutoSell"] = {
        ["Enabled"] = false,
        ["Delay"] = 60, -- delay in seconds
    },
    ["AutoBuy"] = {
        ["Enabled"] = false, -- true/false
        ["Seed"] = {"Mango", "Beanstalk", "Coconut", "Dragon Fruit", "Grape", "Pepper", "Mushroom", "Cacao"}, -- { "Carrot", "Beanstalk" }
        ["Gear"] = {}, -- { "Watering Can", "Master Sprinkler" }
        ["Honey"] = {"Bee Egg", "Flower Seed Pack"}, -- { "Bee Egg", "Bee Crate" }
        ["CosmeticCrate"] = {}, -- { "Sign Crate", "Common Gnome Crate" }
        ["CosmeticItem"] = {}, -- { "Hay Bale", "Wood Pile" }
    },
    ["Pets"] = {
        ["AutoHatch"] = true, -- true/false
        ["AutoPickup"] = false, -- true/false
        ["AutoFeed"] = {
            ["Enabled"] = false, -- true/false
            ["Pets"] = {}, -- { "Dragonfly" },
            ["Foods"] = {}, -- { "Beanstalk" }
            ["Delay"] = 5, -- delay in minutes
        }
    },
    ["AutoWatering"] = {
        ["Enabled"] = false, -- true/false
        ["Plants"] = {}, -- { "Moon Mango", "Candy Blossom" }
        ["Delay"] = 60, -- delay in seconds
    },
    ["Quest"] = {
        ["GivePollinated"] = true, -- true/false
        ["ClaimHoney"] = true, -- true/false
    },
    ["Visual"] = {
        ["ShowToolPrice"] = false, -- true/false
        ["ShowInventoryPrice"] = false, -- true/false
    }
}
loadstring(game:HttpGet"https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/NatHub/NatHub.lua")();
```
