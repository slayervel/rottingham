
local mobsterSounds = {
    "placenta/speech/mobster6.wav",
    "placenta/speech/mobster7.wav",
    "placenta/speech/mobster3.wav",
    "placenta/speech/mobster1.wav",
    "placenta/speech/mobster2.wav",
	"placenta/speech/mobster5.wav"
}

local hurtSounds = {
    "placenta/pain/mobster1.wav",
    "placenta/pain/mobster2.wav",
    "placenta/pain/mobster3.wav",
    "placenta/pain/mobster4.wav"
}


local specificModelSounds = {
    ["models/sligwolf/rustyer/player/rustyer.mdl"] = "npc/combine_soldier/vo/on2.wav",
}

function GM:PlayerLoadout( ply )

	ply:Give( "weapon_stunstick" )

end

local function SpawnUpdateClient( ply )

    local modelData = {
        mdl = "models/liver_failure/arrythmian/arrythmian.mdl",
        skin = 20,
        bodygroups = {
            [0] = 0,  -- Head
            [1] = 2,  -- Pants
            [2] = 12, -- Torso
            [3] = 27, -- Headgear
            [4] = 0,  -- Bandanna
            [5] = 0,  -- Mask
            [6] = 0,  -- Hat Mask
            [7] = 0,  -- Fullmask
            [8] = 8,  -- Eyes
            [9] = 2   -- Hands
        }
    }

    ply:SetModel( modelData.mdl )

    ply:SetSkin( modelData.skin )

    for id, val in pairs( modelData.bodygroups ) do
        ply:SetBodygroup( id, val )
    end

    ply:SetTeam( 1 )
    ply:SetNoCollideWithTeammates( true )

	ply:SetWalkSpeed(160)
	ply:SetRunSpeed(250)

    net.Start( "nUpdateRaidStart" );
        net.WriteUInt( GAMEMODE.ForceRaidEnd, 16 );
        net.WriteUInt( GAMEMODE.SquadState, 4 )
    net.Send( ply );

    GAMEMODE:GiveMoney( ply, 0 ) 

end
hook.Add( "PlayerSpawn", "Spawn_Client_Update", SpawnUpdateClient )

hook.Add( "PlayerSay", "EmitModelChatSound", function( ply, text, team )
    local myModel = ply:GetModel()

	if ( string.find( text, "hog" ) ) then
        ply:EmitSound( "placenta/boom.wav", 75, 100, 1 )
	end

    -- Check if this model exists in  table
    if ( specificModelSounds[ myModel ] ) then
        
        ply:EmitSound( specificModelSounds[ myModel ], 75, 100, 1 )

    else
        
        local randomSound = table.Random( mobsterSounds )
        ply:EmitSound( randomSound, 75, 100, 1 )

    end

    return text

end )

function GM:GiveMoney( ply, amt )

	if( !ply.Money ) then
		ply.Money = 0
	end

	ply.Money = ply.Money + amt

	net.Start( "nUpdateMoney" );
		net.WriteUInt( ply.Money, 32 );
	net.Send( ply )

end

function nPurchaseItem()

	local item = net.ReadString();
	local price = net.ReadUInt( 16 );
	local ply = net.ReadEntity()

	if( ply.Money >= price ) then

		GAMEMODE:GiveMoney( ply, -price )

		ply:Give( item )

	end

end
net.Receive( "nPurchaseItem", nPurchaseItem );

function GM:OnNPCKilled( npc, attacker, inf )

	if( attacker and attacker:IsPlayer() and npc.Reward ) then

		self:GiveMoney( attacker, npc.Reward )

	end

	if( table.HasValue( self.ActiveEnemies, npc ) ) then

		table.RemoveByValue( self.ActiveEnemies, npc )

		if( table.IsEmpty( self.ActiveEnemies ) ) then

			attacker:EmitSound( "buttons/button1.wav", 90 )

			timer.Simple( 1, function() self:EndRaid() end )

		end

	end

end

function GM:DoPlayerDeath( ply, attacker, inf )

	if( attacker:IsPlayer() and attacker:IsValid() and attacker != ply ) then
		attacker:EmitSound("kidneydagger/deadkommandant.ogg", 75, math.random(90, 110));
		attacker.Money = attacker.Money * 0
		attacker:ChatPrint( "You killed " .. ply:Nick() .. "! That's terrible!!")

		net.Start( "nUpdateMoney" );
			net.WriteUInt( ply.Money, 32 );
		net.Send( attacker )

		if( self.SquadState == STATE_IDLE ) then

			attacker:EmitSound( "ambient/alarms/klaxon1.wav" );
			attacker:Kill()

		end

	end

	ply.Money = ply.Money * 0.5

	attacker:EmitSound("placenta/death/mobster2.wav", 75, math.random(90, 110));
	net.Start( "nUpdateMoney" );
		net.WriteUInt( ply.Money, 32 );
	net.Send( ply )

	if( table.HasValue(self.ActiveRaiders, ply ) ) then 
		
		table.RemoveByValue( self.ActiveRaiders, ply )

		if( table.IsEmpty( self.ActiveRaiders ) ) then

			attacker:EmitSound( "buttons/button1.wav", 90 )

			timer.Simple( 1, function() self:EndRaid() end )

		end

	end

end

GM.BannedWeaponPickups = {
	--"weapon_crowbar",
	"weapon_pistol",
	"weapon_smg1",
	"weapon_ar2",
	"weapon_shotgun",
	"weapon_crossbow",
	"weapon_357",
	"weapon_rpg",
	"weapon_annabelle",
};
function GM:PlayerCanPickupWeapon( ply, wep )

	if( table.HasValue( self.BannedWeaponPickups, wep:GetClass() ) and self.SquadState == STATE_ACTIVE ) then

		return false;

	end

	return true;

end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if ((attacker:GetClass() == "prop_physics" and attacker:GetModel() ~= "models/props_c17/trappropeller_blade.mdl") or attacker:GetClass() == "prop_ragdoll" or attacker:GetClass() == "prop_combine_ball" ) then return false; end

	return true;
end

function GM:EntityTakeDamage(ent, dmg)
	
	if ( ent:IsPlayer()) then
		local randomSound = table.Random( hurtSounds )
        ent:EmitSound( randomSound, 75, math.random(90, 110));
	end

	if (ent:IsPlayer() and dmg:GetAttacker() and dmg:GetAttacker():IsValid() and dmg:GetAttacker():IsPlayer() ) then

		dmg:ScaleDamage( 0.25 )

		if( self.SquadState == STATE_IDLE ) then

			dmg:GetAttacker():TakeDamage( dmg:GetDamage() )

			dmg:ScaleDamage( 0 )

		end

	end

	if (ent:IsPlayer() and dmg:GetAttacker() and dmg:GetAttacker().CustomDamageScale ) then

		dmg:ScaleDamage( dmg:GetAttacker().CustomDamageScale )

	end

end
