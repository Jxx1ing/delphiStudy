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
    
    str := '�����߳�ID: ' + Self.ThreadID.ToString + '��ǰ��Ʒ���' + Self.FProduct.Id.ToString;
    Form1.mmo1.Lines.add(str);
    Self.Sleep(100);
    Self.FProduct.id := Self.FProduct.id + 1;

    if Self.FProduct.id = 10 then
    begin
      Exit;
    end;

    
    //TMonitor��ͬ���̡߳���exit����  �˳��ٽ���
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

