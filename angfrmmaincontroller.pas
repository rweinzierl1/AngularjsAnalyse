unit angFrmMainController;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, angPKZ, ComCtrls, SynMemo, strutils, Graphics,
  inifiles, SynEditMarks, angSnippet, SynCompletion, angPasteHistorie;

type


  TOneDIWordFound = class(TObject)

  public
    iLineNr: integer;
    iImageindex: integer;
    sDirectiveRestrict: string;

  end;


  { TOneDIWordFoundList }

  TOneDIWordFoundList = class(TStringList)

  public
    function OneDIWordFound(i: integer): TOneDIWordFound;
    constructor Create;

  end;


  TOneBookMark = class(TObject)
  public
    iBookmarkNr: integer;
    iLineNr: integer;
    sLine: string;
    sFileName: string;
    boolAktiveTab: boolean;
  end;



  TOneFileInfo = class
  public
    slFileInhalt: TStringList;
    slDependencyInjektionNamen: TOneDIWordFoundList;
    slScopeActions: TStringList;
    slngLines: TStringList;
    slngWords: TStringList;
    iImageindex: integer;
    modifiedDateTime: TDatetime;

    pTreenodeInView: TObject;
    constructor Create;
    destructor Destroy; override;
  end;

  { TOneColorScheme }

  TOneColorScheme = class
  public
    sName: string;
    Color: Tcolor;
    Font: TFont;
    constructor Create;
    destructor Destroy;
  end;


  { TColorSchemeList }

  TColorSchemeList = class(TStringList)

  public
    activeColorScheme: TOneColorScheme;
    constructor Create;

  end;

  { TOneTabsheet }

  TOneTabsheet = class
  private

  public
    Tabsheet: TTabSheet;
    SynMemo: TsynMemo;
    SynMemoPreview: TsynMemo;
    SynCompletion: TSynCompletion;
    sFileName: string;

    procedure setPreviewText;
    procedure setCarentFromPreviewToEdit;
    procedure setCarentFromEditToPreview;
    procedure SchemeFromEditToPreview;
    procedure setActiveColorScheme(OneColorScheme: TOneColorScheme);
    procedure InfoToPreviewForToplineChanged;
    procedure InfoToPreviewSelectionChanged;
  end;


  { TOpenedTabsheetList }

  TOpenedTabsheetList = class(TStringList)
  public
    constructor Create;
    function OneTabsheet(i: integer): TOneTabsheet;
  end;


  { TUserPropertys }

  TUserPropertys = class
  private
    sConfigFileName: string;
  public
    iFontsize: integer;
    sSchema: string;
    boolAutoSave: boolean;
    slRecentPath: TStringList;
    procedure LoadFromConfigFile;
    procedure SaveConfigFile;
    constructor Create;
    destructor Destroy; override;
  end;


  { TFilesFoundList }

  TFilesFoundList = class(TStringList)
  public
    function OneFileInfo(i: integer): TOneFileInfo;
    constructor Create(boolOwnObject: boolean; boolDuplicates: boolean);
  end;




  { TFrmMainController }

  TFrmMainController = class
  private
    FsPfad: string;
    slDJKeyWords: TStringList;
    slAllScope: TStringList;
    procedure LookForNgInString(sLine: string; oneFileInfo: TOneFileInfo);
    procedure LookForScopeInString(sLine: string; oneFileInfo: TOneFileInfo);

    function KeysWordInLineAndStringInBrackets(iLineNr: integer;
      sZeile, sSchluesselwort: string; oneFileInfo: TOneFileInfo;
      iImageindex: integer): boolean;
    procedure AnalyzeFileContent(sDateiname: string; oneFileInfo: TOneFileInfo);
    procedure SearchForNGInFile(oneFileInfo: TOneFileInfo);
    procedure SearchForRestrictInSlDirective;
    procedure SetsPfad(AValue: string);


  public

    slAllFilesFound: TFilesFoundList;
    slController: TFilesFoundList;
    slModule: TFilesFoundList;
    slService: TFilesFoundList;
    slFactory: TFilesFoundList;
    slFilter: TFilesFoundList;
    slDirective: TFilesFoundList;
    slConfig: TFilesFoundList;
    myActiveOneTabsheet: TOneTabsheet;
    slOpendTabsheets: TOpenedTabsheetList;
    sLastSearch: string;
    slColorScheme: TColorSchemeList;
    UserPropertys: TUserPropertys;
    AngIntellisence: TAngIntellisence;

    AngClipboardHistorieList: TAngClipboardHistorieList;

    procedure ReplaceSnippetInserts(var sContent: string);
    function IsHTMLTagSelfClosing(s: string): boolean;
    function ChangeMinusToCamelCase(sSuchtext: string): string;
    function ChangeCamelCaseToMinusString(sSuchtext: string): string;
    function GetFilenameWithoutRootPath(sDateiname: string): string;
    function GetslDJKeyWords: TStringList;
    function GetslAllScope: TStringList;
    procedure ClearAll;
    function findFileNameToDataPointer(p: TObject): string;
    function AddOneFileInSL(sPath: string; treenode: TObject): TOneFileInfo;
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
    function GetFileNameToPartFileName(sPart: string): string;
    function getContentToFilename(sFilename: string): string;
    procedure GetAllBookmarks(slBookmarks: TStringList);
    procedure SetTabsheetAktivForFile(sFile: string);
    function GetSynMemoForFile(sFile: string): TSynMemo;
    function CalculateIndexOfFileExtension(sMyFileName: string): integer;
    procedure GetAllHtmlFiles(sl: TStringList);
    procedure GetAllUsedNgKeyWords(sl: TStringList);
    function FindTreenodePointerToFilename(sFilename: string): TObject;
    function GetAngularTypesForFile(sFile: string): string;
    procedure SetHeightToAllSynedit;
    procedure DeleteAllMarksWithIndexIndexMarkFound;
    property sPfad: string read FsPfad write SetsPfad;
    procedure AddAllProjectWordsToIntellisence;
    function ActiveSynMemoIsHTMLAndCarentInSquareBrackets : boolean;
    constructor Create;
    destructor Destroy; override;
  end;


implementation

{ TOneDIWordFoundList }

function TOneDIWordFoundList.OneDIWordFound(i: integer): TOneDIWordFound;
begin
  Result := TOneDIWordFound(self.Objects[i]);
end;

constructor TOneDIWordFoundList.Create;
begin
  self.OwnsObjects := True;
end;

{ TFilesFoundList }

function TFilesFoundList.OneFileInfo(i: integer): TOneFileInfo;
begin
  Result := TOneFileInfo(self.Objects[i]);
end;

constructor TFilesFoundList.Create(boolOwnObject: boolean; boolDuplicates: boolean);
begin
  if boolOwnObject then
    self.OwnsObjects := True;



  if not boolDuplicates then
  begin
    self.Sorted := True;
    self.Duplicates := dupIgnore;
  end;

end;

{ TOpenedTabsheetList }

constructor TOpenedTabsheetList.Create;
begin
  self.OwnsObjects := True;
end;

function TOpenedTabsheetList.OneTabsheet(i: integer): TOneTabsheet;
begin
  Result := TOneTabsheet(self.Objects[i]);
end;

{ TUserPropertys }

procedure TUserPropertys.LoadFromConfigFile;
var
  myIni: TIniFile;
  i: integer;
  s: string;
begin
  if fileexists(sConfigFileName) then
  begin
    myIni := TIniFile.Create(sConfigFileName);
    self.iFontsize := myIni.ReadInteger('init', 'Fontsize', iFontsize);
    self.sSchema := myIni.ReadString('init', 'Schema', sSchema);
    self.boolAutoSave := myIni.ReadBool('init', 'Autosave', boolAutoSave);
    slRecentPath.Clear;
    for i := 0 to 9 do
    begin
      s := myIni.ReadString('init', 'Recentpath' + IntToStr(i), '');
      if s <> '' then
        if DirectoryExists(s) then
          slRecentPath.add(s);
    end;
    myIni.Free;
  end;
end;

procedure TUserPropertys.SaveConfigFile;
var
  myIni: TIniFile;
var
  i: integer;
begin
  forcedirectories(extractfilepath(sConfigFileName));

  myIni := TIniFile.Create(sConfigFileName);
  myIni.WriteInteger('init', 'Fontsize', iFontsize);
  myIni.WriteString('init', 'Schema', sSchema);
  myIni.WriteBool('init', 'Autosave', boolAutoSave);

  for i := 0 to 9 do
  begin
    if i < slRecentPath.Count then
      myIni.WriteString('init', 'Recentpath' + IntToStr(i), slRecentPath[i])
    else
      myIni.WriteString('init', 'Recentpath' + IntToStr(i), '');
  end;

  myIni.Free;

end;

constructor TUserPropertys.Create;
begin
  slRecentPath := TStringList.Create;

  iFontsize := 10;
  sSchema := 'dark';
  boolAutoSave := False;
  sConfigFileName := GetAppConfigFile(False);
  LoadFromConfigFile;

end;

destructor TUserPropertys.Destroy;
begin
  SaveConfigFile;
  slRecentPath.Free;
  inherited Destroy;
end;

{ TOneTabsheet }

procedure TOneTabsheet.setPreviewText;
begin

  SynMemoPreview.Highlighter := SynMemo.Highlighter;
  SynMemoPreview.Lines.Assign(SynMemo.Lines);

  SynMemoPreview.CaretY := SynMemo.CaretY;

end;

procedure TOneTabsheet.setCarentFromPreviewToEdit;
begin

  SynMemo.CaretY := SynMemoPreview.CaretY;
  SynMemo.CaretX := SynMemoPreview.CaretX;
  SynMemoPreview.Repaint;

end;

procedure TOneTabsheet.setCarentFromEditToPreview;
begin
  SynMemoPreview.CaretY := SynMemo.CaretY;
  //SynMemoPreview.CaretX :=  SynMemo.CaretX  ;
  SynMemoPreview.Repaint;
end;

procedure TOneTabsheet.SchemeFromEditToPreview;
begin
  SynMemoPreview.Color := SynMemo.Color;
  SynMemoPreview.Font.Color := SynMemo.Font.Color;

  SynMemoPreview.Repaint;
end;

procedure TOneTabsheet.setActiveColorScheme(OneColorScheme: TOneColorScheme);
begin
  SynMemo.Color := OneColorScheme.Color;
  SynMemo.Font.Color := OneColorScheme.Font.Color;

  SynMemo.Refresh;
  SchemeFromEditToPreview;
end;

procedure TOneTabsheet.InfoToPreviewForToplineChanged;
var
  i, i2: integer;
begin

  i := SynMemo.TopLine;
  i2 := self.SynMemoPreview.TopLine;
  if i < i2 then
  begin
    self.SynMemoPreview.TopLine := i;
  end;


  i := SynMemo.TopLine + SynMemo.LinesInWindow;
  i2 := self.SynMemoPreview.TopLine + self.SynMemoPreview.LinesInWindow;

  if i > i2 then
  begin
    self.SynMemoPreview.TopLine := self.SynMemoPreview.TopLine + i - i2;
  end;

  self.SynMemoPreview.Repaint;

end;

procedure TOneTabsheet.InfoToPreviewSelectionChanged;
//var s: string;
begin
  //TODO Show the selText in Preview highlighted

  //s :=  self.SynMemo.SelText;
  //if length(s) > 10 then
  //  begin
  //  self.SynMemoPreview.SelStart := self.SynMemo.SelStart;
  //  self.SynMemoPreview.SelEnd := self.SynMemo.SelEnd;
  //  end;
  self.SynMemoPreview.Repaint;
end;


{ TOneColorScheme }

constructor TOneColorScheme.Create;
begin
  Font := TFont.Create;
end;

destructor TOneColorScheme.Destroy;
begin
  Font.Free;
end;

{ TColorSchemeList }

constructor TColorSchemeList.Create;
var
  sr: TSearchRec;
  i: integer;
  sPath: string;
  OneScheme: TOneColorScheme;
  myIni: TIniFile;
  sName: string;
begin
  self.OwnsObjects := True;

  sPath := Extractfilepath(ParamStr(0)) + 'ColorScheme';

  i := FindFirst(sPath + sAngSeparator + '*.ini', faAnyFile, sr);
  while (i = 0) do
  begin
    OneScheme := TOneColorScheme.Create;

    sName := ansireplacestr(sr.Name, '.ini', '');
    self.AddObject(sName, OneScheme);
    myIni := TIniFile.Create(sPath + sAngSeparator + sr.Name);
    OneScheme.Color := myIni.Readinteger('Font', 'Color', clWhite);
    OneScheme.sName := sName;
    OneScheme.Font.Color := myIni.Readinteger('Font.Color', 'Color', clBlack);
    ;
    myIni.Free;

    i := Findnext(sr);
  end;
  FindClose(sr);

  activeColorScheme := nil;

end;

{ TOneFileInfo }

constructor TOneFileInfo.Create;
begin
  slFileInhalt := TStringList.Create;
  slDependencyInjektionNamen := TOneDIWordFoundList.Create;
  slScopeActions := TStringList.Create;
  slngLines := TStringList.Create;
  slngWords := TStringList.Create;
  slngWords.Sorted := True;
  slngWords.Duplicates := dupIgnore;
  iImageindex := -1;

end;

destructor TOneFileInfo.Destroy;
begin
  slFileInhalt.Free;
  slDependencyInjektionNamen.Free;
  slScopeActions.Free;
  slngLines.Free;
  slngWords.Free;
  inherited Destroy;
end;

{ TFrmMainController }

constructor TFrmMainController.Create;
begin
  sPfad := '';
  slAllFilesFound := TFilesFoundList.Create(True, True);


  slController := TFilesFoundList.Create(False, False);
  slModule := TFilesFoundList.Create(False, False);
  slService := TFilesFoundList.Create(False, False);
  slFactory := TFilesFoundList.Create(False, False);
  slFilter := TFilesFoundList.Create(False, False);
  slDirective := TFilesFoundList.Create(False, False);
  slConfig := TFilesFoundList.Create(False, False);
  slDJKeyWords := TStringList.Create;
  slAllScope := TStringList.Create;

  slOpendTabsheets := TOpenedTabsheetList.Create;

  slColorScheme := TColorSchemeList.Create;

  UserPropertys := TUserPropertys.Create;



  AngIntellisence := TAngIntellisence.Create;
  AngClipboardHistorieList := TAngClipboardHistorieList.Create;

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
  slAllScope.Free;

  slOpendTabsheets.Free;

  slColorScheme.Free;
  UserPropertys.Free;
  AngIntellisence.Free;
  AngClipboardHistorieList.Free;

  inherited Destroy;
end;

function TFrmMainController.KeysWordInLineAndStringInBrackets(iLineNr: integer;
  sZeile, sSchluesselwort: string; oneFileInfo: TOneFileInfo;
  iImageindex: integer): boolean;
var
  i: integer;
  s2: string;

  OneDIWordFound: TOneDIWordFound;
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

          if pos('+', s2) > 0 then
            Result := False; //TODO make it better

          if pos(':', s2) > 0 then
            Result := False; //TODO make it better

          if Result then
          begin
            OneDIWordFound := TOneDIWordFound.Create;
            OneDIWordFound.iImageindex := iImageindex;
            OneDIWordFound.iLineNr := iLineNr;
            oneFileInfo.slDependencyInjektionNamen.AddObject(s2, OneDIWordFound);

          end;

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
  ThisAge: longint;
begin
  boolModuleGefunden := False;
  boolControllerGefunden := False;
  boolServiceGefunden := False;
  boolFactoryGefunden := False;
  boolFilterGefunden := False;
  boolDirectiveGefunden := False;
  boolConfigGefunden := False;

  sExt := uppercase(ExtractFileExt(sDateiname));

  oneFileInfo.iImageindex := CalculateIndexOfFileExtension(sDateiname);

  if (sExt = '.HTML') or (sExt = '.HTM') or (sExt = '.CSS') then
  begin
    oneFileInfo.slFileInhalt.loadfromfile(sDateiname);
    SearchForNGInFile(oneFileInfo);

    ThisAge := FileAge(sDateiname);
    oneFileInfo.modifiedDateTime := FileDateToDateTime(ThisAge);

  end
  else
  if sExt = '.JS' then
  begin
    sDateiNameOhneRootPfad := GetFilenameWithoutRootPath(sDateiname);
    ThisAge := FileAge(sDateiname);
    oneFileInfo.modifiedDateTime := FileDateToDateTime(ThisAge);

    if pos('angular', ExtractFileName(sDateiname)) = 0 then   //  ignore  Angular Files
      oneFileInfo.slFileInhalt.loadfromfile(sDateiname);
    for i := 0 to oneFileInfo.slFileInhalt.Count - 1 do
    begin
      s := oneFileInfo.slFileInhalt[i];
      ZeileVerarbeitet := False;

      if i < 5 then  //  ignore  Angular Files
        if pos('Google', s) > 0 then
          if pos('Inc. http://angularjs.org', s) > 0 then
            if pos('(c)', s) > 0 then
              break;



      if not ZeileVerarbeitet then
        if KeysWordInLineAndStringInBrackets(i, s, '.controller',
          oneFileInfo, constItemIndexController) then
        begin
          if not boolControllerGefunden then
            slController.addobject(sDateiNameOhneRootPfad, oneFileInfo);

          boolControllerGefunden := True;
          ZeileVerarbeitet := True;
        end;


      if not ZeileVerarbeitet then
        if KeysWordInLineAndStringInBrackets(i, s, '.filter',
          oneFileInfo, constItemIndexFilter) then
        begin
          if not boolFilterGefunden then
            slFilter.addobject(sDateiNameOhneRootPfad, oneFileInfo);
          boolFilterGefunden := True;
          ZeileVerarbeitet := True;
        end;


      if not ZeileVerarbeitet then
        if KeysWordInLineAndStringInBrackets(i, s, '.service',
          oneFileInfo, constItemIndexService) then
        begin
          if not boolServiceGefunden then
            slService.addobject(sDateiNameOhneRootPfad, oneFileInfo);
          boolServiceGefunden := True;
          ZeileVerarbeitet := True;
        end;

      if not ZeileVerarbeitet then
        if KeysWordInLineAndStringInBrackets(i, s, '.directive',
          oneFileInfo, constItemIndexDirective) then
        begin
          if not boolDirectiveGefunden then
            slDirective.addobject(sDateiNameOhneRootPfad, oneFileInfo);
          boolDirectiveGefunden := True;
          ZeileVerarbeitet := True;
        end;


      if not ZeileVerarbeitet then
        if KeysWordInLineAndStringInBrackets(i, s, '.factory',
          oneFileInfo, constItemIndexFactory) then
        begin
          if not boolFactoryGefunden then
            slFactory.addobject(sDateiNameOhneRootPfad, oneFileInfo);
          boolFactoryGefunden := True;
          ZeileVerarbeitet := True;
        end;


      if not ZeileVerarbeitet then
        if KeysWordInLineAndStringInBrackets(i, s, '.config',
          oneFileInfo, constItemIndexConfig) then
        begin
          if not boolConfigGefunden then
            slConfig.addobject(sDateiNameOhneRootPfad, oneFileInfo);
          boolConfigGefunden := True;
          ZeileVerarbeitet := True;
        end;


      if not ZeileVerarbeitet then
        if KeysWordInLineAndStringInBrackets(i, s, 'angular.module',
          oneFileInfo, constItemIndexModule) then
        begin
          if not boolModuleGefunden then
            slModule.addobject(sDateiNameOhneRootPfad, oneFileInfo);
          boolModuleGefunden := True;
          ZeileVerarbeitet := True;
        end;

      LookForScopeInString(s, oneFileInfo);
    end;
  end;
end;

procedure TFrmMainController.SearchForNGInFile(oneFileInfo: TOneFileInfo);
var
  i: integer;
  s: string;
begin
  for i := 0 to oneFileInfo.slFileInhalt.Count - 1 do
  begin
    s := oneFileInfo.slFileInhalt[i];
    LookForNgInString(s, oneFileInfo);
  end;
end;

procedure TFrmMainController.SetsPfad(AValue: string);
var
  iOld: integer;
begin
  if FsPfad = AValue then
    Exit;
  FsPfad := AValue;

  iOld := UserPropertys.slRecentPath.IndexOf(AValue);

  if iOld >= 0 then
    self.UserPropertys.slRecentPath.Exchange(iOld, 0)
  else
    self.UserPropertys.slRecentPath.Insert(0, AValue);

  self.AngIntellisence.AngSnippetList.LoadFromDir(AValue + sAngSeparator +
    '.AngularAnalyse' + sAngSeparator, snippetProject);
  self.AngIntellisence.AngComponentProjectList.Clear;
end;

procedure TFrmMainController.LookForNgInString(sLine: string;
  oneFileInfo: TOneFileInfo);
var
  i, i2, i3: integer;
  sWord: string;
  boolOK: boolean;
begin
  repeat
    i := pos('ng-', sLine);
    if i > 0 then
    begin
      boolOK := True;
      i2 := pos('//', sLine);
      if i2 > 0 then
        if i2 < i then
          boolOK := False; //Todo To simple

      if copy(trim(sLine), 1, 1) = '*' then
        boolOK := False; //Todo To simple

      if i > 1 then
        if (sline[i - 1] in ['A'..'Z']) or (sline[i - 1] in ['a'..'z']) then
          if sline[i - 1] <> ' ' then
            boolOK := False;


      if boolOK then
      begin
        oneFileInfo.slngLines.Add(trim(sLine));

        sWord := '';
        for i3 := i to length(sLine) do
        begin
          if (sline[i3] in ['A'..'Z']) or (sline[i3] in ['a'..'z']) or
            (sline[i3] = '-') then
            sWord := sWord + sline[i3]
          else
            break;
        end;

        oneFileInfo.slngWords.add(sWord);

      end;


      Delete(sline, 1, i);
    end;

  until i = 0;
end;

procedure TFrmMainController.LookForScopeInString(sLine: string;
  oneFileInfo: TOneFileInfo);
var
  i, i2: integer;
  boolOK: boolean;
begin
  i := pos('scope.', sLine);
  if i > 0 then
  begin
    boolOK := True;
    i2 := pos('//', sLine);
    if i2 > 0 then
      if i2 < i then
        boolOK := False; //Todo To simple

    if copy(trim(sLine), 1, 1) = '*' then
      boolOK := False; //Todo To simple


    if boolOK then
      oneFileInfo.slScopeActions.Add(trim(sLine));

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

function TFrmMainController.AddOneFileInSL(sPath: string;
  treenode: TObject): TOneFileInfo;
var
  oneFileInfo: TOneFileInfo;
begin

  oneFileInfo := TOneFileInfo.Create;
  oneFileInfo.pTreenodeInView := treenode;

  slAllFilesFound.AddObject(sPath, oneFileInfo);

  AnalyzeFileContent(sPath, oneFileInfo);

  Result := oneFileInfo;

end;

function TFrmMainController.FindTreenodePointerToFilename(sFilename: string): TObject;
var
  i: integer;
  oneFileInfo: TOneFileInfo;
begin
  Result := nil;
  for i := 0 to self.slAllFilesFound.Count - 1 do
  begin
    if self.slAllFilesFound[i] = sFilename then
    begin
      oneFileInfo := slAllFilesFound.OneFileInfo(i);
      Result := oneFileInfo.pTreenodeInView;
      break;
    end;
  end;
end;

function TFrmMainController.GetAngularTypesForFile(sFile: string): string;
var
  i: integer;
  oneFileInfo: TOneFileInfo;
begin
  Result := '';

  if slModule.IndexOf(sFile) >= 0 then
    Result := Result + 'Module |';
  if slController.IndexOf(sFile) >= 0 then
    Result := Result + 'Controller |';
  if slService.IndexOf(sFile) >= 0 then
    Result := Result + 'Service |';
  if slFactory.IndexOf(sFile) >= 0 then
    Result := Result + 'Factory |';
  if slFilter.IndexOf(sFile) >= 0 then
    Result := Result + 'Filter |';
  if slDirective.IndexOf(sFile) >= 0 then
    Result := Result + 'Directive |';
  if slConfig.IndexOf(sFile) >= 0 then
    Result := Result + 'Config |';

end;

function TFrmMainController.findFileNameToDataPointer(p: TObject): string;
var
  i: integer;
  oneFileInfo: TOneFileInfo;
begin
  Result := '';
  for i := 0 to self.slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := slAllFilesFound.OneFileInfo(i);
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
    oneFileInfo := slAllFilesFound.OneFileInfo(i);
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
    oneFileInfo := slAllFilesFound.OneFileInfo(i);
    for n := 0 to oneFileInfo.slScopeActions.Count - 1 do
      slAllScope.Add(oneFileInfo.slScopeActions[n]);

  end;

  Result := slAllScope;
end;

function TFrmMainController.GetFilenameToKeyword(sKeyWord: string): string;
var
  i, n: integer;
  oneFileInfo: TOneFileInfo;
begin
  Result := '';
  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := slAllFilesFound.OneFileInfo(i);
    for n := 0 to oneFileInfo.slDependencyInjektionNamen.Count - 1 do
      if oneFileInfo.slDependencyInjektionNamen[n] = sKeyWord then
        Result := slAllFilesFound[i];
  end;

end;

function TFrmMainController.GetFileNameToPartFileName(sPart: string): string;
var
  i, n: integer;
  oneFileInfo: TOneFileInfo;
  sPart2, sFileUpper: string;
begin
  Result := '';
  sPart2 := uppercase(sPart);


 {$ifdef Unix}
  {$else}
  sPart2 := ansireplacestr(sPart2, '/', '\');

 {$endif}

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := slAllFilesFound.OneFileInfo(i);
    if oneFileInfo.iImageindex <> constItemIndexUnknownFile then
    begin
      sFileUpper := uppercase(slAllFilesFound[i]);
      if pos(sPart2, sFileUpper) > 0 then
      begin
        Result := slAllFilesFound[i];
        break;
      end;

    end;
  end;

end;



function TFrmMainController.getContentToFilename(sFilename: string): string;
var
  i: integer;
  oneFileInfo: TOneFileInfo;
begin
  Result := '';

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    if slAllFilesFound[i] = sFilename then
    begin
      oneFileInfo := slAllFilesFound.OneFileInfo(i);
      Result := oneFileInfo.slFileInhalt.Text;
    end;
  end;
end;

procedure TFrmMainController.GetAllBookmarks(slBookmarks: TStringList);
var
  i, n: integer;
  OneTabsheet: TOneTabsheet;
  X, Y: integer;
  OneBookMark: TOneBookMark;
begin

  for i := 0 to slOpendTabsheets.Count - 1 do
  begin
    OneTabsheet := slOpendTabsheets.OneTabsheet(i);

    for n := 0 to 9 do
    begin
      x := 0;
      y := 0;

      if OneTabsheet.SynMemo.GetBookMark(n, X, Y) then
      begin
        OneBookMark := TOneBookMark.Create;
        OneBookMark.iBookmarkNr := n;
        OneBookMark.iLineNr := y - 1;
        OneBookMark.sLine := OneTabsheet.SynMemo.Lines[OneBookMark.iLineNr];
        OneBookMark.sFileName := slOpendTabsheets[i];

        if OneTabsheet.SynMemo = self.myActiveOneTabsheet.SynMemo then
          OneBookMark.boolAktiveTab := True
        else
          OneBookMark.boolAktiveTab := False;


        slBookmarks.AddObject(OneBookMark.sLine, OneBookMark);
      end;
    end;
  end;
end;

procedure TFrmMainController.SetTabsheetAktivForFile(sFile: string);
var
  i: integer;
  OneTabsheet: TOneTabsheet;
begin
  for i := 0 to slOpendTabsheets.Count - 1 do
  begin
    OneTabsheet := slOpendTabsheets.OneTabsheet(i);
    self.myActiveOneTabsheet := OneTabsheet;

  end;

end;


function TFrmMainController.GetSynMemoForFile(sFile: string): TSynMemo;
var
  i: integer;
  OneTabsheet: TOneTabsheet;
begin
  Result := nil;
  for i := 0 to slOpendTabsheets.Count - 1 do
  begin
    OneTabsheet := slOpendTabsheets.OneTabsheet(i);
    if slOpendTabsheets[i] = sFile then
      Result := OneTabsheet.SynMemo;
  end;

end;


function TFrmMainController.GetslDJKeyWords: TStringList;
var
  i, n: integer;
  oneFileInfo: TOneFileInfo;
  sl: TOneDIWordFoundList;
begin
  slDJKeyWords.Clear;
  slDJKeyWords.sorted := True;

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := slAllFilesFound.OneFileInfo(i);
    sl := oneFileInfo.slDependencyInjektionNamen;


    for n := 0 to sl.Count - 1 do
      slDJKeyWords.AddObject(sl[n], sl.OneDIWordFound(n));

  end;

  Result := slDJKeyWords;
end;



function TFrmMainController.ChangeMinusToCamelCase(sSuchtext: string): string;
var
  i: integer;
begin
  repeat
    i := pos('-', sSuchtext);
    if i > 0 then
    begin
      Delete(sSuchtext, i, 1);
      if length(sSuchtext) > i then
        sSuchtext[i] := uppercase(sSuchtext[i])[1];
    end;


  until i = 0;

  Result := sSuchtext;

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

function TFrmMainController.GetFilenameWithoutRootPath(sDateiname: string): string;
var
  sDateiNameOhneRootPfad: string;
begin
  sDateiNameOhneRootPfad := copy(sDateiname, length(self.sPfad) +
    1, length(sDateiname));
  Result := sDateiNameOhneRootPfad;
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
  sMinusToCamelcase: string;
begin

  sCamelCaseAufgeloest := ChangeCamelCaseToMinusString(sSuchtext);
  sMinusToCamelcase := ChangeMinusToCamelCase(sSuchtext);

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := slAllFilesFound.OneFileInfo(i);
    gefunden := False;
    sInhalt := oneFileInfo.slFileInhalt.Text;
    if pos(sSuchtext, sInhalt) > 0 then
      gefunden := True
    else
    begin

      if sCamelCaseAufgeloest <> sSuchtext then
        if pos(sCamelCaseAufgeloest, sInhalt) > 0 then
          gefunden := True;

      if not gefunden then
        if sMinusToCamelcase <> sSuchtext then
          if pos(sMinusToCamelcase, sInhalt) > 0 then
            gefunden := True;
    end;


    if gefunden then
    begin
      sDateiNameOhneRootPfad :=
        copy(slAllFilesFound[i], length(self.sPfad) + 1, length(slAllFilesFound[i]));
      sl.AddObject(sDateiNameOhneRootPfad, oneFileInfo);

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
    OneTabsheet := slOpendTabsheets.OneTabsheet(i);

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
    OneTabsheet := slOpendTabsheets.OneTabsheet(i);

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
    OneTabsheet := slOpendTabsheets.OneTabsheet(i);

    if OneTabsheet.Tabsheet = ActivePage then
    begin
      self.myActiveOneTabsheet := OneTabsheet;
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
    myOneTabsheet := slOpendTabsheets.OneTabsheet(i);
    if myOneTabsheet.Tabsheet = self.myActiveOneTabsheet.Tabsheet then
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
  iResult: integer;
  OneDIWordFound: TOneDIWordFound;
  sl: TOneDIWordFoundList;
begin
  iResult := -1;

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    if slAllFilesFound[i] = sFilename then
    begin
      oneFileInfo := slAllFilesFound.OneFileInfo(i);
      sl := oneFileInfo.slDependencyInjektionNamen;


      for n := 0 to sl.Count - 1 do
      begin
        OneDIWordFound := sl.OneDIWordFound(n);
        i1 := OneDIWordFound.iImageindex;
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


function TFrmMainController.CalculateIndexOfFileExtension(sMyFileName: string): integer;
var
  sExt: string;
begin
  Result := constItemIndexUnknownFile;

  sExt := uppercase(ExtractFileExt(sMyFileName));
  if sExt = '.JS' then
    Result := constItemIndexJavascript;
  if pos('.HTM', sExt) > 0 then
    Result := constItemIndexHTML;
  if sExt = '.CSS' then
    Result := constItemIndexCss;
end;

procedure TFrmMainController.GetAllHtmlFiles(sl: TStringList);
var
  sExt: string;
  i: integer;
  oneFileInfo: TOneFileInfo;
begin
  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    sExt := uppercase(ExtractFileExt(slAllFilesFound[i]));
    if pos('.HTM', sExt) > 0 then
    begin
      oneFileInfo := slAllFilesFound.OneFileInfo(i);
      sl.AddObject(GetFilenameWithoutRootPath(slAllFilesFound[i]),
        oneFileInfo);
    end;

  end;
end;

procedure TFrmMainController.GetAllUsedNgKeyWords(sl: TStringList);
var
  i, n: integer;
  oneFileInfo: TOneFileInfo;
begin

  for i := 0 to slAllFilesFound.Count - 1 do
  begin
    oneFileInfo := slAllFilesFound.OneFileInfo(i);
    for n := 0 to oneFileInfo.slngWords.Count - 1 do
      sl.add(oneFileInfo.slngWords[n]);

  end;

end;

procedure TFrmMainController.SetHeightToAllSynedit;
var
  i: integer;
  myOneTabsheet: TOneTabsheet;
begin

  for i := 0 to self.slOpendTabsheets.Count - 1 do
  begin
    myOneTabsheet := self.slOpendTabsheets.OneTabsheet(i);
    myOneTabsheet.SynMemo.Font.Size := self.UserPropertys.iFontsize;
  end;

end;


procedure TFrmMainController.DeleteAllMarksWithIndexIndexMarkFound;
var
  i: integer;
  m: TSynEditMark;
begin
  for i := self.myActiveOneTabsheet.SynMemo.Marks.Count - 1 downto 0 do
  begin
    m := self.myActiveOneTabsheet.SynMemo.Marks[i];
    if m.ImageIndex = constItemIndexMarkFound then
      self.myActiveOneTabsheet.SynMemo.Marks.Delete(i);
  end;
end;

procedure TFrmMainController.SearchForRestrictInSlDirective;
var
  i, n, i1, i2: integer;
  OneFileInfo: TOneFileInfo;
  OneDIWordFound: TOneDIWordFound;
  found: boolean;
  s, s2,s3: string;
begin
  for i := 0 to self.slDirective.Count - 1 do
  begin
    OneFileInfo := slDirective.OneFileInfo(i);

    for n := 0 to OneFileInfo.slDependencyInjektionNamen.Count - 1 do
    begin

      OneDIWordFound := OneFileInfo.slDependencyInjektionNamen.OneDIWordFound(n);
      found := False;
      s2 := OneFileInfo.slDependencyInjektionNamen[n];
      for i1 := 0 to OneFileInfo.slFileInhalt.Count - 1 do
      begin
        if not found then
          if pos(s2, OneFileInfo.slFileInhalt[i1]) > 0 then
            found := True;
        if found and (OneDIWordFound.sDirectiveRestrict = '') then
        begin
          i2 := pos('restrict:', OneFileInfo.slFileInhalt[i1]);

          if i2 > 0 then
          begin
            s := OneFileInfo.slFileInhalt[i1];
            s := ansireplacestr(s,'"',#39);
            Delete(s, 1, i2);
            i2 := pos(#39, s);
            if i2 > 0 then
            begin
              Delete(s, 1, i2);
              i2 := pos(#39, s);
              if i2 > 0 then
              begin
                s3 := copy(s, 1, i2-1);
                OneDIWordFound.sDirectiveRestrict :=s3 ;
                break;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

end;

procedure TFrmMainController.AddAllProjectWordsToIntellisence;
var
  i, i2: integer;
  AngComponent: TAngComponent;
  sl: TStringList;
  OneDIWordFound: TOneDIWordFound;
begin
  self.SearchForRestrictInSlDirective();
  sl := GetslDJKeyWords();


  for i := 0 to sl.Count - 1 do
  begin
    OneDIWordFound := TOneDIWordFound(sl.Objects[i]);
    i2 := OneDIWordFound.iImageindex;
    if i2 = constItemIndexDirective then
    begin
        AngComponent := TAngComponent.Create;

        if pos('E', OneDIWordFound.sDirectiveRestrict) > 0 then
          AngComponent.sTag := '<' + sl[i] + '>'
        else
          AngComponent.sTag :=  sl[i];

        AngComponent.angComponenttyp := AngComponentDirective;
        self.AngIntellisence.AngComponentProjectList.AddObject(
          AngComponent.sTag, AngComponent);
    end;

    if i2 = constItemIndexFilter then
    begin
      AngComponent := TAngComponent.Create;
      AngComponent.sTag := '|' + sl[i];
      AngComponent.angComponenttyp := AngComponentfilter;
      self.AngIntellisence.AngComponentProjectList.AddObject(
        AngComponent.sTag, AngComponent);
    end;
  end;

end;

function TFrmMainController.ActiveSynMemoIsHTMLAndCarentInSquareBrackets: boolean;
var SynMemo : TSynMemo;
    myPoint : TPoint;
    s : string;
    i,i2 : integer;
begin

  result := false;

  if myActiveOneTabsheet.Tabsheet.ImageIndex =  constItemIndexHTML then
    begin
    SynMemo := myActiveOneTabsheet.SynMemo;
    myPoint := SynMemo.LogicalCaretXY;
    s := SynMemo.Lines[myPoint.y -1] ;
    i2 := myPoint.x;
    if length(s) < i2  then
      i2 := length(s);

    for i := i2 downto 1 do
      begin
      if s[i] = '<' then
        result := true;
      if s[i] = '>' then
        exit;
      end;
    end;

end;

procedure TFrmMainController.ReplaceSnippetInserts(var sContent: string);
begin
  sContent := ansireplacestr(sContent, '[[Date]]', Datetostr(now));
  sContent := ansireplacestr(sContent, '[[Datetime]]', Datetimetostr(now));

end;

function TFrmMainController.IsHTMLTagSelfClosing(s: string): boolean;
begin
  Result := False;

  if s = 'area' then
    Result := True;
  if s = 'base' then
    Result := True;
  if s = 'br' then
    Result := True;
  if s = 'col' then
    Result := True;
  if s = 'command' then
    Result := True;
  if s = 'embed' then
    Result := True;
  if s = 'hr' then
    Result := True;
  if s = 'img' then
    Result := True;
  if s = 'input' then
    Result := True;
  if s = 'keygen' then
    Result := True;
  if s = 'link' then
    Result := True;
  if s = 'meta' then
    Result := True;
  if s = 'param' then
    Result := True;
  if s = 'source' then
    Result := True;
  if s = 'track' then
    Result := True;
  if s = 'wbr' then
    Result := True;

end;

end.
