unit angfrmImage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TfrmImage }

  TfrmImage = class(TForm)
    Image1: TImage;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmImage: TfrmImage;

implementation

{$R *.lfm}

end.

