@echo off
rem ������ ��� ���� 䠩��� ����ਡ�⨢�
rem ��ࠬ��� - ��姭��� ����� ���ᨨ (����� ᮮ⢥����� ��� �� CVS)
set d4=CommonControls%prversion%D4
set d5=CommonControls%prversion%D5
set d6=CommonControls%prversion%D6
set d7=CommonControls%prversion%D7
set bcb5=CommonControls%prversion%BCB5
set bcb6=CommonControls%prversion%BCB6
set doc=CommonControls%prversion%eng
set src=CommonControls%prversion%SRC

set prcat=%CD%\..

rem ��⠫��, � htmp ���� ��� CommonControls
set prhtml=%prcat%\..\CommonControls_documentation\Draft_Html

rem ���� � ������� �ணࠬ�� ��� �������樨 ���
set dipas=%prcat%\..\Bin\dipas_console_m.exe

rem ��⠫��, �㤠 ������� ����ਡ�⨢
set dpup=%prcat%\..\..\upload

rem �६���� ��⠫��� ��� ᡮન ����ਡ�⨢�
set dppr=%dpup%\Temp
set dplib=%dpup%\TempLib

rem ������騪 
set wz=%CD%\..\..\bin\pkzip25.exe

set prrescompile=%prcat%\RES\ENG

set d4cat=C:\Program Files\Borland\Delphi4
set d5cat=C:\Program Files\Borland\Delphi5
set d6cat=C:\Program Files\Borland\Delphi6
set d7cat=C:\Program Files\Borland\Delphi7
set bcb5cat=C:\Program Files\Borland\CBuilder5
set bcb6cat=C:\Program Files\Borland\CBuilder6
