; Alt: !
; Control: ^
; Shift: +
; Win Logo: #

#SingleInstance force
#NoTrayIcon

mode := "normal"

#1:: Reload
#0:: ExitApp

LShift & F1:: return
LShift::
  if InRemoteDesktop()
    Return

  NavigateMode()
Return

RShift & F1:: return
RShift::
  if InRemoteDesktop()
    Return

  NormalMode()
Return

Capslock::
  if InRemoteDesktop()
    Return

  Send {Esc}
Return

ProcessNavigate()
{
  UserInput := GetUserInput()

  if (UserInput == "c" || UserInput == "e")
    SwitchToProgram("Neovim", "powershell.exe -WindowStyle Hidden -command e")
  else if (UserInput == "i")
    SwitchToProgram("ahk_class Chrome_WidgetWin_1", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
  else if (UserInput == "o")
    SwitchToProgram("ahk_class rctrl_renwnd32", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook 2016.lnk")
  else if (UserInput == "j")
    Send {down}
  else if (UserInput == "/")
    Send +{F10} ; right click
  else if (UserInput == "k")
    Send {up}
  else if (UserInput == "l")
    Send {right}
  else if (UserInput == "h")
    Send {left}
  else if (UserInput == "0")
    Send {home}
  else if (UserInput == "$")
    Send {end}
  else if (UserInput == "w")
    Send ^{right}
  else if (UserInput == "b")
    Send ^{left}
  else if (UserInput == "S")
  {
    Send {home}{shift down}{end}{shift up}
    NormalMode()
  }
  else if (UserInput == "v")
    VisualMode()
  else if (UserInput == "A")
  {
    Send {end}
    NormalMode()
  }
  else if (UserInput == "I")
  {
    Send {home}
    NormalMode()
  }
  else if (UserInput == "K")
    Send {PgUp}
  else if (UserInput == "J")
    Send {PgDn}
  else
    UnrecognizedInput(UserInput)
}

ProcessVisual()
{
  UserInput := GetUserInput()

  if (UserInput == "k")
    Send +{up}
  else if (UserInput == "j")
    Send +{down}
  else if (UserInput == "l")
    Send +{right}
  else if (UserInput == "h")
    Send +{left}
  else if (UserInput == "w")
    Send ^+{right}
  else if (UserInput == "b")
    Send ^+{left}
  else if (UserInput == "v")
    NavigateMode()
  else if (UserInput == "0")
    Send +{Home}
  else if (UserInput == "$")
    Send +{End}
  else
    UnrecognizedInput(UserInput)
}

UnrecognizedInput(Key)
{
  NormalMode()

  if (Key)
    Send %Key%
}

NormalMode()
{
  global mode
  mode := "normal"
}

InNormalMode()
{
  global mode
  Return mode == "normal"
}

VisualMode()
{
  global mode
  mode := "visual"

  while (InVisualMode())
    ProcessVisual()
}

InVisualMode()
{
  global mode
  Return mode == "visual"
}

NavigateMode()
{
  GoIntoNavigateMode()

  while (InNavigateMode())
    ProcessNavigate()
}

GoIntoNavigateMode()
{
  global mode
  mode := "navigate"
}

InNavigateMode()
{
  global mode
  Return mode == "navigate"
}

GetUserInput()
{
  Input, UserInput, L1, {space}
  Return UserInput
}

SwitchToProgram(identity, location)
{
  if WinExist(identity)
    WinActivate
  else
    Run *RunAs %location%

  NormalMode()
}

InRemoteDesktop()
{
  Return WinActive("ahk_class TscShellContainerClass")
}