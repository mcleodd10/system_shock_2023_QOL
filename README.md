# system_shock_2023_QOL
Autohotkey script for several QOL control fixes for the System Shock 2023 Remake

Available options:
- Remap fire/interact from keyboard to mouse in the case of dropped mouse inputs
- Bind both Aiming & enemy targeting to Right-click:
  - will work with in-game right-click binding, or with the MouseButtonFix option enabled
  - can be enabled or disabled separately
- Quick menu actions for Vaporize & Use (defaults F1 & F3 respectively) 
- Map mouse side buttons (not currently working in initial SS2023 release)
- Toggle sprint support
- Swap mouse wheel scroll direction for hotbar (will however reverse direction for map zoom & text box scrolling)

If the vaporize hotkey doesn't work reliably (usually due to differences in resolution, current value of 40 is for 1080p), adjust the VaporizeYOffset value (defaults to 40, increase to have it click further down, or reduce to click further up)

Script defaults:

**MouseButtonFix defaults to true, leave enabled if you're experiencing dropped mouse clicks, otherwise set to false.
Ensure your in-game binds are set to the following:**
Fire: Right-control
Interact: Page-down

**RightMouseAims/RightMouseTargets defaults to true, bind in-game controls to the following:**
Target: Left-alt
Aim/zoom: Right-alt

Requires Autohotkey v2 from https://www.autohotkey.com
