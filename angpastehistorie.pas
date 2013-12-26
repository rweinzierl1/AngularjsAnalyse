unit angPasteHistorie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,strutils;

type TAngClipboardHistorie = class
  public
  sClipboard : string;
  end;


type

{ TAngClipboardHistorieList }

 TAngClipboardHistorieList = class(TStringlist)
  public
  procedure AddToHistorie(s : string);
  function AngClipboardHistorie(i:integer):TAngClipboardHistorie;
  constructor create;
  end;

implementation

{ TAngClipboardHistorieList }

procedure TAngClipboardHistorieList.AddToHistorie(s: string);
var gefunden : boolean;
i : integer;
AngClipboardHistorie1 : TAngClipboardHistorie;
s2 : string;
begin
  gefunden := false;
  for i := 0 to self.count -1 do
    begin
    if self.AngClipboardHistorie(i).sClipboard = s then
      begin
      gefunden := true;
      self.Exchange(i,0);
      break;
      end;
    end;

if not gefunden then
  begin
  AngClipboardHistorie1 := TAngClipboardHistorie.create;
  AngClipboardHistorie1.sClipboard:= s;
  s2 := copy(s,1,100);
  s2 := ansireplacestr(s2,#13,'');
  s2 := ansireplacestr(s2,#10,'');
  self.InsertObject (0,s2,AngClipboardHistorie1);
  end;

for i := self.count -1 downto 20 do
  self.Delete(i);


end;

function TAngClipboardHistorieList.AngClipboardHistorie(i: integer
  ): TAngClipboardHistorie;
begin
   result := TAngClipboardHistorie(self.Objects[i]);
end;

constructor TAngClipboardHistorieList.create;
begin
  self.OwnsObjects:= true;
end;

end.

