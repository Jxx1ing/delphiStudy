unit ChooseLanguage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Generics.Collections;

type
  TFormLanguage = class(TForm)
    cbbLanguage: TComboBox;
    lbltip: TLabel;
    lblACP: TLabel;
    lblACPValue: TLabel;
    btnok: TButton;
    procedure cbbLanguageChange(Sender: TObject);
  private
  public

  end;

var
  FormLanguage: TFormLanguage;

implementation

{$R *.dfm}

procedure TFormLanguage.cbbLanguageChange(Sender: TObject);
var
  ACPCode: string;
begin
  case cbbLanguage.ItemIndex of
    0:
      ACPCode := '936';  //中文
    1:
      ACPCode := '950';  //繁体中文
    2:
      ACPCode := '1252';  //英语
    3:
      ACPCode := '1251';  //俄语
    4:
      ACPCode := '949';  //韩语
    5:
      ACPCode := '1250'; //波兰语
    6:
      ACPCode := '1250'; //捷克语
    7:
      ACPCode := '1252'; //德语
    8:
      ACPCode := '1252'; //西班牙语
    9:
      ACPCode := '1252'; //法语
    10:
      ACPCode := '1252'; //意大利语
    11:
      ACPCode := '932';  //日语
    12:
      ACPCode := '1254'; //土耳其语
    13:
      ACPCode := '1258'; //越南语
    14:
      ACPCode := '1252'; //葡萄牙语
  end;
  lblACPValue.Caption := ACPCode;
end;

end.

