unit Excel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, CoreEnvConfig;

type
  TFormExcel = class(TForm)
    rgChooseExcel: TRadioGroup;
    rbMicrosoft: TRadioButton;
    rbWPS: TRadioButton;
    btnExcelFix: TButton;
    procedure btnExcelFixClick(Sender: TObject);
  private
  public
    MicrosoftExcelFixedResult: Boolean;
    WPSExcelFixedResult: Boolean;
    function MicrosoftFix: Boolean;
  end;

const
  SSETTITLEExcel = '选择 Microsoft Excel 可执行文件 (Excel.exe)';

var
  FormExcel: TFormExcel;

implementation

{$R *.dfm}

procedure TFormExcel.btnExcelFixClick(Sender: TObject);
begin
  if rbMicrosoft.Checked then
  begin
    MicrosoftExcelFixedResult := MicrosoftFix;
  end
  else if rbWPS.Checked then
  begin
    WPSExcelFixedResult := False;
  end;
end;

function TFormExcel.MicrosoftFix: Boolean;
var
  ExcelexePath: string;
  ScriptPath: string;
begin
  with TFileOpenDialog.Create(nil) do
  try
    Title := SSETTITLEExcel;
    if not Execute then
      Exit;   //显示对话框等待用户做选择。如果用户选择取消，直接退出修复函数。
    ExcelexePath := FileName;
  finally
    Free;
  end;

  //检查是否选择了正确的excel.exe文件
  if not SameText(ExtractFileName(ExcelexePath), 'EXCEL.EXE') then
  begin
    ShowMessage('请选择正确的 Excel.exe 文件');
    Exit(False);
  end;

  ScriptPath := ExtractFilePath(ParamStr(0)) + 'RegisterExcelCOM.ps1';

  Result := ExtractScript(ScriptPath, '"' + ExcelexePath + '"');
end;

end.

