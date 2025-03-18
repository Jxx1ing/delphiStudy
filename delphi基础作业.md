## 1-乘法口诀表

```cpp
program Project2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils;

var
  x,y:integer;

begin
  for x := 1 to 9 do      //行数
  begin
    for y := 1 to x do    //列数
    begin
      write(y, '*', x, '=', y*x, ' ');
    end;

    writeln;  //每打印完一行就换行writeline
  end;

  ReadLn;   //作用：等待用户输入，从而达到控制台窗口打开的状态
              //////如果没有readln  程序在执行完for循环后控制台窗口会立即关闭（无法看到输出）
end.

```

![](https://cdn.nlark.com/yuque/0/2025/png/38695078/1742263764018-4d4d1589-1c79-417d-b573-1761c7b5602d.png)







## 2-找质数

```cpp
program Project2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  Math; //使用math单元，sqrt函数

var
  x : integer; //x为用户输入的数字
  i : integer = 2; //辅助判断质数

begin
  //输入一个数
  write('请输入一个整数：');
  readln(x);

  //检验是否为质数
  if(x <= 1) then               //if语法：   if 条件 then
  begin
    writeln(x,'不是质数');
    readln;
    Exit;
  end;

  while i <= sqrt(x) do
  begin
    if(x mod i = 0) then
    begin
      writeln(x,'不是质数');
      readln;
      Exit;
    end;
    i := i +1;
  end;

  //运行到这里，说明这个数是质数
  writeln(x,'是质数');
  readln;
end.

```



```cpp
program Project2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  Math; //使用math单元，sqrt函数

var
  x,i: integer; //x为用户输入的数字   //i是辅助判断
  nextPrime : integer; //下一个质数

//定义一个函数：判断是否是质数
function isPrime(n : integer) : boolean; //参数是integer类型，函数返回值是boolean
                                           //result是隐式变量，存储函数的返回值
var
  i : integer;
begin
    for i:=2 to Trunc(sqrt(n)) do
    begin
      if(n mod i = 0) then
      begin
        result := false;
        exit;
      end;
    end;

    //运行到这里，说明这个数是质数
    result := true;
end;


//主程序
begin
  //输入一个数
  write('请输入一个整数：');
  readln(x);

  if(x <= 1)then
  begin
    writeln(x,'不是质数，下一个质数是2');
    readln;
    exit;
  end;

  //运行到这里，说明x>=2
  if (isPrime(x)) then
  begin
    writeln(x,'是质数');
  end     //注意：end后不需要;
  else
  begin
    //寻找下一个质数
    nextPrime := x + 1;
    while not (isPrime(nextPrime)) do //while not 条件 do -- 当 条件 为 False 时，not 条件 为 True，循环继续执行
    begin
      nextPrime := nextPrime + 1;
    end;

    writeln(x,'不是质数，下一个质数是',nextPrime);
  end;

  readln;
end.

```

![](https://cdn.nlark.com/yuque/0/2025/png/38695078/1742274720966-df410f90-7eb5-406f-9a46-99435b3bd2b5.png)





## 3-哥德巴赫猜想

### 初级版

```cpp
program Project2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  Math;

var
  x : integer;  //输入的数
  first,second : integer; //两个数

//判断质数 —— 如果能整除i 返回false。如果循环结束没有发现能整除i 返回true
function isPrime(n:integer):boolean;
var
  i : integer; //辅助 (声明为全局变量会有warning)
begin
   if (n<=1) then
   begin
     result := false;
     exit;
   end;

   for i := 2 to trunc(sqrt(n)) do
   begin
     if(n mod i = 0) then
     begin
       result := false;  //非质数
       exit;
     end
   end;

   //运行到这里，说明这个数是质数
   result := true;
end;

//主程序
begin
  writeln('请输入一个大于2的偶数');
  readln(x);

  for first := 2 to x do
  begin
    if(isPrime(first)) then //如果第一个数是质数
    begin
      for second := 2 to x-first do
      begin
        if(isPrime(second) and (first + second = x)) then     //如果第二个数是质数，且第一个数和第二个数之和等于x
        begin
          writeln(x,'=',first,'+',second);
        end;
      end;
    end;
  end;

  readln;
end.

```

![](https://cdn.nlark.com/yuque/0/2025/png/38695078/1742278371387-7d537882-8f18-430f-8b08-5bfadc2b3534.png)



### 普通版

```cpp
program Project2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  Math,
  System.Diagnostics; // 引入System.Diagnostics单元（TStopwatch 类来记录程序的运行时间，引入System.Diagnostics 单元）
                      //////程序开始和结束时分别调用 TStopwatch.Start 和 TStopwatch.Elapsed 来记录时间

var
  x : integer;
  stopwatch : TStopwatch; // 声明stopwatch变量

//定义一个函数——判断是否是质数
function isPrime(n:integer):boolean;
var
  i : integer;
begin
   if (n<=1) then
   begin
     result := false;
     exit;
   end;

   for i := 2 to trunc(sqrt(n)) do
   begin
     if(n mod i = 0) then
     begin
       result := false;
       exit;
     end
   end;

   result := true;
end;

//定义一个函数，判断是否符合哥德巴赫猜想
function isGoldbach(x:integer):boolean;
var
  first,second : integer;
begin
  for first := 2 to x do
  begin
    if(isPrime(first)) then
    begin
      for second := 2 to x-first do
      begin
        if(isPrime(second) and (first + second = x)) then
        begin
            result := true;
            writeln(x,'=',first,'+',second);
            exit;
        end;
      end;
    end;

    //运行到这里，说明循环中找不到符合规定的2个数，返回false
    //注意：result如果是boolen类型，初始化为false（这里不需要写result:=false 否则会警告）
  end;

end;


//主程序
begin
  stopwatch := TStopwatch.StartNew; // 开始计时

  x := 6;
  while x<2147483647 do
  begin
    isGoldbach(x);
    x := x+2;
  end;

  writeln('Total time: ', stopwatch.ElapsedMilliseconds, ' ms'); // 输出运行时间
  readln;
end.
```

![](https://cdn.nlark.com/yuque/0/2025/png/38695078/1742280594684-b2fc3747-118f-4c3c-9047-d88de6d78461.png)



### 提升版（不熟悉）

 将哥德巴赫猜想算法封装成一个**bpl**， 该Bpl 采用64位 **Release**模式编译，

 该BPL可通过**窗体程序或控制台程序**能被调用。



类似C++的头文件，需要注意配置路径，依赖等



### 评优版

要求： 从6 开始一直到int32的表达范围 所有偶数验证哥德巴赫猜想，（不输出的情况下）用时不能超过1分钟。   



多线程
