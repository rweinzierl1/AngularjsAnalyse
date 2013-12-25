unit angSnippet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, angPkz,inifiles,strutils ;

type

  TAngHTMLTag = class
    public
    sTag : string;
    sDescription : string;
  end;

   { TAngHTMLTagList }

   TAngHTMLTagList = class(TStringList)
    public
    function  AngHTMLTag(i : integer) : TAngHTMLTag;
    constructor create;
    procedure LoadFromFile;

   end;


  TSnippetLocation = (snippetProject, snippetUser, snippetGlobal);
  TSnippetForFiletype = (snippetFileHTML, snippetFileCSS, snippetFileJS, snippetFileALL );

  { TAngSnippet }

  TAngSnippet = class
  private
    FsFilename: string;
    procedure SetsFilename(AValue: string);
  public
    sShortcut: string;
    sDescription: string;
    ForFileType: TSnippetForFiletype;
    sContent: string;
    sLongDescription: string;
    SnippetLocation: TSnippetLocation;
    property sFilename: string read FsFilename write SetsFilename ;

    function ForFileTypeOK(myType : TSnippetForFiletype) : boolean;
    procedure MakeShortcutFromSContent;
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
    procedure DeleteSnippet(AngSnippet1 : TAngSnippet);
    constructor Create;
  end;




implementation


function GetPathFromSnippingLoaction(sProjectPath : string;  SnippetLocation1 :TSnippetLocation ): string;
begin
  case SnippetLocation1 of
    snippetProject :
      begin
      if  sProjectPath <> '' then
        if sProjectPath[length(sProjectPath)] <> sAngSeparator then
          sProjectPath := sProjectPath +  sAngSeparator;

        result := sProjectPath + '.AngularAnalyse'+ sAngSeparator+'Snippet'+ sAngSeparator;

      end;
    snippetUser    :  begin
      result := extractfilepath(GetAppConfigFile(False)) + 'Snippet'+
        sAngSeparator ;
      end
    else
    result := extractfilepath(paramstr(0)) + 'Snippet'+ sAngSeparator;

    end;
end;

{ TAngHTMLTagList }

function TAngHTMLTagList.AngHTMLTag(i: integer): TAngHTMLTag;
begin
  result := TAngHTMLTag( self.Objects[i]);
end;

constructor TAngHTMLTagList.create;
begin
  self.OwnsObjects:=true;
  LoadFromFile;
end;

procedure TAngHTMLTagList.LoadFromFile;
var sl : TStringlist;
  sl2 : TStringlist;
  sFilename : string;
  i : integer;
  AngHTMLTag1 : TAngHTMLTag;
begin
  sFilename := extractfilepath(paramstr(0)) + 'Snippet' + sAngSeparator + 'TagReferenz.ATR';

  if fileexists(sFilename) then
    begin
    sl2 := TStringlist.create;
    sl := TStringlist.create;
    sl.LoadFromFile(sFilename);

    for i := 0 to sl.count -1 do
      begin
      sl2.text := ansireplacetext( sl[i] , #9,#13#10);
      if sl2.count >= 2 then
        begin
        AngHTMLTag1 := TAngHTMLTag.create;
        AngHTMLTag1.sTag:=sl2[0];
        AngHTMLTag1.sDescription :=sl2[1];
        self.AddObject(AngHTMLTag1.sTag,AngHTMLTag1 );
        end;

      end;

    sl.free;
    sl2.free;
    end;


end;

procedure TAngSnippet.SetsFilename(AValue: string);
begin
  if FsFilename=AValue then Exit;
  FsFilename:=AValue;
end;

function TAngSnippet.ForFileTypeOK(myType: TSnippetForFiletype): boolean;
begin
  result := false;
  if myType = snippetFileALL then
    result := true;

  if self.ForFileType = myType then
    result := true;
end;

procedure TAngSnippet.MakeShortcutFromSContent;
var i : integer;
s,s2 : string;
begin

s := trim(self.sContent);
s2 := '';

for i := 1 to length(s) do
  begin
  if (s[i] in ['A'..'Z']) or (s[i] in ['a'..'z']) then
    s2 := s2 + s[i];
  if length(s2) = 10 then break;
  end;


self.sShortcut:= s2;

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
  s: string;
begin

myIni := Tinifile.create(sFilename);

sShortcut := myIni.ReadString('init','Shortcut','');
sDescription := myIni.ReadString('init','Description','');

i := myIni.ReadInteger('init','ForFileType',0);

case i of
  0  : ForFileType := snippetFileHTML;
  1  : ForFileType := snippetFileCSS;
  2  : ForFileType := snippetFileJS;
  else   ForFileType := snippetFileALL;

  end;




sl := TStringlist.create;
myIni.ReadSectionRaw('Content',sl);

for i := 0 to sl.count -1 do
  begin
  s :=   sl[i];
  sl[i] := copy(s,2,length(s));

  end;
sContent := sl.text;


myIni.ReadSectionRaw('LongDescription',sl);

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



case ForFileType of
  snippetFileHTML : sl.add('ForFileType=0');
  snippetFileCSS: sl.add('ForFileType=1');
  snippetFileJS: sl.add('ForFileType=2');
  else   sl.add('ForFileType=3');

  end;


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

procedure TAngSnippetList.DeleteSnippet(AngSnippet1: TAngSnippet);
var i : integer;
begin
for i := self.Count - 1 downto 0 do
  if self.AngSnippet(i) = AngSnippet1 then
    self.Delete(i);

end;


constructor TAngSnippetList.Create;
begin
  self.OwnsObjects := True;
  LoadFromFixedpath;
end;

end.
