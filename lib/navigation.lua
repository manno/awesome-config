local ipairs = ipairs
local math = math
local capi =
{
    awesome = awesome,
    mouse = mouse,
    client = client,
    util = util,
    screen = screen
}

local tag    = require("awful.tag")
local client = require("awful.client")
local screen = require("awful.screen")

module("navigation")

-- Return true whether rectangle B is in the right direction
-- compared to rectangle A.
-- @param dir The direction.
-- @param gA The geometric specification for rectangle A.
-- @param gB The geometric specification for rectangle B.
-- @return True if B is in the direction of A.
local function is_in_direction(dir, gA, gB)
    if dir == "up" then
        return gA.y > gB.y
    elseif dir == "down" then
        return gA.y < gB.y
    elseif dir == "left" then
        return gA.x > gB.x
    elseif dir == "right" then
        return gA.x < gB.x
    end
    return false
end

-- Calculate distance between two points.
-- i.e: if we want to move to the right, we will take the right border
-- of the currently focused screen and the left side of the checked screen.
-- @param dir The direction.
-- @param gA The first rectangle.
-- @param gB The second rectangle.
-- @return The distance between the screens.
local function calculate_distance(dir, _gA, _gB)
    local gAx = _gA.x
    local gAy = _gA.y
    local gBx = _gB.x
    local gBy = _gB.y

    if dir == "up" then
        gBy = _gB.y + _gB.height
    elseif dir == "down" then
        gAy = _gA.y + _gA.height
    elseif dir == "left" then
        gBx = _gB.x + _gB.width
    elseif dir == "right" then
        gAx = _gA.x + _gA.width
    end

    return math.sqrt(math.pow(gBx - gAx, 2) + math.pow(gBy - gAy, 2))
end

-- Get the nearest rectangle in the given direction. Every rectangle is specified as a table
-- with 'x', 'y', 'width', 'height' keys, the same as client or screen geometries.
-- @param dir The direction, can be either "up", "down", "left" or "right".
-- @param recttbl A table of rectangle specifications.
-- @param cur The current rectangle.
-- @return The index for the rectangle in recttbl closer to cur in the given direction. nil if none found.
local function get_rectangle_in_direction(dir, recttbl, cur)
    local dist, dist_min
    local target = nil

    -- We check each object
    for i, rect in ipairs(recttbl) do
        -- Check geometry to see if object is located in the right direction.
        if is_in_direction(dir, cur, rect) then
            -- Calculate distance between current and checked object.
            dist = calculate_distance(dir, cur, rect)

            -- If distance is shorter then keep the object.
            if not target or dist < dist_min then
                target = i
                dist_min = dist
            end
        end
    end
    return target
end

--- Give the focus to a screen, and move pointer, by physical position relative to current screen.
-- @param dir The direction, can be either "up", "down", "left" or "right".
-- @param _screen Screen number.
local function screen_focus_bydirection(dir, _screen)
    local sel = _screen or capi.mouse.screen
    if sel then
        local geomtbl = {}
        for s = 1, capi.screen.count() do
            geomtbl[s] = capi.screen[s].geometry
        end
        local target = get_rectangle_in_direction(dir, geomtbl, capi.screen[sel].geometry)
        if target then
            return screen.focus(target)
        end
    end
end

--- Focus a client by the given direction.
-- @param dir The direction, can be either "up", "down", "left" or "right".
-- @param c Optional client.
local function bydirection(dir, c)
    local sel = c or capi.client.focus
    if sel then
        local cltbl = client.visible(sel.screen)
        local geomtbl = {}
        for i,cl in ipairs(cltbl) do
            geomtbl[i] = cl:geometry()
        end

        local target = get_rectangle_in_direction(dir, geomtbl, sel:geometry())

        -- If we found a client to focus, then do it.
        if target then
            capi.client.focus = cltbl[target]
        end
    end
end

--- Focus a client by the given direction. Moves across screens.
-- @param dir The direction, can be either "up", "down", "left" or "right".
-- @param c Optional client.
function global_bydirection(dir, c)
    local sel = c or capi.client.focus
    local scr = capi.mouse.screen
    if sel then
        scr = sel.screen
    end

    -- change focus inside the screen
    client.focus.bydirection(dir, sel)

    -- if focus not changed, we must change screen
    if sel == capi.client.focus then
        screen_focus_bydirection(dir, scr)
        if scr ~= capi.mouse.screen then
            local cltbl = client.visible(capi.mouse.screen)
            local geomtbl = {}
            for i,cl in ipairs(cltbl) do
                geomtbl[i] = cl:geometry()
            end
            local target = get_rectangle_in_direction(dir, geomtbl, capi.screen[scr].geometry)

            if target then
                capi.client.focus = cltbl[target]
            end
        end
    end
end


function movetagtoscreen(tags, offs)
    local sel = c or capi.client.focus
    local scr = capi.mouse.screen
    if sel then
        scr = sel.screen
    end

    local i = tag.getidx()
    local from_tag = tags[scr][i]
    local n = scr + offs
    if n > capi.screen.count() or n < 1 or n ==  scr then
        return
    end

    local to_tag = tags[n][i]
    if to_tag then
        for i, c in ipairs(from_tag:clients()) do
            client.movetotag(to_tag, c)
        end
    end
end

