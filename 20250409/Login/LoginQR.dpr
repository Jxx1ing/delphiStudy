program LoginQR;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {FormLogin},
  QRMaker in 'QRMaker.pas',
  UserInfo in 'UserInfo.pas',
  DelphiZXIngQRCode in 'DelphiZXIngQRCode.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True; {�ڴ�й©���}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormLogin, FormLogin);
  Application.Run;
end.
