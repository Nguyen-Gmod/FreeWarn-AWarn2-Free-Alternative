include("fw_config.lua")
util.AddNetworkString("requestfwarn")
util.AddNetworkString("sendfwarn")
util.AddNetworkString("sendwarn")
util.AddNetworkString("removewarn")

function checkData()
	if fwconfig.sql.enabled == true then

	else
		if file.Exists("fwarndata.txt", "DATA") == false then
			data = {}
			data.players = {}
			data.logs = {}
			data.bans = {}
			file.Write("fwarndata.txt", util.TableToJSON(data, true))
			print("print")
		end
	end
end

function issueWarn()
	warner = net.ReadEntity()
	warnee = net.ReadString()
	reason = net.ReadString()
	online = net.ReadBool()
	databaseID = getWarneeInfo(warnee)
	warnee = getPlayer(warnee)
	database = util.JSONToTable(file.Read("fwarndata.txt", "DATA"))
	if table.HasValue(fwconfig.allowedgroups, warner:GetUserGroup()) or warner:IsAdmin() then
		if online then
			table.insert(database.logs, "["..os.date("%H:%M:%S - %d/%m/%Y",os.time()).."] - "..warner:Nick().." warned "..warnee:Nick().." for reason '"..reason.."'")
		else
			table.insert(database.logs, "["..os.date("%H:%M:%S - %d/%m/%Y",os.time()).."] - "..warner:Nick().." warned "..database.players[databaseID][2].." for reason '"..reason.."'")	
		end
		table.insert(database.players[databaseID].warns, "'"..reason.."' | Issued By: "..warner:Nick().." ("..warner:SteamID()..")")
		file.Write("fwarndata.txt", util.TableToJSON(database, true))
		issuePunishment(table.Count(database.players[databaseID].warns), database.players[databaseID][1])
	end
end

function issueWarnUlx(warner, warnee, reason)
	databaseID = getWarneeInfo(warnee)
	warnee = getPlayer(warnee)
	database = util.JSONToTable(file.Read("fwarndata.txt", "DATA"))
		table.insert(database.logs, "["..os.date("%H:%M:%S - %d/%m/%Y",os.time()).."] - Console warned "..warnee:Nick().." for reason ".."'"..reason.."'")
		table.insert(database.players[databaseID].warns, "'"..reason.."' | Issued By: Console")
		file.Write("fwarndata.txt", util.TableToJSON(database, true))
		issuePunishment(table.Count(database.players[databaseID].warns), database.players[databaseID][1])
end

function removeWarn()
	warner = net.ReadEntity()
	warnee = net.ReadString()
	reason = net.ReadString()
	databaseID = getWarneeInfo(warnee)
	warnee = getPlayer(warnee)
	if table.HasValue(fwconfig.allowedgroups, warner:GetUserGroup()) or warner:IsAdmin() then
		database = util.JSONToTable(file.Read("fwarndata.txt", "DATA"))
		for k,v in pairs(database.players[databaseID].warns) do
			if v == reason then
				table.remove(database.players[databaseID].warns, k)
			end
		end
		file.Write("fwarndata.txt", util.TableToJSON(database, true))
	end
end

function getWarneeInfo(warnee)
	database = util.JSONToTable(file.Read("fwarndata.txt", "DATA"))
	found = false
	id = 0
	for k,v in pairs(database.players) do
		if v[1] == warnee then
			id = k
			found = true
		end
	end
	if found == false then
		pent = getPlayer(warnee)
		playerCard = {warnee, pent:Nick()}
		playerCard.warns = {}
		table.insert(database.players, playerCard)
		file.Write("fwarndata.txt", util.TableToJSON(database, true))
		print("added player...")
		database = util.JSONToTable(file.Read("fwarndata.txt", "DATA"))
		for k,v in pairs(database.players) do
			if v[1] == warnee then
				return k
			end
		end
	else 
		return id
	end
end

function issuePunishment(numWarns, id)
	p = getPlayer(id)
	if numWarns >= fwconfig.allowedwarns then
		p:Kick("You have been automatically kicked for having too many warnings!")
	end
end

function getPlayer(id)
	for k,v in pairs(player.GetAll()) do
		if v:SteamID() == id then
			return v
		end
	end
end

net.Receive("sendwarn", issueWarn)
net.Receive("removewarn", removeWarn)

net.Receive("requestfwarn", function(len, ply)
	if !table.HasValue(fwconfig.allowedgroups, ply:GetUserGroup()) then return end
	database = file.Read("fwarndata.txt", "DATA")
	net.Start("sendfwarn")
	net.WriteString(database) 
	net.Send(ply)
end)

hook.Add("Initialize", "fwarn_check_data", checkData)