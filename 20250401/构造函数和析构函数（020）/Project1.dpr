program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

Type
  TUser = class                     //class(Object)���Բ�д����ÿ���඼�̳��˸���TObejct
    {�ֶ�}
    FName : string;
    {���췽��}
    constructor Aaa(Name:string);
    {����������}
    procedure SetName(Name : string);
    {���ٶ���ķ���}
    destructor Destroy(); override;
  end;


{���췽��}
constructor TUser.Aaa(Name: string);
begin
  //��ʼ��
  Self.FName := Name;
end;


{һ������}
procedure TUser.SetName(Name: string);
begin
  FName := Name;
end;

{���ٶ���ķ���ʵ��}
destructor TUser.Destroy;
begin
   Writeln('���ø������ٶ���ķ���');
  {���ø������ٶ���ķ���}
  inherited;
end;

var
  User : TUser;
begin
  {ͨ����Ĺ��췽��������һ����Ķ���}
  //User := TUser.Create();

  {���ٶ���}
  //User.Free();

  User := TUser.Aaa('aaa');
  Writeln(User.FName); //���aaa

  FreeAndNil(User);

  Readln;
end.
