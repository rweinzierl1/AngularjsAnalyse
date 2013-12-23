unit angfrmSnippet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, angSnippet;

type

  { TfrmSnippet }

  TfrmSnippet = class(TForm)
    bOK: TBitBtn;
    bCancel: TBitBtn;
    cBoxsForFileType: TComboBox;
    cBoxLocation: TComboBox;
    eShortcut: TEdit;
    eDescription: TEdit;
    lblContent: TLabel;
    lblForFileType: TLabel;
    lblLocation: TLabel;
    lblShortcut: TLabel;
    lblDescription: TLabel;
    mContent: TMemo;
    procedure bOKClick(Sender: TObject);
  private
    { private declarations }
    myAngSnippet : TAngSnippet ;

  public
    { public declarations }
    procedure ShowSnippet(mAngSnippet : TAngSnippet );
    function DataFromViewToObject: boolean;
  end;



implementation

{$R *.lfm}

{ TfrmSnippet }

function TfrmSnippet.DataFromViewToObject : boolean;
begin
result := false;
if eShortcut.text = '' then
  begin
  showmessage('Shortcut empty');
  exit;
  end;

myAngSnippet.sShortcut   :=  eShortcut.text  ;
myAngSnippet.sDescription  :=  eDescription.text  ;
myAngSnippet.sContent  :=  mContent.text  ;
myAngSnippet.sForFileType:=   cBoxsForFileType.Text ;

case cBoxLocation.ItemIndex of
  0 : myAngSnippet.SnippetLocation := snippetProject;
  1 : myAngSnippet.SnippetLocation := snippetUser;
  2 : myAngSnippet.SnippetLocation := snippetGlobal;
end;

result := true;
end;



procedure TfrmSnippet.bOKClick(Sender: TObject);
begin
  if not DataFromViewToObject then exit;
  modalresult := mrOK;
end;

procedure TfrmSnippet.ShowSnippet(mAngSnippet: TAngSnippet);
begin
myAngSnippet := mAngSnippet;
  eShortcut.text :=  myAngSnippet.sShortcut;
  eDescription.text :=  myAngSnippet.sDescription ;
  mContent.text :=  myAngSnippet.sContent ;
  cBoxsForFileType.Text:= myAngSnippet.sForFileType ;

  case  myAngSnippet.SnippetLocation of
    snippetProject : cBoxLocation.ItemIndex:= 0;
    snippetUser    : cBoxLocation.ItemIndex:= 1;
    snippetGlobal  : cBoxLocation.ItemIndex:= 2;
  end;

end;

end.

