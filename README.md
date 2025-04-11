# time-estimate-tracker
Simple Github App to remind issue creator to add time estimate
# 🧠 GitHub Issue Estimator Bot

A GitHub App built in Ruby using Sinatra that listens for new issues and ensures they include an `Estimate: <number of hours>` line. If an estimate is missing, the app automatically posts a comment requesting it.

---

## ✨ Features

- Listens for `issues` `opened` events.
- Parses the issue body for `Estimate: X`.
- Posts a comment if the estimate is missing.

---

## 🛠 Requirements

- Ruby 2.7+
- Bundler
- GitHub App credentials (App ID + Private Key)
- [smee](https://smee.io/) for local testing (optional)

---

## 📦 Installation

```bash
git clone https://github.com/eugeneidan/time-estimator-tracker.git
cd time-estimator-tracker
bundle install

```
## Configuration
Create .env file in the root directory

Put your downloaded github private key in /config

GITHUB_APP_ID=your_app_id_here
GITHUB_PRIVATE_KEY_PATH=./config/private-key.pem
WEBHOOK_SECRET=your_webhook_secret


config/private-key.pem

🚀 Creating the GitHub App
Visit: https://github.com/settings/apps

Click "New GitHub App"

✅ Configuration
App Name: issue-estimator-bot

Homepage URL: http://localhost:4567

Webhook URL: Will be updated later with ngrok

Webhook Secret: Use a strong password and match it with your .env's WEBHOOK_SECRET

✅ Permissions
Repository → Issues → Read & write

✅ Subscribe to Events
Issues

Click Create GitHub App

Download the private key and save it to config/private-key.pem

Copy the App ID and paste it in your .env

▶️ Running the Server
Start the webhook listener:

bash
Copy
Edit
ruby webhooks/server.rb
🌐 Exposing with ngrok (For Local Testing)
bash
Copy
Edit
ngrok http 4567
Update your GitHub App's Webhook URL to:

arduino
Copy
Edit
https://<your-ngrok-url>/webhook
📥 Installing the App on a Repository
Go to: https://github.com/apps/YOUR_APP_NAME/installations

Click Install and select your test repository.

🧪 Testing the Bot
Create a new issue without an estimate:

text
Copy
Edit
This task is missing an estimate.
The app will respond:

⚠️ Please provide an Estimate: <number of hours> in the issue description.
