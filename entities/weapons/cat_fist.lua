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

AddCSLuaFile( )

SWEP.PrintName = "Fists"
SWEP.Author = "1F24DCA, L7D, Chessnut"
SWEP.HoldType = "normal"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.DrawHUD = false
SWEP.ViewModel = Model( "models/weapons/c_arms_cstrike.mdl" )
SWEP.WorldModel	= ""
SWEP.ViewModelFOV = 50

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 5
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Delay = 0.5

SWEP.HitDistance = 76
SWEP.LowerAngles = Angle( 0, 5, -15 )
SWEP.UseHands = false

function SWEP:Precache( )
	util.PrecacheSound( "npc/vort/claw_swing1.wav" )
	util.PrecacheSound( "npc/vort/claw_swing2.wav" )
	util.PrecacheSound( "physics/wood/wood_crate_impact_hard2.wav" )
end

function SWEP:PreDrawViewModel( viewMdl, wep, pl )
	local fists = player_manager.TranslatePlayerHands( player_manager.TranslateToPlayerModelName( pl:GetModel( ) ) )
	
	if ( fists and fists.model ) then
		viewMdl:SetModel( fists.model )
		viewMdl:SetSkin( fists.skin )
		viewMdl:SetBodyGroups( fists.body )
	end
end

function SWEP:PrimaryAttack( )
	if ( !IsFirstTimePredicted( ) or CLIENT ) then return end
	local pl = self.Owner
	
	if ( hook.Run( "PlayerCanThrowPunch", pl ) == false ) then
		return
	end
	
	local stamina = catherine.character.GetCharVar( pl, "stamina", 100 )
	
	if ( stamina < 10 ) then
		return
	end
	
	local tr = { }
	tr.start = pl:GetShootPos( )
	tr.endpos = tr.start + pl:GetAimVector( ) * self.HitDistance
	tr.filter = pl
		
	local ent = util.TraceLine( tr ).Entity
	
	catherine.character.SetCharVar( pl, "stamina", stamina - 5 )
	
	pl:SetAnimation( PLAYER_ATTACK1 )
	
	local viewMdl = pl:GetViewModel( )
	viewMdl:SendViewModelMatchingSequence( viewMdl:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
	
	timer.Simple( 0.1, function( )
		viewMdl:SendViewModelMatchingSequence( viewMdl:LookupSequence( table.Random( { "fists_left", "fists_right" } ) ) )
	end )

	pl:EmitSound( "npc/vort/claw_swing" .. math.random( 1, 2 ) .. ".wav" )
	pl:LagCompensation( true )

	if ( IsValid( ent ) ) then
		pl:EmitSound( "Flesh.ImpactHard" )

		if ( ent:IsPlayer( ) ) then
			local dmgInfo = DamageInfo( )
			dmgInfo:SetAttacker( pl )
			dmgInfo:SetInflictor( self )
			dmgInfo:SetDamage( math.random( 8, 12 ) )
			ent:TakeDamageInfo( dmgInfo )
		elseif ( ent:GetClass( ) == "prop_ragdoll" ) then
			local target = ent:GetNetVar( "player" )
			
			if ( IsValid( target ) and target:IsPlayer( ) ) then
				local dmgInfo = DamageInfo( )
				dmgInfo:SetAttacker( pl )
				dmgInfo:SetInflictor( self )
				dmgInfo:SetDamage( math.random( 8, 12 ) )
				target:TakeDamageInfo( dmgInfo )
			end
		end
		
		hook.Run( "PlayerThrowPunch", pl, tr.Hit )
	end
	
	pl:LagCompensation( false )
	self:SetNextPrimaryFire( CurTime( ) + self.Primary.Delay )
end

function SWEP:CanMoveable( ent )
	local physObject = ent:GetPhysicsObject()

	if ( !IsValid( physObject ) ) then
		return false
	end

	if ( physObject:GetMass( ) > 90 or !physObject:IsMoveable( ) ) then
		return false
	end

	return true
end

function SWEP:DoPickup( ent )
	if ( ent:IsPlayerHolding( ) ) then
		return
	end

	timer.Simple( FrameTime( ) * 10, function( )
		if ( !IsValid( ent ) or ent:IsPlayerHolding( ) ) then
			return
		end
		
		local pl = self.Owner

		pl:PickupObject( ent )
		pl:EmitSound( "physics/body/body_medium_impact_soft" .. math.random( 1, 3 ) .. ".wav", 75 )
	end )

	self:SetNextSecondaryFire( CurTime( ) + 1 )
end

function SWEP:SecondaryAttack( )
	if ( !IsFirstTimePredicted( ) ) then return end
	local pl = self.Owner
	local ent = util.TraceLine( {
		start = pl:GetShootPos( ),
		endpos = pl:GetShootPos( ) + pl:GetAimVector( ) * self.HitDistance,
		filter = pl
	} ).Entity
	
	if ( IsValid( ent ) ) then
		if ( catherine.entity.IsDoor( ent ) ) then
			self:EmitSound( "physics/wood/wood_crate_impact_hard2.wav", math.random( 50, 100 ) )
		elseif ( !ent:IsPlayer( ) and !ent:IsNPC( ) and self:CanMoveable( ent ) ) then
			local physObject = ent:GetPhysicsObject( )
			physObject:Wake( )

			self:DoPickup( ent )
		end
	end
	
	self:SetNextSecondaryFire( CurTime( ) + self.Secondary.Delay )
end

function SWEP:Deploy( )
	if ( !IsValid( self.Owner ) ) then return end

	local viewMdl = self.Owner:GetViewModel( )
	viewMdl:SendViewModelMatchingSequence( viewMdl:LookupSequence( "fists_draw" ) )
	
	timer.Simple( viewMdl:SequenceDuration( ), function( ) 
		viewMdl:SendViewModelMatchingSequence( viewMdl:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
	end )
	
	return true
end

function SWEP:Initialize( )
	self:SetHoldType( self.HoldType )
end