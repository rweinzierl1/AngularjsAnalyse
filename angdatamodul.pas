unit angDatamodul;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Controls;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    ImageList1: TImageList;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.lfm}

end.

