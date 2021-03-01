function Initialize()
    accentColor = SKIN:GetVariable('color-accent')
    
    local cellsCount = SKIN:GetVariable('cells-count')
    xs = cellsCount - 1
    ys = cellsCount - 1
    activeCellsCount = 0

    RandomizeGrid()
end

function Update()
    activeCellsCount = 0

    local newCells = { }
    for x = 0, xs do
        newCells[x] = { }
        for y = 0, ys do
            local n = NeighboursCount(x, y)
            local cell = cells[x][y]

            if (n == 2 or n == 3) and cell then
                newCells[x][y] = true
                activeCellsCount = activeCellsCount + 1
            elseif (n < 1 or n > 3) and cell then
                newCells[x][y] = false
            elseif n == 3 and not cell then
                newCells[x][y] = true
                activeCellsCount = activeCellsCount + 1
            else
                newCells[x][y] = false
            end
        end
    end

    local equals = true
    for x = 0, xs do
        for y = 0, ys do
            equals = equals and cells[x][y] == newCells[x][y]
        end
    end

    if equals then 
        ResetGrid()
        RandomizeGrid()
        return
    end

    cells = newCells

    SKIN:Bang('!UpdateMeterGroup', 'Cells')
    SKIN:Bang('!RedrawGroup', 'Cells')
end

function NeighboursCount(x, y)
    local neighboursCount = 0
    for xi = -1, 1 do
        for yi = -1, 1 do
            local xn = math.fmod(x + xi, xs + 1)
            local yn = math.fmod(y + yi, ys + 1)
            if cells[ternary(xn >= 0, xn, xs)]
                    [ternary(yn >= 0, yn, ys)] then
                neighboursCount = neighboursCount + 1
            end
        end
    end
    return neighboursCount - (cells[x][y] and 1 or 0)
end

function ToggleCell(x, y)
    if cells[x][y] then
        cells[x][y] = false
        activeCellsCount = activeCellsCount - 1
    else
        cells[x][y] = true
        activeCellsCount = activeCellsCount + 1
    end
    SKIN:Bang('!UpdateMeterGroup', 'Cells')
    SKIN:Bang('!RedrawGroup', 'Cells')
end

function RandomizeGrid()
    cells = { }
    for x = 0, xs do
        cells[x] = { }
        for y = 0, ys do
            active = math.random() > 0.9
            cells[x][y] = active
            activeCellsCount = activeCellsCount + (active and 1 or 0)
        end
    end
    SKIN:Bang('!UpdateMeterGroup', 'Cells')
    SKIN:Bang('!RedrawGroup', 'Cells')
end

function ResetGrid()
    cells = { }
    for x = 0, xs do
        cells[x] = { }
        for y = 0, ys do
            cells[x][y] = false
        end
    end
    SKIN:Bang('!UpdateMeterGroup', 'Cells')
    SKIN:Bang('!RedrawGroup', 'Cells')
end

function GetCellColor(x, y)
    if not cells[x] or not cells[x][y] or string.len(accentColor) ~= 6 then
        return '10, 10, 10, 10'
    end
    r, g, b = Hex2RGB(accentColor)
    opacity = cells[x][y] and 255 or 10
    return r .. ',' .. g .. ',' .. b .. ',' .. opacity
end

function Hex2RGB(hex)
    return tonumber('0x' .. hex:sub(1, 2)),
           tonumber('0x' .. hex:sub(3, 4)),
           tonumber('0x' .. hex:sub(5, 6))
end

function ternary(condition, T, F)
    if condition then return T else return F end
end
