;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Globals ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcessName := "notepad.exe"
;ProcessName := "archeage.exe"
KeepRunning := true

class GatherAction
{
	gathersPerMove := 0
	gatheringTime := 0
	
	__New(gpm, gt)
	{
		this.gathersPerMove := gpm
		this.gatheringTime := gt
	}
}

CommonGatherSpeed := 6000

GatherData := {}
GatherData["Gather Line Fast"] := new GatherAction(1, CommonGatherSpeed)
GatherData["Gather Wide Line Fast"] := new GatherAction(3, CommonGatherSpeed)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Main ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

ShowDialog()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Functions ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShowDialog()
{	
	global
	
	Gui, Add, DropDownList, vDropDownChoice, Gather Line Fast|Gather Wide Line Fast
	Gui, Add, Button, xm, Spam R
	Gui, Add, Button, x+m, Spam G
	Gui, Add, Button, xm, Stop
	Gui, Add, Button, default ym section, Gather
	
	Gui, Show,, AA:U Macros
	return
	
	ButtonGather:
	KeepRunning := true
	Gui, Submit, NoHide
	Gather(DropDownChoice)
	return

	ButtonSpamR:
	KeepRunning := true
	Gui, Submit, NoHide
	SpamKey("r")
	return

	ButtonSpamG:
	KeepRunning := true
	Gui, Submit, NoHide
	SpamKey("g")
	return

	ButtonStop:
	KeepRunning := false
	return
	
	GuiClose:
	ExitApp
}

Gather(GatherDropDownChoice)
{
	global

	GatherActionInstance := GatherData[GatherDropDownChoice]
	GathersPerMove := GatherActionInstance.gathersPerMove

	Loop
	{
		if (not KeepRunning)
			break

		SendToGame("{PgUp}", 250)
		SendToGame("{PgUp}")

		Loop %GathersPerMove%
		{
			if (not KeepRunning)
				break

			SendToGame("g", GatherActionInstance.gatheringTime)
		}
	}
}

SpamKey(Key)
{
	global KeepRunning

	Loop
	{
		if (not KeepRunning)
			break
		SendToGame(Key, 1000)
	}
}

SendToGame(KeyToSend, SleepTime = 0)
{
	global ProcessName
	; ahk_exe searches by exe name e.g. Task Manager process name
	ControlSend,, %KeyToSend%, ahk_exe %ProcessName%
	Sleep %SleepTime%
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hotkeys ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F11::
KeepRunning := false
return