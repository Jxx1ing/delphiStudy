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
  private
    FProduct: TProduct;
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
    //当为false时表示没有产品
    if not Self.FProduct.IsConsumption then
    begin
      Self.FProduct.id := Self.FProduct.id + 1;
      str := '消费线程ID: ' + Self.ThreadID.ToString + '当前产品编号' + Self.FProduct.Id.ToString;
      Form1.mmo1.Lines.add(str);
      //让本身处于等待状态
      Self.Sleep(500);
      //生产完成后表示有产品
      Self.FProduct.IsConsumption := True;
    end;


    //通知消费者线程进行消费
    System.TMonitor.Pulse(Self.FProduct);
    //让线程处于等待状态 (INFINITE是一个常量，代表无限等待。直到其他线程通过pulse方法唤醒)
    System.TMonitor.Wait(Self.FProduct, INFINITE);
    //TMonitor类同步线程——exit方法  退出临界区
    System.TMonitor.Exit(Self.FProduct);
  end;
end;

{ TConsumptionThread }
//消费线程代码执行
constructor TConsumptionThread.Create(Product: TProduct);
begin
  inherited Create(False);
  Self.FProduct := Product;
end;

constructor TConsumptionThread.Create;
begin
  inherited Create(True);
end;

procedure TConsumptionThread.Execute;
var
  str: string;
begin
  while True do
  begin
    //TMonitor类同步线程——enter方法 进入临界区
    System.TMonitor.Enter(Self.FProduct);
    //当为true时，有产品进行消费
    if Self.FProduct.IsConsumption then
    begin
      str := '生产线程ID: ' + Self.ThreadID.ToString + '当前产品编号' + Self.FProduct.Id.ToString;
      Form1.mmo1.Lines.add(str);
      //让本身处于等待状态
      Self.Sleep(500);
      //消费完成后没有产品
      Self.FProduct.IsConsumption := false;
    end;

    //通知生产者线程进行生产
    System.TMonitor.Pulse(Self.FProduct);
    //让线程处于等待状态 (INFINITE是一个常量，代表无限等待。直到其他线程通过pulse方法唤醒)
    System.TMonitor.Wait(Self.FProduct, INFINITE);
    //TMonitor类同步线程——exit方法  退出临界区
    System.TMonitor.Exit(Self.FProduct);
  end;
end;

end.

