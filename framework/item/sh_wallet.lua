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

local ITEM = catherine.item.New( "wallet" )
ITEM.name = "^Item_Name_Wallet"
ITEM.desc = "^Item_Desc_Wallet"
ITEM.category = "^Item_Category_Wallet"
ITEM.model = catherine.configs.cashModel
ITEM.cost = 0
ITEM.weight = 0.5
ITEM.itemData = {
	amount = 0
}
ITEM.IsPersistent = true
ITEM.func = { }
ITEM.func.take = {
	text = "^Item_FuncStr01_Wallet",
	icon = "icon16/money_add.png",
	canShowIsWorld = true,
	func = function( pl, itemTable, ent )
		if ( !IsValid( ent ) ) then
			return
		end
		
		local itemData = ent:GetItemData( )
		
		catherine.cash.Give( pl, itemData.amount )
		catherine.util.NotifyLang( pl, "Cash_Notify_Get", itemData.amount )
		
		ent:Remove( )
	end,
	canLook = function( )
		return true
	end
}
ITEM.func.drop = {
	text = "^Item_FuncStr02_Wallet",
	icon = "icon16/money_delete.png",
	canShowIsMenu = true,
	func = function( pl, itemTable, isMenu )
		if ( pl:IsTied( ) ) then
			catherine.util.NotifyLang( pl, "Item_Notify03_ZT" )
			return
		end
				
		catherine.util.StringReceiver( pl, "Cash_UniqueDropMoney", "^Item_DropQ_Wallet", catherine.cash.Get( pl ), function( _, val )
			val = tonumber( val )
			
			if ( !val ) then return end
			
			if ( !catherine.cash.Has( pl, val ) ) then
				catherine.util.NotifyLang( pl, "Cash_Notify_HasNot" )
				return
			end
			
			catherine.cash.Take( pl, val )
			catherine.item.Spawn( itemTable.uniqueID, catherine.util.GetItemDropPos( pl ), nil, { amount = val } )
		end )
	end,
	canLook = function( pl )
		return catherine.cash.Get( pl ) > 0
	end
}

if ( SERVER ) then
	catherine.item.RegisterHook( "PlayerSpawnedInCharacter", ITEM, function( pl )
		if ( catherine.inventory.HasItem( pl, "wallet" ) ) then return end
		
		catherine.item.Give( pl, "wallet" )
	end )
else
	function ITEM:GetDesc( pl, itemTable, itemData, isInv )
		if ( itemData.amount ) then
			return isInv and LANG( "Cash_UI_HasStr", catherine.cash.Get( pl ) ) or LANG( "Item_Desc_World_Wallet", catherine.cash.GetName( itemData.amount ) )
		end
	end
end

catherine.item.Register( ITEM )