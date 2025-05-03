unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls,
  System.IniFiles, system.IOUtils;

type
  TForm1 = class(TForm)
    lblName: TLabel;
    lblgender: TLabel;
    edtName: TEdit;
    dbrgrp1: TDBRadioGroup;
    rbBoy: TRadioButton;
    rbGirl: TRadioButton;
    lblAge: TLabel;
    edtAge: TEdit;
    lblHobby: TLabel;
    grp1: TGroupBox;
    chkMoney: TCheckBox;
    chkProgram: TCheckBox;
    lblPosition: TLabel;
    btnSave: TButton;
    cbbPostion: TComboBox;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ConfigPath : string;

implementation

{$R *.dfm}

procedure TForm1.btnSaveClick(Sender: TObject);
var
  IniFile: TIniFile;
  Section: string;
begin
  //�����ļ�
  {�����ļ� ����·��}
  IniFile := TIniFile.Create(ConfigPath);
  {�� ÿ���ڿ��԰��������ֵ�� key-value}
  Section := 'basic';
  {����}
  IniFile.WriteString(Section, 'editName', edtName.text);
  {����}
  IniFile.WriteString(Section, 'editAge', edtAge.Text);
  {�Ա� '����' �Ƿ�ѡ��}
  IniFile.WriteBool(Section, 'editGender', rbBoy.Checked);
  {���� 'Ǯ'�Ƿ�ѡ�� / '���'�Ƿ�ѡ��}
  IniFile.WriteBool(Section, 'chkMoney', chkMoney.Checked);
  IniFile.WriteBool(Section, 'chkProgram', chkProgram.Checked);
  {��ַ ѡ�е��ǵڼ�����ַ 0��1��2}
  IniFile.WriteInteger(Section, 'cbbPostion', cbbPostion.ItemIndex);
  //ShowMessage(TDirectory.GetCurrentDirectory());
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
begin
  ConfigPath := TDirectory.GetCurrentDirectory() + '\UserConfig.ini';
  IniFile := TIniFile.Create(ConfigPath);
  edtName.Text := IniFile.ReadString('basic', 'editName', '');
  edtAge.Text := IniFile.ReadString('basic', 'editAge', '');
  rbBoy.Checked := IniFile.ReadBool('basic', 'editGender', False);
  rbGirl.Checked := not rbBoy.Checked;
  chkMoney.Checked := IniFile.ReadBool('basic', 'chkMoney', False);
  chkProgram.Checked := IniFile.ReadBool('basic', 'chkProgram', False);
  cbbPostion.ItemIndex := IniFile.ReadInteger('basic', 'cbbPostion', 0);
end;

end.
