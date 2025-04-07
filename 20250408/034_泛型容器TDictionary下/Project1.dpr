program Project1;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {Form1},
  TStudentUnit in 'TStudentUnit.pas',
  AddFormUnit in 'AddFormUnit.pas' {FormAdd},
  TDictionaryUnit in 'TDictionaryUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormAdd, FormAdd);
  Application.Run;
end.
