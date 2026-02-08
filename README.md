# Fivem-standalone-radio

A simple FiveM radio script that works in standalone or ESX and blocks blacklisted words in station names.

## Features
- Standalone or ESX command registration
- Word filtering for station names
- Dark orange NUI

## Installation
1. Drop this folder in your server resources.
2. Ensure it in your `server.cfg`:

```
ensure Fivem-standalone-radio
```

## Usage
- `/radio` to open the UI (configurable in `config.lua`).
- Use the UI to enter a station name and stream URL.
- Press Stop to end playback.

## Configuration
Edit `config.lua` to update the framework mode, command name, keybind, and blacklisted words.
