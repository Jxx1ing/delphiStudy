unit Dog;

interface

uses
  Animal;
{定义一个派生类}
type
  TDog = class(TAnimal)
    {TDog类的构造方法}
    constructor Create();
    {重写覆盖了父类的虚方法}
    procedure GetName(); override;
  end;
implementation

{ TDog }

constructor TDog.Create;
begin
  {TDog类的Create方法}
  Writeln('TDog Create');
  {直接调用父类的Create方法}
  inherited Create(1001);
end;

procedure TDog.GetName();
begin
  {在派生类中使用，表示派生类调用基类的同名方法（要求方法的参数要一致）}
  inherited;

  {TDog类的GetName方法}
  Writeln('TDog GetName');

end;

end.
