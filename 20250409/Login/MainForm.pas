unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UserInfo, QRMaker, Vcl.StdCtrls, Vcl.ExtCtrls, DelphiZXIngQRCode;

type
  TFormLogin = class(TForm)
    lblQR: TLabel;
    tmrAuth: TTimer;
    btnQR: TButton;
    imgQR: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQRClick(Sender: TObject);
    procedure tmrAuthTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;
  User: TUser;

implementation

{$R *.dfm}

procedure TFormLogin.btnQRClick(Sender: TObject);
var
  QRBitmap: TBitmap;
begin
  {������Ȩ}
  User.GetURL();
  {���ɶ�ά��}
  QRBitmap := GenerateQRBmp(User.AuthUrl,qrAuto,2);
  try
    imgQR.Picture.Assign(QRBitmap);
  finally
    QRBitmap.Free;
  end;
  {��ʼ��ѯ}
  tmrAuth.Enabled := True;
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  User := TUser.Create('', '', '', '', '', '');
  tmrAuth.Enabled := False;
end;

procedure TFormLogin.FormDestroy(Sender: TObject);
begin
  {User���������봰����������屻����ʱ��Ҳ��Ҫ��ȷ�ͷ�User���󡣷�����ڴ�й©}
  FreeAndNil(User);
  {���ø����FormDestory���ٴ���}
  inherited;
end;

procedure TFormLogin.tmrAuthTimer(Sender: TObject);
begin
  {�����Ȩ״̬�������ݷ���ֵ�����Ƿ�ֹͣ��ʱ��}
  if User.CheckAuth then
  begin
    {��Ȩ�ɹ���ֹͣ��ʱ��}
    tmrAuth.Enabled := False;
    ShowMessage('��Ȩ�ɹ�! ' + User.ReqSpone);  // ��һ�Σ�����ͣ
    Self.Close;
  end;
end;

end.
