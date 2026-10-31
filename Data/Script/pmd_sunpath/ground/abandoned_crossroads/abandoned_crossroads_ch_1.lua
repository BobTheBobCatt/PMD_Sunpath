require 'pmd_sunpath.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.CharacterEssentials'
require 'pmd_sunpath.GeneralFunctions'
require 'pmd_sunpath.CharacterActions'

abandoned_crossroads_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
--Play this scene after the player completed Dusty Dune
function abandoned_crossroads_ch_1.Story_Cutscene()

	GeneralFunctions.DefaultPartyCH1(true)
	
  
	
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local marker = MRKR("DustyDuneExitLocation")
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Down)
	GROUND:TeleportTo(partner, -35, 308, Direction.Right)
	AI:DisableCharacterAI(partner)
	
	GAME:FadeIn(120)
	GAME:WaitFrames(120)
	GAME:CutsceneMode(true)
	UI:ResetSpeaker()
	GROUND:MoveToPosition(hero, 220, 110, false, 1)
	UI:SetSpeaker(hero, true)
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue("...[pause=0]Wow, I forgot how tiring dungeon exploration can be. It's not like I really had a choice, though...")
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("I should stop putting myself in these types of situations...")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 220, 180, false, 1)
	local coro1 = TASK:BranchCoroutine(function () GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
									GAME:WaitFrames(20)
									GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
									GAME:WaitFrames(20) end)
	UI:SetSpeaker(hero, false)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("(No one around for now. That can change at any time though, but they may be friendlier here...)")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.UpLeft, 4)
	GAME:WaitFrames(20)
	UI:SetSpeaker(hero, true)
	GROUND:CharSetEmote(hero, "question", 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	UI:WaitShowDialogue("Hmm, what is that...?")
	GROUND:MoveToPosition(hero, 186, 160, false, 1)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("Bah, just some symbols I can't read. There is a shown direction though. I wonder what is there...?")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
	UI:SetSpeaker(hero, false)
	UI:WaitShowDialogue("(I suppose it doesn't hurt to check it out. Must lead to somewhere if someone left it here.)")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 170, 170, false, 1)
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, -40, 170, false, 1)
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60) --Player leaves the scene so that the partner can join

	UI:ResetSpeaker()
	GAME:MoveCamera(35, 302, 20, false)
	GAME:FadeIn(40)
	CharacterActions.MoveCharAndCamera(partner, 93, 302, false, 1)
	UI:SetSpeaker(partner, true)
	GROUND:CharAnimateTurnTo(partner, Direction.Left, 4)
	UI:WaitShowDialogue("Phew. I think I managed to get away without drawing attention.")
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("Not that it really matters too much. Mother's gonna scold me once I get home...")
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Well, live in the moment they say.")
	CharacterActions.MoveCharAndCamera(partner, 160, 302, false, 1)
	GAME:WaitFrames(5)
	CharacterActions.MoveCharAndCamera(partner, 185, 290, false, 1)
	GAME:WaitFrames(5)
	CharacterActions.MoveCharAndCamera(partner, 222, 280, false, 1)
	GAME:WaitFrames(10)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion('Worried')
	UI:SetSpeaker(partner, false)
	UI:WaitShowDialogue("(You know, I've always wondered who made these roads, they really haven't been maintaining them...)")
	GAME:WaitFrames(20)
	CharacterActions.MoveCharAndCamera(partner, 222, 92, false, 1)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner, true)
	GROUND:CharSetEmote(partner, "question", 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	UI:WaitShowDialogue("What's this feeling...a mystery dungeon nearby? Here?")
	UI:SetSpeaker(partner, false)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("...")
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner, true)
	UI:SetSpeakerEmotion('Inspired')
	UI:WaitShowDialogue("If it is, then I shall take the chance to explore it. Exploration is much more fun than being at home!")
	SOUND:PlayBattleSE("_UNK_EVT_069")
	GROUND:MoveToPosition(partner, 222, -45, true, 4)
	GAME:WaitFrames(20)
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60)
	
	local p = GAME:GetPlayerPartyMember(0)
	GAME:RemovePlayerTeam(0)
	GAME:AddPlayerAssembly(p)
	GeneralFunctions.SendInvToStorage() --clear inventory
	_DATA.Save.ActiveTeam:SetRank("guildless")
	SV.Chapter1.PartnerEnteredDune = true
	--SV.Chapter1.PartnerCompletedDune = true --Only for testing purposes (Flag needed for the Dusty Dune partner scene to play)
	GAME:CutsceneMode(false)
	--GAME:EnterGroundMap("dusty_dune", "Main_Entrance_Marker") --Only for testing purposes for skipping the dungeon (and only if the enter dungeon code is commented out)
	GAME:EnterDungeon("dusty_dune", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
	
end


--Play this cutscene if you somehow got wiped in the dune as just the partner
function abandoned_crossroads_ch_1.WipedInDune()
	local partner = CH('PLAYER')	
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("dusty_dune")
	local marker = MRKR("Main_Entrance_Marker")
	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	UI:ResetSpeaker()
	GAME:MoveCamera(228, 46, 1, false)
	GROUND:TeleportTo(partner, marker.Position.X, marker.Position.Y, Direction.Down)
	GROUND:CharSetAnim(partner, 'EventSleep', true)
	GAME:FadeIn(40)
	
	--wake up and look around
	GAME:WaitFrames(120)
	CharacterActions.DoAnimation(partner, 'Wake')
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
	GAME:WaitFrames(20)
	CharacterActions.LookAround(partner, 2, 4, false, false, false, Direction.Down)
	
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion('Pain')
	CharacterActions.EmoteAndPause(partner, 'Sweating', true)
	
	UI:WaitShowDialogue("Wow... I didn't expect to get roughed up like that.")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue('I got knocked out, so the dungeon spat me back at the entrance...')
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("Perhaps I underestimated how dangerous exploring can be. I hope I haven't been out for too long...")
	
	GAME:WaitFrames(40)
	CharacterActions.ShakeHead(partner)
	GAME:WaitFrames(30)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Alright. I think I can make it through this time. Just have to be a bit more careful.")
	
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(partner, 220, -45, false, 1)
	SOUND:FadeOutBGM()
	GAME:FadeOut(false, 40)
	
	GAME:CutsceneMode(false)
	GAME:EnterDungeon("dusty_dune", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)

end
