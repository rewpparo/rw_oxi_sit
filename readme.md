
# Sitting script using ox_target
## Features :
- Simple to use configuration file
- Configure offset to line up the character
- Multiple sitting positions per prop
- Choose sitting scenario per prop
- Server side occupancy tracking (TODO)

## Zlib licence
```
Copyright (c) 2023 Rewpparo

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
```

## config.lua
Config.Seat is a key value table with the name of the prop as a key. That name can be obtained with ox_target's debug function (see ox_target's config file). Value is an array of the following elements :
- o : vec3 or array of vec3 with the offset of the seating positions relative to the prop. Usually +x is left, +y is back, +z is up. Default is (0.0, 0.0, 0.5) which is fine for a lot of seats.
- h : the orientation in degrees of the sitting position relative to the object. Default is 0
- s : the name of the scenario to use. Default is 'PROP_HUMAN_SEAT_BENCH', full list here : https://pastebin.com/6mrYTdQv Interesting scenarios include : PROP_HUMAN_SEAT_CHAIR, PROP_HUMAN_SEAT_CHAIR_UPRIGHT, PROP_HUMAN_SEAT_DECKCHAIR, PROP_HUMAN_SEAT_ARMCHAIR, PROP_HUMAN_SEAT_SUNLOUNGER
