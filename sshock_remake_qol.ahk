#Requires AutoHotkey v2.0
; SS2023 Control QOL Fixes v1
;////////////////////////////////////////////////////////////////////////////////////////
; Available options:
; Remap fire/interact from keyboard to mouse in the case of dropped mouse inputs
; Bind both Aiming & enemy targeting to the Right-click:
;   will work with in-game right-click binding, or with the MouseButtonFix option enabled
;   can be enabled or disabled separately
; Quick menu actions for Vaporize & Use (default F1 & F3 respectively) 
; Map mouse side buttons
; Toggle sprint support
;////////////////////////////////////////////////////////////////////////////////////////

;////////////////////////////////////////////
;/////////// Change these values ////////////
;////////////////////////////////////////////


RightMouseTargets   := true     ; fires targeting hotkey if right-click isn't held for longer than the aim-delay
targetKey           := "LAlt"   ; match to in-game setting

RightMouseAims      := true     ; aims if right-click is held longer than the aim delay
RightMouseAimDelay  := 100      ; length of time to hold right-click before aim is triggered (in ms)
aimKey              := "RAlt"   ; match to in-game setting

ToggleSprint        := true     ; if true, sprinting will continue until all movement keys & shift are released
forward             := "w"      ; set these keys to match in-game
left                := "a"
back                := "s"
right               := "d"
sprintKey           := "LShift"

MouseButtonFix      := true     ; set to true if mouse clicks are being dropped, ensure fire & interact are set in-game to the below values
fireKey             := "RCtrl"  ; set to left-click
interactKey         := "PgDn"   ; set to right-click

; Quick menu actions, hover over the item and hit the corresponding hotkey (only tested at 1080p), disable by removing hotkey text
QuickUseKey         := "F1"     ; quick use
QuickVaporizeKey    := "F3"     ; quick vaporize
VaporizeYOffset     := 40       ; in pixels, relative to mouse, adjust this if the script isn't hitting the correct menu option (higher for down, lower for up)

; enter an in-game hotkey between the quotes to bind to mouse buttons
; to disable, remove character from between quotes, i.e. Mouse3 := ""
Mouse3              := "l"      ; light
Mouse4              := "b"      ; boots
Mouse5              := "p"      ; shield

F10::Reload                     ; restarts script (in the event you change settings)

;////////////////////////////////////////////
;/////// Do not change below values /////////
;////////////////////////////////////////////

SetKeyDelay -1
SetMouseDelay -1

held() {
    sleep RightMouseAimDelay
    if GetKeyState("RButton") {
        if RightMouseAims
            Send "{Blind}{" aimKey " Down}"
    } else {
        if RightMouseTargets
            Send "{Blind}{" targetKey " Down}{" targetKey " Up}" 
    }
}

#HotIf WinActive("ahk_exe SystemReShock-Win64-Shipping.exe")

if MouseButtonFix {
    Hotkey "*~LButton", _ => Send("{Blind}{" fireKey " Down}")
    Hotkey "*~LButton up", _ => Send("{Blind}{" fireKey " Up}")
}
Hotkey "*~RButton", _ => (
    SetTimer(held, -1)
    MouseButtonFix && Send("{Blind}{" interactKey " Down}")
)
Hotkey "*~RButton up", _ => Send("{Blind}{" aimKey " Up}{" interactKey " Up}")

if Mouse3
    Hotkey "*MButton", _ => Send(Mouse3)
if Mouse4
    Hotkey "*XButton1", _ => Send(Mouse4)
if Mouse5
    Hotkey "*XButton2", _ => Send(Mouse5)

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
