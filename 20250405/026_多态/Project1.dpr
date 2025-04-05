program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Unit1 in 'Unit1.pas';

//向上转型，把子类对象的类型转换为父类的数据类型
procedure ShowAnimalRun(Animal : TAnimal);
var
  Dog : TDog;
begin
{
  //运行时的数据类型
  Animal.Run;
  //向下转型: 把父类对象的类型转换为子类的数据类型
  //强制类型转换
  Dog := TDog(Animal);
  Dog.LookDoor;
}
{
  if Animal.ClassName = 'TDog' then begin
    Dog := TDog(Animal);
    Dog.LookDoor;
  end;
}
  //判断一个对象是否和一个类型兼容
  if Animal is TDog then begin
    Writeln('可以转化成狗');
    Dog := Animal as TDog;   //将基类Animal转化为派生类Dog
    Dog.LookDoor;
  end;

  if Assigned(Dog) then begin
    Writeln('不是空值');
end;
end;

var
  Animal : TAnimal;
begin
  ShowAnimalRun(TDog.Create);    //输出狗在跑，狗在看门
  Readln;
end.
