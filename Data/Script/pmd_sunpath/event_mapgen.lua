require 'pmd_sunpath.common'

------------------------
--Halcyon scripts
------------------------

--Edited version of the reverse script for Halcyon's Relic Forest
function ZONE_GEN_SCRIPT.ReverseDustyDune(zoneContext, context, queue, seed, args)
	if SV.Chapter1.PlayerEnteredDune and not SV.Chapter1.PlayerCompletedDune then
		local activeEffect = RogueEssence.Data.ActiveEffect()
		local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
		local priority = RogueElements.Priority(-6)
		activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("DustyDuneFlipStairs"))
		queue:Enqueue(priority, destNote)
	end
end




----------------------
--Nebula's Mission Board scripts
----------------------

function ZONE_GEN_SCRIPT.GenerateJobInFloor(zoneContext, context, queue, seed, args)
    MissionGen:GenerateJobInFloor(zoneContext, context, queue, seed, args)
end
