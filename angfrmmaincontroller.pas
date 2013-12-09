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
    function SchluesselwortInZeileGefundenUndStringInKlammern(
      sZeile, sSchluesselwort: string; oneFileInfo: TOneFileInfo;
      iImageindex: integer): boolean;
    procedure WerteDateiInhaltAus(sDateiname: string; oneFileInfo: TOneFileInfo);
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
    slGeoffnetteTabsheets: TStringList;
    function loeseCamelCaseAuf(sSuchtext: string): string;
    function GetslDJKeyWords: TStringList;
    procedure ClearAll;
    function sucheDateinameZuDataPointer(p: TObject): string;
    procedure AddOneFileInSL(sPath: string; treenode: TObject);
    function sucheoneFileInfoZuDataPointer(p: TObject): TOneFileInfo;
    procedure FuelleSlMitDateinDieDiesesWortEnthalten(sl: TStringList;
      sSuchtext: string);
    procedure SaveAll;
    function SynMemoModifiedAvailable: boolean;
    procedure SetzeActiveTabsheet(ActivePage: TTabSheet);
    function GetActiveFilePath: string;
    constructor Create;
    destructor Destroy; override;
  end;


implementation

{ TOneFileInfo }

constructor TOneFileInfo.Create;
begin
  slFileInhalt := TStringList.Create;
  slDependencyInjektionNamen := TStringList.Create;
end;

destructor TOneFileInfo.Destroy;
begin
  slFileInhalt.Free;
  slDependencyInjektionNamen.Free;
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

  slGeoffnetteTabsheets := TStringList.Create;
  slGeoffnetteTabsheets.OwnsObjects := True;
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

  slGeoffnetteTabsheets.Free;


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

          if Result then
            oneFileInfo.slDependencyInjektionNamen.AddObject(s2, TObject(iImageindex));

          if pos('function', trim(s2)) = 1 then    //anonyme Funktion
            Result := True;

        end;
      end;

  end;

end;

procedure TFrmMainController.WerteDateiInhaltAus(sDateiname: string;
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

  if (sExt = '.HTML') or (sExt = '.HTM') then
    oneFileInfo.slFileInhalt.loadfromfile(sDateiname)
  else
  if sExt = '.JS' then
  begin
    sDateiNameOhneRootPfad := copy(sDateiname, length(self.sPfad) + 1, length(sDateiname));


    oneFileInfo.slFileInhalt.loadfromfile(sDateiname);
    for i := 0 to oneFileInfo.slFileInhalt.Count - 1 do
    begin
      s := oneFileInfo.slFileInhalt[i];
      ZeileVerarbeitet := False;

      if i < 5 then  //  ignore  Angular Files
        if pos('Google, Inc. http://angularjs.org', s) > 0 then
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

    end;

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

  WerteDateiInhaltAus(sPath, oneFileInfo);

end;

function TFrmMainController.sucheDateinameZuDataPointer(p: TObject): string;
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

function TFrmMainController.sucheoneFileInfoZuDataPointer(p: TObject): TOneFileInfo;
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

function TFrmMainController.loeseCamelCaseAuf(sSuchtext: string): string;
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


procedure TFrmMainController.FuelleSlMitDateinDieDiesesWortEnthalten(sl: TStringList;
  sSuchtext: string);
var
  i: integer;
  oneFileInfo: TOneFileInfo;
  sDateiNameOhneRootPfad: string;
  gefunden: boolean;
  sInhalt: string;
  sCamelCaseAufgeloest: string;
begin

  sCamelCaseAufgeloest := loeseCamelCaseAuf(sSuchtext);

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
      sDateiNameOhneRootPfad := copy(slAllFilesFound[i], length(self.sPfad) +
        1, length(slAllFilesFound[i]));
      sl.AddObject(sDateiNameOhneRootPfad, oneFileInfo.pTreenodeInView);

    end;
  end;
end;

procedure TFrmMainController.SaveAll;
var
  i: integer;
  OneTabsheet: TOneTabsheet;
begin

  for i := 0 to slGeoffnetteTabsheets.Count - 1 do
  begin
    OneTabsheet := TOneTabsheet(slGeoffnetteTabsheets.Objects[i]);

    if OneTabsheet.SynMemo.Modified then
    begin
      OneTabsheet.SynMemo.Lines.SaveToFile(slGeoffnetteTabsheets[i]);
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

  for i := 0 to slGeoffnetteTabsheets.Count - 1 do
  begin
    OneTabsheet := TOneTabsheet(slGeoffnetteTabsheets.Objects[i]);

    if OneTabsheet.SynMemo.Modified then
    begin
      Result := True;
      break;
    end;
  end;

end;

procedure TFrmMainController.SetzeActiveTabsheet(ActivePage: TTabSheet);
var
  i: integer;
  OneTabsheet: TOneTabsheet;
begin
  for i := 0 to slGeoffnetteTabsheets.Count - 1 do
  begin
    OneTabsheet := TOneTabsheet(slGeoffnetteTabsheets.Objects[i]);
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

  for i := 0 to slGeoffnetteTabsheets.Count - 1 do
  begin
    myOneTabsheet := TOneTabsheet(slGeoffnetteTabsheets.Objects[i]);
    if myOneTabsheet.Tabsheet = myActiveTabsheet then
    begin
      Result := slGeoffnetteTabsheets[i];
    end;
  end;

end;




end.
