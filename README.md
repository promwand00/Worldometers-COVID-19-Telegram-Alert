# Worldometers COVID-19 Telegram Alert

Data source: <https://worldometers.info/coronavirus/>

### Based:
- BASH
- Python (command included in Shell Script)
- Curl

### Variable Settings:
- `COUNTRY` - Set country and follow Worldometers format (example: Indonesia)
- `TELEGRAM_API_KEY` - Set your Telegram Bot API KEY
- `TELEGRAM_CHAT_ID` - Set your Chat ID

### Run:
```
bash covid-19-telegram-alert.sh
```

### Crontab Setting:
```
* * * * * bash /path-to/covid-19-telegram-alert.sh
```
