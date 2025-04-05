unit Unit1;

interface
type
  {接口}
  IColor = interface

  end;

  {基类}
  TAnimal = class(TInterfacedObject)

  public
    procedure run();virtual;abstract;
  end;

  {派生类}
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
  Writeln('狗在看门')
end;

procedure TDog.run;
begin
  Writeln('狗在跑');
end;

{ TCat }

procedure TCat.CatchMouse;
begin
  Writeln('猫在抓老鼠');
end;

procedure TCat.run;
begin
  Writeln('猫在跑');
end;

end.
