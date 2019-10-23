if SERVER then
	include("server/init.lua")
end

CATEGORY_NAME = "Warning System"


function ulx.warnmenu(calling_ply)
	if SERVER then
		calling_ply:SendLua("net.Start('requestfwarn')")
		calling_ply:SendLua("net.SendToServer()")		
	end
end
local warnmenu = ulx.command(CATEGORY_NAME, "ulx warnmenu", ulx.warnmenu, "!warnmenu")
warnmenu:defaultAccess(ULib.ACCESS_ADMIN)
warnmenu:help("Opens the warning menu.")

function ulx.warn(calling_ply, target_ply, reason)
	if SERVER then
		issueWarnUlx(calling_ply, target_ply:SteamID(), reason, true)
		ulx.fancyLogAdmin(calling_ply, "#A warned #T for #s", target_ply, reason)
	end
end
local warn = ulx.command(CATEGORY_NAME, "ulx warn", ulx.warn, "!warn")
warn:addParam{type=ULib.cmds.PlayerArg, target="!^", ULib.cmds.ignoreCanTarget}
warn:addParam{type=ULib.cmds.StringArg, hint="Reason for warning."}
warn:defaultAccess(ULib.ACCESS_ADMIN)
warn:help("Warns the target.")