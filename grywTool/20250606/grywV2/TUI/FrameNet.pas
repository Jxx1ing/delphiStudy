unit FrameNet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ControlList, CoreNet, Generics.Collections,
  Math, StrUtils, HttpGet, Vcl.ComCtrls;

type
  TFrmNet = class(TFrame)
    pnlNet: TPanel;
    scrlbxNet: TScrollBox;
    btnNet: TButton;
    lstBasicConnet: TControlList;
    lblBasicConnectKey: TLabel;
    lblBasicConnectValue: TLabel;
    tmrLatencyAndLoss: TTimer;
    lstLatencyAndLoss: TControlList;
    lblLatencyAndLossKey: TLabel;
    lblLatencyAndLossValue: TLabel;
    pbNetCheck: TProgressBar;
    lstConfig: TControlList;
    lblConfigKey: TLabel;
    lblConfigValue: TLabel;
    btnFix: TButton;
    procedure lstBasicConnetBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure lstLatencyAndLossBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnNetClick(Sender: TObject);
    procedure lstConfigBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnFixClick(Sender: TObject);
    procedure tmrLatencyAndLossTimer(Sender: TObject);
  private
    FNetManger: TNetManger;
    FBasicConnetDic: TDictionary<Integer, string>;
    FLatencyAndLossDic: TDictionary<Integer, string>;
    FDNSAndProxyDic: TDictionary<Integer, string>;
    procedure UpdateBasicConnect;
    procedure UpdateDNSAndProxy;
    procedure UpdateFixConfig;
    procedure UpdatedateLatencyAndLoss;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

const
  SAASCONNECT = 'SaaSServer连接（saas.fscut.com）';
  CLOUDCONNECT = 'CloudServer连接（cloudnest.fscut.com）';
  INTERNETCONNECT = 'Internet访问（www.baidu.com）';
  CONNECTSUCCESSED = '连接成功';
  CONNECTFAILED = '连接失败';
  DNSRESOLVER = 'DNS解析器';
  PROXYSETTINGS = '代理设置';
  PROXYOPENING = '代理已开启，请关闭代理';
  PROXYCLOSEING = '代理未开启';
  DNSSETTINGTRUE = 'DNS设置正确';
  DNSSETTINGFALSE = 'DNS设置错误，请参考手册';
  SAASLATENCYANDLOSS = 'SaaSServer 延迟 / 丢包率';
  CLOUDLATENCYANDLOSS = 'CloudServer 延迟 / 丢包率';
  DNSFIXSUCCESSED = '修复成功：223.5.5.5 , 114.114.114.114';
  DNSFIXFAILED = '修复失败：请尝试以管理员权限修复';

implementation

{$R *.dfm}

{ TFrmNet }

procedure TFrmNet.btnFixClick(Sender: TObject);
begin
  FNetManger.Fix;
  UpdateFixConfig;
end;

procedure TFrmNet.btnNetClick(Sender: TObject);
var
  BasicConnectChecker: TBasicConnectChecker;
  LatencyAndLossChecker: TLatencyAndLossChecker;
begin
  btnNet.Enabled := False;
  pbNetCheck.Style := pbstMarquee;
  tmrLatencyAndLoss.Enabled := True;

  FNetManger.Excute;   //执行网络检测

  UpdateBasicConnect;
  UpdateDNSAndProxy;
  //开始延迟和丢包率
  LatencyAndLossChecker := TLatencyAndLossChecker(FNetManger.Checkers[LatencyAndLoss]);
  LatencyAndLossChecker.StartThreadTest;
end;

constructor TFrmNet.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;
  FNetManger := TNetManger.Create;

  //测试基本连接
  lstBasicConnet.ItemCount := 3;
  FBasicConnetDic := TDictionary<Integer, string>.Create;
  for I := 0 to lstBasicConnet.ItemCount - 1 do
  begin
    FBasicConnetDic.Add(I, '');
  end;

  //测试网络配置信息
  lstConfig.ItemCount := 2;
  FDNSAndProxyDic := TDictionary<Integer, string>.Create;
  for I := 0 to lstConfig.ItemCount - 1 do
  begin
    FDNSAndProxyDic.Add(I, '');
  end;

  //测试延迟和丢包率
  lstLatencyAndLoss.ItemCount := 2;
  FLatencyAndLossDic := TDictionary<Integer, string>.Create;
  for I := 0 to lstLatencyAndLoss.ItemCount - 1 do
  begin
    FLatencyAndLossDic.Add(I, '');
  end;
end;

destructor TFrmNet.Destroy;
begin
  if Assigned(FNetManger) then
    FNetManger.Destroy;
  FBasicConnetDic.Free;
  FLatencyAndLossDic.Free;
  FDNSAndProxyDic.Free;
  inherited;
end;

procedure TFrmNet.lstBasicConnetBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  case AIndex of
    0:
      lblBasicConnectKey.Caption := SAASCONNECT;
    1:
      lblBasicConnectKey.Caption := CLOUDCONNECT;
    2:
      lblBasicConnectKey.Caption := INTERNETCONNECT;
  end;
  lblBasicConnectValue.Caption := FBasicConnetDic[AIndex];
end;

procedure TFrmNet.lstConfigBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  case AIndex of
    0:
      lblConfigKey.Caption := DNSRESOLVER;
    1:
      lblConfigKey.Caption := PROXYSETTINGS;
  end;
  lblConfigValue.Caption := FDNSAndProxyDic[AIndex];
end;

procedure TFrmNet.lstLatencyAndLossBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  case AIndex of
    0:
      lblLatencyAndLossKey.Caption := SAASLATENCYANDLOSS;
    1:
      lblLatencyAndLossKey.Caption := CLOUDLATENCYANDLOSS;
  end;
  lblLatencyAndLossValue.Caption := FLatencyAndLossDic[AIndex];
end;

procedure TFrmNet.tmrLatencyAndLossTimer(Sender: TObject);
begin
  UpdatedateLatencyAndLoss;
end;

procedure TFrmNet.UpdateBasicConnect;
var
  BasicConnectChecker: TBasicConnectChecker;
begin
  BasicConnectChecker := TBasicConnectChecker(FNetManger.Checkers[BasicConnet]);
  if FNetManger.GetResult(BasicConnet) then
  begin
    BasicConnectChecker := TBasicConnectChecker(FNetManger.Checkers[BasicConnet]);
    FBasicConnetDic[Ord(SaaSLink)] := IfThen(BasicConnectChecker.SaaSConnected, CONNECTSUCCESSED, CONNECTFAILED);
    FBasicConnetDic[Ord(CloudLink)] := IfThen(BasicConnectChecker.CloudConnected, CONNECTSUCCESSED, CONNECTFAILED);
    FBasicConnetDic[Ord(InternetLink)] := IfThen(BasicConnectChecker.InternetConnected, CONNECTSUCCESSED, CONNECTFAILED);
    lstBasicConnet.Invalidate;
  end;
end;

procedure TFrmNet.UpdatedateLatencyAndLoss;
var
  LatencyAndLossChecker: TLatencyAndLossChecker;
  SaaSResult, CloudResult: TMethodResult;
begin
  LatencyAndLossChecker := TLatencyAndLossChecker(FNetManger.Checkers[LatencyAndLoss]);
  if FNetManger.GetResult(LatencyAndLoss) then
  //if LatencyAndLossChecker.Check then
  begin
    tmrLatencyAndLoss.Enabled := False;
    LatencyAndLossChecker.CollectThreadResults;
    SaaSResult := LatencyAndLossChecker.CalAvgLatencyAndLoss(SaaS);
    CloudResult := LatencyAndLossChecker.CalAvgLatencyAndLoss(Cloud);
    FLatencyAndLossDic[Ord(SaaS)] := Format('延迟: %d ms | 丢包: %.2f%%', [SaaSResult.Latency, SaaSResult.PacketLoss]);
    FLatencyAndLossDic[Ord(Cloud)] := Format('延迟: %d ms | 丢包: %.2f%%', [CloudResult.Latency, CloudResult.PacketLoss]);
    lstLatencyAndLoss.Invalidate;

    btnNet.Enabled := True;
    pbNetCheck.Style := pbstNormal;
  end;
end;

procedure TFrmNet.UpdateDNSAndProxy;
var
  ConfigChecker: TConfigChecker;
begin
  ConfigChecker := TConfigChecker(FNetManger.Checkers[Config]);
  if FNetManger.GetResult(Config) then
  begin
    FDNSAndProxyDic[Ord(DNSconfig)] := IfThen(ConfigChecker.DNSIsTrue, DNSSETTINGTRUE, DNSSETTINGFALSE);
    FDNSAndProxyDic[Ord(Proxyconfig)] := IfThen(ConfigChecker.ProxyOpened, PROXYOPENING, PROXYCLOSEING);
    lstConfig.Invalidate;
  end;
end;

procedure TFrmNet.UpdateFixConfig;
begin
  FDNSAndProxyDic[Ord(DNSconfig)] := IfThen(FNetManger.Fix, DNSFIXSUCCESSED, DNSFIXFAILED);
  lstConfig.Invalidate;
end;

end.

