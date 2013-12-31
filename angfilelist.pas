unit angFileList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, ComCtrls, StdCtrls, Menus, angDatamodul,
  angFrmMainController, angpkz, Math, strutils, SynHighlighterAny,
  SynHighlighterCss, SynHighlighterHtml ,Clipbrd, SynEdit ,SynEditTypes;

type

  { TFileListFileInfo }

  TFileListFileInfo = class
  public
    iImageindex: integer;
    sFilename: string;
    sPath: string;
    iLines: integer;
    Visible: boolean;
    ng: string;
    DI: string;
    Types : string;
    Model : string;
    oneFileInfo: TOneFileInfo;
    constructor Create;
  end;

  { TfrmFileList }

  TfrmFileList = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    eFilter: TEdit;
    eFilterAng: TEdit;
    eFilterTypes: TEdit;
    eFilterPath: TEdit;
    eFilterNg: TEdit;
    eFilterModel: TEdit;
    lblDI: TLabel;
    lblTypes: TLabel;
    lblPath: TLabel;
    lblCount: TLabel;
    lblNg: TLabel;
    lblFiles: TLabel;
    lblTypes1: TLabel;
    ListView1: TListView;
    mnuCopyClipboard: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    pmAngFileList: TPopupMenu;
    Splitter1: TSplitter;
    SynMemo1: TSynMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure eFilterKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure eFilterKeyPress(Sender: TObject; var Key: char);
    procedure eFilterKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: integer; var Compare: integer);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ListView1Enter(Sender: TObject);
    procedure ListView1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListView1Resize(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure mnuCopyClipboardClick(Sender: TObject);
    procedure SynMemo1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
  private
    { private declarations }
    slFilesToView: TStringList;
    ColumnToSort: integer;
    frmMainController1: TFrmMainController;
    procedure doFilterKeyUp;
    procedure DoSetSFilename;

    procedure ShowFiltered;
  public
    { public declarations }
    sFilename: string;
    SynAnySyn1: TSynAnySyn;
    SynCssSyn1: TSynCssSyn;
    SynHTMLSyn1: TSynHTMLSyn;

    procedure Initialize(frmMainController: TFrmMainController);
  end;

var
  frmFileList: TfrmFileList;

implementation

{ TFileListFileInfo }

constructor TFileListFileInfo.Create;
begin
  iImageindex := 0;
  sFilename := '';
  sPath := '';
  Visible := True;
end;

{$R *.lfm}

{ TfrmFileList }


procedure TfrmFileList.Initialize(frmMainController: TFrmMainController);
var
  i, i2: integer;
  FileListFileInfo: TFileListFileInfo;
  s: string;
  oneFileInfo: TOneFileInfo;
begin
  frmMainController1 := frmMainController;


  for i := 0 to frmMainController.slAllFilesFound.Count - 1 do
  begin
    s := frmMainController.slAllFilesFound[i];
    i2 := frmMainController.GetImageindexForFileIfItContainsOnlyTheSameType(s);
    if i2 = -1 then
      i2 := frmMainController.CalculateIndexOfFileExtension(s);

    if i2 <> constItemIndexUnknownFile then
    begin
      oneFileInfo := TOneFileInfo(frmMainController.slAllFilesFound.Objects[i]);

      FileListFileInfo := TFileListFileInfo.Create;
      FileListFileInfo.iImageindex := i2;
      FileListFileInfo.sFilename := extractfilename(s);
      FileListFileInfo.iLines := oneFileInfo.slFileInhalt.Count;

      FileListFileInfo.ng :=
        Ansireplacestr(oneFileInfo.slngWords.Text, #13#10, ' | ');
      FileListFileInfo.DI :=
        Ansireplacestr(oneFileInfo.slDependencyInjektionNamen.Text, #13#10, ' | ');

      FileListFileInfo.sPath := frmMainController.GetFilenameWithoutRootPath(s);
      FileListFileInfo.oneFileInfo := oneFileInfo;

      FileListFileInfo.Types := frmMainController.GetAngularTypesForFile(FileListFileInfo.sPath);

      FileListFileInfo.Model := Ansireplacestr(oneFileInfo.slNgModels.Text, #13#10, ' | '); ;

      slFilesToView.AddObject(s, FileListFileInfo);

    end;
  end;

  ShowFiltered;

end;

procedure TfrmFileList.ShowFiltered;
var
  i: integer;
  myItem: TListitem;
  FileListFileInfo: TFileListFileInfo;
begin
  ListView1.BeginUpdate;
  ListView1.Clear;

  for i := 0 to slFilesToView.Count - 1 do
  begin
    FileListFileInfo := TFileListFileInfo(slFilesToView.Objects[i]);
    if FileListFileInfo.Visible then
    begin
      myItem := ListView1.Items.Add;
      myItem.Caption := extractfilename(FileListFileInfo.sFilename);
      myitem.SubItems.add(FileListFileInfo.sPath);
      myitem.SubItems.add(IntToStr(FileListFileInfo.iLines));

      myitem.SubItems.add(ExtractFileExt(FileListFileInfo.sFilename));

      myitem.SubItems.add(FileListFileInfo.ng);
      myitem.SubItems.add(FileListFileInfo.DI);
      myitem.SubItems.add(FileListFileInfo.Types);
      myitem.Data := FileListFileInfo.oneFileInfo;

      myitem.SubItems.add(datetimetostr( FileListFileInfo.oneFileInfo.modifiedDateTime)  );

      myitem.SubItems.add(FileListFileInfo.Model);


      myitem.ImageIndex := FileListFileInfo.iImageindex;
    end;

  end;


  ListView1.EndUpdate;

  BitBtn1.Enabled := ListView1.items.Count > 0;

  lblCount.Caption := IntToStr(ListView1.items.Count);

end;


procedure TfrmFileList.BitBtn1Click(Sender: TObject);
begin
  DoSetSFilename;
end;

procedure TfrmFileList.eFilterKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = 40 then
    Listview1.SetFocus;
end;

procedure TfrmFileList.DoSetSFilename;
var
  i: integer;
  myItem: TListitem;
begin
  i := ListView1.ItemIndex;

  if i = -1 then
  begin
    i := 0;
    if Listview1.Items.Count = 0 then
      exit;

  end;

  myItem := ListView1.Items[i];

  sFilename := myItem.subitems[0];

  modalresult := mrOk;
end;

procedure TfrmFileList.eFilterKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TfrmFileList.eFilterKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
doFilterKeyUp ;
end;

procedure TfrmFileList.doFilterKeyUp;
var
  i: integer;
  FileListFileInfo: TFileListFileInfo;
begin

  for i := 0 to slFilesToView.Count - 1 do
  begin
    FileListFileInfo := TFileListFileInfo(slFilesToView.Objects[i]);
    FileListFileInfo.Visible := True;
    if eFilter.Text <> '' then
      if pos(uppercase(eFilter.Text), uppercase(FileListFileInfo.sFilename)) = 0 then
        FileListFileInfo.Visible := False;

    if eFilterPath.Text <> '' then
      if pos(uppercase(eFilterPath.Text), uppercase(FileListFileInfo.sPath )) = 0 then
        FileListFileInfo.Visible := False;

    if eFilterNg.Text <> '' then
      if pos(uppercase(eFilterNg.Text), uppercase(FileListFileInfo.ng )) = 0 then
        FileListFileInfo.Visible := False;


    if eFilterAng.Text <> '' then
      if pos(uppercase(eFilterAng.Text), uppercase(FileListFileInfo.DI )) = 0 then
        FileListFileInfo.Visible := False;

    if eFilterTypes.Text <> '' then
      if pos(uppercase(eFilterTypes.Text), uppercase(FileListFileInfo.Types )) = 0 then
        FileListFileInfo.Visible := False;

    if eFilterModel.Text <> '' then
      if pos(uppercase(eFilterModel.Text), uppercase(FileListFileInfo.Model )) = 0 then
        FileListFileInfo.Visible := False;






  end;
  ShowFiltered;
end;

procedure TfrmFileList.FormCreate(Sender: TObject);
begin
  slFilesToView := TStringList.Create;
  slFilesToView.OwnsObjects := True;
end;

procedure TfrmFileList.FormDestroy(Sender: TObject);
begin
  slFilesToView.Free;
end;

procedure TfrmFileList.FormShow(Sender: TObject);
begin
  eFilter.setfocus;
end;

procedure TfrmFileList.ListView1Click(Sender: TObject);

begin


end;

procedure TfrmFileList.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  ColumnToSort := Column.Index;
  Listview1.AlphaSort;
end;

procedure TfrmFileList.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: integer; var Compare: integer);
var
  i: integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else
  begin
    i := ColumnToSort - 1;
    if i = 1 then   //lines
    begin
      Compare := CompareValue(strtointdef(Item1.SubItems[i], 0),
        strtointdef(Item2.SubItems[i], 0));

    end
    else
    if i = 6 then  //Datetime
    begin
      Compare :=  CompareValue (strtodatetimedef (Item2.SubItems[i], 0),
        strtodatetimedef(Item1.SubItems[i], 0));

    end
    else
      Compare := CompareText(Item1.SubItems[i], Item2.SubItems[i]);

  end;
end;

procedure TfrmFileList.ListView1DblClick(Sender: TObject);
begin
  DoSetSFilename;

end;

procedure TfrmFileList.ListView1EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
     eFilter.Width:=listview1.Columns[0].Width ;
end;

procedure TfrmFileList.ListView1Enter(Sender: TObject);
begin
  if Listview1.Items.Count > 0 then
    if Listview1.ItemIndex = -1 then
      Listview1.ItemIndex := 0;
end;

procedure TfrmFileList.ListView1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TfrmFileList.ListView1Resize(Sender: TObject);
begin

end;

procedure TfrmFileList.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
  var {i : integer;
item : TListitem; }
oneFileInfo : ToneFileInfo;
begin
{i :=   Listview1.ItemIndex  ;
if i = -1 then exit;
item := Listview1.items[i];  }

oneFileInfo := ToneFileInfo(item.Data);
SynMemo1.Lines.text := oneFileinfo.slFileInhalt.Text  ;

if oneFileinfo.iImageindex = constItemIndexCss then
  SynMemo1.Highlighter := SynCssSyn1
else
if oneFileinfo.iImageindex = constItemIndexHTML then
  SynMemo1.Highlighter := SynHtmlSyn1
else
  SynMemo1.Highlighter := SynAnySyn1;
end;

procedure TfrmFileList.mnuCopyClipboardClick(Sender: TObject);
var i : integer;
  s: string;
  item : TListitem ;
begin
s := '';
for i := 0 to ListView1.Items.Count - 1 do
  begin
    item := ListView1.Items[i];
    s := s + item.Caption + #9 + ansireplacestr(item.SubItems.Text,#13#10,#9) + #13#10 ;
  end;
  Clipboard.AsText :=s;
end;

procedure TfrmFileList.SynMemo1StatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin


end;



end.






