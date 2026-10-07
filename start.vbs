' Content OS launcher - starts the local server (hidden) and opens the app window
Option Explicit
Dim sh, fso, dir, url, http, i, ok, edge, chrome
Set sh = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
dir = fso.GetParentFolderName(WScript.ScriptFullName)
url = "http://localhost:8787/"

ok = Ping()
If Not ok Then
  sh.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & dir & "\server\server.ps1""", 0, False
  For i = 1 To 40
    WScript.Sleep 250
    If Ping() Then ok = True : Exit For
  Next
End If
If Not ok Then
  MsgBox "Content OS start failed. Please try again.", 48, "Content OS"
  WScript.Quit
End If

edge = sh.ExpandEnvironmentStrings("%ProgramFiles(x86)%") & "\Microsoft\Edge\Application\msedge.exe"
If Not fso.FileExists(edge) Then edge = sh.ExpandEnvironmentStrings("%ProgramFiles%") & "\Microsoft\Edge\Application\msedge.exe"
chrome = sh.ExpandEnvironmentStrings("%ProgramFiles%") & "\Google\Chrome\Application\chrome.exe"
If fso.FileExists(edge) Then
  sh.Run """" & edge & """ --app=" & url & " --window-size=1440,900", 1, False
ElseIf fso.FileExists(chrome) Then
  sh.Run """" & chrome & """ --app=" & url & " --window-size=1440,900", 1, False
Else
  sh.Run url, 1, False
End If

Function Ping()
  On Error Resume Next
  Set http = CreateObject("MSXML2.XMLHTTP")
  http.Open "GET", url & "api/ping?t=" & Timer, False
  http.Send
  Ping = (Err.Number = 0 And http.Status = 200)
  Err.Clear
End Function
