unit uTools;

interface
{��������}
var
  Name : string;

type TPerson = class
{�ֶΡ���}
  Private            //˽�л�
  FName : string;
  FAge : Integer;

  function GetAge(): Integer;
  procedure SetAge(MyAge : Integer);
  Public
  {����}
    property Name : string read FName write FName;  //��property������ʹ���� + ��������/�ֶ���

    //property Age : Integer read GetAge;  //�����ú����������ֵ��ֻ�����ԣ�

    property Age : Integer read GetAge write SetAge;   //�����ù��̻�����ԣ�����ֻ����һ�������Ը������ԣ�

end;

implementation
{ʵ������}

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
{��ʼ������}
  Name := '��Ǿ';
  Age := 16;

finalization
{��������}
  Name := '';
  Age := 0;
end.
