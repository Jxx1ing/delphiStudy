unit TDictionaryUnit;

interface
uses
  {泛型集合}
  System.Generics.Collections,
  {ShowMessage}
  Vcl.Dialogs,
  {TStudent类}
  TStudentUnit;

type
  TDic = class
  public
  {class关键字使得：该方法调用时不需要创建对象}
  {增加}
  class procedure MyAdd(Stu : TStudent); //调用add()
  {删除}
  class procedure MyClear();
  {查找,这里功能叫做显示所有元素更合适}
  class function ShowStu: TDictionary<string,TStudent>;
  {修改}
  class procedure modifyStu(OldId: string; NewStu: TStudent);
  end;

implementation

{ TDic }
var
  StudentsDic : TDictionary<string,TStudent>; //key是id,value是一个学生对象

class procedure TDic.MyAdd(Stu: TStudent);
begin
  {如果存在，则显示已经存在；如果不存在，则插入}
  if StudentsDic.ContainsKey(Stu.id) then
  begin
    ShowMessage('这个学生已经存在');
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


{查- 特别注意：这个是函数，其他是过程}
class function TDic.ShowStu: TDictionary<string,TStudent>;
begin
  Result := StudentsDic;
end;

{改— 自己写的，老侯没有实现（ 不看修改也行）}
class procedure TDic.modifyStu(OldId: string; NewStu: TStudent);
begin
  if StudentsDic.ContainsKey(OldId) then
  begin
    StudentsDic.Remove(OldId);
  end
  else
    ShowMessage('该学生不存在');

  StudentsDic.Add(NewStu.ID, NewStu);
  ShowMessage('修改成功');
end;

{该单元被加载时，初始化StudentDic对象}
initialization
  StudentsDic := TDictionary<string,TStudent>.Create();

end.
