unit uThreads;

interface

uses
  System.SysUtils, System.Classes;

type
  TWork = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
    procedure operation;
  end;

implementation

uses
  Unit1;  //局部引用（但是有循环引用的风险）

{ TWork }

procedure TWork.Execute;
begin
  Operation();
end;

procedure TWork.operation;
var
  Num: Integer;
begin
  for Num := 1 to 10000000 do begin
    Form1.lblNum2.Caption := Num.ToString;
    TThread.Sleep(100);
  end;
end;

end.
