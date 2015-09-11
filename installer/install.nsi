!define VERSION "1.7.5_1"

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

!macro X86Files

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

!macro EncFSSetup
  WriteUninstaller $PROGRAMFILES32\EncFS\EncFS4Winy\EncFSUninstall.exe

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy" "DisplayName" "EncFS4Winy ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy" "UninstallString" '"$PROGRAMFILES32\EncFS\EncFS4Winy\EncFSUninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy" "NoRepair" 1

!macroend

Section -Prerequisites
  ; Check Dokany is installed on the system
  
  IfSilent endRequireDokan
  ${If} ${RunningX64}
	SetRegView 64
	ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "DisplayName"
	${If} $0 == ""
		Goto beginRequireDokan
	${EndIf}
  ${Else}
	ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DokanLibrary" "DisplayName"
	${If} $0 == ""
		Goto beginRequireDokan
	${EndIf}
  ${EndIf}
  Goto endRequireDokan
  
  beginRequireDokan:
  MessageBox MB_YESNO "$0 Your system does not appear to have Dokany installed.$\n$\nWould you like to download it?" IDNO endRequireDokan
  ExecShell "open" "https://github.com/dokan-dev/dokany/releases"
  Abort
  endRequireDokan:
SectionEnd

Section "EncFS4Winy x86" section_x86
  !insertmacro X86Files
  !insertmacro EncFSSetup
SectionEnd

Section "Uninstall"
  RMDir /r $PROGRAMFILES32\EncFS\EncFS4Winy
  RMDir $PROGRAMFILES32\EncFS

  SetShellVarContext all
  RMDir /r $SMPROGRAMS\EncFS

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\EncFS4Winy"
SectionEnd

Function .onInit
  IntOp $0 ${SF_SELECTED} | ${SF_RO}
FunctionEnd

Function .onInstSuccess
  IfSilent noshellopen
    ExecShell "open" "$PROGRAMFILES32\EncFS\EncFS4Winy"
  noshellopen:
FunctionEnd

