include("fw_config.lua")

function openWarnMenu()
	if table.HasValue(fwconfig.allowedgroups, LocalPlayer():GetUserGroup()) then
		database = util.JSONToTable(net.ReadString())
		local Frame = vgui.Create("DFrame")
		Frame:SetPos(5, 5)
		Frame:SetSize(ScrW()/2, ScrH()/2)
		Frame:Center()
		Frame:SetTitle("FreeWarn Version 1.0 | Created by Nguyen-Gmod | github.com/Nguyen-Gmod")
		Frame:SetVisible(true)
		Frame:SetDraggable(false)
		Frame:ShowCloseButton(true)
		Frame:MakePopup()
		Frame.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
		end
		
		//Left Panel
		local FrameTabsWarnings = vgui.Create("DPropertySheet", Frame)
		FrameTabsWarnings:Dock(FILL)
		FrameTabsWarnings.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		end
		local FrameTabsPanelList = vgui.Create("DPanel", FrameTabsWarnings)
		FrameTabsWarnings:AddSheet("Warnings", FrameTabsPanelList, "icon16/exclamation.png")
		local FrameTabsPanelListLogs = vgui.Create("DPanel", FrameTabsWarnings)
		FrameTabsWarnings:AddSheet("Logs", FrameTabsPanelListLogs, "icon16/book.png")
		local FrameWarningEntrys = vgui.Create("DListView", FrameTabsPanelList)
		FrameWarningEntrys:Dock(FILL)
		FrameWarningEntrys:AddColumn("Warn ID"):SetFixedWidth(45)
		FrameWarningEntrys:AddColumn("Reason")
		local FrameWarningLogs = vgui.Create("DListView", FrameTabsPanelListLogs)
		FrameWarningLogs:Dock(FILL)
		FrameWarningLogs:AddColumn("Log")
		for k,v in pairs(database.logs) do
			FrameWarningLogs:AddLine(v)
		end
		local FrameTabsWarningText = vgui.Create("DTextEntry", Frame)
		FrameTabsWarningText:Dock(BOTTOM)
		FrameTabsWarningText:SetText("Enter warning reason...")
		//Right Panel
		local FrameTabsPlayers = vgui.Create("DPropertySheet", Frame)
		FrameTabsPlayers:Dock(RIGHT)
		FrameTabsPlayers:SetSize(200, 0)
		FrameTabsPlayers.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		end
		local FrameTabsPanelListPlayers = vgui.Create("DPanel", FrameTabsPlayers)

		
		
		local FrameOnlinePlayerList = vgui.Create("DListView", FrameTabsPanelListPlayers)
		FrameOnlinePlayerList:Dock(FILL)
		FrameOnlinePlayerList:SetMultiSelect(false)
		FrameOnlinePlayerList:AddColumn("Name")
		FrameOnlinePlayerList:AddColumn("SteamID")
		for k,v in pairs(player.GetAll()) do
			FrameOnlinePlayerList:AddLine(v:Name(), v:SteamID())
		end
		FrameOnlinePlayerList.OnRowSelected = function(lst, index, pnl)
			FrameWarningEntrys:Clear()
			for k,v in pairs(database.players) do
				if pnl:GetColumnText(2) == database.players[k][1] then
					for j,l in pairs(database.players[k].warns) do
						FrameWarningEntrys:AddLine(j,l)
					end
				end
			end
		end
		FrameTabsPlayers:AddSheet("Online", FrameTabsPanelListPlayers, "icon16/user.png")
		
		
		local FrameTabsPanelListOfflinePlayers = vgui.Create("DPanel", FrameTabsPlayers)
		local FrameOfflinePlayerList = vgui.Create("DListView", FrameTabsPanelListOfflinePlayers)
		FrameOfflinePlayerList:Dock(FILL)
		FrameOfflinePlayerList:SetMultiSelect(false)
		FrameOfflinePlayerList:AddColumn("Name")
		FrameOfflinePlayerList:AddColumn("SteamID")
		for k,v in pairs(database.players) do
			real = checkValidPlayer(database.players[k][1])
			if real == false then
				FrameOfflinePlayerList:AddLine(database.players[k][2], database.players[k][1])
			end
		end
		FrameOfflinePlayerList.OnRowSelected = function(lst, index, pnl)
			FrameWarningEntrys:Clear()
			for k,v in pairs(database.players) do
				if pnl:GetColumnText(2) == database.players[k][1] then
					for j,l in pairs(database.players[k].warns) do
						FrameWarningEntrys:AddLine(j,l)
					end
				end
			end
		end
		FrameTabsPlayers:AddSheet("Offline", FrameTabsPanelListOfflinePlayers, "icon16/user_delete.png")
		
		local FrameTabsPanelListPlayersButtonRemove = vgui.Create("DButton", FrameTabsPanelListPlayers)
		FrameTabsPanelListPlayersButtonRemove:Dock(BOTTOM)
		FrameTabsPanelListPlayersButtonRemove:SetText("Remove Warning")
		FrameTabsPanelListPlayersButtonRemove.DoClick = function()
			if FrameWarningEntrys:GetSelectedLine() ~= nil then
				net.Start("removewarn")
				net.WriteEntity(LocalPlayer())
				net.WriteString(FrameOnlinePlayerList:GetLine(FrameOnlinePlayerList:GetSelectedLine()):GetColumnText(2))
				net.WriteString(FrameWarningEntrys:GetLine(FrameWarningEntrys:GetSelectedLine()):GetColumnText(2))
				net.SendToServer()
				net.Start("requestfwarn")
				net.SendToServer()
				Frame:Close()
			end
		end	
		local FrameTabsPanelListPlayersButton = vgui.Create("DButton", FrameTabsPanelListPlayers)
		FrameTabsPanelListPlayersButton:Dock(BOTTOM)
		FrameTabsPanelListPlayersButton:SetText("Give Warning")
		FrameTabsPanelListPlayersButton.DoClick = function()
			if FrameTabsWarningText:GetValue() != "" then
				net.Start("sendWarn")
				net.WriteEntity(LocalPlayer())
				net.WriteString(FrameOnlinePlayerList:GetLine(FrameOnlinePlayerList:GetSelectedLine()):GetColumnText(2))
				net.WriteString(FrameTabsWarningText:GetValue())
				net.WriteBool(true)
				net.SendToServer()
				net.Start("requestfwarn")
				net.SendToServer()
				Frame:Close()
			end
		end
		
		local FrameTabsPanelListOfflinePlayersButtonRemove = vgui.Create("DButton", FrameTabsPanelListOfflinePlayers)
		FrameTabsPanelListOfflinePlayersButtonRemove:Dock(BOTTOM)
		FrameTabsPanelListOfflinePlayersButtonRemove:SetText("Remove Warning")
		FrameTabsPanelListOfflinePlayersButtonRemove.DoClick = function()
			if FrameWarningEntrys:GetSelectedLine() ~= nil then
				net.Start("removewarn")
				net.WriteEntity(LocalPlayer())
				net.WriteString(FrameOfflinePlayerList:GetLine(FrameOfflinePlayerList:GetSelectedLine()):GetColumnText(2))
				net.WriteString(FrameWarningEntrys:GetLine(FrameWarningEntrys:GetSelectedLine()):GetColumnText(2))
				net.SendToServer()
				net.Start("requestfwarn")
				net.SendToServer()
				Frame:Close()
			end
		end	
		local FrameTabsPanelListOfflinePlayersButton = vgui.Create("DButton", FrameTabsPanelListOfflinePlayers)
		FrameTabsPanelListOfflinePlayersButton:Dock(BOTTOM)
		FrameTabsPanelListOfflinePlayersButton:SetText("Give Warning")
		FrameTabsPanelListOfflinePlayersButton.DoClick = function()
			if FrameTabsWarningText:GetValue() != "" then
				net.Start("sendWarn")
				net.WriteEntity(LocalPlayer())
				net.WriteString(FrameOfflinePlayerList:GetLine(FrameOfflinePlayerList:GetSelectedLine()):GetColumnText(2))
				net.WriteString(FrameTabsWarningText:GetValue())
				net.WriteBool(false)
				net.SendToServer()
				net.Start("requestfwarn")
				net.SendToServer()
				Frame:Close()
			end
		end
	end
end

function checkValidPlayer(ply)
	for k,v in pairs(player.GetAll()) do
		if v:SteamID() == ply then
			return true
		end
	end
	return false
end

concommand.Add("openwarningmenu", function(ply, cmd, args)
	net.Start("requestfwarn")
	net.SendToServer()
end)

net.Receive("sendfwarn", openWarnMenu)