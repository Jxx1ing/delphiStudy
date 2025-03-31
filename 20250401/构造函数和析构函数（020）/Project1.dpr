program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

Type
  TUser = class                     //class(Object)可以不写，但每个类都继承了父类TObejct
    {字段}
    FName : string;
    {构造方法}
    constructor Aaa(Name:string);
    {声明、定义}
    procedure SetName(Name : string);
    {销毁对象的方法}
    destructor Destroy(); override;
  end;


{构造方法}
constructor TUser.Aaa(Name: string);
begin
  //初始化
  Self.FName := Name;
end;


{一个方法}
procedure TUser.SetName(Name: string);
begin
  FName := Name;
end;

{销毁对象的方法实现}
destructor TUser.Destroy;
begin
   Writeln('调用父类销毁对象的方法');
  {调用父类销毁对象的方法}
  inherited;
end;

var
  User : TUser;
begin
  {通过类的构造方法，创建一个类的对象}
  //User := TUser.Create();

  {销毁对象}
  //User.Free();

  User := TUser.Aaa('aaa');
  Writeln(User.FName); //输出aaa

  FreeAndNil(User);

  Readln;
end.
