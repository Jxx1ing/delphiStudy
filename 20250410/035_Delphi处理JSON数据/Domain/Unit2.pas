unit Unit2;

interface
type
  TStudent = class
  private
    FName : string;
    FAge : Integer;
  public
    constructor Create();overload;
    constructor Create(PName : string; PAge : Integer); overload;
    property Name: string read FName write FName;
    property Age: Integer read FAge write FAge;
  end;

implementation

{ TStudent }

constructor TStudent.Create(PName: string; PAge: Integer);
begin
  Self.FName := PName;
  Self.FAge := PAge;
end;

constructor TStudent.Create;
begin

end;

end.
