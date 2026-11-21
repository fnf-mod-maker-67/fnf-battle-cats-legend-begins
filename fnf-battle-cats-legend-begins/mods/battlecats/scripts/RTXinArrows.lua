function onCreatePost()
    initLuaShader('RTXLighting')   -- 쓸 쉐이더 이름 (shaders 폴더의 .frag 이름)

    for i = 0, 3 do
        setSpriteShader('playerStrums.members[' .. i .. ']', 'RTXLighting')
        setSpriteShader('opponentStrums.members[' .. i .. ']', 'RTXLighting')
    end
end

function goodNoteHit()
	for i = 0, 3 do
        setSpriteShader('playerStrums.members[' .. i .. ']', 'RTXLighting')
    end
end
