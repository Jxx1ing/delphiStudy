program QiYeVXLogin;

uses
  Vcl.Forms,
  Login_QiYeVX in 'Login_QiYeVX.pas' {Form1},
  DelphiZXIngQRCode in '..\..\�½��ļ���\DelphiZXingQRCode-master\Source\DelphiZXIngQRCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
