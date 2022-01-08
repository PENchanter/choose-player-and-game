Gui, New
Gui, +AlwaysOnTop
Gui, Margin, 5,5

Gui, Font, s20 Norm cBlack, Consolas

Gui Add, GroupBox, x5 y5 w225 h160, Player ?

Gui, Add, Radio, vPlayerChoice x10 y45 section,[&1] Player 1
Gui, Add, Radio, Checked x10 y85,[&2] Player 2
Gui, Add, Radio, x10 y125,[&3] Player 3

Gui, Add, Checkbox, x11 y164 w200 h40 gBToothed, &BlueTooth

Gui Add, GroupBox, x250 y5 w225 h160, Game ?

Gui, Add, Radio, vGameChoice x260 y45 section,[&4] Game 1
Gui, Add, Radio, Checked x260 y85,[&5] Game 2
Gui, Add, Radio, x260 y125,[&6] Game 3

Gui, Font, s17 Norm cBlack, Consolas
Gui, Add, Button, x250 y171 w110 h21 gCanceled, &Cancel
Gui, Add, Button, x400 y171 w75 h21 vOkayed gOkayed, &OK

Gui, Font
Gui, Show, W500 H200, Gaming Clippy 2021

Return

BToothed:
	Gui, Submit, nohide
Return

Okayed:
	Gui, Submit, nohide
	Gui, Destroy
	GOTO GOCONTINUE
Return

GOCONTINUE:

Canceled:
GuiEscape:
GuiClose:
GuiContextMenu:
*Esc::
    ExitApp
