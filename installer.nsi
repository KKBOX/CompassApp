; basic script template for NSIS installers
;
; Written by Philip Chu
; Copyright (c) 2004-2005 Technicat, LLC
;
; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from the use of this software.
 
; Permission is granted to anyone to use this software for any purpose,
; including commercial applications, and to alter it ; and redistribute
; it freely, subject to the following restrictions:
 
;    1. The origin of this software must not be misrepresented; you must not claim that
;       you wrote the original software. If you use this software in a product, an
;       acknowledgment in the product documentation would be appreciated but is not required.
 
;    2. Altered source versions must be plainly marked as such, and must not be
;       misrepresented as being the original software.
 
;    3. This notice may not be removed or altered from any source distribution.
 
!define setup "setup.exe"
 
; change this to wherever the files to be packaged reside
!define srcdir "."
 
!define company "Handlino Inc."
!define prodname "Compass.app"

!define exec "compass-app.exe"
#!define folder "packages\windows\compass.app"
 
; optional stuff
 
; text file to open in notepad after installation
!define notefile "README.markdown"
 
; license text file
!define licensefile "LICENSE"

; help file
;!define helpfile "lib\dowuments\extensions_readme.txt"
 
; icons must be Microsoft .ICO files
!define icon "lib\images\icon\icon-win.ico"
 
; installer background screen
!define screenimage "lib\images\icon\bmp_24.bmp"

!define website "http://compass.handlino.com/"
!define doc_website "http://compass.handlino.com/doc/"
!define wiki_website "https://github.com/handlino/CompassApp/wiki"
 
; file containing list of file-installation commands
; !define files "files.nsi"
 
; file containing list of file-uninstall commands
; !define unfiles "unfiles.nsi"
 
; registry stuff
 
!define regkey "Software\${prodname}"
!define uninstkey "Software\Microsoft\Windows\CurrentVersion\Uninstall\${prodname}"
 
!define startmenu "$SMPROGRAMS\${prodname}"
!define uninstaller "uninstall.exe"
 
;--------------------------------
 
XPStyle on
ShowInstDetails hide
ShowUninstDetails hide
 
Name "${prodname}"
Caption "${prodname}"  # TODO
 
!ifdef icon
Icon "${icon}"
!endif
 
OutFile "packages/windows_installer/${setup}"
 
SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal
 
InstallDir "$PROGRAMFILES\${prodname}"
InstallDirRegKey HKLM "${regkey}" ""
 
!ifdef licensefile
LicenseText "License"
LicenseData "${srcdir}\${licensefile}"
!endif
 
; pages
; we keep it simple - leave out selectable installation types
BrandingText "${company}"

;!ifdef licensefile
;Page license
;!endif
 
; Page components
;Page directory
;Page instfiles
 
;UninstPage uninstConfirm
;UninstPage instfiles

!include "MUI2.nsh"

; MUI Settings
!define MUI_ICON "${srcdir}\${icon}"
!define MUI_UNICON "${srcdir}\${icon}"
!define MUI_HEADERIMAGE "${srcdir}\${screenimage}"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${srcdir}\${screenimage}"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${srcdir}\${screenimage}"
!define MUI_INSTFILESPAGE_PROGRESSBAR colored
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING_CANCEL_DEFAULT

!define MUI_TEXT_WELCOME_INFO_TITLE       "Handlino Inc. Compass.app"
!define MUI_TEXT_WELCOME_INFO_TEXT        "Handlino Inc. Welcome Text #TODO"
!define MUI_INNERTEXT_LICENSE_BOTTOM      "Handlino Inc. License Buttom"
!define MUI_TEXT_LICENSE_TITLE            "Handlino Inc. License Title"
!define MUI_TEXT_LICENSE_SUBTITLE         "Handlino Inc. License Subtitle"
!define MUI_INNERTEXT_LICENSE_TOP         "Handlino Inc. License Top"
!define MUI_TEXT_DIRECTORY_TITLE          "Handlino Inc. Directory Title"
!define MUI_TEXT_DIRECTORY_SUBTITLE       "Handlino Inc. Directory Subtitle"
!define MUI_TEXT_INSTALLING_TITLE         "Handlino Inc. Installing Title"
!define MUI_TEXT_INSTALLING_SUBTITLE      "Handlino Inc. Installing Subtitle"
!define MUI_TEXT_FINISH_TITLE             "Handlino Inc. Finish Title"
!define MUI_TEXT_FINISH_SUBTITLE          "Handlino Inc. Finish Subtitle"
!define MUI_UNTEXT_CONFIRM_TITLE          "Handlino Inc. Uninstall Confirm Title"
!define MUI_UNTEXT_CONFIRM_SUBTITLE       "Handlino Inc. Uninstall Confirm Subtitle"
!define MUI_UNTEXT_UNINSTALLING_TITLE     "Handlino Inc. Uninstalling Title"
!define MUI_UNTEXT_UNINSTALLING_SUBTITLE  "Handlino Inc. Uninstalling Subtitle"
!define MUI_UNTEXT_FINISH_TITLE           "Handlino Inc. Uninstall Finish Title"
!define MUI_UNTEXT_FINISH_SUBTITLE        "Handlino Inc. Uninstall Finish Subtitle"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE license
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"
;--------------------------------
 
AutoCloseWindow false
ShowInstDetails show
 
 
;!ifdef screenimage
; 
;; set up background image
;; uses BgImage plugin
; 
;Function .onGUIInit
;	; extract background BMP into temp plugin directory
;	InitPluginsDir
;	File /oname=$PLUGINSDIR\1.bmp "${screenimage}"
; 
;	BgImage::SetBg /NOUNLOAD /FILLSCREEN $PLUGINSDIR\1.bmp
;	BgImage::Redraw /NOUNLOAD
;FunctionEnd
; 
;Function .onGUIEnd
;	; Destroy must not have /NOUNLOAD so NSIS will be able to unload and delete BgImage before it exits
;	BgImage::Destroy
;FunctionEnd
; 
;!endif
; 
; beginning (invisible) section
Section
 
  WriteRegStr HKLM "${regkey}" "Publisher" "${company}"
  WriteRegStr HKLM "${regkey}" "Install_Dir" "$INSTDIR"
  ; write uninstall strings
  WriteRegStr HKLM "${uninstkey}" "DisplayName" "${prodname} (remove only)"
  WriteRegStr HKLM "${uninstkey}" "UninstallString" '"$INSTDIR\${uninstaller}"'
 
!ifdef filetype
  WriteRegStr HKCR "${filetype}" "" "${prodname}"
!endif
 
  WriteRegStr HKCR "${prodname}\Shell\open\command\" "" '"$INSTDIR\${exec} "%1"'
 
!ifdef icon
  WriteRegStr HKCR "${prodname}\DefaultIcon" "" "$INSTDIR\${icon}"
!endif
 
  SetOutPath $INSTDIR
 
 
; package all files, recursively, preserving attributes
; assume files are in the correct places
;File /r "${srcdir}\${folder}"

File "${srcdir}\packages\windows\compass.app\compass-app.exe"
File "${srcdir}\packages\windows\compass.app\compass-app.jar"
File /r "${srcdir}\packages\windows\compass.app\lib"
 
!ifdef licensefile
File "${srcdir}\${licensefile}"
!endif
 
!ifdef notefile
File "${srcdir}\${notefile}"
!endif
 
!ifdef icon
File "${srcdir}\${icon}"
!endif
 
; any application-specific files
!ifdef files
!include "${files}"
!endif
 
  WriteUninstaller "${uninstaller}"
 
SectionEnd
 
; create shortcuts
Section
 
  CreateDirectory "${startmenu}"
  SetOutPath $INSTDIR ; for working directory
  CreateShortCut "${startmenu}\${prodname}.lnk" "$INSTDIR\${exec}" "" "$INSTDIR\icon-win.ico"
 
!ifdef notefile
  CreateShortCut "${startmenu}\Readme.lnk "$INSTDIR\${notefile}"
!endif
 
!ifdef helpfile
  CreateShortCut "${startmenu}\ExtensionReadme "$INSTDIR\${helpfile}"
!endif
 
!ifdef website
WriteINIStr "${startmenu}\Official site.url" "InternetShortcut" "URL" ${website}
!endif

!ifdef doc_website
WriteINIStr "${startmenu}\Document.url" "InternetShortcut" "URL" ${doc_website}
!endif

!ifdef wiki_website
WriteINIStr "${startmenu}\Wiki.url" "InternetShortcut" "URL" ${wiki_website}
!endif
 
!ifdef notefile
ExecShell "open" "$INSTDIR\${notefile}"
!endif
 
SectionEnd
 
; Uninstaller
; All section names prefixed by "Un" will be in the uninstaller
 
UninstallText "This will uninstall ${prodname}."
 
!ifdef icon
UninstallIcon "${icon}"
!endif
 
Section "un.Uninstall"
 
  DeleteRegKey HKLM "${uninstkey}"
  DeleteRegKey HKLM "${regkey}"
 
  Delete "${startmenu}\*.*"
  Delete "${startmenu}"
 
!ifdef licensefile
Delete "$INSTDIR\${licensefile}"
!endif
 
!ifdef notefile
Delete "$INSTDIR\${notefile}"
!endif
 
!ifdef icon
Delete "$INSTDIR\icon-win.ico"
!endif
 
RmDir /r $INSTDIR
 
!ifdef unfiles
!include "${unfiles}"
!endif
 
SectionEnd
