# 🔗 Roblox J*b ID → Discord Webhook Sender

Send your **current Roblox Job ID** (with join link) directly to a **Discord webhook** using a simple in-game GUI.

Built for **executors**, this tool is perfect for:
- 📌 Saving private servers
- 📡 Sending job info to Discord
- 🔒 Personal use tracking

---

## 🎮 Features

- ✅ Executor-compatible
- ✅ Send current game `JobId` and join link
- ✅ Simple drag-and-drop GUI
- ✅ Automatically saves webhook URL using `writefile`
- ❌ No extra dependencies, no server needed

---

## 📸 Screenshot

> *(later or never)*

---

## 📜 Script 
~ Loadstring :
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/main/Webhook-Current-JbId/main.lua"))()
```

---

## 🧩 How It Works

This script fetches your:
- `game.JobId`
- `game.PlaceId`
- Builds a clickable link like: https://www.roblox.com/games/1234567890?jobId=ABCDEF123456

Then sends it via `http_request` to your Discord webhook.

---

## 📦 Installation

1. Use any Roblox executor (Synapse, Fluxus, etc.)
2. Run the full script inside a LocalScript or autoexec
3. Paste your Discord webhook into the textbox
4. Press **Send Job ID**
5. Profit 🎉

> Your webhook is saved to `jobhook_config.json` for next time!

---

## 💬 Example Embed

![Embed example](https://fake.link/your-screenshot.png)

---

📂 Files

File	Description

main.lua	Main script (GUI + webhook logic)
jobhook_config.json	Auto-generated webhook config

---

🙏 Credits

Script by Afkar

Assistant: ChatGPT
