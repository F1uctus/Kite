--[[
This script checks if Windows accent color
has changed since the last check.
]]

function Initialize()
    measureColor = SKIN:GetMeasure("MeasureWindowsAccentColor")
end

function Update()
    oldColor = ReadFile("last-accent-color.txt")
    newColor = string.match(
        measureColor:GetStringValue(),
        "([%l%u0-9][%l%u0-9][%l%u0-9][%l%u0-9][%l%u0-9][%l%u0-9])"
    ) or oldColor
    if newColor ~= oldColor then
        print("AccentColorSyncer: color has changed from #" .. oldColor .. " to #" .. newColor)
        SKIN:Bang("!WriteKeyValue", "Variables", "color-accent", newColor, "#@#Config.inc")
        SKIN:Bang("!RefreshGroup", "AccentColorDependent")
        WriteFile("last-accent-color.txt", newColor)
    end
end

function ReadFile(path)
    path = SKIN:MakePathAbsolute(path)
    local f = io.open(path)
    if not f then
        print('AccentColorSyncer: unable to open ' .. path)
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