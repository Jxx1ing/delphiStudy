unit uThreads;

interface

uses
  System.Classes, uDoMain, system.SysUtils;

type
  //�����߳���
  TProductionThread = class(TThread)
  private
    FProduct: TProduct;
  protected
    procedure Execute; override;
  public
  //���췽��
    constructor Create; overload;
    constructor Create(Product: TProduct); overload;
  end;

  //�����߳���
  TConsumptionThread = class(TThread)
  private
    FProduct: TProduct;
  protected
    procedure Execute; override;
  public
  //���췽��
    constructor Create; overload;
    constructor Create(Product: TProduct); overload;
  end;

implementation

uses
  unit1;

{ uThreads }
//�ղι���
constructor TProductionThread.Create;
begin
  //���ø��๹��
  inherited Create(True); //true��ʾ�̴߳���������ڵ���start������Ż�����߳�
end;

//�вι���
constructor TProductionThread.Create(Product: TProduct);
begin
  inherited Create(False);
  Self.FProduct := Product;
end;

//�����̵߳Ĵ���
procedure TProductionThread.Execute;
var
  str: string;
begin
  while True do
  begin
    //TMonitor��ͬ���̡߳���enter���� �����ٽ���
    System.TMonitor.Enter(Self.FProduct);
    //��Ϊfalseʱ��ʾû�в�Ʒ
    if not Self.FProduct.IsConsumption then
    begin
      Self.FProduct.id := Self.FProduct.id + 1;
      str := '�����߳�ID: ' + Self.ThreadID.ToString + '��ǰ��Ʒ���' + Self.FProduct.Id.ToString;
      Form1.mmo1.Lines.add(str);
      //�ñ����ڵȴ�״̬
      Self.Sleep(500);
      //������ɺ��ʾ�в�Ʒ
      Self.FProduct.IsConsumption := True;
    end;


    //֪ͨ�������߳̽�������
    System.TMonitor.Pulse(Self.FProduct);
    //���̴߳��ڵȴ�״̬ (INFINITE��һ���������������޵ȴ���ֱ�������߳�ͨ��pulse��������)
    System.TMonitor.Wait(Self.FProduct, INFINITE);
    //TMonitor��ͬ���̡߳���exit����  �˳��ٽ���
    System.TMonitor.Exit(Self.FProduct);
  end;
end;

{ TConsumptionThread }
//�����̴߳���ִ��
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
    //TMonitor��ͬ���̡߳���enter���� �����ٽ���
    System.TMonitor.Enter(Self.FProduct);
    //��Ϊtrueʱ���в�Ʒ��������
    if Self.FProduct.IsConsumption then
    begin
      str := '�����߳�ID: ' + Self.ThreadID.ToString + '��ǰ��Ʒ���' + Self.FProduct.Id.ToString;
      Form1.mmo1.Lines.add(str);
      //�ñ����ڵȴ�״̬
      Self.Sleep(500);
      //������ɺ�û�в�Ʒ
      Self.FProduct.IsConsumption := false;
    end;

    //֪ͨ�������߳̽�������
    System.TMonitor.Pulse(Self.FProduct);
    //���̴߳��ڵȴ�״̬ (INFINITE��һ���������������޵ȴ���ֱ�������߳�ͨ��pulse��������)
    System.TMonitor.Wait(Self.FProduct, INFINITE);
    //TMonitor��ͬ���̡߳���exit����  �˳��ٽ���
    System.TMonitor.Exit(Self.FProduct);
  end;
end;

end.

