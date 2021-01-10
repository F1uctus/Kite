# Kite <img align="left" width=48 height=48 src="/%40Screenshots/Kite.jpg">

Initially, this skin was made to show [pyrmont](https://github.com/F1uctus/pyrmont) static skin generator possibilities.
Now it is high-level, adaptable, automated and practical suite for Rainmeter.

`@Resources/Config.inc` can be edited to use custom suite scale, colors, dark/light themes and English/Russian localizations.
With `ThemeSyncer` enabled, config values are changed according to current Windows theme and accent color.

### Requirements

- Place your GitHub feed key to the file `.\GitHub\Feed\token-github-feed.ignore.txt`

- Place your OpenWeatherMap API key to the file `.\Weather\token-openweathermap.ignore.inc` with format:
```
[Variables]
    token-openweathermap=YOUR_API_KEY
```

- If you are planning to customize this suite, `pyrmont` requires Python 3 on your machine. Python is used for GitHub feed scraping too.

- [FrostedGlass](https://github.com/TheAzack9/FrostedGlass) plugin.

- There is a micro C# program allowing to get Windows theme and accent color, so you'll need .NET Framework 4.7.2 or greater.

### Screenshots

Light:
![Kite](/%40Screenshots/Kite-1.0.3.png)

Dark:
![Kite](/%40Screenshots/Kite-1.0.3b.png)
