program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  //����һ����������
  TFunDemo = function(Age:Integer) : Integer;
  //����һ����������
  TFun = reference to function(num:Integer) : Integer;

function Demo1(Age:Integer):Integer;
begin
  Writeln(Age);

  Result := Age;
end;

{�Ѻ�������һ��������д���}
function Demo2(num1,num2 : Integer; fun : TFun) : Integer;
begin
  result := fun(num1 + num2);  // ������������������ (num1 + num2)
end;


var
  func1 : TFunDemo; //func1�Ǻ������ͣ��������Ϊ����ָ��
  fun2 : TFun;
  NumResult : Integer;
begin
{
  fun2 :=
    function(num : Integer) : Integer //function������Բ���������
    begin
      result := num;
    end;

    //������������
    fun2(10);
 }
 {
    Demo2(fun2);
 }

  NumResult := Demo2(10,20,
      function(num : Integer) : Integer
      begin
        Result := num * 2;
      end
  );

  Writeln(NumResult); //���60
  Readln;
end.
