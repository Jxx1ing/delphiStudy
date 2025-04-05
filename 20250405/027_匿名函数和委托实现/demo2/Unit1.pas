unit Unit1;

interface
type
  {接口}
  IEat = interface
    {方法}
    procedure Eating();
  end;

  {狗类}
  TDog = class(TInterfacedObject,IEat)
    procedure Eating();
  end;

  {猫类}
  TCat = class(TInterfacedObject,IEat)
  private
    FCat : IEat; //FCat类型是IEat,当成一个接口
  public
    {属性： 名为Eat,通过调用FCat字段进行读写}
     {访问Cat.Eat 实际上就是访问FEat}
     {Eat的类型是IEat,当成一个接口}
    property Eat: IEat read FCat write FCat implements IEat;
    { implements :它告诉编译器，当TCat类被当作接口IEat使用时，把接口的调用转发到FEat}
  end;

implementation

{ TDog }

procedure TDog.Eating;
begin
  Writeln('狗吃骨头');
end;

end.
