-- -- script by Archie

local allowCountdown = false

function onStartCountdown()
    if not allowCountdown then
        allowCountdown = true
        
        local chartFolder = getPropertyFromClass('backend.Song', 'loadedSongName')
        chartFolder = string.gsub(chartFolder, " ", "-") -- 공백을 하이픈(-)으로 치환
        
        -- 만약 파일명이 소문자 기준(e.g. nyan-chapter1)이라면 아래 코드를 사용하세요.
        -- chartFolder = string.lower(string.gsub(chartFolder, " ", "-"))
        
        local videoName = chartFolder .. '-' .. difficultyName
        if checkFileExists('videos/' .. videoName .. '.mp4') then
            startVideo(videoName)
        else
            debugPrint('Video not found: ' .. videoName)
            startCountdown()
        end
        return Function_Stop
    end
    return Function_Continue
end