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
  //Writeln(People.Name);  //外界使用Name
  People.Age := 18;
  Writeln(People.Age); //Age可以读可以写,通过setAge更改了值为18，通过getAge得到值
  Readln;
end.
