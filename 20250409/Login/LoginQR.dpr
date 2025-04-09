program LoginQR;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {FormLogin},
  QRMaker in 'QRMaker.pas',
  UserInfo in 'UserInfo.pas',
  DelphiZXIngQRCode in 'DelphiZXIngQRCode.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True; {ÄÚ´æÐ¹Â©¼ì²é}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormLogin, FormLogin);
  Application.Run;
end.
