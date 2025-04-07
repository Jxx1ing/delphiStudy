unit AddFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Generics.Collections,
  TDictionaryUnit,TStudentUnit;  //�Զ���������Ԫ;

type
  TFormAdd = class(TForm)
    lblName: TLabel;
    lblAge: TLabel;
    edtName: TEdit;
    edtAge: TEdit;
    btnSave: TButton;
    procedure edtNameClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtAgeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAdd: TFormAdd;

implementation

{$R *.dfm}

procedure TFormAdd.btnSaveClick(Sender: TObject);
var
  Dictionary : TDictionary<string,TStudent>;
  key : string;
  Stu : TStudent;
begin
  {����������ѧ��}
  TDic.MyAdd(TStudent.Create(TGUID.NewGuid.ToString, EdtName.Text, StrToInt(edtAge.Text)));
  ShowMessage('����ɹ�');
  {����ɹ������Զ��˳�}
  Self.Close;
end;



procedure TFormAdd.edtAgeClick(Sender: TObject);
begin
  edtAge.Text := '';
end;

procedure TFormAdd.edtNameClick(Sender: TObject);
begin
  edtName.Text := '';
end;

end.
