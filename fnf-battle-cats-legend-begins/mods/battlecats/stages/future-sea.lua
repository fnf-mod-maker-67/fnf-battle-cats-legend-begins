local StageProps = {'bunbun', 'bear', 'leopard', 'daram', 'tank'}

function onBeatHit()
	for i = 1, #StageProps do
		if curBeat % 1 == 0 then -- 매 비트마다. 2박마다면 curBeat % 2 == 0
			playAnim(StageProps[i], 'idle', true)
		end
	end
end