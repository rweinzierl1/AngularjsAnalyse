unit angFrmSelectSnippet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, Buttons, angSnippet, angPKZ,angfrmSnippet,strutils;

type

  { TfrmSelectSnippet }

  TfrmSelectSnippet = class(TForm)
    bDelete: TButton;
    BitBtn1: TBitBtn;
    bTake: TButton;
    bChange: TButton;
    ListView1: TListView;
    Panel1: TPanel;
    pnlEdit: TPanel;
    Splitter1: TSplitter;
    procedure bChangeClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure bTakeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Splitter1Moved(Sender: TObject);
  private
    FOnItemSelected: TNotifyevent;
    frmSnippet: TfrmSnippet;
    AngSnippet :  TAngSnippet;
    myAngSnippetList: TAngSnippetList;

    procedure ResizeFrmSippet;
    procedure SetOnItemSelected(AValue: TNotifyevent);
    { private declarations }
  public
    { public declarations }
    boolTake : boolean;
    sContent : string;
    procedure ShowSnippingList(AngSnippetList : TAngSnippetList);
    property OnItemSelected: TNotifyevent read FOnItemSelected write SetOnItemSelected;
  end;



implementation

{$R *.lfm}

{ TfrmSelectSnippet }

procedure TfrmSelectSnippet.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if assigned(OnItemSelected)  then
    OnItemSelected(nil);

end;

procedure TfrmSelectSnippet.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);

begin

AngSnippet := TAngSnippet(item.data);
frmSnippet.ShowSnippet(AngSnippet);

bDelete.enabled := true;
bChange.enabled := true;
bTake.enabled := true;



end;

procedure TfrmSelectSnippet.Splitter1Moved(Sender: TObject);
begin
  ResizeFrmSippet ;
end;

procedure TfrmSelectSnippet.FormCreate(Sender: TObject);

begin
  boolTake := false;

frmSnippet := TfrmSnippet.create(pnlEdit );

frmSnippet.parent := pnlEdit ;
frmSnippet.BorderStyle:= bsnone;
frmSnippet.Left:= 0;
frmSnippet.Top := 0;

frmSnippet.bOK.visible := false;
frmSnippet.bCancel.visible := false;
frmSnippet.mContent.Height:=frmSnippet.mContent.Height + 20 ;


frmSnippet.show;







end;

procedure TfrmSelectSnippet.bChangeClick(Sender: TObject);
var item : TListitem;
begin
  if frmSnippet.DataFromViewToObject then
    begin
    AngSnippet.SaveToFile();

    item := Listview1.Items[Listview1.ItemIndex ] ;

    item.Caption := AngSnippet.sShortcut ;
    item.SubItems[0] := AngSnippet.sDescription ;

    end;
end;

procedure TfrmSelectSnippet.bDeleteClick(Sender: TObject);
begin
deletefile( AngSnippet.sFilename);


Listview1.Items.Delete(Listview1.ItemIndex ) ;

myAngSnippetList.DeleteSnippet(AngSnippet);


if Listview1.Items.Count > 0 then
  Listview1.ItemIndex := 0
else
  close;

end;

procedure TfrmSelectSnippet.bTakeClick(Sender: TObject);
begin
  boolTake := true;

  sContent := frmSnippet.mContent.text;
  //HIER NOCH falsch



  modalresult := mrOK;
end;

procedure TfrmSelectSnippet.FormDestroy(Sender: TObject);
begin
  frmSnippet.free;
end;

procedure TfrmSelectSnippet.FormResize(Sender: TObject);
begin
  ResizeFrmSippet;
  end;

  procedure TfrmSelectSnippet.ResizeFrmSippet;
  begin
  frmSnippet.Width:=pnlEdit.Width;
  frmSnippet.Height :=pnlEdit.Height;
end;

procedure TfrmSelectSnippet.SetOnItemSelected(AValue: TNotifyevent);
begin
  if FOnItemSelected=AValue then Exit;
  FOnItemSelected:=AValue;
end;

procedure TfrmSelectSnippet.ShowSnippingList(AngSnippetList: TAngSnippetList);
var item : TListItem;
  i : integer;
  Snippet :  TAngSnippet ;
begin
  myAngSnippetList  := AngSnippetList;

  for i := 0 to AngSnippetList.Count -1 do
    begin
    item := ListView1.Items.add;

    Snippet := AngSnippetList.AngSnippet(i);
    item.Caption:= Snippet.sShortcut  ;
    item.SubItems.Add(Snippet.sDescription ) ;
    item.Data:=AngSnippetList.AngSnippet(i) ;

    case Snippet.SnippetLocation of
      snippetProject : item.ImageIndex:=constItemSnippetLocal ;
      snippetUser    : item.ImageIndex:=constItemSnippetUser ;
      snippetGlobal  : item.ImageIndex:=constItemSnippetGlobal ;
    end;


    if i = 0 then
      ListView1.itemindex := 0;

    end;

end;

end.

