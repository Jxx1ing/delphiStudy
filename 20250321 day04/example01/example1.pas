unit example1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Edit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  temp : integer;
begin
  temp := StrToInt( edit1.text);
  label1.Caption := IntToStr(temp mod 10);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  temp : integer;
begin
  temp := StrToInt( edit1.text);
  label2.Caption := IntToStr(temp mod 100 div 10);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  temp : integer;
begin
  temp := StrToInt( edit1.Text );
  label3.Caption := IntToStr(temp div 100 mod 10);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  temp : integer;
begin
   temp := StrToInt( edit1.Text );
   label4.Caption := IntToStr(temp div 1000);
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  edit1.Text := '';
end;

end.
