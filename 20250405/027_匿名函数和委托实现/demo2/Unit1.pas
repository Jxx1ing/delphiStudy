unit Unit1;

interface
type
  {�ӿ�}
  IEat = interface
    {����}
    procedure Eating();
  end;

  {����}
  TDog = class(TInterfacedObject,IEat)
    procedure Eating();
  end;

  {è��}
  TCat = class(TInterfacedObject,IEat)
  private
    FCat : IEat; //FCat������IEat,����һ���ӿ�
  public
    {���ԣ� ��ΪEat,ͨ������FCat�ֶν��ж�д}
     {����Cat.Eat ʵ���Ͼ��Ƿ���FEat}
     {Eat��������IEat,����һ���ӿ�}
    property Eat: IEat read FCat write FCat implements IEat;
    { implements :�����߱���������TCat�౻�����ӿ�IEatʹ��ʱ���ѽӿڵĵ���ת����FEat}
  end;

implementation

{ TDog }

procedure TDog.Eating;
begin
  Writeln('���Թ�ͷ');
end;

end.
