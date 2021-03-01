--[[
This script checks if Windows theme & accent color
has changed since the last check.
]]

function Initialize()
    measureColor = SKIN:GetMeasure("MeasureWindowsTheme")

    themePattern = "theme=(light)"
    colorPattern = "([%l%u0-9][%l%u0-9][%l%u0-9][%l%u0-9][%l%u0-9][%l%u0-9])"
end

function Update()
    local lastData = ReadFile("last-theme.ignore.txt")
    -- print(lastData)
    local lastTheme = string.match(lastData, themePattern) or "dark"
    local lastColor = string.match(lastData, colorPattern) or "ffffff"

    local newData = measureColor:GetStringValue()
    -- print(newData)
    local newTheme = string.match(newData, themePattern) or "dark"
    local newColor = string.match(newData, colorPattern) or lastColor

    local changed = false
    if newTheme ~= lastTheme then
        print("ThemeSyncer: theme has changed from " .. lastTheme .. " to " .. newTheme)
        SKIN:Bang("!WriteKeyValue", "Variables", "theme", newTheme, "#@#Config.inc")
        changed = true
    end
    if newColor ~= lastColor then
        print("ThemeSyncer: color has changed from #" .. lastColor .. " to #" .. newColor)
        SKIN:Bang("!WriteKeyValue", "Variables", "color-accent", newColor, "#@#Config.inc")
        changed = true
    end
    if changed then
        SKIN:Bang("!RefreshGroup", "OSThemeDependent")
        Wait(10)
        SKIN:Bang("!ZPosGroup", "-2", "OSThemeDependent")
    end
    WriteFile("last-theme.ignore.txt", newData)
end

function ReadFile(path)
    path = SKIN:MakePathAbsolute(path)
    local f = io.open(path)
    if not f then
        print('ThemeSyncer: unable to open ' .. path)
        return
    end
    local content = f:read('*all')
    f:close()
    return content
end

function WriteFile(path, content)
    path = SKIN:MakePathAbsolute(path)
    local f = io.open(path, 'w')
    if not f then
        print('AccentColorSyncer: unable to open ' .. path)
        return
    end
    f:write(content)
    f:close()
    return true
end

function Wait(milliseconds)
    -- Busy wait is bad, but there are not many better alternatives...
    local duration = os.time() + milliseconds / 1000
    while os.time() < duration do end
end
