unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uThreads, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btnStart: TButton;
    btnReset: TButton;
    lblNum: TLabel;
    grp1: TGroupBox;
    lblNum2: TLabel;
    btnStartNum: TButton;
    btnPauseNum: TButton;
    btnGoonNum: TButton;
    btnEnd: TButton;
    procedure btnResetClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStartNumClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPauseNumClick(Sender: TObject);
    procedure btnGoonNumClick(Sender: TObject);
    procedure btnEndClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ThreadWork: TWork;

implementation

{$R *.dfm}

procedure Work();
var
  Num: Integer;
begin
  for Num := 1 to 10000000 do begin
    Form1.lblNum.Caption := Num.ToString; //这里不能省略Form1.
    //线程休眠100毫秒
    TThread.Sleep(100);
  end;
end;


procedure TForm1.btnStartClick(Sender: TObject);
begin
  TThread.CreateAnonymousThread(work).Start;
{
  TThread.CreateAnonymousThread(
    procedure
    var
    Num: Integer;
    begin
      for num := 1 to 10000000 do
      begin
        lblNum.Caption := Num.ToString;
        //线程休眠0.1s
        TThread.Sleep(100);
      end;
    end).Start;
}
end;

procedure TForm1.btnStartNumClick(Sender: TObject);
begin
  ThreadWork.Start;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //true代表线程创建完对象立即执行（false不立即执行）
  ThreadWork := TWork.Create(True);
end;

procedure TForm1.btnEndClick(Sender: TObject);
begin
   try
    TerminateThread(ThreadWork.Handle, 0);
   except
     ShowMessage('终止失败')
   end;
end;

procedure TForm1.btnGoonNumClick(Sender: TObject);
begin
  ThreadWork.Suspended := False;
end;

procedure TForm1.btnPauseNumClick(Sender: TObject);
begin
  ThreadWork.Suspended := True;
end;

procedure TForm1.btnResetClick(Sender: TObject);
begin
  lblNum.caption := '0';
end;

end.
