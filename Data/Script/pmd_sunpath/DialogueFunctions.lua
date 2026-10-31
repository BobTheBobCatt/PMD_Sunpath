require 'pmd_sunpath.common'
require 'pmd_sunpath.config'
require 'pmd_sunpath.PartnerEssentials'
DialogueFunctions = {}

--------------------------
--Halcyon scripts
--------------------------

--shortcut for doing player dialogue (i.e., no sfx, no nameplate at the start)
function DialogueFunctions.HeroDialogue(chara, str, emotion)
	UI:SetSpeaker('', false, chara.CurrentForm.Species, chara.CurrentForm.Form, chara.CurrentForm.Skin, chara.CurrentForm.Gender)
	UI:SetSpeakerEmotion(emotion)
	UI:WaitShowDialogue(str)
end

-- Used to get proper pronoun depending on gender of character (gender check command)
-- Form should be given as they, them, their, theirs, themself, or they're.
-- If uppercase is truth, then the first letter will be capitalized.
function DialogueFunctions.GetPronoun(chara, form, uppercase)
    local gender = chara.CurrentForm.Gender
    local value = ""
    
    if gender == Gender.Female then
        local female_pronouns = {
            ["they"] = "she", -- nominative
            ["them"] = "her", -- objective
            ["their"] = "her", -- possessive
            ["theirs"] = "hers", -- possessive, no following noun
            ["themself"] = "herself", -- reflexive
            ["they're"] = "she's", -- nominative + "be" contraction
            ["are"] = "is", -- "be" present indicative
			["were"] = "was", -- "be" past indicative
			["don't"] = "doesn't", -- declarative + "do not" contraction
			["aren't"] = "isn't", -- declarative + "are not" contraction
			["child"] = "daughter", -- concrete noun
			["kid"] = "girl", -- concrete noun
			["hurt"] = "hurts" -- action
        }
        value = female_pronouns[form]
    elseif gender == Gender.Male then
        local male_pronouns = {
            ["they"] = "he", -- nominative
            ["them"] = "him", -- objective
            ["their"] = "his", -- possessive
            ["theirs"] = "his", -- possessive, no following noun
            ["themself"] = "himself", -- reflexive
            ["they're"] = "he's", -- nominative + "be" contraction
            ["are"] = "is", -- "be" present indicative
			["were"] = "was", -- "be" past indicative
			["don't"] = "doesn't", -- declarative + "do not" contraction
			["aren't"] = "isn't", -- declarative + "are not" contraction
			["child"] = "son", -- concrete noun
			["kid"] = "boy", -- concrete noun
			["hurt"] = "hurts" -- action
        }
        value = male_pronouns[form]
    else -- if neither male or female, use they/them, so just return the form 
        value = form
    end

    return uppercase and value:gsub("^%l", string.upper) or value
    
end

--used to conjugate certain verbs appropriately, to be used with the above function typically
--this will need to be updated to be more sophisticated as the use cases arrive. For now, KISS.
function DialogueFunctions.Conjugate(chara, verb)
    local gender = chara.CurrentForm.Gender
    local value = verb
    
    if gender ~= Gender.Genderless then 
		if string.sub(verb, -1) == 's' then 
			value = value .. 'es'
		else
			value = value .. 's'
		end
    end

	return value
    
end


function DialogueFunctions.NameStutter(chara)
	--used to get a stutter on a character's name with proper coloring
	local name = chara.Nickname
	local prefix = "[color=#00FFFF]" .. string.sub(name, 1, 1) .. "[color]-"
	
	return prefix .. chara:GetDisplayName()

end


--does a monologue, centering the text, having it appear instantly and turning off the keysound, then turn centering and auto finish off after.
function DialogueFunctions.Monologue(str)
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:SetAutoFinish(true)
	UI:WaitShowDialogue(str)
	UI:SetAutoFinish(false)
	UI:SetCenter(false)
end 

--used to start a coroutine to have partner turn towards target NPC while having a conversation start.
--also stops their animations 
function DialogueFunctions.StartConversation(target, dialogue, emotion, npcTurn, changeNPCanimation, changeSpeaker, animation, turnframes)
	if emotion == nil then emotion = 'Normal' end
	if changeSpeaker == nil then changeSpeaker = true end 
	if npcTurn == nil then npcTurn = true end--should NPC turn to face you?
	if changeNPCanimation == nil then changeNPCanimation = true end--should NPC change their animation? useful for flying npcs too
	if animation == nil then animation = 'None' end 
	if turnframes == nil then turnframes = 4 end
	
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	partner.IsInteracting = true
	SV.TemporaryFlags.OldDirection = target.Direction
	if changeSpeaker then UI:SetSpeaker(target) end
	UI:SetSpeakerEmotion(emotion)
	GROUND:CharSetAnim(partner, animation, true)
	GROUND:CharSetAnim(hero, animation, true)
	if changeNPCanimation then GROUND:CharSetAnim(target, animation, true) end
		
    GROUND:CharTurnToChar(hero, target)
    if npcTurn then GROUND:CharTurnToChar(target, hero) end
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, target, turnframes) end)

    UI:WaitShowDialogue(dialogue)

    TASK:JoinCoroutines({coro1})
	UI:WaitDialog()
	
end 

--used to start a coroutine to have 2nd partner turn towards target NPC while having a conversation start.
--also stops their animations 
function DialogueFunctions.StartConversation2(target, dialogue, emotion, npcTurn, changeNPCanimation, changeSpeaker, animation, turnframes)
	if emotion == nil then emotion = 'Normal' end
	if changeSpeaker == nil then changeSpeaker = true end 
	if npcTurn == nil then npcTurn = true end--should NPC turn to face you?
	if changeNPCanimation == nil then changeNPCanimation = true end--should NPC change their animation? useful for flying npcs too
	if animation == nil then animation = 'None' end 
	if turnframes == nil then turnframes = 4 end
	
	
	local hero = CH('PLAYER')
	local partner2 = CH('Teammate2')
	partner2.IsInteracting = true
	SV.TemporaryFlags.OldDirection = target.Direction
	if changeSpeaker then UI:SetSpeaker(target) end
	UI:SetSpeakerEmotion(emotion)
	GROUND:CharSetAnim(partner2, animation, true)
	GROUND:CharSetAnim(hero, animation, true)
	if changeNPCanimation then GROUND:CharSetAnim(target, animation, true) end
		
    GROUND:CharTurnToChar(hero, target)
    if npcTurn then GROUND:CharTurnToChar(target, hero) end
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner2, target, turnframes) end)

    UI:WaitShowDialogue(dialogue)

    TASK:JoinCoroutines({coro1})
	UI:WaitDialog()
	
end 

--used to start a coroutine to have both partners turn towards target NPC while having a conversation start.
--also stops their animations 
function DialogueFunctions.StartConversationBoth(target, dialogue, emotion, npcTurn, changeNPCanimation, changeSpeaker, animation, turnframes)
	if emotion == nil then emotion = 'Normal' end
	if changeSpeaker == nil then changeSpeaker = true end 
	if npcTurn == nil then npcTurn = true end--should NPC turn to face you?
	if changeNPCanimation == nil then changeNPCanimation = true end--should NPC change their animation? useful for flying npcs too
	if animation == nil then animation = 'None' end 
	if turnframes == nil then turnframes = 4 end
	
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local partner2 = CH('Teammate2')
	partner.IsInteracting = true
	partner2.IsInteracting = true
	SV.TemporaryFlags.OldDirection = target.Direction
	if changeSpeaker then UI:SetSpeaker(target) end
	UI:SetSpeakerEmotion(emotion)
	GROUND:CharSetAnim(partner, animation, true)
	GROUND:CharSetAnim(partner2, animation, true)
	GROUND:CharSetAnim(hero, animation, true)
	if changeNPCanimation then GROUND:CharSetAnim(target, animation, true) end
		
    GROUND:CharTurnToChar(hero, target)
    if npcTurn then GROUND:CharTurnToChar(target, hero) end
    local coro1 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner, target, turnframes) end)
	local coro2 = TASK:BranchCoroutine(function() GROUND:CharTurnToCharAnimated(partner2, target, turnframes) end)

    UI:WaitShowDialogue(dialogue)

    TASK:JoinCoroutines({coro1, coro2})
	UI:WaitDialog()
	
end 

--call this at the end of an npc conversation, sister function of above StartConversation function 
--Edited version of EndConversation for both partners
function DialogueFunctions.EndConversationBoth(target, changeNPCanimation)
	if changeNPCanimation == nil then changeNPCanimation = true end--should NPC change their animation? useful for flying npcs too

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local partner2 = CH('Teammate2')
	
	if target ~= partner then--if partner conversation was started don't turn them back around after
		if SV.TemporaryFlags.OldDirection ~= Direction.None then GROUND:EntTurn(target, SV.TemporaryFlags.OldDirection) end 
		SV.TemporaryFlags.OldDirection = Direction.None -- Clear flag 
	elseif target ~= partner2 then--if 2nd partner conversation was started don't turn them back around after
		if SV.TemporaryFlags.OldDirection ~= Direction.None then GROUND:EntTurn(target, SV.TemporaryFlags.OldDirection) end 
		SV.TemporaryFlags.OldDirection = Direction.None -- Clear flag 
	end
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(partner2)
	GROUND:CharEndAnim(hero)
	if changeNPCanimation and target ~= partner then GROUND:CharEndAnim(target) end
	
	partner.IsInteracting = false
	partner2.IsInteracting = false

end

--call this at the end of an npc conversation, sister function of above StartConversation function 
--Edited version of EndConversation for second partners
function DialogueFunctions.EndConversationPartner2(target, changeNPCanimation)
	if changeNPCanimation == nil then changeNPCanimation = true end--should NPC change their animation? useful for flying npcs too

	local hero = CH('PLAYER')
	local partner2 = CH('Teammate2')
	
	if target ~= partner2 then--if 2nd partner conversation was started don't turn them back around after
		if SV.TemporaryFlags.OldDirection ~= Direction.None then GROUND:EntTurn(target, SV.TemporaryFlags.OldDirection) end 
		SV.TemporaryFlags.OldDirection = Direction.None -- Clear flag 
	end
	
	GROUND:CharEndAnim(partner2)
	GROUND:CharEndAnim(hero)
	if changeNPCanimation and target ~= partner then GROUND:CharEndAnim(target) end
	
	partner2.IsInteracting = false

end

--call this at the end of an npc conversation, sister function of above StartConversation function 
function DialogueFunctions.EndConversation(target, changeNPCanimation)
	if changeNPCanimation == nil then changeNPCanimation = true end--should NPC change their animation? useful for flying npcs too

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	if target ~= partner then--if partner conversation was started don't turn them back around after
		if SV.TemporaryFlags.OldDirection ~= Direction.None then GROUND:EntTurn(target, SV.TemporaryFlags.OldDirection) end 
		SV.TemporaryFlags.OldDirection = Direction.None -- Clear flag 
	end
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	if changeNPCanimation and target ~= partner then GROUND:CharEndAnim(target) end
	
	partner.IsInteracting = false

end





--used to start a conversation between the player and the partner when it's the partner trying to start a conversation w/ the player
function DialogueFunctions.StartPartnerConversation(dialogue, emotion, heroTurn)
	if heroTurn == nil then heroTurn = true end
	if emotion == nil then emotion = 'Normal' end	
	
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	partner.IsInteracting = true
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion(emotion)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
		
    GROUND:CharTurnToCharAnimated(partner, hero, 4)

    UI:WaitShowDialogue(dialogue)
	
	--hero turns towards partner after 1st line of dialogue
	if heroTurn then GROUND:CharTurnToCharAnimated(hero, partner, 4) end
	
end 

--used to start a conversation between the player and the 2nd partner when it's the partner trying to start a conversation w/ the player
function DialogueFunctions.StartPartner2Conversation(dialogue, emotion, heroTurn)
	if heroTurn == nil then heroTurn = true end
	if emotion == nil then emotion = 'Normal' end	
	
	
	local hero = CH('PLAYER')
	local partner2 = CH('Teammate2')
	partner2.IsInteracting = true
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion(emotion)
	GROUND:CharSetAnim(partner2, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
		
    GROUND:CharTurnToCharAnimated(partner2, hero, 4)

    UI:WaitShowDialogue(dialogue)
	
	--hero turns towards partner after 1st line of dialogue
	if heroTurn then GROUND:CharTurnToCharAnimated(hero, partner2, 4) end
	
end 

--used to start a conversation between the player and the partners when it's the partner trying to start a conversation w/ the player
function DialogueFunctions.StartPartnersConversation(dialogue, emotion, heroTurn)
	if heroTurn == nil then heroTurn = true end
	if emotion == nil then emotion = 'Normal' end	
	
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local partner2 = CH('Teammate2')
	partner.IsInteracting = true
	partner2.IsInteracting = true
	UI:SetSpeaker(partner)
	UI:SetSpeaker(partner2)
	UI:SetSpeakerEmotion(emotion)
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(partner2, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
		
    GROUND:CharTurnToCharAnimated(partner, hero, 4)
    GROUND:CharTurnToCharAnimated(partner2, hero, 4)

    UI:WaitShowDialogue(dialogue)
	
	--hero turns towards partner after 1st line of dialogue
	if heroTurn then GROUND:CharTurnToCharAnimated(hero, partner, 4) end
	if heroTurn then GROUND:CharTurnToCharAnimated(hero, partner2, 4) end
	
end 

--------------------------
--Knightcore scripts
--------------------------

function DialogueFunctions.InstantTextNoSpeaker(str)
    UI:SetAutoFinish(true)
    UI:ResetSpeaker()
    UI:WaitShowDialogue(str)
    UI:SetAutoFinish(false)
end

--------------------------
--Sunpath scripts
--------------------------

function DialogueFunctions.GetSpecies(chara, form, uppercase)
    local gender = chara.CurrentForm.Species
    local value = ""

    return uppercase and value:gsub("^%l", string.upper) or value
    
end
