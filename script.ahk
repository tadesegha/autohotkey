; Alt: !
; Control: ^
; Shift: +
; Win Logo: #

#SingleInstance force
#NoTrayIcon

mode := "normal"
windows := { }

#1:: Reload
#0:: ExitApp

LShift & F1:: return
LShift::
  if InRemoteDesktop()
    Return

  VimNavigationMode()
Return

Capslock::
  if InRemoteDesktop()
    Return

  Send {Esc}
Return

ProcessNavigationCommands()
{
  UserInput := GetUserInput()

  if (UserInput == "j")
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
    VimNavigationMode()
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

VimNavigationMode()
{
  GoIntoVimNavigationMode()

  while (InVimNavigationMode())
    ProcessNavigationCommands()
}

GoIntoVimNavigationMode()
{
  global mode
  mode := "navigate"
}

InVimNavigationMode()
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

RShift & F1:: return
RShift::
  if InRemoteDesktop()
    Return

  ProcessWindowNavigationCommand()
Return

ProcessWindowNavigationCommand()
{
  UserInput := GetUserInput()

  if Trim(UserInput) = ""
    NormalMode()
  else
    StoreOrGoToWindow(UserInput)
}

StoreOrGoToWindow(index)
{
  global windows

  handle := "ahk_id " windows[index]

  if (WinActive(handle))
  {
    Msgbox, 260, , "Stop tracking window?"
    IfMsgBox, Yes
      windows.Delete(index)
  }
  else if (WinExist(handle))
    WinActivate, %handle%
  else
    windows[(index)] := WinExist("A")

  NormalMode()
}
