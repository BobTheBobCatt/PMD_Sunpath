require 'pmd_sunpath.CharacterEssentials'
PartnerEssentials = {}

--helper function, used if a dialogue bit will be used on multiple maps...
local function in_array(value, array)
    for index = 1, #array do
        if array[index] == value then
            return true
        end
    end

    return false -- We could ommit this part, as nil is like false
end

--This function is called to move partner to a specific marker on loading a new map
function PartnerEssentials.InitializePartnerSpawn(dir, customPosition)
	--Each map has an initial point where the partner spawns. 
	--Set the Partner Spawn variable to default to let the partner spawn there
	--My nomenclature, to keep things consistent, is to just copy the player's spawn marker's name,
	--add _Partner to the end for the partner's marker.
	--You can specify the dir parameter for a custom direction to spawn as if you want.
	--This function also assigns ground partner AI to the partner so they actually follow you.
	
	if GAME:GetPlayerPartyCount() < 2 then return end --do nothing if party is only size 1 
	
	local partner = CH('Teammate1')
	local player = CH('PLAYER')

	
	--in case a custom position is ever needed
	if customPosition ~= nil then 
		dir = dir or partner.Direction
		GROUND:TeleportTo(partner, customPosition.X, customPosition.Y, dir)
	--otherwise use the marker system
	elseif SV.partner.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner.Spawn)
		dir = dir or marker.Direction or partner.Direction
		
		
		GROUND:TeleportTo(partner, marker.Position.X, marker.Position.Y, dir)
	end	
	

	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
    partner.CollisionDisabled = true
	
end

function PartnerEssentials.InitializePartner2Spawn(dir, customPosition)
	--Each map has an initial point where the other partner spawns. 
	--Set the Partner Spawn variable to default to let the other partner spawn there
	--My nomenclature, to keep things consistent, is to just copy the player's spawn marker's name,
	--add _Partner to the end for the partner's marker.
	--You can specify the dir parameter for a custom direction to spawn as if you want.
	--This function also assigns ground partner AI to the partner so they actually follow you.
	
	if GAME:GetPlayerPartyCount() < 2 then return end --do nothing if party is only size 1 
	
	local partner2 = CH('Teammate2')
	local player = CH('PLAYER')

	
	--in case a custom position is ever needed
	if customPosition ~= nil then 
		dir = dir or partner.Direction
		GROUND:TeleportTo(partner2, customPosition.X, customPosition.Y, dir)
	--otherwise use the marker system
	elseif SV.partner2.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner2.Spawn)
		dir = dir or marker.Direction or partner2.Direction
		
		
		GROUND:TeleportTo(partner2, marker.Position.X, marker.Position.Y, dir)
	end	
	

	AI:SetCharacterAI(partner2, "ai.ground_partner2", CH('PLAYER'), partner2.Position)
    partner.CollisionDisabled = true
	
end

function PartnerEssentials.InitializePartnersSpawn(dir, customPosition)
	--Each map has an initial point where the other partner spawns. 
	--Set the Partner Spawn variable to default to let the other partner spawn there
	--My nomenclature, to keep things consistent, is to just copy the player's spawn marker's name,
	--add _Partner to the end for the partner's marker.
	--You can specify the dir parameter for a custom direction to spawn as if you want.
	--This function also assigns ground partner AI to the partner so they actually follow you.
	
	if GAME:GetPlayerPartyCount() < 3 then return end --do nothing if party is only size 1 or 2
	
	local partner = CH('Teammate1')
	local partner2 = CH('Teammate2')
	local player = CH('PLAYER')

	
	--in case a custom position is ever needed
	if customPosition ~= nil then 
		dir = dir or partner.Direction or partner2.Direction
		GROUND:TeleportTo(partner, customPosition.X, customPosition.Y, dir)
		GROUND:TeleportTo(partner2, customPosition.X, customPosition.Y, dir)
	--otherwise use the marker system
	elseif SV.partner.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner.Spawn)
		dir = dir or marker.Direction or partner2.Direction
		
		
		GROUND:TeleportTo(partner, marker.Position.X, marker.Position.Y, dir)
	elseif SV.partner2.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner2.Spawn)
		dir = dir or marker.Direction or partner2.Direction
		
		
		GROUND:TeleportTo(partner2, marker.Position.X, marker.Position.Y, dir)
	end	
	
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	AI:SetCharacterAI(partner2, "ai.ground_partner2", CH('PLAYER'), partner2.Position)
    partner.CollisionDisabled = true
    partner2.CollisionDisabled = true
	
end

--when reloading a save, load the partner back in at the proper coordinates.
function PartnerEssentials.LoadGamePartnerPosition(partner)
	print("loading partner in, activating their AI")
	GROUND:TeleportTo(partner, SV.partner.LoadPositionX, SV.partner.LoadPositionY, PartnerEssentials.NumToDir(SV.partner.LoadDirection))--sv doesn't seem to like storing custom classes
	AI:SetCharacterAI(partner, "ai.ground_partner", CH('PLAYER'), partner.Position)
	AI:EnableCharacterAI(partner)
end

function PartnerEssentials.LoadGamePartnerPosition(partner2)
	print("loading other partner in, activating their AI")
	GROUND:TeleportTo(partner2, SV.partner2.LoadPositionX, SV.partner2.LoadPositionY, PartnerEssentials.NumToDir(SV.partner2.LoadDirection))--sv doesn't seem to like storing custom classes
	AI:SetCharacterAI(partner2, "ai.ground_partner2", CH('PLAYER'), partner2.Position)
	AI:EnableCharacterAI(partner2)
end

--when saving the game, make note of where the partner is and where they're facing so we can reload them that way.
function PartnerEssentials.SaveGamePartnerPosition(partner)
	SV.partner.LoadPositionX = partner.Position.X
	SV.partner.LoadPositionY = partner.Position.Y
	SV.partner.LoadDirection = PartnerEssentials.DirToNum(partner.Direction)--sv doesnt seem to like storing custom classes
end

function PartnerEssentials.SaveGamePartnerPosition(partner2)
	SV.partner2.LoadPositionX = partner2.Position.X
	SV.partner2.LoadPositionY = partner2.Position.Y
	SV.partner2.LoadDirection = PartnerEssentials.DirToNum(partner2.Direction)--sv doesnt seem to like storing custom classes
end


--assigns a number value to each direction, useful for figuring out how many turn a direction is from another
function PartnerEssentials.DirToNum(dir)
	--up is 0, upright is 1, ... up left is 7
	local num = -1
	if dir == Direction.Up then
		num = 0
	elseif dir == Direction.UpRight then
		num = 1
	elseif dir == Direction.Right then
		num = 2
	elseif dir == Direction.DownRight then
		num = 3
	elseif dir == Direction.Down then
		num = 4
	elseif dir == Direction.DownLeft then
		num = 5
	elseif dir == Direction.Left then
		num = 6
	elseif dir == Direction.UpLeft then
		num = 7
	end
	
	return num
	
end


--converts a number to a direction
function PartnerEssentials.NumToDir(num)
	local dir = Direction.None
	if num % 8 == 0 then 
		dir = Direction.Up
	elseif num % 8 == 1 then
		dir = Direction.UpRight
	elseif num % 8 == 2 then
		dir = Direction.Right
	elseif num % 8 == 3 then
		dir = Direction.DownRight
	elseif num % 8 == 4 then
		dir = Direction.Down
	elseif num % 8 == 5 then
		dir = Direction.DownLeft
	elseif num % 8 == 6 then
		dir = Direction.Left
	elseif num % 8 == 7 then
		dir = Direction.UpLeft
	end

	return dir
end



--[[
partner's dialogue can be changed by walking over markers that indicate where in a map you're standing. This gives you the ability
to have the partner's dialogue be much more dynamic than the normal PMD games. This command is basically just going to a giant
case statement methinks.
]]--
function PartnerEssentials.GetPartnerDialogue(partner)
	
	assert(pcall(load("PartnerEssentials.Chapter_" .. tostring(SV.ChapterProgression.Chapter) .. "_Dialogue(...)"), partner))
	
end

function PartnerEssentials.GetPartnerDialogue(partner2)
	
	assert(pcall(load("PartnerEssentials.Chapter_" .. tostring(SV.ChapterProgression.Chapter) .. "_Dialogue(...)"), partner2))
	
end




function PartnerEssentials.GetPartnerDungeonDialogue()
end



