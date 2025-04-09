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
  {请求授权}
  User.GetURL();
  {生成二维码}
  QRBitmap := GenerateQRBmp(User.AuthUrl,qrAuto,2);
  try
    imgQR.Picture.Assign(QRBitmap);
  finally
    QRBitmap.Free;
  end;
  {开始轮询}
  tmrAuth.Enabled := True;
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  User := TUser.Create('', '', '', '', '', '');
  tmrAuth.Enabled := False;
end;

procedure TFormLogin.FormDestroy(Sender: TObject);
begin
  {User生命周期与窗体关联，窗体被销毁时，也需要正确释放User对象。否则会内存泄漏}
  FreeAndNil(User);
  {调用父类的FormDestory销毁窗体}
  inherited;
end;

procedure TFormLogin.tmrAuthTimer(Sender: TObject);
begin
  {检查授权状态，并根据返回值决定是否停止定时器}
  if User.CheckAuth then
  begin
    {授权成功，停止定时器}
    tmrAuth.Enabled := False;
    ShowMessage('授权成功! ' + User.ReqSpone);  // 弹一次，立刻停
    Self.Close;
  end;
end;

end.
