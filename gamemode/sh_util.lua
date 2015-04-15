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

catherine.util = catherine.util or { }

function catherine.util.Print( col, message )
	if ( !message ) then return end
	if ( !col ) then col = Color( 255, 255, 255 ) end
	MsgC( col, "[CAT] " .. message .. "\n" )
end

function catherine.util.ErrorPrint( message )
	if ( !message ) then return end
	MsgC( Color( 0, 255, 255 ), "[CAT LUA ERROR] " .. message .. "\n" )
end

function catherine.util.Include( dir, typ )
	if ( !dir ) then return end
	dir = dir:lower( )
	
	if ( SERVER and ( typ == "SERVER" or dir:find( "sv_" ) ) ) then 
		include( dir )
	elseif ( typ == "CLIENT" or dir:find( "cl_" ) ) then
		if ( SERVER ) then 
			AddCSLuaFile( dir )
		else 
			include( dir )
		end
	elseif ( typ == "SHARED" or dir:find( "sh_" ) ) then
		AddCSLuaFile( dir )
		include( dir )
	end
end

function catherine.util.IncludeInDir( dir, isCat )
	if ( !dir or ( !isCat or dir:find( "schema/" ) ) and !Schema ) then return end
	local dir2 = ( ( isCat and "catherine" ) or Schema.FolderName ) .. "/gamemode/" .. dir .. "/*.lua"
	
	for k, v in pairs( file.Find( dir2, "LUA" ) ) do
		catherine.util.Include( dir .. "/" .. v )
	end
end

function catherine.util.CalcDistanceByPos( loc, target )
	if ( !IsValid( loc ) or !IsValid( target ) ) then return 0 end
	return loc:GetPos( ):Distance( target:GetPos( ) )
end

function catherine.util.FindPlayerByName( name )
	if ( !name ) then return end
	
	for k, v in pairs( player.GetAllByLoaded( ) ) do
		if ( catherine.util.CheckStringMatch( v:Name( ), name ) ) then
			return v
		end
	end
end

function catherine.util.FindPlayerByStuff( use, str )
	if ( !use or !str ) then return end

	for k, v in pairs( player.GetAllByLoaded( ) ) do
		if ( catherine.util.CheckStringMatch( v[ use ]( v ), str ) ) then
			return v
		end
	end
end

function catherine.util.CheckStringMatch( one, two )
	if ( !one or !two ) then return false end
	return one:lower( ):match( two:lower( ) )
end

function catherine.util.GetUniqueName( name )
	if ( !name ) then return end
	return name:sub( 4, -5 )
end

function catherine.util.GetRealTime( )
	local one, dst, hour = os.date( "*t" ), os.date( "%p" ), os.date( "%I" )
	return one.year .. "-" .. one.month .. "-" .. one.day .. " | " .. dst .. " " .. hour .. ":" .. os.date( "%M" )
end

function catherine.util.FolderDirectoryTranslate( dir )
	if ( !dir ) then return end
	if ( dir:sub( 1, 1 ) != "/" ) then dir = "/" .. dir end
	local ex = string.Explode( "/", dir )
	
	for k, v in pairs( ex ) do
		if ( v != "" ) then continue end
		table.remove( ex, k )
	end
	
	return ex
end

function catherine.util.GetItemDropPos( pl )
	local data = { }
	data.start = pl:GetShootPos( ) - pl:GetAimVector( ) * 64
	data.endpos = pl:GetShootPos( ) + pl:GetAimVector( ) * 86
	data.filter = pl
	local tr = util.TraceLine( data )

	return tr.HitPos + tr.HitNormal * 36
end

local holdTypes = {
	weapon_physgun = "smg",
	weapon_physcannon = "smg",
	weapon_stunstick = "melee",
	weapon_crowbar = "melee",
	weapon_stunstick = "melee",
	weapon_357 = "pistol",
	weapon_pistol = "pistol",
	weapon_smg1 = "smg",
	weapon_ar2 = "smg",
	weapon_crossbow = "smg",
	weapon_shotgun = "shotgun",
	weapon_frag = "grenade",
	weapon_slam = "grenade",
	weapon_rpg = "shotgun",
	weapon_bugbait = "melee",
	weapon_annabelle = "shotgun",
	gmod_tool = "pistol"
}

local translateHoldType = {
	melee2 = "melee",
	fist = "melee",
	knife = "melee",
	ar2 = "smg",
	physgun = "smg",
	crossbow = "smg",
	slam = "grenade",
	passive = "normal",
	rpg = "shotgun"
}

function catherine.util.GetHoldType( wep )
	local holdType = holdTypes[ wep:GetClass( ) ]
	if ( holdType ) then
		return holdType
	elseif ( wep.HoldType ) then
		return translateHoldType[ wep.HoldType ] or wep.HoldType
	else
		return "normal"
	end
end

catherine.util.IncludeInDir( "libs/external", true )

if ( SERVER ) then
	catherine.util.Receiver = catherine.util.Receiver or { String = { }, Query = { } }
	
	function catherine.util.Notify( pl, message, time )
		if ( !IsValid( pl ) or !message ) then return end
		netstream.Start( pl, "catherine.util.Notify", { message, time } )
	end
	
	function catherine.util.NotifyAll( message, time )
		if ( !message ) then return end
		netstream.Start( player.GetAllByLoaded( ), "catherine.util.Notify", { message, time } )
	end
	
	function catherine.util.NotifyAllLang( key, ... )
		if ( !key ) then return end
		netstream.Start( player.GetAllByLoaded( ), "catherine.util.NotifyAllLang", { key, { ... } } )
	end
	
	function catherine.util.NotifyLang( pl, key, ... )
		if ( !IsValid( pl ) or !key ) then return end
		netstream.Start( pl, "catherine.util.Notify", { LANG( pl, key, ... ) } )
	end
	
	function catherine.util.ProgressBar( pl, message, time, func )
		if ( !IsValid( pl ) or !message or !time ) then return end
		
		if ( func ) then
			timer.Simple( time, function( )
				if ( !IsValid( pl ) ) then return end
				func( pl )
			end )
		end
		
		netstream.Start( pl, "catherine.util.ProgressBar", { message, time } )
	end
	
	function catherine.util.TopNotify( pl, message )
		if ( !IsValid( pl ) or message == nil ) then return end
		netstream.Start( pl, "catherine.util.TopNotify", message )
	end

	function catherine.util.PlaySound( pl, dir )
		if ( !dir ) then return end
		netstream.Start( pl, "catherine.util.PlaySound", dir )
	end

	function catherine.util.AddResourceInFolder( dir )
		if ( !dir ) then return end
		local files, dirs = file.Find( dir .. "/*", "GAME" )
		
		for _, v in pairs( dirs ) do
			if ( v == ".svn" ) then	continue end
			catherine.util.AddResourceInFolder( dir .. "/" .. v )
		end
		
		for k, v in pairs( files ) do
			resource.AddFile( dir .. "/" .. v )
		end
	end

	function catherine.util.StringReceiver( pl, id, msg, defV, func )
		if ( !IsValid( pl ) or !id or !msg or !func ) then return end
		if ( !defV ) then defV = "" end
		local steamID = pl:SteamID( )
		
		catherine.util.Receiver.String[ steamID ] = catherine.util.Receiver.String[ steamID ] or { }
		catherine.util.Receiver.String[ steamID ][ id ] = func
		
		netstream.Start( pl, "catherine.util.StringReceiver", { id, msg, defV } )
	end
	
	function catherine.util.QueryReceiver( pl, id, msg, func )
		if ( !IsValid( pl ) or !id or !msg or !func ) then return end
		local steamID = pl:SteamID( )
		
		catherine.util.Receiver.Query[ steamID ] = catherine.util.Receiver.Query[ steamID ] or { }
		catherine.util.Receiver.Query[ steamID ][ id ] = func
		
		netstream.Start( pl, "catherine.util.QueryReceiver", { id, msg } )
	end
	
	function catherine.util.ScreenColorEffect( pl, col, time, fadeTime )
		if ( !IsValid( pl ) ) then return end
		netstream.Start( pl, "catherine.util.ScreenColorEffect", { col or Color( 255, 255, 255 ), time, fadeTime } )
	end

	netstream.Hook( "catherine.util.StringReceiver_Receive", function( pl, data )
		local id = data[ 1 ]
		local steamID = pl:SteamID( )
		local rec = catherine.util.Receiver.String
		
		if ( !rec[ steamID ] or !rec[ steamID ][ id ] ) then return end
		
		rec[ steamID ][ id ]( pl, data[ 2 ] )
		catherine.util.Receiver.String[ steamID ][ id ] = nil
	end )
	
	netstream.Hook( "catherine.util.QueryReceiver_Receive", function( pl, data )
		local id = data[ 1 ]
		local steamID = pl:SteamID( )
		local rec = catherine.util.Receiver.Query
		
		if ( !rec[ steamID ] or !rec[ steamID ][ id ] ) then return end
		
		rec[ steamID ][ id ]( pl, data[ 2 ] )
		catherine.util.Receiver.Query[ steamID ][ id ] = nil
	end )
else
	catherine.util.blurTexture = Material( "pp/blurscreen" )
	CAT_UTIL_BUTTOMSOUND_1 = 1
	CAT_UTIL_BUTTOMSOUND_2 = 2
	CAT_UTIL_BUTTOMSOUND_3 = 3
	
	netstream.Hook( "catherine.util.StringReceiver", function( data )
		Derma_StringRequest( data[ 2 ], LANG( "Basic_UI_StringRequest" ), data[ 3 ], function( val )
				netstream.Start( "catherine.util.StringReceiver_Receive", { data[ 1 ], val } )
			end, function( ) end, LANG( "Basic_UI_OK" ), LANG( "Basic_UI_NO" )
		)
	end )
	
	netstream.Hook( "catherine.util.QueryReceiver", function( data )
		Derma_Query( data[ 2 ], LANG( "Basic_UI_Question" ), LANG( "Basic_UI_OK" ), function( )
				netstream.Start( "catherine.util.QueryReceiver_Receive", { data[ 1 ], true } )
			end, LANG( "Basic_UI_NO" ), function( ) 
				netstream.Start( "catherine.util.QueryReceiver_Receive", { data[ 1 ], false } )
			end
		)
	end )
	
	netstream.Hook( "catherine.util.ScreenColorEffect", function( data )
		local col = data[ 1 ]
		local time = CurTime( ) + ( data[ 2 ] or 0.1 )
		local fadeTime = data[ 3 ] or 0.03
		local a = 255
		
		hook.Remove( "HUDPaint", "catherine.util.ScreenColorEffect" )
		hook.Add( "HUDPaint", "catherine.util.ScreenColorEffect", function( )
			if ( time <= CurTime( ) ) then
				a = Lerp( fadeTime, a, 0 )
				if ( math.Round( a ) <= 0 ) then
					hook.Remove( "HUDPaint", "catherine.util.ScreenColorEffect" )
				end
			end
			draw.RoundedBox( 0, 0, 0, ScrW( ), ScrH( ), Color( col.r, col.g, col.b, a ) )
		end )
	end )
	
	netstream.Hook( "catherine.util.PlaySound", function( data )
		surface.PlaySound( data )
	end )

	netstream.Hook( "catherine.util.Notify", function( data )
		catherine.notify.Add( data[ 1 ], data[ 2 ] )
	end )
	
	netstream.Hook( "catherine.util.NotifyAllLang", function( data )
		catherine.notify.Add( LANG( data[ 1 ], unpack( data[ 2 ] ) ) )
	end )

	netstream.Hook( "catherine.util.ProgressBar", function( data )
		catherine.hud.ProgressBarAdd( data[ 1 ], data[ 2 ] )
	end )
	
	netstream.Hook( "catherine.util.TopNotify", function( data )
		if ( data == false ) then
			catherine.hud.TopNotify = nil
			return
		end
		catherine.hud.TopNotifyAdd( data )
	end )

	function catherine.util.PlayButtonSound( typ )
		if ( typ == CAT_UTIL_BUTTOMSOUND_1 ) then
			surface.PlaySound( "CAT/ui/one.wav" )
		elseif ( typ == CAT_UTIL_BUTTOMSOUND_2 ) then
			surface.PlaySound( "CAT/ui/two.wav" )
		elseif ( typ == CAT_UTIL_BUTTOMSOUND_3 ) then
			surface.PlaySound( "CAT/ui/three.wav" )
		end
	end
	
	function catherine.util.DrawCoolText( message, font, x, y, col, xA, yA, backgroundCol, backgroundBor )
		if ( !message or !font or !x or !y ) then return end
		if ( !xA or !yA ) then xA = 1 yA = 1 end
		if ( !backgroundBor ) then backgroundBor = 5 end
		if ( !col ) then col = Color( 255, 255, 255, 255 ) end
		if ( !backgroundCol ) then backgroundCol = Color( 50, 50, 50, 255 ) end
		surface.SetFont( font )
		local textW, textH = surface.GetTextSize( message )
		
		draw.RoundedBox( 0, x - ( textW / 2 ) - ( backgroundBor ), y - ( textH / 2 ) - ( backgroundBor ), textW + ( backgroundBor * 2 ), textH + ( backgroundBor * 2 ), backgroundCol )
		draw.SimpleText( message, font, x, y, col, xA, yA )
	end
	
	function catherine.util.GetAlphaFromDistance( base, x, max )
		if ( !base or !x or !max ) then return 255 end
		return ( 1 - ( ( x:Distance( base ) ) / max ) ) * 255
	end
	
	function catherine.util.BlurDraw( x, y, w, h, amount )
		amount = amount or 5
		surface.SetMaterial( catherine.util.blurTexture )
		surface.SetDrawColor( 255, 255, 255 )
		
		local x2, y2 = x / ScrW( ), y / ScrH( )
		local w2, h2 = ( x + w ) / ScrW( ), ( y + h ) / ScrH( )

		for i = -0.2, 1, 0.2 do
			catherine.util.blurTexture:SetFloat( "$blur", i * amount )
			catherine.util.blurTexture:Recompute( )
			render.UpdateScreenEffectTexture( )
			surface.DrawTexturedRectUV( x, y, w, h, x2, y2, w2, h2 )
		end
	end
end