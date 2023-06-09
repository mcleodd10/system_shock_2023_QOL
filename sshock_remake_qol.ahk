; SS2023 Control QOL Fixes v1.2
;////////////////////////////////////////////////////////////////////////////////////////
; Available options:
; Remap fire/interact from keyboard to mouse in the case of dropped mouse inputs
; Allow double-click, and hold actions for the Right-mouse button, with customizable delay
; Quick menu actions for Vaporize & Use (default F1 & F3 respectively) 
; Map mouse side buttons
; Toggle sprint support
; Swap mouse wheel scroll direction
;////////////////////////////////////////////////////////////////////////////////////////

#Requires AutoHotkey v2.0

;////////////////////////////////////////////
;/////////// Change these values ////////////
;////////////////////////////////////////////

RightMouseDoubleClick   := true     ; fires the hotkey defined below if right-click isn't held for longer than the aim-delay
DoubleClickDelay        := 200      ; second click must be within this many milliseconds
doubleKey               := "LAlt"   ; Key to send when RMouse is double-clicked. Default is bound to the target function in-game

RightMouseHold          := true     ; aims if right-click is held longer than the aim delay
RightMouseHoldDelay     := 150      ; length of time to hold right-click before hotkey is triggered (in ms)
holdKey                 := "RAlt"   ; Key to send when RMouse is held. I bound "aim" to LAlt in game, so holding right-click will aim after the delay

ToggleSprint            := true     ; if true, sprinting will continue until all movement keys & shift are released
forward                 := "w"      ; set these keys to match in-game
left                    := "a"
back                    := "s"
right                   := "d"
sprintKey               := "LShift"

SwapScrollDirection     := false     ; swaps mouse wheel scroll direction, also affects text boxes and map zoom

; enter an in-game hotkey between the quotes to bind to mouse buttons
; to disable, remove character from between quotes, i.e. Mouse3 := ""
Mouse3                  := "l"      ; light
Mouse4                  := "b"      ; boots
Mouse5                  := "p"      ; shield

; Quick menu actions, hover over the item and hit the corresponding hotkey (only tested at 1080p), disable by removing hotkey text
QuickUseKey             := "F1"     ; quick use
QuickVaporizeKey        := "F3"     ; quick vaporize
VaporizeYOffset         := 45       ; in pixels, relative to mouse, adjust this if the script isn't hitting the correct menu option (higher for down, lower for up)

F10::Reload                         ; restarts script (in the event you change settings)

;////////////////////////////////////////////
;/////// Do not change below values /////////
;////////////////////////////////////////////

SetKeyDelay -1
SetMouseDelay -1

RightMouseHoldDelay /= 1000

clickStart() {
    if RightMouseDoubleClick
        doubleStart(DoubleClickDelay)
    if RightMouseHold && !KeyWait("RButton", "U T" RightMouseHoldDelay) {
        Send "{Blind}{" holdKey " Down}"
    }
}

double := 0
doubleStart(delay := 200) {
    global double
    delay *= -1
    double := !double ? 1 : 2
    SetTimer(doubleClick, delay)
}

doubleClick() {
    global double
    if double = 2 {
        Send "{Blind}{" doubleKey " Down}{" doubleKey " Up}"
        double := 0
    } else if double = 1 {
        double := 0
    }
}

HotIfWinActive "ahk_exe SystemReShock-Win64-Shipping.exe"

if RightMouseDoubleClick || RightMouseHold
    Hotkey "*~RButton", _ => SetTimer(clickStart, -1)

if RightMouseDoubleClick
    Hotkey "*~RButton up", _ => Send("{Blind}{" holdKey " Up}")

if Mouse3
    Hotkey "*MButton", _ => Send(Mouse3)
if Mouse4
    Hotkey "*XButton1", _ => Send(Mouse4)
if Mouse5
    Hotkey "*XButton2", _ => Send(Mouse5)

if SwapScrollDirection {
    Hotkey "WheelDown", _ => Click("WheelUp")
    Hotkey "WheelUp", _ => Click("WheelDown")
}

GotoMenu(type := "use") {
    y2 := type = "use" 
        ? "1" 
        : type = "vaporize" 
            ? VaporizeYOffset
            : ""
    if !y2
        return
    MouseGetPos &x, &y
    Click "Right"
    Sleep 50
    Click "Rel 20 " y2
    Sleep 50
    Click Format("{} {} 0", x, y)
    KeyWait(RegExReplace(A_ThisHotkey,"[^a-zA-Z0-9]*"))
}

if QuickUseKey
    Hotkey "*~" QuickUseKey, _ => GotoMenu("use")

if QuickVaporizeKey
    Hotkey "*~" QuickVaporizeKey, _ => GotoMenu("vaporize")

aSprint := [forward, left, back, right, sprintKey]
SprintFunc(ThisKey) {
    If GetKeyState(sprintKey) {
        for key in aSprint {
            if GetKeyState(key, "p")
                return
        }
        Send "{Blind}{" sprintKey " up}"
    }
}

if ToggleSprint {
    Hotkey "*" sprintKey, _ => Send("{Blind}{" sprintKey " down}")
    for key in aSprint {
        Hotkey "*~" key " up", SprintFunc
    }
}
