program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

var
  i : Integer;
var
  PInt : ^Integer;  //����һ���������͵�ָ��
  PInt2 : PInteger; //����ϵͳ��װ�õ�����ָ��
  void :Pointer;    //������ָ��
begin
  i := 100;
  //PInt := @i; //ȡ��ַ
  Writeln(Integer(@i).toHexString);   //�������i 16���Ƶĵ�ַ

  Pint := @i; //ȡ��ַ
  Writeln(Pint^);  //������

  //��ʼ���������ڴ�ռ�
  New(PInt2);
  //ͨ��ָ�븳ֵ
  PInt2^ := 100;
  //�ͷ��ڴ�
  Dispose(PInt2);

  {����ָ��}
  Readln;
end.
