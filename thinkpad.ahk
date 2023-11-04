/*
--------------------------------
Thinkpad with semi-broken keyboard helper -- By owhs
--------------------------------
Programmable On-Screen Keyboard -- POSK() v0.01  By owhs
--------------------------------
On-Screen Keyboard -- OSK() v1.5  By FeiYue
--------------------------------
*/


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
CoordMode, Mouse, Screen ; Regardless of being used or not, still doesn't work correctly
;#SingleInstance, Force

I_Icon = keyboard.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%


WindowActive :=  0


POSK(shiftKey=false) {

  Send {Ctrl up}{Alt up}
  
;--------------------------------
;             CONFIG:
;--------------------------------

  ; Keyboard layout: [key name, width, spacing]
  row1:=[ ["t"],["y"] ]
  row2:=[ ["["],["]"] ]
  row3:=[ ["{"],["}"] ]
  KeyboardRows = 3

  ; Special values - replace label with custom text
  global SpecialValues := { }
    
  ; GUI
  FontSize:=15
  
  ButtonWidth:=40
  ButtonHeight:=30
  
  BackgroundColour=000000 ;Set same as transparent colour to hide bg
  TransparentColour=00FF00
  
  AutoCloseTime := 2 * 1000 ; s * 1000 (ms total)
  
  Transparency = 125 ; Upto 255, ~125 is good
  
;--------------------------------
;           CONFIG END
;--------------------------------


  Gui, POSK: Destroy
  Gui POSK:+LastFound
  Gui, POSK: +DPIScale +AlwaysOnTop -Border +Owner +E0x08000000
  WinSet, Style, -0xC00000
  Gui, POSK: Font, s%FontSize%, Arial Unicode MS
  Gui, POSK: Margin, 5, 5
  Gui, POSK: Color, %BackgroundColour%
  WinSet, TransColor, %TransparentColour% %Transparency%
  
  ; Add Keys:
  Loop, %KeyboardRows% {
    if (A_Index<=2)
      j=
    For i,v in row%A_Index%
    {
      w:=v.2 ? v.2 : ButtonWidth, d:=v.3 ? v.3 : 2
      j:=j="" ? "xm" : i=1 ? "xm y+2" : "x+" d
	  l:=shiftKey=false ? v.1 : Format("{:U}", v.1) 
      Gui, POSK: Add, Button, %j% w%w% h%ButtonHeight% cGreen BackgroundTrans cRED -Wrap gRunPOSK, % l
    }
  }
  MouseGetPos, xPos, yPos
  yPos -= 30, xPos -= 30
  Gui, POSK: Show, NA NA x%xPos% y%yPos% NoActivate, POSK
  global WindowActive := 1
  SetTimer, Hide, %AutoCloseTime%
  return
  
  POSKGuiClose:
  Gui, POSK: Destroy
  return

  RunPOSK:
  k:=A_GuiControl
  For what, with in SpecialValues
     StringReplace, k, k, %what%, %with%, All
  Send {Text}%k%
  global WindowActive := 0
  Gui, Hide
  return
  
  Hide:
  global WindowActive := 0
  Gui, POSK: Hide
  return
}
                                                                                  
~Esc::Gui, POSK: Hide ; hide gui when you press escape key

Ctrl & LAlt::POSK() ; show gui when you press ctrl and alt

; LCtrl & RCtrl::Send {Ctrl up}{LWin}
RShift & RAlt::POSK(true)
LAlt & Delete::SendInput, {Ctrl up}{Alt up}{Backspace} 
LAlt & r::Send {Ctrl up}{Alt up}{t}
LAlt & u::Send {Ctrl up}{Alt up}{y}
LAlt & LCtrl::Send {Ctrl up}{Alt up}{LWin}


#IfWinActive, ahk_exe Chrome.exe
LAlt & w::Send {Ctrl up}{Alt up}{Ctrl down}{t}{Ctrl up}
LAlt & j::Send {Ctrl up}{Alt up}{Ctrl down}{Shift down}{j}{Ctrl up}{Shift up}
#IfWinActive
