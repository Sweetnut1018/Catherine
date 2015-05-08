--[[
< CATHERINE > - A free role-playing framework for Garry's Mod.
Development and design by L7D.

Catherine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Catherine.  If not, see <http://www.gnu.org/licenses/>.
]]--

function GM:ShowHelp( pl )
	if ( !pl:IsCharacterLoaded( ) ) then return end
	local status = hook.Run( "CanLookF1", pl )
	if ( !status ) then return end
	
	netstream.Start( pl, "catherine.ShowHelp" )
end

function GM:ShowTeam( pl )
	if ( !pl:IsCharacterLoaded( ) ) then return end
	local status = hook.Run( "CanLookF2", pl )
	if ( !status ) then return end
	
	local ent = pl:GetEyeTrace( 70 ).Entity
	
	if ( IsValid( ent ) and catherine.entity.IsDoor( ent ) and !catherine.door.IsDoorDisabled( ent ) ) then
		local has, flag = catherine.door.IsHasDoorPermission( pl, ent )
		
		if ( has ) then
			if ( flag == CAT_DOOR_FLAG_BASIC ) then return end
			
			netstream.Start( pl, "catherine.door.DoorMenu", {
				ent:EntIndex( ),
				flag
			} )
		else
			local isBuyable = catherine.door.IsBuyableDoor( ent )
			if ( !isBuyable ) then return end
			
			catherine.util.QueryReceiver( pl, "BuyDoor_Question", LANG( pl, "Door_Notify_BuyQ" ), function( _, bool )
				if ( bool ) then
					catherine.command.Run( pl, "doorbuy" )
				end
			end )
		end
	else
		netstream.Start( pl, "catherine.recognize.SelectMenu" )
	end
end

function GM:CanLookF1( pl )
	return true
end

function GM:CanLookF2( pl )
	return true
end

function GM:PlayerFirstSpawned( pl, id )
	catherine.character.SetCharVar( pl, "originalModel", pl:GetModel( ) )
end

function GM:CharacterVarChanged( pl, key, value )
	if ( key == "_name" ) then
		hook.Run( "CharacterNameChanged", pl, value )
	elseif ( key == "_model" ) then
		pl:SetModel( value )
		pl:SetupHands( )
		catherine.character.SetCharVar( pl, "originalModel", value )
	end
end

function GM:CanPlayerSuicide( pl )
	return hook.Run( "PlayerCanSuicide", pl ) or false
end

function GM:GetGameDescription( )
	return "CAT - " .. ( Schema and Schema.Name or "Unknown" )
end

function GM:PlayerSpray( pl )
	return !hook.Run( "PlayerCanSpray", pl )
end

function GM:Move( pl, moveData )
	if ( pl:IsCharacterLoaded( ) and pl:GetNetVar( "isActioning" ) ) then
		moveData:SetForwardSpeed( 0 )
		moveData:SetSideSpeed( 0 )
	end
end

function GM:PlayerSpawn( pl )
	if ( IsValid( pl.deathBody ) ) then
		pl.deathBody:Remove( )
		pl.deathBody = nil
	end
	
	if ( IsValid( pl.CAT_ragdoll ) ) then
		pl.CAT_ragdoll:Remove( )
		pl.CAT_ragdoll = nil
	end
	
	pl.CAT_deathSoundPlayed = nil

	pl:SetNetVar( "noDrawOriginal", nil )
	
	pl:SetNoDraw( false )
	pl:Freeze( false )
	pl:ConCommand( "-duck" )
	pl:SetColor( Color( 255, 255, 255, 255 ) )
	pl:SetNetVar( "isTied", false )
	pl:SetupHands( )

	local status = hook.Run( "PlayerCanFlashlight", pl ) or false
	pl:AllowFlashlight( status )

	if ( pl:IsCharacterLoaded( ) and !pl.CAT_loadingChar ) then
		hook.Run( "PlayerSpawnedInCharacter", pl )
	end
end

function GM:ScalePlayerDamage( pl, hitGroup, dmgInfo )
	if ( !pl:IsPlayer( ) ) then return end

	catherine.util.ScreenColorEffect( pl, Color( 255, 150, 150 ), 0.5, 0.01 )
	
	if ( hitGroup == CAT_BODY_ID_HEAD ) then
		catherine.util.ScreenColorEffect( pl, nil, 2, 0.005 )
	end
end

function GM:PlayerSpawnedInCharacter( pl )
	catherine.util.ScreenColorEffect( pl, nil, 0.5, 0.01 )
	hook.Run( "OnSpawnedInCharacter", pl )
	
	if ( catherine.configs.giveHand ) then
		pl:Give( "cat_fist" )
	end
	
	if ( catherine.configs.giveKey ) then
		pl:Give( "cat_key" )
	end
end

function GM:PlayerSetHandsModel( pl, ent )
	local info = player_manager.TranslatePlayerHands( player_manager.TranslateToPlayerModelName( pl:GetModel( ) ) )
	
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:PlayerAuthed( pl )
	timer.Simple( 2, function( )
		catherine.chat.Send( pl, "connect" )
		catherine.log.Add( CAT_LOG_FLAG_IMPORTANT, pl:SteamName( ) .. ", " .. pl:SteamID( ) .. " has connected a server." )
		
		hook.Run( "PlayerLoadFinished", pl )
	end )
end

function GM:PlayerDisconnected( pl )
	if ( IsValid( pl.deathBody ) ) then
		pl.deathBody:Remove( )
	end
	
	catherine.chat.Send( pl, "disconnect" )
	catherine.log.Add( CAT_LOG_FLAG_IMPORTANT, pl:SteamName( ) .. ", " .. pl:SteamID( ) .. " has disconnected a server." )
	
	if ( pl:IsCharacterLoaded( ) ) then
		hook.Run( "PlayerDisconnectedInCharacter", pl )
	end
end

function GM:PlayerCanHearPlayersVoice( pl, target )
	return catherine.configs.voiceAllow, catherine.configs.voice3D
end

function GM:EntityTakeDamage( ent, dmginfo )
	local entPlayer = ent
	
	if ( ent:GetClass( ) == "prop_ragdoll" ) then
		local pl = ent:GetNetVar( "player" )
		
		if ( IsValid( pl ) and pl:IsPlayer( ) ) then
			local inflictor = dmginfo:GetInflictor( )
			local attacker = dmginfo:GetAttacker( )
			local amount = dmginfo:GetDamage( )
			
			pl.CAT_ignore_hurtSound = true
			pl:TakeDamage( amount, attacker, inflictor )
			pl.CAT_ignore_hurtSound = nil

			if ( pl:Health( ) <= 0 ) then
				if ( !pl.CAT_deathSoundPlayed ) then
					hook.Run( "PlayerDeathSound", pl, ent )
				end
			else
				hook.Run( "PlayerTakeDamage", pl, attacker, ent )
			end
		end
	end
	
	if ( ent:IsPlayer( ) and dmginfo:IsBulletDamage( ) ) then
		ent:SetRunSpeed( ent:GetWalkSpeed( ) )
		
		local steamID = ent:SteamID( )
		timer.Remove( "Catherine.timer.RunSpamProtection_" .. steamID )
		timer.Create( "Catherine.timer.RunSpamProtection_" .. steamID, 2, 1, function( )
			ent:SetRunSpeed( catherine.configs.playerDefaultRunSpeed )
		end )
	end
end

function GM:PlayerCanFlashlight( pl )
	return true
end

function GM:KeyPress( pl, key )
	if ( key == IN_RELOAD ) then
		timer.Create( "Catherine.timer.WeaponToggle." .. pl:SteamID( ), 1, 1, function( )
			pl.ToggleWeaponRaised( pl )
		end )
	elseif ( key == IN_USE ) then
		local data = { }
		data.start = pl:GetShootPos( )
		data.endpos = data.start + pl:GetAimVector( ) * 60
		data.filter = pl
		local ent = util.TraceLine( data ).Entity
		
		if ( !IsValid( ent ) ) then return end
		
		if ( ent:GetClass( ) == "prop_ragdoll" ) then
			ent = ent.GetNetVar( ent, "player" )
		end
		
		if ( IsValid( ent ) and ent:IsPlayer( ) ) then
			return hook.Run( "PlayerInteract", pl, ent )
		end

		if ( IsValid( ent ) and catherine.entity.IsDoor( ent ) ) then
			if ( hook.Run( "PlayerCanUseDoor", pl, ent ) == false ) then
				return
			end
			
			catherine.door.DoorSpamProtection( pl, ent )

			return hook.Run( "PlayerUseDoor", pl, ent )
		elseif ( IsValid( ent ) and ent.IsCustomUse ) then
			netstream.Start( pl, "catherine.entity.CustomUseMenu", ent:EntIndex( ) )
		end
	end
end

function GM:PlayerUse( pl, ent )
	if ( catherine.player.IsTied( pl ) ) then
		if ( ( pl.CAT_tiedMSG or CurTime( ) ) <= CurTime( ) ) then
			catherine.util.NotifyLang( pl, "Item_Notify03_ZT" )
			pl.CAT_tiedMSG = CurTime( ) + 5
		end
		
		return false
	end

	local isDoor = catherine.entity.IsDoor( ent )
	
	return ( isDoor and !pl.CAT_cantUseDoor == true ) and true or !isDoor and true
end

function GM:PlayerSay( pl, text )
	catherine.chat.Run( pl, text )
end

function GM:KeyRelease( pl, key )
	if ( key == IN_RELOAD ) then
		timer.Remove( "Catherine.timer.WeaponToggle." .. pl:SteamID( ) )
	end
end

function GM:PlayerInitialSpawn( pl )
	timer.Simple( 1, function( )
		pl:SetNoDraw( true )
		catherine.player.Initialize( pl )
	end )
end

function GM:PlayerGiveSWEP( pl )
	return pl:IsAdmin( )
end

function GM:PlayerSpawnSWEP( pl )
	return pl:IsAdmin( )
end

function GM:PlayerSpawnEffect( pl )
	return pl:HasFlag( "s" )
end

function GM:PlayerSpawnRagdoll( pl )
	return pl:HasFlag( "R" )
end

function GM:PlayerSpawnNPC( pl )
	return pl:HasFlag( "n" )
end

function GM:PlayerSpawnVehicle( pl )
	return pl:HasFlag( "V" )
end

function GM:PlayerSpawnSENT( pl )
	return pl:HasFlag( "x" )
end

function GM:PlayerSpawnObject( pl )
	return pl:HasFlag( "e" )
end

function GM:PlayerSpawnProp( pl )
	return pl:HasFlag( "e" )
end

function GM:PlayerTakeDamage( pl, attacker, ragdollEntity )
	if ( pl:Health( ) <= 0 ) then
		return true
	end
	
	pl.CAT_healthRecover = true

	local sound = hook.Run( "GetPlayerPainSound", pl )
	local gender = pl:GetGender( )
	
	if ( !sound ) then
		local hitGroup = pl:LastHitGroup( )
		
		if ( hitGroup == HITGROUP_HEAD ) then
			sound = "vo/npc/" .. gender .. "01/ow0" .. math.random( 1, 2 ) .. ".wav"
		elseif ( hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC ) then
			sound = "vo/npc/" .. gender .. "01/hitingut0" .. math.random( 1, 2 ) .. ".wav"
		elseif ( hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG ) then
			sound = "vo/npc/" .. gender .. "01/myleg0" .. math.random( 1, 2 ) .. ".wav"
		elseif ( hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM ) then
			sound = "vo/npc/" .. gender .. "01/myarm0" .. math.random( 1, 2 ) .. ".wav"
		elseif ( hitGroup == HITGROUP_GEAR ) then
			sound = "vo/npc/" .. gender .. "01/startle0" .. math.random( 1, 2 ) .. ".wav"
		end
	end
	
	catherine.util.ScreenColorEffect( pl, Color( 255, 150, 150 ), 0.5, 0.01 )

	if ( IsValid( ragdollEntity ) ) then
		ragdollEntity:EmitSound( sound or "vo/npc/" .. gender .. "01/pain0" .. math.random( 1, 6 ) .. ".wav" )
		
		return true
	end

	pl:EmitSound( sound or "vo/npc/" .. gender .. "01/pain0" .. math.random( 1, 6 ) .. ".wav" )
	
	return true
end

function GM:PlayerHurt( pl, attacker )
	return !pl.CAT_ignore_hurtSound and hook.Run( "PlayerTakeDamage", pl, attacker ) or true
end

function GM:PlayerDeathSound( pl, ragdollEntity )
	local sound = hook.Run( "GetPlayerDeathSound", pl )
	local gender = pl:GetGender( )
	
	if ( IsValid( ragdollEntity ) ) then
		ragdollEntity:EmitSound( sound or "vo/npc/" .. gender .. "01/pain0" .. math.random( 7, 9 ) .. ".wav" )
		pl.CAT_deathSoundPlayed = true
		
		return true
	end
	
	pl:EmitSound( sound or "vo/npc/" .. gender .. "01/pain0" .. math.random( 7, 9 ) .. ".wav" )
	pl.CAT_deathSoundPlayed = true
	
	return true
end

function GM:PlayerDeathThink( pl )

end

function GM:DoPlayerDeath( pl )
	pl:SetNoDraw( true )

	if ( !pl.CAT_ragdoll ) then
		local ent = ents.Create( "prop_ragdoll" )
		ent:SetAngles( pl:GetAngles( ) )
		ent:SetModel( pl:GetModel( ) )
		ent:SetPos( pl:GetPos( ) )
		ent:Spawn( )
		ent:Activate( )
		ent:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		ent.player = self
		ent:SetNetVar( "player", pl )
		
		pl:SetNetVar( "ragdollIndex", ent:EntIndex( ) )
		pl.deathBody = ent
	end
	
	pl:SetNetVar( "noDrawOriginal", true )
	pl:SetNetVar( "isRagdolled", nil )
end

function GM:PlayerDeath( pl )
	pl.CAT_healthRecover = nil
	
	local respawnTime = hook.Run( "GetRespawnTime", pl ) or catherine.configs.spawnTime
	
	catherine.util.ProgressBar( pl, LANG( pl, "Player_Message_Dead_01" ), respawnTime, function( )
		pl:Spawn( )
	end )

	pl:SetNetVar( "nextSpawnTime", CurTime( ) + respawnTime )
	pl:SetNetVar( "deathTime", CurTime( ) )
	
	catherine.log.Add( nil, pl:SteamName( ) .. ", " .. pl:SteamID( ) .. " has a died [Character Name : " .. pl:Name( ) .. "]", true )
	
	//hook.Run( "PlayerGone", pl ) :?
end

function GM:Tick( )
	for k, v in pairs( player.GetAllByLoaded( ) ) do
		catherine.player.BunnyHopProtection( v )
		catherine.player.HealthRecoverTick( v )
	end
end

function GM:GetUnknownTargetName( pl, target )
	return LANG( pl, "Recognize_UI_Unknown" )
end

function GM:PlayerShouldTakeDamage( )
	return true
end

function GM:GetFallDamage( pl, speed )
	return hook.Run( "GetOverrideFallDamage", pl, speed ) or ( speed - 580 ) * 0.8
end

function GM:InitPostEntity( )
	hook.Run( "DataLoad" )
	hook.Run( "SchemaDataLoad" )
	
	if ( catherine.configs.clearMap ) then
		catherine.util.RemoveEntityByClass( "item_healthcharger" )
		catherine.util.RemoveEntityByClass( "item_suitcharger" )
		catherine.util.RemoveEntityByClass( "prop_vehicle*" )
		catherine.util.RemoveEntityByClass( "weapon_*" )
	end
	
	catherine.log.Add( CAT_LOG_FLAG_IMPORTANT, "Catherine (Framework, Schema, Plugin) data has loaded." )
end

function GM:ShutDown( )
	catherine.log.Add( CAT_LOG_FLAG_IMPORTANT, "Shutting down ... :)" )
	
	hook.Run( "PostDataSave" )
	hook.Run( "DataSave" )
	hook.Run( "SchemaDataSave" )
end

function GM:Initialize( )
	MsgC( Color( 0, 255, 0 ), "[CAT] You are using Catherine '" .. catherine.version.Ver .. "' date Version, Thanks.\n" )
end

netstream.Hook( "catherine.IsTyping", function( pl, data )
	pl:SetNetVar( "isTyping", data )
	
	hook.Run( "ChatTypingChanged", pl, data )
end )