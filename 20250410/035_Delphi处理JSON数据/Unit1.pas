unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls,
  Unit2,
  System.JSON,System.JSON.Serializers,
  System.Generics.Collections;

type
  TForm1 = class(TForm)
    btn1: TButton;
    btn2: TButton;
    mmo1: TMemo;
    btn3: TButton;
    btn4: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
 //������һ�����󣨱���TStudent�� �� JSON�ַ�����ת��
procedure TForm1.btn1Click(Sender: TObject);
var
  UserJson: string;
  Serializer : TJsonSerializer;
  Student: TStudent;
begin
  //�ַ������͵�json����
  UserJson := '{"FName":"С��","FAge":18}';
  Serializer := TJsonSerializer.Create();
  //�����л�
  {����ֵ��T��}
  Student := Serializer.Deserialize<TStudent>(UserJson);
  mmo1.Lines.Add('�����л�:' + Student.Name + ',' + Student.Age.ToString);
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  UserJson: string;
  Serializer : TJsonSerializer;
  Student: TStudent;
begin
 //����ʵ�������
  Student := TStudent.Create;
  Student.Name := 'С��';
  Student.Age := 30;
 //�������л�����
  Serializer := TJsonSerializer.Create();
  //���л�
  {����ֵ��һ��string}
  mmo1.Lines.Add('���л���' + Serializer.Serialize<TStudent>(Student));
end;



//���濪ʼ�Ǽ���(����TList,Ԫ����TStduent) �� JSON�ַ�����ת��
procedure TForm1.btn3Click(Sender: TObject);
var
  Serializer : TJsonSerializer;
  Student: TStudent;
  List : TList<TStudent>;
begin
  List := TList<TStudent>.Create();
  List.Add(TStudent.Create('С��', 30));
  List.Add(TStudent.Create('��Ǿ', 30));
  Serializer := TJsonSerializer.Create();
  mmo1.Lines.Add('���л���' + Serializer.Serialize< TList<TStudent> >(List));
end;

procedure TForm1.btn4Click(Sender: TObject);
var
  UserJson: string;
  Serializer : TJsonSerializer;
  List: TList<TStudent>;

  Stu : TStudent;
begin
  UserJson := '{"FListHelper":[{"FName":"С��","FAge":30},{"FName":"��Ǿ","FAge":30}],"FComparer":{}}';
  //���������л�����
  Serializer := TJsonSerializer.Create();
  List := Serializer.Deserialize<TList<TStudent>>(UserJson);

  //����
  for Stu in List do
  begin
    mmo1.Lines.Add('�����л�:' + Stu.Name + ',' + Stu.Age.ToString);
  end;

  {����JSON�ַ���}
  {��������������} //���2
  mmo1.Lines.Add(TJSONObject.ParseJSONValue(USerJson).GetValue<TJSONArray>('FListHelper').Count.Tostring);
end;


end.

