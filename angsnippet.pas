unit angSnippet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, angPkz, inifiles, strutils;

type
  TAngComponenttype = (AngComponentService, AngComponentfunction,
    AngComponentfilter, AngComponentDirective, AngComponentproperty);

  TAngComponent = class
  public
    sTag: string;
    sDescription: string;
    angComponenttyp: TAngComponenttype;
  end;


  { TAngComponentList }

  TAngComponentList = class(TStringList)
  public
    function AngComponent(i: integer): TAngComponent;
    constructor Create;
    procedure LoadFromFile;

  end;



  TAngHTMLTag = class
  public
    sTag: string;
    sDescription: string;
  end;

  { TAngHTMLTagList }

  TAngHTMLTagList = class(TStringList)
  public
    function AngHTMLTag(i: integer): TAngHTMLTag;
    constructor Create;
    procedure LoadFromFile;

  end;


  TSnippetLocation = (snippetProject, snippetUser, snippetGlobal);
  TSnippetForFiletype = (snippetFileHTML, snippetFileCSS, snippetFileJS,
    snippetFileALL);

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
    property sFilename: string read FsFilename write SetsFilename;

    function ForFileTypeOK(myType: TSnippetForFiletype): boolean;
    procedure MakeShortcutFromSContent;
    procedure MakeFilenameFromShortcut(sProjectPath: string);
    constructor Create;
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
    procedure DeleteSnippet(AngSnippet1: TAngSnippet);
    constructor Create;
  end;


  { TAngIntellisence }

  TAngIntellisence = class
  public
    AngHTMLTagList: TAngHTMLTagList;
    AngSnippetList: TAngSnippetList;
    AngComponentList: TAngComponentList;
    AngComponentProjectList: TAngComponentList;
    slHtmlGlobalAttr: TStringList;
    slHtmlEventhandlerAttributes: TStringList;

    constructor Create;
    destructor Destroy; override;
  end;


implementation


function GetPathFromSnippingLoaction(sProjectPath: string;
  SnippetLocation1: TSnippetLocation): string;
begin
  case SnippetLocation1 of
    snippetProject:
    begin
      if sProjectPath <> '' then
        if sProjectPath[length(sProjectPath)] <> sAngSeparator then
          sProjectPath := sProjectPath + sAngSeparator;

      Result := sProjectPath + '.AngularAnalyse' + sAngSeparator + 'Snippet' +
        sAngSeparator;

    end;
    snippetUser:
    begin
      Result := extractfilepath(GetAppConfigFile(False)) + 'Snippet' +
        sAngSeparator;
    end
    else
      Result := extractfilepath(ParamStr(0)) + 'Snippet' + sAngSeparator;

  end;
end;

{ TAngIntellisence }

constructor TAngIntellisence.Create;
var
  sFilename: string;
begin
  AngSnippetList := TAngSnippetList.Create;
  AngHTMLTagList := TAngHTMLTagList.Create;
  AngComponentList := TAngComponentList.Create;
  AngComponentList.LoadFromFile;
  AngComponentProjectList := TAngComponentList.Create;

  slHtmlGlobalAttr := TStringList.Create;

  sFilename := extractfilepath(ParamStr(0)) + 'Snippet' + sAngSeparator +
    'HtmlGlobalAttr.txt';
  if fileexists(sFilename) then
    slHtmlGlobalAttr.LoadFromFile(sFilename);

  slHtmlEventhandlerAttributes := TStringList.Create;
  sFilename := extractfilepath(ParamStr(0)) + 'Snippet' + sAngSeparator +
    'HtmlEventhandlerAttributes.txt';

  if fileexists(sFilename) then
    slHtmlEventhandlerAttributes.LoadFromFile(sFilename);

end;

destructor TAngIntellisence.Destroy;
begin
  AngSnippetList.Free;
  AngHTMLTagList.Free;
  AngComponentList.Free;
  AngComponentProjectList.Free;
  slHtmlGlobalAttr.Free;
  slHtmlEventhandlerAttributes.Free;
  inherited Destroy;
end;

{ TAngComponentList }

function TAngComponentList.AngComponent(i: integer): TAngComponent;
begin
  Result := TAngComponent(self.Objects[i]);
end;

constructor TAngComponentList.Create;
begin
  self.OwnsObjects := True;
end;

procedure TAngComponentList.LoadFromFile;
var
  sl: TStringList;
  sl2: TStringList;
  sFilename: string;
  i: integer;
  AngComponent1: TAngComponent;
begin
  sFilename := extractfilepath(ParamStr(0)) + 'Snippet' + sAngSeparator +
    'AngularComponents.ACP';

  if fileexists(sFilename) then
  begin
    sl2 := TStringList.Create;
    sl := TStringList.Create;
    sl.LoadFromFile(sFilename);

    for i := 0 to sl.Count - 1 do
    begin
      sl2.Text := ansireplacetext(sl[i], #9, #13#10);
      if sl2.Count >= 3 then
      begin
        AngComponent1 := TAngComponent.Create;
        AngComponent1.sTag := sl2[0];
        AngComponent1.sDescription := sl2[1];
        if sl2[2] = 'directive' then
          AngComponent1.angComponenttyp := AngComponentDirective;
        if sl2[2] = 'filter' then
        begin
          AngComponent1.angComponenttyp := AngComponentfilter;
          AngComponent1.sTag := '|' + AngComponent1.sTag;
        end;
        if sl2[2] = 'function' then
          AngComponent1.angComponenttyp := AngComponentfunction;
        if sl2[2] = 'property' then
          AngComponent1.angComponenttyp := AngComponentproperty;
        if sl2[2] = 'service' then
          AngComponent1.angComponenttyp := AngComponentService;




        self.AddObject(AngComponent1.sTag, AngComponent1);
      end;

    end;

    sl.Free;
    sl2.Free;
  end;

end;

{ TAngHTMLTagList }

function TAngHTMLTagList.AngHTMLTag(i: integer): TAngHTMLTag;
begin
  Result := TAngHTMLTag(self.Objects[i]);
end;

constructor TAngHTMLTagList.Create;
begin
  self.OwnsObjects := True;
  LoadFromFile;
end;

procedure TAngHTMLTagList.LoadFromFile;
var
  sl: TStringList;
  sl2: TStringList;
  sFilename: string;
  i: integer;
  AngHTMLTag1: TAngHTMLTag;
begin
  sFilename := extractfilepath(ParamStr(0)) + 'Snippet' + sAngSeparator +
    'TagReferenz.ATR';

  if fileexists(sFilename) then
  begin
    sl2 := TStringList.Create;
    sl := TStringList.Create;
    sl.LoadFromFile(sFilename);

    for i := 0 to sl.Count - 1 do
    begin
      sl2.Text := ansireplacetext(sl[i], #9, #13#10);
      if sl2.Count >= 2 then
      begin
        AngHTMLTag1 := TAngHTMLTag.Create;
        AngHTMLTag1.sTag := sl2[0];
        AngHTMLTag1.sDescription := sl2[1];
        self.AddObject(AngHTMLTag1.sTag, AngHTMLTag1);
      end;

    end;

    sl.Free;
    sl2.Free;
  end;

end;

procedure TAngSnippet.SetsFilename(AValue: string);
begin
  if FsFilename = AValue then
    Exit;
  FsFilename := AValue;
end;

function TAngSnippet.ForFileTypeOK(myType: TSnippetForFiletype): boolean;
begin
  Result := False;
  if myType = snippetFileALL then
    Result := True;

  if self.ForFileType = myType then
    Result := True;
end;

procedure TAngSnippet.MakeShortcutFromSContent;
var
  i: integer;
  s, s2: string;
begin

  s := trim(self.sContent);
  s2 := '';

  for i := 1 to length(s) do
  begin
    if (s[i] in ['A'..'Z']) or (s[i] in ['a'..'z']) then
      s2 := s2 + s[i];
    if length(s2) = 10 then
      break;
  end;


  self.sShortcut := s2;

end;



procedure TAngSnippet.MakeFilenameFromShortcut(sProjectPath: string);
var
  sPath: string;
  sFilename1, sFilename2: string;
  i: integer;
begin

  sPath := GetPathFromSnippingLoaction(sProjectPath, SnippetLocation);


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
    sFilename2 := sPath + sFilename1 + IntToStr(i) + '.AaS';
    Inc(i);
  end;

  sFilename := sFilename2;

end;

constructor TAngSnippet.Create;
begin
  SnippetLocation := snippetUser;
end;

function TAngSnippet.LoadfromFile(): boolean;
var
  myIni: Tinifile;
  sl: TStringList;
  i: integer;
  s: string;
begin

  myIni := Tinifile.Create(sFilename);

  sShortcut := myIni.ReadString('init', 'Shortcut', '');
  sDescription := myIni.ReadString('init', 'Description', '');

  i := myIni.ReadInteger('init', 'ForFileType', 0);

  case i of
    0: ForFileType := snippetFileHTML;
    1: ForFileType := snippetFileCSS;
    2: ForFileType := snippetFileJS;
    else
      ForFileType := snippetFileALL;

  end;




  sl := TStringList.Create;
  myIni.ReadSectionRaw('Content', sl);

  for i := 0 to sl.Count - 1 do
  begin
    s := sl[i];
    sl[i] := copy(s, 2, length(s));

  end;
  sContent := sl.Text;


  myIni.ReadSectionRaw('LongDescription', sl);

  for i := 0 to sl.Count - 1 do
    sl[i] := copy(sl[i], 2, length(sl[i]));
  self.sLongDescription := sl.Text;

  sl.Free;

  myIni.Free;

  Result := sShortcut <> '';
end;

procedure TAngSnippet.SaveToFile();
var
  sl, sl2: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  sl2 := TStringList.Create;

  sl.add('[init]');
  sl.add('Shortcut=' + sShortcut);
  sl.add('Description=' + sDescription);



  case ForFileType of
    snippetFileHTML: sl.add('ForFileType=0');
    snippetFileCSS: sl.add('ForFileType=1');
    snippetFileJS: sl.add('ForFileType=2');
    else
      sl.add('ForFileType=3');

  end;


  sl.add(' ');
  sl.add('[Content]');
  sl2.Text := self.sContent;

  for i := 0 to sl2.Count - 1 do
    sl.add('_' + sl2[i]);

  sl.add('[LongDescription]');
  sl2.Text := self.sLongDescription;

  for i := 0 to sl2.Count - 1 do
    sl.add('_' + sl2[i]);



  sl2.Free;

  sl.SaveToFile(self.sFilename);

  sl.Free;
end;

{ TAngSnippetList }

function TAngSnippetList.AngSnippet(i: integer): TAngSnippet;
begin
  Result := TAngSnippet(self.Objects[i]);
end;

procedure TAngSnippetList.LoadFromFixedpath;
var
  sPath: string;
begin
  sPath := GetPathFromSnippingLoaction('', snippetUser);
  LoadFromDir(sPath, snippetUser);

  sPath := GetPathFromSnippingLoaction('', snippetGlobal);
  LoadFromDir(sPath, snippetGlobal);

end;

procedure TAngSnippetList.LoadFromDir(sPath: string; snippetLocation: TSnippetLocation);
var
  sr: TSearchRec;
  i: integer;
  myAngSnippet: TAngSnippet;
begin

  for i := self.Count - 1 downto 0 do
  begin
    myAngSnippet := self.AngSnippet(i);
    if myAngSnippet.SnippetLocation = snippetLocation then
      self.Delete(i);
  end;

  i := FindFirst(sPath + '*', faAnyFile, sr);
  while (i = 0) do
  begin
    if (sr.attr and faDirectory = faDirectory) then
    begin
      if copy(sr.Name, 1, 1) <> '.' then
      begin
        LoadFromDir(sPath + sr.Name + sAngSeparator, snippetLocation);
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
var
  i: integer;
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
