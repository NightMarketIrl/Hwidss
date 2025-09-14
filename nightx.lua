local GuncelVersion = "1.0.4" -- Version Num

local MenuSize = vec2(800, 500)
local MenuStartCoords = vec2(500, 500)
local TabSectionWidth = 150 

local MenuWindow = MachoMenuTabbedWindow("NightX", MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y, TabSectionWidth)
local menu = 1
MachoMenuSetAccent(MenuWindow, 93, 63, 211)
MachoMenuSetKeybind(MenuWindow, 0x2E)
