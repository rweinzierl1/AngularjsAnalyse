; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "AngularJSAnalyse"
#define MyAppVersion "1.0"
#define MyAppURL "http://rweinzierl1.github.io/AngularjsAnalyse"
#define MyAppExeName "AngularAnalyse.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{F3947CC7-DAB8-46E9-A727-BC8300CFE394}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=C:\Freigabe\Lazarus\AngularAnalysegit\innoSetup\license.txt
OutputBaseFilename=setup
Compression=lzma
SolidCompression=yes
WizardImageFile=C:\Freigabe\Lazarus\AngularAnalysegit\innoSetup\SetupGross.bmp
WizardSmallImageFile=C:\Freigabe\Lazarus\AngularAnalysegit\innoSetup\SetupSmall.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Freigabe\Lazarus\AngularAnalysegit\AngularAnalyse.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Freigabe\Lazarus\AngularAnalysegit\Snippet\*"; DestDir: "{app}\Snippet\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Freigabe\Lazarus\AngularAnalysegit\ColorScheme\*"; DestDir: "{app}\ColorScheme\"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

