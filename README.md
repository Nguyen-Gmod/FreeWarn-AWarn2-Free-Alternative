# FreeWarn-AWarn2-Free-Alternative<br/>
FreeWarn is a free alternative to the popular GmodStore addon AWarn2<br/>

![Menu](https://puu.sh/EvNsP/d911066dae.png)<br/>

###Usage<br/>

!warnmenu - openings warning menu<br/>
!warn player reason - adds a warning to the specified player<br/>

###Config<br/>

fwconfig.allowedgroups = {"superadmin", "admin"} -- Which ULX groups can issue warns from the menu<br/>
fwconfig.requirereason = true --not implemented<br/>
fwconfig.bantime = 180 -- not implemented, currently kicks<br/>
fwconfig.allowedwarns = 3 -- amount of warns before player is auto kicked<br/>
fwconfig.sql = {} - any thing sql is not implemented<br/>
fwconfig.enabled = false<br/>
fwconfig.sql.ip = "127.0.0.1"<br/>
fwconfig.sql.port = "1433"<br/>
fwconfig.sql.table = "freewarn"<br/>
