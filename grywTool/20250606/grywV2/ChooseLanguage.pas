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
      lblACPValue.Caption := '936';  //����
    1:
      lblACPValue.Caption := '950';  //��������
    2:
      lblACPValue.Caption := '1252';  //Ӣ��
    3:
      lblACPValue.Caption := '1251';  //����
    4:
      lblACPValue.Caption := '949';  //����
    5:
      lblACPValue.Caption := '1250'; //������
    6:
      lblACPValue.Caption := '1250'; //�ݿ���
    7:
      lblACPValue.Caption := '1252'; //����
    8:
      lblACPValue.Caption := '1252'; //��������
    9:
      lblACPValue.Caption := '1252'; //����
    10:
      lblACPValue.Caption := '1252'; //�������
    11:
      lblACPValue.Caption := '932';  //����
    12:
      lblACPValue.Caption := '1254'; //��������
    13:
      lblACPValue.Caption := '1258'; //Խ����
    14:
      lblACPValue.Caption := '1252'; //��������
  end;
end;

end.

