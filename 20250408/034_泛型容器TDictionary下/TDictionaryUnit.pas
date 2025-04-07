unit TDictionaryUnit;

interface
uses
  {���ͼ���}
  System.Generics.Collections,
  {ShowMessage}
  Vcl.Dialogs,
  {TStudent��}
  TStudentUnit;

type
  TDic = class
  public
  {class�ؼ���ʹ�ã��÷�������ʱ����Ҫ��������}
  {����}
  class procedure MyAdd(Stu : TStudent); //����add()
  {ɾ��}
  class procedure MyClear();
  {����,���﹦�ܽ�����ʾ����Ԫ�ظ�����}
  class function ShowStu: TDictionary<string,TStudent>;
  {�޸�}
  class procedure modifyStu(OldId: string; NewStu: TStudent);
  end;

implementation

{ TDic }
var
  StudentsDic : TDictionary<string,TStudent>; //key��id,value��һ��ѧ������

class procedure TDic.MyAdd(Stu: TStudent);
begin
  {������ڣ�����ʾ�Ѿ����ڣ���������ڣ������}
  if StudentsDic.ContainsKey(Stu.id) then
  begin
    ShowMessage('���ѧ���Ѿ�����');
  end
  else
  begin
      StudentsDic.add(Stu.id,Stu);
  end;
end;

class procedure TDic.MyClear;
begin
  StudentsDic.Clear;
end;


{��- �ر�ע�⣺����Ǻ����������ǹ���}
class function TDic.ShowStu: TDictionary<string,TStudent>;
begin
  Result := StudentsDic;
end;

{�ġ� �Լ�д�ģ��Ϻ�û��ʵ�֣� �����޸�Ҳ�У�}
class procedure TDic.modifyStu(OldId: string; NewStu: TStudent);
begin
  if StudentsDic.ContainsKey(OldId) then
  begin
    StudentsDic.Remove(OldId);
  end
  else
    ShowMessage('��ѧ��������');

  StudentsDic.Add(NewStu.ID, NewStu);
  ShowMessage('�޸ĳɹ�');
end;

{�õ�Ԫ������ʱ����ʼ��StudentDic����}
initialization
  StudentsDic := TDictionary<string,TStudent>.Create();

end.
