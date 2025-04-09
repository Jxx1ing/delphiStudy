unit UserInfo;

interface
uses
  Winapi.Windows, Winapi.Messages, MSXML, Variants, SuperObject, Nativexml, Dialogs, SysUtils;

{������ת��ΪӲ�����ַ���}
const
  STR_REQUEST_URL = 'https://saas.fscut.com/wxauth/reqauth.aspx?App={0}&Version={1}&Action={2}&ReqData={3}&wework=1';
  STR_GET_FALED = '����ʧ��';
  STR_AUTH_SUCCESS = '��Ȩ�ɹ�!';
  STR_AUTH_WAIT = '�ȴ���Ȩ';

{����һ���洢User��Ϣ����}
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
  {��ȡUser�ֶ�}
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
  {����һ��IXMLHTTPRequest����}
  HTTPReq := CoXMLHTTP60.Create;
  {���������URL}
   FReqUrl := STR_REQUEST_URL;
   {��ʼ��Get����}
   HTTPReq.open('GET', FReqUrl, False, EmptyParam, EmptyParam);
   {��������}
   HTTPReq.send(EmptyParam);
   {�����Ӧ״̬}
   if HTTPReq.status = 200 then
   begin
      UrlReq := HTTPReq.responseText;
   end
   else
   begin
     ShowMessage(STR_GET_FALED);
   end;

   {����������XML��Ӧ}
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
{����һ--ʹ��ʱ��������get����Ļ������⡣ ������--������ʹ����ջ��棨3�д��룩}
  CheckUrl := Format('%s?ReqID=%s&ReqData=%s&timestamp=%d',[FResultUrl, FReqID, FReqData, GetTickCount64]);
  HTTPReq := CoXMLHTTP60.Create;
  HTTPReq.open('GET', CheckUrl, False, EmptyParam, EmptyParam);
  HTTPReq.send(EmptyParam);
  if HTTPReq.status = 200 then
  begin
      Result := False;
      try
        JsonObj := SO(HTTPReq.responseText);

        {����JSON}
        if JsonObj.I['errcode'] = 0 then
        begin
          FReqSpone := JsonObj.S['UserId'];  // ��ʱ�����������
          //ShowMessage(STR_AUTH_SUCCESS + Jsonobj.S['UserId']);
          {��Ȩ�ɹ�����true Ŀ������Ȩ�ɹ����ֹһֱ��ѯ}
          Result := True;
        end
{ <summary>  TODO: ��ô���ȽϺã��ȴ���Ȩ����һֱ�����������ɾ��
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
