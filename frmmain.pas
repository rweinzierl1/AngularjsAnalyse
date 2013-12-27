unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynHighlighterHTML, SynMemo, SynEdit,
  SynPluginSyncroEdit, SynHighlighterAny, SynHighlighterCss, Forms, Controls,
  SynEditMarks, strutils, SynEditTypes,
  Graphics, Dialogs, ComCtrls, Menus, ExtCtrls, StdCtrls, angPKZ,
  Clipbrd, ActnList, shellapi, SynEditMiscClasses, SynEditMarkupSpecialLine,
  angFrmMainController, angDatamodul, angKeyWords, angfrmBookmarks, angFileList, types,
  angSnippet, angfrmSnippet, angFrmSelectSnippet, SynCompletion, LCLType, SynEditKeyCmds,
  angFrmIntelligence,angFrmClipboardHistorie ;

type

  { TfrmMainView }

  TfrmMainView = class(TForm)
    acSelectDir: TAction;
    acOpenAFile: TAction;
    acSaveAll: TAction;
    acSynchronize: TAction;
    acAutosave: TAction;
    acFontLarger: TAction;
    acFontSmaller: TAction;
    ActionList1: TActionList;
    FindDialog1: TFindDialog;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    mnuPasteFromHistorie: TMenuItem;
    mnuCloseAllOthers: TMenuItem;
    mnuCloseWithoutSave: TMenuItem;
    mnuManageSnippet: TMenuItem;
    mnuCreateSnippet: TMenuItem;
    mnuSnippet: TMenuItem;
    mnuSearch1: TMenuItem;
    mnuAutosave: TMenuItem;
    mnuSmaller: TMenuItem;
    mnuLarger: TMenuItem;
    mnuFont: TMenuItem;
    mnuColorScheme: TMenuItem;
    mnuPreferences: TMenuItem;
    mnuOpenShell: TMenuItem;
    mnuResync: TMenuItem;
    mnuOpenMarkedFileName: TMenuItem;
    mnuShowInTree: TMenuItem;
    mnuOpenAFile: TMenuItem;
    mnuGotoLine: TMenuItem;
    mnuBookmarks: TMenuItem;
    mnuDJKeywords: TMenuItem;
    mnuSave1: TMenuItem;
    mnuSave: TMenuItem;
    mnuFind: TMenuItem;
    mnuCloseActivepage: TMenuItem;
    mnuFindNext: TMenuItem;
    mnuSearchPath: TMenuItem;
    mnuSearchBottom: TMenuItem;
    mnuSearchTop: TMenuItem;
    mnuSaveall: TMenuItem;
    mnuInfo: TMenuItem;
    mnuHelp: TMenuItem;
    mnuPathToClipboard: TMenuItem;
    mnuClose: TMenuItem;
    mnuPfadOeffnen: TMenuItem;
    mnuDatei: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    PopupMenuRecentPath: TPopupMenu;
    PopupMenuTreeview: TPopupMenu;
    PopupMenuSynedit: TPopupMenu;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    SynAnySyn1: TSynAnySyn;
    SynCssSyn1: TSynCssSyn;
    SynHTMLSyn1: TSynHTMLSyn;
    timerCloseIntelligence: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    TreeView1: TTreeView;
    procedure acAutosaveExecute(Sender: TObject);
    procedure acFontLargerExecute(Sender: TObject);
    procedure acOpenAFileExecute(Sender: TObject);
    procedure acSaveAllExecute(Sender: TObject);
    procedure acSelectDirExecute(Sender: TObject);
    procedure acSynchronizeExecute(Sender: TObject);
    procedure acFontSmallerExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
    procedure htmlPreviewClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure mnuAutosaveClick(Sender: TObject);
    procedure mnuBookMark1Click(Sender: TObject);
    procedure mnuBookmarksClick(Sender: TObject);
    procedure mnuCloseAllOthersClick(Sender: TObject);
    procedure mnuCloseWithoutSaveClick(Sender: TObject);
    procedure mnuColorSchemeClick(Sender: TObject);
    procedure mnuCreateSnippetClick(Sender: TObject);
    procedure mnuDJKeywordsClick(Sender: TObject);
    procedure mnuFindClick(Sender: TObject);
    procedure mnuCloseActivepageClick(Sender: TObject);
    procedure mnuFindNextClick(Sender: TObject);
    procedure mnuGotoLineClick(Sender: TObject);
    procedure mnuHelpClick(Sender: TObject);
    procedure mnuIntelligenceClick(Sender: TObject);
    procedure mnuManageSnippetClick(Sender: TObject);
    procedure mnuLargerClick(Sender: TObject);
    procedure mnuOpenAFileClick(Sender: TObject);
    procedure mnuOpenMarkedFileNameClick(Sender: TObject);
    procedure mnuOpenShellClick(Sender: TObject);
    procedure mnuPasteFromHistorieClick(Sender: TObject);
    procedure mnuPreferencesClick(Sender: TObject);
    procedure mnuResyncClick(Sender: TObject);
    procedure mnuSave1Click(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuSearchPathClick(Sender: TObject);
    procedure mnuSearchBottomClick(Sender: TObject);
    procedure mnuSearchTopClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure mnuDateiClick(Sender: TObject);
    procedure mnuInfoClick(Sender: TObject);
    procedure mnuPathToClipboardClick(Sender: TObject);
    procedure mnuPfadOeffnenClick(Sender: TObject);
    procedure mnuSaveallClick(Sender: TObject);
    procedure mnuShowInTreeClick(Sender: TObject);
    procedure mnuSmallerClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: boolean);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenuSyneditPopup(Sender: TObject);
    procedure timerCloseIntelligenceTimer(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    treenodeModule: TTreenode;
    treenodeController: TTreenode;
    treenodeService: TTreenode;
    treenodeFactory: TTreenode;
    treenodeFilter: TTreenode;
    treenodeHTML: TTreenode;
    treenodeAllFiles: TTreenode;
    treenodeDirectives: TTreenode;
    treenodeConfig: TTreenode;
    treenodeDependencyInjectionWords: TTreenode;
    treenodeAngularWords: TTreenode;
    treenodeSearchInPath: TTreenode;
    treenodeScope: TTreenode;
    treenodeScopeNurPunkt: TTreenode;
    treenodeScopeGleich: TTreenode;
    treenodeScopeGleichFunction: TTreenode;
    frmSelectSnippet: TfrmSelectSnippet;

    frmMainController: TFrmMainController;
    procedure AddAllRecentPathtoPopupmenu;
    procedure AddAngularJSKeyWordsInTreeview;
    procedure AddEditMarkToLine(iImageindex, iLine: integer);
    procedure AddSearchInPathToTree(const s: string);
    procedure AddTreenodeNgToNode(OneFileInfo: TOneFileInfo; treenode: TTreenode);
    procedure AddTreenodeScopeToNode(const OneFileInfo: TOneFileInfo;
      const treenode: TTreenode);
    procedure ChangeSchema(Sender: TObject);
    function CloseAllTabsheets: boolean;
    procedure DoCloseActivePagecontrolPage(boolSaveChanges: boolean);
    procedure DoRecentPathPM(Sender: TObject);
    procedure DoSaveActivePage;
    procedure InsertIntoSysMemoIntelligenceText;
    procedure IntelligenceItemSelected(Sender: TObject);
    procedure MarkLineContainsThisWord(sWord: string);
    procedure OpenIntelligenceDlg;
    function SearchTabsheetOrCreateNew(sMyFileName: string): boolean;
    procedure AddAngularJSFilesAsTreenode(myTreeNode: TTreenode;
      sl: TStringList; iImageindex: integer);
    procedure ReadPathToTreeview(myItemRoot: TTreenode; sPfad: string);
    procedure AddRootTreenodesToTreeview;
    procedure setAcAutosaveToUserProperty;
    procedure ShouldHTMLTagClosed;
    procedure ShowFileInPagecontrolAsTabsheet(const sPfad: string);
    procedure StartPathAnalyse;
    procedure SynCompletionCodeCompletion(var Value: string;
      SourceValue: string; var SourceStart, SourceEnd: TPoint;
      KeyChar: TUTF8Char; Shift: TShiftState);
    procedure SynCompletionDoExecute(Sender: TObject);
    procedure SynEdit1CutCopy(Sender: TObject; var AText: string;
      var AMode: TSynSelectionMode; ALogStartPos: TPoint;
      var AnAction: TSynCopyPasteAction);
    procedure SynEdit1Paste(Sender: TObject; var AText: string;
      var AMode: TSynSelectionMode; ALogStartPos: TPoint;
      var AnAction: TSynCopyPasteAction);
    procedure SynEditCommandProcessed(Sender: TObject;
      var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
    procedure SynEditPreviewDblClick(Sender: TObject);
    procedure SynEditPreviewSpecialLineMarkup(Sender: TObject;
      Line: integer; var Special: boolean; Markup: TSynSelectedColor);
    procedure SynEditProcessedCommand(Sender: TObject;
      var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
    procedure SynMemo1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure synmemoChange(Sender: TObject);
    procedure synmemoClick(Sender: TObject);
    procedure synmemoKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure IntelligenceFrmCloseAndFree;

  public
  end;

var
  frmMainView: TfrmMainView;

implementation

{$R *.lfm}

{ TfrmMainView }

procedure TfrmMainView.mnuDateiClick(Sender: TObject);
begin
  IntelligenceFrmCloseAndFree;
end;

procedure TfrmMainView.mnuInfoClick(Sender: TObject);
begin
  ShowMessage('Simple tool to anlyse AngularJS projekt stucture. ' +
    #13#10 + 'Freeware/ Open source' + #13#10 +
    'https://github.com/rweinzierl1/AngularjsAnalyse ' + #13#10 +
    'Developed by  Weinzierl Reinhold');
end;

procedure TfrmMainView.mnuPathToClipboardClick(Sender: TObject);
begin
  Clipboard.AsText := frmMainController.GetActiveFilePath;
end;

procedure TfrmMainView.ChangeSchema(Sender: TObject);
var
  mi: TMenuItem;
  i, n: integer;
  OneColorScheme: TOneColorScheme;
  OneTabsheet: TOneTabsheet;
begin
  mi := TMenuItem(Sender);


  frmMainController.UserPropertys.sSchema := mi.Caption;

  for i := 0 to mi.Parent.Count - 1 do
    mi.Parent.Items[i].Checked := False;


  for i := 0 to frmMainController.slColorScheme.Count - 1 do
  begin
    if mi.Caption = frmMainController.slColorScheme[i] then
    begin
      OneColorScheme := TOneColorScheme(frmMainController.slColorScheme.Objects[i]);
      frmMainController.slColorScheme.activeColorScheme := OneColorScheme;
      mi.Checked := True;

      for n := 0 to frmMainController.slOpendTabsheets.Count - 1 do
      begin
        OneTabsheet := frmMainController.slOpendTabsheets.OneTabsheet(n);
        OneTabsheet.setActiveColorScheme(OneColorScheme);

        self.Color := OneColorScheme.Color; //Avoid Blinking of Pagecontrol change

      end;
    end;
  end;
end;


procedure TfrmMainView.DoRecentPathPM(Sender: TObject);
var
  mi: TMenuItem;
begin

  if not CloseAllTabsheets then
    exit;

  mi := TMenuItem(Sender);
  frmMainController.sPfad := mi.Caption;
  StartPathAnalyse;
end;


procedure OnDeactivate1(Sender: TObject);
begin

end;

procedure TfrmMainView.IntelligenceFrmCloseAndFree;
begin

  if frmIntelligence <> nil then
  begin
    if not frmIntelligence.boolCallbackActive then
    begin
      frmIntelligence.Close;
      frmIntelligence.Free;
      frmIntelligence := nil;
    end;
  end;

end;

procedure TfrmMainView.FormCreate(Sender: TObject);
var
  i: integer;
  mi: TMenuItem;
begin
  frmMainController := TFrmMainController.Create;
  frmIntelligence := nil;


  for i := 0 to frmMainController.slColorScheme.Count - 1 do
  begin
    mi := TMenuItem.Create(mnuColorScheme);
    mnuColorScheme.Add(mi);
    mi.Caption := frmMainController.slColorScheme[i];
    mi.OnClick := @ChangeSchema;
    if mi.Caption = frmMainController.UserPropertys.sSchema then
      ChangeSchema(mi);

  end;

  AddAllRecentPathtoPopupmenu;
  setAcAutosaveToUserProperty;


  application.OnDeactivate := @FormDeactivate;

end;

procedure TfrmMainView.FormDeactivate(Sender: TObject);
begin
  if self.frmMainController.UserPropertys.boolAutoSave then
    frmMainController.SaveAll;

end;

procedure TfrmMainView.FindDialog1Find(Sender: TObject);
{var
  srOptions: TSynSearchOptions;  }

begin
  if frmMainController.myActiveOneTabsheet = nil then
    exit;

  if frmMainController.myActiveOneTabsheet.SynMemo = nil then
    exit;


  if pos(FindDialog1.FindText,
    frmMainController.myActiveOneTabsheet.SynMemo.Lines.Text) > 0 then
  begin
    frmMainController.sLastSearch := FindDialog1.FindText;
    frmMainController.myActiveOneTabsheet.SynMemo.SetFocus;
    MarkLineContainsThisWord(frmMainController.sLastSearch);
    FindDialog1.CloseDialog;
  end;




  {srOptions := [];

 SynEditTypes,

if not (frDown in FindDialog1.Options) then Include(srOptions,ssoBackwards);
if (frMatchCase in FindDialog1.Options) then Include(srOptions, ssoMatchCase);
if (frWholeWord in FindDialog1.Options) then Include(srOptions, ssoWholeWord);
if SynMemo1.SearchReplace('ooooo','',srOptions)=0 then  //AEdit ist die SynEdit-Komponente
begin
  SHowMessage('Yes');
end else
  SHowMessage('No');      }
end;

procedure TfrmMainView.Button1Click(Sender: TObject);
begin

end;

procedure TfrmMainView.acSelectDirExecute(Sender: TObject);
var
  chosenDirectory: string;
begin
  IntelligenceFrmCloseAndFree;
  if not CloseAllTabsheets then
    exit;


  if SelectDirectory('Select a directory', 'C:\', chosenDirectory) then
    if Uppercase(chosenDirectory) = 'C:\' then
    begin
      ShowMessage('C:\  ???');
    end
    else
    begin
      frmMainController.sPfad := chosenDirectory;
      StartPathAnalyse;
      AddAllRecentPathtoPopupmenu;
    end;
end;

procedure TfrmMainView.acSynchronizeExecute(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin
  IntelligenceFrmCloseAndFree;

  sl := TStringList.Create;
  sl.Text := frmMainController.slOpendTabsheets.Text;

  if not CloseAllTabsheets then
    exit;

  StartPathAnalyse;



  for i := 0 to sl.Count - 1 do
    if fileexists(sl[i]) then
      ShowFileInPagecontrolAsTabsheet(sl[i]);

  sl.Free;
end;

procedure TfrmMainView.acFontSmallerExecute(Sender: TObject);
begin
  IntelligenceFrmCloseAndFree;
  if frmMainController.UserPropertys.iFontsize > 1 then
  begin
    frmMainController.UserPropertys.iFontsize :=
      frmMainController.UserPropertys.iFontsize - 1;
    frmMainController.SetHeightToAllSynedit;
  end;

end;

procedure TfrmMainView.acOpenAFileExecute(Sender: TObject);
begin
  IntelligenceFrmCloseAndFree;
  Application.CreateForm(TfrmFileList, frmFileList);

  frmFileList.SynAnySyn1 := SynAnySyn1;
  frmFileList.SynCssSyn1 := SynCssSyn1;
  frmFileList.SynHTMLSyn1 := SynHTMLSyn1;

  frmFileList.Initialize(frmMainController);
  frmFileList.showmodal;
  if frmFileList.ModalResult = mrOk then
  begin
    ShowFileInPagecontrolAsTabsheet(frmMainController.sPfad + frmFileList.sFilename);
  end;
  frmFileList.Free;
end;

procedure TfrmMainView.acAutosaveExecute(Sender: TObject);
begin
  IntelligenceFrmCloseAndFree;
  self.frmMainController.UserPropertys.boolAutoSave :=
    not self.frmMainController.UserPropertys.boolAutoSave;

  setAcAutosaveToUserProperty;
end;

procedure TfrmMainView.acFontLargerExecute(Sender: TObject);
begin
  IntelligenceFrmCloseAndFree;
  frmMainController.UserPropertys.iFontsize :=
    frmMainController.UserPropertys.iFontsize + 1;
  frmMainController.SetHeightToAllSynedit;
end;

procedure TfrmMainView.acSaveAllExecute(Sender: TObject);
begin
  IntelligenceFrmCloseAndFree;
  frmMainController.SaveAll;
end;

procedure TfrmMainView.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  iAnswer: integer;
begin
  if frmMainController.UserPropertys.boolAutoSave then
  begin
    frmMainController.SaveAll;
    exit;
  end;


  if frmMainController.SynMemoModifiedAvailable then
  begin
    iAnswer := MessageDlg('Save changes', mtConfirmation, [mbYes, mbNo, mbAbort], 0);
    if iAnswer = mrAbort then
      CanClose := False;
    if iAnswer = mrYes then
      frmMainController.SaveAll;
  end;

end;

procedure TfrmMainView.FormDestroy(Sender: TObject);
begin
  frmMainController.Free;
  IntelligenceFrmCloseAndFree;
end;

procedure TfrmMainView.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
begin

end;

procedure TfrmMainView.htmlPreviewClick(Sender: TObject);
begin

end;

procedure TfrmMainView.MenuItem1Click(Sender: TObject);
begin
  IntelligenceFrmCloseAndFree;
end;

procedure TfrmMainView.MenuItem2Click(Sender: TObject);
begin
end;

procedure TfrmMainView.MenuItem3Click(Sender: TObject);
begin

end;

procedure TfrmMainView.mnuAutosaveClick(Sender: TObject);
begin

end;

procedure TfrmMainView.mnuBookMark1Click(Sender: TObject);
begin
end;

procedure TfrmMainView.mnuBookmarksClick(Sender: TObject);
var
  obm: TOneBookMark;
  mys: Tsynmemo;
  i: integer;
begin
  Application.CreateForm(TfrmBookmarks, frmBookmarks);

  frmBookmarks.Initialize(frmMainController);



  frmBookmarks.showmodal;
  if frmBookmarks.ModalResult = mrOk then
  begin

    if frmBookmarks.iKeyPressed >= 0 then
      frmMainController.myActiveOneTabsheet.SynMemo.SetBookMark(
        frmBookmarks.iKeyPressed, frmMainController.myActiveOneTabsheet.SynMemo.CaretX,
        frmMainController.myActiveOneTabsheet.SynMemo.CaretY)
    else
    if frmBookmarks.obmMarked <> nil then
    begin
      frmMainController.SetTabsheetAktivForFile(frmBookmarks.obmMarked.sFileName);
      self.PageControl1.ActivePage := frmMainController.myActiveOneTabsheet.Tabsheet;
      frmMainController.myActiveOneTabsheet.SynMemo.GotoBookMark(
        frmBookmarks.obmMarked.iBookmarkNr);
    end;

    for i := 0 to frmBookmarks.ListView1.Items.Count - 1 do
    begin
      if not frmBookmarks.ListView1.Items[i].Checked then
      begin
        obm := TOneBookMark(frmBookmarks.ListView1.Items[i].Data);
        mys := frmMainController.GetSynMemoForFile(obm.sFileName);
        mys.ClearBookMark(obm.iBookmarkNr);

      end;

    end;

  end;

  frmBookmarks.Free;
end;

procedure TfrmMainView.mnuCloseAllOthersClick(Sender: TObject);
var myTab : TTabsheet;
i : integer;
begin

  myTab := self.PageControl1.ActivePage;

for i := self.PageControl1.PageCount -1 downto 0 do
  begin
  if self.PageControl1.Pages[i] <>myTab then
    begin
    self.PageControl1.ActivePageIndex:=i;
    DoCloseActivePagecontrolPage(True);

    end;


  end;
end;

procedure TfrmMainView.mnuCloseWithoutSaveClick(Sender: TObject);
begin
  DoCloseActivePagecontrolPage(False);
end;

procedure TfrmMainView.mnuColorSchemeClick(Sender: TObject);
begin

end;

procedure TfrmMainView.mnuCreateSnippetClick(Sender: TObject);
var
  frmSnippet: TfrmSnippet;
  AngSnippet: TAngSnippet;
  i: integer;
begin
  frmSnippet := TfrmSnippet.Create(self);

  AngSnippet := TAngSnippet.Create;
  AngSnippet.sContent := self.frmMainController.myActiveOneTabsheet.SynMemo.SelText;


  AngSnippet.MakeShortcutFromSContent();

  i := self.frmMainController.CalculateIndexOfFileExtension(
    self.frmMainController.myActiveOneTabsheet.sFilename);

  case i of
    constItemIndexHTML: AngSnippet.ForFileType := snippetFileHTML;
    constItemIndexCss: AngSnippet.ForFileType := snippetFileCSS;
    constItemIndexJavascript: AngSnippet.ForFileType := snippetFileJS;
    else
      AngSnippet.ForFileType := snippetFileALL;
  end;




  frmSnippet.ShowSnippet(AngSnippet);

  frmSnippet.showmodal;

  if frmSnippet.ModalResult = mrOk then
  begin
    AngSnippet.MakeFilenameFromShortcut(frmMainController.sPfad);
    AngSnippet.SaveToFile();

    self.frmMainController.AngIntellisence.AngSnippetList.AddObject(AngSnippet.sShortcut, AngSnippet);

  end
  else
    AngSnippet.Free;


  frmSnippet.Free;

end;



procedure TfrmMainView.mnuDJKeywordsClick(Sender: TObject);
begin
  Application.CreateForm(TfrmSelectKeywords, frmSelectKeywordsObj);
  frmSelectKeywordsObj.Initialize(frmMainController, SynAnySyn1);
  frmSelectKeywordsObj.showmodal;
  if frmSelectKeywordsObj.ModalResult = mrOk then
  begin
    frmMainController.myActiveOneTabsheet.SynMemo.InsertTextAtCaret(
      frmSelectKeywordsObj.GetSelectedKeyWords);
  end;
  frmSelectKeywordsObj.Free;
end;

procedure TfrmMainView.mnuFindClick(Sender: TObject);
begin
  if frmMainController.myActiveOneTabsheet.SynMemo = nil then
    exit;

  if FindDialog1.Execute then
  begin

  end;

end;

procedure TfrmMainView.mnuCloseActivepageClick(Sender: TObject);
begin
  DoCloseActivePagecontrolPage(True);
end;

procedure TfrmMainView.mnuFindNextClick(Sender: TObject);
var
  mySyn: TsynMemo;
  i, iPos: integer;
  point: TPoint;
begin
  mySyn := frmMainController.myActiveOneTabsheet.SynMemo;


  for i := mySyn.CaretY to mySyn.Lines.Count - 1 do
  begin
    iPos := pos(frmMainController.sLastSearch, mySyn.Lines[i]);
    if iPos > 0 then
    begin
      point.y := i + 1;
      point.X := iPos;
      mySyn.LogicalCaretXY := point;
      mySyn.SelectWord;
      break;
    end;
  end;
end;

procedure TfrmMainView.mnuGotoLineClick(Sender: TObject);
var
  s: string;
  i: integer;
begin
  if inputquery('Line Nr', 'Line Nr', s) then
  begin
    i := strtointdef(s, -1);
    if i <> -1 then
      self.frmMainController.myActiveOneTabsheet.SynMemo.CaretY := i;

  end;

end;

procedure TfrmMainView.mnuHelpClick(Sender: TObject);
begin
  IntelligenceFrmCloseAndFree;
end;

procedure TfrmMainView.InsertIntoSysMemoIntelligenceText;
var
  mySyn: TSynMemo;
  s: string;
begin
  mySyn := self.frmMainController.myActiveOneTabsheet.SynMemo;

  s := frmIntelligence.sSelText;

  Delete(s, 1, length(frmIntelligence.sFilter));


  mySyn.InsertTextAtCaret(s);


  if s <> '' then
    if s[Length(s)] = '>' then
      ShouldHTMLTagClosed;

end;

procedure TfrmMainView.IntelligenceItemSelected(Sender: TObject);
begin
  InsertIntoSysMemoIntelligenceText;
  timerCloseIntelligence.Enabled := True;

end;

procedure TfrmMainView.mnuIntelligenceClick(Sender: TObject);
begin

end;



procedure TfrmMainView.OpenIntelligenceDlg;
begin
  frmIntelligence := TfrmIntelligence.Create(self);

  frmIntelligence.Top := self.top + 100;
  frmIntelligence.Left := self.Left;


  //todo make this better
  frmIntelligence.Left := frmIntelligence.Left + TreeView1.Width +
    self.frmMainController.myActiveOneTabsheet.SynMemo.CaretXPix;
  frmIntelligence.top := frmIntelligence.Top + ToolBar1.Height +
    self.frmMainController.myActiveOneTabsheet.SynMemo.CaretyPix;

  frmIntelligence.OnIntelligenceItemSelected := @IntelligenceItemSelected;

  frmIntelligence.Show;

  self.frmMainController.myActiveOneTabsheet.SynMemo.SetFocus;

end;


procedure TfrmMainView.mnuManageSnippetClick(Sender: TObject);

begin
  frmSelectSnippet := TfrmSelectSnippet.Create(self);

  frmSelectSnippet.ShowSnippingList(self.frmMainController.AngIntellisence.AngSnippetList);
  frmSelectSnippet.Showmodal;

  if frmSelectSnippet.modalresult = mrOk then
    if frmSelectSnippet.booltake then
      frmMainController.myActiveOneTabsheet.SynMemo.InsertTextAtCaret(
        frmSelectSnippet.sContent);

  frmSelectSnippet.Free;

end;

procedure TfrmMainView.mnuLargerClick(Sender: TObject);
begin

end;

procedure TfrmMainView.mnuOpenAFileClick(Sender: TObject);
begin

end;

procedure TfrmMainView.mnuOpenMarkedFileNameClick(Sender: TObject);
var
  s, sFilename: string;
begin
  s := frmMainController.myActiveOneTabsheet.SynMemo.SelText;
  sFilename := frmMainController.GetFileNameToPartFileName(s);
  if sFilename <> '' then
    ShowFileInPagecontrolAsTabsheet(sFilename);

end;

procedure TfrmMainView.mnuOpenShellClick(Sender: TObject);
var
  treenode: TTreenode;
  sPfad: string;
  //parentNode: TTreenode;
  s: string;
begin

  treenode := TreeView1.Selected;
  if treenode = nil then
    exit;


  if treenode = treenodeSearchInPath then
    exit;

  if treenode.Data = nil then
    exit;

  sPfad := frmMainController.findFileNameToDataPointer(TObject(treenode.Data));

  sPfad := extractfilepath(sPfad);


  ShellExecute(0, 'open', PChar(sPfad), nil, nil, 5);  //5 =  SW_SHOW

end;

procedure TfrmMainView.mnuPasteFromHistorieClick(Sender: TObject);
begin
  frmPasteHistorie := TfrmPasteHistorie.create(self);
  frmPasteHistorie.FillListbox(self.frmMainController.AngClipboardHistorieList );

  frmPasteHistorie.ShowModal;
  if frmPasteHistorie.ModalResult = mrOK then
    self.frmMainController.myActiveOneTabsheet.SynMemo.InsertTextAtCaret(frmPasteHistorie.Memo1.Text ) ;
  frmPasteHistorie.free;
end;

procedure TfrmMainView.mnuPreferencesClick(Sender: TObject);
begin
  IntelligenceFrmCloseAndFree;
end;

procedure TfrmMainView.mnuResyncClick(Sender: TObject);
begin
end;

procedure TfrmMainView.mnuSave1Click(Sender: TObject);
begin
  DoSaveActivePage;
end;

procedure TfrmMainView.DoSaveActivePage;
var
  i: integer;
  myOneTabsheet: TOneTabsheet;
begin
  if pagecontrol1.PageCount = 0 then
    exit;


  for i := 0 to frmMainController.slOpendTabsheets.Count - 1 do
  begin
    myOneTabsheet := frmMainController.slOpendTabsheets.OneTabsheet(i);
    if Pagecontrol1.ActivePage = myOneTabsheet.Tabsheet then
    begin
      if myOneTabsheet.SynMemo.Modified then
      begin
        myOneTabsheet.SynMemo.Lines.SaveToFile(
          frmMainController.slOpendTabsheets[i]);
        myOneTabsheet.SynMemo.Modified := False;
      end;
    end;
  end;
end;

procedure TfrmMainView.mnuSaveClick(Sender: TObject);
begin
  DoSaveActivePage;
end;

procedure TfrmMainView.mnuSearchPathClick(Sender: TObject);
var
  mySyn: TsynMemo;
  s: string;
  point: TPoint;
begin
  mySyn := frmMainController.myActiveOneTabsheet.SynMemo;
  s := mySyn.SelText;

  if s = '' then
  begin
    point := mySyn.LogicalCaretXY;
    s := trim(mySyn.GetWordAtRowCol(point));
  end;

  if s <> '' then
  begin
    AddSearchInPathToTree(s);
  end;

end;

procedure TfrmMainView.mnuSearchBottomClick(Sender: TObject);
var
  mySyn: TsynMemo;
  s: string;
  point: TPoint;
  i, iPos: integer;
begin
  mySyn := frmMainController.myActiveOneTabsheet.SynMemo;
  point := mySyn.LogicalCaretXY;
  s := trim(mySyn.GetWordAtRowCol(point));

  for i := mySyn.CaretY to mySyn.Lines.Count - 1 do
  begin
    iPos := frmMainController.PostitionOfTextInText(s, mySyn.Lines[i]);

    if iPos > 0 then
    begin
      point.y := i + 1;
      point.x := iPos;
      mySyn.LogicalCaretXY := point;
      break;
    end;
  end;

end;

procedure TfrmMainView.mnuSearchTopClick(Sender: TObject);
var
  mySyn: TsynMemo;
  s: string;
  point: TPoint;
  i, iPos: integer;
begin
  mySyn := frmMainController.myActiveOneTabsheet.SynMemo;
  point := mySyn.LogicalCaretXY;
  s := trim(mySyn.GetWordAtRowCol(point));

  for i := mySyn.CaretY - 2 downto 0 do
  begin
    iPos := frmMainController.PostitionOfTextInText(s, mySyn.Lines[i]);

    if iPos > 0 then
    begin
      point.y := i + 1;
      point.x := iPos;
      mySyn.LogicalCaretXY := point;
      break;
    end;
  end;

end;

procedure TfrmMainView.mnuCloseClick(Sender: TObject);
begin
  DoCloseActivePagecontrolPage(True);
end;

procedure TfrmMainView.DoCloseActivePagecontrolPage(boolSaveChanges: boolean);
var
  i, iAnswer: integer;
  myOneTabsheet: TOneTabsheet;
  myTabsheet: TTabSheet;
begin
  if pagecontrol1.PageCount = 0 then
    exit;

  if boolSaveChanges then
    if self.frmMainController.UserPropertys.boolAutoSave then
      frmMainController.SaveAll;


  for i := 0 to frmMainController.slOpendTabsheets.Count - 1 do
  begin
    myOneTabsheet := frmMainController.slOpendTabsheets.OneTabsheet(i);
    if Pagecontrol1.ActivePage = myOneTabsheet.Tabsheet then
    begin
      if boolSaveChanges then
        if myOneTabsheet.SynMemo.Modified then
        begin
          iAnswer := MessageDlg('Save changes', mtConfirmation,
            [mbYes, mbNo, mbAbort], 0);
          if iAnswer = mrAbort then
            exit;

          if iAnswer = mrYes then
          begin
            myOneTabsheet.SynMemo.Lines.SaveToFile(
              frmMainController.slOpendTabsheets[i]);
            myOneTabsheet.SynMemo.Modified := False;
          end;
        end;

      frmMainController.slOpendTabsheets.Delete(i);
      break;
    end;
  end;
  myTabsheet := Pagecontrol1.ActivePage;

  if Pagecontrol1.ActivePage.TabIndex > 0 then    //avoid white blinking
  begin
    Pagecontrol1.ActivePageIndex := Pagecontrol1.ActivePage.TabIndex - 1;
  end;

  myTabsheet.Free;
end;




procedure TfrmMainView.AddRootTreenodesToTreeview;
begin
  TreeView1.Items.Clear;


  treenodeModule := TreeView1.Items.AddChild(nil, 'angular.module');
  treenodeModule.ImageIndex := constItemIndexModule;
  treenodeController := TreeView1.Items.AddChild(nil, '.controller');
  treenodeController.ImageIndex := constItemIndexController;
  treenodeService := TreeView1.Items.AddChild(nil, '.service');
  treenodeService.ImageIndex := constItemIndexService;
  treenodeFactory := TreeView1.Items.AddChild(nil, '.factory');
  treenodeFactory.ImageIndex := constItemIndexFactory;
  treenodeFilter := TreeView1.Items.AddChild(nil, '.filter');
  treenodeFilter.ImageIndex := constItemIndexFilter;
  treenodeDirectives := TreeView1.Items.AddChild(nil, '.directive');
  treenodeDirectives.ImageIndex := constItemIndexDirective;
  treenodeConfig := TreeView1.Items.AddChild(nil, '.config');
  treenodeConfig.ImageIndex := constItemIndexConfig;

  treenodeHTML := TreeView1.Items.AddChild(nil, 'HTML');
  treenodeHTML.ImageIndex := constItemIndexHTML;


  treenodeDependencyInjectionWords :=
    TreeView1.Items.AddChild(nil, 'Dependency Injection Key Words');
  treenodeDependencyInjectionWords.ImageIndex := constItemIndexKey;


  treenodeAngularWords := TreeView1.Items.AddChild(nil, 'AngularJS Keywords');
  treenodeAngularWords.ImageIndex := constItemIndexAngular;



  treenodeScope := TreeView1.Items.AddChild(nil, 'scope.');
  treenodeScope.ImageIndex := constItemScope;

  treenodeScopeGleichFunction :=
    TreeView1.Items.AddChild(treenodeScope, 'scope. = function');
  treenodeScopeGleichFunction.ImageIndex := constItemScope;

  treenodeScopeGleich := TreeView1.Items.AddChild(treenodeScope, 'scope. =');
  treenodeScopeGleich.ImageIndex := constItemScope;

  treenodeScopeNurPunkt := TreeView1.Items.AddChild(treenodeScope, 'scope.');
  treenodeScopeNurPunkt.ImageIndex := constItemScope;


  treenodeAllFiles := TreeView1.Items.AddChild(nil, 'All Files');
  treenodeAllFiles.ImageIndex := constItemIndexFolder;

  treenodeSearchInPath := TreeView1.Items.AddChild(nil, 'Search In Path (dblClick)');
  treenodeSearchInPath.ImageIndex := constItemIndexSearchInPath;

end;

procedure TfrmMainView.setAcAutosaveToUserProperty;
begin
  acAutosave.Checked := self.frmMainController.UserPropertys.boolAutoSave;
  if acAutosave.Checked then
    acAutosave.Caption := 'Autosave is on'
  else
    acAutosave.Caption := 'Autosave is off';
  acAutosave.Hint := acAutosave.Caption;
end;

procedure TfrmMainView.ShowFileInPagecontrolAsTabsheet(const sPfad: string);
begin
  if SearchTabsheetOrCreateNew(sPfad) then
  begin
    if pos('.HTM', uppercase(sPfad)) > 0 then
      frmMainController.myActiveOneTabsheet.SynMemo.Highlighter := SynHTMLSyn1
    else
    if pos('.CSS', uppercase(sPfad)) > 0 then
      frmMainController.myActiveOneTabsheet.SynMemo.Highlighter := SynCssSyn1
    else
    begin
      frmMainController.myActiveOneTabsheet.SynMemo.Highlighter := SynAnySyn1;
      if pos('.JS', uppercase(sPfad)) > 0 then
      begin
        {
        SynAnySyn1.KeyWords.Clear;
        SynAnySyn1.KeyWords.add('ANGULAR');          }
        frmMainController.myActiveOneTabsheet.SynMemo.Refresh;
      end;
    end;

    frmMainController.myActiveOneTabsheet.Tabsheet.Caption := extractfilename(sPfad);
    frmMainController.myActiveOneTabsheet.SynMemo.Lines.LoadFromFile(sPfad);

    frmMainController.myActiveOneTabsheet.setPreviewText;
  end;
end;

procedure TfrmMainView.AddAngularJSKeyWordsInTreeview;
var
  sl: TStringList;
  i: integer;
  treenodeAngularSchluessel: TTreenode;
begin
  sl := TStringList.Create;
  sl.add('$apply');
  sl.add('$scope.');
  sl.add('$watch');
  sl.add('$emit');
  sl.add('$broadcast');
  sl.add('.bind');
  sl.add('.$on');

  for i := 0 to sl.Count - 1 do
  begin
    treenodeAngularSchluessel :=
      TreeView1.Items.AddChild(treenodeAngularWords, sl[i]);
    treenodeAngularSchluessel.ImageIndex := constItemIndexAngular;

  end;

  sl.Clear;
  sl.Sorted := True;
  sl.Duplicates := dupIgnore;
  frmMainController.GetAllUsedNgKeyWords(sl);

  for i := 0 to sl.Count - 1 do
  begin
    treenodeAngularSchluessel :=
      TreeView1.Items.AddChild(treenodeAngularWords, sl[i]);
    treenodeAngularSchluessel.ImageIndex := constItemIndexAngular;

  end;


  sl.Free;
end;

procedure TfrmMainView.AddAllRecentPathtoPopupmenu;
var
  mi: TMenuItem;
  i: integer;
begin
  PopupMenuRecentPath.Items.Clear;
  for i := 0 to frmMainController.UserPropertys.slRecentPath.Count - 1 do
  begin
    mi := TMenuItem.Create(PopupMenuRecentPath);
    PopupMenuRecentPath.Items.Add(mi);
    mi.Caption := frmMainController.UserPropertys.slRecentPath[i];
    mi.OnClick := @DoRecentPathPM;
  end;

end;


procedure TfrmMainView.mnuPfadOeffnenClick(Sender: TObject);
begin

end;

procedure TfrmMainView.mnuSaveallClick(Sender: TObject);
begin

end;

procedure TfrmMainView.mnuShowInTreeClick(Sender: TObject);
var
  i: integer;
  myOneTabsheet: TOneTabsheet;
  p: TObject;
begin
  if pagecontrol1.PageCount = 0 then
    exit;

  Treeview1.FullCollapse;


  for i := 0 to frmMainController.slOpendTabsheets.Count - 1 do
  begin
    myOneTabsheet := frmMainController.slOpendTabsheets.OneTabsheet(i);
    if Pagecontrol1.ActivePage = myOneTabsheet.Tabsheet then
    begin
      p := frmMainController.FindTreenodePointerToFilename(
        frmMainController.slOpendTabsheets[i]);

      Treeview1.Selected := TTreenode(p);

      treeview1.Selected.ExpandParents;

    end;
  end;

end;

procedure TfrmMainView.mnuSmallerClick(Sender: TObject);
begin

end;

procedure TfrmMainView.PageControl1Change(Sender: TObject);
begin
  PageControl1.Visible := True;
  if PageControl1.ActivePage = nil then
  begin
    frmMainController.myActiveOneTabsheet.Tabsheet := nil;
    frmMainController.myActiveOneTabsheet.SynMemo := nil;
  end
  else
    frmMainController.SetActiveTabsheet(PageControl1.ActivePage);
end;

procedure TfrmMainView.PageControl1Changing(Sender: TObject; var AllowChange: boolean);
begin
  IntelligenceFrmCloseAndFree;
  PageControl1.Visible := False;  //avoid blinking
end;

procedure TfrmMainView.PopupMenu1Popup(Sender: TObject);
begin

  if self.frmMainController.UserPropertys.boolAutoSave then
    mnuCloseWithoutSave.Visible := True;

end;

procedure TfrmMainView.PopupMenuSyneditPopup(Sender: TObject);
var
  s: string;
begin
  mnuOpenMarkedFileName.Visible := False;
  mnuCreateSnippet.Visible := False;


  s := frmMainController.myActiveOneTabsheet.SynMemo.SelText;
  if length(s) > 3 then
  begin
    if frmMainController.GetFileNameToPartFileName(s) <> '' then
      mnuOpenMarkedFileName.Visible := True;
  end;


  if length(s) > 10 then
  begin
    mnuCreateSnippet.Visible := True;
  end;

end;

procedure TfrmMainView.timerCloseIntelligenceTimer(Sender: TObject);
begin
  timerCloseIntelligence.Enabled := False;
  IntelligenceFrmCloseAndFree;

end;



procedure TfrmMainView.AddAngularJSFilesAsTreenode(myTreeNode: TTreenode;
  sl: TStringList; iImageindex: integer);
var
  i, i2, n,iIdx: integer;
  treenode, treenodeDISchluessel: TTreenode;
  OneFileInfo: TOneFileInfo;
  treenodeFilestructure: TTreenode;
  sFilename: string;
begin

  for i := 0 to sl.Count - 1 do
  begin
    treenode := TreeView1.Items.AddChild(myTreeNode, sl[i]);
    treenode.ImageIndex := iImageindex;
    treenode.Data := sl.Objects[i];


    OneFileInfo := TOneFileInfo(treenode.Data);


    treenodeFilestructure := TTreenode(OneFileInfo.pTreenodeInView);

    sFilename := frmMainController.findFileNameToDataPointer(
      OneFileInfo.pTreenodeInView);
    i2 := frmMainController.GetImageindexForFileIfItContainsOnlyTheSameType(sFilename);
    if i2 <> -1 then
      treenodeFilestructure.ImageIndex := i2;


    if OneFileInfo <> nil then
    begin
      for n := 0 to OneFileInfo.slDependencyInjektionNamen.Count - 1 do
      begin
        iIdx := integer(OneFileInfo.slDependencyInjektionNamen.Objects[n] );

        treenodeDISchluessel :=
          TreeView1.Items.AddChild(treenode, OneFileInfo.slDependencyInjektionNamen[n]);
        treenodeDISchluessel.ImageIndex := iIdx;

        treenodeDISchluessel :=
          TreeView1.Items.AddChild(treenodeFilestructure,
          OneFileInfo.slDependencyInjektionNamen[n]);
        treenodeDISchluessel.ImageIndex := iIdx;

      end;


      if OneFileInfo.slngLines.Count > 0 then
      begin
        AddTreenodeNgToNode(OneFileInfo, treenode);
        AddTreenodeNgToNode(OneFileInfo, treenodeFilestructure);
      end;


      if OneFileInfo.slScopeActions.Count > 0 then
      begin
        AddTreenodeScopeToNode(OneFileInfo, treenode);
        AddTreenodeScopeToNode(OneFileInfo, treenodeFilestructure);
      end;

    end;
  end;

end;




procedure TfrmMainView.StartPathAnalyse;
var
  i, i1, i2, i3: integer;
  sl: TStringList;
  treenode: TTreenode;
begin
  //mnuOpenAFile.Enabled := True;
  acOpenAFile.Enabled := True;
  self.acSaveAll.Enabled := True;
  self.acSynchronize.Enabled := True;


  AddRootTreenodesToTreeview;
  frmMainController.ClearAll;

  statusbar1.Panels[0].Text := frmMainController.sPfad;
  TreeView1.BeginUpdate;
  ReadPathToTreeview(treenodeAllFiles, frmMainController.sPfad);

  AddAngularJSFilesAsTreenode(treenodeConfig, frmMainController.slConfig,
    constItemIndexConfig);
  AddAngularJSFilesAsTreenode(treenodeModule, frmMainController.slModule,
    constItemIndexModule);
  AddAngularJSFilesAsTreenode(treenodeController, frmMainController.slController,
    constItemIndexController);
  AddAngularJSFilesAsTreenode(treenodeService, frmMainController.slService,
    constItemIndexService);
  AddAngularJSFilesAsTreenode(treenodeFactory, frmMainController.slFactory,
    constItemIndexFactory);
  AddAngularJSFilesAsTreenode(treenodeDirectives, frmMainController.slDirective,
    constItemIndexDirective);
  AddAngularJSFilesAsTreenode(treenodeFilter, frmMainController.slFilter,
    constItemIndexFilter);

  sl := TStringList.Create;
  frmMainController.GetAllHtmlFiles(sl);
  AddAngularJSFilesAsTreenode(treenodeHTML, sl, constItemIndexHTML);

  sl.Free;



  SynAnySyn1.Constants.Clear;

  sl := frmMainController.GetslDJKeyWords;
  for i := 0 to sl.Count - 1 do
  begin
    treenode := TreeView1.Items.AddChild(treenodeDependencyInjectionWords, sl[i]);
    treenode.ImageIndex := integer(sl.Objects[i]);

    SynAnySyn1.Constants.add(uppercase(sl[i]));
  end;


  sl := frmMainController.GetslAllScope;
  for i := 0 to sl.Count - 1 do
  begin
    i1 := pos('scope', sl[i]);
    i2 := pos('=', sl[i]);
    i3 := pos('function', sl[i]);




    if (i2 > 0) and (i3 > 0) and (i3 > i2) and (i2 > i1) then
    begin
      treenode := TreeView1.Items.AddChild(treenodeScopeGleichFunction, sl[i]);
      treenode.ImageIndex := constItemScope;
    end
    else
    begin
      if (i2 > 0) and (i2 > i1) then
      begin
        treenode := TreeView1.Items.AddChild(treenodeScopeGleich, sl[i]);
        treenode.ImageIndex := constItemScope;
      end
      else
      begin
        treenode := TreeView1.Items.AddChild(treenodeScopeNurPunkt, sl[i]);
        treenode.ImageIndex := constItemScope;
      end;
    end;

  end;

  AddAngularJSKeyWordsInTreeview;


  TreeView1.EndUpdate;

  mnuFind.Enabled := True;


  self.frmMainController.AddAllProjectWordsToIntellisence;

end;




procedure TfrmMainView.ToolButton1Click(Sender: TObject);
begin

end;

procedure TfrmMainView.ToolButton2Click(Sender: TObject);
begin

end;

procedure TfrmMainView.ToolButton3Click(Sender: TObject);
begin

end;

procedure TfrmMainView.ToolButton4Click(Sender: TObject);
begin

end;

procedure TfrmMainView.ToolButton5Click(Sender: TObject);
begin
end;

procedure TfrmMainView.ToolButton9Click(Sender: TObject);
begin

end;

procedure TfrmMainView.SynEditPreviewSpecialLineMarkup(Sender: TObject;
  Line: integer; var Special: boolean; Markup: TSynSelectedColor);
var
  SynMemo: TSynMemo;
  SynPreview: TSynMemo;
  //sSel : string;
  //i : integer;
begin

  SynMemo := frmMainController.myActiveOneTabsheet.SynMemo;
  if SynMemo.CaretY = line then
  begin
    Markup.Background := clred;
    Special := True;
  end
  else
  begin
    if (line >= SynMemo.TopLine) and (line <= SynMemo.TopLine +
      SynMemo.LinesInWindow) then
    begin
      Markup.Background := clGray;
      Special := True;
    end;
  end;


{ sSel := SynMemo.SelText;

 if length(sSel) > 2 then
   begin
   SynPreview := TSynMemo(Sender);
   i := pos(sSel,SynPreview.lines[line]);
   if i > 0 then
     begin
     Markup.StartX:=i;
     Markup.EndX  := i + length(sSel);
     Markup.Background := clOlive ;
     //Special := True;
     end;

   end;   }

end;



procedure TfrmMainView.synmemoChange(Sender: TObject);
begin
  frmMainController.myActiveOneTabsheet.setPreviewText;
end;

procedure TfrmMainView.synmemoClick(Sender: TObject);
begin

  IntelligenceFrmCloseAndFree;
end;


procedure TfrmMainView.synmemoKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin

end;

procedure TfrmMainView.SynEditPreviewDblClick(Sender: TObject);
var
  i: integer;
begin
  frmMainController.myActiveOneTabsheet.setCarentFromPreviewToEdit;

  frmMainController.DeleteAllMarksWithIndexIndexMarkFound;

  i := TSynmemo(Sender).CaretY;
  AddEditMarkToLine(constItemIndexMarkFound, i);
end;

procedure TfrmMainView.SynMemo1StatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
var
  ms: TSynmemo;
begin

  if scTopLine in changes then
  begin
    frmMainController.myActiveOneTabsheet.InfoToPreviewForToplineChanged;
  end;

  if scCaretY in changes then
  begin
    frmMainController.myActiveOneTabsheet.setCarentFromEditToPreview;
  end;

  if scSelection in changes then
  begin
    frmMainController.myActiveOneTabsheet.InfoToPreviewSelectionChanged;
  end;

end;


procedure TfrmMainView.SynCompletionDoExecute(Sender: TObject);
var
  SynCompletion: TSynCompletion;
  i, i2: integer;
  AngSnippet: TAngSnippet;
  myForFiletype: TSnippetForFiletype;
begin
  SynCompletion := TSynCompletion(Sender);

  i2 := self.frmMainController.CalculateIndexOfFileExtension(
    self.frmMainController.myActiveOneTabsheet.sFilename);

  case i2 of
    constItemIndexHTML: myForFiletype := snippetFileHTML;
    constItemIndexCss: myForFiletype := snippetFileCSS;
    constItemIndexJavascript: myForFiletype := snippetFileJS;
    else
      myForFiletype := snippetFileALL;
  end;


  SynCompletion.ItemList.Clear;

  for i := 0 to self.frmMainController.AngIntellisence.AngSnippetList.Count - 1 do
  begin
    AngSnippet := self.frmMainController.AngIntellisence.AngSnippetList.AngSnippet(i);
    if pos(SynCompletion.CurrentString, AngSnippet.sShortcut) = 1 then
      if AngSnippet.ForFileTypeOK(myForFiletype) then
        SynCompletion.ItemList.Add(AngSnippet.sShortcut);
  end;


  if SynCompletion.ItemList.Count = 0 then
    self.frmMainController.myActiveOneTabsheet.SynMemo.InsertTextAtCaret(#9);
end;

procedure TfrmMainView.SynCompletionCodeCompletion(var Value: string;
  SourceValue: string; var SourceStart, SourceEnd: TPoint; KeyChar: TUTF8Char;
  Shift: TShiftState);
var
  AngSnippet: TAngSnippet;
  i: integer;
begin

  for i := 0 to self.frmMainController.AngIntellisence.AngSnippetList.Count - 1 do
  begin
    AngSnippet := self.frmMainController.AngIntellisence.AngSnippetList.AngSnippet(i);
    if Value = AngSnippet.sShortcut then
    begin
      Value := AngSnippet.sContent;

    end;
  end;

end;

procedure TfrmMainView.SynEditProcessedCommand(Sender: TObject;
  var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
begin

  if (AChar = #27) or (Command in [2, 3, 5]) then   //ESC or left key ...
    IntelligenceFrmCloseAndFree;

  if Command = 509 then //Enter
    if frmIntelligence <> nil then
      if frmIntelligence.Visible then
      begin
        frmIntelligence.SetSelTextToPublic;
        InsertIntoSysMemoIntelligenceText;
        IntelligenceFrmCloseAndFree;
        Command := 0;
      end;

  if Command = 4 then  //key down   ???
  begin
    if frmIntelligence <> nil then
      if frmIntelligence.Visible then
      begin
        frmIntelligence.SetFocus;

        Command := 0;
      end;
  end;

  if (AChar = '<') or (AChar = '|') then
  begin
    if self.frmMainController.myActiveOneTabsheet.Tabsheet.ImageIndex =
      constItemIndexHTML then
    begin
      if frmIntelligence <> nil then
        if not frmIntelligence.Visible then
          IntelligenceFrmCloseAndFree;

      if frmIntelligence = nil then
        OpenIntelligenceDlg;
    end;

  end;

  if frmIntelligence <> nil then
    if frmIntelligence.Visible then
    begin
      if Command = 501 then
        begin
        if length(frmIntelligence.sFilter) > 0 then
          begin
          delete(frmIntelligence.sFilter,length(frmIntelligence.sFilter) ,1);
          frmIntelligence.FillWithHtml5Tags(self.frmMainController.AngIntellisence);
          end;
        end;

      if trim(AChar) <> '' then
      begin
        frmIntelligence.sFilter := frmIntelligence.sFilter + AChar;
        frmIntelligence.FillWithHtml5Tags(self.frmMainController.AngIntellisence);


        if frmIntelligence.ListView1.Items.Count = 0 then
          IntelligenceFrmCloseAndFree;

      end;
    end;
end;

procedure TfrmMainView.SynEditCommandProcessed(Sender: TObject;
  var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
begin
  if AChar = '>' then
  begin
    ShouldHTMLTagClosed;
  end;

end;

procedure TfrmMainView.ShouldHTMLTagClosed;
var
  sysMemo: TsynMemo;
  s: string;
  i: integer;
  s2, s3, s4, s5: string;
  gefunden: boolean;
  myPoint: TPoint;
begin

  if self.frmMainController.myActiveOneTabsheet.Tabsheet.ImageIndex =
    constItemIndexHTML then
  begin
    IntelligenceFrmCloseAndFree;

    sysMemo := self.frmMainController.myActiveOneTabsheet.SynMemo;
    myPoint := sysMemo.LogicalCaretXY;
    s := sysMemo.Lines[myPoint.y - 1];

    s2 := '';
    gefunden := False;
    for i := myPoint.x - 2 downto 1 do
    begin
      if i = myPoint.x - 2 then
        if s[i] = '/' then
        begin
          break;
        end;

      if s[i] = '<' then
      begin
        gefunden := True;
        break;
      end;
      s2 := s[i] + s2;
    end;

    if gefunden then
    begin
      s3 := '';
      for i := 1 to length(s2) do
      begin
        if (s2[i] = ' ') or (s2[i] = #9) then
          break
        else
          s3 := s3 + s2[i];
      end;

      if s3 <> '' then
        if s3[1] <> '/' then
          if not self.frmMainController.IsHTMLTagSelfClosing(s3) then
          begin
            s4 := '</' + s3 + '>';
            if pos(s4, s) = 0 then
            begin
              gefunden := False;
              for i := sysMemo.CaretY to sysMemo.Lines.Count - 1 do
              begin
                s5 := sysMemo.Lines[i];
                if pos('<' + s3, s5) > 0 then
                  break;
                if pos('</' + s3, s5) > 0 then
                begin
                  gefunden := True;
                  break;
                end;
              end;

              if not gefunden then
              begin
                myPoint := sysMemo.LogicalCaretXY;
                sysMemo.InsertTextAtCaret(s4);
                sysMemo.LogicalCaretXY := myPoint;
              end;
            end;
          end;

    end;

  end;

end;


procedure TfrmMainView.SynEdit1CutCopy(Sender: TObject; var AText: string;
  var AMode: TSynSelectionMode; ALogStartPos: TPoint;
  var AnAction: TSynCopyPasteAction);
begin
   self.frmMainController.AngClipboardHistorieList.AddToHistorie(AText) ;
end;


procedure TfrmMainView.SynEdit1Paste(Sender: TObject; var AText: string;
  var AMode: TSynSelectionMode; ALogStartPos: TPoint;
  var AnAction: TSynCopyPasteAction);
begin
  self.frmMainController.AngClipboardHistorieList.AddToHistorie(AText) ;
end;


function TfrmMainView.SearchTabsheetOrCreateNew(sMyFileName: string): boolean;
var
  i, i2, i3: integer;
  myOneTabsheet: TOneTabsheet;
begin
  Result := False;

  for i := 0 to frmMainController.slOpendTabsheets.Count - 1 do
  begin
    if frmMainController.slOpendTabsheets[i] = sMyFileName then
    begin
      myOneTabsheet := frmMainController.slOpendTabsheets.OneTabsheet(i);
      self.PageControl1.ActivePage := myOneTabsheet.Tabsheet;
      exit;
    end;
  end;


  myOneTabsheet := TOneTabsheet.Create;
  frmMainController.myActiveOneTabsheet := myOneTabsheet;
  myOneTabsheet.Tabsheet := Pagecontrol1.AddTabSheet;
  myOneTabsheet.SynMemo :=
    TsynMemo.Create(frmMainController.myActiveOneTabsheet.Tabsheet);
  myOneTabsheet.SynMemoPreview :=
    TsynMemo.Create(frmMainController.myActiveOneTabsheet.Tabsheet);
  myOneTabsheet.SynMemoPreview.Align := alRight;
  myOneTabsheet.SynMemoPreview.Visible := True;
  myOneTabsheet.SynMemoPreview.Parent := frmMainController.myActiveOneTabsheet.Tabsheet;
  myOneTabsheet.SynMemoPreview.Width := 70;
  myOneTabsheet.SynMemoPreview.Font.Quality := fqProof;
  myOneTabsheet.SynMemoPreview.Font.Size := 1;
  myOneTabsheet.SynMemoPreview.Font.Name := 'Consolas';
  myOneTabsheet.SynMemoPreview.ScrollBars := ssNone;
  myOneTabsheet.SynMemoPreview.Gutter.Visible := False;
  myOneTabsheet.SynMemoPreview.ReadOnly := True;
  myOneTabsheet.SynMemoPreview.OnSpecialLineMarkup := @SynEditPreviewSpecialLineMarkup;
  myOneTabsheet.SynMemoPreview.OnDblClick := @SynEditPreviewDblClick;


  frmMainController.myActiveOneTabsheet.SynMemo.Align := alClient;
  frmMainController.myActiveOneTabsheet.SynMemo.Visible := True;
  frmMainController.myActiveOneTabsheet.SynMemo.Parent :=
    frmMainController.myActiveOneTabsheet.Tabsheet;

  frmMainController.myActiveOneTabsheet.SynMemo.PopupMenu := PopupMenuSynedit;

  myOneTabsheet.SynMemo.BookMarkOptions.BookmarkImages := DataModule1.imgBookMarks;

  myOneTabsheet.SynMemo.OnChange := @synmemoChange;
  myOneTabsheet.SynMemo.OnClick := @synmemoClick;
  myOneTabsheet.SynMemo.OnKeyUp := @synmemoKeyUp;
  myOneTabsheet.SynMemo.OnCommandProcessed := @SynEditCommandProcessed;
  myOneTabsheet.SynMemo.OnProcessCommand := @SynEditProcessedCommand;

  myOneTabsheet.SynMemo.OnCutCopy := @SynEdit1CutCopy;
  myOneTabsheet.SynMemo.OnPaste := @SynEdit1Paste;

  myOneTabsheet.SynMemo.RightEdge := 0;



  if frmMainController.slColorScheme.activeColorScheme <> nil then
  begin
    myOneTabsheet.setActiveColorScheme(
      frmMainController.slColorScheme.activeColorScheme);

  end;

  myOneTabsheet.SynMemo.Font.Quality := fqProof;
  myOneTabsheet.SynMemo.Font.Size := frmMainController.UserPropertys.iFontsize;
  myOneTabsheet.SynMemo.Font.Name := 'Consolas';

  myOneTabsheet.SynMemo.OnStatusChange := @SynMemo1StatusChange;


  myOneTabsheet.Tabsheet := frmMainController.myActiveOneTabsheet.Tabsheet;

  frmMainController.myActiveOneTabsheet.Tabsheet.ImageIndex :=
    frmMainController.CalculateIndexOfFileExtension(sMyFileName);

  i2 := frmMainController.GetImageindexForFileIfItContainsOnlyTheSameType(sMyFileName);

  if i2 >= 0 then
    frmMainController.myActiveOneTabsheet.Tabsheet.ImageIndex := i2;

  frmMainController.slOpendTabsheets.AddObject(sMyFileName, myOneTabsheet);
  myOneTabsheet.sFileName := sMyFileName;

  self.PageControl1.ActivePage := frmMainController.myActiveOneTabsheet.Tabsheet;


  myOneTabsheet.SynCompletion :=
    TSynCompletion.Create(frmMainController.myActiveOneTabsheet.Tabsheet);


  myOneTabsheet.SynCompletion.OnExecute := @SynCompletionDoExecute;
  myOneTabsheet.SynCompletion.Position := 0;
  myOneTabsheet.SynCompletion.LinesInWindow := 6;
  myOneTabsheet.SynCompletion.SelectedColor := clHighlight;
  myOneTabsheet.SynCompletion.CaseSensitive := True;
  myOneTabsheet.SynCompletion.Width := 262;
  myOneTabsheet.SynCompletion.ShowSizeDrag := True;
  myOneTabsheet.SynCompletion.ShortCut := 9;
  myOneTabsheet.SynCompletion.EndOfTokenChr := '()[].';
  myOneTabsheet.SynCompletion.OnCodeCompletion := @SynCompletionCodeCompletion;
  myOneTabsheet.SynCompletion.Editor := myOneTabsheet.SynMemo;




  Result := True;

  mnuSave.Enabled := True;
  mnuSaveall.Enabled := True;
  mnuResync.Enabled := True;

end;

procedure TfrmMainView.TreeView1Click(Sender: TObject);
var
  treenode, treenodeNeu: TTreenode;
  sl: TStringList;
  i: integer;
begin
  IntelligenceFrmCloseAndFree;
  treenode := TreeView1.Selected;
  if treenode = nil then
    exit;
  if treenode.Data = nil then
    if not treenode.HasChildren then
    begin
      sl := TStringList.Create;
      frmMainController.FillSlWithFilesContainsThisWord(sl, treenode.Text);

      for i := 0 to sl.Count - 1 do
      begin
        treenodeNeu := TreeView1.Items.AddChild(treenode, sl[i]);
        treenodeNeu.ImageIndex := frmMainController.CalculateIndexOfFileExtension(sl[i]);
        treenodeNeu.Data := sl.Objects[i];
        //In Data immer den Zeiger auf den Konten aller Dateien ablegen
      end;

      sl.Free;
      treenode.Expand(False);
    end;

end;

procedure TfrmMainView.TreeView1DblClick(Sender: TObject);
var
  treenode: TTreenode;
  sPfad: string;
  parentNode: TTreenode;
  s: string;
begin
  IntelligenceFrmCloseAndFree;
  treenode := TreeView1.Selected;
  if treenode = nil then
    exit;


  if treenode = treenodeSearchInPath then
  begin
    s := '';
    if inputquery('', '', s) then
    begin
      AddSearchInPathToTree(s);
      exit;
    end;
  end;

  if treenode.Data = nil then
    exit;

  sPfad := frmMainController.findFileNameToDataPointer(TObject(treenode.Data));

  ShowFileInPagecontrolAsTabsheet(sPfad);

  parentNode := treenode.parent;
  if parentNode <> nil then
  begin
    MarkLineContainsThisWord(parentNode.Text);

  end;
end;



procedure TfrmMainView.ReadPathToTreeview(myItemRoot: TTreenode; sPfad: string);
var
  sr: TSearchRec;
  i: integer;
  myItem: TTreenode;
begin
  i := FindFirst(sPfad + sAngSeparator + '*', faAnyFile, sr);
  while (i = 0) do
  begin
    if (sr.attr and faDirectory = faDirectory) then
    begin
      if copy(sr.Name, 1, 1) <> '.' then
        //  simple ignore all .hg .git ... (sr.Name <> '.') and (sr.Name <> '..')
      begin
        myItem := TreeView1.Items.AddChild(myItemRoot, sr.Name);
        myItem.ImageIndex := constItemIndexFolder;
        ReadPathToTreeview(myItem, sPfad + sAngSeparator + sr.Name);
      end;
    end
    else
    begin
      myItem := TreeView1.Items.AddChild(myItemRoot, sr.Name);
      myItem.ImageIndex := frmMainController.CalculateIndexOfFileExtension(sr.Name);
      myItem.Data := myItem;
      frmMainController.AddOneFileInSL(sPfad + sAngSeparator + sr.Name, myItem);

    end;
    i := Findnext(sr);
  end;
  FindClose(sr);
end;

procedure TfrmMainView.MarkLineContainsThisWord(sWord: string);
var
  i: integer;
  ipos: integer;
  s: string;

  sWord2: string;
  sWord3: string;

  gefunden: boolean;
  point: TPoint;

  boooWord2Different: boolean;
  boooWord3Different: boolean;
begin
  sWord2 := frmMainController.ChangeCamelCaseToMinusString(sWord);
  sWord3 := frmMainController.ChangeMinusToCamelCase(sWord);
  gefunden := False;

  boooWord2Different := (sWord <> sWord2);
  boooWord3Different := (sWord <> sWord3);

  frmMainController.DeleteAllMarksWithIndexIndexMarkFound;



  for i := 0 to frmMainController.myActiveOneTabsheet.SynMemo.Lines.Count - 1 do
  begin
    s := frmMainController.myActiveOneTabsheet.SynMemo.Lines[i];
    ipos := pos(sWord, s);
    if boooWord2Different then
      if ipos = 0 then
        ipos := pos(sWord2, s);
    if boooWord3Different then
      if ipos = 0 then
        ipos := pos(sWord3, s);

    if ipos > 0 then
    begin

      AddEditMarkToLine(constItemIndexMarkFound, i + 1);

      if not gefunden then
      begin
        ipos := pos(sWord, s);
        if ipos = 0 then
          ipos := pos(sWord2, s);

        point.y := i + 1;


        point.x := ipos;

        frmMainController.myActiveOneTabsheet.SynMemo.LogicalCaretXY := point;

        frmMainController.myActiveOneTabsheet.SynMemo.SetFocus;
        frmMainController.myActiveOneTabsheet.SynMemo.SelectWord;
        gefunden := True;
      end;

    end;

  end;

end;



procedure TfrmMainView.AddSearchInPathToTree(const s: string);
var
  treenodeSearch: TTreenode;
begin
  treenodeSearchInPath.Collapse(True);
  treenodeSearch := TreeView1.Items.AddChild(treenodeSearchInPath, s);
  treenodeSearch.ImageIndex := constItemIndexSerchInPath1;
  TreeView1.Selected := treenodeSearch;
  TreeView1Click(TreeView1);

  treenodeSearchInPath.Expand(False);

end;

procedure TfrmMainView.AddTreenodeNgToNode(OneFileInfo: TOneFileInfo;
  treenode: TTreenode);
var
  n: integer;
  treenodeScope1: TTreenode;
  treenodeScopeLokal: TTreenode;
begin
  treenodeScope1 := TreeView1.Items.AddChild(treenode, 'ng   ' +
    ansireplacestr(OneFileInfo.slngWords.Text, #13#10, ' | '));
  treenodeScope1.ImageIndex := constItemIndexAngular;

  for n := 0 to OneFileInfo.slngLines.Count - 1 do
  begin
    treenodeScopeLokal :=
      TreeView1.Items.AddChild(treenodeScope1, OneFileInfo.slngLines[n]);
    treenodeScopeLokal.ImageIndex := constItemIndexAngular;
  end;
end;

procedure TfrmMainView.AddTreenodeScopeToNode(const OneFileInfo: TOneFileInfo;
  const treenode: TTreenode);
var
  treenodeScope1: TTreenode;
  treenodeScopeLokal: TTreenode;
  n: integer;
begin
  treenodeScope1 := TreeView1.Items.AddChild(treenode, 'scope.');
  treenodeScope1.ImageIndex := constItemScope;

  for n := 0 to OneFileInfo.slScopeActions.Count - 1 do
  begin

    treenodeScopeLokal :=
      TreeView1.Items.AddChild(treenodeScope1, OneFileInfo.slScopeActions[n]);
    treenodeScopeLokal.ImageIndex := constItemScope;
  end;
end;

function TfrmMainView.CloseAllTabsheets: boolean;
var
  i: integer;
  iAnswer: integer;
begin

  if frmMainController.SynMemoModifiedAvailable then
  begin
    iAnswer := MessageDlg('Save changes', mtConfirmation,
      [mbYes, mbNo, mbAbort], 0);
    if iAnswer = mrAbort then
    begin
      Result := False;
      exit;
    end;
    if iAnswer = mrYes then
      frmMainController.SaveAll;
  end;


  for i := frmMainController.slOpendTabsheets.Count - 1 downto 0 do
    frmMainController.slOpendTabsheets.Delete(i);


  for i := Pagecontrol1.PageCount - 1 downto 0 do
    Pagecontrol1.Pages[i].Free;
  Result := True;
end;

procedure TfrmMainView.AddEditMarkToLine(iImageindex, iLine: integer);
var
  m: TSynEditMark;
begin
  m := TSynEditMark.Create(frmMainController.myActiveOneTabsheet.SynMemo);
  m.Line := iLine;
  m.ImageList := DataModule1.ImageList1;
  m.ImageIndex := iImageindex;
  m.Visible := True;
  frmMainController.myActiveOneTabsheet.SynMemo.Marks.Add(m);







end;




end.
