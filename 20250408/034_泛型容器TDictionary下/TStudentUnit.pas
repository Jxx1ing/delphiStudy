unit TStudentUnit;

interface
{����һ��ѧ����,�������ΪTDictionary�ֵ����Ԫ��}
type TStudent = class
private
  FId : string;
  FName : string;
  FAge : Integer;
public
  {���캯��}
  constructor Create(); overload;
  constructor Create(userId,userName:string; userAge:Integer);overload;

  {����}
  property id : string read FId write FId;
  property name : string read FName write FName;
  property age:  Integer read FAge write FAge;

end;

implementation

{ TStudent }

constructor TStudent.Create(userId, userName: string; userAge: Integer);
begin
  Self.FId := userId;
  Self.FName := userName;
  Self.FAge := userAge;
end;

constructor TStudent.Create;
begin

end;

end.
