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
 //这里是一个对象（比如TStudent） 与 JSON字符串的转换
procedure TForm1.btn1Click(Sender: TObject);
var
  UserJson: string;
  Serializer : TJsonSerializer;
  Student: TStudent;
begin
  //字符串类型的json对象
  UserJson := '{"FName":"小黑","FAge":18}';
  Serializer := TJsonSerializer.Create();
  //反序列化
  {返回值是T类}
  Student := Serializer.Deserialize<TStudent>(UserJson);
  mmo1.Lines.Add('反序列化:' + Student.Name + ',' + Student.Age.ToString);
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  UserJson: string;
  Serializer : TJsonSerializer;
  Student: TStudent;
begin
 //创建实体类对象
  Student := TStudent.Create;
  Student.Name := '小白';
  Student.Age := 30;
 //创建序列化对象
  Serializer := TJsonSerializer.Create();
  //序列化
  {返回值是一个string}
  mmo1.Lines.Add('序列化：' + Serializer.Serialize<TStudent>(Student));
end;



//下面开始是集合(比如TList,元素是TStduent) 与 JSON字符串的转换
procedure TForm1.btn3Click(Sender: TObject);
var
  Serializer : TJsonSerializer;
  Student: TStudent;
  List : TList<TStudent>;
begin
  List := TList<TStudent>.Create();
  List.Add(TStudent.Create('小白', 30));
  List.Add(TStudent.Create('萧蔷', 30));
  Serializer := TJsonSerializer.Create();
  mmo1.Lines.Add('序列化：' + Serializer.Serialize< TList<TStudent> >(List));
end;

procedure TForm1.btn4Click(Sender: TObject);
var
  UserJson: string;
  Serializer : TJsonSerializer;
  List: TList<TStudent>;

  Stu : TStudent;
begin
  UserJson := '{"FListHelper":[{"FName":"小白","FAge":30},{"FName":"萧蔷","FAge":30}],"FComparer":{}}';
  //创建反序列化对象
  Serializer := TJsonSerializer.Create();
  List := Serializer.Deserialize<TList<TStudent>>(UserJson);

  //遍历
  for Stu in List do
  begin
    mmo1.Lines.Add('反序列化:' + Stu.Name + ',' + Stu.Age.ToString);
  end;

  {解析JSON字符串}
  {数组有两条数据} //输出2
  mmo1.Lines.Add(TJSONObject.ParseJSONValue(USerJson).GetValue<TJSONArray>('FListHelper').Count.Tostring);
end;


end.

