require 'origin.common'
require 'pmd_sunpath.mission_gen'

function ZONE_GEN_SCRIPT.ReverseDustyDune(zoneContext, context, queue, seed, args)
	if SV.Chapter1.PlayerEnteredDune and not SV.Chapter1.PlayerCompletedDune then
		local activeEffect = RogueEssence.Data.ActiveEffect()
		local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
		local priority = RogueElements.Priority(-6)
		activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("DustyDuneFlipStairs"))
		queue:Enqueue(priority, destNote)
	end
end




--Halcyon/Sunpath custom map gen steps
 
--Used to create a somewhat irregular cross that cuts through a dungeon. It's needed to add some more pathways for mobs to navigate the dungeon with and jump you more often.
function FLOOR_GEN_SCRIPT.CreateCrossHalls(map, args)
	
	--get the center of the map to start the cross from, plus or minus 1 or 2 for variety.
	local mapCenterX = math.ceil(map.Width / 2) + map.Rand:Next(-2, 3)
	local mapCenterY = math.ceil(map.Height / 2) + map.Rand:Next(-2, 3)
	
	local originTile = RogueElements.Loc(mapCenterX, mapCenterY)
	map:TrySetTile(originTile, RogueEssence.Dungeon.Tile("floor"))
	
	--try to set the tile to floor. If it's already floor, return true to let the loop know to break.
	local function SetTileOrBreak(x, y)
		local loc = RogueElements.Loc(x, y)
		if map:GetTile(loc):TileEquivalent(map.WallTerrain) then
			map:TrySetTile(loc, RogueEssence.Dungeon.Tile("floor"))
			return false
		elseif map:GetTile(loc):TileEquivalent(map.RoomTerrain) then
			return true --if we hit a floor tile, break early. Can't break in the local function, so return true to let the caller know.
		end
	end
	
	--i could have maybe figured out a way to be more clever and reuse the same functionality, since it's the same function but in different directions essentially, but this
	--was the most straightforward to my brain way of doing this.
	local function GenerateVertical(centerX, centerY, reverseDirection)
		local start, finish, sign
		if reverseDirection then 
			start = centerY + 1 
			finish = map.Height
			sign = 1
		else
			start = centerY - 1 
			finish = 0
			sign = -1
		end
		
		--Go in a given direction until we hit a floor tile. If we somehow never do (we always should), stop at the edge of the map
		local didSidestep = false
		local x = centerX
		for i = start, finish, sign do
			if SetTileOrBreak(x, i) then break end
			--Once you've left the origin at least map axis length / 10 tiles, start rolling a 1/7 chance to do a one time adjust to the side for a few tiles.		
			--sidestep will be for map axis length / 20 plus 0 or 1
			--only do 1 side step.
			if not didSidestep and math.abs(i - centerY) >=  math.floor(map.Height / 10) then
				if map.Rand:Next(1, 8) == 1 then 
					didSidestep = true
					local sidestepDirection = 1
					local sidestepDistance = math.floor(map.Height / 20) + map.Rand:Next(0, 2)
					--50% chance to turn left or right
					if map.Rand:Next(1, 3) == 1 then sidestepDirection = -1 end  
					for j = x + sidestepDirection, x + (sidestepDirection * sidestepDistance), sidestepDirection do 
						--do j + sidestep direction because without the sidestep addition, we'd be starting on the tile we're already on and immediately would hit a break
						x = j
						if SetTileOrBreak(x, i) then break end
					end 
				end 
			end
		end 
	end 
	
	local function GenerateHorizontal(centerX, centerY, reverseDirection)
		local start, finish, sign
		if reverseDirection then 
			start = centerX + 1 
			finish = map.Width
			sign = 1
		else
			start = centerX - 1 
			finish = 0
			sign = -1
		end
		
		--Go in a given direction until we hit a floor tile. If we somehow never do (we always should), stop at the edge of the map
		local didSidestep = false
		local y = centerY
		for i = start, finish, sign do
			if SetTileOrBreak(i, y) then break end
			--Once you've left the origin at least map axis length / 10 tiles, start rolling a 1/7 chance to do a one time adjust to the side for a few tiles.		
			--sidestep will be for map axis length / 20 plus 0 or 1.
			--only do 1 side step.
			if not didSidestep and math.abs(i - centerX) >=  math.floor(map.Width / 10) then
				if map.Rand:Next(1, 8) == 1 then 
					didSidestep = true
					local sidestepDirection = 1
					local sidestepDistance = math.floor(map.Width / 20) + map.Rand:Next(0, 2)
					--50% chance to turn left or right
					if map.Rand:Next(1, 3) == 1 then sidestepDirection = -1 end  
					--do j + sidestep direction because without the sidestep addition, we'd be starting on the tile we're already on and immediately would hit a break
					for j = y + sidestepDirection, y + (sidestepDirection * sidestepDistance), sidestepDirection do 
						y = j
						if SetTileOrBreak(i, y) then break end
					end 
				end 
			end
		end 
	end
	
	--With our functions defined, run them each twice, one for each direction.
	GenerateHorizontal(mapCenterX, mapCenterY, false)
	GenerateHorizontal(mapCenterX, mapCenterY, true)
	GenerateVertical(mapCenterX, mapCenterY, false)
	GenerateVertical(mapCenterX, mapCenterY, true)
	
	
 
end 
--Used for making the rivers in dungeons.
function FLOOR_GEN_SCRIPT.CreateRiver(map, args)
	local mapCenter = math.ceil(map.Width / 2)
	local randomOffset = map.Rand:Next(-2,3) --a random small offset added to all tiles to help randomize where the river falls a bit 
	local leftBound = math.floor(mapCenter / 2) + randomOffset --base left bound 
	local rightBound = math.ceil(mapCenter * 3 / 2) + randomOffset -- base right bound
	local leftOffset = map.Rand:Next(-1, 2)
	local rightOffset = map.Rand:Next(-1, 2)
	local leftShore = 0
	local rightShore = 0
	
	local leftOffsetRemaining = map.Rand:Next(1, 5)--how many times this specific offset can be used before being regenerated 
	local rightOffsetRemaining = map.Rand:Next(1, 5)
	
	
	
	--go row by row. Replace ground tiles towards the center of the map with water tiles to create a river flowing through the dungeon.
	--Ground tiles will remain untouched. River will ebb a bit side to side within a limit.
	
	for y = 0, map.Height-1, 1 do 
		
		--determine starting and ending positions for row of river
		--an offset will last for a few rows before trying to roll again for a new offset
		
		--roll new offsets and set new offset timer 
		--NOTE: map.Rand:Next(lower, upper) is inclusive on lower, and exclusive on upper 
		--todo: make this more clever
		if leftOffsetRemaining <= 0 then
			if leftOffset < 0 then
				leftOffset = map.Rand:Next(-1, 1)
			elseif leftOffset > 0 then 
				leftOffset = map.Rand:Next(0, 2)
			else 
				leftOffset = map.Rand:Next(-1, 2)
			end
			leftOffsetRemaining = map.Rand:Next(1, 5)
		end
		
		if rightOffsetRemaining <= 0 then
			if rightOffset < 0 then
				rightOffset = map.Rand:Next(-1, 1)
			elseif rightOffset > 0 then 
				rightOffset = map.Rand:Next(0, 2)
			else 
				rightOffset = map.Rand:Next(-1, 2)
			end
			rightOffsetRemaining = map.Rand:Next(1, 5)
		end
		
		leftShore = leftBound + leftOffset
		rightShore = rightBound + rightOffset
		--print("Left, right shore :" .. leftShore .. " " ..rightShore)
		--print("Left, right offset:" .. leftOffset .. " " .. rightOffset)
		--print("left, right offset remaining: " .. leftOffsetRemaining .. " " .. rightOffsetRemaining)
		
		--set all non ground tiles to water tiles between our left and right bounds 
		for x = leftShore, rightShore, 1 do 
			local loc = RogueElements.Loc(x, y)
			if not map:GetTile(loc):TileEquivalent(map.RoomTerrain) then
				map:TrySetTile(loc, RogueEssence.Dungeon.Tile("water"))
			end
	
	
		end 
		
		leftOffsetRemaining = leftOffsetRemaining - 1
		rightOffsetRemaining = rightOffsetRemaining - 1
		
	end 
	
	
end



