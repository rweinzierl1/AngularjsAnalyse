unit angfrmBookmarks;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ComCtrls, Menus, ActnList, angDatamodul, angFrmMainController;

type




  { TfrmBookmarks }

  TfrmBookmarks = class(TForm)
    Action0: TAction;
    Action1: TAction;
    acClose: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ListView1: TListView;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    tb0: TToolButton;
    tb9: TToolButton;
    tb1: TToolButton;
    tb2: TToolButton;
    tb3: TToolButton;
    tb4: TToolButton;
    tb5: TToolButton;
    tb6: TToolButton;
    tb7: TToolButton;
    tb8: TToolButton;
    ToolButton1: TToolButton;
    procedure acCloseExecute(Sender: TObject);
    procedure Action0Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ListView1DblClick(Sender: TObject);
    procedure tb1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { private declarations }
  var
    slBookmarks: TStringList;
  procedure DoSetobmMarkedAndClose;
  public
    { public declarations }
    iKeyPressed: integer;
    obmMarked: TOneBookMark;

    procedure Initialize(frmMainController: TFrmMainController);
  end;

var
  frmBookmarks: TfrmBookmarks;

implementation

{$R *.lfm}

{ TfrmBookmarks }

procedure TfrmBookmarks.FormCreate(Sender: TObject);
begin
  iKeyPressed := -1;
  obmMarked   := nil;
  slBookmarks := TStringList.Create;
  slBookmarks.OwnsObjects := True;
end;

procedure TfrmBookmarks.Action0Execute(Sender: TObject);
begin
  self.iKeyPressed := 0;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.acCloseExecute(Sender: TObject);
begin
  DoSetobmMarkedAndClose;
end;

procedure TfrmBookmarks.Action1Execute(Sender: TObject);
begin
  self.iKeyPressed := 1;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.Action2Execute(Sender: TObject);
begin
  self.iKeyPressed := 2;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.Action3Execute(Sender: TObject);
begin
  self.iKeyPressed := 3;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.Action4Execute(Sender: TObject);
begin
  self.iKeyPressed := 4;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.Action5Execute(Sender: TObject);
begin
  self.iKeyPressed := 5;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.Action6Execute(Sender: TObject);
begin
  self.iKeyPressed := 6;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.Action7Execute(Sender: TObject);
begin
  self.iKeyPressed := 7;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.Action8Execute(Sender: TObject);
begin
  self.iKeyPressed := 8;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.Action9Execute(Sender: TObject);
begin
  self.iKeyPressed := 9;
  modalresult := mrOk;
end;

procedure TfrmBookmarks.BitBtn1Click(Sender: TObject);
begin
  DoSetobmMarkedAndClose
end;

procedure TfrmBookmarks.FormDestroy(Sender: TObject);
begin
  slBookmarks.Free;
end;

procedure TfrmBookmarks.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin

end;

procedure TfrmBookmarks.ListView1DblClick(Sender: TObject);
begin
  DoSetobmMarkedAndClose;
end;

procedure TfrmBookmarks.DoSetobmMarkedAndClose;
begin
  if ListView1.ItemIndex = -1 then exit;


  obmMarked := TOneBookMark(ListView1.Items.item[ListView1.ItemIndex].data )  ;
  modalresult := mrok;

end;

procedure TfrmBookmarks.tb1Click(Sender: TObject);
begin
end;

procedure TfrmBookmarks.ToolButton1Click(Sender: TObject);
var i : integer;
begin
  for i := 0 to ListView1.Items.Count -1 do
    ListView1.Items.Item[i].checked := false ;
end;

procedure TfrmBookmarks.Initialize(frmMainController: TFrmMainController);
var
  i: integer;
  myItem: TListitem;
  obm: TOneBookMark;
begin
  frmMainController.GetAllBookmarks(slBookmarks);




  for i := 0 to slBookmarks.Count - 1 do
  begin
    obm := TOneBookMark(slBookmarks.Objects[i]);

    myItem := ListView1.Items.Add;
    myItem.Caption := obm.sLine;
    myItem.ImageIndex := obm.iBookmarkNr;
    myItem.SubItems.Add(frmMainController.GetFilenameWithoutRootPath(obm.sFileName));

    myItem.SubItems.Add(inttostr( obm.iLineNr ));

    myItem.Data := obm;
    myItem.checked := true;

    if obm.boolAktiveTab then
    begin
      case obm.iBookmarkNr of
        0: tb0.Down := True;
        1: tb1.Down := True;
        2: tb2.Down := True;
        3: tb3.Down := True;
        4: tb4.Down := True;
        5: tb5.Down := True;
        6: tb6.Down := True;
        7: tb7.Down := True;
        8: tb8.Down := True;
        9: tb9.Down := True;
      end;

    end;

  end;


  if ListView1.Items.Count > 0 then
    begin
    ListView1.ItemIndex:= 0 ;


    end;

  //frmBookmarks.Initialize(slBookmarks);

end;

end.


