# Yeet-Helper
Some basic "GUI" functionalty for the linux version of YeetPatch for voices of the void

A simple script to add some additional features and a more GUI interface to the linux version to YeetPatcher


# Requirments
- ZENITY (preinstalled in some linux distros like SteamOS - steam decks), if you dont have it, download it from your appropriate package manager beforehand
- YeetPatch, Installed in its correct location

## How to setup
- make sure that Yeetpatch folder is sitting next to the VotV.exe
also next to that VotV.exe place this Yeet-Helper.sh next to that exe, thats it!

# Features
- You can launch the game via wine from this script in BOTH dx11 (Default) OR the experimental Vulkan.
- Allows you to launch the game with mods IF you have set up modding support. this does NOT set anything up for you. but pretty much appends the launch args and also loads the correct wine dll  overrides IF you set them up 
- You can setup Yeetpatch paths like the game path and exe location DIRECTLY from within this script
- Check and download updates as well as display version. also places a indacator file next to the exe showing you what version you are on at a glance


<img width="477" height="392" alt="Screenshot_20260413_061307" src="https://github.com/user-attachments/assets/b63639a7-8e72-41b0-baf3-0d4280ef0e36" />



## ADVISORY ⚠️
sometimes with SOME shadow builds you cant download automatically as by design by yeet patcher
you might get an error like "[ERROR] No patch available for >Version<" meaning yeetpatcher itself or the game might need one manual update
