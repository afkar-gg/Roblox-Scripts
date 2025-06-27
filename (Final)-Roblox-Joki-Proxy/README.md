# 🧠 Joki Discord Bot Proxy (Roblox ↔ Discord)

This project is a powerful bridge between **Roblox UI scripts** and a **Discord bot**, allowing seamless webhook-like interactions using a real bot instead of webhooks — perfect for Joki services, AFK farming monitors, or client status tracking.

> ✅ Built with Node.js, Express, and Cloudflare Tunnel  
> ✅ Roblox clients send Joki session data and live check-ins  
> ✅ Discord bot sends embeds and plain messages per user session  
> ✅ Auto-offline detection, session timers, and multi-user support

---

## 🚀 Features

- 🧾 `/send`: Starts a Joki session and posts an embed with start + end times  
- 📡 `/check`: Edits original message with heartbeat check timestamp  
- ✅ `/complete`: Marks the session complete with a thank-you embed  
- 🔴 Offline detection: Sends @everyone if a user misses 10 min heartbeat  
- 🧠 Multi-user support with unique message IDs  
- 🌐 Cloudflare Tunnel built-in for public access

---
File info :
- proxy server = index.js
- config channel id & bot token = config.json
- ui loadstring script = main.lua
---

## 🛠️ Setup Instructions (Termux)
### (Disclaimer) If you just downloaded termux, update and upgrade the apt
```bash
apt update && apt upgrade
```
### 1. Install Important Package
```bash
pkg install git nodejs cloudflared
```
### 2. Clone the Repo

```bash
git clone https://github.com/afkar-gg/bot/ afkar-proxy && cd afkar-proxy
```
### 3. Install Dependencies
```bash
npm install node-fetch@2 express
```
### 4. Create a config.json File
```bash
{
  "BOT_TOKEN": "your_discord_bot_token_here",
  "CHANNEL_ID": "your_default_channel_id_here"
}
```
> 🔐 Never share this file publicly.

### 5. Start the Proxy
```bash
node index.js
```
This will output a Cloudflare tunnel like:

🌍 Tunnel URL: https://yourname.trycloudflare.com
➡️ Ready: /send /check /complete

Use this URL in your Roblox UI script's config.

---
## Setup Instructions (Roblox)

### 1. Execute The Script 
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/(Final)-Roblox-Joki-Proxy/main.lua"))();
```
~ there's should be 4 text boxes :
- jam_selesai_joki -- how much hour the buyer bought
- nomor_order -- order number on itemku (OD******)
- nama_store -- store name for make the webhook looks legit
- proxy_url -- put the cloudflare tunnel url here
### Example :
![example](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/Readme-Assets/(Final)-Roblox-Joki-Proxy/Screenshot_2025_0627_121535_com.geniuscloud.overseasplatform.png)
> tip : the execute button would have a little delay to turn green. if it's not, you put the url wrong (try to put it like in the image)

- Should be look like this on Discord (after setup the roblox script)

![Discord](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/Readme-Assets/(Final)-Roblox-Joki-Proxy/IMG_20250627_115836.png)

---

🤖 Roblox UI Script Features

GUI built in Luau

Auto-saves config locally

Sends data to your Node proxy

Draggable, stylized UI

Loops /check every 5 minutes

Sends /complete after timer ends



---

📡 API Routes

Endpoint	Method	Description

/send	POST	Starts joki + sends embed
/check	POST	Edits original message (online)
/complete	POST	Sends a completion embed



---

💡 Future Improvements

/cancel endpoint to stop joki early

Web dashboard with status and timers

Save sessions to disk

Multi-order support per user

Role pings instead of @everyone



---

🙏 Credits

Built by Afkar and ChatGPT

Powered by Cloudflare Tunnel

Uses Discord Bot API

Roblox client uses HttpService, GUI and loadstring in Luau



---

📜 License

MIT — Free to use, modify and contribute.
