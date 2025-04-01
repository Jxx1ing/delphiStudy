unit uTools;

interface
{声明区域}
var
  Name : string;

type TPerson = class
{字段、域}
  Private            //私有化
  FName : string;
  FAge : Integer;

  function GetAge(): Integer;
  procedure SetAge(MyAge : Integer);
  Public
  {属性}
    property Name : string read FName write FName;  //①property后跟外界使用名 + 属性类型/字段名

    //property Age : Integer read GetAge;  //②利用函数获得属性值（只读属性）

    property Age : Integer read GetAge write SetAge;   //③利用过程获得属性（参数只能有一个，可以更改属性）

end;

implementation
{实现区域}

var
  Age : Integer;

{ TPerson }

function TPerson.GetAge: Integer;
begin
  Result := Self.FAge;
end;

procedure TPerson.SetAge(MyAge: Integer);
begin
  Self.FAge := MyAge;
end;

initialization
{初始化区域}
  Name := '萧蔷';
  Age := 16;

finalization
{销毁区域}
  Name := '';
  Age := 0;
end.
