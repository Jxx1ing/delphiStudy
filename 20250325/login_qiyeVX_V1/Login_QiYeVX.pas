unit Login_QiYeVX;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  DelphiZXIngQRCode,
  System.JSON,
  IdFTPListTypes,IdSSLOpenSSl,SuperObject, nativexml;

type
  TForm1 = class(TForm)
    Button1: TButton;
    image1: TImage;
    Timer1: TTimer;
    lblStatus: TLabel;
    memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
    ReqURL : string;
    ReqData : string;
    Response: string;
    ReqID : string;
    AuthUrl : string;
    ResultUrl : string;
    FChecking: Boolean;
    procedure Request();
    procedure Check();
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  Winapi.MSXMLIntf, Winapi.MSXML;

//申请授权
procedure TForm1.Request();
var
  HTTPRequest: IXMLHTTPRequest;
  Xml : TNativeXml;
  Node: TXmlNode;
begin
  //创建XMLTHHP对象
  HTTPRequest := CoXMlHTTP60.Create;
  //设置请求的URL
  ReqURL := 'https://saas.fscut.com/wxauth/reqauth.aspx?App={0}&Version={1}&Action={2}&ReqData={3}&wework=1';
  //初始化GET请求
  HTTPRequest.open('GET',ReqURL,False,EmptyParam,EmptyParam);
  //发送请求
  HTTPRequest.send(EmptyParam);
  //检查响应状态
  if (HTTPRequest.status = 200) then
  begin
    ShowMessage('请求成功');
    Response := HTTPRequest.responseText;
  end
  else
  begin
    ShowMessage('请求失败');
  end;

  //接下来开始解析XML文件
  XML := TNativeXml.Create(nil);
  XML.ReadFromString(Response);
  Node := XML.Root;

  ReqID := Node[2].Value;
  AuthUrl := Node[3].Value;
  ResultUrl := Node[4].Value;
  //ShowMessage(ResultURL);
  ReqData := '{3}';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Check();
end;

// 生成二维码并返回 TBitmap
function GenerateQRCodeBitmap(const Data: WideString; Encoding: TQRCodeEncoding; QuietZone: Integer): TBitmap;
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := Data;
    QRCode.Encoding := Encoding;
    QRCode.QuietZone := QuietZone;

    Result := TBitmap.Create;
    Result.SetSize(QRCode.Rows, QRCode.Columns);

    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if QRCode.IsBlack[Row, Column] then
          Result.Canvas.Pixels[Column, Row] := clBlack
        else
          Result.Canvas.Pixels[Column, Row] := clWhite;
      end;
    end;
  finally
    QRCode.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FChecking := False;
  Timer1.Enabled := False;
  Timer1.Interval := 8000; // 每8秒检查一次授权结果
  Timer1.OnTimer := Timer1Timer; // 关联定时器事件
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TForm1.Check();
var
  HTTPRequest: IXMLHTTPRequest;
  CheckUrl: string;
  JsonObj: ISuperObject;
begin
  CheckUrl := Format('%s?ReqID=%s&ReqData=%s', [ResultUrl, ReqID, ReqData]);
    {
      Memo1.Lines.Clear;
      Memo1.Lines.Add(CheckUrl); // 完整显示 URL，支持滚动查看
      Memo1.Visible := True; // 确保 Memo 可见
    }

  HTTPRequest := CoXMlHTTP60.Create;
  try
    HTTPRequest.open('GET', CheckUrl, False, EmptyParam, EmptyParam);
    HTTPRequest.send(EmptyParam);

    if (HTTPRequest.status = 200) then
    begin
      JsonObj := SO(HTTPRequest.responseText);
      Memo1.Lines.Add(JsonObj.AsJson());

      if JsonObj.I['errcode'] = 0 then // 授权成功
      begin
        ShowMessage('授权成功! UserID: ' + JsonObj.S['UserId']);
        Timer1.Enabled := False; // 停止轮询
      end
      else // 授权失败或未完成
      begin
        // 保持定时器运行继续检查
        // 不需要显示信息，因为这只是轮询中的状态
      end;
    end
    else // HTTP请求失败
    begin
      Timer1.Enabled := False;
      ShowMessage('检查授权状态失败');
    end;
  except
    Timer1.Enabled := False;
    ShowMessage('检查授权状态时发生异常');
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // 请求授权
  Request();

  // 显示二维码
  Image1.Picture.Assign(GenerateQRCodeBitmap(AuthUrl, qrAuto, 2));

  // 初始化状态
  lblStatus.Caption := '请使用企业微信扫码授权';

  // 开始轮询检查
  Timer1.Enabled := True;
  // 不需要在这里直接调用Check()，定时器会第一次触发
end;






end.
