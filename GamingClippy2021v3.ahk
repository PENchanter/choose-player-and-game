#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
; #NoTrayIcon

If FileExist("AHK main icon_orange2340.png")
;	Menu, Tray, Icon, %A_ScriptDir%\clippy-GW2b.ico, 1
	Menu, Tray, Icon, AHK main icon_orange2340.png, 1
Loop, Parse, A_ScriptName, `n, `r
	v_scriptv := % RegExReplace(A_LoopField, ".*?[\w]([\d.]+)\..*", "$1")
Menu, Tray, Tip, %A_ScriptName% ( v. %v_scriptv% )

Global BTooth := "False", BlueToothed := "", GameChoice := "", Okayed := "", PlayerChoice := "", v_archivefile := "", v_archivefolder := "", v_archivepathandfile := "", v_cmdlnargs := "", v_gameexe := "", v_gamepath := "", v_shortcut_name := "", v_xmlfolderandfile = ""

If FileExist(A_ScriptDir . "\" . "Gw2.dat")
	DefaultChoice = Choose1
;	GameChoice := "GUILD WARS 2"						; leave here for reference
If FileExist(A_ScriptDir . "\" . "SWTORLaunch.dll")
	DefaultChoice = Choose2
;	GameChoice := "SWTOR"							; leave here for reference

Gui, AHKGameClippy:+AlwaysOnTop
; Gui, Add, Picture, x-8 y0 w525 h200, RAINBOWPastelRainbowSwirl525x200.png
Gui, AHKGameClippy:Font, s20 Norm cBlack, Consolas
Gui, AHKGameClippy:Add, Text, x10 y10 w200 h50, Player ?
Gui, AHKGameClippy:Add, Text, x10 y40 w175 h2 +0x10
Gui, AHKGameClippy:Add, DropDownList, x10 y50 w205 +Sort +Uppercase vPlayerChoice gOnSelectedP, MERMAN|PEN|VULTURE
Gui, AHKGameClippy:Add, Text, x300 y10 w200 h50, Game ?
Gui, AHKGameClippy:Add, Text, x300 y40 w175 h2 +0x10
Gui, AHKGameClippy:Add, DropDownList, x300 y50 w205 +Sort +Uppercase %DefaultChoice% vGameChoice gOnSelectedG, GUILD WARS 2|SWTOR|VALHEIM
; Gui, Add, DropDownList, x300 y50 w205 +Sort +Uppercase vGameChoice gOnSelectedG, GUILD WARS 2,SWTOR,VALHEIM
Gui, AHKGameClippy:Add, CheckBox, x225 y48 w75 h50 vBlueToothed gBToothed, BT
Gui, AHKGameClippy:Add, Button, x10 y100 w110 h30 gCanceled, &Cancel
Gui, AHKGameClippy:Add, Button, x426 y100 w75 h30 vOkayed gOkayed, &OK
Gui, AHKGameClippy:Font

GuiControl, AHKGameClippy:Hide, BlueToothed
GuiControl, AHKGameClippy:Hide, Okayed

Gui, AHKGameClippy:Show, w517 h166, Gaming Clippy 2021
Return

OnSelectedP:
	Gui, Submit, nohide
	If (PlayerChoice)
;		Run, C:\_PENsTools_\NirCmd64_\nircmd.exe speak text "You've chosen %PlayerChoice%"
	{
		If (GameChoice)
			GuiControl, Show, Okayed
	}
	If (A_Username = "PEN")
	{
		If (PlayerChoice = "PEN")
		{
			GuiControl, Show, BlueToothed
		} Else {
			GuiControl,, BlueToothed, 0
			GuiControl, Hide, BlueToothed
		}
	}
Return

OnSelectedG:
	Gui, AHKGameClippy:Submit, nohide
	If (PlayerChoice)
	{
		If (GameChoice)
			GuiControl, Show, Okayed
	}
Return

; this subroutine is repeated below in the "Okayed" subroutine to modify its contents appropriately.
BToothed:
	Gui, AHKGameClippy:Submit, nohide
Return

Okayed:
	Gui, AHKGameClippy:Submit, nohide
	Gui, AHKGameClippy:Destroy
	GOTO GOCONTINUE
Return

GOCONTINUE:

; ---------------------------------------------------------------- should this simply be: If (BlueToothed)	??
; MsgBox, 4097, Blue Tooth?, BlueToothed = %BlueToothed%
; ExitApp
If (BlueToothed = 1)
	BTtoggle()

; ---------------------------------------------------------------- 'GoSub' chosen game's proper subroutine
If (GameChoice	 = "GUILD WARS 2")
	GameChoice	:= "GUILDWARS2"

GameChoices := "GUILDWARS2,SWTOR,VALHEIM"

; vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv 
; vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv The following stopped working at some point.
; vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv 

Loop, parse, GameChoices, `,
{
	If (GameChoices = A_LoopField)
		If IsLabel(A_LoopField)
			GoSub %A_LoopField%
}

; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ It was going to the appropriate chosen game's subroutine,
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ but something happened and I cannot figure out what exactly.

MsgBox, 4096, Status?, GameChoice = %GameChoice%`nGameChoices = %GameChoices%`nv_gamepath = %v_gamepath%
ExitApp

; ---------------------------------------------------------------- double-check if selected game path+launcher program exists...

If !FileExist(v_gamepath)
	ShowError("Game PATH var or game LAUNCHER is incorrect!")

If !(v_shortcut_name)
	 v_shortcut_name := "AHK - Clippy by PEN ©2021"

	 v_shortcut_loco = %A_Desktop%\%v_shortcut_name%.lnk

If !FileExist(v_shortcut_loco)
	DesktopShortcut()

; ---------------------------------------------------------------- extract files from archive
Run, "PowerShell.exe" -NoProfile -NoLogo -NoExit -Command Expand-Archive -LiteralPath '%v_archivepathandfile%' -DestinationPath '%v_gamepath%' -Force,, Hide
Sleep 3000

; ---------------------------------------------------------------- I would prefer to "MOVE" the file, 
; ---------------------------------------------------------------- but that does not seem to work for me. :(
If FileExist(v_gamepath . "\" . "Local.dat")
{
	FileCopy, %v_gamepath%\Local.dat, %v_xmlfolder%, 1
	Sleep 1500
}

; ---------------------------------------------------------------- copy password from file to 'Clipboard'
FileRead, Clipboard, %v_gamepath%\clippy.txt
Sleep 1500

; ---------------------------------------------------------------- display current variable contents
TrayTip, Hey there!,%PlayerChoice%`n%Clipboard%`n%v_gamepath%\%v_gameexe%,,49
Sleep 3000
TrayTip

; ---------------------------------------------------------------- run selected game
Run, "%v_gamepath%\%v_gameexe%" %v_cmdlnargs%,,,gamePID

If (BlueToothed = 1)
{
	Process, WaitClose, %gamePID%
	BTtoggle()
}

Canceled:
GuiEscape:
GuiClose:
    ExitApp

; ****************************************************************
; ****************************************************************

; -----------------------------------------------------------sub-- display message to reveal if results are correct
ShowTrayTip:
TrayTip, Hey there!, %PlayerChoice%`n%v_clippass%,,49
Sleep 3000
TrayTip
Return

; -----------------------------------------------------------sub-- show the contents of variables
ShowProgress:
; GoSub, ShowProgress
	MsgBox, 4096, Take a look at these,BToggle = %BToggle%`ndoc = %doc%`nDocNode = %DocNode%`ngwPID = %gwPID%`nLaunchIt = %LaunchIt%`nouterXml = %outerXml%`nxml = %xml%`nv_archivepathandfile = %v_archivepathandfile%`nv_archivefile = %v_archivefile%`nv_archivefolder = %v_archivefolder%`nv_gamepath = %v_gamepath%`nv_gameexe = %v_gameexe%`nv_gamestuff = %v_gamestuff%`nv_clippassfile = %v_clippassfile%`nv_clippass = %v_clippass%`nv_nickname = %v_nickname%`nv_clippassfile = %v_clippassfile%`nv_gameexe = %v_gameexe%`nv_gamelaunch = %v_gamelaunch%`nv_gamepath = %v_gamepath%`nv_regex_haystack = %v_regex_haystack%`nv_regex_needle = %v_regex_needle%`nv_regex_replacement = %v_regex_replacement%`nv_shortcut_description = %v_shortcut_description%`nv_shortcut_icon = %v_shortcut_icon%`nv_shortcut_iconnumber = %v_shortcut_iconnumber%`nv_shortcut_linkfile = %v_shortcut_linkfile%`nv_shortcut_target = %v_shortcut_target%`nv_shortcut_workingdir = %v_shortcut_workingdir%`nv_xmlfile = %v_xmlfile%`nv_xmlfolder = %v_xmlfolder%`nv_xmlfolderandfile = %v_xmlfolderandfile%
	IfMsgBox Ok, {
		Return
	} Else IfMsgBox Cancel, {
		ExitApp
	}
Return

; ---------------------------------------------------------------- show error message with custome message content
ShowError(ErrorMessage)
{
	Global v_return
	MsgBox, 4096, UH-OH!!, %ErrorMessage%
	If !(v_return)
		ExitApp
	v_return := ""
	Return
}
Return

; ---------------------------------------------------------------- Toggle BlueTooth
BTtoggle(){
	Run ms-settings:bluetooth
	WinWaitActive Settings
	Sleep 2500
	SendInput {Tab}{Space}
	Sleep 1500
	WinClose Settings
	Return
	}
Return

; ---------------------------------------------------------------- create desktop shortcut to a copy this script
; ---------------------------------------------------------------- that has been copied to 'v_gamepath'
; v_shortcut_name := "AHK - Clippy by PEN ©2021"
; If !FileExist(A_Desktop . "\" . "%v_shortcut_name%.lnk")
;	DesktopShortcut()
; Return

DesktopShortcut() {
Global v_gamepath, v_shortcut_name

; ---------------------------------------------------------------- THIS IS TEMPORARY! this script should be contained within an archive file
If !FileExist(v_gamepath . "\" . A_ScriptName)
{
	FileCopy, %A_ScriptFullPath%, %v_gamepath%, 1
	Sleep 1500
}
; ----------------------------------------------------------------

If !FileExist(v_gamepath . "\" . "Clippy.ico")
{
	v_return := "yes, return"			; conjole 'ShowError' function to 'Return' to this point...
	ShowError(Icon file not found!)
	Return								; 'Return' to point where this function was CALLed.
}

TrayTip, Hey there %A_Username%!, Attempting to create`na desktop shortcut for`n%v_shortcut_name%,,49
Sleep, 3000
; TrayTip

v_shortcut_target		 =  %v_gamepath%\%A_ScriptName%
v_shortcut_linkfile		:=  A_Desktop "\" v_shortcut_name ".lnk"
v_shortcut_workingdir	 =  %v_gamepath%
v_shortcut_description	:= "%v_shortcut_name%"
v_shortcut_icon			 =  %v_gamepath%\Clippy.ico
v_shortcut_iconnumber	 = 1
FileCreateShortcut, %v_shortcut_target%, %v_shortcut_linkfile%, %v_shortcut_workingdir%,, %v_shortcut_description%, %v_shortcut_icon%,, %v_shortcut_iconnumber%

TrayTip
; TrayTip, Finished!, A shortcut should now`nbe on your desktop for`n%v_shortcut_name%.`nLaunch it! :),,49
; Sleep 5000
; TrayTip
MsgBox, 4096, Finished!!, You should now be able to launch a`nshortcut on your desktop named:`n%v_shortcut_name%
Return
}

; ================================================================ Guild Wars 2
GUILDWARS2:

Global PlayerChoice, v_gamepath, v_gameexe, v_archivepathandfile, v_archivefile, v_archivefolder, v_xmlfolderandfile

Loop, %A_AppData%\Guild Wars 2\*64.exe.xml, 0, 0
	v_xmlfolderandfile := A_LoopFileFullPath

If !(v_xmlfolderandfile)
	ShowError("File not found!")

SplitPath, v_xmlfolderandfile, v_xmlfile, v_xmlfolder

FileRead, xml, %v_xmlfolderandfile%

doc := ComObjCreate("MSXML2.DOMDocument.6.0")
doc.async := false
doc.loadXML(xml)

DocNode		:= doc.selectSingleNode("//GSA_SDK/APPLICATION/INSTALLPATH")
outerXml	:= DocNode.xml
v_gamepath	:= DocNode.getAttribute("Value")

DocNode		:= doc.selectSingleNode("//GSA_SDK/APPLICATION/EXECUTABLE")
outerXml	:= DocNode.xml
v_gameexe	:= DocNode.getAttribute("Value")

If !FileExist(v_gamepath "\" v_gameexe)
	ShowError("Game PATH/LAUNCHER is incorrect! -GW-sub-")

xml := ""

; ---------------------------------------------------------------- strip (single?) trailing backslash, if any
v_regex_haystack	 = %v_gamepath%
v_regex_needle		:= "\\$"
v_regex_replacement	:= ""
v_gamepath 			:= RegExReplace(v_regex_haystack, v_regex_needle, v_regex_replacement)

Loop, %v_gamepath%\%PlayerChoice%*AppData*.zip, 0, 0
	v_archivepathandfile := A_LoopFileFullPath

If FileExist(v_archivepathandfile)
	{
	SplitPath, v_archivepathandfile, v_archivefile, v_archivefolder
	} Else {
	ShowError("Player data archive not found!")
	}

v_cmdlnargs = -maploadinfo

TrayTip, GUILDWARS2!, %v_gamepath%\%v_gameexe%`n%v_cmdlnargs%,5,49

MsgBox, 4096, Game Chosen,PLAYER = %PlayerChoice%`nGAME = %GameChoice%`nBLUETOOTH = %BlueToothed%`nv_gamepath = %v_gamepath%`nYou made it to the 'Guild Wars 2' subroutine!
; Return

Return
; ================================================================ SWTOR
SWTOR:

Global PlayerChoice, v_gamepath, v_gameexe, v_archivepathandfile, v_archivefile, v_archivefolder

RegRead, v_gamepath, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\BioWare\Star Wars-The Old Republic, Install Dir

v_gameexe = launcher.exe

If !FileExist(v_gamepath "\" v_gameexe)
	ShowError("Game PATH/LAUNCHER is incorrect! -SW-sub-")

Loop, %v_gamepath%\*settings*%PlayerChoice%.zip, 0, 0
	v_archivepathandfile := A_LoopFileFullPath

If FileExist(v_archivepathandfile)
	{
	SplitPath, v_archivepathandfile, v_archivefile, v_archivefolder
	} Else {
	ShowError("Player data archive not found!")
	}

TrayTip, SWTOR!, %v_gamepath%\%v_gameexe%,5,49

MsgBox, 4096, Game Chosen,PLAYER = %PlayerChoice%`nGAME = %GameChoice%`nBLUETOOTH = %BlueToothed%`nv_gamepath = %v_gamepath%`nYou made it to the 'SWTOR' subroutine!
; Return

Return

; ================================================================ Valheim
VALHEIM:

Global PlayerChoice, v_gamepath, v_gameexe, v_archivepathandfile, v_archivefile, v_archivefolder

v_gamepath = x:\path\to\valheim
v_gameexe  = VALHEIM.EXE

TrayTip, VALHEIM!, %v_gamepath%\%v_gameexe%,5,49

MsgBox, 4096, Game Chosen,PLAYER = %PlayerChoice%`nGAME = %GameChoice%`nBLUETOOTH = %BlueToothed%`nv_gamepath = %v_gamepath%`nYou made it to the 'VALHEIM' subroutine!
Return
