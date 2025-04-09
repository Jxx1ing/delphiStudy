unit UserInfo;

interface
uses
  Winapi.Windows, Winapi.Messages, MSXML, Variants, SuperObject, Nativexml, Dialogs, SysUtils;

{将中文转换为硬编码字符串}
const
  STR_REQUEST_URL = 'https://saas.fscut.com/wxauth/reqauth.aspx?App={0}&Version={1}&Action={2}&ReqData={3}&wework=1';
  STR_GET_FALED = '请求失败';
  STR_AUTH_SUCCESS = '授权成功!';
  STR_AUTH_WAIT = '等待授权';

{定义一个存储User信息的类}
type
  TUser = class
  private
    FReqUrl, FReqData, FReqSpone: string;
    FReqId, FAuthUrl, FResultUrl: string;
  public
  constructor Create(AReqUrl, AReqData, AReqSpone, AReqID, AAuthUrl, AResultUrl: string);
  destructor Destroy;override;
  procedure GetURL();
  function CheckAuth(): Boolean;
  {提取User字段}
  property ReqUrl: string read FReqUrl write FReqUrl;
  property ReqData: string read FReqData write FReqData;
  property ReqSpone: string read FReqSpone write FReqSpone;
  property ReqId: string read FReqId write FReqId;
  property AuthUrl: string read FAuthUrl write FAuthUrl;
  property ResultUrl: string read FResultUrl write FResultUrl;
  end;

implementation

{ TUser }

constructor TUser.Create(AReqUrl, AReqData, AReqSpone, AReqId, AAuthUrl, AResultUrl: string);
begin
  FReqUrl := AReqUrl;
  FReqData := AReqData;
  FReqSpone := AReqSpone;
  FReqId := AReqId;
  FAuthUrl := AAuthUrl;
  FResultUrl := AResultUrl;
end;


destructor TUser.Destroy;
begin
  inherited;
end;


procedure TUser.GetURL();
var
  HTTPReq : IXMLHTTPRequest;
  UrlXml : TNativeXml;
  UrlNode : TXmlNode;
  UrlReq : string;
begin
  {创建一个IXMLHTTPRequest对象}
  HTTPReq := CoXMLHTTP60.Create;
  {设置请求的URL}
   FReqUrl := STR_REQUEST_URL;
   {初始化Get请求}
   HTTPReq.open('GET', FReqUrl, False, EmptyParam, EmptyParam);
   {发送请求}
   HTTPReq.send(EmptyParam);
   {检查响应状态}
   if HTTPReq.status = 200 then
   begin
      UrlReq := HTTPReq.responseText;
   end
   else
   begin
     ShowMessage(STR_GET_FALED);
   end;

   {接下来解析XML响应}
   UrlXml := TNativeXml.Create(nil);
   try
     UrlXml.ReadFromString(UrlReq);
     UrlNode := UrlXml.Root;

     if Assigned(UrlNode.NodeByName('ReqID')) then
        FReqId := UrlNode.NodeByName('ReqID').Value;
     if Assigned(UrlNode.NodeByName('AuthUrl')) then
        FAuthUrl := UrlNode.NodeByName('AuthUrl').Value;
     if Assigned(UrlNode.NodeByName('ResultUrl')) then
        FResultUrl := UrlNode.NodeByName('ResultUrl').Value;
     FReqData := '{3}';
   finally
     FreeAndNil(UrlXml);
   end;

   HTTPReq := nil;
end;

function TUser.CheckAuth(): Boolean;
var
  HTTPReq : IXMLHTTPRequest;
  JsonObj: ISuperObject;
  CheckUrl : string;
begin
{方法一--使用时间戳，解决get请求的缓存问题。 方法二--还可以使用清空缓存（3行代码）}
  CheckUrl := Format('%s?ReqID=%s&ReqData=%s&timestamp=%d',[FResultUrl, FReqID, FReqData, GetTickCount64]);
  HTTPReq := CoXMLHTTP60.Create;
  HTTPReq.open('GET', CheckUrl, False, EmptyParam, EmptyParam);
  HTTPReq.send(EmptyParam);
  if HTTPReq.status = 200 then
  begin
      Result := False;
      try
        JsonObj := SO(HTTPReq.responseText);

        {处理JSON}
        if JsonObj.I['errcode'] = 0 then
        begin
          FReqSpone := JsonObj.S['UserId'];  // 暂时放这里，存下来
          //ShowMessage(STR_AUTH_SUCCESS + Jsonobj.S['UserId']);
          {授权成功返回true 目的是授权成功后防止一直轮询}
          Result := True;
        end
{ <summary>  TODO: 怎么做比较好？等待授权窗体一直出现这里把它删了
        else
        begin
          ShowMessage(STR_AUTH_WAIT);
        end;
 <summary>
}
      finally
        JsonObj := nil;
      end;
  end;

  HTTPReq := nil;
end;

end.
