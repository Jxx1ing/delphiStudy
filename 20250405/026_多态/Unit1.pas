unit Unit1;

interface
type
  {�ӿ�}
  IColor = interface

  end;

  {����}
  TAnimal = class(TInterfacedObject)

  public
    procedure run();virtual;abstract;
  end;

  {������}
  TDog = class(TAnimal,IColor)
    procedure run();override;
    procedure LookDoor();
  end;

   TCat = class(TAnimal,IColor)
    procedure run();override;
    procedure CatchMouse();
  end;

implementation


{ TDog }

procedure TDog.LookDoor;
begin
  Writeln('���ڿ���')
end;

procedure TDog.run;
begin
  Writeln('������');
end;

{ TCat }

procedure TCat.CatchMouse;
begin
  Writeln('è��ץ����');
end;

procedure TCat.run;
begin
  Writeln('è����');
end;

end.
