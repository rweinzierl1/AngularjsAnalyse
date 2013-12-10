unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynHighlighterHTML, SynMemo, SynEdit,
  SynPluginSyncroEdit, SynHighlighterAny, SynHighlighterCss, Forms, Controls,
   SynEditMarks, strutils,
  Graphics, Dialogs, ComCtrls, Menus, ExtCtrls, StdCtrls, angPKZ,
  SynHighlighterJava, SynHighlighterCpp, Clipbrd, angFrmMainController;

type

  { TForm1 }

  TForm1 = class(TForm)
    FindDialog1: TFindDialog;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
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
    procedure MenuItem2Click(Sender: TObject);
    procedure mnuFindNextClick(Sender: TObject);
    procedure mnuSearchPathClick(Sender: TObject);
    procedure mnuSearchBottomClick(Sender: TObject);
    procedure mnuSearchTopClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure mnuDateiClick(Sender: TObject);
    procedure mnuInfoClick(Sender: TObject);
    procedure mnuPathToClipboardClick(Sender: TObject);
    procedure mnuPfadOeffnenClick(Sender: TObject);
    procedure mnuSaveallClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    treenodeModule: TTreenode;
    treenodeController: TTreenode;
    treenodeService: TTreenode;
    treenodeFactory: TTreenode;
    treenodeFilter: TTreenode;
    treenodeAllFiles: TTreenode;
    treenodeDirectives: TTreenode;
    treenodeConfig: TTreenode;
    treenodeDependencyInjectionWords: TTreenode;
    treenodeAngularWords: TTreenode;
    treenodeSearchInPath: TTreenode;
    frmMainController: TFrmMainController;
    procedure AddAngularJSKeyWordsInTreeview;
    procedure AddEditMarkToLine(iImageindex, iLine: integer);
    procedure AddSearchInPathToTree(const s: string);
    procedure MarkLineContainsThisWord(sWord: string);
    function SucheTabsheetOderErstelleNeue(sDateiname: string): boolean ;
    function ErmittleItemindexAnhandDateiendung(sDateiname: string): integer;
    procedure FuegeAngularJSDateienAlsKnotenEin(myTreeNode: TTreenode;
      sl: TStringList; iImageindex: integer);
    procedure LesePfadInTreeviewEin(myItemRoot: TTreenode; sPfad: string);
    procedure SorgeFuerModuleFilterInTreeview;
    procedure StartePfadAnalyse;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.mnuDateiClick(Sender: TObject);
begin

end;

procedure TForm1.mnuInfoClick(Sender: TObject);
begin
  ShowMessage('Simple tool to anlyse AngularJS projekt stucture. ' +
    #13#10 + 'Freeware/ Open source' + #13#10 +
    'https://github.com/rweinzierl1/AngularjsAnalyse ' + #13#10 +
    'Developed by  Weinzierl Reinhold');
end;

procedure TForm1.mnuPathToClipboardClick(Sender: TObject);
begin
  Clipboard.AsText := frmMainController.GetActiveFilePath;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  frmMainController := TFrmMainController.Create;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
{var
  srOptions: TSynSearchOptions;  }

begin
  if frmMainController.myActiveSynMemo = nil then
    exit;


  if pos(FindDialog1.FindText, frmMainController.myActiveSynMemo.Lines.Text) > 0 then
  begin
    frmMainController.sLastSearch:= FindDialog1.FindText;
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

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
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

procedure TForm1.FormDestroy(Sender: TObject);
begin
  frmMainController.Free;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  if frmMainController.myActiveSynMemo = nil then
    exit;

  if FindDialog1.Execute then
  begin

  end;

end;

procedure TForm1.mnuFindNextClick(Sender: TObject);
var mySyn : TsynMemo;
  i,iPos  : integer;
begin
  mySyn := frmMainController.myActiveSynMemo;


  for i := mySyn.CaretY  to mySyn.lines.Count -1  do
    begin
    iPos :=  pos(frmMainController.sLastSearch,mySyn.Lines[i]);
    if iPos > 0 then
      begin
      mySyn.CaretY := i+1;
      mySyn.CaretX := iPos;
      mySyn.SelectWord;
      break;
      end;
    end;
end;

procedure TForm1.mnuSearchPathClick(Sender: TObject);
    var mySyn : TsynMemo;
  s : string;
  point : TPoint;
begin
  mySyn := frmMainController.myActiveSynMemo;
  s := mySyn.SelText;

  if s = '' then
    begin
    point.x := mySyn.CaretX;
    point.y := mySyn.CaretY;
    s := trim(mySyn.GetWordAtRowCol(point)) ;
    end;

  if s <> '' then
    begin
    AddSearchInPathToTree(s);
    end;

end;

procedure TForm1.mnuSearchBottomClick(Sender: TObject);
  var mySyn : TsynMemo;
  s : string;
  point : TPoint;
  i,iPos  : integer;
begin
  mySyn := frmMainController.myActiveSynMemo;
  point.x := mySyn.CaretX;
  point.y := mySyn.CaretY;
  s := trim(mySyn.GetWordAtRowCol(point)) ;

  for i := mySyn.CaretY  to mySyn.lines.Count -1  do
    begin
    iPos :=  frmMainController.PostitionOfTextInText(s,mySyn.Lines[i]);
    if iPos > 0 then
      begin
      mySyn.CaretY := i+1;
      mySyn.CaretX := iPos;
      break;
      end;
    end;
end;

procedure TForm1.mnuSearchTopClick(Sender: TObject);
var mySyn : TsynMemo;
  s : string;
  point : TPoint;
  i,iPos  : integer;
begin
  mySyn := frmMainController.myActiveSynMemo;
  point.x := mySyn.CaretX;
  point.y := mySyn.CaretY;
  s := trim(mySyn.GetWordAtRowCol(point)) ;

  for i := mySyn.CaretY -2 downto 0 do
    begin
    iPos :=  frmMainController.PostitionOfTextInText(s,mySyn.Lines[i]);


    if iPos > 0 then
      begin
      mySyn.CaretY := i+1;
      mySyn.CaretX := iPos;
      break;
      end;
    end;

end;

procedure TForm1.mnuCloseClick(Sender: TObject);
var
  i, iAnswer: integer;
  myOneTabsheet: TOneTabsheet;
begin

  for i := 0 to frmMainController.slGeoffnetteTabsheets.Count - 1 do
  begin
    myOneTabsheet := TOneTabsheet(frmMainController.slGeoffnetteTabsheets.Objects[i]);
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
            frmMainController.slGeoffnetteTabsheets[i]);
          myOneTabsheet.SynMemo.Modified := False;
        end;
      end;

      frmMainController.slGeoffnetteTabsheets.Delete(i);
      break;
    end;
  end;


  Pagecontrol1.ActivePage.Free;
end;




procedure TForm1.SorgeFuerModuleFilterInTreeview;
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

  treenodeDependencyInjectionWords :=
    TreeView1.Items.AddChild(nil, 'Dependency Injection Key Words');
  treenodeDependencyInjectionWords.ImageIndex := constItemIndexKey;


  treenodeAngularWords := TreeView1.Items.AddChild(nil, 'AngularJS Keywords');
  treenodeAngularWords.ImageIndex := constItemIndexAngular;
  AddAngularJSKeyWordsInTreeview;

  treenodeAllFiles := TreeView1.Items.AddChild(nil, 'All Files');
  treenodeAllFiles.ImageIndex := constItemIndexFolder;

  treenodeSearchInPath := TreeView1.Items.AddChild(nil, 'Search In Path (dblClick)');
  treenodeSearchInPath.ImageIndex := constItemIndexSearchInPath;

end;

procedure TForm1.AddAngularJSKeyWordsInTreeview;
var
  sl: TStringList;
  i: integer;
  treenodeAngularSchluessel: TTreenode;
begin
  sl :=  TStringList.create;
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



  sl.Free;
end;


procedure TForm1.mnuPfadOeffnenClick(Sender: TObject);
var
  chosenDirectory: string;
begin
  if SelectDirectory('Select a directory', 'C:\', chosenDirectory) then
  begin
    frmMainController.sPfad := chosenDirectory;
    StartePfadAnalyse;
  end;

end;

procedure TForm1.mnuSaveallClick(Sender: TObject);
begin
  frmMainController.SaveAll;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = nil then
  begin
    frmMainController.myActiveTabsheet := nil;
    frmMainController.myActiveSynMemo := nil;
  end
  else
    frmMainController.SetzeActiveTabsheet(PageControl1.ActivePage);
end;



procedure TForm1.FuegeAngularJSDateienAlsKnotenEin(myTreeNode: TTreenode;
  sl: TStringList; iImageindex: integer);
var
  i, n: integer;
  treenode, treenodeDISchluessel: TTreenode;
  OneFileInfo: TOneFileInfo;
begin

  for i := 0 to sl.Count - 1 do
  begin
    treenode := TreeView1.Items.AddChild(myTreeNode, sl[i]);
    treenode.ImageIndex := iImageindex;
    treenode.Data := sl.Objects[i];

    OneFileInfo := frmMainController.sucheoneFileInfoZuDataPointer(
      TObject(treenode.Data));

    if OneFileInfo <> nil then
      for n := 0 to OneFileInfo.slDependencyInjektionNamen.Count - 1 do
      begin
        treenodeDISchluessel :=
          TreeView1.Items.AddChild(treenode, OneFileInfo.slDependencyInjektionNamen[n]);
        treenodeDISchluessel.ImageIndex := constItemIndexKey;
      end;

  end;

end;

function TForm1.ErmittleItemindexAnhandDateiendung(sDateiname: string): integer;
var
  sExt: string;
begin
  Result := constItemIndexUnknownFile;

  sExt := uppercase(ExtractFileExt(sDateiname));
  if sExt = '.JS' then
    Result := constItemIndexJavascript;
  if pos('.HTM', sExt) > 0 then
    Result := constItemIndexHTML;
  if sExt = '.CSS' then
    Result := constItemIndexCss;
end;



procedure TForm1.StartePfadAnalyse;
var
  i: integer;
  sl: TStringList;
  treenode: TTreenode;
begin
  SorgeFuerModuleFilterInTreeview;
  frmMainController.ClearAll;

  statusbar1.Panels[0].Text := frmMainController.sPfad;
  TreeView1.BeginUpdate;
  LesePfadInTreeviewEin(treenodeAllFiles, frmMainController.sPfad);

  FuegeAngularJSDateienAlsKnotenEin(treenodeConfig, frmMainController.slConfig,
    constItemIndexConfig);
  FuegeAngularJSDateienAlsKnotenEin(treenodeModule, frmMainController.slModule,
    constItemIndexModule);
  FuegeAngularJSDateienAlsKnotenEin(treenodeController, frmMainController.slController,
    constItemIndexController);
  FuegeAngularJSDateienAlsKnotenEin(treenodeService, frmMainController.slService,
    constItemIndexService);
  FuegeAngularJSDateienAlsKnotenEin(treenodeFactory, frmMainController.slFactory,
    constItemIndexFactory);
  FuegeAngularJSDateienAlsKnotenEin(treenodeDirectives, frmMainController.slDirective,
    constItemIndexDirective);
  FuegeAngularJSDateienAlsKnotenEin(treenodeFilter, frmMainController.slFilter,
    constItemIndexFilter);

  SynAnySyn1.Constants.Clear;

  sl := frmMainController.GetslDJKeyWords;
  for i := 0 to sl.Count - 1 do
  begin
    treenode := TreeView1.Items.AddChild(treenodeDependencyInjectionWords, sl[i]);
    treenode.ImageIndex := integer(sl.Objects[i]);

    SynAnySyn1.Constants.add(uppercase(sl[i]));
  end;
  TreeView1.EndUpdate;
end;



procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  frmMainController.sPfad := 'C:\temp\KonfigWeb';
  StartePfadAnalyse;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin

end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
frmMainController.sPfad := 'D:\BesuchHerrRammer\Konfigurator\Src';
StartePfadAnalyse;
end;

function TForm1.SucheTabsheetOderErstelleNeue(sDateiname: string) : boolean;
var
  i: integer;
  myOneTabsheet: TOneTabsheet;
begin
result := false;

  for i := 0 to frmMainController.slGeoffnetteTabsheets.Count - 1 do
  begin
    if frmMainController.slGeoffnetteTabsheets[i] = sDateiname then
    begin
      myOneTabsheet := TOneTabsheet(frmMainController.slGeoffnetteTabsheets.Objects[i]);
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
  myOneTabsheet.Tabsheet := frmMainController.myActiveTabsheet;

  frmMainController.slGeoffnetteTabsheets.AddObject(sDateiname, myOneTabsheet);

  self.PageControl1.ActivePage := frmMainController.myActiveTabsheet;
  result := true;

end;

procedure TForm1.TreeView1Click(Sender: TObject);
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
      frmMainController.FuelleSlMitDateinDieDiesesWortEnthalten(sl, treenode.Text);

      for i := 0 to sl.Count - 1 do
      begin
        treenodeNeu := TreeView1.Items.AddChild(treenode, sl[i]);
        treenodeNeu.ImageIndex := ErmittleItemindexAnhandDateiendung(sl[i]);
        treenodeNeu.Data := sl.Objects[i];
        //In Data immer den Zeiger auf den Konten aller Dateien ablegen
      end;

      sl.Free;
    end;

  treenode.Expand(false);

end;

procedure TForm1.TreeView1DblClick(Sender: TObject);
var
  treenode: TTreenode;
  sPfad: string;
  parentNode: TTreenode;
  s : string;
begin

  treenode := TreeView1.Selected;
  if treenode = nil then
    exit;


  if treenode = treenodeSearchInPath then
    begin
    s := '';
    if inputquery('','',s) then
      begin
      AddSearchInPathToTree(s);
      exit;
      end;
    end;

  if treenode.Data = nil then
    exit;

  sPfad := frmMainController.sucheDateinameZuDataPointer(TObject(treenode.Data));

  if SucheTabsheetOderErstelleNeue(sPfad) then
    begin
    if pos('.HTM', uppercase(sPfad)) > 0 then
      frmMainController.myActiveSynMemo.Highlighter := SynHTMLSyn1
    else
    if pos('.CSS', uppercase(sPfad)) > 0 then
      frmMainController.myActiveSynMemo.Highlighter := SynCssSyn1
    else
    begin
      frmMainController.myActiveSynMemo.Highlighter := SynAnySyn1;
      if pos('.JS', uppercase(treenode.Text)) > 0 then
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

  parentNode := treenode.parent;
  if parentNode <> nil then
  begin
    MarkLineContainsThisWord(parentNode.Text);

  end;
end;



procedure TForm1.LesePfadInTreeviewEin(myItemRoot: TTreenode; sPfad: string);
var
  sr: TSearchRec;
  i: integer;
  myItem: TTreenode;
begin
  i := FindFirst(sPfad + '\*.*', faAnyFile, sr);
  while (i = 0) do
  begin
    if (sr.attr and faDirectory = faDirectory) then
    begin
      if (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        myItem := TreeView1.Items.AddChild(myItemRoot, sr.Name);
        myItem.ImageIndex := constItemIndexFolder;
        LesePfadInTreeviewEin(myItem, sPfad + '\' + sr.Name);
      end;
    end
    else
    begin
      myItem := TreeView1.Items.AddChild(myItemRoot, sr.Name);
      myItem.ImageIndex := ErmittleItemindexAnhandDateiendung(sr.Name);
      myItem.Data := myItem;
      frmMainController.AddOneFileInSL(sPfad + '\' + sr.Name, myItem);
    end;
    i := Findnext(sr);
  end;
  FindClose(sr);
end;

procedure TForm1.MarkLineContainsThisWord(sWord: string);
var
  i: integer;
  ipos: integer;
  s: string;
  m: TSynEditMark;
  sWord2: string;
  gefunden: boolean;
begin
  sWord2 := frmMainController.loeseCamelCaseAuf(sWord);
  gefunden := False;

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
    if ipos = 0 then
      ipos := pos(sWord2, s);

    if ipos > 0 then
    begin

      AddEditMarkToLine(constItemIndexMarkFound, i + 1);

      if not gefunden then
      begin
        // for n := 1 to length(s) do
        //   if s[n] = #39 then

        s := ansireplacestr(s, #9, '        '); // TODO make it better
        ipos := pos(sWord, s);
        if ipos = 0 then
          ipos := pos(sWord2, s);


        frmMainController.myActiveSynMemo.CaretY := i + 1;
        frmMainController.myActiveSynMemo.CaretX := ipos;

        frmMainController.myActiveSynMemo.SetFocus;
        frmMainController.myActiveSynMemo.SelectWord;
        gefunden := True;
      end;

    end;

  end;

end;

procedure TForm1.AddEditMarkToLine(iImageindex, iLine: integer);
var
  m: TSynEditMark;
begin
  m := TSynEditMark.Create(frmMainController.myActiveSynMemo);
  m.Line := iLine;
  m.ImageList := ImageList1;
  m.ImageIndex := iImageindex;
  m.Visible := True;
  frmMainController.myActiveSynMemo.Marks.Add(m);
end;

procedure TForm1.AddSearchInPathToTree(const s: string);
var
  treenodeSearch: TTreenode;
begin
  treenodeSearchInPath.Collapse(true);
  treenodeSearch :=       TreeView1.Items.AddChild(treenodeSearchInPath, s);
  treenodeSearch.ImageIndex := constItemIndexSerchInPath1;
  TreeView1.Selected := treenodeSearch;
  TreeView1Click(TreeView1);

  treenodeSearchInPath.Expand(false);

end;


end.