function onEvent(name, value1, value2)
	if name ~= "middleScroll" then return end

	local duration = tonumber(value2) or 0.5

	-- 엔진 기본값(STRUM_X=42, STRUM_X_MIDDLESCROLL=-278, swagWidth=112, 화면폭=1280) 기준 계산
	local offOpp = {92, 204, 316, 428}
	local offPly = {732, 844, 956, 1068}
	local onOpp  = {82, 194, 971, 1083}
	local onPly  = {412, 524, 636, 748}

	local targetOpp, targetPly
	if value1 == "true" or value1 == "1" then
		targetOpp, targetPly = onOpp, onPly
	else
		targetOpp, targetPly = offOpp, offPly
	end

	for i = 0, 3 do
		doTweenX('middleScrollOpp' .. i, 'opponentStrums.members[' .. i .. ']', targetOpp[i + 1], duration, 'linear')
		doTweenX('middleScrollPly' .. i, 'playerStrums.members[' .. i .. ']', targetPly[i + 1], duration, 'linear')
	end
end
