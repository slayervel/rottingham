local HP_CONFIG = {
    width = 800,
    height = 20,
    yPos = 10,
    colorHealth = Color(233, 22, 22, 255), 
    colorBack   = Color(30, 30, 30, 150),  
    colorOutline = Color(0, 0, 0, 255)
}

local ARMOR_CONFIG = {
    width = 800,
    height = 20,
    yPos = 40,
    colorHealth = Color(22, 22, 233, 255), 
    colorBack   = Color(30, 30, 30, 150),  
    colorOutline = Color(0, 0, 0, 255)
}

local function DrawArmorBar()
    local ply = LocalPlayer()
    
    if not IsValid(ply) or not ply:Alive() then return end

    local arm = ply:Armor()
    local maxArm = ply:GetMaxArmor()
    
    if maxArm <= 0 then maxArm = 100 end
    if arm <= 14 then return end

    local hpPercent = math.Clamp(arm / maxArm, 0, 1)

    local xPos = (ScrW() / 2) - (ARMOR_CONFIG.width / 2)
    local yPos = ARMOR_CONFIG.yPos

    surface.SetDrawColor(ARMOR_CONFIG.colorBack)
    surface.DrawRect(xPos, yPos, HP_CONFIG.width, HP_CONFIG.height)

    surface.SetDrawColor(ARMOR_CONFIG.colorHealth)
    surface.DrawRect(xPos, yPos, HP_CONFIG.width * hpPercent, HP_CONFIG.height)

    surface.SetDrawColor(ARMOR_CONFIG.colorOutline)
    surface.DrawOutlinedRect(xPos, yPos, HP_CONFIG.width, HP_CONFIG.height)

    local text = string.format("carapace")
    draw.SimpleText(text, "TargetIDSmall", ScrW() / 2, yPos + (HP_CONFIG.height / 2), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function DrawHealthBar()
    local ply = LocalPlayer()
    
    if not IsValid(ply) or not ply:Alive() then return end

    local hp = ply:Health()
    local maxHp = ply:GetMaxHealth()

    if hp >= 90 then return end
    if maxHp <= 0 then maxHp = 100 end 
    
    local hpPercent = math.Clamp(hp / maxHp, 0, 1)

    local xPos = (ScrW() / 2) - (HP_CONFIG.width / 2)
    local yPos = HP_CONFIG.yPos

    surface.SetDrawColor(HP_CONFIG.colorBack)
    surface.DrawRect(xPos, yPos, HP_CONFIG.width, HP_CONFIG.height)

    surface.SetDrawColor(HP_CONFIG.colorHealth)
    surface.DrawRect(xPos, yPos, HP_CONFIG.width * hpPercent, HP_CONFIG.height)

    surface.SetDrawColor(HP_CONFIG.colorOutline)
    surface.DrawOutlinedRect(xPos, yPos, HP_CONFIG.width, HP_CONFIG.height)

    local text = string.format("blood")
    draw.SimpleText(text, "TargetIDSmall", ScrW() / 2, yPos + (HP_CONFIG.height / 2), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function GM:HUDPaint()

	local get = LocalPlayer():GetEyeTraceNoCursor();

	if( get and get.Entity and get.Entity:IsValid() ) then

		playerY = (ScrH() / 2) + 25

		if( get.Entity:IsPlayer() and get.Entity:Alive() ) then

			draw.SimpleTextOutlined( get.Entity:Nick(), "ChatFont", ScrW() / 2, playerY, Color( 200, 200, 0, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) );
			playerY = playerY + 15

			draw.SimpleTextOutlined( get.Entity:Health() .. "% Health", "ChatFont", ScrW() / 2, playerY, Color( 200, 50, 50, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) );
			playerY = playerY + 15

			if( get.Entity:Armor() and get.Entity:Armor() > 0 ) then

				draw.SimpleTextOutlined( get.Entity:Armor() .. "% Armor", "ChatFont", ScrW() / 2, playerY, Color( 50, 50, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) );
				playerY = playerY + 15

			end

		end

		if( get.Entity.Interesting ) then

			get.Entity:HUDFunc( playerY )

		end

	end

	local ply = LocalPlayer();
	local money = 0

	if( ply.Money ) then

		money = ply.Money

	end

	local y = 200

	draw.SimpleTextOutlined( "$£€: " .. money, "ChatFont", ScrW() - 25, ScrH() - y, Color( 200, 200, 0, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) );
	y = y + 20

	local sState = "Idle"

	if( self.SquadState and self.SquadState == STATE_ACTIVE and self.ForceRaidEnd ) then

		sState = "Active"
		draw.SimpleTextOutlined( "Raid Time: " .. math.Round( self.ForceRaidEnd - CurTime() ), "ChatFont", ScrW() - 25, ScrH() - y, Color( 200, 200, 0, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) );
		y = y + 20

		draw.SimpleTextOutlined( "Raid Threat: " .. math.Round( self.Threat, 2 ), "ChatFont", ScrW() - 25, ScrH() - y, Color( 200, 200, 0, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) );
		y = y + 20

	end

	draw.SimpleTextOutlined( "Squad State: " .. sState, "ChatFont", ScrW() - 25, ScrH() - y, Color( 200, 200, 0, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) );
	y = y + 20
	
	-- HEALTHBAR CODE
	DrawHealthBar()
	DrawArmorBar()
end

function GM:HUDShouldDraw(name)
    local elementsToHide = {
        ["CHudHealth"] = true,
        ["CHudBattery"] = true,
    }

    if elementsToHide[name] then
        return false
    end

    return true 
end

hook.Add( "HUDShouldDraw", "HideDefaultCrosshair", function( name )
    if ( name == "CHudCrosshair" ) then
        return false
    end
end )

local currentRadius = 12
hook.Add( "HUDPaint", "DrawRotatingDots", function()

	local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()

	local radius = 12

	if ( IsValid(wep) and wep.GetNWBool and wep:GetNWBool("Ironsights") ) then
        radius = 7 
    end

	currentRadius = Lerp( FrameTime() * 10, currentRadius, radius )

    local centerX = ScrW() / 2
    local centerY = ScrH() / 2
    local speed = 0.9
    local dotSize = 3
    local dotCount = 3

    for i = 1, dotCount do

        local angle = RealTime() * speed + math.rad( i * (360 / dotCount) )

        local x = centerX + math.cos( angle ) * currentRadius
        local y = centerY + math.sin( angle ) * currentRadius

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawRect( x - (dotSize / 2), y - (dotSize / 2), dotSize, dotSize )

    end

end )
