unit Animal;

interface
{定义一个基类}
type
  TAnimal = class
  private
    FTiZhong : Integer;
  protected
    FName : String;
  public
    {构造方法}
    constructor Create(TiZhong : Integer);
    {属性}
    property TiZhong : Integer read FTiZhong write FTiZhong;
    {虚方法}
    procedure GetName(); virtual;
  end;

implementation

{ TAnimal }

constructor TAnimal.Create(TiZhong : Integer);
begin
  Writeln('Animal Create');
  Writeln('Animal TiZhong:',TiZhong);
end;

procedure TAnimal.GetName();
begin
  Writeln('TAniaml GetName');
end;

end.
