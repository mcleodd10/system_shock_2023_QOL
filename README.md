# system_shock_2023_QOL
Autohotkey script for several QOL control fixes for the System Shock 2023 Remake

Available options:
- Quick menu actions for Use & Vaporize (defaults F1 & F3 respectively) 
- Map keys to hold & double-click actions for the right mouse button (i.e., targeting, aiming, mods, etc)
- Map mouse side buttons (not currently working in initial SS2023 release or the first official patch)
- Toggle sprint support (sprinting continues as long as WASD is held)
- Swap mouse wheel scroll direction for hotbar (will however reverse direction for map zoom & text box scrolling)

If the vaporize hotkey doesn't work reliably (usually due to differences in resolution, current value of 45 is for 1080p), adjust the VaporizeYOffset value (defaults to 40, increase to have it click further down, or reduce to click further up)

**RightMouseHold/RightMouseDoubleClick defaults to true, and are mapped to the following keys by default:**
Double-click: Left-alt (Target Enemy)
Hold: Right-alt (personally, bound in-game to Aim)

Requires Autohotkey v2 from https://www.autohotkey.com, download and install it, then just double-click sshock_remake_qol.ahk to start.
