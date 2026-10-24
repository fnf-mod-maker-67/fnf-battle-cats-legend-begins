local useEditor = false

local sliders = 
{
    --name     val  x   y   wid  hei  min  max  dragging  color
    {'overlayR', 0, 50, 50, 200, 10,  0,   1,   false, "0xFFFF0000"},
    {'overlayG', 0, 50, 100, 200, 10,  0,   1,   false , "0xFF00FF00"},
    {'overlayB', 0, 50, 150, 200, 10,  0,   1,   false, "0xFF0000FF"},
    {'overlayA', 0, 50, 200, 200, 10,  0,   1,   false, "0xFFAAAAAA"},

    {'satinR', 0, 300, 50, 200, 10,  0,   1,   false, "0xFFFF0000"},
    {'satinG', 0, 300, 100, 200, 10,  0,   1,   false , "0xFF00FF00"},
    {'satinB', 0, 300, 150, 200, 10,  0,   1,   false, "0xFF0000FF"},
    {'satinA', 0, 300, 200, 200, 10,  0,   1,   false, "0xFFAAAAAA"},

    {'innerR', 0, 550, 50, 200, 10,  0,   1,   false, "0xFFFF0000"},
    {'innerG', 0, 550, 100, 200, 10,  0,   1,   false , "0xFF00FF00"},
    {'innerB', 0, 550, 150, 200, 10,  0,   1,   false, "0xFF0000FF"},
    {'innerA', 0, 550, 200, 200, 10,  0,   1,   false, "0xFFAAAAAA"},

    {'innerAngle', 0, 800, 50, 200, 10,  0,   360,   false, "0xFFAAAAAA"},
    {'innerDistance', 20, 800, 100, 200, 10,  0,   50,   false, "0xFFCCCCCC"}
}

function onCreatePost()
    initLuaShader('RTXLighting')
    
    -- 기본 캐릭터 및 배경 태그 리스트
    local allTargets = {'boyfriend', 'dad', 'gf', 'bgTag_noul', 'bgTag_night', 'bgTag_gris', 'bgTag_desert', 'bgTag_moon'}

    for _, tag in ipairs(allTargets) do
        if tag == 'boyfriend' or tag == 'dad' or tag == 'gf' then
            setSpriteShader(tag, 'RTXLighting')
        end

        setShaderFloatArray(tag, 'overlayColor', {0.0, 0.0, 0.0, 0.0})
        setShaderFloatArray(tag, 'satinColor', {0.0, 0.0, 0.0, 0.0})
        setShaderFloatArray(tag, 'innerShadowColor', {0.0, 0.0, 0.0, 0.0})
        setShaderFloat(tag, 'innerShadowAngle', 0.0)
        setShaderFloat(tag, 'innerShadowDistance', 20)
    end

    local didSetData = false

    local eventsLength = getProperty('eventNotes.length')
    for i = 0,eventsLength-1 do 
        local eventName = getPropertyFromGroup('eventNotes', i, 'event')
        if eventName == 'Open RTX Editor' then
            useEditor = true
        elseif eventName == "Set RTX Data" then
            if not didSetData or true then 
                didSetData = true 
                setRTXData(getPropertyFromGroup('eventNotes', i, 'value1'))
            end
        end
    end

    if useEditor then 
        createEditorHUD()
        setProperty('cpuControlled', true)
        setProperty('camHUD.visible', false)
        addHaxeLibrary('Clipboard', 'lime.system')
    end 
end

function onEvent(tag, val1, val2)
    if tag == "Set RTX Data" then
        setRTXData(val1)
    elseif tag == 'Change Character' then
        setSpriteShader('boyfriend', 'RTXLighting')
        setSpriteShader('dad', 'RTXLighting')
        setSpriteShader('gf', 'RTXLighting')
        updateShader()
    end
end

function onEndSong()
    if useEditor then 
        setProperty('endingSong', false)
        return Function_Stop;  
    end
    return Function_Continue;
end

--string split
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function setRTXData(dataStr)
    local data = split(dataStr, ",")
    for i = 1, #data do
        sliders[i][2] = tonumber(data[i]) 
    end
    updateShader()
end

local mouseWidth = 20
local sliderWidth = 10

function createEditorHUD()
    for i = 1, #sliders do 
        local data = sliders[i]

        makeLuaSprite(data[1].."back", "", data[3], data[4])
        makeGraphic(data[1].."back", data[5], data[6], data[10])
        setObjectCamera(data[1].."back", 'other')
        addLuaSprite(data[1].."back", true)

        makeLuaSprite(data[1].."slider", "", data[3], data[4]-(data[6]*0.5))
        makeGraphic(data[1].."slider", sliderWidth, data[6]*2, '0xFFFFFFFF')
        setObjectCamera(data[1].."slider", 'other')
        addLuaSprite(data[1].."slider", true)

        makeLuaText(data[1]..'text', "test", data[5], data[3], data[4]-20)
        setObjectCamera(data[1].."text", 'other')
        addLuaText(data[1]..'text')
    end

    makeLuaText("CopyText", "Click Here to copy data to clipboard", 0, 50, 650)
    setObjectCamera("CopyText", 'other')
    addLuaText("CopyText")

    makeLuaSprite("mouse", "", 0, 0)
    makeGraphic("mouse", mouseWidth, mouseWidth, '0xFFAAAAAA')
    setObjectCamera("mouse", 'other')
    addLuaSprite("mouse", true)
end

function pointOverlaps(obj, mouseX, mouseY)
    local x = getProperty(obj..".x")
    local y = getProperty(obj..".y")
    local w = getProperty(obj..".width")
    local h = getProperty(obj..".height")
    return (mouseX+mouseWidth > x) and (mouseX < x + w) and (mouseY+mouseWidth > y) and (mouseY < y + h);
end

function remapToRange(value, start1, stop1, start2, stop2)
    return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1))
end

function onUpdate(elapsed)
    if useEditor then 
        updateEditor(elapsed)
    end
    
    -- [핵심] 1절/2절 언제든 곡 중간에 dad2가 생성되는 즉시 실시간 감지하여 쉐이더를 부착하고 수치를 초기화합니다.
    runHaxeCode([[
        if (game.dad2 != null && game.dad2.shader == null) {
            var targetShader = game.runtimeShaders.get('RTXLighting');
            if (targetShader != null) {
                game.dad2.shader = targetShader;
                game.callOnLuas('updateShader', []); // 생성 프레임에 즉시 쉐이더 수치 동기화
            }
        }
    ]])
end

function updateEditor(elapsed)
    setProperty('camHUD.zoom', 1)

    local mouseX = getMouseX()
    local mouseY = getMouseY()
    local justClicked = mouseClicked("")
    local justReleased = mouseReleased("")

    setProperty('mouse.x', mouseX)
    setProperty('mouse.y', mouseY)

    for i = 1, #sliders do 
        local data = sliders[i]

        setProperty(data[1].."slider.x", remapToRange(data[2], data[7], data[8], data[3], data[3]+data[5])) 

        local overlapsSlider = pointOverlaps(data[1].."slider", mouseX, mouseY)
        local overlapsBack = pointOverlaps(data[1].."back", mouseX, mouseY)

        if overlapsSlider or overlapsBack then 
            setProperty(data[1].."slider.color", getColorFromHex("AAAAAA"))
        else 
            setProperty(data[1].."slider.color", getColorFromHex("FFFFFF"))
        end

        if (overlapsSlider or overlapsBack) and justClicked then
            sliders[i][9] = true
        elseif justReleased then 
            sliders[i][9] = false
        end

        local snapToMouse = sliders[i][9]

        if snapToMouse then 
            local newPos = mouseX
            if mouseX <= data[3] then 
                newPos = data[3]
            elseif mouseX >= data[3]+data[5] then 
                newPos = data[3]+data[5]
            end
            
            setProperty(data[1].."slider.x", newPos)
            data[2] = remapToRange(newPos, data[3], data[3]+data[5], data[7], data[8]) 
        end

        setTextString(data[1]..'text', data[1]..": "..(math.floor(data[2]*100)/100))
    end

    if pointOverlaps("CopyText", mouseX, mouseY) then 
        setTextColor("CopyText", "0xFFAAAAAA")
        if justClicked then 
            local dataStr = ""
            for i = 1, #sliders do 
                dataStr = dataStr..sliders[i][2]
                if i < #sliders then 
                    dataStr = dataStr..","
                end
            end
            runHaxeCode("Clipboard.text = '"..dataStr.."';")
            playSound("confirmMenu")
        end
    else 
        setTextColor("CopyText", "0xFFFFFFFF")
    end

    updateShader()
end

function updateShader()
    local allTargets = {'boyfriend', 'dad', 'gf', 'bgTag_noul', 'bgTag_night', 'bgTag_gris', 'bgTag_desert', 'bgTag_moon'}
    
    -- 1. 루아가 정상 인식하는 원본 타겟 수치 적용
    for _, tag in ipairs(allTargets) do
        if getProperty(tag .. '.exists') then
            if currentBg == 'white' and (tag == 'boyfriend' or tag == 'dad' or tag == 'gf') then
                setShaderFloatArray(tag, 'overlayColor', {0,0,0,0})
                setShaderFloatArray(tag, 'satinColor', {0,0,0,0})
                setShaderFloatArray(tag, 'innerShadowColor', {0,0,0,0})
                setShaderFloat(tag, 'innerShadowAngle', 0.0)
                setShaderFloat(tag, 'innerShadowDistance', 20)
            else
                setShaderFloatArray(tag, 'overlayColor', {sliders[1][2], sliders[2][2], sliders[3][2], sliders[4][2]})
                setShaderFloatArray(tag, 'satinColor', {sliders[5][2], sliders[6][2], sliders[7][2], sliders[8][2]})
                setShaderFloatArray(tag, 'innerShadowColor', {sliders[9][2], sliders[10][2], sliders[11][2], sliders[12][2]})
                setShaderFloat(tag, 'innerShadowAngle', sliders[13][2] * (math.pi / 180))
                setShaderFloat(tag, 'innerShadowDistance', sliders[14][2])
            end
        end
    end

    -- 2. [해결 장치] 루아 제어 범위를 벗어난 dad2 오브젝트에 Haxe를 이용해 직접 쉐이더 Uniform 값을 강제 주입
    runHaxeCode([[
        var targetShader = game.runtimeShaders.get('RTXLighting');
        if (targetShader != null && game.dad2 != null) {
            // 애니메이션 변환 등으로 쉐이더가 유실되는 것 방지
            if (game.dad2.shader != targetShader) {
                game.dad2.shader = targetShader;
            }
            
            // 화이트 배경 예외 처리 분기 포함하여 수치 주입
            if (]]..(currentBg == 'white' and "true" or "false")..[[) {
                targetShader.setFloatArray('overlayColor', [0.0, 0.0, 0.0, 0.0]);
                targetShader.setFloatArray('satinColor', [0.0, 0.0, 0.0, 0.0]);
                targetShader.setFloatArray('innerShadowColor', [0.0, 0.0, 0.0, 0.0]);
                targetShader.setFloat('innerShadowAngle', 0.0);
                targetShader.setFloat('innerShadowDistance', 20.0);
            } else {
                targetShader.setFloatArray('overlayColor', [ ]]..sliders[1][2]..[[, ]]..sliders[2][2]..[[, ]]..sliders[3][2]..[[, ]]..sliders[4][2]..[[ ]);
                targetShader.setFloatArray('satinColor', [ ]]..sliders[5][2]..[[, ]]..sliders[6][2]..[[, ]]..sliders[7][2]..[[, ]]..sliders[8][2]..[[ ]);
                targetShader.setFloatArray('innerShadowColor', [ ]]..sliders[9][2]..[[, ]]..sliders[10][2]..[[, ]]..sliders[11][2]..[[, ]]..sliders[12][2]..[[ ]);
                targetShader.setFloat('innerShadowAngle', ]]..(sliders[13][2] * (math.pi / 180))..[[);
                targetShader.setFloat('innerShadowDistance', ]]..sliders[14][2]..[[);
            }
        }
    ]])
end