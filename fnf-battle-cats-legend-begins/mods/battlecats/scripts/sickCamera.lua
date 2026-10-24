-- Credits: MelodyTheFelony, Seqezzy
-- Inspired by: https://gamebanana.com/tools/10781

-- Camera Rotation settings
local ag = 1.5
local agSpeed = 0.5

-- Camera Movement settings
local Intensity = 10;
local followchars = true;
local startCam = false;

local camOffX = 0;
local camOffY = 0;

local dadPos = {0,0};
local bfPos = {0,0};
local gfPos = {0,0};

-- Initialization and events
function onSongStart()
    findCharCam()
    runTimer("canStartCamera", 0.4);
end

function onEvent(name, value1, value2)
    if name == "Change Character" then 
        findCharCam()
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "camOff" then
        followchars = false;
    elseif tag == "camOn" then
        followchars = true;
    end
    if tag == "canStartCamera" then
        startCam = true;
    end
end

-- Main camera logic
function onUpdatePost()
    -- Camera Rotation Reset Logic (Resets when character stops singing)
    if gfSection or mustHitSection ~= nil then
        local characterStr = (gfSection and 'gf' or (mustHitSection and 'boyfriend' or 'dad'))
        local checkAnim = getProperty(characterStr..'.animation.curAnim.name')
        if checkAnim and not string.find(checkAnim, 'sing') then
            doTweenAngle('camGameAngle', 'camGame', 0, agSpeed, 'linear')
        end
    end

    -- Camera Offset Based on Animation
    if followchars and startCam then
        local anim = getProperty('dad.animation.curAnim.name');
        if mustHitSection and not gfSection then
            anim = getProperty('boyfriend.animation.curAnim.name');
        end
        if gfSection then 
            anim = getProperty('gf.animation.curAnim.name');
        end

        if startsWith(anim, "singLEFT") then
            camOffY = 0;
            camOffX = 0 - Intensity;
        elseif startsWith(anim, "singRIGHT") then
            camOffY = 0;
            camOffX = Intensity;
        elseif startsWith(anim, "singUP") then
            camOffX = 0;
            camOffY = 0 - Intensity;
        elseif startsWith(anim, "singDOWN") then
            camOffX = 0;
            camOffY = Intensity;
        elseif startsWith(anim, "idle") then
            camOffX = 0;
            camOffY = 0;
        end
    end
   
    -- Camera Manual Math Boundary Lock
    if followchars and startCam then
        local cameraX = getProperty('camFollow.x');
        local cameraY = getProperty('camFollow.y');
        local bfX = getProperty('boyfriend.x');
        local bfY = getProperty('boyfriend.y');
        local dadX = getProperty('dad.x');
        local dadY = getProperty('dad.y');
        local gfX = getProperty('gf.x');
        local gfY = getProperty('gf.y');

        if mustHitSection and not gfSection and (bfPos[1] ~= nil and bfPos[2] ~= nil) then 
            cameraX = getMid(bfX , getProperty('boyfriend.width')) - 100;
            cameraY = getMid(bfY , getProperty('boyfriend.height')) - 100;
            cameraX = cameraX - bfPos[1];
            cameraY = cameraY + bfPos[2];
        elseif not mustHitSection and not gfSection and (dadPos[1] ~= nil and dadPos[2] ~= nil) then
            cameraX = getMid(dadX , getProperty('dad.width')) + 150;
            cameraY = getMid(dadY , getProperty('dad.height')) - 100;
            cameraX = cameraX + dadPos[1];
            cameraY = cameraY + dadPos[2];
        end
        
        if gfSection and (gfPos[1] ~= nil and gfPos[2] ~= nil) then 
            cameraX = getMid(gfX, getProperty('gf.width'));
            cameraY = getMid(gfY, getProperty('gf.height'));
            cameraX = cameraX + gfPos[1];
            cameraY = cameraY + gfPos[2];
        end
      
        setProperty('camFollow.x', cameraX + camOffX);
        setProperty('camFollow.y', cameraY + camOffY);
    end
end

-- Rotation triggers
local baseOffset = 50 -- 기준 오프셋 수치

function angle(d, m)
    if m == mustHitSection then
        -- 1. 스테이지의 기본 줌 수치를 불러와서 보정된 이동량 계산
        local zoom = getProperty('defaultCamZoom')
        if zoom <= 0 then zoom = 1 end -- 0으로 나누기 방지
        
        -- 줌이 낮을수록 더 크게 움직이도록 역선형 보정
        local moveOffset = baseOffset / zoom

        -- 2. 기존 각도 회전
        doTweenAngle('camGameAngle', 'camGame', ag * (d == 0 and -1 or d == 3 and 1 or 0), agSpeed, 'linear')
        
        -- 3. 보정된 오프셋으로 방향별 좌표 계산
        local targetX = (d == 0 and -moveOffset or (d == 3 and moveOffset or 0))
        local targetY = (d == 1 and moveOffset or (d == 2 and -moveOffset or 0))
        
        -- 4. 카메라 오프셋 트윈 적용
        doTweenX('camGameX', 'camGame.targetOffset', targetX, agSpeed, 'linear')
        doTweenY('camGameY', 'camGame.targetOffset', targetY, agSpeed, 'linear')
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    angle(direction, true)
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    angle(direction, false)
end

-- HELPER FUNCTIONS
function getMid(value, size)
    local fixSize = 0;
    if size ~= nil then
        fixSize = size;
    else
        fixSize = value; -- Fallback safety if size is missing
    end
    return value + (fixSize / 2);
end

function startsWith(String, Start)
    if String == nil then return false end
    return string.sub(String,1,string.len(Start))==Start
end

function findCharCam()
    local cameraDad = getProperty('dad.cameraPosition');
    if cameraDad ~= nil then
        dadPos[1] = cameraDad[1];
        dadPos[2] = cameraDad[2];
    end

    local cameraBf = getProperty('boyfriend.cameraPosition');
    if cameraBf ~= nil then
        bfPos[1] = cameraBf[1];
        bfPos[2] = cameraBf[2];
    end

    local cameraGf = getProperty('gf.cameraPosition');
    if cameraGf ~= nil then
        gfPos[1] = cameraGf[1];
        gfPos[2] = cameraGf[2];
    end
end