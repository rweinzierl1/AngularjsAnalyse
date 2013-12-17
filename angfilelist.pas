unit angFileList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ComCtrls, StdCtrls, angDatamodul, angFrmMainController, angpkz,math;

type

  { TFileListFileInfo }

  TFileListFileInfo = class
  public
    iImageindex: integer;
    sFilename: string;
    sPath: string;
    iLines : integer;
    Visible: boolean;
    constructor Create;
  end;

  { TfrmFileList }

  TfrmFileList = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    eFilter: TEdit;
    lblCount: TLabel;
    ListView1: TListView;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure eFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure eFilterKeyPress(Sender: TObject; var Key: char);
    procedure eFilterKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1Enter(Sender: TObject);
  private
    { private declarations }
    slFilesToView: TStringList;
    ColumnToSort: Integer;
    procedure DoSetSFilename;

    procedure ShowFiltered;
  public
    { public declarations }
    sFilename : string;
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
  Visible :=    True;
end;

{$R *.lfm}

{ TfrmFileList }


procedure TfrmFileList.Initialize(frmMainController: TFrmMainController);
var
  i, i2: integer;
  FileListFileInfo: TFileListFileInfo;
  s: string;
  oneFileInfo : TOneFileInfo ;
begin

  for i := 0 to frmMainController.slAllFilesFound.Count - 1 do
  begin
    s := frmMainController.slAllFilesFound[i];
    i2 := frmMainController.GetImageindexForFileIfItContainsOnlyTheSameType(s);
    if i2 = -1 then
      i2 := frmMainController.CalculateIndexOfFileExtension(s);

    if i2 <> constItemIndexUnknownFile then
    begin
      oneFileInfo := TOneFileInfo(frmMainController.slAllFilesFound.Objects[i]);

      FileListFileInfo := TFileListFileInfo.create;
      FileListFileInfo.iImageindex:= i2;
      FileListFileInfo.sFilename:= extractfilename(s);
      FileListFileInfo.iLines := oneFileInfo.slFileInhalt.Count  ;

      FileListFileInfo.sPath := frmMainController.GetFilenameWithoutRootPath(s);
      slFilesToView.AddObject(s,FileListFileInfo);

    end;
  end;

   ShowFiltered;

end;

procedure TfrmFileList.ShowFiltered;
var i : integer;
  myItem : TListitem;
  FileListFileInfo: TFileListFileInfo;
begin
  ListView1.BeginUpdate;
  ListView1.clear;

  for i := 0 to slFilesToView.Count -1 do
    begin
    FileListFileInfo := TFileListFileInfo(slFilesToView.Objects[i] );
    if FileListFileInfo.Visible then
      begin
        myItem := ListView1.Items.Add;
      myItem.Caption := extractfilename(FileListFileInfo.sFilename );
      myitem.SubItems.add(FileListFileInfo.sPath  );
      myitem.SubItems.add(inttostr(FileListFileInfo.iLines ) );

      myitem.SubItems.add(ExtractFileExt(FileListFileInfo.sFilename)  );


      myitem.ImageIndex := FileListFileInfo.iImageindex ;
      end;

    end;


      ListView1.EndUpdate;

   BitBtn1.enabled :=    ListView1.items.count > 0;

   lblCount.caption := inttostr(ListView1.items.count);

end;


procedure TfrmFileList.BitBtn1Click(Sender: TObject);
begin
 DoSetSFilename;
end;

procedure TfrmFileList.eFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 40 then
    Listview1.setfocus;
end;

procedure TfrmFileList.DoSetSFilename;
var i : integer;
   myItem : TListitem;
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

modalresult := mrOK;
end;

procedure TfrmFileList.eFilterKeyPress(Sender: TObject; var Key: char);
begin





end;

procedure TfrmFileList.eFilterKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var i : integer;
  myItem : TListitem;
  FileListFileInfo: TFileListFileInfo;
begin

  for i := 0 to slFilesToView.Count -1 do
    begin
    FileListFileInfo := TFileListFileInfo(slFilesToView.Objects[i] );
    FileListFileInfo.Visible := true;
    if eFilter.Text <> '' then
      if pos(uppercase(eFilter.Text),uppercase(FileListFileInfo.sFilename)) = 0 then
        FileListFileInfo.Visible := false;
    end;
  ShowFiltered ;
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

procedure TfrmFileList.ListView1ColumnClick(Sender: TObject; Column: TListColumn
  );
begin
  ColumnToSort := Column.Index;
  Listview1.AlphaSort;
end;

procedure TfrmFileList.ListView1Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
  var
  i:integer;
begin
  if ColumnToSort = 0 then
  Compare := CompareText(Item1.Caption, Item2.Caption)
  else
  begin
    i := ColumnToSort -1;
    if i = 1 then
      begin
      Compare := CompareValue( strtointdef(Item1.SubItems[i],0), strtointdef(Item2.SubItems[i],0) );

      end
    else
      Compare := CompareText(Item1.SubItems[i], Item2.SubItems[i]);


  end;
end;

procedure TfrmFileList.ListView1DblClick(Sender: TObject);
begin
  DoSetSFilename;


end;

procedure TfrmFileList.ListView1Enter(Sender: TObject);
begin
      if Listview1.Items.Count > 0 then
      if Listview1.ItemIndex = -1 then
        Listview1.ItemIndex := 0 ;
end;



end.



