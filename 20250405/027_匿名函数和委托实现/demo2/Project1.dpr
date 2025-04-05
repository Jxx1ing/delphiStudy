program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Unit1 in 'Unit1.pas';

var
  Dog : TDog;
  Cat : TCat;
  Eat : IEat;

begin
  Cat := TCat.Create;
  Cat.Eat := TDog.Create; //Eat类型是IEat
                          //类TCat把接口Eat的实现方法委托给 FEat所指向的对象TDog
                          //TDog实现接口类型IEat
  Cat.Eat.Eating; //实际上调用的是TDog.Eating

  Readln;
end.
