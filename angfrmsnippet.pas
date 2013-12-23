unit angfrmSnippet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, angSnippet;

type

  { TfrmSnippet }

  TfrmSnippet = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
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
    procedure BitBtn1Click(Sender: TObject);
  private
    { private declarations }
    myAngSnippet : TAngSnippet ;
  public
    { public declarations }
    procedure ShowSnippet(mAngSnippet : TAngSnippet );
  end;



implementation

{$R *.lfm}

{ TfrmSnippet }

procedure TfrmSnippet.BitBtn1Click(Sender: TObject);
begin
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

