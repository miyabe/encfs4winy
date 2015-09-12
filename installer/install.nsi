!define VERSION "1.7.5_2"

!include LogicLib.nsh
!include x64.nsh
!include WinVer.nsh

Name "EncFS4WinyInstaller ${VERSION}"
BrandingText http://zamasoft.net/encfs4winy/
OutFile "EncFS4WinyInstall_${VERSION}.exe"

InstallDir $PROGRAMFILES32\EncFS\EncFS4Winy
RequestExecutionLevel admin
LicenseData "licdata.rtf"
ShowUninstDetails show

Page license
Page components
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

!macro EncFSFiles

  SetOutPath $PROGRAMFILES32\EncFS\EncFS4Winy
 
    File ..\encfs\msvc\Release\encfs1.dll
    File ..\rlog-1.4\win32\Release\rlog.dll
    File ..\encfs\msvc\Release\encfs.exe
    File ..\encfs\msvc\Release\encfsw.exe
    File ..\encfs\msvc\Release\encfsctl.exe

  SetOutPath $PROGRAMFILES32\EncFS\EncFS4Winy\encfs1
 
    File ..\encfs\msvc\Release\encfs1\resource.res

  SetShellVarContext all
  CreateDirectory $SMPROGRAMS\EncFS
  CreateShortCut $SMPROGRAMS\EncFS\EncFS.lnk $PROGRAMFILES32\EncFS\EncFS4Winy\encfsw.exe
  CreateShortCut $SMPROGRAMS\EncFS\Uninstall.lnk $PROGRAMFILES32\EncFS\EncFS4Winy\EncFSUninstall.exe

!macroend

!macro DokanFiles

  SetOutPath $PROGRAMFILES32\EncFS\EncFS4Winy
 
    File ..\dokany-0.7.4\license.gpl.txt
    File ..\dokany-0.7.4\license.lgpl.txt
    File ..\dokany-0.7.4\license.mit.txt
    File ..\dokany-0.7.4\Win32\Release\dokanctl.exe
    File ..\dokany-0.7.4\Win32\Release\mounter.exe
    File ..\dokany-0.7.4\Win32\Release\dokan.dll
    File ..\dokany-0.7.4\Win32\Release\dokannp.dll

!macroend

!macro X86Driver os
  SetOutPath $SYSDIR\drivers
    File ..\dokany-0.7.4\Win32\${os}Release\dokan.sys
!macroend

!macro X64Driver os
  ${DisableX64FSRedirection}

  SetOutPath $SYSDIR\drivers

    File ..\dokany-0.7.4\x64\${os}Release\dokan.sys

  ${EnableX64FSRedirection}
!macroend

!macro StartDokan
  ${If} ${RunningX64}
	SetRegView 64
	DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary"
  ${Else}
	DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary"
  ${EndIf}
  
  ExecWait '"$PROGRAMFILES32\EncFS\EncFS4Winy\dokanctl.exe" /i a' $0
  ExecWait '"$PROGRAMFILES32\EncFS\EncFS4Winy\dokanctl.exe" /i n' $0
  DetailPrint "dokanctl returned $0"
!macroend

!macro EncFSSetup
  WriteUninstaller $PROGRAMFILES32\EncFS\EncFS4Winy\EncFSUninstall.exe

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy" "DisplayName" "EncFS4Winy ${VERSION}"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy" "UninstallString" '"$PROGRAMFILES32\EncFS\EncFS4Winy\EncFSUninstall.exe"'
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy" "NoModify" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy" "NoRepair" 1

!macroend

Section "Dokan Driver x86" section_x86_driver
  ${If} ${IsWin7}
    !insertmacro X86Driver "Win7"
  ${ElseIf} ${IsWin2008R2}
    !insertmacro X86Driver "Win7"
  ${ElseIf} ${IsWin8}
    !insertmacro X86Driver "Win8"
  ${ElseIf} ${IsWin2012}
    !insertmacro X86Driver "Win8"
  ${ElseIf} ${IsWin8.1}
    !insertmacro X86Driver "Win8.1"
  ${ElseIf} ${IsWin2012R2}
    !insertmacro X86Driver "Win8.1"
  ${EndIf}
  !insertmacro DokanFiles
  !insertmacro StartDokan
SectionEnd

Section "Dokan Driver x64" section_x64_driver
  ${If} ${IsWin7}
    !insertmacro X64Driver "Win7"
  ${ElseIf} ${IsWin2008R2}
    !insertmacro X64Driver "Win7"
  ${ElseIf} ${IsWin8}
    !insertmacro X64Driver "Win8"
  ${ElseIf} ${IsWin2012}
    !insertmacro X64Driver "Win8"
  ${ElseIf} ${IsWin8.1}
    !insertmacro X64Driver "Win8.1"
  ${ElseIf} ${IsWin2012R2}
    !insertmacro X64Driver "Win8.1"
  ${EndIf}
  !insertmacro DokanFiles
  !insertmacro StartDokan
SectionEnd

Section "EncFS4Winy" section_x86
  !insertmacro EncFSFiles
  !insertmacro EncFSSetup
SectionEnd

Section "Uninstall"
  ${If} ${RunningX64}
	SetRegView 64
	ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "DisplayName"
  ${Else}
	ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "DisplayName"
  ${EndIf}
  Push $0

  ${If} $0 == ""
    ExecWait '"$PROGRAMFILES32\EncFS\EncFS4Winy\dokanctl.exe" /r n' $0
    ExecWait '"$PROGRAMFILES32\EncFS\EncFS4Winy\dokanctl.exe" /r a' $0
    DetailPrint "dokanctl.exe returned $0"

    ${If} ${RunningX64}
      ${DisableX64FSRedirection}
        Delete $SYSDIR\drivers\dokan.sys
      ${EnableX64FSRedirection}
    ${Else}
      Delete $SYSDIR\drivers\dokan.sys
    ${EndIf}
  ${EndIf}

  RMDir /r $PROGRAMFILES32\EncFS\EncFS4Winy
  RMDir $PROGRAMFILES32\EncFS

  SetShellVarContext all
  RMDir /r $SMPROGRAMS\EncFS

  ; Remove registry keys
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy"

  Pop $0
  ${If} $0 == ""
    IfSilent noreboot
      MessageBox MB_YESNO "A reboot is required to finish the uninstallation. Do you wish to reboot now?" IDNO noreboot
      Reboot
    noreboot:
  ${EndIf}

SectionEnd

Function .onInit
  SectionSetFlags ${section_x86_driver} ${SF_RO}  ; disable
  SectionSetFlags ${section_x64_driver} ${SF_RO}  ; disable

  StrCpy $0 ""
  ${If} ${RunningX64}
    ${DisableX64FSRedirection}
    IfFileExists $SYSDIR\drivers\dokan.sys HasDokan NoDokan
    ${EnableX64FSRedirection}
  ${Else}
    IfFileExists $SYSDIR\drivers\dokan.sys HasDokan NoDokan
  ${EndIf}
  
  HasDokan:
  ${If} ${RunningX64}
	SetRegView 64
	ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "DisplayName"
  ${Else}
	ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "DisplayName"
  ${EndIf}
  NoDokan:

  ${If} $0 == ""
    IntOp $0 ${SF_SELECTED} | ${SF_RO}

    ${If} ${RunningX64}
      SectionSetFlags ${section_x64_driver} $0
    ${Else}
      SectionSetFlags ${section_x86_driver} $0
    ${EndIf}
  ${EndIf}

  IntOp $0 ${SF_SELECTED} | ${SF_RO}
  SectionSetFlags ${section_x86} $0

  ; Windows Version check

  ${If} ${RunningX64}
    ${If} ${IsWin2008R2}
    ${ElseIf} ${IsWin7}
	${ElseIf} ${IsWin2012}
	${ElseIf} ${IsWin8}
	${ElseIf} ${IsWin2012R2}
	${ElseIf} ${IsWin8.1}
    ${Else}
      MessageBox MB_OK "Your OS is not supported. Dokan library supports Windows 2008R2, 7, 2012, 8, 2012R2, 8.1 for x64."
      Abort
    ${EndIf}
  ${Else}
    ${If} ${IsWin2008R2}
    ${ElseIf} ${IsWin7}
	${ElseIf} ${IsWin2012}
	${ElseIf} ${IsWin8}
	${ElseIf} ${IsWin2012R2}
	${ElseIf} ${IsWin8.1}
    ${Else}
      MessageBox MB_OK "Your OS is not supported. Dokan library supports Windows 2008R2, 7, 2012, 8, 2012R2, 8.1 for x86."
      Abort
    ${EndIf}
  ${EndIf}
FunctionEnd

Function .onInstSuccess
  IfSilent noshellopen
    ExecShell "open" "$PROGRAMFILES32\EncFS\EncFS4Winy"
  noshellopen:
FunctionEnd

