unit angFrmClipboardHistorie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons,angPasteHistorie;

type

  { TfrmPasteHistorie }

  TfrmPasteHistorie = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ListBox1: TListBox;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
  private
    { private declarations }
    AngClipboardHistorieList1: TAngClipboardHistorieList;
  public
    { public declarations }
    procedure FillListbox(AngClipboardHistorieList : TAngClipboardHistorieList );
  end;

var
  frmPasteHistorie: TfrmPasteHistorie;

implementation

{$R *.lfm}

{ TfrmPasteHistorie }

procedure TfrmPasteHistorie.FormCreate(Sender: TObject);
begin



end;

procedure TfrmPasteHistorie.ListBox1SelectionChange(Sender: TObject;
  User: boolean);
var i : integer;
begin
i := Listbox1.ItemIndex ;

if i = -1 then exit;

memo1.lines.text := AngClipboardHistorieList1.AngClipboardHistorie(i).sClipboard;

end;

procedure TfrmPasteHistorie.FillListbox(
  AngClipboardHistorieList: TAngClipboardHistorieList);
var i : integer;
begin
AngClipboardHistorieList1 := AngClipboardHistorieList;

for i := 0 to AngClipboardHistorieList.Count -1 do
  Listbox1.Items.Add(AngClipboardHistorieList[i]   );


if Listbox1.Items.Count > 0 then
  Listbox1.ItemIndex := 0;

end;

end.

