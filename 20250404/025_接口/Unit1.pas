unit Unit1;

interface

type
  {����һ���ӿ�}
  IUsb = interface
    ['{C925B198-550F-41EE-93AB-008F27DD477B}']       //GUID ȫ��Ψһ��ʶ

    {����һ������ public}
    procedure Read();
  end;

  IUsb2 = interface(IUsb)
    procedure write();
  end;





  {����һ����}
  //����
  TComputer = class(TInterfacedObject)

  end;

  //������
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
