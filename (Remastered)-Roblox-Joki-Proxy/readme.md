# 📦 Roblox Joki Webhook Proxy (Remastered)

This project lets a Roblox executor script communicate with a Discord bot (via Node.js proxy), allowing live joki session tracking with:

- 🔐 Password-protected dashboard

- 📥 Web-based session configuration

- ⏱️ Reconnect-friendly execution & timer tracking

- 📲 Discord embed notifications

- 🟢 Watchdog-based offline detection



---

## 📁 Repo Contents

This repo contains:

- ✅ main.lua: Roblox UI script (executor-compatible)

- 🖼️ /screenshots/: reserved for interface previews (add your own!)

- 📄 README.md: you're looking at it 😉


> NOTE: The actual index.js and config.json for the proxy backend are located in a separate repo and are cloned during setup.


---

## 🚀 How to Set Up the Proxy (via Termux)

1. Install Requirements:
```bash
pkg install nodejs git cloudflared
```

2. Clone the Proxy Backend Only:

> ⚠️ You only need index.js and config.json from the backend repo.


```bash
git clone https://github.com/afkar-gg/bot-proxy.git Afkar-Proxy && cd Afkar-proxy
```

3. Install Dependencies:
```bash
npm install express node-fetch cookie-parser
```

### All in one :
```bash
pkg install nodejs git cloudflared -y && git clone https://github.com/afkar-gg/bot-proxy.git Afkar-Proxy && cd Afkar-proxy && npm install express node-fetch cookie-parser
```

4. Fill in config.json:
```bash
{
  // Example BOT TOKEN (get it from your bot application)
  "BOT_TOKEN": "YOUR_DISCORD_BOT_TOKEN_HERE",

  // Channel to send session notifications (start, complete, offline, etc.)
  "CHANNEL_ID": "YOUR_SART_JOB_CHANNEL_ID",

  // Channel where /send-job will post Job ID info
  "JOB_CHANNEL_ID": "YOUR_JOBID_CHANNEL_ID",

  // Dashboard login password (used at /login)
  "DASHBOARD_PASSWORD": "changeme"
}
```

5. Run the Proxy:
```bash
node index.js
```


✅ After running, you’ll see a command in the terminal at the bottom, you should copy that and paste it on another fresh terminal.

---

## 💻 Roblox Script Setup (Executor)

Paste this in your executor to launch the Roblox-side UI:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/main/(Remastered)-Roblox-Joki-Proxy/main.lua"))();
```

✅ This script only asks for your proxy URL. Then you can:

- 🟢 Start a joki session (linked to your dashboard)

- 📩 Send your current jobId to Discord



---

## 🖼 Screenshots

Here’s what you’ll see:

### 🎮 Roblox UI (ignore the quality) :

![pro](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/Readme-Assets/(Final)-Roblox-Joki-Proxy/IMG_20250708_001045.png)

### 🛠️ Dashboard Page:

- "/check" endpoint
![quality](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/Readme-Assets/(Final)-Roblox-Joki-Proxy/Screenshot_2025_0708_001133_com.kiwibrowser.browser.png)

- "/dashboard" endpoint
![sigma](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/Readme-Assets/(Final)-Roblox-Joki-Proxy/Screenshot_2025_0708_001149_com.kiwibrowser.browser.png)

### 📡 Discord Embed Example:

- Send embedded J*bId information from /send-job
![iwiaiaj](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/Readme-Assets/(Final)-Roblox-Joki-Proxy/Screenshot_2025_0708_003452.png)

- Start from /track
![deeznut](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/Readme-Assets/(Final)-Roblox-Joki-Proxy/Screenshot_2025_0707_202342.png)

- Checked from /check
![skibidi](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/Readme-Assets/(Final)-Roblox-Joki-Proxy/Screenshot_2025_0708_002202.png)

- Offline detected for not sending /check after 3 mins <br>
(image's on progress)

- Completed from /complete 
![lol](https://raw.githubusercontent.com/afkar-gg/Roblox-Scripts/refs/heads/Readme-Assets/(Final)-Roblox-Joki-Proxy/Screenshot_2025_0707_200859.png)

---

## 🙏 Credits

@Afkar (Discord) Project idea, Roblox-side scripting, dashboard flow 💡

Luau (ChatGPT)	Proxy backend architecture, scripting assistant 🧠

Node.js & Express	Web stack powering the proxy 🔌

Cloudflare Tunnel	Zero-config HTTPS access 🌐



---

## 💬 Support

If you want help or want to suggest features, feel free to DM Discord @afkar
