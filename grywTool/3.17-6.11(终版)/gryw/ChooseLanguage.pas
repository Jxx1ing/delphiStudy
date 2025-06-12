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
      ACPCode := '936';  //����
    1:
      ACPCode := '950';  //��������
    2:
      ACPCode := '1252';  //Ӣ��
    3:
      ACPCode := '1251';  //����
    4:
      ACPCode := '949';  //����
    5:
      ACPCode := '1250'; //������
    6:
      ACPCode := '1250'; //�ݿ���
    7:
      ACPCode := '1252'; //����
    8:
      ACPCode := '1252'; //��������
    9:
      ACPCode := '1252'; //����
    10:
      ACPCode := '1252'; //�������
    11:
      ACPCode := '932';  //����
    12:
      ACPCode := '1254'; //��������
    13:
      ACPCode := '1258'; //Խ����
    14:
      ACPCode := '1252'; //��������
  end;
  lblACPValue.Caption := ACPCode;
end;

end.

