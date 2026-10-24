-- Credits: MelodyTheFelony, Browniegaming1234
-- Inspired by: https://gamebanana.com/tools/9079

healthToDrain = 0.01
willDie = 0.25

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then
        local currentHealth = getProperty('health')
        
        if currentHealth > willDie then
            local damage = healthToDrain
            
            if noteType == 'GF Duet' then
                damage = healthToDrain * 2
            end
            
            local resultHealth = currentHealth - damage
            
            if resultHealth < willDie then
                setProperty('health', willDie)
            else
                setProperty('health', resultHealth)
            end
        end
    end
end