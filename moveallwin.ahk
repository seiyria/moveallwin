
; credit goes originally to http://autohotkey.com/board/topic/17885-dual-monitor-swap/
; I modified this so it works with any number of monitors
; caveats:
; * your monitors all have to be the same size (probably)
; * it does not move minimized windows (this effect looks terrible on windows 10)
; * it does some really dumb unnecessary swap that I don't know how to fix

; get the total monitors available
SysGet, NumMons, MonitorCount

; instant swap
SetWinDelay, 0

; alt-win-right arrow
!#Right::
MoveRight:
{
  DetectHiddenWindows, Off
  WinGet, WinArray, List

  i := WinArray

  Loop, %NumMons% {

    CurMon := A_Index
    NextMon := CurMon-1 < 0 ? NumMons : CurMon-1

    Loop, %i% {
       WinID := WinArray%A_Index%
       WinGetTitle, CurWin, ahk_id %WinID%
       If (CurWin)
       {
         SwapMon(WinID, CurMon, NextMon)
       }
    }
  }
  return
}

; alt-win-left arrow
; I wish I didn't have to copy/paste this, but I don't know how autohotkey works
!#Left::
MoveLeft:
{
  DetectHiddenWindows, Off
  WinGet, WinArray, List

  i := WinArray

  Loop, %NumMons% {

    CurMon := A_Index
    NextMon := NumMons-CurMon-1 < 0 ? NumMons-CurMon-1 : NumMons

    Loop, %i% {
       WinID := WinArray%A_Index%
       WinGetTitle, CurWin, ahk_id %WinID%
       If (CurWin)
       {
         SwapMon(WinID, CurMon, NextMon)
       }
    }
  }
  return
}

; move the window WinId from LeftMonitorNumber to RightMonitorNumber
SwapMon(WinID, LeftMonitorNumber, RightMonitorNumber)
{
  SysGet, Mon1, Monitor, %LeftMonitorNumber%
  SysGet, Mon2, Monitor, %RightMonitorNumber%
  WinGetPos, WinX, WinY, WinWidth, , ahk_id %WinID%

  WinCenter := WinX + (WinWidth / 2) ; Determines which monitor this is on by the position of the center pixel.
  if (WinCenter > Mon1Left and WinCenter < Mon1Right) {
    WinX := Mon2Left + (WinX - Mon1Left)
  } else if (WinCenter > Mon2Left and WinCenter < Mon2Right) {
    WinX := Mon1Left + (WinX - Mon2Left)
  }

  WinMove, ahk_id %WinID%, , %WinX%, %WinY%
  return
}
