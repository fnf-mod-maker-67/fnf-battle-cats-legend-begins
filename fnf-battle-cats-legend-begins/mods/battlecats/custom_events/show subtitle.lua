-- Event by Stinko
-- 자막 번역 테이블 (한국어)
local subtitle_translations = {
    ["Oh, you have to brush a tooth"] = "아 입냄새나;;;;",
    ["Do you want to die?"] = "뒤질래?",
    ["I tried to send you alive"] = "좋게 보내줄라 했더니",
    ["but I think that you have to die."] = "안 되겠구만~?",
    ["GAAAAAAAAHHHHHHHHHHHHHHHHH"] = "으아아아ㅏㅏㅏㅏㅏ!!!!!!!!!!!!",
    ["GO!"] = "고",
    ["1"] = "1",
    ["2"] = "2",
    ["3"] = "3",
    ["you are bad about to sing a song"] = "와 진짜 드럽게 못부른다...",
    ["you are bad about singing a song"] = "와 진짜 드럽게 못 부른다...",
    ["snake: F*** are you b**** on ******* wt* "] = "스네이크: 씨*** 너 뭐*** 짓*** 하고 있*** 씨* ",
    ["s** ga*fu * are you kin duhan?"] = "씨* 개** 니가 김두한이냐?",
    ["F*** are you b**** on ******* wt* "] = "씨*** 너 뭐*** 짓*** 하고 있*** 씨* ",
    ["bang"] = "빵",
    ["bangbang"] = "빵빵",
    ["bangbangbang"] = "빵빵빵",
    ["booming"] = "터트리고 있어요.",
    ["those guys: I said I will do"] = "놈놈놈: 아 내가 한다고 했잖아",
    ["snake: you are troller f**k"] = "스네이크: 이 트롤 ㅅㄲ야",
	["Who are you?"] = "넌 뭐야?"
}

function onCreatePost()
	luaDebugMode = true;
------------------------------------------------BG
	makeLuaSprite('BG', image, 0, 500)
	makeGraphic('BG', 400, 75, '000000')
	setProperty('BG.alpha', 1)
	addLuaSprite('BG', true)
	setObjectCamera('BG', 'camHUD')
	setProperty('BG.visible', false)
	screenCenter('BG', 'x')
	setObjectOrder('BG', 20)
	setProperty('BG.alpha', 0.65)
------------------------------------------------Text
	makeLuaText('subText', '', 0, 0, 550)
    setObjectCamera('subText', 'camHUD')
	screenCenter('subText', 'x')
	addLuaText('subText')
	setObjectOrder('subText', 21)
	setProperty('subText.visible', false)
	setTextFont('subText', 'subtitle.ttf')
	setTextBorder('subText', 0, 'black')
	setTextSize('subText', 32)
	setTextWidth('subText', 400)
	--setTextHeight('subText', 150)
end

function onEvent(name, value1, value2, strumTime)
	if name == 'show subtitle' then
		if value1 == '' then
			setProperty('BG.visible', false)
			setProperty('subText.visible', false)
			setProperty("subText.y", getProperty("BG.y") + (getProperty("BG.height") - getProperty("subText.height")) / 2)
			doTweenColor('TextColor', 'subText', '' .. value2 .. '', 0.05)
		else
			setProperty('BG.visible', true)
			setProperty('subText.visible', true)
			-- 한국어일 때만 번역 테이블 lookup, 다른 언어는 항상 원문
			local displayText = value1
			if getCurLanguage() == 'ko-KR' then
				displayText = subtitle_translations[value1] or value1
			end
			setProperty('subText.text', displayText)
			screenCenter('subText', 'x')
			setProperty("subText.y", getProperty("BG.y") + (getProperty("BG.height") - getProperty("subText.height")) / 2)
			doTweenColor('TextColor', 'subText', '' .. value2 .. '', 0.05)
		end

	end

end
