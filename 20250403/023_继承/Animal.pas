unit Animal;

interface
{����һ������}
type
  TAnimal = class
  private
    FTiZhong : Integer;
  protected
    FName : String;
  public
    {���췽��}
    constructor Create(TiZhong : Integer);
    {����}
    property TiZhong : Integer read FTiZhong write FTiZhong;
    {�鷽��}
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
