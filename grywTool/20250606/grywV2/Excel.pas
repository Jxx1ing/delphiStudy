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
  SSETTITLEExcel = 'ѡ�� Microsoft Excel ��ִ���ļ� (Excel.exe)';

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
      Exit;   //��ʾ�Ի���ȴ��û���ѡ������û�ѡ��ȡ����ֱ���˳��޸�������
    ExcelexePath := FileName;
  finally
    Free;
  end;

  //����Ƿ�ѡ������ȷ��excel.exe�ļ�
  if not SameText(ExtractFileName(ExcelexePath), 'EXCEL.EXE') then
  begin
    ShowMessage('��ѡ����ȷ�� Excel.exe �ļ�');
    Exit(False);
  end;

  ScriptPath := ExtractFilePath(ParamStr(0)) + 'RegisterExcelCOM.ps1';

  Result := ExtractScript(ScriptPath, '"' + ExcelexePath + '"');
end;

end.

