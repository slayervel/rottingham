include( "sh_setup.lua" );
include( "cl_hud.lua" );

local defaultSettings = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = -0.04,
	[ "$pp_colour_contrast" ] = 1.01,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

local hurtSettings = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = -0.02,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 0.4, 
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

hook.Add( "RenderScreenspaceEffects", "RottishFX", function()

    DrawColorModify( defaultSettings )
    DrawBloom( 0.35, 0.84, 9, 9, 1, 1, 1, 1, 1 )
    DrawSharpen( 1.21, 1.21 )
end )

hook.Add( "RenderScreenspaceEffects", "HurtFX", function()

    local ply = LocalPlayer()

    if ( ply:Health() < 20 and ply:Alive() ) then
        

        DrawColorModify( hurtSettings )
        

        DrawMotionBlur( 0.4, 0.8, 0.01 )
        
        DrawSharpen( 1.2, 1.2 ) 

    end
end )
