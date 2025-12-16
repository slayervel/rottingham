concommand.Add( "givemoney", function( ply, cmd, args, str )

	GAMEMODE:GiveMoney( ply, args[1] )
	
end )

concommand.Add( "giveswep", function( ply, cmd, args, str )

		ply:Give( args[1] )

	
end )
