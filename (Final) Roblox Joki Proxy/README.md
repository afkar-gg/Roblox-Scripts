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

## 🛠️ Setup Instructions

### 1. Clone the Repo

```bash
git clone https://github.com/afkar-gg/bot/ afkar-proxy && cd afkar-proxy
```
### 2. Install Dependencies
```bash
npm install node-fetch@2 express
```
### 3. Create a config.json File
```bash
{
  "BOT_TOKEN": "your_discord_bot_token_here",
  "CHANNEL_ID": "your_default_channel_id_here"
}
```
> 🔐 Never share this file publicly.

### 4. Start the Proxy
```bash
node index.js
```
This will output a Cloudflare tunnel like:

🌍 Tunnel URL: https://yourname.trycloudflare.com
➡️ Ready: /send /check /complete

Use this URL in your Roblox UI script's config.


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
