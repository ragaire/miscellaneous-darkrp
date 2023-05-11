# gmod-propban
A SAM | Admin Mod Module to ban players from spawning props for a specified amount of time.

## Installation
Place propban.lua in lua/sam/modules

## In-Game Usage:
!propban user/steamid time reason
!unpropban user/steamid

## Other information
Uses SetNWInt("PropBanEndTime", 0), So you can use GetNWInt("PropBanEndTime") on huds or other things to show a display if you are prop banned.

view https://ronnyg.xyz to contact me
