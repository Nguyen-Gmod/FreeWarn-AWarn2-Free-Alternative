AddCSLuaFile()

fwconfig = {}
fwconfig.allowedgroups = {"superadmin", "admin"}
fwconfig.requirereason = true
fwconfig.bantime = 180
fwconfig.allowedwarns = 3
fwconfig.sql = {}
fwconfig.enabled = false
fwconfig.sql.ip = "127.0.0.1"
fwconfig.sql.port = "1433"
fwconfig.sql.table = "freewarn"
fwconfig.logging = true