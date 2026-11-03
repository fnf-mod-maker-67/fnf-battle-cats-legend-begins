local locked = false
local lockX, lockY = 0, 0
local skipNext = false

function onEvent(name, value1, value2)
    if name == "MoveCam" then
        if value1 ~= '' or value2 ~= '' then
            lockX, lockY = tonumber(value1), tonumber(value2)
            locked = true
            skipNext = true
            setCameraFollowPoint(lockX, lockY)
            setCameraScroll(lockX, lockY)
        end
    end
end

function onUpdatePost(elapsed)
    if locked then
        setCameraFollowPoint(lockX, lockY)
    end
end

function onMoveCamera(focus)
    if skipNext then
        skipNext = false
    else
        locked = false
    end
end
