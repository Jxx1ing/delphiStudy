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
  Cat.Eat := TDog.Create; //Eat������IEat
                          //��TCat�ѽӿ�Eat��ʵ�ַ���ί�и� FEat��ָ��Ķ���TDog
                          //TDogʵ�ֽӿ�����IEat
  Cat.Eat.Eating; //ʵ���ϵ��õ���TDog.Eating

  Readln;
end.
