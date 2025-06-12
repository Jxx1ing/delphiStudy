unit HttpGet;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Classes,
  System.Net.HttpClient, ActiveX, ComObj, Variants, Registry, Winapi.Windows,
  StrUtils, SynCrtSock, System.Math, Vcl.StdCtrls, Vcl.Controls,
  System.Net.URLClient, msxml;

type
  TMethodResult = record
    Latency: integer;
    PacketLoss: Double;
    constructor Create(ALatency: integer; APacketLoss: double);
  end;

const
  MaxTestCount = 30;

function TestWithWinHttp(const Url: string): TMethodResult;

function TestWithServerXMLHTTP(const Url: string): TMethodResult;

function TestWithXMLHttp(const Url: string): TMethodResult;

function TestWithHttpClient(const Url: string): TMethodResult;

function TestWithSocket(const Url: string): TMethodResult;

implementation

{ TMethodResult }
constructor TMethodResult.Create(ALatency: integer; APacketLoss: double);
begin
  Latency := ALatency;
  PacketLoss := APacketLoss;
end;

function CreateHttpRequest: IXMLHttpRequest;   //XMLHttpRequest的辅助函数
begin
  try
    Result := CoXMLHTTP60.Create; // 6.0
  except
    try
      Result := CoXMLHTTP40.Create; // 4.0
    except
      try
        Result := CoXMLHTTP30.Create; // 3.0
      except
        try
          Result := CoXMLHTTP26.Create; // 2.6
        except
          try
            Result := CoXMLHTTP.Create; // 1.0
          except
            Result := nil;
          end;
        end;
      end;
    end;
  end;
end;

function TestWithWinHttp(const Url: string): TMethodResult;
var
  TotalTime: OleVariant;
  StartTime: Cardinal;
  SuccessCount: Integer;
  i: integer;
  WinHttp: OleVariant;
begin
  TotalTime := 0;
  SuccessCount := 0;

  for i := 0 to MaxTestCount - 1 do
  begin
    WinHttp := CreateOleObject('WinHttp.WinHttpRequest.5.1');
    try
      // 设置连接、发送、接收和解析超时各5秒
      WinHttp.SetTimeouts(5000, 5000, 5000, 5000);
      StartTime := GetTickCount;
      WinHttp.Open('Get', Url, False);
      WinHttp.Send;
      Inc(TotalTime, GetTickCount - StartTime);
      Inc(SuccessCount);
      WinHttp := Unassigned;
      Sleep(100);
    except
      Continue;
    end;
  end;

  if SuccessCount > 0 then
    Result := TMethodResult.Create(TotalTime div SuccessCount, 100 * (MaxTestCount - SuccessCount) / MaxTestCount)
  else
    Result := TMethodResult.Create(-1, 100);
end;

function TestWithServerXMLHTTP(const Url: string): TMethodResult;
var
  TotalTime: OleVariant;
  StartTime: Cardinal;
  SuccessCount: Integer;
  i: integer;
  ServerXMLHTTP: OleVariant;
begin
  TotalTime := 0;
  SuccessCount := 0;

  for i := 0 to MaxTestCount - 1 do
  begin
    ServerXMLHTTP := CreateOleObject('Msxml2.ServerXMLHTTP');
    try
      ServerXMLHTTP.SetTimeouts(5000, 5000, 5000, 5000);
      StartTime := GetTickCount;
      ServerXMLHTTP.Open('Get', Url, False);
      ServerXMLHTTP.Send;
      Inc(TotalTime, GetTickCount - StartTime);
      Inc(SuccessCount);
      ServerXMLHTTP := Unassigned;
      Sleep(100);
    except
      Continue;
    end;
  end;

  if SuccessCount > 0 then
    Result := TMethodResult.Create(TotalTime div SuccessCount, 100 * (MaxTestCount - SuccessCount) / MaxTestCount)
  else
    Result := TMethodResult.Create(-1, 100);
end;

function TestWithXMLHttp(const Url: string): TMethodResult;
var
  TotalTime: OleVariant;
  StartTime: Cardinal;
  SuccessCount: Integer;
  i: integer;
  XMLHTTP: OleVariant;
begin
  TotalTime := 0;
  SuccessCount := 0;

  for i := 0 to MaxTestCount - 1 do
  begin
    XMLHTTP := CreateHttpRequest;
    try
      StartTime := GetTickCount;
      XMLHTTP.Open('GET', Url + '?timestamp=' + IntToStr(GetTickCount64), False, EmptyParam, EmptyParam); //防止缓存
      XMLHTTP.send();
      Inc(TotalTime, GetTickCount - StartTime);
      Inc(SuccessCount);
      XMLHTTP := Unassigned;
      Sleep(100);
    except
      Continue;
    end;
  end;

  if SuccessCount > 0 then
    Result := TMethodResult.Create(TotalTime div SuccessCount, 100 * (MaxTestCount - SuccessCount) / MaxTestCount)
  else
    Result := TMethodResult.Create(-1, 100);
end;

function TestWithHttpClient(const Url: string): TMethodResult;
var
  TotalTime: OleVariant;
  StartTime: Cardinal;
  SuccessCount: Integer;
  i: integer;
  HTTPClient: THTTPClient;
begin
  TotalTime := 0;
  SuccessCount := 0;

  for i := 0 to MaxTestCount - 1 do
  begin
    HTTPClient := THTTPClient.Create;
    try
      try
        HTTPClient.ConnectionTimeout := 5000;  // 设置连接超时
        HTTPClient.ResponseTimeout := 5000;    // 设置响应超时
        StartTime := GetTickCount;
        HTTPClient.Get(Url);
        Inc(TotalTime, GetTickCount - StartTime);
        Inc(SuccessCount);
        Sleep(100);
      except
        Continue;
      end;
    finally
      HTTPClient.Free;
    end;
  end;

  if SuccessCount > 0 then
    Result := TMethodResult.Create(TotalTime div SuccessCount, 100 * (MaxTestCount - SuccessCount) / MaxTestCount)
  else
    Result := TMethodResult.Create(-1, 100);
end;

function TestWithSocket(const Url: string): TMethodResult;
var
  TotalTime: OleVariant;
  StartTime: Cardinal;
  SuccessCount: Integer;
  i: integer;
  SocketHttp: THTTPClientSocket;
  Host: string;
  Path: string;
  ParseUrl: TUri;
begin
  ParseUrl := TURI.Create(Url);
  Host := ParseUrl.Host;
  Path := ParseUrl.Path;
    // 检查必要字段
  if Host.IsEmpty then
    Exit(TMethodResult.Create(-1, 100)); // 标记为失败
  if Path.IsEmpty then
    Exit(TMethodResult.Create(-1, 100)); // 标记为失败

  TotalTime := 0;
  SuccessCount := 0;

  for i := 0 to MaxTestCount - 1 do
  begin
    //设置5s超时，如果不设置直接用open方法默认为10s超时
    SocketHttp := THttpClientSocket.Create(5000);
    SocketHttp.Open(UTF8Encode(Host), '443');
    try
      try
        StartTime := GetTickCount;
        SocketHttp.Get(UTF8Encode(Path));
        Inc(TotalTime, GetTickCount - StartTime);
        Inc(SuccessCount);
        Sleep(100);
      except
        Continue;
      end;
    finally
      SocketHttp.Free;
    end;
  end;

  if SuccessCount > 0 then
    Result := TMethodResult.Create(TotalTime div SuccessCount, 100 * (MaxTestCount - SuccessCount) / MaxTestCount)
  else
    Result := TMethodResult.Create(-1, 100);
end;

end.

