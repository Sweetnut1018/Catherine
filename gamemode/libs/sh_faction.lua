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

catherine.faction = catherine.faction or { }
catherine.faction.Lists = { }
local META = FindMetaTable( "Player" )

function catherine.faction.Register( factionTable )
	if ( !factionTable or !factionTable.index ) then
		catherine.util.ErrorPrint( "Faction register error, can't found faction table!" )
		return
	end
	
	catherine.faction.Lists[ factionTable.index ] = factionTable
	team.SetUp( factionTable.index, factionTable.name, factionTable.color )
	
	return factionTable.index
end

function catherine.faction.New( uniqueID )
	return { uniqueID = uniqueID, index = table.Count( catherine.faction.Lists ) + 1 }
end

function catherine.faction.GetPlayerUsableFaction( pl )
	local factions = { }
	
	for k, v in pairs( catherine.faction.GetAll( ) ) do
		if ( v.isWhitelist and ( SERVER and catherine.faction.HasWhiteList( pl, v.uniqueID ) or catherine.faction.HasWhiteList( v.uniqueID ) ) == false ) then continue end
		factions[ #factions + 1 ] = v
	end
	
	return factions
end

function catherine.faction.GetAll( )
	return catherine.faction.Lists
end

function catherine.faction.FindByName( name )
	for k, v in pairs( catherine.faction.GetAll( ) ) do
		if ( v.name == name ) then
			return v
		end
	end
end

function catherine.faction.FindByID( id )
	for k, v in pairs( catherine.faction.GetAll( ) ) do
		if ( v.uniqueID == id ) then
			return v
		end
	end
end

function catherine.faction.FindByIndex( index )
	for k, v in pairs( catherine.faction.GetAll( ) ) do
		if ( v.index == index ) then
			return v
		end
	end
end

function catherine.faction.Include( dir )
	for k, v in pairs( file.Find( dir .. "/factions/*.lua", "LUA" ) ) do
		catherine.util.Include( dir .. "/factions/" .. v, "SHARED" )
	end
end

if ( SERVER ) then
	function catherine.faction.AddWhiteList( pl, id )
		local factionTable = catherine.faction.FindByID( id )
		
		if ( !factionTable or !factionTable.isWhitelist or catherine.faction.HasWhiteList( pl, id ) ) then
			return false, "Faction_Notify_NotValid", { id }
		end
		
		if ( !factionTable.isWhitelist ) then
			return false, "Faction_Notify_NotWhitelist", { id }
		end
		
		if ( catherine.faction.HasWhiteList( pl, id ) ) then
			return false, "Faction_Notify_AlreadyHas", { pl:Name( ), id }
		end
		
		local whiteLists = catherine.catData.GetVar( pl, "whitelists", { } )
		whiteLists[ #whiteLists + 1 ] = id
		
		catherine.catData.SetVar( pl, "whitelists", whiteLists, false, true )
		return true
	end
	
	function catherine.faction.RemoveWhiteList( pl, id )
		local factionTable = catherine.faction.FindByID( id )
		
		if ( !factionTable ) then
			return false, "Faction_Notify_NotValid", { id }
		end
		
		if ( !factionTable.isWhitelist ) then
			return false, "Faction_Notify_NotWhitelist", { id }
		end
		
		if ( !catherine.faction.HasWhiteList( pl, id ) ) then
			return false, "Faction_Notify_HasNot", { pl:Name( ), id }
		end
		
		local whiteLists = catherine.catData.GetVar( pl, "whitelists", { } )
		table.RemoveByValue( whiteLists, id )
		
		catherine.catData.SetVar( pl, "whitelists", whiteLists, false, true )
		return true
	end

	function catherine.faction.HasWhiteList( pl, id )
		local whiteLists = catherine.catData.GetVar( pl, "whitelists", { } )
		
		return table.HasValue( whiteLists, id )
	end
	
	function META:HasWhiteList( id )
		return catherine.faction.HasWhiteList( self, id )
	end
	
	function catherine.faction.PlayerFirstSpawned( pl )
		local factionTable = catherine.faction.FindByIndex( pl:Team( ) )
		if ( !factionTable or !factionTable.PlayerFirstSpawned ) then return end
		
		factionTable:PlayerFirstSpawned( pl )
	end
	
	hook.Add( "PlayerFirstSpawned", "catherine.faction.PlayerFirstSpawned", catherine.faction.PlayerFirstSpawned )
else
	function catherine.faction.HasWhiteList( id )
		local whiteLists = catherine.catData.GetVar( "whitelists", { } )
		
		return table.HasValue( whiteLists, id )
	end
	
	function META:HasWhiteList( id )
		return catherine.faction.HasWhiteList( id )
	end
end

catherine.command.Register( {
	command = "plygivewhitelist",
	syntax = "[Name] [Faction Name]",
	canRun = function( pl ) return pl:IsSuperAdmin( ) end,
	runFunc = function( pl, args )
		if ( args[ 1 ] ) then
			if ( args[ 2 ] ) then
				local target = catherine.util.FindPlayerByName( args[ 1 ] )
				
				if ( IsValid( target ) and target:IsPlayer( ) ) then
					local success, langKey, par = catherine.faction.AddWhiteList( target, args[ 2 ] )
					
					if ( success ) then
						catherine.util.NotifyAllLang( "Faction_Notify_Give", pl:Name( ), args[ 2 ], target:Name( ) )
					else
						catherine.util.NotifyLang( pl, langKey, unpack( par or { } ) )
					end
				else
					catherine.util.NotifyLang( pl, "Basic_Notify_UnknownPlayer" )
				end
			else
				catherine.util.NotifyLang( pl, "Basic_Notify_NoArg", 2 )
			end
		else
			catherine.util.NotifyLang( pl, "Basic_Notify_NoArg", 1 )
		end
	end
} )

catherine.command.Register( {
	command = "plytakewhitelist",
	syntax = "[Name] [Faction Name]",
	canRun = function( pl ) return pl:IsSuperAdmin( ) end,
	runFunc = function( pl, args )
		if ( args[ 1 ] ) then
			if ( args[ 2 ] ) then
				local target = catherine.util.FindPlayerByName( args[ 1 ] )
				
				if ( IsValid( target ) and target:IsPlayer( ) ) then
					local success, langKey, par = catherine.faction.RemoveWhiteList( target, args[ 2 ] )
					
					if ( success ) then
						catherine.util.NotifyAllLang( "Faction_Notify_Take", pl:Name( ), args[ 2 ], target:Name( ) )
					else
						catherine.util.NotifyLang( pl, langKey, unpack( par or { } ) )
					end
				else
					catherine.util.NotifyLang( pl, "Basic_Notify_UnknownPlayer" )
				end
			else
				catherine.util.NotifyLang( pl, "Basic_Notify_NoArg", 2 )
			end
		else
			catherine.util.NotifyLang( pl, "Basic_Notify_NoArg", 1 )
		end
	end
} )