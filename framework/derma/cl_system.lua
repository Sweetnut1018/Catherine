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
	catherine.vgui.system = self
	
	self.w, self.h = ScrW( ), ScrH( )
	self.x, self.y = ScrW( ) / 2 - self.w / 2, ScrH( ) / 2 - self.h / 2
	
	self:SetSize( self.w, self.h )
	self:SetPos( self.x, self.y )
	self:SetDraggable( false )
	self:ShowCloseButton( false )
	self:SetTitle( "" )
	self:MakePopup( )
	
	local foundNewMat = Material( "icon16/asterisk_orange.png" )
	local errorMat = Material( "icon16/exclamation.png" )
	local alreadyNewMat = Material( "CAT/ui/accept.png" )
	local firstMenuDelta = 0
	
	local panelWSize = ( self.w / 3 ) - ( 20 * 1.5 )
	
	self.updatePanel = vgui.Create( "DPanel", self )
	
	self.updatePanel.w, self.updatePanel.h = panelWSize, self.h * 0.45
	self.updatePanel.x, self.updatePanel.y = 20, 45
	self.updatePanel.status = false
	self.updatePanel.loadingAni = 0
	
	self.updatePanel:SetSize( self.updatePanel.w, self.updatePanel.h )
	self.updatePanel:SetPos( self.updatePanel.x, self.updatePanel.y )
	self.updatePanel:SetAlpha( 0 )
	self.updatePanel:AlphaTo( 255, 0.5, firstMenuDelta )
	
	firstMenuDelta = firstMenuDelta + 0.1
	self.updatePanel.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 150 ) )
		
		surface.SetDrawColor( 0, 0, 0, 90 )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, 30, w, 1, Color( 0, 0, 0, 90 ) )
		
		draw.SimpleText( LANG( "System_UI_Update_Title" ), "catherine_normal20", 10, 15, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
		draw.SimpleText( catherine.GetVersion( ) .. " " .. catherine.GetBuild( ), "catherine_normal20", w - 10, 15, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
		
		if ( pnl.status ) then
			pnl.Lists:SetVisible( false )
			
			pnl.loadingAni = math.Approach( pnl.loadingAni, pnl.loadingAni - 10, 10 )
			
			draw.NoTexture( )
			surface.SetDrawColor( 90, 90, 90, 255 )
			catherine.geometry.DrawCircle( w / 2, h / 2, 15, 5, 0, 360, 100 )
			
			draw.NoTexture( )
			surface.SetDrawColor( 255, 255, 255, 255 )
			catherine.geometry.DrawCircle( w / 2, h / 2, 15, 5, pnl.loadingAni, 70, 100 )
		else
			if ( !pnl.Lists:IsVisible( ) ) then
				pnl.Lists:SetVisible( true )
			end
			
			local data = catherine.net.GetNetGlobalVar( "cat_updateData", { } )
			
			if ( data.version != catherine.GetVersion( ) ) then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( foundNewMat )
				surface.DrawTexturedRect( 10, h - 97, 16, 16 )
				
				draw.SimpleText( LANG( "System_UI_Update_FoundNew" ), "catherine_normal15", 33, h - 90, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
			else
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( alreadyNewMat )
				surface.DrawTexturedRect( 10, h - 97, 16, 16 )
				
				draw.SimpleText( LANG( "System_UI_Update_AlreadyNew" ), "catherine_normal15", 33, h - 90, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
			end
		end
	end
	self.updatePanel.RefreshHistory = function( pnl )
		pnl.Lists:Clear( )
		local data = catherine.net.GetNetGlobalVar( "cat_updateData", { } )
		
		if ( data.history ) then
			for k, v in pairs( data.history ) do
				local mat = nil
				
				if ( v.icon ) then
					mat = Material( v.icon )
				end
				
				local panel = vgui.Create( "DPanel" )
				panel:SetSize( pnl.Lists:GetWide( ), 30 )
				panel.Paint = function( pnl2, w, h )
					draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 90 ) )
					draw.SimpleText( v.text, "catherine_normal15", 10, h / 2, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
					
					if ( mat ) then
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetMaterial( mat )
						surface.DrawTexturedRect( w - 25, h / 2 - 16 / 2, 16, 16 )
					end
				end
				
				pnl.Lists:AddItem( panel )
			end
		end
	end
	
	self.updatePanel.Lists = vgui.Create( "DPanelList", self.updatePanel )
	self.updatePanel.Lists:SetPos( 10, 40 )
	self.updatePanel.Lists:SetSize( self.updatePanel.w - 20, self.updatePanel.h - 145 )
	self.updatePanel.Lists:SetSpacing( 5 )
	self.updatePanel.Lists:EnableHorizontal( false )
	self.updatePanel.Lists:EnableVerticalScrollbar( true )
	self.updatePanel.Lists:SetDrawBackground( false )
	
	self.updatePanel:RefreshHistory( )
	
	self.updatePanel.check = vgui.Create( "catherine.vgui.button", self.updatePanel )
	self.updatePanel.check.progressing = false
	self.updatePanel.check:SetSize( self.updatePanel.w - 15, 30 )
	self.updatePanel.check:SetPos( self.updatePanel.w / 2 - self.updatePanel.check:GetWide( ) / 2, self.updatePanel.h - self.updatePanel.check:GetTall( ) - 10 )
	self.updatePanel.check:SetStr( LANG( "System_UI_Update_CheckButton" ) )
	self.updatePanel.check:SetStrFont( "catherine_normal15" )
	self.updatePanel.check:SetStrColor( Color( 50, 50, 50, 255 ) )
	self.updatePanel.check:SetGradientColor( Color( 255, 255, 255, 150 ) )
	self.updatePanel.check.Click = function( pnl )
		if ( pnl.progressing ) then return end
		
		self.updatePanel.status = true
		netstream.Start( "catherine.update.Check" )
	end
	self.updatePanel.check.PaintBackground = function( pnl, w, h )
		if ( self.updatePanel.status and !pnl.progressing ) then
			pnl:SetStr( LANG( "System_UI_Update_CheckingUpdate" ) )
			pnl.progressing = true
		elseif ( !self.updatePanel.status and pnl.progressing ) then
			pnl:SetStr( LANG( "System_UI_Update_CheckButton" ) )
			pnl.progressing = false
		end
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
	end
	
	self.updatePanel.openLog = vgui.Create( "catherine.vgui.button", self.updatePanel )
	self.updatePanel.openLog:SetSize( self.updatePanel.w - 15, 30 )
	self.updatePanel.openLog:SetPos( self.updatePanel.w / 2 - self.updatePanel.openLog:GetWide( ) / 2, self.updatePanel.h - ( self.updatePanel.openLog:GetTall( ) * 2 ) - 15 )
	self.updatePanel.openLog:SetStr( LANG( "System_UI_Update_OpenUpdateLog" ) )
	self.updatePanel.openLog:SetStrFont( "catherine_normal15" )
	self.updatePanel.openLog:SetStrColor( Color( 50, 50, 50, 255 ) )
	self.updatePanel.openLog:SetGradientColor( Color( 255, 255, 255, 150 ) )
	self.updatePanel.openLog.Click = function( pnl )
		gui.OpenURL( "http://github.com/L7D/Catherine/commits" )
	end
	self.updatePanel.openLog.PaintBackground = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
	end
	
	self.pluginPanel = vgui.Create( "DPanel", self )
	
	self.pluginPanel.w, self.pluginPanel.h = panelWSize, self.h * 0.45
	self.pluginPanel.x, self.pluginPanel.y = self.w / 2 - self.updatePanel.w / 2, 45
	
	self.pluginPanel:SetSize( self.pluginPanel.w, self.pluginPanel.h )
	self.pluginPanel:SetPos( self.pluginPanel.x, self.pluginPanel.y )
	self.pluginPanel:SetAlpha( 0 )
	self.pluginPanel:AlphaTo( 255, 0.5, firstMenuDelta )
	
	firstMenuDelta = firstMenuDelta + 0.1
	self.pluginPanel.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 150 ) )
		
		surface.SetDrawColor( 0, 0, 0, 90 )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, 30, w, 1, Color( 0, 0, 0, 90 ) )
		
		draw.SimpleText( LANG( "System_UI_Plugin_Title" ), "catherine_normal20", 10, 15, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
		
		local pluginAll = catherine.plugin.GetAll( )
		
		local frameworkPluginsCount, schemaPluginsCount, deactivePluginsCount = 0, 0, 0
		
		for k, v in pairs( pluginAll ) do
			if ( !catherine.plugin.GetActive( k ) ) then
				deactivePluginsCount = deactivePluginsCount + 1
			end
			
			if ( v.isSchema == "b" ) then
				schemaPluginsCount = schemaPluginsCount + 1
			else
				frameworkPluginsCount = frameworkPluginsCount + 1
			end
		end
		
		draw.SimpleText( LANG( "System_UI_Plugin_ManagerAllPluginCount", table.Count( pluginAll ) ), "catherine_normal20", w / 2, h * 0.3, Color( 50, 50, 50, 255 ), 1, 1 )
		draw.SimpleText( LANG( "System_UI_Plugin_ManagerFrameworkPluginCount", frameworkPluginsCount ), "catherine_normal15", w / 2, h * 0.3 + 50, Color( 50, 50, 50, 255 ), 1, 1 )
		draw.SimpleText( LANG( "System_UI_Plugin_ManagerSchemaPluginCount", schemaPluginsCount ), "catherine_normal15", w / 2, h * 0.3 + 70, Color( 50, 50, 50, 255 ), 1, 1 )
		draw.SimpleText( LANG( "System_UI_Plugin_ManagerDeactivePluginCount", deactivePluginsCount ), "catherine_normal15", w / 2, h * 0.3 + 90, Color( 255, 90, 90, 255 ), 1, 1 )
	end
	
	self.pluginPanel.OpenManager = function( )
		local changed = false
		
		self.pluginManager = vgui.Create( "DFrame" )
		
		catherine.vgui.pluginManager = self.pluginManager
		
		self.pluginManager.w, self.pluginManager.h = ScrW( ), ScrH( )
		self.pluginManager.x, self.pluginManager.y = ScrW( ) / 2 - self.pluginManager.w / 2, ScrH( ) / 2 - self.pluginManager.h / 2
		
		self.pluginManager:SetSize( self.pluginManager.w, self.pluginManager.h )
		self.pluginManager:SetPos( self.pluginManager.x, self.pluginManager.y )
		self.pluginManager:SetDraggable( false )
		self.pluginManager:ShowCloseButton( false )
		self.pluginManager:SetTitle( "" )
		self.pluginManager:MakePopup( )
		self.pluginManager.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
			
			draw.SimpleText( LANG( "System_UI_Plugin_ManagerTitle" ), "catherine_normal25", 10, 20, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
			draw.SimpleText( LANG( "System_UI_Plugin_NameSearch" ), "catherine_normal15", w - pnl.searchEnt:GetWide( ) - 25, 23, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, 1 )
		
			local pluginAll = catherine.plugin.GetAll( )
		
			local frameworkPluginsCount, schemaPluginsCount, deactivePluginsCount = 0, 0, 0
			
			for k, v in pairs( pluginAll ) do
				if ( !catherine.plugin.GetActive( k ) ) then
					deactivePluginsCount = deactivePluginsCount + 1
				end
				
				if ( v.isSchema == "b" ) then
					schemaPluginsCount = schemaPluginsCount + 1
				else
					frameworkPluginsCount = frameworkPluginsCount + 1
				end
			end
			
			draw.SimpleText( LANG( "System_UI_Plugin_ManagerAllPluginCount", table.Count( pluginAll ) ) .. " : " .. LANG( "System_UI_Plugin_ManagerFrameworkPluginCount", frameworkPluginsCount ) .. ", " .. LANG( "System_UI_Plugin_ManagerSchemaPluginCount", schemaPluginsCount ) .. " - " .. LANG( "System_UI_Plugin_ManagerDeactivePluginCount", deactivePluginsCount ), "catherine_normal15", w - 10, h - 20, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
		end
		
		self.pluginManager.Close = function( pnl )
			if ( pnl.closing ) then return end
			
			pnl.closing = true
			
			pnl:Remove( )
			pnl = nil
		end
		
		self.pluginManager.searchEnt = vgui.Create( "DTextEntry", self.pluginManager )
		self.pluginManager.searchEnt:SetSize( self.pluginManager.w * 0.4, 20 )
		self.pluginManager.searchEnt:SetPos( self.pluginManager.w - self.pluginManager.searchEnt:GetWide( ) - 10, 13 )
		self.pluginManager.searchEnt:SetFont( "catherine_normal15" )
		self.pluginManager.searchEnt:SetText( "" )
		self.pluginManager.searchEnt:SetAllowNonAsciiCharacters( true )
		self.pluginManager.searchEnt.Paint = function( pnl, w, h )
			catherine.theme.Draw( CAT_THEME_TEXTENT, w, h )
			pnl:DrawTextEntryText( Color( 50, 50, 50 ), Color( 45, 45, 45 ), Color( 50, 50, 50 ) )
		end
		self.pluginManager.searchEnt.OnTextChanged = function( pnl )
			local text = pnl:GetText( )
			
			if ( text == "" ) then
				self.pluginManager:SearchString( text, true )
			else
				self.pluginManager:SearchString( text )
			end
		end
		self.pluginManager.searchEnt.OnEnter = function( pnl )
			self.pluginManager:SearchString( pnl:GetText( ) )
		end
		
		self.pluginManager.Lists = vgui.Create( "DPanelList", self.pluginManager )
		self.pluginManager.Lists:SetPos( 10, 45 )
		self.pluginManager.Lists:SetSize( self.pluginManager.w - 20, self.pluginManager.h - 90 )
		self.pluginManager.Lists:SetSpacing( 0 )
		self.pluginManager.Lists:EnableHorizontal( false )
		self.pluginManager.Lists:EnableVerticalScrollbar( true )
		self.pluginManager.Lists.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, 1, Color( 0, 0, 0, 90 ) )
			draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 90 ) )
		end
		
		self.pluginManager.SearchString = function( pnl, text, force )
			pnl.Lists:Clear( )
			local delta = 0
			
			for k, v in SortedPairsByMemberValue( catherine.plugin.GetAll( ), "isSchema" ) do
				local name = "ERROR Title"
				local desc = "ERROR Description"
				local author = "ERROR Author"
				
				if ( !v.isDisabled ) then
					name = catherine.util.StuffLanguage( v.name )
					desc = catherine.util.StuffLanguage( v.desc )
					author = LANG( "Plugin_Value_Author", v.author )
				end
				
				if ( !force and ( name == "ERROR Title" or !catherine.util.CheckStringMatch( name, text ) ) ) then continue end
				
				local panel = vgui.Create( "DPanel" )
				panel:SetSize( pnl.Lists:GetWide( ), 0 )
				panel.Paint = function( pnl2, w, h )
					draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 90 ) )
					
					draw.SimpleText( v.isSchema == "a" and LANG( "System_UI_Plugin_ManagerIsFrameworkPlugin" ) or LANG( "System_UI_Plugin_ManagerIsSchemaPlugin" ), "catherine_normal15", w - 20, 15, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
					
					if ( !catherine.plugin.GetActive( k ) ) then
						catherine.geometry.SlickBackground( 0, 0, w, h, true, Color( 0, 0, 0, 0 ), Color( 255, 0, 0, 100 ) )
						draw.SimpleText( LANG( "System_UI_Plugin_DeactivePluginTitle", k ), "catherine_normal20", 5, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
						draw.SimpleText( LANG( "System_UI_Plugin_DeactivePluginDesc" ), "catherine_normal15", 5, 40, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
						
						return
					end
					
					if ( v.isLoaded ) then
						draw.SimpleText( name, "catherine_normal20", 5, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
						draw.SimpleText( desc, "catherine_normal15", 5, 40, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
						draw.SimpleText( author, "catherine_normal15", w / 2, h / 2, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
					else
						catherine.geometry.SlickBackground( 0, 0, w, h, true, Color( 0, 0, 0, 0 ), Color( 255, 0, 0, 100 ) )
						draw.SimpleText( LANG( "System_UI_Plugin_DeactivePluginTitle", k ), "catherine_normal20", 5, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
						draw.SimpleText( LANG( "System_UI_Plugin_ManagerNeedRestart" ), "catherine_normal15", 5, 40, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
					end
				end
				
				local switch = vgui.Create( "catherine.vgui.button", panel )
				switch:SetSize( 150, 25 )
				switch:SetPos( panel:GetWide( ) - switch:GetWide( ) - 20, panel:GetTall( ) - 35 )
				switch:SetStr( "..." )
				switch:SetStrColor( Color( 50, 50, 50, 255 ) )
				switch:SetStrFont( "catherine_normal15" )
				switch:SetGradientColor( Color( 0, 0, 0, 255 ) )
				switch.Click = function( )
					if ( !changed ) then
						Derma_Message( LANG( "System_UI_Plugin_ManagerNeedRestart" ), LANG( "Basic_UI_Notify" ), LANG( "Basic_UI_OK" ) )
					end
					
					changed = true
					netstream.Start( "catherine.plugin.ToggleActive", {
						k
					} )
				end
				switch.Think = function( pnl2 )
					if ( catherine.plugin.GetActive( k ) ) then
						pnl2:SetStr( LANG( "System_UI_Plugin_ManagerDeactive" ) )
						pnl2:SetStrColor( Color( 255, 0, 0, 255 ) )
						pnl2:SetGradientColor( Color( 255, 0, 0, 255 ) )
					else
						pnl2:SetStr( LANG( "System_UI_Plugin_ManagerActive" ) )
						pnl2:SetStrColor( Color( 0, 0, 0, 255 ) )
						pnl2:SetGradientColor( Color( 0, 0, 0, 255 ) )
					end
				end
				switch.PaintBackground = function( pnl2, w, h )
					surface.SetDrawColor( 0, 0, 0, 100 )
					surface.DrawOutlinedRect( 0, 0, w, h )
				end
				switch.PerformLayout = function( pnl2 )
					pnl2:SetPos( panel:GetWide( ) - pnl2:GetWide( ) - 20, panel:GetTall( ) - 35 )
				end
				
				panel:SizeTo( pnl.Lists:GetWide( ), 60, 0.05, delta, nil, function( )
					pnl.Lists:Rebuild( )
					switch:PerformLayout( )
				end )
				delta = delta + 0.05
				
				pnl.Lists:AddItem( panel )
			end
		end
		
		self.pluginManager.Refresh = function( pnl )
			pnl.Lists:Clear( )
			local delta = 0
			
			for k, v in SortedPairsByMemberValue( catherine.plugin.GetAll( ), "isSchema" ) do
				local name = "ERROR Title"
				local desc = "ERROR Description"
				local author = "ERROR Author"
				
				if ( !v.isDisabled ) then
					name = catherine.util.StuffLanguage( v.name )
					desc = catherine.util.StuffLanguage( v.desc )
					author = LANG( "Plugin_Value_Author", v.author )
				end
				
				local panel = vgui.Create( "DPanel" )
				panel:SetSize( pnl.Lists:GetWide( ), 0 )
				panel.Paint = function( pnl2, w, h )
					draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 90 ) )
					
					draw.SimpleText( v.isSchema == "a" and LANG( "System_UI_Plugin_ManagerIsFrameworkPlugin" ) or LANG( "System_UI_Plugin_ManagerIsSchemaPlugin" ), "catherine_normal15", w - 20, 15, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
					
					if ( !catherine.plugin.GetActive( k ) ) then
						catherine.geometry.SlickBackground( 0, 0, w, h, true, Color( 0, 0, 0, 0 ), Color( 255, 0, 0, 100 ) )
						draw.SimpleText( LANG( "System_UI_Plugin_DeactivePluginTitle", k ), "catherine_normal20", 5, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
						draw.SimpleText( LANG( "System_UI_Plugin_DeactivePluginDesc" ), "catherine_normal15", 5, 40, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
						
						return
					end
					
					if ( v.isLoaded ) then
						draw.SimpleText( name, "catherine_normal20", 5, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
						draw.SimpleText( desc, "catherine_normal15", 5, 40, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
						draw.SimpleText( author, "catherine_normal15", w / 2, h / 2, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
					else
						catherine.geometry.SlickBackground( 0, 0, w, h, true, Color( 0, 0, 0, 0 ), Color( 255, 0, 0, 100 ) )
						draw.SimpleText( LANG( "System_UI_Plugin_DeactivePluginTitle", k ), "catherine_normal20", 5, 15, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
						draw.SimpleText( LANG( "System_UI_Plugin_ManagerNeedRestart" ), "catherine_normal15", 5, 40, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
					end
				end
				
				local switch = vgui.Create( "catherine.vgui.button", panel )
				switch:SetSize( 150, 25 )
				switch:SetPos( panel:GetWide( ) - switch:GetWide( ) - 20, panel:GetTall( ) - 35 )
				switch:SetStr( "..." )
				switch:SetStrColor( Color( 50, 50, 50, 255 ) )
				switch:SetStrFont( "catherine_normal15" )
				switch:SetGradientColor( Color( 0, 0, 0, 255 ) )
				switch.Click = function( )
					if ( !changed ) then
						Derma_Message( LANG( "System_UI_Plugin_ManagerNeedRestart" ), LANG( "Basic_UI_Notify" ), LANG( "Basic_UI_OK" ) )
					end
					
					changed = true
					netstream.Start( "catherine.plugin.ToggleActive", {
						k
					} )
				end
				switch.Think = function( pnl2 )
					if ( catherine.plugin.GetActive( k ) ) then
						pnl2:SetStr( LANG( "System_UI_Plugin_ManagerDeactive" ) )
						pnl2:SetStrColor( Color( 255, 0, 0, 255 ) )
						pnl2:SetGradientColor( Color( 255, 0, 0, 255 ) )
					else
						pnl2:SetStr( LANG( "System_UI_Plugin_ManagerActive" ) )
						pnl2:SetStrColor( Color( 0, 0, 0, 255 ) )
						pnl2:SetGradientColor( Color( 0, 0, 0, 255 ) )
					end
				end
				switch.PaintBackground = function( pnl2, w, h )
					surface.SetDrawColor( 0, 0, 0, 100 )
					surface.DrawOutlinedRect( 0, 0, w, h )
				end
				switch.PerformLayout = function( pnl2 )
					pnl2:SetPos( panel:GetWide( ) - pnl2:GetWide( ) - 20, panel:GetTall( ) - 35 )
				end
				
				panel:SizeTo( pnl.Lists:GetWide( ), 60, 0.05, delta, nil, function( )
					pnl.Lists:Rebuild( )
					switch:PerformLayout( )
				end )
				delta = delta + 0.05
				
				pnl.Lists:AddItem( panel )
			end
		end
		
		self.pluginManager.close = vgui.Create( "catherine.vgui.button", self.pluginManager )
		self.pluginManager.close:SetPos( 10, self.pluginManager.h - 35 )
		self.pluginManager.close:SetSize( self.pluginManager.w * 0.2, 25 )
		self.pluginManager.close:SetStr( LANG( "System_UI_Close" ) )
		self.pluginManager.close:SetStrColor( Color( 50, 50, 50, 255 ) )
		self.pluginManager.close:SetGradientColor( Color( 255, 255, 255, 150 ) )
		self.pluginManager.close.Click = function( )
			self.pluginManager:Close( )
		end
		self.pluginManager.close.PaintBackground = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 200, 200, 255 ) )
		end
		
		self.pluginManager:Refresh( )
	end
	
	self.pluginPanel.open = vgui.Create( "catherine.vgui.button", self.pluginPanel )
	self.pluginPanel.open:SetSize( self.pluginPanel.w - 15, 30 )
	self.pluginPanel.open:SetPos( self.pluginPanel.w / 2 - self.pluginPanel.open:GetWide( ) / 2, self.pluginPanel.h - self.pluginPanel.open:GetTall( ) - 10 )
	self.pluginPanel.open:SetStr( LANG( "System_UI_Plugin_ManagerButton" ) )
	self.pluginPanel.open:SetStrFont( "catherine_normal15" )
	self.pluginPanel.open:SetStrColor( Color( 50, 50, 50, 255 ) )
	self.pluginPanel.open:SetGradientColor( Color( 255, 255, 255, 150 ) )
	self.pluginPanel.open.Click = function( pnl )
		self.pluginPanel:OpenManager( )
	end
	self.pluginPanel.open.PaintBackground = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
	end
	
	self.databasePanel = vgui.Create( "DPanel", self )
	
	self.databasePanel.w, self.databasePanel.h = panelWSize, self.h * 0.45
	self.databasePanel.x, self.databasePanel.y = self.w - self.databasePanel.w - 20, 45
	self.databasePanel.loadingAni = 0
	
	self.databasePanel:SetSize( self.databasePanel.w, self.databasePanel.h )
	self.databasePanel:SetPos( self.databasePanel.x, self.databasePanel.y )
	self.databasePanel:SetAlpha( 0 )
	self.databasePanel:AlphaTo( 255, 0.5, firstMenuDelta )
	
	firstMenuDelta = firstMenuDelta + 0.1
	self.databasePanel.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 150 ) )
		
		surface.SetDrawColor( 0, 0, 0, 90 )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, 30, w, 1, Color( 0, 0, 0, 90 ) )
		
		draw.SimpleText( LANG( "System_UI_DB_Title" ), "catherine_normal20", 10, 15, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
		
		local status = catherine.database.GetStatus( )
		
		draw.SimpleText( LANG( "System_UI_DB_Status" .. status ), "catherine_normal25", w / 2, h * 0.6, Color( 50, 50, 50, 255 ), 1, 1 )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Material( "cat/ui/db_" .. status .. ".png", "smooth" ) )
		surface.DrawTexturedRect( w / 2 - 64 / 2, h * 0.3 - 64 / 2, 64, 64 )
		
		if ( status == 1 ) then
			pnl.loadingAni = math.Approach( pnl.loadingAni, pnl.loadingAni - 10, 10 )
			
			draw.NoTexture( )
			surface.SetDrawColor( 90, 90, 90, 255 )
			catherine.geometry.DrawCircle( 25, h - 25, 10, 3, 0, 360, 100 )
			
			draw.NoTexture( )
			surface.SetDrawColor( 255, 255, 255, 255 )
			catherine.geometry.DrawCircle( 25, h - 25, 10, 3, pnl.loadingAni, 70, 100 )
		end
	end
	
	self.databasePanel.OpenManager = function( )
		netstream.Start( "catherine.database.RequestData" )
		
		self.databaseManager = vgui.Create( "DFrame" )
		
		catherine.vgui.databaseManager = self.databaseManager
		
		self.databaseManager.w, self.databaseManager.h = ScrW( ), ScrH( )
		self.databaseManager.x, self.databaseManager.y = ScrW( ) / 2 - self.databaseManager.w / 2, ScrH( ) / 2 - self.databaseManager.h / 2
		self.databaseManager.backupFilesData = catherine.database.backupFilesData
		self.databaseManager.loadingAni = 0
		
		self.databaseManager:SetSize( self.databaseManager.w, self.databaseManager.h )
		self.databaseManager:SetPos( self.databaseManager.x, self.databaseManager.y )
		self.databaseManager:SetDraggable( false )
		self.databaseManager:ShowCloseButton( false )
		self.databaseManager:SetTitle( "" )
		self.databaseManager:MakePopup( )
		self.databaseManager.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
			
			surface.SetFont( "catherine_normal25" )
			
			local title = LANG( "System_UI_DB_ManagerTitle" )
			local tw, th = surface.GetTextSize( title )
			
			draw.SimpleText( title, "catherine_normal25", 10, 20, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
			
			local status = catherine.database.GetStatus( )
			
			surface.SetFont( "catherine_normal20" )
			
			local statusText = LANG( "System_UI_DB_Status" .. status )
			local tw2, th2 = surface.GetTextSize( statusText )
			
			surface.SetDrawColor( 0, 0, 0, 150 )
			surface.DrawOutlinedRect( 45 + tw, 3, tw2 + 53, 37 )
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material( "cat/ui/db_" .. status .. ".png", "smooth" ) )
			surface.DrawTexturedRect( 50 + tw, 7, 30, 30 )
			
			draw.SimpleText( statusText, "catherine_normal20", 92 + tw, 22, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
			
			if ( pnl.main.status != "none" ) then
				if ( pnl.main:IsVisible( ) ) then
					pnl.main:SetVisible( false )
				end
				
				pnl.loadingAni = math.Approach( pnl.loadingAni, pnl.loadingAni - 10, 10 )
				
				draw.NoTexture( )
				surface.SetDrawColor( 90, 90, 90, 255 )
				catherine.geometry.DrawCircle( w / 2, h / 2, 15, 5, 0, 360, 100 )
				
				draw.NoTexture( )
				surface.SetDrawColor( 255, 255, 255, 255 )
				catherine.geometry.DrawCircle( w / 2, h / 2, 15, 5, pnl.loadingAni, 70, 100 )
			else
				if ( !pnl.main:IsVisible( ) ) then
					pnl.main:SetVisible( true )
				end
			end
		end
		
		self.databaseManager.Close = function( pnl )
			if ( pnl.closing ) then return end
			
			pnl.closing = true
			
			pnl:Remove( )
			pnl = nil
		end
		
		self.databaseManager.main = vgui.Create( "DPanel", self.databaseManager )
		
		self.databaseManager.main.w, self.databaseManager.main.h = self.databaseManager.w - 20, self.databaseManager.h - 55
		self.databaseManager.main.x, self.databaseManager.main.y = 10, 45
		self.databaseManager.main.status = "none"
		self.databaseManager.main.block = false
		self.databaseManager.main.selectedFile = nil
		self.databaseManager.main.restartDelay = false
		
		self.databaseManager.main:SetSize( self.databaseManager.main.w, self.databaseManager.main.h )
		self.databaseManager.main:SetPos( self.databaseManager.main.x, self.databaseManager.main.y )
		self.databaseManager.main.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 150 ) )
			
			surface.SetDrawColor( 0, 0, 0, 90 )
			surface.DrawOutlinedRect( 0, 0, w, h )
			
			if ( pnl.restartDelay ) then
				pnl.Lists:SetVisible( false )
				pnl.backup:SetVisible( false )
				pnl.recover:SetVisible( false )
				self.databaseManager.close:SetVisible( false )
				
				draw.SimpleText( LANG( "System_UI_DB_Manager_RestartServer" ), "catherine_normal20", w / 2, h / 2, Color( 0, 0, 0, 255 ), 1, 1 )
				
				return
			end
			
			draw.SimpleText( LANG( "System_UI_DB_Manager_BackupFilesCount", #self.databaseManager.backupFilesData ), "catherine_normal20", w - 10, 15, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
			// draw.SimpleText( LANG( "System_UI_DB_Manager_AutoBackupStatus", "Disabled" ), "catherine_normal15", w - 10, h - 55, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
		end
		
		self.databaseManager.main.Lists = vgui.Create( "DPanelList", self.databaseManager.main )
		self.databaseManager.main.Lists:SetPos( 10, 40 )
		self.databaseManager.main.Lists:SetSize( self.databaseManager.main.w - 20, self.databaseManager.main.h - 110 )
		self.databaseManager.main.Lists:SetSpacing( 3 )
		self.databaseManager.main.Lists:EnableHorizontal( false )
		self.databaseManager.main.Lists:EnableVerticalScrollbar( true )
		self.databaseManager.main.Lists:SetDrawBackground( false )
		
		self.databaseManager.main.Refresh = function( pnl )
			pnl.Lists:Clear( )
			local i = 1
			
			for k, v in SortedPairsByMemberValue( self.databaseManager.backupFilesData, "timeNumber" ) do
				local fileTitle = LANG( "System_UI_DB_Manager_FileTitle", i )
				
				local panel = vgui.Create( "DButton" )
				panel:SetSize( pnl.Lists:GetWide( ), 30 )
				panel:SetText( "" )
				panel.Paint = function( pnl2, w, h )
					draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 0, 0, 0, 90 ) )
					
					draw.SimpleText( fileTitle, "catherine_normal20", 10, h / 2, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
					draw.SimpleText( v.timeString, "catherine_normal15", w - 10, h / 2, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
					draw.SimpleText( v.requester, "catherine_normal15", w / 2, h / 2, Color( 50, 50, 50, 255 ), 1, 1 )
					
					if ( pnl.selectedFile == v.name ) then
						draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 30 ) )
					end
				end
				panel.DoClick = function( pnl2 )
					if ( pnl.selectedFile == v.name ) then
						pnl.selectedFile = nil
					else
						pnl.selectedFile = v.name
					end
				end
				
				pnl.Lists:AddItem( panel )
				i = i + 1
			end
		end
		
		self.databaseManager.main.backup = vgui.Create( "catherine.vgui.button", self.databaseManager.main )
		self.databaseManager.main.backup:SetSize( self.databaseManager.main.w / 2 - 20, 30 )
		self.databaseManager.main.backup:SetPos( 10, self.databaseManager.main.h - self.databaseManager.main.backup:GetTall( ) - 10 )
		self.databaseManager.main.backup:SetStr( LANG( "System_UI_DB_Manager_BackupButton" ) )
		self.databaseManager.main.backup:SetStrFont( "catherine_normal20" )
		self.databaseManager.main.backup:SetStrColor( Color( 50, 50, 50, 255 ) )
		self.databaseManager.main.backup:SetGradientColor( Color( 255, 255, 255, 150 ) )
		self.databaseManager.main.backup.Click = function( pnl )
			if ( self.databaseManager.main.status != "none" ) then return end
			
			Derma_Query( LANG( "System_Notify_BackupQ" ), "", LANG( "Basic_UI_YES" ), function( )
				if ( !IsValid( self.databaseManager ) ) then return end
				
				self.databaseManager.main.status = "backup"
				
				netstream.Start( "catherine.database.Backup" )
			end, LANG( "Basic_UI_NO" ), function( ) end )
		end
		self.databaseManager.main.backup.PaintBackground = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
		end
		
		self.databaseManager.main.recover = vgui.Create( "catherine.vgui.button", self.databaseManager.main )
		self.databaseManager.main.recover:SetSize( self.databaseManager.main.w / 2 - 10, 30 )
		self.databaseManager.main.recover:SetPos( self.databaseManager.main.w / 2, self.databaseManager.main.h - self.databaseManager.main.recover:GetTall( ) - 10 )
		self.databaseManager.main.recover:SetStr( LANG( "System_UI_DB_Manager_RestoreButton" ) )
		self.databaseManager.main.recover:SetStrFont( "catherine_normal20" )
		self.databaseManager.main.recover:SetStrColor( Color( 50, 50, 50, 255 ) )
		self.databaseManager.main.recover:SetGradientColor( Color( 255, 255, 255, 150 ) )
		self.databaseManager.main.recover.Click = function( pnl )
			if ( self.databaseManager.main.status != "none" ) then return end
			
			if ( self.databaseManager.main.selectedFile ) then
				Derma_Query( LANG( "System_Notify_RestoreQ" ), "", LANG( "Basic_UI_YES" ), function( )
					Derma_Query( LANG( "System_Notify_RestoreQ2" ), "", LANG( "Basic_UI_YES" ), function( )
						if ( !IsValid( self.databaseManager ) ) then return end
						
						self.databaseManager.main.status = "restore"
						
						netstream.Start( "catherine.database.Restore", self.databaseManager.main.selectedFile )
					end, LANG( "Basic_UI_NO" ), function( ) end )
				end, LANG( "Basic_UI_NO" ), function( ) end )
			else
				Derma_Message( LANG( "System_Notify_RestoreError" ), LANG( "Basic_UI_Notify" ), LANG( "Basic_UI_OK" ) )
			end
		end
		self.databaseManager.main.recover.PaintBackground = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 150, 150, 255 ) )
		end
		
		self.databaseManager.main:Refresh( )
		
		self.databaseManager.close = vgui.Create( "catherine.vgui.button", self.databaseManager )
		self.databaseManager.close.block = false
		self.databaseManager.close:SetPos( self.databaseManager.w - ( self.databaseManager.w * 0.1 ) - 10, 10 )
		self.databaseManager.close:SetSize( self.databaseManager.w * 0.1, 25 )
		self.databaseManager.close:SetStr( LANG( "System_UI_Close" ) )
		self.databaseManager.close:SetStrColor( Color( 50, 50, 50, 255 ) )
		self.databaseManager.close:SetGradientColor( Color( 255, 255, 255, 150 ) )
		self.databaseManager.close.Click = function( pnl )
			if ( self.databaseManager.main.status != "none" ) then return end
			
			self.databaseManager:Close( )
		end
		self.databaseManager.close.PaintBackground = function( pnl, w, h )
			if ( self.databaseManager.main.status == "none" ) then
				pnl:SetAlpha( 255 )
			else
				pnl:SetAlpha( 100 )
			end
			
			draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 200, 200, 255 ) )
		end
	end
	
	self.databasePanel.open = vgui.Create( "catherine.vgui.button", self.databasePanel )
	self.databasePanel.open:SetSize( self.databasePanel.w - 15, 30 )
	self.databasePanel.open:SetPos( self.databasePanel.w / 2 - self.databasePanel.open:GetWide( ) / 2, self.databasePanel.h - self.databasePanel.open:GetTall( ) - 10 )
	self.databasePanel.open:SetStr( LANG( "System_UI_DB_ManagerButton" ) )
	self.databasePanel.open:SetStrFont( "catherine_normal15" )
	self.databasePanel.open:SetStrColor( Color( 50, 50, 50, 255 ) )
	self.databasePanel.open:SetGradientColor( Color( 255, 255, 255, 150 ) )
	self.databasePanel.open.Click = function( pnl )
		self.databasePanel:OpenManager( )
	end
	self.databasePanel.open.PaintBackground = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
	end
	
	self.externalXPanel = vgui.Create( "DPanel", self )
	
	self.externalXPanel.w, self.externalXPanel.h = panelWSize, self.h * 0.45 + 5
	self.externalXPanel.x, self.externalXPanel.y = 20, self.h * 0.5 + 20
	self.externalXPanel.loadingAni = 0
	self.externalXPanel.hideAll = false
	self.externalXPanel.restartDelay = false
	
	self.externalXPanel:SetSize( self.externalXPanel.w, self.externalXPanel.h )
	self.externalXPanel:SetPos( self.externalXPanel.x, self.externalXPanel.y )
	self.externalXPanel:SetAlpha( 0 )
	self.externalXPanel:AlphaTo( 255, 0.5, firstMenuDelta )
	
	firstMenuDelta = firstMenuDelta + 0.1
	self.externalXPanel.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 150 ) )
		
		surface.SetDrawColor( 0, 0, 0, 90 )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, 30, w, 1, Color( 0, 0, 0, 90 ) )
		
		draw.SimpleText( LANG( "System_UI_ExternalX_Title" ), "catherine_normal20", 10, 15, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
		
		if ( pnl.hideAll or pnl.restartDelay ) then
			pnl.install:SetVisible( false )
			pnl.check:SetVisible( false )
		else
			pnl.check:SetVisible( true )
		end
		
		if ( pnl.restartDelay ) then
			draw.SimpleText( LANG( "System_UI_ExternalX_RestartServer" ), "catherine_normal20", w / 2, h / 2, Color( 0, 0, 0, 255 ), 1, 1 )
		end
		
		if ( pnl.status ) then
			if ( pnl.hideAll ) then
				draw.SimpleText( LANG( "System_UI_ExternalX_Installing" ), "catherine_normal20", w / 2, h / 2 + 60, Color( 50, 50, 50, 255 ), 1, 1 )
			end
			
			pnl.loadingAni = math.Approach( pnl.loadingAni, pnl.loadingAni - 10, 10 )
			
			draw.NoTexture( )
			surface.SetDrawColor( 90, 90, 90, 255 )
			catherine.geometry.DrawCircle( w / 2, h / 2, 15, 5, 0, 360, 100 )
			
			draw.NoTexture( )
			surface.SetDrawColor( 255, 255, 255, 255 )
			catherine.geometry.DrawCircle( w / 2, h / 2, 15, 5, pnl.loadingAni, 70, 100 )
			
			return
		end
		
		local textH = pnl.install:IsVisible( ) and h - 95 or h - 60
		
		if ( catherine.externalX.foundNewPatch ) then
			pnl.install:SetVisible( true )
		else
			pnl.install:SetVisible( false )
		end
		
		if ( catherine.externalX.foundNewPatch ) then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( foundNewMat )
			surface.DrawTexturedRect( 10, textH - 7, 16, 16 )
			
			draw.SimpleText( LANG( "System_UI_ExternalX_FoundNewPatch", catherine.externalX.newPatchVersion or "INIT" ), "catherine_normal15", 35, textH, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
		else
			if ( pnl.restartDelay ) then return end
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( alreadyNewMat )
			surface.DrawTexturedRect( 10, textH - 7, 16, 16 )
			
			draw.SimpleText( LANG( "System_UI_ExternalX_UsingVer", catherine.externalX.patchVersion ), "catherine_normal15", w / 2, h / 2, Color( 50, 50, 50, 255 ), 1, 1 )
			draw.SimpleText( LANG( "System_UI_ExternalX_AlreadyNewPatch" ), "catherine_normal15", 35, textH, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
		end
	end
	
	self.externalXPanel.check = vgui.Create( "catherine.vgui.button", self.externalXPanel )
	self.externalXPanel.check.progressing = false
	self.externalXPanel.check:SetSize( self.externalXPanel.w - 15, 30 )
	self.externalXPanel.check:SetPos( self.externalXPanel.w / 2 - self.externalXPanel.check:GetWide( ) / 2, self.externalXPanel.h - self.externalXPanel.check:GetTall( ) - 10 )
	self.externalXPanel.check:SetStr( LANG( "System_UI_ExternalX_CheckButton" ) )
	self.externalXPanel.check:SetStrFont( "catherine_normal15" )
	self.externalXPanel.check:SetStrColor( Color( 50, 50, 50, 255 ) )
	self.externalXPanel.check:SetGradientColor( Color( 255, 255, 255, 150 ) )
	self.externalXPanel.check.Click = function( pnl )
		if ( pnl.progressing ) then return end
		
		self.externalXPanel.status = true
		netstream.Start( "catherine.externalX.CheckNewPatch" )
	end
	self.externalXPanel.check.PaintBackground = function( pnl, w, h )
		if ( self.externalXPanel.status and !pnl.progressing ) then
			pnl:SetStr( LANG( "System_UI_ExternalX_CheckingButton" ) )
			pnl.progressing = true
		elseif ( !self.externalXPanel.status and pnl.progressing ) then
			pnl:SetStr( LANG( "System_UI_ExternalX_CheckButton" ) )
			pnl.progressing = false
		end
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
	end
	
	self.externalXPanel.install = vgui.Create( "catherine.vgui.button", self.externalXPanel )
	self.externalXPanel.install.progressing = false
	self.externalXPanel.install:SetVisible( false )
	self.externalXPanel.install:SetSize( self.externalXPanel.w - 15, 30 )
	self.externalXPanel.install:SetPos( self.externalXPanel.w / 2 - self.externalXPanel.install:GetWide( ) / 2, self.externalXPanel.h - ( self.externalXPanel.install:GetTall( ) * 2 ) - 15 )
	self.externalXPanel.install:SetStr( LANG( "System_UI_ExternalX_InstallButton" ) )
	self.externalXPanel.install:SetStrFont( "catherine_normal20" )
	self.externalXPanel.install:SetStrColor( Color( 50, 50, 50, 255 ) )
	self.externalXPanel.install:SetGradientColor( Color( 255, 255, 255, 150 ) )
	self.externalXPanel.install.Click = function( pnl )
		if ( pnl.progressing ) then return end
		
		Derma_Query( LANG( "System_Notify_InstallQ" ), "", LANG( "Basic_UI_YES" ), function( )
			self.externalXPanel.status = true
			self.externalXPanel.hideAll = true
			
			timer.Simple( 1, function( )
				netstream.Start( "catherine.externalX.DownloadPatch" )
			end )
		end, LANG( "Basic_UI_NO" ), function( ) end )
	end
	self.externalXPanel.install.PaintBackground = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
	end
	
	self.configPanel = vgui.Create( "DPanel", self )
	
	self.configPanel.w, self.configPanel.h = panelWSize * 2 + 25, self.h * 0.45 + 5
	self.configPanel.x, self.configPanel.y = self.w / 2 - panelWSize / 2, self.h * 0.5 + 20
	
	self.configPanel:SetSize( self.configPanel.w, self.configPanel.h )
	self.configPanel:SetPos( self.configPanel.x, self.configPanel.y )
	self.configPanel:SetAlpha( 0 )
	self.configPanel:AlphaTo( 255, 0.5, firstMenuDelta )
	
	firstMenuDelta = firstMenuDelta + 0.1
	self.configPanel.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 150 ) )
		
		surface.SetDrawColor( 0, 0, 0, 90 )
		surface.DrawOutlinedRect( 0, 0, w, h )
		
		draw.RoundedBox( 0, 0, 30, w, 1, Color( 0, 0, 0, 90 ) )
		
		draw.SimpleText( LANG( "System_UI_Config_Title" ), "catherine_normal20", 10, 15, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
	end
	
	self.configPanel.Lists = vgui.Create( "DPanelList", self.configPanel )
	self.configPanel.Lists:SetPos( 10, 40 )
	self.configPanel.Lists:SetSize( self.configPanel.w - 20, self.configPanel.h - 50 )
	self.configPanel.Lists:SetSpacing( 5 )
	self.configPanel.Lists:EnableHorizontal( false )
	self.configPanel.Lists:EnableVerticalScrollbar( true )
	self.configPanel.Lists:SetDrawBackground( false )
	
	self.configPanel.RefreshConfigs = function( pnl, configTable )
		pnl.Lists:Clear( )
		
		local resultTable = table.Copy( configTable )
		
		for k, v in pairs( catherine.configs ) do
			if ( !resultTable[ k ] ) then
				resultTable[ k ] = v
			end
		end
		
		for k, v in SortedPairs( resultTable ) do
			if ( type( v ) == "table" ) then continue end
			
			local panel = vgui.Create( "DPanel" )
			panel:SetSize( pnl.Lists:GetWide( ), 30 )
			panel.Paint = function( pnl2, w, h )
				draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 50, 50, 50, 255 ) )
				
				draw.SimpleText( k, "catherine_normal15", 10, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, 1 )
				
				if ( type( v ) == "boolean" ) then
					if ( v == true ) then
						draw.SimpleText( LANG( "System_UI_Config_BooleanTrue" ), "catherine_normal15", w - 10, h / 2, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
					else
						draw.SimpleText( LANG( "System_UI_Config_BooleanFalse" ), "catherine_normal15", w - 10, h / 2, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
					end
					
				else
					draw.SimpleText( v, "catherine_normal15", w - 10, h / 2, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
				end
			end
			
			pnl.Lists:AddItem( panel )
		end
	end
	
	self.configPanel.RequestConfigs = function( pnl )
		netstream.Start( "catherine.requestConfigTable" )
	end
	
	self.configPanel:RequestConfigs( )
	
	self.close = vgui.Create( "catherine.vgui.button", self )
	self.close:SetPos( self.w - ( self.w * 0.1 ) - 20, 10 )
	self.close:SetSize( self.w * 0.1, 25 )
	self.close:SetStr( LANG( "System_UI_Close" ) )
	self.close:SetStrColor( Color( 50, 50, 50, 255 ) )
	self.close:SetGradientColor( Color( 255, 255, 255, 150 ) )
	self.close.Click = function( )
		self:Close( )
	end
	self.close.PaintBackground = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 200, 200, 255 ) )
	end
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 245, 245, 245, 255 ) )
	
	draw.SimpleText( LANG( "System_UI_Title" ), "catherine_normal25", 20, 20, Color( 50, 50, 50, 255 ), TEXT_ALIGN_LEFT, 1 )
	draw.SimpleText( LANG( "System_UI_Welcome", catherine.pl:Name( ) ), "catherine_italic20", w - self.close:GetWide( ) - 40, 23, Color( 50, 50, 50, 255 ), TEXT_ALIGN_RIGHT, 1 )
end

function PANEL:Close( )
	if ( self.closing ) then return end
	
	self.closing = true
	
	self:Remove( )
	self = nil
end

vgui.Register( "catherine.vgui.system", PANEL, "DFrame" )

catherine.menu.Register( function( )
	return LANG( "System_UI_Title" )
end, "system", function( menuPnl, itemPnl )
	vgui.Create( "catherine.vgui.system" )
	menuPnl:Close( )
end, function( pl )
	return pl:IsSuperAdmin( )
end )