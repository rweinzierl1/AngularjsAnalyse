unit angPKZ;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const

{$ifdef Unix}
sAngSeparator = '/';
{$else}
sAngSeparator = '\';
{$endif}


constItemIndexFolder = 0 ;
constItemIndexUnknownFile = 1;
constItemIndexFolder2  = 2 ;
constItemIndexController  = 3 ;
constItemIndexService  = 4 ;
constItemIndexAngular  =5  ;
constItemIndexFactory   =6 ;
constItemIndexFilter  = 7 ;
constItemIndexModule  =8  ;
constItemIndexCss  =9  ;
constItemIndexHTML  = 10 ;
constItemIndexJavascript  = 11 ;
constItemIndexUnknownFileWithPath = 12;
constItemIndexDirective = 13;
constItemIndexConfig = 14;
constItemIndexKey = 15;
constItemIndexMarkFound = 16;
constItemIndexfree1 = 17;
constItemIndexfree2 = 18;
constItemIndexfree3 = 19;
constItemIndexSerchInPath1 = 20;
constItemIndexSearchInPath = 21;
constItemIndexSaveAll = 22;
constItemIndexInfo = 23;
constItemIndexNew = 24;
constItemIndexSave = 25;
constItemScope = 26;
constItemAbwaertsuchen= 27;
constItemAufwaertsuchen = 28;
constItemTree = 29;
constItemResync = 30;
constItemOpenListview = 31;
constItemAutosave = 32;


implementation




end.

