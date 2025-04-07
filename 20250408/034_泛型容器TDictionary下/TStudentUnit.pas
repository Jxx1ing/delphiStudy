unit TStudentUnit;

interface
{定义一个学生类,其对象作为TDictionary字典类的元素}
type TStudent = class
private
  FId : string;
  FName : string;
  FAge : Integer;
public
  {构造函数}
  constructor Create(); overload;
  constructor Create(userId,userName:string; userAge:Integer);overload;

  {属性}
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
