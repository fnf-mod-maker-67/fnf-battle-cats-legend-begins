-------- glitching.lua (최적화 버전) --------
-- 원본 문제: onCreatePost에서 글리치 셰이더 필터를 camGame/camHUD/camOther 3개 카메라에
--   곡 내내 항상 부착 → intensity=0(꺼짐)이어도 풀스크린 셰이더 3개가 매 프레임 렌더링 → FPS 저하
--   + onUpdate에서 매 프레임 runHaxeCode(iTime 갱신)
-- 수정: 글리치 이벤트가 발생(intensity>0)할 때만 필터 부착, intensity=0 되면 필터 제거
--   → 글리치 안 쓰는 구간/곡에서는 셰이더 비용 0

local totalTime = 0
local shaderActive = false

function onCreatePost()
    -- 셰이더 객체만 미리 생성 (필터는 부착하지 않음)
    runHaxeCode([[
        if (!ClientPrefs.data.shaders) return;
        var glitchShader = game.createRuntimeShader('glitch');
        if (glitchShader != null) {
            glitchShader.setFloat('iTime', 0.0);
            glitchShader.setFloat('uIntensity', 0.0);
            setVar('glitchShaderObj', glitchShader);
        }
    ]])
end

function onUpdate(elapsed)
    -- 셰이더가 활성화된 동안에만 iTime 갱신 (필터 꺼져 있으면 매 프레임 runHaxeCode 안 함)
    if not shaderActive then return end
    totalTime = totalTime + elapsed
    runHaxeCode([[
        var shader = getVar('glitchShaderObj');
        if (shader != null) {
            shader.setFloat('iTime', ]] .. totalTime .. [[);
        }
    ]])
end

function onEvent(name, value1, value2)
    if name == 'glitch' or name == 'Glitch' then
        local intensity = tonumber(value1) or 0.0

        if intensity > 0 and not shaderActive then
            -- 글리치 처음 발동 시에만 3개 카메라에 필터 부착
            shaderActive = true
            runHaxeCode([[
                var shader = getVar('glitchShaderObj');
                if (shader != null) {
                    var filter = new openfl.filters.ShaderFilter(shader);
                    game.camGame.setFilters([filter]);
                    game.camHUD.setFilters([filter]);
                    if (game.camOther != null) {
                        game.camOther.setFilters([filter]);
                    }
                }
            ]])
        end

        -- intensity 적용
        runHaxeCode([[
            var shader = getVar('glitchShaderObj');
            if (shader != null) {
                shader.setFloat('uIntensity', ]] .. intensity .. [[);
            }
        ]])

        -- intensity 0이면 필터 제거 → 성능 복구
        if intensity <= 0 and shaderActive then
            shaderActive = false
            runHaxeCode([[
                game.camGame.setFilters([]);
                game.camHUD.setFilters([]);
                if (game.camOther != null) {
                    game.camOther.setFilters([]);
                }
            ]])
        end
    end
end