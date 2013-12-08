unit angFrmMainController;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,angPKZ,ComCtrls,SynMemo;


type

  { TFrmMainController }

  { TOneFileInfo }

  TOneFileInfo = class
    public
    slFileInhalt : TStringlist;
    slDependencyInjektionNamen : TStringlist;

    pTreenodeInView : TObject;
    constructor create;
    destructor destroy; override;
  end;


    TOneTabsheet = class
    public
     Tabsheet :   TTabSheet;
     SynMemo : TsynMemo;
  end;


  TFrmMainController = class
  private
    slDJKeyWords : Tstringlist;
    function loeseCamelCaseAuf(sSuchtext: string): string;
    function SchluesselwortInZeileGefundenUndStringInKlammern(sZeile,sSchluesselwort: string; oneFileInfo : TOneFileInfo ;iImageindex : integer): boolean;
    procedure WerteDateiInhaltAus(sDateiname: string; oneFileInfo : TOneFileInfo);
  public
      sPfad : string;
      slAllFilesFound : TStringlist;
      slController : TStringlist;
      slModule     : TStringlist;
      slService    : TStringlist;
      slFactory    : TStringlist;
      slFilter     : TStringlist;
      slDirective  : TStringlist;
      slConfig     : TStringlist;

      myActiveTabsheet : TTabSheet;
      myActiveSynMemo : TsynMemo;

      slGeoffnetteTabsheets : TStringlist;


      function GetslDJKeyWords: TStringlist;
      procedure ClearAll;
      function sucheDateinameZuDataPointer(p: Tobject): string;
      procedure AddOneFileInSL(sPath : string ; treenode : TObject);
      function sucheoneFileInfoZuDataPointer(p: TObject): TOneFileInfo;
      procedure FuelleSlMitDateinDieDiesesWortEnthalten(sl: TStringlist; sSuchtext: string);
      constructor create;
      destructor destroy; override;
  end;


implementation

{ TOneFileInfo }

constructor TOneFileInfo.create;
begin
  slFileInhalt := TStringlist.create;
  slDependencyInjektionNamen := TStringlist.create;
end;

destructor TOneFileInfo.destroy;
begin
  slFileInhalt.free;
  slDependencyInjektionNamen.free;
  inherited destroy;
end;

{ TFrmMainController }

constructor TFrmMainController.create;
begin
  sPfad := '';
  slAllFilesFound := TStringlist.create;
  slAllFilesFound.OwnsObjects:=true;

  slController := TStringlist.create;
  slModule     := TStringlist.create;
  slService    := TStringlist.create;
  slFactory    := TStringlist.create;
  slFilter     := TStringlist.create;
  slDirective  := TStringlist.create;
  slConfig     := TStringlist.create;
  slDJKeyWords := Tstringlist.create;

  slGeoffnetteTabsheets := TStringlist.create;
  slGeoffnetteTabsheets.OwnsObjects:=true;
end;

destructor TFrmMainController.destroy;
begin
  slAllFilesFound.free;

  slController.free;
  slModule.free;
  slService.free;
  slFactory.free;
  slFilter.free;
  slDirective.free;
  slConfig.free;
  slDJKeyWords.free;

  slGeoffnetteTabsheets.free;


  inherited destroy;
end;

function TFrmMainController.SchluesselwortInZeileGefundenUndStringInKlammern(sZeile ,sSchluesselwort : string; oneFileInfo : TOneFileInfo;iImageindex : integer ) : boolean;
var i : integer;
s2: string;
begin
result := false;

i := pos(sSchluesselwort,sZeile);
if  i  > 0 then
  begin
  s2 := copy(sZeile,i + length(sSchluesselwort) , length(sZeile));

  if s2 <> '' then
    if s2[1] = '(' then    //find the Word in ("xxxx")
      begin
      delete(s2,1,1);
      if s2 <> '' then
        begin
        if s2[1] = #39 then
          begin
          delete(s2,1,1);
          if pos(#39,s2 ) > 0 then
            begin
            s2 := copy(s2,1,pos(#39,s2 )-1);
            result := true;
            end;
          end;

        if s2[1] = '"' then
          begin
          delete(s2,1,1);
          if pos('"',s2 ) > 0 then
            begin
            s2 := copy(s2,1,pos('"',s2 )-1);
            result := true;
            end;
          end;

        if result then
          oneFileInfo.slDependencyInjektionNamen.AddObject(s2,TObject(iImageindex));

        if pos('function',trim(s2)) = 1 then    //anonyme Funktion
          result := true;

        end;
      end;

  end;

end;

procedure TFrmMainController.WerteDateiInhaltAus(sDateiname : string ; oneFileInfo : TOneFileInfo );
var
s : string;
i : integer;
boolModuleGefunden : boolean;
boolControllerGefunden : boolean;
boolServiceGefunden : boolean;
boolFactoryGefunden : boolean;
boolFilterGefunden : boolean;
boolDirectiveGefunden :boolean;
boolConfigGefunden :boolean;
ZeileVerarbeitet : boolean  ;
sDateiNameOhneRootPfad : string;
sExt: string;
begin
boolModuleGefunden := false;
boolControllerGefunden := false;
boolServiceGefunden := false;
boolFactoryGefunden := false;
boolFilterGefunden := false;
boolDirectiveGefunden := false;
boolConfigGefunden := false;

sExt := uppercase(ExtractFileExt(sDateiname));

if (sExt = '.HTML') or (sExt = '.HTM')    then
  oneFileInfo.slFileInhalt.loadfromfile(sDateiname)
else
if sExt = '.JS'    then
  begin
  sDateiNameOhneRootPfad := copy(sDateiname,length(self.sPfad) + 1,length(sDateiname)) ;


  oneFileInfo.slFileInhalt.loadfromfile(sDateiname);
  for i := 0 to oneFileInfo.slFileInhalt.count -1 do
    begin
    s := oneFileInfo.slFileInhalt[i];
    ZeileVerarbeitet := false  ;

    if i < 5 then  //  ignore  Angular Files
      if pos('Google, Inc. http://angularjs.org',s) > 0 then
        if pos('(c)',s) > 0 then
          break;



      if not ZeileVerarbeitet then
        if SchluesselwortInZeileGefundenUndStringInKlammern(s,'.controller',oneFileInfo,constItemIndexController) then
          begin
          if not boolControllerGefunden then
            slController.addobject(sDateiNameOhneRootPfad,oneFileInfo.pTreenodeInView);

          boolControllerGefunden := true;
          ZeileVerarbeitet := true;
          end;

    if not boolFilterGefunden then
      if not ZeileVerarbeitet then
        if SchluesselwortInZeileGefundenUndStringInKlammern(s,'.filter',oneFileInfo,constItemIndexFilter) then
          begin
          slFilter.addobject(sDateiNameOhneRootPfad,oneFileInfo.pTreenodeInView);
          boolFilterGefunden := true;
          ZeileVerarbeitet := true;
          end;

    if not boolServiceGefunden then
      if not ZeileVerarbeitet then
        if SchluesselwortInZeileGefundenUndStringInKlammern(s,'.service',oneFileInfo,constItemIndexService) then
          begin
          slService.addobject(sDateiNameOhneRootPfad,oneFileInfo.pTreenodeInView);
          boolServiceGefunden := true;
          ZeileVerarbeitet := true;
          end;

    if not boolDirectiveGefunden then
      if not ZeileVerarbeitet then
        if SchluesselwortInZeileGefundenUndStringInKlammern(s,'.directive',oneFileInfo,constItemIndexDirective) then
          begin
          slDirective.addobject(sDateiNameOhneRootPfad,oneFileInfo.pTreenodeInView);
          boolDirectiveGefunden := true;
          ZeileVerarbeitet := true;
          end;

    if not boolFactoryGefunden then
      if not ZeileVerarbeitet then
        if  SchluesselwortInZeileGefundenUndStringInKlammern(s,'.factory',oneFileInfo,constItemIndexFactory) then
          begin
          slFactory.addobject(sDateiNameOhneRootPfad,oneFileInfo.pTreenodeInView);
          boolFactoryGefunden := true;
          ZeileVerarbeitet := true;
          end;

    if not boolConfigGefunden then
      if not ZeileVerarbeitet then
        if  SchluesselwortInZeileGefundenUndStringInKlammern(s,'.config',oneFileInfo,constItemIndexConfig) then
          begin
          slConfig.addobject(sDateiNameOhneRootPfad,oneFileInfo.pTreenodeInView);
          boolConfigGefunden := true;
          ZeileVerarbeitet := true;
          end;

    if not boolModuleGefunden then
      if not ZeileVerarbeitet then
        if SchluesselwortInZeileGefundenUndStringInKlammern(s,'angular.module',oneFileInfo,constItemIndexModule)  then
          begin
          slModule.addobject(sDateiNameOhneRootPfad,oneFileInfo.pTreenodeInView);
          boolModuleGefunden := true;
          ZeileVerarbeitet := true;
          end;


    end;

  end;

end;

procedure TFrmMainController.ClearAll;
begin
slAllFilesFound.clear;
slController.clear;
slModule.clear;
slService.clear;
slFactory.clear;
slFilter.clear;
slDirective.clear;
slConfig.clear;
end;

procedure TFrmMainController.AddOneFileInSL(sPath : string ; treenode : TObject);
var oneFileInfo : TOneFileInfo;
begin

oneFileInfo := TOneFileInfo.create;
oneFileInfo.pTreenodeInView:=treenode;

slAllFilesFound.AddObject(sPath,oneFileInfo);

WerteDateiInhaltAus(sPath,oneFileInfo)

end;

function TFrmMainController.sucheDateinameZuDataPointer(p: TObject): string;
var i : integer;
oneFileInfo : TOneFileInfo;
begin
result :=  '';
for i := 0 to self.slAllFilesFound.Count -1 do
  begin
  oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
  if  oneFileInfo.pTreenodeInView = p then
    begin
    result := slAllFilesFound[i];
    break;
    end;
  end;
end;

function TFrmMainController.sucheoneFileInfoZuDataPointer(p: TObject): TOneFileInfo;
var i : integer;
oneFileInfo : TOneFileInfo;
begin
result :=  nil;
for i := 0 to self.slAllFilesFound.Count -1 do
  begin
  oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]);
  if  oneFileInfo.pTreenodeInView = p then
    begin
    result := oneFileInfo;
    break;
    end;
  end;
end;




function TFrmMainController.GetslDJKeyWords : TStringlist;
var i,n : integer;
oneFileInfo : TOneFileInfo;
begin
slDJKeyWords.clear;
slDJKeyWords.sorted := true;

for i := 0 to slAllFilesFound.count -1 do
  begin
  oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]) ;
  for n := 0 to oneFileInfo.slDependencyInjektionNamen.count -1 do
    slDJKeyWords.AddObject(oneFileInfo.slDependencyInjektionNamen[n],oneFileInfo.slDependencyInjektionNamen.objects[n] );


  end;

result := slDJKeyWords;
end;

function  TFrmMainController.loeseCamelCaseAuf(sSuchtext : string): string;
var i : integer;
boolGross : boolean;
begin
result := '';
for i := 1 to length(sSuchtext) do
  begin
  boolGross := false;
  if  Ord(sSuchtext[i]) >= ORD('A') then
    if  Ord(sSuchtext[i]) <= ORD('Z') then
      boolGross := true;

  if boolGross then
    result := result + '-'+  lowercase(sSuchtext[i])
  else
    result := result +sSuchtext[i];


  end;
end;


Procedure TFrmMainController.FuelleSlMitDateinDieDiesesWortEnthalten(sl : TStringlist; sSuchtext : string) ;
var i: integer;
oneFileInfo : TOneFileInfo;
sDateiNameOhneRootPfad : string;
gefunden : boolean ;
sInhalt : string;
sCamelCaseAufgeloest : string;
begin

sCamelCaseAufgeloest := loeseCamelCaseAuf(sSuchtext);

for i := 0 to slAllFilesFound.count -1 do
  begin
  oneFileInfo := TOneFileInfo(slAllFilesFound.Objects[i]) ;
  gefunden := false;
  sInhalt := oneFileInfo.slFileInhalt.text;
  if pos( sSuchtext, sInhalt ) > 0 then
    gefunden := true
  else
    begin


    if sCamelCaseAufgeloest <>  sSuchtext then
      if pos( sCamelCaseAufgeloest, sInhalt ) > 0 then
        gefunden := true
    end;


  if gefunden then
    begin
    sDateiNameOhneRootPfad := copy(slAllFilesFound[i],length(self.sPfad) + 1,length(slAllFilesFound[i])) ;
    sl.AddObject(sDateiNameOhneRootPfad,oneFileInfo.pTreenodeInView  );

    end;
  end;
end;





end.

