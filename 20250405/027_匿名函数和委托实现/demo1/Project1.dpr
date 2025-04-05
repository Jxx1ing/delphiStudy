program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  //声明一个函数类型
  TFunDemo = function(Age:Integer) : Integer;
  //定义一个匿名函数
  TFun = reference to function(num:Integer) : Integer;

function Demo1(Age:Integer):Integer;
begin
  Writeln(Age);

  Result := Age;
end;

{把函数当作一个对象进行传递}
function Demo2(num1,num2 : Integer; fun : TFun) : Integer;
begin
  result := fun(num1 + num2);  // 调用匿名函数，处理 (num1 + num2)
end;


var
  func1 : TFunDemo; //func1是函数类型，可以理解为函数指针
  fun2 : TFun;
  NumResult : Integer;
begin
{
  fun2 :=
    function(num : Integer) : Integer //function后面可以不跟函数名
    begin
      result := num;
    end;

    //调用匿名函数
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

  Writeln(NumResult); //输出60
  Readln;
end.
