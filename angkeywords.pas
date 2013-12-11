unit angKeyWords;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, Forms, Controls, Graphics, Dialogs,
  ExtCtrls,  ComCtrls, Buttons, angDatamodul,angFrmMainController,SynHighlighterAny;

type

  { TfrmSelectKeywords }

  TfrmSelectKeywords = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ListView1: TListView;
    Panel1: TPanel;
    Splitter1: TSplitter;
    SynMemo1: TSynMemo;
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { private declarations }
    frmMainController1: TFrmMainController;
  public
    { public declarations }

    procedure Initialize( frmMainController: TFrmMainController ; SynAnySyn1 : TSynAnySyn);
    function GetSelectedKeyWords : string;
  end;

var
  frmSelectKeywordsObj: TfrmSelectKeywords;

implementation

{$R *.lfm}

{ TfrmSelectKeywords }

procedure TfrmSelectKeywords.ListView1SelectItem(Sender: TObject;Item: TListItem; Selected: Boolean);
var s : string;
begin
s := frmMainController1.sPfad + item.SubItems[0];


SynMemo1.Lines.Text := frmMainController1.getContentToFilename(s);

end;

procedure TfrmSelectKeywords.Initialize( frmMainController: TFrmMainController ; SynAnySyn1 : TSynAnySyn);
var i : integer;
myItem : TListitem;
slKeywords : TStringlist;
s : string;
begin
SynMemo1.Highlighter := SynAnySyn1;
frmMainController1 := frmMainController;


slKeywords:= frmMainController.GetslDJKeyWords  ;
for i := 0 to slKeywords.Count -1 do
  begin
  myItem := ListView1.Items.Add;
  myItem.Caption := slKeywords[i] ;
  myItem.ImageIndex := integer(slKeywords.Objects[i]) ;


  s := frmMainController.GetFilenameToKeyword(slKeywords[i]) ;
  s := frmMainController.GetFilenameWithoutRootPath(s);

  myItem.SubItems.Add(s );

  end;

end;

function TfrmSelectKeywords.GetSelectedKeyWords: string;
var i : integer;
myItem : TListitem;
begin
result := '';

for i := 0 to ListView1.Items.Count -1 do
  begin
  myItem := ListView1.Items[i];
  if myItem.checked then
    begin
    if result <> '' then
      result := result + ' , ';

    result := result +  myItem.Caption ;
    end;

  end;

end;

end.

