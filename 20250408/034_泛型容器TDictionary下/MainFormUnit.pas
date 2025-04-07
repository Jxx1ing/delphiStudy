unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Generics.Collections,               //����
  AddFormUnit,TDictionaryUnit,TStudentUnit;  //�Զ���������Ԫ

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
{�������ʱ������һ���µ�Form}
var
  AddForm : TFormAdd;
begin
  AddForm := TFormAdd.Create(Self); //Self����ǰ����

  {�������´������}
  AddForm.Left := Self.Left + 70;
  AddForm.Top := Self.Top + 15;
  {�û������ȹرոñ������ڣ������ܼ���������������}
  AddForm.ShowModal;
end;


procedure TForm1.btnDeleteClick(Sender: TObject);
begin
  {����ֵ�����}
  TDic.MyClear;
  {���TMemo����ʾ}
  mmo1Show.Clear;
end;


procedure TForm1.btnFindClick(Sender: TObject);
var
  StuDic : TDictionary<string,TStudent>;
  Stu : TStudent;
begin
  {���memo}
  mmo1Show.Clear;
  {��TDic�๹�����ֵ丳ֵ��StuDic}
  StuDic := TDic.ShowStu;
  {��������ʼ����}
  for Stu in StuDic.values do
  begin
    mmo1Show.Lines.Add(Stu.id + ',' + Stu.name + ',' + Stu.age.ToString); //����ת��Ϊ�ַ���
  end;
end;


{�Լ�д���޸ģ����Բ���}
procedure TForm1.btnModifyClick(Sender: TObject);
var
  Stu : TStudent;
begin
   {���memo}
  mmo1Show.Clear;
  Stu := TStudent.Create('0','Steven',18);     //ɾ��һ��id������Ĭ�ϵ�һ��ѧ����Ϣ
  TDic.modifyStu('1',Stu);  //��Ϊ1�����ڣ�������ʵÿ�λ�������������ѧ����Ϣ
end;

end.
