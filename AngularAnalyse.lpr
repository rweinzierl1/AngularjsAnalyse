program AngularAnalyse;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, frmMain, angPKZ, angFrmMainController, angKeyWords, angDatamodul,
  angfrmBookmarks, angFileList, angSnippet, angfrmSnippet, angFrmSelectSnippet,
  angFrmIntelligence, angPasteHistorie, angFrmClipboardHistorie, angfrmImage;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmMainView, frmMainView);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.

