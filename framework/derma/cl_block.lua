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

local PANEL = { }

function PANEL:Init( )
	catherine.vgui.block = self
	
	self:SetMenuSize( ScrW( ) * 0.6, ScrH( ) * 0.8 )
	self:SetMenuName( LANG( "Block_UI_Title" ) )
	
	self.Lists = vgui.Create( "DPanelList", self )
	self.Lists:SetPos( 10, 35 )
	self.Lists:SetSize( self.w - 20, self.h - 80 )
	self.Lists:SetSpacing( 5 )
	self.Lists:EnableHorizontal( false )
	self.Lists:EnableVerticalScrollbar( true )
	self.Lists.Paint = function( pnl, w, h )
		catherine.theme.Draw( CAT_THEME_PNLLIST, w, h )
	end
	
	self.addBlock = vgui.Create( "catherine.vgui.button", self )
	self.addBlock:SetPos( self.w * 0.8 + 20, self.h - 35 )
	self.addBlock:SetSize( self.w - self.w * 0.8 - 30, 25 )
	self.addBlock:SetStr( LANG( "Block_UI_Add" ) )
	self.addBlock:SetStrFont( "catherine_normal20" )
	self.addBlock:SetStrColor( Color( 50, 50, 50, 255 ) )
	self.addBlock:SetGradientColor( Color( 255, 255, 255, 150 ) )
	self.addBlock.Click = function( )
		local menu = DermaMenu( )
		local subMenu = menu:AddSubMenu( LANG( "Block_UI_AddByPlayer" ) )
		
		for k, v in pairs( player.GetAll( ) ) do
			subMenu:AddOption( v:Name( ), function( )
				netstream.Start( "catherine.block.RegisterBySteamID", {
					v:SteamID( ),
					{ CAT_BLOCK_TYPE_ALL_CHAT, CAT_BLOCK_TYPE_PM_CHAT }
				} )
			end )
		end
		
		menu:AddOption( LANG( "Block_UI_AddBySteamID" ), function( )
			Derma_StringRequest( "", LANG( "Block_UI_AddBySteamID_Q" ), "", function( val )
					if ( val:match( "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
						netstream.Start( "catherine.block.RegisterBySteamID", {
							val,
							{ CAT_BLOCK_TYPE_ALL_CHAT, CAT_BLOCK_TYPE_PM_CHAT }
						} )
					else
						Derma_Message( LANG( "Player_Message_IsNotSteamID" ), LANG( "Basic_UI_Notify" ), LANG( "Basic_UI_OK" ) )
					end
				end, function( ) end, LANG( "Basic_UI_OK" ), LANG( "Basic_UI_NO" )
			)
		end )
		
		menu:Open( )
	end
	self.addBlock.PaintBackground = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 235, 235, 235, 255 ) )
	end
	
	self:BuildBlock( )
end

function PANEL:OnMenuRecovered( )
	self:BuildBlock( )
end

function PANEL:BuildBlock( )
	self.Lists:Clear( )
	
	for k, v in pairs( catherine.block.GetList( ) ) do
		local panel = vgui.Create( "DPanel" )
		panel:SetSize( self.Lists:GetWide( ), 70 )
		panel.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 50, 50, 50, 90 ) )
			
			draw.SimpleText( v.steamID, "catherine_normal20", 80, 20, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
			draw.SimpleText( v.time, "catherine_normal15", 80, 50, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
			
			local blockType = v.blockType
			
			if ( table.HasValue( blockType, CAT_BLOCK_TYPE_ALL_CHAT ) and table.HasValue( blockType, CAT_BLOCK_TYPE_PM_CHAT ) ) then
				draw.SimpleText( LANG( "Block_UI_AllChat" ) .. ", " .. LANG( "Block_UI_PM" ), "catherine_normal15", w - 170, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, 1 )
			elseif ( table.HasValue( blockType, CAT_BLOCK_TYPE_ALL_CHAT ) ) then
				draw.SimpleText( LANG( "Block_UI_AllChat" ), "catherine_normal15", w - 170, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, 1 )
			elseif ( table.HasValue( blockType, CAT_BLOCK_TYPE_PM_CHAT ) ) then
				draw.SimpleText( LANG( "Block_UI_PM" ), "catherine_normal15", w - 170, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, 1 )
			end
		end
		
		local avatar = vgui.Create( "AvatarImage", panel )
		avatar:SetPos( 5, 5 )
		avatar:SetSize( 60, 60 )
		avatar:SetSteamID( util.SteamIDTo64( v.steamID ), 64 )
		avatar.PaintOver = function( pnl, w, h )
			surface.SetDrawColor( 50, 50, 50, 150 )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
		
		local removeItem = vgui.Create( "catherine.vgui.button", panel )
		removeItem:SetPos( panel:GetWide( ) - 150, 10 )
		removeItem:SetSize( 140, 20 )
		removeItem:SetStr( LANG( "Block_UI_Dis" ) )
		removeItem:SetStrFont( "catherine_normal15" )
		removeItem:SetStrColor( Color( 50, 50, 50, 255 ) )
		removeItem:SetGradientColor( Color( 255, 255, 255, 150 ) )
		removeItem.Click = function( )
			netstream.Start( "catherine.block.RemoveBySteamID", v.steamID )
		end
		removeItem.PaintBackground = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 225, 150, 150, 150 ) )
		end
		
		local changeBlockType = vgui.Create( "catherine.vgui.button", panel )
		changeBlockType:SetPos( panel:GetWide( ) - 150, 40 )
		changeBlockType:SetSize( 140, 20 )
		changeBlockType:SetStr( LANG( "Block_UI_ChangeType" ) )
		changeBlockType:SetStrFont( "catherine_normal15" )
		changeBlockType:SetStrColor( Color( 50, 50, 50, 255 ) )
		changeBlockType:SetGradientColor( Color( 255, 255, 255, 150 ) )
		changeBlockType.Click = function( )
			local menu = DermaMenu( )
			local blockType = v.blockType
			
			if ( table.HasValue( blockType, CAT_BLOCK_TYPE_ALL_CHAT ) and table.HasValue( blockType, CAT_BLOCK_TYPE_PM_CHAT ) ) then
				menu:AddOption( LANG( "Block_UI_AllChatDis" ), function( )
					netstream.Start( "catherine.block.ChangeType", {
						v.steamID,
						{ CAT_BLOCK_TYPE_PM_CHAT }
					} )
				end )
				
				menu:AddOption( LANG( "Block_UI_PMDis" ), function( )
					netstream.Start( "catherine.block.ChangeType", {
						v.steamID,
						{ CAT_BLOCK_TYPE_ALL_CHAT }
					} )
				end )
			elseif ( table.HasValue( blockType, CAT_BLOCK_TYPE_ALL_CHAT ) ) then
				menu:AddOption( LANG( "Block_UI_AllChatDis" ), function( )
					netstream.Start( "catherine.block.ChangeType", {
						v.steamID,
						{ CAT_BLOCK_TYPE_PM_CHAT }
					} )
				end )
				
				menu:AddOption( LANG( "Block_UI_PM" ), function( )
					netstream.Start( "catherine.block.ChangeType", {
						v.steamID,
						{ CAT_BLOCK_TYPE_ALL_CHAT, CAT_BLOCK_TYPE_PM_CHAT }
					} )
				end )
			elseif ( table.HasValue( blockType, CAT_BLOCK_TYPE_PM_CHAT ) ) then
				menu:AddOption( LANG( "Block_UI_AllChat" ), function( )
					netstream.Start( "catherine.block.ChangeType", {
						v.steamID,
						{ CAT_BLOCK_TYPE_ALL_CHAT, CAT_BLOCK_TYPE_PM_CHAT }
					} )
				end )
				
				menu:AddOption( LANG( "Block_UI_PMDis" ), function( )
					netstream.Start( "catherine.block.ChangeType", {
						v.steamID,
						{ CAT_BLOCK_TYPE_ALL_CHAT }
					} )
				end )
			else
				
			end
			
			menu:Open( )
		end
		changeBlockType.PaintBackground = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 255 ) )
		end
		
		self.Lists:AddItem( panel )
	end
end

vgui.Register( "catherine.vgui.block", PANEL, "catherine.vgui.menuBase" )

catherine.menu.Register( function( )
	return LANG( "Block_UI_Title" )
end, "block", function( menuPnl, itemPnl )
	return IsValid( catherine.vgui.block ) and catherine.vgui.block or vgui.Create( "catherine.vgui.block", menuPnl )
end )