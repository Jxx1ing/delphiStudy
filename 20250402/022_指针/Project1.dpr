program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

var
  i : Integer;
var
  PInt : ^Integer;  //定义一个整数类型的指针
  PInt2 : PInteger; //利用系统封装好的类型指针
  void :Pointer;    //无类型指针
begin
  i := 100;
  //PInt := @i; //取地址
  Writeln(Integer(@i).toHexString);   //输出整型i 16进制的地址

  Pint := @i; //取地址
  Writeln(Pint^);  //解引用

  //初始化，分配内存空间
  New(PInt2);
  //通过指针赋值
  PInt2^ := 100;
  //释放内存
  Dispose(PInt2);

  {函数指针}
  Readln;
end.
