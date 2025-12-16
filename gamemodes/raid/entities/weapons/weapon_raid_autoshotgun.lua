
-- Variables that are used on both client and server

SWEP.PrintName		= "Lubov" -- 'Nice' Weapon name (Shown on HUD)
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/tnb/weapons/c_saiga12.mdl"
SWEP.UseHands 		= true
SWEP.WorldModel		= "models/tnb/weapons/w_saiga12.mdl"
SWEP.HoldType		= "shotgun"

SWEP.Spawnable		= false
SWEP.AdminOnly		= false

SWEP.Primary.ClipSize		= 12			-- Size of a clip
SWEP.Primary.DefaultClip	= 12		-- Default number of bullets in a clip
SWEP.Primary.Automatic		= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Buckshot"
SWEP.Primary.Damage			= 5
SWEP.Primary.Sound			= "tekka/weapons/weapon_shotgunblast.wav"
SWEP.Primary.Delay			= 0.3
SWEP.Primary.NumBullets		= 6
SWEP.Primary.Accuracy		= 0.15
SWEP.Primary.Aimcone		= 0.06

SWEP.Secondary.ClipSize		= 3
SWEP.Secondary.DefaultClip	= 3
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "357"


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

function SWEP:SecondaryAttack()

	if ( !self:CanSecondaryAttack() ) then return end

	self:EmitSound("Weapon_Shotgun.Single")

	self:ShootBullet( 150, 1, 0.025, self.Secondary.Ammo )

	-- Remove 1 bullet from our clip
	self:TakeSecondaryAmmo( 1 )

	-- Punch the player's view
	if ( !self.Owner:IsNPC() ) then self.Owner:ViewPunch( Angle( -10, 0, 0 ) ) end

end

function SWEP:CanSecondaryAttack()

	if ( self:Clip2() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		return false

	end

	return true

end