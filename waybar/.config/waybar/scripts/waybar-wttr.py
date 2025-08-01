#!/usr/bin/env python
import json
from datetime import datetime

import requests

WEATHER_CODES = {
    '113': '☀️ ',
    '116': '⛅ ',
    '119': '☁️ ',
    '122': '☁️ ',
    '143': '☁️ ',
    '176': '🌧️',
    '179': '🌧️',
    '182': '🌧️',
    '185': '🌧️',
    '200': '⛈️ ',
    '227': '🌨️',
    '230': '🌨️',
    '248': '☁️ ',
    '260': '☁️ ',
    '263': '🌧️',
    '266': '🌧️',
    '281': '🌧️',
    '284': '🌧️',
    '293': '🌧️',
    '296': '🌧️',
    '299': '🌧️',
    '302': '🌧️',
    '305': '🌧️',
    '308': '🌧️',
    '311': '🌧️',
    '314': '🌧️',
    '317': '🌧️',
    '320': '🌨️',
    '323': '🌨️',
    '326': '🌨️',
    '329': '❄️ ',
    '332': '❄️ ',
    '335': '❄️ ',
    '338': '❄️ ',
    '350': '🌧️',
    '353': '🌧️',
    '356': '🌧️',
    '359': '🌧️',
    '362': '🌧️',
    '365': '🌧️',
    '368': '🌧️',
    '371': '❄️',
    '374': '🌨️',
    '377': '🌨️',
    '386': '🌨️',
    '389': '🌨️',
    '392': '🌧️',
    '395': '❄️ '
}
WEATHER_API = "https://wttr.in/{location}?format=j1"


def format_time(time):
    return time.replace("00", "").zfill(2)


def get_temp(temp_data, t_type="FeelsLike", scale="C"):
    return (temp_data[f"{t_type}{scale}"] + f"°{scale}").ljust(4)


def format_chances(hour):
    chances = {
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        "chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Wind"
    }
    conditions = []
    for event in chances.keys():
        if int(hour[event]) > 0:
            conditions.append(f"{chances[event]} {hour[event]}%")
    return ", ".join(conditions)


def main(location="Santa Barbara"):
    loc = location.replace(" ", "+")
    w_data = requests.get(WEATHER_API.format(location=loc)).json()
    curr_cond = w_data["current_condition"][0]
    curr_temp = get_temp(curr_cond)
    alt_curr_temp = get_temp(curr_cond, scale="F")

    # get text to display in waybar
    text = f" {WEATHER_CODES[curr_cond['weatherCode']]} {curr_temp}"
    alt = f" {WEATHER_CODES[curr_cond['weatherCode']]} {alt_curr_temp}"

    # get tooltip details
    tooltip = (
        f"<b>{curr_cond['weatherDesc'][0]['value']} {curr_temp} in {location}</b>\n"
        f"Feels like: {curr_temp}\n"
        f"Wind: {curr_cond['windspeedKmph']}Km/h\n"
        f"Humidity: {curr_cond['humidity']}%\n"
    )
    for i, day in enumerate(w_data['weather']):
        tooltip += f"\n<b>"
        if i == 0:
            tooltip += "Today, "
        if i == 1:
            tooltip += "Tomorrow, "
        tooltip += f"{day['date']}</b>\n"
        tooltip += f"⬆️ {get_temp(day, t_type='maxtemp')} ⬇️ {get_temp(day, t_type='mintemp')} "
        tooltip += f"🌅 {day['astronomy'][0]['sunrise']} 🌇 {day['astronomy'][0]['sunset']}\n"
        for hour in day['hourly']:
            if i == 0:
                if int(format_time(hour['time'])) < datetime.now().hour-2:
                    continue
            tooltip += (
                f"{format_time(hour['time'])}"
                f" {WEATHER_CODES[hour['weatherCode']]} {get_temp(hour)}"
                f" {hour['weatherDesc'][0]['value'].strip()}, {format_chances(hour)}\n"
            )
    formatted_data = {
        "text": text,
        "alt": alt,
        "tooltip": tooltip,
    }
    return formatted_data


if __name__ == "__main__":
    display_data = main()
    print(json.dumps(display_data))
