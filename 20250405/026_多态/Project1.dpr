program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Unit1 in 'Unit1.pas';

//����ת�ͣ���������������ת��Ϊ�������������
procedure ShowAnimalRun(Animal : TAnimal);
var
  Dog : TDog;
begin
{
  //����ʱ����������
  Animal.Run;
  //����ת��: �Ѹ�����������ת��Ϊ�������������
  //ǿ������ת��
  Dog := TDog(Animal);
  Dog.LookDoor;
}
{
  if Animal.ClassName = 'TDog' then begin
    Dog := TDog(Animal);
    Dog.LookDoor;
  end;
}
  //�ж�һ�������Ƿ��һ�����ͼ���
  if Animal is TDog then begin
    Writeln('����ת���ɹ�');
    Dog := Animal as TDog;   //������Animalת��Ϊ������Dog
    Dog.LookDoor;
  end;

  if Assigned(Dog) then begin
    Writeln('���ǿ�ֵ');
end;
end;

var
  Animal : TAnimal;
begin
  ShowAnimalRun(TDog.Create);    //��������ܣ����ڿ���
  Readln;
end.
