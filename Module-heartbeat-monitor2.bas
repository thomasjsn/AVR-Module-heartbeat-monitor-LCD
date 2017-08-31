'--------------------------------------------------------------
'                   Thomas Jensen | uCtrl.net
'--------------------------------------------------------------
'  file: AVR_HEARTBEAT_MONITOR_2
'  date: 23/12/2006
'--------------------------------------------------------------

$regfile = "8515def.dat"
$crystal = 4000000
Config Portd = Input
Config Portc = Input
Config Portb = Output
Config Porta.0 = Output
Config Porta.1 = Output
Config Porta.2 = Input
Config Porta.3 = Input
Config Watchdog = 1024

Config Lcdpin = Pin , Db4 = Portb.3 , Db5 = Portb.2 , Db6 = Portb.1 , Db7 = Portb.0 , E = Portb.6 , Rs = Portb.7
Config Lcd = 16 * 1

Dim A As Byte
Dim B As Byte
Dim Alarm As Integer
Dim Alarmled As Integer , Is_shown As Integer
Dim Modul(15) As Byte

Deflcdchar 0 , 32 , 4 , 2 , 31 , 2 , 4 , 32 , 32            ' arrow

Alarm = 0
Alarmled = 0
Is_shown = 0
Const Timeout = 21

'boot
Porta.0 = 0
Porta.1 = 0

Cls
Cursor Off
Cls
Locate 1 , 1
Lcd "MSMU #2"

For A = 1 To 15
    Porta.0 = Not Porta.0
    Porta.1 = Not Porta.1
    Waitms 250
Next A

Porta.0 = 0
Porta.1 = 0

Cls
Locate 1 , 1
Lcd "Running"
Waitms 1500
Cls

Start Watchdog

Main:

'lcd display
For B = 1 To 15
Gosub Sjekk

    If Alarm <> 1 Then
    Is_shown = 1
    Waitms 50
    Locate 1 , 1
    Lcd B
      Locate 1 , 4
      If Modul(b) > 1 Then Lcd "Ok" ; Chr(0) ; Modul(b)
      If Modul(b) = 0 Then Lcd "#n/a "
      For A = 1 To 9
      Waitms 50
      Gosub Sjekk
      Next A
    End If

    If Modul(b) = 1 And Alarm = 1 Then
    Is_shown = 1
    Waitms 50
    Locate 1 , 1
    Lcd B
      Locate 1 , 4
      Lcd "FAIL!"
      For A = 1 To 9
      Waitms 50
      Gosub Sjekk
      Next A
    End If


Endoflcd:

If Is_shown = 1 Then
For A = 1 To 15
If Modul(a) > 1 Then Decr Modul(a)
If Modul(a) = 1 Then Alarm = 1
Next A

'lifelight
If Alarm = 0 Then Porta.1 = Not Porta.1
If Alarm = 1 Then Porta.1 = 0

'setting alarmled
If Alarm = 1 And Alarmled = 0 Then Alarmled = 2
If Alarmled > 0 Then Alarmled = Alarmled - 1
If Alarmled = 1 Then Porta.0 = 1
If Alarmled = 0 Then Porta.0 = 0
End If

Is_shown = 0
Cls
Next B
Cls

Goto Main
End

Sjekk:
'setting 15 second timeout
If Pina.2 = 0 And Modul(1) <> 1 Then Modul(1) = Timeout
If Pina.3 = 0 And Modul(2) <> 1 Then Modul(2) = Timeout
If Pinc.2 = 0 And Modul(3) <> 1 Then Modul(3) = Timeout
If Pinc.3 = 0 And Modul(4) <> 1 Then Modul(4) = Timeout
If Pinc.4 = 0 And Modul(5) <> 1 Then Modul(5) = Timeout
If Pinc.5 = 0 And Modul(6) <> 1 Then Modul(6) = Timeout
If Pinc.6 = 0 And Modul(7) <> 1 Then Modul(7) = Timeout
If Pinc.7 = 0 And Modul(8) <> 1 Then Modul(8) = Timeout
If Pind.0 = 0 And Modul(9) <> 1 Then Modul(9) = Timeout
If Pind.1 = 0 And Modul(10) <> 1 Then Modul(10) = Timeout
If Pind.2 = 0 And Modul(11) <> 1 Then Modul(11) = Timeout
If Pind.3 = 0 And Modul(12) <> 1 Then Modul(12) = Timeout
If Pind.4 = 0 And Modul(13) <> 1 Then Modul(13) = Timeout
If Pind.5 = 0 And Modul(14) <> 1 Then Modul(14) = Timeout
If Pind.6 = 0 And Modul(15) <> 1 Then Modul(15) = Timeout
Reset Watchdog

'reset
If Pind.7 = 0 Then
   Alarm = 0
   For A = 1 To 15
   Modul(a) = 0
   Next A
   Cls
   Locate 1 , 1
   Lcd "Reset!"
      For A = 1 To 9
      Waitms 50
      Reset Watchdog
      Next A
   Cls
   Waitms 50
   B = 0
   Goto Endoflcd
   End If

Return