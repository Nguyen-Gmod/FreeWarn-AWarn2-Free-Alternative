# FreeWarn-AWarn2-Free-Alternative<br/>
FreeWarn is a free alternative to the popular GmodStore addon AWarn2<br/>

![Menu](https://puu.sh/EvNsP/d911066dae.png)<br/>

###Usage<br/>

!warnmenu - openings warning menu<br/>
!warn player reason - adds a warning to the specified player<br/>

###Config<br/>

fwconfig.allowedgroups = {"superadmin", "admin"} -- Which ULX groups can issue warns from the menu
fwconfig.requirereason = true --not implemented
fwconfig.bantime = 180 -- not implemented, currently kicks
fwconfig.allowedwarns = 3 -- amount of warns before player is auto kicked
fwconfig.sql = {} - any thing sql is not implemented
fwconfig.enabled = false
fwconfig.sql.ip = "127.0.0.1"
fwconfig.sql.port = "1433"
fwconfig.sql.table = "freewarn"
