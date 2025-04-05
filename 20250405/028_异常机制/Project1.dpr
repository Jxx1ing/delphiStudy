program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

{自定义异常类EMathException}
type
  EMathException = class(Exception) //父类是Exception,系统自带

  end;


{一个除法方法，其中有异常判断}
procedure MyDivFun(Num1,Num2 : Integer);
begin
  if(0 = Num2) then begin
    //抛出异常
    raise Exception.Create('除数不能为0');
  end;
  Writeln('***'); //如果执行了抛出异常的语句，这行不会继续执行。直接Exit
end;



begin
{第二种：try-finally结构}
  try

   {对于try-finally结构来说，这里无论是否发生异常都会执行}
   {第一种：try-except结构}
   try
    {对于try-except结构来说，下面是可能发生异常的代码。即除法函数}
    MyDivFun(10,0);
   except
   {处理特定类型或者其他未明确类型的异常}
      {特定类型}
      on E:EMathException do begin        //ExMathException 是自定义的异常类型（系统自带的是Exception 父类）
        Writeln(E.UnitName, E.ClassName, E.Message);  //打印异常时的信息，用到的方法有：单元名，类名，抛出异常信息
      end;
      {其他异常类型}
      on E:Exception do begin
        Writeln(E.Message);
      end;
   end;

  finally
    //一般用于释放资源
    Writeln('释放资源');
  end;

  Readln;
end.
