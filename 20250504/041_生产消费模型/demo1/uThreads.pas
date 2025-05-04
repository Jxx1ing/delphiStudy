unit uThreads;

interface

uses
  System.Classes, uDoMain, system.SysUtils;

type
  //生产线程类
  TProductionThread = class(TThread)
  private
    FProduct: TProduct;
  protected
    procedure Execute; override;
  public
  //构造方法
    constructor Create; overload;
    constructor Create(Product: TProduct); overload;
  end;

  //消费线程类
  TConsumptionThread = class(TThread)
  protected
    procedure Execute; override;
  public
  //构造方法
    constructor Create; overload;
    constructor Create(Product: TProduct); overload;
  end;

implementation

uses
  unit1;

{ uThreads }
//空参构造
constructor TProductionThread.Create;
begin
  //调用父类构造
  inherited Create(True); //true表示线程创建后挂起，在调用start方法后才会继续线程
end;

//有参构造
constructor TProductionThread.Create(Product: TProduct);
begin
  inherited Create(False);
  Self.FProduct := Product;
end;

//启动线程的代码
procedure TProductionThread.Execute;
var
  str: string;
begin
  while True do
  begin
    //TMonitor类同步线程——enter方法 进入临界区
    System.TMonitor.Enter(Self.FProduct);
    
    str := '消费线程ID: ' + Self.ThreadID.ToString + '当前产品编号' + Self.FProduct.Id.ToString;
    Form1.mmo1.Lines.add(str);
    Self.Sleep(100);
    Self.FProduct.id := Self.FProduct.id + 1;

    if Self.FProduct.id = 10 then
    begin
      Exit;
    end;

    
    //TMonitor类同步线程——exit方法  退出临界区
    System.TMonitor.Exit(Self.FProduct);
  end;
end;

{ TConsumptionThread }

constructor TConsumptionThread.Create(Product: TProduct);
begin

end;

constructor TConsumptionThread.Create;
begin

end;

procedure TConsumptionThread.Execute;
begin
  

end;

end.

