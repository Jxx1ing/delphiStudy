unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Edit4: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Image1: TImage;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure Edit1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
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
begin
  label2.Caption := '➕';
  edit4.Text := FloatToStr( StrToFloat(edit1.Text) + StrToFloat(edit2.Text) );
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  label2.caption := '➖';
  edit4.Text := FloatToStr( StrToFloat(edit1.Text) - StrToFloat(edit2.Text) );
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  label2.caption := '✖';
  edit4.Text := FloatToStr( StrToFloat(edit1.Text) * StrToFloat(edit2.Text) );
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  label2.Caption := '➗';
  edit4.Text := FloatToStr( StrToFloat(edit1.Text) / StrToFloat(edit2.Text) );
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  label2.Caption := 'AND';
  edit4.text := IntToStr( StrToInt(edit1.Text) And StrToInt(edit2.Text) );
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  label2.Caption := 'Or';
  edit4.text := IntToStr( StrToInt(edit1.Text) Or StrToInt(edit2.Text) );
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  label2.Caption := 'Not';
  edit4.text := IntToStr( Not StrToInt(edit1.Text) );
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  edit1.text := '';
end;

procedure TForm1.Edit2Click(Sender: TObject);
begin
  edit2.Text := '';
end;

end.
