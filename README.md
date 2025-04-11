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
- [ngrok](https://smee.io/) for local testing (optional)

---

## 📦 Installation

```bash
git clone https://github.com/eugeneidan/issue-estimator-bot.git
cd issue-estimator-bot
bundle install
