program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uTools in 'uTools.pas',
  Unit1 in 'Unit1.pas';

var
  People : TPerson;

begin
  People := TPerson.Create;
  //Writeln(People.Name);  //���ʹ��Name
  People.Age := 18;
  Writeln(People.Age); //Age���Զ�����д,ͨ��setAge������ֵΪ18��ͨ��getAge�õ�ֵ
  Readln;
end.
