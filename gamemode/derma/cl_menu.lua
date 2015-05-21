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
	if ( IsValid( catherine.vgui.menu ) ) then
		catherine.vgui.menu:Remove( )
	end
	
	catherine.vgui.menu = self
	
	self.player = LocalPlayer( )
	self.w, self.h = ScrW( ), ScrH( )
	self.blurAmount = 0
	self.activePanelButton = nil
	self.activePanelShowW = 0
	self.activePanelShowX = 0
	
	local Ww, Xx = catherine.menu.GetActiveButtonData( )
	
	self.activePanelShowTargetW = Ww or 0
	self.activePanelShowTargetX = Xx or 0
	
	self:SetSize( self.w, self.h )
	self:Center( )
	self:SetTitle( "" )
	self:ShowCloseButton( false )
	self:SetDraggable( false )
	self:SetAlpha( 0 )
	self:AlphaTo( 255, 0.1, 0 )
	self:MakePopup( )
	
	local mainCol = catherine.configs.mainColor
	
	self.ListsBase = vgui.Create( "DPanel", self )
	self.ListsBase:SetSize( self.w, 50 )
	self.ListsBase:SetPos( 0, self.h )
	self.ListsBase:MoveTo( 0, self.h - self.ListsBase:GetTall( ), 0.2, 0.1, nil, function( )
		local delta = 0
		local pl = self.player
		local menuTable = catherine.menu.GetAll( )
		local xPos = 0
		
		for k, v in pairs( menuTable ) do
			if ( v.canLook and v.canLook( pl ) == false ) then continue end
			
			local menuItem, itemW = self:AddMenuItem( type( v.name ) == "function" and v.name( pl ) or v.name, v.func )
			menuItem:SetAlpha( 0 )
			menuItem:AlphaTo( 255, 0.2, delta )
			menuItem:SetItemXPos( xPos )
			
			xPos = xPos + itemW
			
			delta = delta + 0.05
			
			if ( k == #menuTable ) then
				catherine.menu.RecoverLastActivePanel( self )
			end
		end
	end )
	self.ListsBase.Paint = function( pnl, w, h )
		local x, y = self.ListsBase.Lists:GetPos( )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )
		
		self.activePanelShowX = Lerp( 0.09, self.activePanelShowX, x + self.activePanelShowTargetX )
		self.activePanelShowW = Lerp( 0.09, self.activePanelShowW, self.activePanelShowTargetW )

		draw.RoundedBox( 0, self.activePanelShowX, 0, self.activePanelShowW, 5, Color( mainCol.r, mainCol.g, mainCol.b, 235 ) )
	end
	
	self.ListsBase.Lists = vgui.Create( "DHorizontalScroller", self.ListsBase )
	self.ListsBase.Lists:SetSize( 0, self.ListsBase:GetTall( ) )
end

function PANEL:AddMenuItem( name, func )
	surface.SetFont( "catherine_normal20" )
	local tw, th = surface.GetTextSize( name )
	
	local menuItem = vgui.Create( "DButton" )
	menuItem:SetText( name )
	menuItem:SetFont( "catherine_normal20" )
	menuItem:SetTextColor( Color( 50, 50, 50 ) )
	menuItem:SetSize( tw + 30, self.ListsBase:GetTall( ) )
	menuItem:SetDrawBackground( false )
	menuItem.SetItemXPos = function( pnl, val )
		pnl.itemXPos = val
	end
	menuItem.DoClick = function( pnl )
		local activePanel = catherine.menu.GetActivePanel( )
		local activePanelName = catherine.menu.GetActivePanelName( )
		local x, y = pnl:GetPos( )
		
		if ( activePanelName and activePanelName == name ) then
			if ( IsValid( activePanel ) ) then
				activePanel:FakeHide( )
				catherine.menu.SetActivePanel( nil )
				catherine.menu.SetActivePanelName( nil )
				catherine.menu.SetActivePanelData( 0, 0 )
				self.activePanelShowTargetW = 0
				self.activePanelShowTargetX = 0
				
				hook.Run( "MenuItemClicked", CAT_MENU_STATUS_SAMEMENU )
			else
				local newActivePanel = func( self, pnl )
				
				if ( newActivePanel and type( newActivePanel ) == "Panel" and IsValid( newActivePanel ) ) then
					newActivePanel:Show( )
					newActivePanel:OnMenuRecovered( )
				end
				
				self.activePanelButton = pnl
				catherine.menu.SetActivePanel( newActivePanel )
				catherine.menu.SetActivePanelName( name )
				self.activePanelShowTargetW = pnl:GetWide( )
				self.activePanelShowTargetX = pnl.itemXPos
				
				hook.Run( "MenuItemClicked", CAT_MENU_STATUS_SAMEMENU_NO )
			end
		else
			if ( IsValid( activePanel ) ) then
				local newActivePanel = func( self, pnl )
				
				activePanel:FakeHide( )
				
				if ( newActivePanel and type( newActivePanel ) == "Panel" and IsValid( newActivePanel ) ) then
					newActivePanel:Show( )
					newActivePanel:OnMenuRecovered( )
				end
				
				self.activePanelButton = pnl
				catherine.menu.SetActivePanel( newActivePanel )
				catherine.menu.SetActivePanelName( name )
				self.activePanelShowTargetW = pnl:GetWide( )
				self.activePanelShowTargetX = pnl.itemXPos
				
				hook.Run( "MenuItemClicked", CAT_MENU_STATUS_NOTSAMEMENU )
			else
				local newActivePanel = func( self, pnl )
				
				if ( newActivePanel and type( newActivePanel ) == "Panel" and IsValid( newActivePanel ) ) then
					newActivePanel:Show( )
					newActivePanel:OnMenuRecovered( )
				end
				
				self.activePanelButton = pnl
				catherine.menu.SetActivePanel( newActivePanel )
				catherine.menu.SetActivePanelName( name )
				self.activePanelShowTargetW = pnl:GetWide( )
				self.activePanelShowTargetX = pnl.itemXPos
				
				hook.Run( "MenuItemClicked", CAT_MENU_STATUS_NOTSAMEMENU_NO )
			end
		end
	end
	
	local w = self.ListsBase.Lists:GetWide( )
	
	self.ListsBase.Lists:AddPanel( menuItem )
	self.ListsBase.Lists:SetWide( math.min( w + menuItem:GetWide( ), self.w ) )
	self.ListsBase.Lists:SetPos( self.w / 2 - w / 2, 0 )
	
	return menuItem, menuItem:GetWide( )
end

function PANEL:OnKeyCodePressed( key )
	if ( key == KEY_TAB ) then
		self:Close( )
	end
end

function PANEL:Paint( w, h )
	self.blurAmount = Lerp( 0.05, self.blurAmount, self.closeing and 0 or 3 )
	
	if ( self:IsVisible( ) ) then
		catherine.util.BlurDraw( 0, 0, w, h, self.blurAmount )
	end
end

function PANEL:Show( )
	self:SetVisible( true )
	
	self.blurAmount = 0
	self.activePanelButton = nil
	self.activePanelShowW = 0
	self.activePanelShowX = 0
	local Ww, Xx = catherine.menu.GetActiveButtonData( )
	self.activePanelShowTargetW = Ww or 0
	self.activePanelShowTargetX = Xx or 0
	
	local mainCol = catherine.configs.mainColor
	
	if ( IsValid( self.ListsBase ) ) then
		self.ListsBase:Remove( )
		self.ListsBase.Lists:Remove( )
	end
	
	self.ListsBase = vgui.Create( "DPanel", self )
	self.ListsBase:SetSize( self.w, 50 )
	self.ListsBase:SetPos( 0, self.h )
	self.ListsBase:MoveTo( 0, self.h - self.ListsBase:GetTall( ), 0.2, 0.1, nil, function( )
		local delta = 0
		local pl = self.player
		local menuTable = catherine.menu.GetAll( )
		local xPos = 0
		
		for k, v in pairs( menuTable ) do
			if ( v.canLook and v.canLook( pl ) == false ) then continue end
			
			local menuItem, itemW = self:AddMenuItem( type( v.name ) == "function" and v.name( pl ) or v.name, v.func )
			menuItem:SetAlpha( 0 )
			menuItem:AlphaTo( 255, 0.2, delta )
			menuItem:SetItemXPos( xPos )
			
			xPos = xPos + itemW
			
			delta = delta + 0.05
			
			if ( k == #menuTable ) then
				catherine.menu.RecoverLastActivePanel( self )
			end
		end
	end )
	self.ListsBase.Paint = function( pnl, w, h )
		local x, y = self.ListsBase.Lists:GetPos( )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 235 ) )
		
		self.activePanelShowX = Lerp( 0.09, self.activePanelShowX, x + self.activePanelShowTargetX )
		self.activePanelShowW = Lerp( 0.09, self.activePanelShowW, self.activePanelShowTargetW )

		draw.RoundedBox( 0, self.activePanelShowX, 0, self.activePanelShowW, 5, Color( mainCol.r, mainCol.g, mainCol.b, 235 ) )
	end
	
	self.ListsBase.Lists = vgui.Create( "DHorizontalScroller", self.ListsBase )
	self.ListsBase.Lists:SetSize( 0, self.ListsBase:GetTall( ) )
	
	self.closeing = false
end

function PANEL:OnRemove( )
	local activePanel = catherine.menu.GetActivePanel( )
	
	if ( IsValid( self ) and IsValid( activePanel ) and self == pnl ) then
		activePanel:Close( )
	end
	
	catherine.menu.SetActivePanel( nil )
	catherine.menu.SetActivePanelName( nil )
	catherine.menu.SetActivePanelData( 0, 0 )
end

function PANEL:Close( )
	if ( self.closeing ) then return end
	
	CloseDermaMenus( )
	gui.EnableScreenClicker( false )
	self.closeing = true
	
	local activePanel = catherine.menu.GetActivePanel( )
	
	if ( IsValid( activePanel ) and type( activePanel ) == "Panel" ) then
		catherine.menu.SetActivePanelData( self.activePanelShowTargetW, self.activePanelShowTargetX )
		activePanel:FakeHide( )
	end

	self.ListsBase:MoveTo( self.w / 2 - self.ListsBase:GetWide( ) / 2, self.h, 0.2, 0, nil, function( anim, pnl )
		self:SetVisible( false )
	end )
end

vgui.Register( "catherine.vgui.menu", PANEL, "DFrame" )