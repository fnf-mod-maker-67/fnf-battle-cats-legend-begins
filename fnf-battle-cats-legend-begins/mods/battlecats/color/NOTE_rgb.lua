-- (R = Arrow, G = Glow, B = Outline)
local bfRGB = {
    r = { 'C24B99', '00FFFF', '12FA05', 'F9393F' },
    g = { 'FFFFFF', 'FFFFFF', 'FFFFFF', 'FFFFFF' },
    b = { '3C1F56', '1542B7', '0A4447', '651038' }
}

local dadRGB = {
    r = { 'C24B99', '00FFFF', '12FA05', 'F9393F' },
    g = { 'FFFFFF', 'FFFFFF', 'FFFFFF', 'FFFFFF' },
    b = { '3C1F56', '1542B7', '0A4447', '651038' }
}

local function applyShaderColor(group, id, index, colors)
    setPropertyFromGroup(group, id, 'rgbShader.r', getColorFromHex(colors.r[index]))
    setPropertyFromGroup(group, id, 'rgbShader.g', getColorFromHex(colors.g[index]))
    setPropertyFromGroup(group, id, 'rgbShader.b', getColorFromHex(colors.b[index]))
end

function onSpawnNote(id, nd, nt, sus)
    local noteData = getPropertyFromGroup('notes', id, 'noteData') + 1
    local isMustPress = getPropertyFromGroup('notes', id, 'mustPress')

    if isMustPress then
        applyShaderColor('notes', id, noteData, bfRGB)
    else
        applyShaderColor('notes', id, noteData, dadRGB)
    end
end

function onCreatePost()
    applyAllStrums()
end

function onCountdownStarted()
    applyAllStrums()
    runTimer('destelloStrums', 0.2)
end

function applyAllStrums()
    for i = 0, getProperty('playerStrums.length') - 1 do
        applyShaderColor('playerStrums', i, i + 1, bfRGB)
    end
    for i = 0, getProperty('opponentStrums.length') - 1 do
        applyShaderColor('opponentStrums', i, i + 1, dadRGB)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'destelloStrums' then
        runHaxeCode([[
            for (i in 0...4) {
                if (game.opponentStrums.members[i] != null) game.opponentStrums.members[i].playAnim('press', true);
                if (game.playerStrums.members[i] != null) game.playerStrums.members[i].playAnim('press', true);
            }
        ]])
    end
end