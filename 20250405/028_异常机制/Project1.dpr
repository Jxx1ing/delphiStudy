program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

{�Զ����쳣��EMathException}
type
  EMathException = class(Exception) //������Exception,ϵͳ�Դ�

  end;


{һ�������������������쳣�ж�}
procedure MyDivFun(Num1,Num2 : Integer);
begin
  if(0 = Num2) then begin
    //�׳��쳣
    raise Exception.Create('��������Ϊ0');
  end;
  Writeln('***'); //���ִ�����׳��쳣����䣬���в������ִ�С�ֱ��Exit
end;



begin
{�ڶ��֣�try-finally�ṹ}
  try

   {����try-finally�ṹ��˵�����������Ƿ����쳣����ִ��}
   {��һ�֣�try-except�ṹ}
   try
    {����try-except�ṹ��˵�������ǿ��ܷ����쳣�Ĵ��롣����������}
    MyDivFun(10,0);
   except
   {�����ض����ͻ�������δ��ȷ���͵��쳣}
      {�ض�����}
      on E:EMathException do begin        //ExMathException ���Զ�����쳣���ͣ�ϵͳ�Դ�����Exception ���ࣩ
        Writeln(E.UnitName, E.ClassName, E.Message);  //��ӡ�쳣ʱ����Ϣ���õ��ķ����У���Ԫ�����������׳��쳣��Ϣ
      end;
      {�����쳣����}
      on E:Exception do begin
        Writeln(E.Message);
      end;
   end;

  finally
    //һ�������ͷ���Դ
    Writeln('�ͷ���Դ');
  end;

  Readln;
end.
