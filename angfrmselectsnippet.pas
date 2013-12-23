unit angFrmSelectSnippet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  angSnippet;

type

  { TfrmSelectSnippet }

  TfrmSelectSnippet = class(TForm)
    ListView1: TListView;
  private
    { private declarations }
  public
    { public declarations }
    procedure ShowSnippingList(AngSnippetList : TAngSnippetList);
  end;



implementation

{$R *.lfm}

{ TfrmSelectSnippet }

procedure TfrmSelectSnippet.ShowSnippingList(AngSnippetList: TAngSnippetList);
var item : TListItem;
  i : integer;
begin

  for i := 0 to AngSnippetList.Count -1 do
    begin
    item := ListView1.Items.add;
    item.Caption:=AngSnippetList.AngSnippet(i).sShortcut  ;

    end;






end;

end.

