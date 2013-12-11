unit angFrmMainController;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, angPKZ, ComCtrls, SynMemo;

type

  { TFrmMainController }

  { TOneFileInfo }

  TOneFileInfo = class
  public
    slFileInhalt: TStringList;
    slDependencyInjektionNamen: TStringList;
    slScopeActions: TStringList;

    pTreenodeInView: TObject;
    constructor Create;
    destructor Destroy; override;
  end;


  TOneTabsheet = class
  public
    Tabsheet: TTabSheet;
    SynMemo: TsynMemo;
  end;


  TFrmMainController = class
  private
    slDJKeyWords: TStringList;
    slAllScope: TStringList;

    procedure LookForScopeInString(sLine: string; oneFileInfo: TOneFileInfo);
    function SchluesselwortInZeileGefundenUndStringInKlammern(
      sZeile, sSchluesselwort: string; oneFileInfo: TOneFileInfo;
      iImageindex: integer): boolean;
    procedure AnalyzeFileContent(sDateiname: string; oneFileInfo: TOneFileInfo);
  public
    sPfad: string;
    slAllFilesFound: TStringList;
    slController: TStringList;
    slModule: TStringList;
    slService: TStringList;
    slFactory: TStringList;
    slFilter: TStringList;
    slDirective: TStringList;
    slConfig: TStringList;
    myActiveTabsheet: TTabSheet;
    myActiveSynMemo: TsynMemo;
    slOpendTabsheets: TStringList;
    sLastSearch: string;

    function ChangeCamelCaseToMinusString(sSuchtext: string): string;
    function GetFilenameWithoutRootPath(sDateiname : string): string;
    function GetslDJKeyWords: TStringList;
    function GetslAllScope : TStringlist;
    procedure ClearAll;
    function findFileNameToDataPointer(p: TObject): string;
    procedure AddOneFileInSL(sPath: string; treenode: TObject);
    function FindOneFileInfoToDataPointer(p: TObject): TOneFileInfo;
    procedure FillSlWithFilesContainsThisWord(sl: TStringList; sSuchtext: string);
    procedure SaveAll;
    function SynMemoModifiedAvailable: boolean;
    procedure SetActiveTabsheet(ActivePage: TTabSheet);
    function GetActiveFilePath: string;
    function PostitionOfTextInText(const Substr: ansistring;
      const Source: ansistring): integer;
    function GetImageindexForFileIfItContainsOnlyTheSameType(sFilename: string): integer;
    function GetFilenameToKeyword(sKeyWord: string): string;
    function getContentToFilename(sFilename: string): string;
    constructor Create;
    destructor Destroy; override;
  end;


implementation

{ TOneFileInfo }

constructor TOneFileInfo.Create;
begin
  slFileInhalt := TStringList.Create;
  slDependencyInjektionNamen := TStringList.Create;
  slScopeActions             := TStringList.create;
end;

destructor TOneFileInfo.Destroy;
begin
  slFileInhalt.Free;
  slDependencyInjektionNamen.Free;
  slScopeActions.free;
  inherited Destroy;
end;

{ TFrmMainController }

constructor TFrmMainController.Create;
begin
  sPfad := '';
  slAllFilesFound := TStringList.Create;
  slAllFilesFound.OwnsObjects := True;

  slController := TStringList.Create;
  slModule := TStringList.Create;
  slService := TStringList.Create;
  slFactory := TStringList.Create;
  slFilter := TStringList.Create;
  slDirective := TStringList.Create;
  slConfig := TStringList.Create;
  slDJKeyWords := TStringList.Create;
  slAllScope := TStringList.Create;

  slOpendTabsheets := TStringList.Create;
  slOpendTabsheets.OwnsObjects := True;
end;

destructor TFrmMainController.Destroy;
begin
  slAllFilesFound.Free;

  slController.Free;
  slModule.Free;
  slService.Free;
  slFactory.Free;
  slFilter.Free;
  slDirective.Free;
  slConfig.Free;
  slDJKeyWords.Free;
  slAllScope.free;

  slOpendTabsheets.Free;


  inherited Destroy;
end;

function TFrmMainController.SchluesselwortInZeileGefundenUndStringInKlammern(
  sZeile, sSchluesselwort: string; oneFileInfo: TOneFileInfo;
  iImageindex: integer): boolean;
var
  i: integer;
  s2: string;
begin
  Result := False;

  i := pos(sSchluesselwort, sZeile);
  if i > 0 then
  begin
    s2 := copy(sZeile, i + length(sSchluesselwort), length(sZeile));

    if s2 <> '' then
      if s2[1] = '(' then    //find the Word in ("xxxx")
      begin
        Delete(s2, 1, 1);
        if s2 <> '' then
        begin
          if s2[1] = #39 then
          begin
            Delete(s2, 1, 1);
            if pos(#39, s2) > 0 then
            begin
              s2 := copy(s2, 1, pos(#39, s2) - 1);
              Result := True;
            end;
          end;

          if s2[1] = '"' then
          begin
            Delete(s2, 1, 1);
            if pos('"', s2) > 0 then
            begin
              s2 := copy(s2, 1, pos('"', s2) - 1);
              Result := True;
            end;
          end;

          if pos('+',s2) > 0 then
            result := false ; //TODO make it better

          if pos(':',s2) > 0 then
            result := false ; //TODO make it better

          if Result then
            oneFileInfo.slDependencyInjektionNamen.AddObject(s2, TObject(iImageindex));

          if pos('function', trim(s2)) = 1 then    //anonyme Funktion
            Result := True;

        end;
      end;

  end;

end;

procedure TFrmMainController.AnalyzeFileContent(sDateiname: string;
  oneFileInfo: TOneFileInfo);
var
  s: string;
  i: integer;
  boolModuleGefunden: boolean;
  boolControllerGefunden: boolean;
  boolServiceGefunden: boolean;
  boolFactoryGefunden: boolean;
  boolFilterGefunden: boolean;
  boolDirectiveGefunden: boolean;
  boolConfigGefunden: boolean;
  ZeileVerarbeitet: boolean;
  sDateiNameOhneRootPfad: string;
  sExt: string;
begin
  boolModuleGefunden := False;
  boolControllerGefunden := False;
  boolServiceGefunden := False;
  boolFactoryGefunden := False;
  boolFilterGefunden := False;
  boolDirectiveGefunden := False;
  boolConfigGefunden := False;

  sExt := uppercase(ExtractFileExt(sDateiname));

  if (sExt = '.HTML') or (sExt = '.HTM') or (sExt = '.CSS') then
    oneFileInfo.slFileInhalt.loadfromfile(sDateiname)
  else
  if sExt = '.JS' then
  begin
    sDateiNameOhneRootPfad:=GetFilenameWithoutRootPath(sDateiname );


    if pos('angular',ExtractFileName(sDateiname) ) = 0 then   //  ignore  Angular Files
      oneFileInfo.slFileInhalt.loadfromfile(sDateiname);
    for i := 0 to oneFileInfo.slFileInhalt.Count - 1 do
    begin
      s := oneFileInfo.slFileInhalt[i];
      ZeileVerarbeitet := False;

      if i < 5 then  //  ignore  Angular Files
        if pos('Google',s) > 0 then
        if pos('Inc. http://angularjs.org', s) > 0 then
          if pos('(c)', s) > 0 then
            break;



      if not ZeileVerarbeitet then
        if SchluesselwortInZeileGefundenUndStringInKlammern(
          s, '.controller', oneFileInfo, constItemIndexController) then
        begin
          if not boolControllerGefunden then
            slController.addobject(sDateiNameOhneRootPfad, oneFileInfo.pTreenodeInView);

          boolControllerGefunden := True;
          ZeileVerarbeitet := True;
        end;

      if not boolFilterGefunden then
        if not ZeileVerarbeitet then
          if SchluesselwortInZeileGefundenUndStringInKlammern(
            s, '.filter', oneFileInfo, constItemIndexFilter) then
          begin
            slFilter.addobject(sDateiNameOhneRootPfad, oneFileInfo.pTreenodeInView);
            boolFilterGefunden := True;
            ZeileVerarbeitet := True;
          end;

      if not boolServiceGefunden then
        if not ZeileVerarbeitet then
          if SchluesselwortInZeileGefundenUndStringInKlammern(
            s, '.service', oneFileInfo, constItemIndexService) then
          begin
            slService.addobject(sDateiNameOhneRootPfad, oneFileInfo.pTreenodeInView);
            boolServiceGefunden := True;
            ZeileVerarbeitet := True;
          end;

      if not boolDirectiveGefunden then
        if not ZeileVerarbeitet then
          if SchluesselwortInZeileGefundenUndStringInKlammern(
            s, '.directive', oneFileInfo, constItemIndexDirective) then
          begin
            slDirective.addobject(sDateiNameOhneRootPfad, oneFileInfo.pTreenodeInView);
            boolDirectiveGefunden := True;
            ZeileVerarbeitet := True;
          end;

      if not boolFactoryGefunden then
        if not ZeileVerarbeitet then
          if SchluesselwortInZeileGefundenUndStringInKlammern(
            s, '.factory', oneFileInfo, constItemIndexFactory) then
          begin
            slFactory.addobject(sDateiNameOhneRootPfad, oneFileInfo.pTreenodeInView);
            boolFactoryGefunden := True;
            ZeileVerarbeitet := True;
          end;

      if not boolConfigGefunden then
        if not ZeileVerarbeitet then
          if SchluesselwortInZeileGefundenUndStringInKlammern(
            s, '.config', oneFileInfo, constItemIndexConfig) then
          begin
            slConfig.addobject(sDateiNameOhneRootPfad, oneFileInfo.pTreenodeInView);
            boolConfigGefunden := True;
            ZeileVerarbeitet := True;
          end;

      if not boolModuleGefunden then
        if not ZeileVerarbeitet then
          if SchluesselwortInZeileGefundenUndStringInKlammern(
            s, 'angular.module', oneFileInfo, constItemIndexModule) then
          begin
            slModule.addobject(sDateiNameOhneRootPfad, oneFileInfo.pTreenodeInView);
            boolModuleGefunden := True;
            ZeileVerarbeitet := True;
          end;

          LookForScopeInString(s, oneFileInfo );


    end;

  end;

end;


procedure TFrmMainController.LookForScopeInString(sLine : string ; oneFileInfo : TOneFileInfo) ;
var i,i2 : integer;
s : string;
boolOK : boolean ;
begin
  i := pos('scope.',sLine) ;
  if  i > 0 then
    begin
    boolOK := true;
    i2 := pos('//',sLine) ;
    if i2 > 0 then
      if i2 < i then
          boolOK := false; //Todo To simple

    if copy(trim(sLine),1,1) = '*' then
      boolOK := false; //Todo To simple


    if boolOK then
      oneFileInfo.slScopeActions.Add(trim(sLine) );

    end;
end;

procedure TFrmMainController.ClearAll;
begin
  slAllFilesFound.Clear;
  slController.Clear;
  slModule.Clear;
  slService.Clear;
  slFactory.Clear;
  slFilter.Clear;
  slDirective.Clear;
  slConfig.Clear;
end;

procedure TFrmMainController.AddOneFileInSL(sPath: string; treenode: TObject);
var
  oneFileInfo: TOneFileInfo;
begin

  oneFileInfo := TOneFileInfo.Create;
  oneFileInfo.pTreenodeInView := treenode;

  slAllFilesFound.AddObject(sPath, oneFileInfo);

  AnalyzeFileContent(sPath, oneFileInfo);

end;

function TFrmMainController.findFileNameToDataPointer(p: TObject): string;
var
  i: integer;
  oneFileInfo: TOneFileInfo;
begin
  Result := '';
  for i := 0 to self.slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
    if oneFileInfo.pTreenodeInView = p then
    begin
      Result := slAllFilesFound[i];
      break;
    end;
  end;
end;

function TFrmMainController.FindOneFileInfoToDataPointer(p: TObject): TOneFileInfo;
var
  i: integer;
  oneFileInfo: TOneFileInfo;
begin
  Result := nil;
  for i := 0 to self.slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
    if oneFileInfo.pTreenodeInView = p then
    begin
      Result := oneFileInfo;
      break;
    end;
  end;
end;

function TFrmMainController.GetslAllScope: TStringList;
var
  i, n: integer;
  oneFileInfo: TOneFileInfo;
begin
  slAllScope.Clear;
  slAllScope.sorted := True;

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
    for n := 0 to oneFileInfo.slScopeActions.Count - 1 do
      slAllScope.Add(oneFileInfo.slScopeActions[n]);

  end;

  Result := slAllScope;
end;

function TFrmMainController.GetFilenameToKeyword(sKeyWord : string) : string;
var
  i, n: integer;
  oneFileInfo: TOneFileInfo;
begin
  Result := '';
  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
    for n := 0 to oneFileInfo.slDependencyInjektionNamen.Count - 1 do
      if oneFileInfo.slDependencyInjektionNamen[n] = sKeyWord then
        result := slAllFilesFound[i];
  end;


end;



function TFrmMainController.getContentToFilename(sFilename : string): string;
var
  i, n: integer;
  oneFileInfo: TOneFileInfo;
begin
  Result := '';

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    if slAllFilesFound[i] = sFilename then
      begin
      oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
      result := oneFileInfo.slFileInhalt.Text;
      end;
  end;
end;

function TFrmMainController.GetslDJKeyWords: TStringList;
var
  i, n: integer;
  oneFileInfo: TOneFileInfo;
begin
  slDJKeyWords.Clear;
  slDJKeyWords.sorted := True;

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
    for n := 0 to oneFileInfo.slDependencyInjektionNamen.Count - 1 do
      slDJKeyWords.AddObject(oneFileInfo.slDependencyInjektionNamen[n],
        oneFileInfo.slDependencyInjektionNamen.objects[n]);

  end;

  Result := slDJKeyWords;
end;

function TFrmMainController.ChangeCamelCaseToMinusString(sSuchtext: string): string;
var
  i: integer;
  boolGross: boolean;
begin
  Result := '';
  for i := 1 to length(sSuchtext) do
  begin
    boolGross := False;
    if Ord(sSuchtext[i]) >= Ord('A') then
      if Ord(sSuchtext[i]) <= Ord('Z') then
        boolGross := True;

    if boolGross then
      Result := Result + '-' + lowercase(sSuchtext[i])
    else
      Result := Result + sSuchtext[i];

  end;
end;

function TFrmMainController.GetFilenameWithoutRootPath(sDateiname : string): string;
var
  sDateiNameOhneRootPfad: string;
begin
  sDateiNameOhneRootPfad := copy(sDateiname, length(self.sPfad) +
    1, length(sDateiname));
  Result:=sDateiNameOhneRootPfad;
end;


procedure TFrmMainController.FillSlWithFilesContainsThisWord(sl: TStringList;
  sSuchtext: string);
var
  i: integer;
  oneFileInfo: TOneFileInfo;
  sDateiNameOhneRootPfad: string;
  gefunden: boolean;
  sInhalt: string;
  sCamelCaseAufgeloest: string;
begin

  sCamelCaseAufgeloest := ChangeCamelCaseToMinusString(sSuchtext);

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
    gefunden := False;
    sInhalt := oneFileInfo.slFileInhalt.Text;
    if pos(sSuchtext, sInhalt) > 0 then
      gefunden := True
    else
    begin

      if sCamelCaseAufgeloest <> sSuchtext then
        if pos(sCamelCaseAufgeloest, sInhalt) > 0 then
          gefunden := True;
    end;


    if gefunden then
    begin
      sDateiNameOhneRootPfad :=
        copy(slAllFilesFound[i], length(self.sPfad) + 1, length(slAllFilesFound[i]));
      sl.AddObject(sDateiNameOhneRootPfad, oneFileInfo.pTreenodeInView);

    end;
  end;
end;

procedure TFrmMainController.SaveAll;
var
  i: integer;
  OneTabsheet: TOneTabsheet;
begin

  for i := 0 to slOpendTabsheets.Count - 1 do
  begin
    OneTabsheet := TOneTabsheet(slOpendTabsheets.Objects[i]);

    if OneTabsheet.SynMemo.Modified then
    begin
      OneTabsheet.SynMemo.Lines.SaveToFile(slOpendTabsheets[i]);
      OneTabsheet.SynMemo.Modified := False;
    end;
  end;

end;

function TFrmMainController.SynMemoModifiedAvailable: boolean;
var
  i: integer;
  OneTabsheet: TOneTabsheet;
begin
  Result := False;

  for i := 0 to slOpendTabsheets.Count - 1 do
  begin
    OneTabsheet := TOneTabsheet(slOpendTabsheets.Objects[i]);

    if OneTabsheet.SynMemo.Modified then
    begin
      Result := True;
      break;
    end;
  end;

end;

procedure TFrmMainController.SetActiveTabsheet(ActivePage: TTabSheet);
var
  i: integer;
  OneTabsheet: TOneTabsheet;
begin
  for i := 0 to slOpendTabsheets.Count - 1 do
  begin
    OneTabsheet := TOneTabsheet(slOpendTabsheets.Objects[i]);
    if OneTabsheet.Tabsheet = ActivePage then
    begin
      myActiveTabsheet := OneTabsheet.Tabsheet;
      myActiveSynMemo := OneTabsheet.SynMemo;
      break;
    end;
  end;

end;

function TFrmMainController.GetActiveFilePath: string;
var
  i: integer;
  myOneTabsheet: TOneTabsheet;
begin
  Result := '';

  for i := 0 to slOpendTabsheets.Count - 1 do
  begin
    myOneTabsheet := TOneTabsheet(slOpendTabsheets.Objects[i]);
    if myOneTabsheet.Tabsheet = myActiveTabsheet then
    begin
      Result := slOpendTabsheets[i];
    end;
  end;

end;


function TFrmMainController.PostitionOfTextInText(const Substr: ansistring;
  const Source: ansistring): integer;
var
  iPos, iEnd: integer;
  c: char;
begin
  iPos := pos(Substr, Source);
  if iPos > 0 then
  begin
    if iPos > 1 then
    begin
      c := Source[iPos - 1];
      if (c in ['a'..'z']) or (c in ['A'..'Z']) then
        iPos := 0;

      if iPos > 1 then
      begin
        iEnd := iPos + length(Substr);
        if iEnd < length(Source) then
        begin
          c := Source[iEnd];
          if (c in ['a'..'z']) or (c in ['A'..'Z']) then
            iPos := 0;
        end;
      end;

    end;

  end;

  Result := iPos;

end;

function TFrmMainController.GetImageindexForFileIfItContainsOnlyTheSameType(
  sFilename: string): integer;
var
  i, n, i1: integer;
  oneFileInfo: TOneFileInfo;
  sl: TStringList;
  iResult: integer;
begin
  iResult := -1;

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    if slAllFilesFound[i] = sFilename then
    begin
      oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
      sl := oneFileInfo.slDependencyInjektionNamen;

      for n := 0 to sl.Count - 1 do
      begin
        i1 := integer(sl.Objects[n]);
        if iResult = -1 then
          iResult := i1
        else
        if iResult >= 0 then
          if iResult <> i1 then
            iResult := -2;
      end;
    end;
  end;

  if iResult >= 0 then
    Result := iResult
  else
    Result := -1;

end;

end.
