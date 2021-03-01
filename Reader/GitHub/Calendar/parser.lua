--[[
Example of input:
{"data":[
0,0,0,0,0,1,0,0,0,0,0,0,1,2,2,0,0,4,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
6,0,1,1,0,0,0,0,0,0,0,0,0,1,17,0,4,0,0,0,0,0,0,0,0,0,0,2,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,1,0,0,1,
0,0,0,2,12,0,0,2,0,0,0,0,0,0,0,0,0,3,0,0,0,1,7,2,0,2,5,0,
0,1,6,0,0,0,0,15,4,0,0,3,0,3,0,0,0,0,0,4,14,5,0,0,1,0,0,1,
2,0,0,10,13,8,7,5,0,5,0,0,10,16,12,0,2,5,22,12,9,13,2,18,
0,5,8,1,0,0,2,1,3,0,3,0,12,8,26,5,0,3,3,0,8,19,6,10,4,1,1,
2,5,0,0,1,0,3,6,0,0,0,2,0,1,0,0,2,4,0,1,0,0,1,0,0,2,2,0,0,1,1,4,1,3,1,1,1]}
]]

function Initialize()
    measureGraph = SKIN:GetMeasure("MeasureGraph")
    accentColor = SKIN:GetVariable("color-accent")
    blocks = {}
    maxCount = 0
    contributionsSum = 0
    for x = 1, 53 do
        blocks[x] = { }
    end
end

function Update()
    local inputJson = measureGraph:GetStringValue()
    local x = 1
    local y = 1
    local aux = inputJson:gsub("%d", "\1")
    contributionsSum = 0
    for b, e in aux:gmatch("()\1+()") do
        local contributionsCount = tonumber(inputJson:sub(b, e - 1))
        if contributionsCount > maxCount then
            maxCount = contributionsCount
        end
        contributionsSum = contributionsSum + contributionsCount
        blocks[x][y] = contributionsCount
        y = y + 1
        if y == 8 then
            y = 1
            x = x + 1
        end
    end    
    SKIN:Bang("!UpdateMeterGroup", "Contributions")
    SKIN:Bang("!RedrawGroup", "Contributions")
end

function Hex2RGB(hex)
    return tonumber("0x" .. hex:sub(1, 2)),
           tonumber("0x" .. hex:sub(3, 4)),
           tonumber("0x" .. hex:sub(5, 6))
end

function GetColor(x, y)
    if not blocks[x] or not blocks[x][y] or string.len(accentColor) ~= 6 then
        return "10101020"
    end
    r, g, b = Hex2RGB(accentColor)
    opacity = Clamp(math.ceil(blocks[x][y] / maxCount * 255) + 5, 0, 255)
    return r .. ',' .. g .. ',' .. b .. ',' .. opacity
end

function Clamp(num, lower, upper)
    assert(
        num and lower and upper,
        'error: Clamp(' .. num .. ', ' .. lower .. ', ' .. upper .. ')'
    )
    return math.max(lower, math.min(upper, num))
end

function GetSum()
    return contributionsSum
end