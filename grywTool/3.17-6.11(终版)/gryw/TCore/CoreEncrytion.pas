unit CoreEncrytion;

interface

uses
  System.Win.ComObj, Winapi.ActiveX, MSXML, Variants, Dialogs, System.JSON,
  System.Hash, System.IOUtils, System.SysUtils, System.Classes;

const
  TEST_URL = 'https://cloudnest.fscut.com/api/server_version';
  DefaultResponse = '{"status":0,"msg":"OK","data":{"version":"3.43.0","ver_date":"20230321","server_env":"prod"}}';
  TestString = 'This is a test string for encryption detection';

type
  TItemType = (EncryNet, EncryFile);

type
  TEncryptionChecker = class
  public
    function CheckNet: Boolean;
    function CheckFile: Boolean;
  end;

implementation

{ TEncryptionChecker }
function TEncryptionChecker.CheckNet: Boolean;
var
  NetRequest: IXMLHTTPRequest;
  NetEncryptionResponse: string;
  ResponseJSON, DefaultJSON: TJSONObject;
begin
  ResponseJSON := nil;
  DefaultJSON := nil;

  try
    CoInitialize(nil);
    NetRequest := CreateComObject(class_XMLHTTP) as IXMLHTTPRequest;
    NetRequest.open('GET', TEST_URL, False, EmptyParam, EmptyParam);
    NetRequest.send(EmptyParam);

    if NetRequest.status = 200 then
    begin
      NetEncryptionResponse := NetRequest.responseText;
      try
        ResponseJSON := TJSONObject.ParseJSONValue(NetEncryptionResponse) as TJSONObject;
        DefaultJSON := TJSONObject.ParseJSONValue(DefaultResponse) as TJSONObject;
        Result := SameText(ResponseJSON.ToString, DefaultJSON.ToString);
      except
        Result := False;
      end;
    end
    else
    begin
      Result := False;
    end;
  except
    Result := False;
  end;

  if Assigned(ResponseJSON) then
    ResponseJSON.Free;
  if Assigned(DefaultJSON) then
    DefaultJSON.Free;

  CoUninitialize;
end;

function TEncryptionChecker.CheckFile: Boolean;
var
  STempFile: string;
  SFileContent: string;
  SOriginalHash, SFileHash: string;
begin
  try
    SOriginalHash := THashSHA2.GetHashString(TestString, THashSHA2.TSHA2Version.SHA256);
    STempFile := ExtractFilePath(ParamStr(0)) + 'test_123.txt';
    TFile.WriteAllText(STempFile, TestString, TEncoding.UTF8);
    SFileContent := TFile.ReadAllText(STempFile, TEncoding.UTF8);
    SFileHash := THashSHA2.GetHashString(SFileContent, THashSHA2.TSHA2Version.SHA256);
    Result := SameText(SOriginalHash, SFileHash);

    DeleteFile(STempFile);
  except
    Result := False;
  end;
end;

end.

