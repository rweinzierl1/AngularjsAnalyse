unit angKeyWords;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  CheckLst, ComCtrls, Buttons,angDatamodul;

type

  { TfrmSelectKeywords }

  TfrmSelectKeywords = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ListView1: TListView;
    Panel1: TPanel;
  private
    { private declarations }
  public
    { public declarations }

    procedure Initialize(slKeywords : TStringlist);
    function GetSelectedKeyWords : string;
  end;

var
  frmSelectKeywordsObj: TfrmSelectKeywords;

implementation

{$R *.lfm}

{ TfrmSelectKeywords }

procedure TfrmSelectKeywords.Initialize(slKeywords: TStringlist);
var i : integer;
myItem : TListitem;
begin

for i := 0 to slKeywords.Count -1 do
  begin
  myItem := ListView1.Items.Add;
  myItem.Caption := slKeywords[i] ;
  myItem.ImageIndex := integer(slKeywords.Objects[i]) ;

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

