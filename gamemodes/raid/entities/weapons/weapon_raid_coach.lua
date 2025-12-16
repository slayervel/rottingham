
-- Variables that are used on both client and server

SWEP.PrintName		= "Coach" -- 'Nice' Weapon name (Shown on HUD)
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/c_coach.mdl"
SWEP.UseHands 		= true
SWEP.WorldModel		= "models/weapons/w_coach.mdl"
SWEP.HoldType		= "shotgun"

SWEP.Spawnable		= false
SWEP.AdminOnly		= false

SWEP.Primary.ClipSize		= 2			-- Size of a clip
SWEP.Primary.DefaultClip	= 2		-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Buckshot"
SWEP.Primary.Damage			= 8
SWEP.Primary.Sound			= "tekka/weapons/weapon_shotgun2.wav"
SWEP.Primary.Delay			= 0.3
SWEP.Primary.NumBullets		= 10
SWEP.Primary.Accuracy		= 0.15
SWEP.Primary.Aimcone		= 0.06

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

function SWEP:SecondaryAttack()

	if ( !self:CanSecondaryAttack() ) then return end

	self:EmitSound("Weapon_Shotgun.Single")

	if(self:Clip1() <= 1) then
		self:ShootBullet( self.Primary.Damage, self.Primary.NumBullets, self.Primary.Aimcone, self.Primary.Ammo )
		self:TakePrimaryAmmo( 1 )
	end
	if(self:Clip1() <= 2) then
		self:ShootBullet( self.Primary.Damage, self.Primary.NumBullets*2, self.Primary.Aimcone, self.Primary.Ammo )
		self:TakePrimaryAmmo( 2 )
	end

	-- Punch the player's view
	if ( !self.Owner:IsNPC() ) then self.Owner:ViewPunch( Angle( -10, 0, 0 ) ) end

end

function SWEP:CanSecondaryAttack()

	if ( self:Clip1() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		return false

	end

	return true

end