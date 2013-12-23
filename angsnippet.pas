unit angSnippet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, angPkz,inifiles;

type

  TSnippetLocation = (snippetProject, snippetUser, snippetGlobal);

  { TAngSnippet }

  TAngSnippet = class
  private
    FsFilename: string;
    procedure SetsFilename(AValue: string);
  public
    sShortcut: string;
    sDescription: string;
    sForFileType: string;
    sContent: string;
    sLongDescription: string;
    SnippetLocation: TSnippetLocation;
    property sFilename: string read FsFilename write SetsFilename ;

    procedure MakeFilenameFromShortcut(sProjectPath : string);
    constructor create;
    function LoadfromFile(): boolean;
    procedure SaveToFile();
  end;

  { TAngSnippetList }

  TAngSnippetList = class(TStringList)
  private
   procedure LoadFromFixedpath;
  public

    function AngSnippet(i: integer): TAngSnippet;
    procedure LoadFromDir(sPath: string; snippetLocation: TSnippetLocation);
    constructor Create;
  end;




implementation


function GetPathFromSnippingLoaction(sProjectPath : string;  SnippetLocation1 :TSnippetLocation ): string;
begin
  case SnippetLocation1 of
    snippetProject : result := sProjectPath + '.AngularAnalyse'+
      sAngSeparator+'Snippet'+ sAngSeparator;
    snippetUser    :  begin
      result := extractfilepath(GetAppConfigFile(False)) + 'Snippet'+
        sAngSeparator ;
      end
    else
    result := extractfilepath(paramstr(0)) + 'Snippet'+ sAngSeparator;

    end;
end;

procedure TAngSnippet.SetsFilename(AValue: string);
begin
  if FsFilename=AValue then Exit;
  FsFilename:=AValue;
end;



procedure TAngSnippet.MakeFilenameFromShortcut(sProjectPath: string);
var sPath : string;
  sFilename1,sFilename2 : string;
  i : integer;
begin


sPath := GetPathFromSnippingLoaction(sProjectPath,SnippetLocation);


forcedirectories(sPath);

sFilename1 := '';

for i := 1 to length(self.sShortcut) do
  begin
  if (sShortcut[i] in ['A'..'Z']) or (sShortcut[i] in ['a'..'z']) then
    sFilename1 := sFilename1 + sShortcut[i]
  else
    sFilename1 := sFilename1 + '_';
  end;

i := 1;
sFilename2 := sPath + sFilename1 + '.AaS';
while fileexists(sFilename2) do
  begin
  sFilename2 := sPath + sFilename1 + inttostr(i) +'.AaS';
  inc(i);
  end;

sFilename := sFilename2;

end;

constructor TAngSnippet.create;
begin
  SnippetLocation := snippetUser;
end;

function TAngSnippet.LoadfromFile(): boolean;
var myIni : Tinifile;
  sl : TStringlist;
  i : integer;
begin

myIni := Tinifile.create(sFilename);

sShortcut := myIni.ReadString('init','Shortcut','');
sDescription := myIni.ReadString('init','Description','');
sForFileType := myIni.ReadString('init','ForFileType','');

sl := TStringlist.create;
myIni.ReadSection('Content',sl);

for i := 0 to sl.count -1 do
  sl[i] := copy(sl[i],2,length(sl[i]));
sContent := sl.text;


myIni.ReadSection('LongDescription',sl);

for i := 0 to sl.count -1 do
  sl[i] := copy(sl[i],2,length(sl[i]));
self.sLongDescription := sl.text;

sl.free;

myIni.free;

result :=  sShortcut <> '';
end;

procedure TAngSnippet.SaveToFile();
var sl,sl2 : TStringlist;
  i : integer;
begin
sl := TStringlist.create;
sl2 := TStringlist.create;

sl.add('[init]');
sl.add('Shortcut='+sShortcut);
sl.add('Description='+sDescription);
sl.add('ForFileType='+sForFileType);

sl.add(' ');
sl.add('[Content]');
sl2.text := self.sContent;

for i := 0 to sl2.Count -1 do
  sl.add('_'+sl2[i]);

sl.add('[LongDescription]');
sl2.text := self.sLongDescription ;

for i := 0 to sl2.Count -1 do
  sl.add('_'+sl2[i]);



sl2.free;

sl.SaveToFile(self.sFilename);

sl.free;
end;

{ TAngSnippetList }

function TAngSnippetList.AngSnippet(i: integer): TAngSnippet;
begin
  Result := TAngSnippet(self.Objects[i]);
end;

procedure TAngSnippetList.LoadFromFixedpath;
var sPath: string;
begin
sPath := GetPathFromSnippingLoaction( '',snippetUser);
LoadFromDir(sPath,snippetUser);

sPath := GetPathFromSnippingLoaction( '',snippetGlobal);
LoadFromDir(sPath,snippetGlobal);


end;

procedure TAngSnippetList.LoadFromDir(sPath: string; snippetLocation: TSnippetLocation);
var
  sr: TSearchRec;
  i: integer;
  myAngSnippet: TAngSnippet;
begin

for i := self.Count -1 downto 0 do
  begin
  myAngSnippet := self.AngSnippet(i);
  if myAngSnippet.SnippetLocation = snippetLocation then
    self.Delete(i);
  end;

  i := FindFirst(sPath  + '*', faAnyFile, sr);
  while (i = 0) do
  begin
    if (sr.attr and faDirectory = faDirectory) then
    begin
      if copy(sr.Name, 1, 1) <> '.' then
      begin
        LoadFromDir(sPath  + sr.Name+ sAngSeparator, snippetLocation);
      end;
    end
    else
    begin
      if uppercase(ExtractFileExt(sr.Name)) = '.AAS' then
      begin
        myAngSnippet := TAngSnippet.Create;
        myAngSnippet.SnippetLocation := snippetLocation;
        myAngSnippet.sFilename := sPath + sAngSeparator + sr.Name;
        if myAngSnippet.LoadfromFile() then
          self.AddObject(myAngSnippet.sShortcut, myAngSnippet)
        else
          myAngSnippet.Free;

      end;
    end;
    i := Findnext(sr);
  end;
  FindClose(sr);
end;


constructor TAngSnippetList.Create;
begin
  self.OwnsObjects := True;
  LoadFromFixedpath;
end;

end.
