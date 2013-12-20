unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynHighlighterHTML, SynMemo, SynEdit,
  SynPluginSyncroEdit, SynHighlighterAny, SynHighlighterCss, Forms, Controls,
  SynEditMarks, strutils,
  Graphics, Dialogs, ComCtrls, Menus, ExtCtrls, StdCtrls, angPKZ,
  Clipbrd, shellapi,
  angFrmMainController, angDatamodul, angKeyWords, angfrmBookmarks, angFileList;

type

  { TfrmMainView }

  TfrmMainView = class(TForm)
    FindDialog1: TFindDialog;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
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
    PopupMenuTreeview: TPopupMenu;
    PopupMenuSynedit: TPopupMenu;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    SynAnySyn1: TSynAnySyn;
    SynCssSyn1: TSynCssSyn;
    SynHTMLSyn1: TSynHTMLSyn;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    TreeView1: TTreeView;
    procedure FindDialog1Find(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuBookMark1Click(Sender: TObject);
    procedure mnuBookmarksClick(Sender: TObject);
    procedure mnuColorSchemeClick(Sender: TObject);
    procedure mnuDJKeywordsClick(Sender: TObject);
    procedure mnuFindClick(Sender: TObject);
    procedure mnuCloseActivepageClick(Sender: TObject);
    procedure mnuFindNextClick(Sender: TObject);
    procedure mnuGotoLineClick(Sender: TObject);
    procedure mnuLargerClick(Sender: TObject);
    procedure mnuOpenAFileClick(Sender: TObject);
    procedure mnuOpenMarkedFileNameClick(Sender: TObject);
    procedure mnuOpenShellClick(Sender: TObject);
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
    procedure PopupMenuSyneditPopup(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
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

    frmMainController: TFrmMainController;
    procedure AddAngularJSKeyWordsInTreeview;
    procedure AddEditMarkToLine(iImageindex, iLine: integer);
    procedure AddSearchInPathToTree(const s: string);
    procedure ChangeSchema(Sender: TObject);
    function CloseAllTabsheets: boolean;
    procedure DoCloseActivePagecontrolPage;
    procedure DoSaveActivePage;
    procedure MarkLineContainsThisWord(sWord: string);
    function SearchTabsheetOrCreateNew(sMyFileName: string): boolean;
    procedure AddAngularJSFilesAsTreenode(myTreeNode: TTreenode;
      sl: TStringList; iImageindex: integer);
    procedure ReadPathToTreeview(myItemRoot: TTreenode; sPfad: string);
    procedure AddRootTreenodesToTreeview;
    procedure ShowFileInPagecontrolAsTabsheet(const sPfad: string);
    procedure StartPathAnalyse;
  public
  end;

var
  frmMainView: TfrmMainView;

implementation

{$R *.lfm}

{ TfrmMainView }

procedure TfrmMainView.mnuDateiClick(Sender: TObject);
begin

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
var mi : TMenuItem;
  i : integer;
  OneColorScheme : TOneColorScheme;
begin
  mi := TMenuItem(Sender);


  for i := 0 to frmMainController.slColorScheme.Count -1 do
    begin
    if mi.Caption =  frmMainController.slColorScheme[i] then
      begin
      OneColorScheme := TOneColorScheme(frmMainController.slColorScheme.Objects[i]  ) ;
      frmMainController.slColorScheme.activeColorScheme := OneColorScheme;
      end;
    end;
end;

procedure TfrmMainView.FormCreate(Sender: TObject);
var i : integer;
  mi : TMenuItem;
begin
  frmMainController := TFrmMainController.Create;

  if not fileexists(extractfilepath(ParamStr(0)) + 'test.txt') then
    ToolBar1.Visible := False;


  for i := 0 to  frmMainController.slColorScheme.Count -1 do
    begin
    mi := TMenuItem.Create(mnuColorScheme);
    mnuColorScheme.Add(mi);
    mi.Caption:=frmMainController.slColorScheme[i];
    mi.OnClick:=@ChangeSchema;

    end;


end;

procedure TfrmMainView.FindDialog1Find(Sender: TObject);
{var
  srOptions: TSynSearchOptions;  }

begin
  if frmMainController.myActiveSynMemo = nil then
    exit;


  if pos(FindDialog1.FindText, frmMainController.myActiveSynMemo.Lines.Text) > 0 then
  begin
    frmMainController.sLastSearch := FindDialog1.FindText;
    frmMainController.myActiveSynMemo.SetFocus;
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

procedure TfrmMainView.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  iAnswer: integer;
begin

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
      frmMainController.myActiveSynMemo.SetBookMark(
        frmBookmarks.iKeyPressed, frmMainController.myActiveSynMemo.CaretX,
        frmMainController.myActiveSynMemo.CaretY)
    else
    if frmBookmarks.obmMarked <> nil then
    begin
      frmMainController.SetTabsheetAktivForFile(frmBookmarks.obmMarked.sFileName);
      self.PageControl1.ActivePage := frmMainController.myActiveTabsheet;
      frmMainController.myActiveSynMemo.GotoBookMark(
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

procedure TfrmMainView.mnuColorSchemeClick(Sender: TObject);
begin

end;

procedure TfrmMainView.mnuDJKeywordsClick(Sender: TObject);
begin
  Application.CreateForm(TfrmSelectKeywords, frmSelectKeywordsObj);
  frmSelectKeywordsObj.Initialize(frmMainController, SynAnySyn1);
  frmSelectKeywordsObj.showmodal;
  if frmSelectKeywordsObj.ModalResult = mrOk then
  begin
    frmMainController.myActiveSynMemo.InsertTextAtCaret(
      frmSelectKeywordsObj.GetSelectedKeyWords);
  end;
  frmSelectKeywordsObj.Free;
end;

procedure TfrmMainView.mnuFindClick(Sender: TObject);
begin
  if frmMainController.myActiveSynMemo = nil then
    exit;

  if FindDialog1.Execute then
  begin

  end;

end;

procedure TfrmMainView.mnuCloseActivepageClick(Sender: TObject);
begin
  DoCloseActivePagecontrolPage;
end;

procedure TfrmMainView.mnuFindNextClick(Sender: TObject);
var
  mySyn: TsynMemo;
  i, iPos: integer;
  point: TPoint;
begin
  mySyn := frmMainController.myActiveSynMemo;


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
      self.frmMainController.myActiveSynMemo.CaretY := i;

  end;

end;

procedure TfrmMainView.mnuLargerClick(Sender: TObject);
begin
  frmMainController.myActiveSynMemo.Font.Height := frmMainController.myActiveSynMemo.Font.Height +1 ;
end;

procedure TfrmMainView.mnuOpenAFileClick(Sender: TObject);
begin
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

procedure TfrmMainView.mnuOpenMarkedFileNameClick(Sender: TObject);
var
  s, sFilename: string;
begin
  s := frmMainController.myActiveSynMemo.SelText;
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


  ShellExecute(0, 'open', PCHAR(sPfad), NIL, NIL, 5);  //5 =  SW_SHOW

end;

procedure TfrmMainView.mnuResyncClick(Sender: TObject);
var
  sl: TStringList;
  i : integer;
begin

  sl :=  TStringList.create;
  sl.text := frmMainController.slOpendTabsheets.text;

  if not CloseAllTabsheets then
    exit;

  StartPathAnalyse;



  for i := 0 to sl.count -1 do
    if fileexists(sl[i]) then
      ShowFileInPagecontrolAsTabsheet(sl[i]);

  sl.free;
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
    myOneTabsheet := TOneTabsheet(frmMainController.slOpendTabsheets.Objects[i]);
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
  mySyn := frmMainController.myActiveSynMemo;
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
  mySyn := frmMainController.myActiveSynMemo;
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
  mySyn := frmMainController.myActiveSynMemo;
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
  DoCloseActivePagecontrolPage;
end;

procedure TfrmMainView.DoCloseActivePagecontrolPage;
var
  i, iAnswer: integer;
  myOneTabsheet: TOneTabsheet;
begin
  if pagecontrol1.PageCount = 0 then
    exit;


  for i := 0 to frmMainController.slOpendTabsheets.Count - 1 do
  begin
    myOneTabsheet := TOneTabsheet(frmMainController.slOpendTabsheets.Objects[i]);
    if Pagecontrol1.ActivePage = myOneTabsheet.Tabsheet then
    begin
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


  Pagecontrol1.ActivePage.Free;
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

procedure TfrmMainView.ShowFileInPagecontrolAsTabsheet(const sPfad: string);
begin
  if SearchTabsheetOrCreateNew(sPfad) then
  begin
    if pos('.HTM', uppercase(sPfad)) > 0 then
      frmMainController.myActiveSynMemo.Highlighter := SynHTMLSyn1
    else
    if pos('.CSS', uppercase(sPfad)) > 0 then
      frmMainController.myActiveSynMemo.Highlighter := SynCssSyn1
    else
    begin
      frmMainController.myActiveSynMemo.Highlighter := SynAnySyn1;
      if pos('.JS', uppercase(sPfad)) > 0 then
      begin
        {
        SynAnySyn1.KeyWords.Clear;
        SynAnySyn1.KeyWords.add('ANGULAR');          }
        frmMainController.myActiveSynMemo.Refresh;
      end;
    end;

    frmMainController.myActiveTabsheet.Caption := extractfilename(sPfad);
    frmMainController.myActiveSynMemo.Lines.LoadFromFile(sPfad);
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


procedure TfrmMainView.mnuPfadOeffnenClick(Sender: TObject);
var
  chosenDirectory: string;
begin

  if not CloseAllTabsheets then
    exit;


  if SelectDirectory('Select a directory', 'C:\', chosenDirectory) then
  begin
    frmMainController.sPfad := chosenDirectory;
    StartPathAnalyse;
  end;

end;

procedure TfrmMainView.mnuSaveallClick(Sender: TObject);
begin
  frmMainController.SaveAll;
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
    myOneTabsheet := TOneTabsheet(frmMainController.slOpendTabsheets.Objects[i]);
    if Pagecontrol1.ActivePage = myOneTabsheet.Tabsheet then
    begin
      p := frmMainController.FindTreenodePointerToFilename(
        frmMainController.slOpendTabsheets[i]);

      Treeview1.Selected := TTreenode(p);

    end;
  end;

end;

procedure TfrmMainView.mnuSmallerClick(Sender: TObject);
begin
 frmMainController.myActiveSynMemo.Font.Height := frmMainController.myActiveSynMemo.Font.Height -1 ;
end;

procedure TfrmMainView.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = nil then
  begin
    frmMainController.myActiveTabsheet := nil;
    frmMainController.myActiveSynMemo := nil;
  end
  else
    frmMainController.SetActiveTabsheet(PageControl1.ActivePage);
end;

procedure TfrmMainView.PopupMenuSyneditPopup(Sender: TObject);
var
  s: string;
begin
  mnuOpenMarkedFileName.Visible := False;
  s := frmMainController.myActiveSynMemo.SelText;
  if length(s) > 3 then
  begin
    if frmMainController.GetFileNameToPartFileName(s) <> '' then
      mnuOpenMarkedFileName.Visible := True;
  end;

end;



procedure TfrmMainView.AddAngularJSFilesAsTreenode(myTreeNode: TTreenode;
  sl: TStringList; iImageindex: integer);
var
  i, n: integer;
  treenode, treenodeDISchluessel, treenodeScopeLokal: TTreenode;
  OneFileInfo: TOneFileInfo;
  treenodeScope1: TTreenode;
begin

  for i := 0 to sl.Count - 1 do
  begin
    treenode := TreeView1.Items.AddChild(myTreeNode, sl[i]);
    treenode.ImageIndex := iImageindex;
    treenode.Data := sl.Objects[i];

    OneFileInfo := frmMainController.FindOneFileInfoToDataPointer(
      TObject(treenode.Data));

    if OneFileInfo <> nil then
    begin
      for n := 0 to OneFileInfo.slDependencyInjektionNamen.Count - 1 do
      begin
        treenodeDISchluessel :=
          TreeView1.Items.AddChild(treenode, OneFileInfo.slDependencyInjektionNamen[n]);
        treenodeDISchluessel.ImageIndex := constItemIndexKey;
      end;


      if OneFileInfo.slngLines.Count > 0 then
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


      if OneFileInfo.slScopeActions.Count > 0 then
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

    end;
  end;

end;




procedure TfrmMainView.StartPathAnalyse;
var
  i, i1, i2, i3: integer;
  sl: TStringList;
  treenode: TTreenode;
begin
  mnuOpenAFile.Enabled := True;

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

end;



procedure TfrmMainView.ToolButton1Click(Sender: TObject);
begin
  frmMainController.sPfad := 'C:\temp\KonfigWeb';
  StartPathAnalyse;
end;

procedure TfrmMainView.ToolButton2Click(Sender: TObject);
begin

end;

procedure TfrmMainView.ToolButton3Click(Sender: TObject);
begin
  frmMainController.sPfad := 'D:\BesuchHerrRammer\Konfigurator\Src';
  StartPathAnalyse;
end;

procedure TfrmMainView.ToolButton4Click(Sender: TObject);
begin

end;

function TfrmMainView.SearchTabsheetOrCreateNew(sMyFileName: string): boolean;
var
  i, i2,i3: integer;
  myOneTabsheet: TOneTabsheet;
begin
  Result := False;

  for i := 0 to frmMainController.slOpendTabsheets.Count - 1 do
  begin
    if frmMainController.slOpendTabsheets[i] = sMyFileName then
    begin
      myOneTabsheet := TOneTabsheet(frmMainController.slOpendTabsheets.Objects[i]);
      self.PageControl1.ActivePage := myOneTabsheet.Tabsheet;
      exit;
    end;
  end;


  frmMainController.myActiveTabsheet := Pagecontrol1.AddTabSheet;
  frmMainController.myActiveSynMemo :=
    TsynMemo.Create(frmMainController.myActiveTabsheet);
  frmMainController.myActiveSynMemo.Align := alClient;
  frmMainController.myActiveSynMemo.Visible := True;
  frmMainController.myActiveSynMemo.Parent := frmMainController.myActiveTabsheet;

  frmMainController.myActiveSynMemo.PopupMenu := PopupMenuSynedit;


  myOneTabsheet := TOneTabsheet.Create;
  myOneTabsheet.SynMemo := frmMainController.myActiveSynMemo;

  myOneTabsheet.SynMemo.BookMarkOptions.BookmarkImages := DataModule1.imgBookMarks;


  if frmMainController.slColorScheme.activeColorScheme <> nil then
    begin
    i3 :=frmMainController.slColorScheme.activeColorScheme.Color ;
    myOneTabsheet.SynMemo.Color := i3 ; //  ;
    i3 := frmMainController.slColorScheme.activeColorScheme.Font.Color ;
    myOneTabsheet.SynMemo.Font.Color  := i3 ;
    end;

  myOneTabsheet.SynMemo.Font.Quality :=  fqProof;

  myOneTabsheet.Tabsheet := frmMainController.myActiveTabsheet;

  frmMainController.myActiveTabsheet.ImageIndex :=
    frmMainController.CalculateIndexOfFileExtension(sMyFileName);

  i2 := frmMainController.GetImageindexForFileIfItContainsOnlyTheSameType(sMyFileName);

  if i2 >= 0 then
    frmMainController.myActiveTabsheet.ImageIndex := i2;

  frmMainController.slOpendTabsheets.AddObject(sMyFileName, myOneTabsheet);

  self.PageControl1.ActivePage := frmMainController.myActiveTabsheet;
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
      if (sr.Name <> '.') and (sr.Name <> '..') then
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
  m: TSynEditMark;
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


  for i := frmMainController.myActiveSynMemo.Marks.Count - 1 downto 0 do
  begin
    m := frmMainController.myActiveSynMemo.Marks[i];
    if m.ImageIndex = constItemIndexMarkFound then
      frmMainController.myActiveSynMemo.Marks.Delete(i);
  end;

  for i := 0 to frmMainController.myActiveSynMemo.Lines.Count - 1 do
  begin
    s := frmMainController.myActiveSynMemo.Lines[i];
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

        frmMainController.myActiveSynMemo.LogicalCaretXY := point;

        frmMainController.myActiveSynMemo.SetFocus;
        frmMainController.myActiveSynMemo.SelectWord;
        gefunden := True;
      end;

    end;

  end;

end;

procedure TfrmMainView.AddEditMarkToLine(iImageindex, iLine: integer);
var
  m: TSynEditMark;
begin
  m := TSynEditMark.Create(frmMainController.myActiveSynMemo);
  m.Line := iLine;
  m.ImageList := DataModule1.ImageList1;
  m.ImageIndex := iImageindex;
  m.Visible := True;
  frmMainController.myActiveSynMemo.Marks.Add(m);
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


end.
