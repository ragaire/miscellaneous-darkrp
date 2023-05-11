# gmod-propban
A SAM | Admin Mod Module to ban players from spawning props for a specified amount of time.

## Installation
Place propban.lua in lua/sam/modules

## In-Game Usage:
!propban user/steamid time reason
!unpropban user/steamid

## Other information
### About the module
Uses SetNWInt("PropBanEndTime", 0), So you can use GetNWInt("PropBanEndTime") on huds or other things to show a display if you are prop banned. Bad practice? i dont know. It works and it useful for hud displays.

view https://ronnyg.xyz to contact me

### SAM | Admin Mod
https://www.gmodstore.com/market/view/sam
