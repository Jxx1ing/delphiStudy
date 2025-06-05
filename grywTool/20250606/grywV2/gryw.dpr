program gryw;

uses
  Vcl.Forms,
  Tool in 'Tool.pas' {ToolForm},
  FrameAntiVirus in 'TUI\FrameAntiVirus.pas' {FrmVirus: TFrame},
  FrameEncrytion in 'TUI\FrameEncrytion.pas' {FrmEncry: TFrame},
  FrameEnvConfig in 'TUI\FrameEnvConfig.pas' {FrmEnv: TFrame},
  FrameNet in 'TUI\FrameNet.pas' {FrmNet: TFrame},
  CoreAntiVirus in 'TCore\CoreAntiVirus.pas',
  CoreEncrytion in 'TCore\CoreEncrytion.pas',
  CoreEnvConfig in 'TCore\CoreEnvConfig.pas',
  CoreNet in 'TCore\CoreNet.pas',
  ChooseLanguage in 'ChooseLanguage.pas' {FormLanguage},
  Excel in 'Excel.pas' {FormExcel},
  HttpGet in 'HttpGet.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TToolForm, ToolForm);
  Application.CreateForm(TFormLanguage, FormLanguage);
  Application.CreateForm(TFormExcel, FormExcel);
  Application.Run;
end.
