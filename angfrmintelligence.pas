unit angFrmIntelligence;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, angSnippet, angPkz;

type

  { TfrmIntelligence }

  TfrmIntelligence = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyPress(Sender: TObject; var Key: char);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private
    FOnIntelligenceItemSelected: TNotifyEvent;
    { private declarations }
    xMouseDown, YMouseDown: integer;
    procedure AddFilterKeysToListview(AngCompList: TAngComponentList;
      iIndex: integer);
    procedure DoOnIntelligenceItemSelected;
    procedure SetOnIntelligenceItemSelected(AValue: TNotifyEvent);
    procedure setFocusToFirstElement;
  public
    { public declarations }
    sSelText: string;
    boolCallbackActive: boolean;
    sFilter: string;

    procedure SetSelTextToPublic;
    procedure FillWithHtml5Tags(AngIntellisence: TAngIntellisence);
    property OnIntelligenceItemSelected: TNotifyEvent
      read FOnIntelligenceItemSelected write SetOnIntelligenceItemSelected;
  end;

var
  frmIntelligence: TfrmIntelligence;

implementation

{$R *.lfm}

{ TfrmIntelligence }

procedure TfrmIntelligence.Button1Click(Sender: TObject);
begin
end;

procedure TfrmIntelligence.FormCreate(Sender: TObject);
begin
  boolCallbackActive := False;
end;

procedure TfrmIntelligence.SetSelTextToPublic;
var
  i: integer;
begin
  i := Listview1.ItemIndex;

  if i <> -1 then
    sSelText := Listview1.Items[i].Caption;
end;


procedure TfrmIntelligence.DoOnIntelligenceItemSelected;
begin
  if assigned(OnIntelligenceItemSelected) then
  begin
    boolCallbackActive := True;
    OnIntelligenceItemSelected(self);
    boolCallbackActive := False;
  end;
end;

procedure TfrmIntelligence.AddFilterKeysToListview(AngCompList: TAngComponentList;
  iIndex: integer);
var
  AngComponent: TAngComponent;
  i: integer;
  myItem: TListitem;
begin
  for i := 0 to AngCompList.Count - 1 do
  begin
    AngComponent := AngCompList.AngComponent(i);
    if AngComponent.angComponenttyp = AngComponentfilter then
      if pos(sFilter, AngComponent.sTag) = 1 then
      begin
        myItem := ListView1.Items.Add;
        myItem.Caption := AngComponent.sTag;
        myItem.SubItems.Add(AngComponent.sDescription);
        myItem.ImageIndex := iIndex;
      end;
  end;
end;

procedure TfrmIntelligence.setFocusToFirstElement;
begin
  if listview1.Items.Count > 0 then
    listview1.ItemIndex := 0;

end;

procedure TfrmIntelligence.ListView1DblClick(Sender: TObject);
begin
  SetSelTextToPublic;
  DoOnIntelligenceItemSelected;

end;

procedure TfrmIntelligence.ListView1KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    SetSelTextToPublic;
    DoOnIntelligenceItemSelected;
  end;

  if Key = #27 then
    begin
    Close;
    end;
end;

procedure TfrmIntelligence.Panel1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  xMouseDown := x;
  YMouseDown := Y;
end;

procedure TfrmIntelligence.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  widthNewX, heightNewY: integer;
begin
  widthNewX := self.Width + (x - xMouseDown);
  heightNewY := self.Height + (Y - YMouseDown);


  if widthNewX < 100 then
    widthNewX := 100;
  if heightNewY < 100 then
    heightNewY := 100;

  self.Width := widthNewX;
  self.Height := heightNewY;

end;

procedure TfrmIntelligence.SetOnIntelligenceItemSelected(AValue: TNotifyEvent);
begin
  if FOnIntelligenceItemSelected = AValue then
    Exit;
  FOnIntelligenceItemSelected := AValue;
end;

procedure TfrmIntelligence.FillWithHtml5Tags(AngIntellisence: TAngIntellisence);
var
  myItem: TListitem;
  i: integer;
  AngHTMLTag: TAngHTMLTag;
begin
  ListView1.Clear;
  ListView1.BeginUpdate;


  if copy(sFilter, 1, 1) = '|' then
  begin
    AddFilterKeysToListview(AngIntellisence.AngComponentProjectList , constItemIndexFilter);
    AddFilterKeysToListview(AngIntellisence.AngComponentList, constItemIndexAngular);
  end;


  if copy(sFilter, 1, 1) = '<' then
  begin
    for i := 0 to AngIntellisence.AngHTMLTagList.Count - 1 do
    begin
      AngHTMLTag := AngIntellisence.AngHTMLTagList.AngHTMLTag(i);

      if pos(sFilter, AngHTMLTag.sTag) = 1 then
      begin
        myItem := ListView1.Items.Add;
        myItem.Caption := AngHTMLTag.sTag;
        myItem.SubItems.Add(AngHTMLTag.sDescription);
        myItem.ImageIndex := constItemIndexHTML;
      end;
    end;
  end;


 setFocusToFirstElement;

  ListView1.EndUpdate;
end;

end.
