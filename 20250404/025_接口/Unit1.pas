unit Unit1;

interface

type
  {定义一个接口}
  IUsb = interface
    ['{C925B198-550F-41EE-93AB-008F27DD477B}']       //GUID 全局唯一标识

    {声明一个方法 public}
    procedure Read();
  end;

  IUsb2 = interface(IUsb)
    procedure write();
  end;





  {定义一个类}
  //基类
  TComputer = class(TInterfacedObject)

  end;

  //派生类
  TLaptop = class(TComputer,IUsb,IUsb2)
    procedure Read();
    procedure write();
  end;

implementation

{ TLaptop }
procedure TLaptop.Read;
begin

end;

procedure TLaptop.write;
begin

end;

end.
