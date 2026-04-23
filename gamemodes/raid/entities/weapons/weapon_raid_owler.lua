
-- Variables that are used on both client and server

SWEP.PrintName		= "Owler" -- 'Nice' Weapon name (Shown on HUD)
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "A cheap piece of shit submachine gun."


SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/tnb/weapons/c_skorpion.mdl"
SWEP.UseHands = true
SWEP.WorldModel		= "models/tnb/weapons/w_skorpion.mdl"
SWEP.HoldType		= "ar2"
SWEP.Slot   		= 2

SWEP.Spawnable		= false
SWEP.AdminOnly		= false

SWEP.Primary.ClipSize		= 20			-- Size of a clip
SWEP.Primary.DefaultClip	= 20		-- Default number of bullets in a clip
SWEP.Primary.Automatic		= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Damage			= 15
SWEP.Primary.Sound			= "tekka/weapons/weapon_mp40.wav"
SWEP.Primary.Delay			= 0.1
SWEP.Primary.NumBullets		= 1
SWEP.Primary.Accuracy		= 0.3
SWEP.Primary.Aimcone		= 0.02


SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"


--[[---------------------------------------------------------
	Name: SWEP:Initialize()
	Desc: Called when the weapon is first loaded
-----------------------------------------------------------]]
function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:PrimaryAttack()

	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end

	-- Play shoot sound
	self:EmitSound( self.Primary.Sound )

	-- Shoot 9 bullets, 150 damage, 0.75 aimcone
	self:ShootBullet( self.Primary.Damage, self.Primary.NumBullets, self.Primary.Aimcone, self.Primary.Ammo )

	-- Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	-- Punch the player's view
	if ( !self.Owner:IsNPC() ) then self.Owner:ViewPunch( Angle( -1, 0, 0 ) ) end

end

function SWEP:CanSecondaryAttack()

	return false
end

function SWEP:SecondaryAttack()
 
end