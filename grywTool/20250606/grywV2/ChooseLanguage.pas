unit ChooseLanguage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TFormLanguage = class(TForm)
    cbbLanguage: TComboBox;
    lbltip: TLabel;
    lblACP: TLabel;
    lblACPValue: TLabel;
    btnok: TButton;
    procedure cbbLanguageChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLanguage: TFormLanguage;

implementation

{$R *.dfm}

procedure TFormLanguage.cbbLanguageChange(Sender: TObject);
begin
  case cbbLanguage.ItemIndex of
    0:
      lblACPValue.Caption := '936';  //中文
    1:
      lblACPValue.Caption := '950';  //繁体中文
    2:
      lblACPValue.Caption := '1252';  //英语
    3:
      lblACPValue.Caption := '1251';  //俄语
    4:
      lblACPValue.Caption := '949';  //韩语
    5:
      lblACPValue.Caption := '1250'; //波兰语
    6:
      lblACPValue.Caption := '1250'; //捷克语
    7:
      lblACPValue.Caption := '1252'; //德语
    8:
      lblACPValue.Caption := '1252'; //西班牙语
    9:
      lblACPValue.Caption := '1252'; //法语
    10:
      lblACPValue.Caption := '1252'; //意大利语
    11:
      lblACPValue.Caption := '932';  //日语
    12:
      lblACPValue.Caption := '1254'; //土耳其语
    13:
      lblACPValue.Caption := '1258'; //越南语
    14:
      lblACPValue.Caption := '1252'; //葡萄牙语
  end;
end;

end.

