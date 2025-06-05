unit CoreNet;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes,
  System.Net.HttpClient, ActiveX, ComObj, Variants, Registry, Winapi.Windows,
  StrUtils, SynCrtSock, System.Math, Vcl.StdCtrls, Vcl.Controls,
  System.Net.URLClient, msxml, HttpGet;

type
  TItemType = (BasicConnet, Config, LatencyAndLoss);

  TMethodType = (Winhttp, Serverxmlhttp, Xmlhttp, Httpclient, Socket);

  TServerType = (SaaS, Cloud);

  TLinkTest = (SaaSLink, CloudLink, InternetLink);

  TConfig = (DNSconfig, Proxyconfig);

type
  TNetChecker = class abstract
  private
    IsCompleted: Boolean;
  public
    function Check(): Boolean; virtual; abstract;
    function Fix(): Boolean; virtual; abstract;
    property Completed: Boolean read IsCompleted write IsCompleted;
  end;

type
  TNetManger = class
  private
    FCheckers: TDictionary<TItemType, TNetChecker>;     //检测类型-检测器
    FResult: TDictionary<TItemType, Boolean>;         //检测类型-检测是否完成
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitCheckers;   //初始化每个检测器
    procedure Excute(); //执行所有类型检测
    function Fix: Boolean;    //修改用户的DNS
    property Checkers: TDictionary<TItemType, TNetChecker> read FCheckers;
    function GetResult(ItemType: TItemType): Boolean;
  end;

type
  TBasicConnectChecker = class(TNetChecker)
  private
    IsCompleted: Boolean;
    ResultSaaS: Boolean;
    ResultCloud: Boolean;
    ResultInternet: Boolean;
  public
    function Check(): Boolean; override;
    function HttpRequest(TestUrl: string): Boolean;
    function Fix(): Boolean; override;
    property Completed: Boolean read IsCompleted write IsCompleted;
    property SaaSConnected: Boolean read ResultSaaS;
    property CloudConnected: Boolean read ResultCloud;
    property InternetConnected: Boolean read ResultInternet;
  end;

type
  TConfigChecker = class(TNetChecker)
  private
    IsCompleted: Boolean;
    ResultProxy: Boolean;
    ResultDNS: Boolean;
    function GetProxyStatus: Boolean;
    function FixDNS: Boolean;
    function CheckDNS: Boolean;
  public
    function Check(): Boolean; override;
    function Fix(): Boolean; override;
    property Completed: Boolean read IsCompleted write IsCompleted;
    property ProxyOpened: Boolean read ResultProxy;
    property DNSIsTrue: Boolean read ResultDNS;
  end;

type
  TNetRequestFunc = function(const Url: string): TMethodResult;   //定义统一的函数指针类型

type
  TNetThread = class(TThread)
  private
    FServerType: TServerType;
    FMethodType: TMethodType;
    FNetRequestFunc: TNetRequestFunc;
    TmpMethodResult: TPair<TMethodType, TMethodResult>;
    FFinished: Boolean;
  public
    constructor Create(ServerType: TServerType; MethodType: TMethodType; NetRequestFunc: TNetRequestFunc);
    destructor destroy; override;
    procedure Execute; override;
    property Finished: Boolean read FFinished write FFinished;
  end;

type
  TLatencyAndLossChecker = class(TNetChecker)
  private
    IsCompleted: Boolean;
    FServerType: TServerType;
    FMethods: TDictionary<TMethodType, TNetRequestFunc>;
    FThreads: TList<TNetThread>;
    FLatencyAndLossResult: TDictionary<TServerType, TDictionary<TMethodType, TMethodResult>>;
    FCompleted: TDictionary<TServerType, Boolean>;      //检测服务器类型-是否完成
    property Completed: Boolean read IsCompleted write IsCompleted;
  public
    constructor Create;
    destructor Destroy; override;
    procedure StartThreadTest;
    procedure CollectThreadResults;
    function CalAvgLatencyAndLoss(ServerType: TServerType): TMethodResult;
    function Check(): Boolean; override;
    function Fix(): Boolean; override;
  end;

const
  SAASURL = 'https://saas.fscut.com/api/site/v1';
  CLOUDURL = 'https://cloudnest.fscut.com/api/server_version';
  BAIDUURL = 'https://www.baidu.com/';
  REGINTERNETSETTINGSPATH = 'Software\Microsoft\Windows\CurrentVersion\Internet Settings';
  SWBEMLOCATORCLASS = 'WbemScripting.SWbemLocator';
  WMISERVICENAMESPACE = 'root\CIMV2';
  WQLQUERY = 'SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True';
  REGINTERNETSETTINGS_PATH = 'Software\Microsoft\Windows\CurrentVersion\Internet Settings';

implementation

{ TNetManger }
constructor TNetManger.Create;
begin
  inherited;
  FCheckers := TDictionary<TItemType, TNetChecker>.Create;
  FResult := TDictionary<TItemType, Boolean>.Create;
  InitCheckers;
end;

destructor TNetManger.Destroy;
var
  Checker: TNetChecker;
begin
  for Checker in FCheckers.Values do
    Checker.Free;
  FCheckers.Free;
  FResult.Free;
  inherited;
end;

procedure TNetManger.InitCheckers;
var
  I: TItemType;
begin
  //初始化检测器
  FCheckers.Add(BasicConnet, TBasicConnectChecker.Create);
  FCheckers.Add(Config, TConfigChecker.Create);
  FCheckers.Add(LatencyAndLoss, TLatencyAndLossChecker.Create);

  //初始化检测结果
  for I := Low(TItemType) to High(TItemType) do
    FResult.Add(I, False);
end;

procedure TNetManger.Excute;
var
  Checker: TPair<TItemType, TNetChecker>;
begin
  for Checker in FCheckers do
  begin
    FResult.AddOrSetValue(Checker.Key, Checker.Value.Check);
  end;
end;

function TNetManger.Fix: Boolean;
var
  CheckerType: TItemType;
begin
  {
  for CheckerType in FResult.Keys do
  begin
    if not FResult[CheckerType] then
    begin
      FCheckers[CheckerType].Fix;
    end;
  end;
}
  Result := True;
  CheckerType := Config;
  if not TConfigChecker(FCheckers[CheckerType]).CheckDNS then
  begin
    Result := FCheckers[CheckerType].Fix;
  end;
end;

function TNetManger.GetResult(ItemType: TItemType): Boolean;
begin
  if ItemType = LatencyAndLoss then
    Result := (FCheckers[ItemType] as TLatencyAndLossChecker).Check // 动态检查
  else
    Result := FResult[ItemType]; // 其他检查仍用缓存
end;

{ TBasicConnetChecker }
function TBasicConnectChecker.Check: Boolean;
begin
  ResultSaaS := HttpRequest(SAASURL);
  ResultCloud := HttpRequest(CLOUDURL);
  ResultInternet := HttpRequest(BAIDUURL);
  Result := True;
end;

function TBasicConnectChecker.Fix: Boolean;
begin

end;

function TBasicConnectChecker.HttpRequest(TestUrl: string): Boolean;
var
  HTTPClient: THTTPClient;
  Response: IHTTPResponse;
begin
  HTTPClient := THTTPClient.Create;
  try
    Response := HTTPClient.Get(TestUrl);
    Result := (Response.StatusCode = 200);
  except
    Result := False;
  end;

  HTTPClient.Free;
end;

{ TConfigChecker }
function TConfigChecker.Check: Boolean;
begin
  ResultProxy := GetProxyStatus;
  ResultDNS := CheckDNS;
  Result := True;
end;

function TConfigChecker.CheckDNS: Boolean;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumVariant;
  iValue: LongWord;
  DNSServers: OLEVariant;
  DNSServerList: string;
  i: Integer;
  Found223, Found114: Boolean;
begin
  Result := False;
  Found223 := False;
  Found114 := False;

  try
    FSWbemLocator := CreateOleObject(SWBEMLOCATORCLASS);
    FWMIService := FSWbemLocator.ConnectServer('localhost', WMISERVICENAMESPACE, '', '');
    FWbemObjectSet := FWMIService.ExecQuery(WQLQUERY, 'WQL', 0);
    oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;

    while oEnum.Next(1, FWbemObject, iValue) = 0 do
    begin
      if not VarIsNull(FWbemObject.DNSServerSearchOrder) then
      begin
        DNSServers := FWbemObject.DNSServerSearchOrder;
        DNSServerList := '';

        // 处理DNS服务器数组
        if VarIsArray(DNSServers) then
        begin
          for i := VarArrayLowBound(DNSServers, 1) to VarArrayHighBound(DNSServers, 1) do
          begin
            if DNSServerList <> '' then
              DNSServerList := DNSServerList + ', ';
            DNSServerList := DNSServerList + DNSServers[i];

            // 检查是否包含所需的DNS服务器
            if DNSServers[i] = '223.5.5.5' then
              Found223 := True
            else if DNSServers[i] = '114.114.114.114' then
              Found114 := True;
          end;
        end;

        // 如果找到两个所需的DNS服务器，设置结果为True
        if Found223 or Found114 then
        begin
          Result := True;
          Break;
        end;
      end;
      FWbemObject := Unassigned;
    end;
  except
    Result := False;
  end;
end;

function TConfigChecker.Fix: Boolean;
begin
  FixDNS;
end;

function TConfigChecker.FixDNS: Boolean;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumVariant;
  iValue: LongWord;
  DNSServers: OLEVariant;
  arrDNSServers: array[0..1] of string;
  ReturnValue: Integer;
begin
  Result := False;

  try
    FSWbemLocator := CreateOleObject(SWBEMLOCATORCLASS);
    FWMIService := FSWbemLocator.ConnectServer('localhost', WMISERVICENAMESPACE, '', '');
    FWbemObjectSet := FWMIService.ExecQuery(WQLQUERY, 'WQL', 0);
    oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;

    // 设置要使用的DNS服务器
    arrDNSServers[0] := '223.5.5.5';
    arrDNSServers[1] := '114.114.114.114';
    DNSServers := VarArrayCreate([0, 1], varOleStr);
    DNSServers[0] := arrDNSServers[0];
    DNSServers[1] := arrDNSServers[1];

    while oEnum.Next(1, FWbemObject, iValue) = 0 do
    begin
      // 设置DNS服务器
      ReturnValue := FWbemObject.SetDNSServerSearchOrder(DNSServers);

      if ReturnValue = 0 then
      begin
        Result := True;
      end
      else if ReturnValue = 1 then
      begin
        Result := True;
      end
      else
      begin
        Result := False;
      end;

      FWbemObject := Unassigned;
    end;

  except
    on E: Exception do
      Result := False;
  end;
end;

function TConfigChecker.GetProxyStatus: Boolean;
var
  Reg: TRegistry;
  ProxyEnable: Integer;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REGINTERNETSETTINGSPATH, False) then
    begin
      if Reg.ValueExists('ProxyEnable') then
        ProxyEnable := Reg.ReadInteger('ProxyEnable')
      else
        ProxyEnable := 0;

      Result := (ProxyEnable = 1);
    end
    else
    begin
      Result := False;
    end;
  finally
    Reg.Free;
  end;
end;

{ TLatencyAndLossChecker }
constructor TLatencyAndLossChecker.Create;
var
  MethodType: TMethodType;
  ServerType: TServerType;
begin
  inherited Create;
  //初始化容器
  FMethods := TDictionary<TMethodType, TNetRequestFunc>.Create;
  FThreads := TList<TNetThread>.Create;
  FLatencyAndLossResult := TDictionary<TServerType, TDictionary<TMethodType, TMethodResult>>.Create;
  FCompleted := TDictionary<TServerType, Boolean>.Create;
  //初始化每种方法
  FMethods.Add(Winhttp, TestWithWinHttp);
  FMethods.Add(Serverxmlhttp, TestWithWinHttp);
  FMethods.Add(Xmlhttp, TestWithXMLHttp);
  FMethods.Add(HTTPClient, TestWithHttpClient);
  FMethods.Add(Socket, TestWithSocket);
  //初始化每种方法是否完成的状态
  for ServerType := Low(TServerType) to High(TServerType) do
    FCompleted.Add(ServerType, False);
end;

destructor TLatencyAndLossChecker.Destroy;
var
  ServerType: TServerType;
  MethodDict: TDictionary<TMethodType, TMethodResult>;
begin
  while FThreads.Count > 0 do
  begin
    FThreads.Last.Terminate;
    FThreads.Last.WaitFor;
    FThreads.Last.Free;
    FThreads.Delete(FThreads.Count - 1);
  end;
  FThreads.Free;

  for ServerType in FLatencyAndLossResult.keys do
  begin
    MethodDict := FLatencyAndLossResult[ServerType];
    if Assigned(MethodDict) then
      MethodDict.Free;
  end;
  FLatencyAndLossResult.Free;
  FMethods.Free;
  FCompleted.Free;
  inherited;
end;

procedure TLatencyAndLossChecker.StartThreadTest;
var
  ServerType: TServerType;
  MethodType: TMethodType;
  NetThread: TNetThread;
  OldDict: TDictionary<TMethodType, TMethodResult>;
  I: Integer;
begin
  //清理旧的线程
  for I := FThreads.Count - 1 downto 0 do
  begin
    FThreads[I].Terminate;
    FThreads[I].WaitFor;
    FreeAndNil(FThreads[I]);
  end;
  FThreads.Clear;

  //清理旧的字典
  for ServerType in FLatencyAndLossResult.Keys.ToArray do
  begin
    if FLatencyAndLossResult.TryGetValue(ServerType, OldDict) then   //oldDict实际上是引用
    begin
      OldDict.Free;   //释放内层字典
      FLatencyAndLossResult.Remove(ServerType);    //移除字典所有键值对（不释放字典本身）
    end;
  end;

  //添加测试2个地址，每个地址5个方法
  for ServerType := Low(TServerType) to High(TServerType) do
  begin
    for MethodType in FMethods.Keys do
    begin
      FThreads.Add(TNetThread.Create(ServerType, MethodType, FMethods[MethodType]));
    end;
  end;

  //启动所有线程
  for NetThread in FThreads do
    NetThread.Start;
end;

procedure TLatencyAndLossChecker.CollectThreadResults;
var
  NetThread: TNetThread;
  MethodType: TMethodType;
  SaaSMethodDict: TDictionary<TMethodType, TMethodResult>;
  CloudMethodDict: TDictionary<TMethodType, TMethodResult>;
begin
  SaaSMethodDict := TDictionary<TMethodType, TMethodResult>.Create;
  CloudMethodDict := TDictionary<TMethodType, TMethodResult>.Create;

  for NetThread in FThreads do
  begin
    case NetThread.FServerType of
      SaaS:
        SaaSMethodDict.AddOrSetValue(NetThread.TmpMethodResult.Key, NetThread.TmpMethodResult.Value);
      Cloud:
        CloudMethodDict.AddOrSetValue(NetThread.TmpMethodResult.Key, NetThread.TmpMethodResult.Value);
    end;
  end;

  FLatencyAndLossResult.AddOrSetValue(SaaS, SaaSMethodDict);
  FLatencyAndLossResult.AddOrSetValue(Cloud, CloudMethodDict);
end;

function TLatencyAndLossChecker.CalAvgLatencyAndLoss(ServerType: TServerType): TMethodResult;
var
  CurrentType: TServerType;
  CurrentMethodDict: TDictionary<TMethodType, TMethodResult>;   //获取当前服务器的所有方法结果
  MethodPair: TPair<TMethodType, TMethodResult>;                //方法-结果
  LatencySum, AvgLatency: Integer;
  LossSum, AvgLoss: Double;
  ValidCount: Integer;
begin
  LatencySum := 0;
  LossSum := 0.0;
  ValidCount := 0;

  if not FLatencyAndLossResult.TryGetValue(ServerType, CurrentMethodDict) then
    Exit;

  for MethodPair in CurrentMethodDict do
  begin
    LatencySum := LatencySum + MethodPair.Value.Latency;
    LossSum := LossSum + MethodPair.Value.PacketLoss;
    Inc(ValidCount);
  end;

  if ValidCount > 0 then
  begin
      //计算平均值
    AvgLatency := LatencySum div ValidCount;
    AvgLoss := LossSum / ValidCount;
  end
  else
  begin
    AvgLatency := -1;
    AvgLoss := 100;
  end;

  Result := TMethodResult.Create(AvgLatency, AvgLoss);

  //2种服务器的延迟和丢包率检测完成
  for ServerType := Low(TServerType) to High(TServerType) do
    FCompleted[ServerType] := True;
end;

function TLatencyAndLossChecker.Check: Boolean;
var
  NetThread: TNetThread;
begin
  Result := True;
  for NetThread in FThreads do
  begin
    if not NetThread.Finished then
    begin
      Result := False;
      Break;
    end;
  end;
end;

function TLatencyAndLossChecker.Fix: Boolean;
begin

end;

{ TNetThread }
constructor TNetThread.Create(ServerType: TServerType; MethodType: TMethodType; NetRequestFunc: TNetRequestFunc);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FServerType := ServerType;
  FMethodType := MethodType;
  FNetRequestFunc := NetRequestFunc;
  Finished := False;
end;

destructor TNetThread.destroy;
begin
  inherited;
end;

procedure TNetThread.Execute;
begin
  CoInitialize(nil);
  case FServerType of
    SaaS:
      TmpMethodResult := TPair<TMethodType, TMethodResult>.Create(FMethodType, FNetRequestFunc(SAASURL));
    Cloud:
      TmpMethodResult := TPair<TMethodType, TMethodResult>.Create(FMethodType, FNetRequestFunc(CLOUDURL));
  end;
  CoUninitialize;

  Finished := True;
end;

end.

