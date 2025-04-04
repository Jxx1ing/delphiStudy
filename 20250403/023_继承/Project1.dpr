program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Animal in 'Animal.pas',
  Dog in 'Dog.pas';

var
  XDog : TDog;
begin
  XDog := TDog.Create;

  XDog.GetName;

  Readln;
end.
