unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Generics.Collections,               //容器
  AddFormUnit,TDictionaryUnit,TStudentUnit;  //自定义其他单元

type
  TForm1 = class(TForm)
    btnIncrease: TButton;
    btnDelete: TButton;
    btnFind: TButton;
    btnModify: TButton;
    mmo1Show: TMemo;
    procedure btnIncreaseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.btnIncreaseClick(Sender: TObject);
{点击增加时，创建一个新的Form}
var
  AddForm : TFormAdd;
begin
  AddForm := TFormAdd.Create(Self); //Self代表当前窗口

  {调整下新窗体界面}
  AddForm.Left := Self.Left + 70;
  AddForm.Top := Self.Top + 15;
  {用户必须先关闭该表单（窗口），才能继续操作其他窗口}
  AddForm.ShowModal;
end;


procedure TForm1.btnDeleteClick(Sender: TObject);
begin
  {清空字典容器}
  TDic.MyClear;
  {清空TMemo的显示}
  mmo1Show.Clear;
end;


procedure TForm1.btnFindClick(Sender: TObject);
var
  StuDic : TDictionary<string,TStudent>;
  Stu : TStudent;
begin
  {清空memo}
  mmo1Show.Clear;
  {将TDic类构建的字典赋值给StuDic}
  StuDic := TDic.ShowStu;
  {接下来开始遍历}
  for Stu in StuDic.values do
  begin
    mmo1Show.Lines.Add(Stu.id + ',' + Stu.name + ',' + Stu.age.ToString); //整型转化为字符型
  end;
end;


{自己写的修改，可以不看}
procedure TForm1.btnModifyClick(Sender: TObject);
var
  Stu : TStudent;
begin
   {清空memo}
  mmo1Show.Clear;
  Stu := TStudent.Create('0','Steven',18);     //删除一个id，增加默认的一个学生信息
  TDic.modifyStu('1',Stu);  //因为1不存在，所以其实每次会增加上面那条学生信息
end;

end.
