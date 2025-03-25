unit uHttpClient;

interface

uses
  Winapi.msxml, Winapi.ActiveX, Winapi.MSXMLIntf, Classes, System.SysUtils,
  System.Variants;

type
  IHttpClient = interface
    ['{BEDBB46D-9D9A-4F8E-884D-2C1D6A6D3F22}']
    function Get(const AUrl: string): string;
    function Post(const AUrl: string; const AData: string): string; overload;
    function Post(const AUrl: string; const AData: string; Files: TStringList):
      string; overload;
    function DownloadFile(const AUrl, AFilePath: string): Boolean;
    procedure SetSessionCode(const AValue: string);
    procedure SetProxy(const AProxyServer: string);  // 新增代理设置方法
  end;

  EHttpClientError = class(Exception);

implementation

uses
  System.Threading, fsapplc, IPC.Intf;

type
  THttpClient = class(TInterfacedObject, IHttpClient)
  private
    FSessionCode: string;
    FProxyServer: string;  // 新增代理服务器字段
    procedure ConfigureHeaders(XMLHttp: IServerXMLHTTPRequest2);
    function SendRequest(XMLHttp: IServerXMLHTTPRequest2): string;
    procedure ApplyProxySettings(XMLHttp: IServerXMLHTTPRequest2);  // 新增代理设置方法
  public
    function Get(const AUrl: string): string;
    function Post(const AUrl: string; const AData: string): string; overload;
    function Post(const AUrl: string; const AData: string; Files: TStringList):
      string; overload;
    function DownloadFile(const AUrl, AFilePath: string): Boolean;
    procedure SetSessionCode(const AValue: string);
    procedure SetProxy(const AProxyServer: string);  // 实现代理设置方法
  public
    constructor Create;
    destructor Destroy; override;
  end;

const
  DEFAULT_TIMEOUT = 30000; // 30 seconds
  CRLF = #13#10;

{ THttpClient }

constructor THttpClient.Create;
begin
  inherited;
  CoInitialize(nil);
end;

destructor THttpClient.Destroy;
begin
  CoUninitialize;
  inherited;
end;

function THttpClient.DownloadFile(const AUrl, AFilePath: string): Boolean;
var
  XMLHttp: IServerXMLHTTPRequest2;
  ResponseStream: TFileStream;
  VarArray: OleVariant;
  PData: Pointer;
  Len: Integer;
begin
  Result := True;
  CoInitialize(nil);
  try
    XMLHttp := CoServerXMLHTTP60.Create;
    try
      XMLHttp.open('GET', AUrl, False, EmptyParam, EmptyParam);
      ApplyProxySettings(XMLHttp);
      ConfigureHeaders(XMLHttp);
      XMLHttp.send(EmptyParam);

      if XMLHttp.status <> 200 then
        raise EHttpClientError.CreateFmt('HTTP Error %d: %s', [XMLHttp.status,
          XMLHttp.statusText]);

      // 创建文件流并保存响应内容
      ResponseStream := TFileStream.Create(AFilePath, fmCreate);
      try
        VarArray := XMLHttp.responseBody;
        if not VarIsArray(VarArray) or (VarType(VarArray) and varTypeMask <> varByte) then
          raise EHttpClientError.Create('Invalid response body format');

        Len := VarArrayHighBound(VarArray, 1) - VarArrayLowBound(VarArray, 1) + 1;
        if Len > 0 then
        begin
          PData := VarArrayLock(VarArray);
          try
            ResponseStream.WriteBuffer(PData^, Len);
          finally
            VarArrayUnlock(VarArray);
          end;
        end;
      finally
        ResponseStream.Free;
      end;
    except
      on E: Exception do
      begin
        raise EHttpClientError.Create('Download failed: ' + E.Message);
      end;
    end;
  finally
    CoUninitialize;
  end;
end;

procedure THttpClient.ConfigureHeaders(XMLHttp: IServerXMLHTTPRequest2);
begin
  if FSessionCode <> '' then
    XMLHttp.setRequestHeader('SessionCode', FSessionCode);
  XMLHttp.setRequestHeader('Accept', 'application/json');
end;

procedure THttpClient.ApplyProxySettings(XMLHttp: IServerXMLHTTPRequest2);
begin
  if FProxyServer <> '' then
    XMLHttp.setProxy(2 {SXH_PROXY_SET_PROXY}, FProxyServer, '');
end;

function THttpClient.SendRequest(XMLHttp: IServerXMLHTTPRequest2): string;
begin
  try
    XMLHttp.send(EmptyParam);
    if XMLHttp.status <> 200 then
      raise EHttpClientError.CreateFmt('HTTP Error %d: %s', [XMLHttp.status,
        XMLHttp.statusText]);

    Result := XMLHttp.responseText;
  except
    on E: Exception do
      raise EHttpClientError.Create('HTTP request failed: ' + E.Message);
  end;
end;

function THttpClient.Get(const AUrl: string): string;
var
  XMLHttp: IServerXMLHTTPRequest2;
begin
  CoInitialize(nil);
  try
    XMLHttp := CoServerXMLHTTP60.Create;
    try
      XMLHttp.open('GET', AUrl, False, EmptyParam, EmptyParam);
      ApplyProxySettings(XMLHttp);  // 应用代理设置
      ConfigureHeaders(XMLHttp);
      Result := SendRequest(XMLHttp);
    except
      // GET 请求不对外抛异常
    end;
  finally
    CoUninitialize;
  end;
end;

function THttpClient.Post(const AUrl, AData: string): string;
var
  XMLHttp: IServerXMLHTTPRequest2;
begin
  CoInitialize(nil);
  try
    XMLHttp := CoServerXMLHTTP60.Create;
    try
      XMLHttp.open('POST', AUrl, False, EmptyParam, EmptyParam);
      ApplyProxySettings(XMLHttp);  // 应用代理设置
      ConfigureHeaders(XMLHttp);
      XMLHttp.setRequestHeader('Content-Type', 'application/json; charset=utf-8');
      XMLHttp.send(AData);
      Result := XMLHttp.responseText;
    except
      on E: Exception do
        raise EHttpClientError.Create('POST request failed: ' + E.Message);
    end;
  finally
    CoUninitialize;
  end;
end;

function THttpClient.Post(const AUrl: string; const AData: string; Files:
  TStringList): string;
var
  XMLHttp: IServerXMLHTTPRequest2;
  PostData: TStringStream;
  Boundary: string;
  I: Integer;
  FileName, FilePath: string;
  FileStream: TFileStream;
begin
  CoInitialize(nil);
  try
    XMLHttp := CoServerXMLHTTP60.Create;
    PostData := TStringStream.Create('', TEncoding.UTF8);
    try
      Boundary := '----------' + IntToHex(Random(MaxInt), 8);

      // 添加JSON数据部分
      PostData.WriteString('--' + Boundary + CRLF);
      PostData.WriteString('Content-Disposition: form-data; name="data"' + CRLF);
      PostData.WriteString('Content-Type: application/json; charset=utf-8' + CRLF + CRLF);
      PostData.WriteString(AData + CRLF);

      // 添加文件部分
      for I := 0 to Files.Count - 1 do
      begin
        FilePath := Files[I];
        FileName := ExtractFileName(FilePath);

        if not FileExists(FilePath) then
          raise EHttpClientError.CreateFmt('File not found: %s', [FilePath]);

        PostData.WriteString('--' + Boundary + CRLF);
        PostData.WriteString(Format('Content-Disposition: form-data; name="files"; filename="%s"%s',
          [FileName, ExtractFileName(FilePath), CRLF]));
        PostData.WriteString('Content-Type: application/octet-stream' + CRLF + CRLF);

        FileStream := TFileStream.Create(FilePath, fmOpenRead);
        try
          PostData.CopyFrom(FileStream, 0);
        finally
          FileStream.Free;
        end;
        PostData.WriteString(CRLF);
      end;

      PostData.WriteString('--' + Boundary + '--' + CRLF + CRLF);

      XMLHttp.open('POST', AUrl, False, EmptyParam, EmptyParam);
      ApplyProxySettings(XMLHttp);  // 应用代理设置
      ConfigureHeaders(XMLHttp);
      XMLHttp.setRequestHeader('Content-Type', 'multipart/form-data; boundary='
        + Boundary);
      XMLHttp.send(PostData.DataString);

      Result := XMLHttp.responseText;
      ;
    finally
      PostData.Free;
    end;
  finally
    CoUninitialize;
  end;
end;

procedure THttpClient.SetProxy(const AProxyServer: string);
begin
  FProxyServer := AProxyServer;
end;

procedure THttpClient.SetSessionCode(const AValue: string);
begin
  FSessionCode := AValue;
end;

initialization
  AppSys.RegisterService(IHttpClient, THttpClient.Create);

end.

