@Echo Off
SetLocal

:begin

echo:
echo ****** Disable folder networking ******
echo:

set /p folder=Please enter the folder (Exit please close the window directly):
If Not Exist "%folder%\" Exit/B
If /I "%CD%" NEq "%folder%" PushD %folder%
Set "Cmnd=netsh advfirewall firewall add rule action=block"
echo:
For /R %%a In (*.exe) Do (For %%b In (in out) Do (
      echo Create ban  %%b rule[%%a]
      %Cmnd% name="blocked %%a via script" dir=%%b program="%%a"))

echo:
echo the inbound/outbound prohibition rules for all exe files in %folder% have been successfully created
echo ----------------------------
echo:

goto begin