-- ===== Simple Auth System =====

local AUTH_URL = "https://raw.githubusercontent.com/NightMarketIrl/Hwidss/refs/heads/main/Fuckyallniggers.json"
local AUTH_OK, AUTH_READY = false, false

-- JSON decode wrapper
local function json_decode_safe(str)
    local ok, result = pcall(function() return json.decode(str) end)
    if ok then return result end
    return nil
end

-- Get key from Macho loader
local function get_macho_key()
    if type(MachoAuthenticationKey) == "function" then
        local ok, val = pcall(MachoAuthenticationKey)
        if ok and val then return tostring(val) end
    end
    return ""
end

-- Convert ISO date string to timestamp
local function iso_to_time(iso)
    local y, m, d, H, M, S = iso:match("^(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)")
    return os.time{year=y, month=m, day=d, hour=H, min=M, sec=S}
end

-- Auth check thread
CreateThread(function()
    local key = get_macho_key()
    if key == "" then
        print("[AUTH] Missing Macho key.")
        AUTH_READY = true
        return
    end

    local response = MachoWebRequest(AUTH_URL)
    if not response or response == "" then
        print("[AUTH] Could not reach GitHub auth file.")
        AUTH_READY = true
        return
    end

    local data = json_decode_safe(response)
    if not data or not data.keys then
        print("[AUTH] Bad auth data.")
        AUTH_READY = true
        return
    end

    local entry = data.keys[key]
    if not entry then
        print("[AUTH] Invalid key.")
        AUTH_READY = true
        return
    end

    if os.time() > iso_to_time(entry.expires_at) then
        print("[AUTH] License expired.")
        AUTH_READY = true
        return
    end

    -- Success
    AUTH_OK, AUTH_READY = true, true
    print("[AUTH] Success! Expiry: " .. entry.expires_at)
end)

-- Require auth before menu builds
local function RequireAuth()
    if AUTH_READY and AUTH_OK then return true end
    if not AUTH_READY then
        local timeout = GetGameTimer() + 8000
        while not AUTH_READY and GetGameTimer() < timeout do
            Wait(50)
        end
    end
    if not AUTH_OK and type(MachoMenuNotification) == "function" then
        MachoMenuNotification("AUTH", "License invalid or expired.")
    end
    return AUTH_OK
end

-- ===== Only build your menu if authed =====
if not RequireAuth() then
    return
end

-- ===== Example menu build =====
local win = MachoMenuWindow(0.2, 0.2, 0.6, 0.6)
MachoMenuSetText(win, "Welcome to my Lua menu!")

local GuncelVersion = "1.0.4" -- Version Num

local MenuSize = vec2(800, 500)
local MenuStartCoords = vec2(500, 500)
local TabSectionWidth = 150 

local MenuWindow = MachoMenuTabbedWindow("NightX", MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y, TabSectionWidth)
local menu = 1
MachoMenuSetAccent(MenuWindow, 93, 63, 211)
MachoMenuSetKeybind(MenuWindow, 0x2E)
