unit angFrmIntelligence;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls,angSnippet;

type

  { TfrmIntelligence }

  TfrmIntelligence = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyPress(Sender: TObject; var Key: char);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FOnIntelligenceItemSelected: TNotifyevent;
    { private declarations }
    xMouseDown,YMouseDown : integer;
    procedure SetOnIntelligenceItemSelected(AValue: TNotifyevent);
    procedure SetSelTextToPublic;
  public
    { public declarations }
    sSelText : string;

    procedure FillWithHtml5Tags(AngHTMLTagList : TAngHTMLTagList);
    property OnIntelligenceItemSelected : TNotifyevent read FOnIntelligenceItemSelected write SetOnIntelligenceItemSelected;
  end;

var
  frmIntelligence: TfrmIntelligence;

implementation

{$R *.lfm}

{ TfrmIntelligence }

procedure TfrmIntelligence.Button1Click(Sender: TObject);
begin
end;

procedure TfrmIntelligence.SetSelTextToPublic;
var i : integer;
begin
  if assigned(OnIntelligenceItemSelected)  then
    begin
    i := Listview1.ItemIndex;

    if i <> -1 then
      begin
      sSelText := Listview1.Items[i].Caption ;
      end;

    OnIntelligenceItemSelected(self);
    end;
end;

procedure TfrmIntelligence.ListView1DblClick(Sender: TObject);
begin
 SetSelTextToPublic


end;

procedure TfrmIntelligence.ListView1KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    SetSelTextToPublic;
end;

procedure TfrmIntelligence.Panel1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   xMouseDown := x;
   YMouseDown := Y;
end;

procedure TfrmIntelligence.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var widthNewX,heightNewY : integer;
begin
widthNewX := self.Width + (x-xMouseDown);
heightNewY := self.Height + (Y-YMouseDown);


if widthNewX < 100 then widthNewX := 100;
if heightNewY < 100 then heightNewY := 100;

self.Width  := widthNewX;
self.Height := heightNewY;

end;

procedure TfrmIntelligence.SetOnIntelligenceItemSelected(AValue: TNotifyevent);
begin
  if FOnIntelligenceItemSelected=AValue then Exit;
  FOnIntelligenceItemSelected:=AValue;
end;

procedure TfrmIntelligence.FillWithHtml5Tags(AngHTMLTagList: TAngHTMLTagList);
var myItem : TListitem;
  i : integer;
  AngHTMLTag : TAngHTMLTag;
begin
  ListView1.Clear;
  ListView1.BeginUpdate;

  for i := 0 to AngHTMLTagList.Count -1 do
    begin
    AngHTMLTag := AngHTMLTagList.AngHTMLTag(i) ;
    myItem := ListView1.Items.Add;
    myItem.Caption:= AngHTMLTag.sTag ;
    myItem.SubItems.Add(AngHTMLTag.sDescription ) ;
    end;

   ListView1.EndUpdate ;
end;

end.

