
-- Variables that are used on both client and server

SWEP.PrintName		= "Painkiller" -- 'Nice' Weapon name (Shown on HUD)
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/c_painkiller.mdl"
SWEP.UseHands = true
SWEP.WorldModel		= "models/weapons/w_painkiller.mdl"
SWEP.HoldType		= "pistol"

SWEP.Spawnable		= false
SWEP.AdminOnly		= false

SWEP.Primary.ClipSize		= 6			-- Size of a clip
SWEP.Primary.DefaultClip	= 6		-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Damage			= 20
SWEP.Primary.Sound			= "tekka/weapons/weapon_pistolcrack.wav"
SWEP.Primary.Delay			= 0.1
SWEP.Primary.NumBullets		= 1
SWEP.Primary.Accuracy		= 0.3
SWEP.Primary.Aimcone		= 0.01


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
	return false
end

function SWEP:Think()

    if ( self.Owner:KeyDown( IN_ATTACK2 ) ) then
        if ( !self:GetNWBool( "Ironsights" ) ) then
            self:SetNWBool( "Ironsights", true )
        end
    else
        if ( self:GetNWBool( "Ironsights" ) ) then
            self:SetNWBool( "Ironsights", false )
        end
    end
    
    if ( self.BaseClass.Think ) then self.BaseClass.Think( self ) end
end

function SWEP:TranslateFOV( current_fov )
    
    local targetFOV = current_fov
    if ( self:GetNWBool( "Ironsights" ) ) then
        targetFOV = 60
    end

    if ( !self.CurrentFOV ) then 
        self.CurrentFOV = current_fov 
    end

    self.CurrentFOV = Lerp( FrameTime() * 5, self.CurrentFOV, targetFOV )

    return self.CurrentFOV
end