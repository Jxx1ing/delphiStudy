unit CoreEnvConfig;

interface

uses
  Generics.Collections, SysUtils, Registry, Classes, Windows, ShellAPI,
  ChooseLanguage, Vcl.Dialogs;

const
  SROOT = 'HKLM:\';
  SJSPATH = 'SOFTWARE\WOW6432Node\Classes\CLSID\{0E59F1D5-1FBE-11D0-8FF2-00A0D10038BC}';
  SJSVALUE = '{0E59F1D5-1FBE-11D0-8FF2-00A0D10038BC}';
  SACPPATH = 'SYSTEM\CurrentControlSet\Control\Nls\CodePage';
  FRIENDESS = '\Friendess\';
  DNCYP = '\dnCyp\';
  REGFRIENDESS = 'SOFTWARE\Friendess';
  REGEXCELCURRENTUSER = 'SOFTWARE\Classes\WOW6432Node\CLSID\{00024500-0000-0000-C000-000000000046}';
  REGEXCELLOCALMACHINE1 = 'SOFTWARE\WOW6432Node\Classes\CLSID\{00024500-0000-0000-C000-000000000046}';
  REGEXCELLOCALMACHINE2 = 'SOFTWARE\Classes\CLSID\{00024500-0000-0000-C000-000000000046}';
  REGEXCELLOCALMACHINE3 = 'SOFTWARE\Classes\WOW6432Node\CLSID\{00024500-0000-0000-C000-000000000046}';
  REGEXCELCLASSESROOT1 = 'Wow6432Node\CLSID\{00024500-0000-0000-C000-000000000046}';
  REGEXCELCLASSESROOT2 = 'CLSID\{00024500-0000-0000-C000-000000000046}';

type
  TItemType = (EnvExcel, EnvJS, EnvACP, EnvShortDate, EnvSystemFiles, EnvCache, EnvOther);

  TCacheType = (CacheLocal, CacheCloud, CacheReg);

type
  TEnvChecker = class abstract
  public
    function Check(): Boolean; virtual; abstract;
    function Fix(): Boolean; virtual; abstract;
  end;

type
  TEnvManger = class
  private
    FCheckers: TDictionary<TItemType, TEnvChecker>;   //检测类型-检测器
    procedure InitCheckers;
  public
    constructor Create;
    destructor Destroy; override;
    property Checkers: TDictionary<TItemType, TEnvChecker> read FCheckers;
  end;

type
  TExcelChecker = class(TEnvChecker)
  private
  public
    function Check(): Boolean; override;
    function Fix(): Boolean; override;
  end;

  TJSChecker = class(TEnvChecker)
  private
    function CreateJSAPPID: Boolean;
  public
    function Check(): Boolean; override;
    function Fix(): Boolean; override;
  end;

  TACPChecker = class(TEnvChecker)
  private
    FACPDic: TDictionary<Integer, string>;
    FCurrentACP: Integer;
    function ModifyACP(): Boolean;
  public
    function Check(): Boolean; override;
    function Fix(): Boolean; override;
    property CurrentACP: Integer read FCurrentACP;
    property ACPDic: TDictionary<Integer, string> read FACPDic;
    constructor Create;
    destructor Destroy; override;
  end;

  TShortDateChecker = class(TEnvChecker)
  private
  public
    function Check(): Boolean; override;
    function Fix(): Boolean; override;
  end;

  TSystemFilesChecker = class(TEnvChecker)
  private
  public
    function Check(): Boolean; override;
    function Fix(): Boolean; override;
  end;

  TCacheChecker = class(TEnvChecker)
  private
    function CheckReg(const Root: HKEY; const KeyPath: string): Boolean;
    function ResetLocalCache: Boolean;
    function ResetCloudCache: Boolean;
    function ResetRegFriendess: Boolean;
  public
    LocalExists, CloudExists, RegExists: Boolean;
    LocalPath, CloudPath: string;
    LocalCompleted, CloudCompleted, RegCompleted: Boolean;
    LocalStatus, CloudStatus, RegStatus: Boolean;
    function Check(): Boolean; override;
    function Fix(): Boolean; override;
  end;

function DeleteDir(const DirPath: string): Boolean;   //删除文件

function DeleteReg(const Root: HKEY; const KeyPath: string): Boolean;   //删除注册表

function ExtractScript(const ScriptFile: string; const Parameters: string): Boolean;   //运行脚本（比如可以用来提权）

implementation

function DeleteDir(const DirPath: string): Boolean;
var
  SearchRec: TSearchRec;
  TempPath: string;
begin
  if not DirectoryExists(DirPath) then
    Exit(true);

  if FindFirst(IncludeTrailingPathDelimiter(DirPath) + '*.*', faAnyFile, SearchRec) = 0 then
  begin
    try
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          TempPath := IncludeTrailingPathDelimiter(DirPath) + SearchRec.Name;

          if (SearchRec.Attr and faDirectory) = faDirectory then
          begin
            if not DeleteDir(TempPath) then
              Exit(false);
          end
          else
          begin
            if not DeleteFile(PChar(TempPath)) then
              Exit(false);
          end;
        end;
      until FindNext(SearchRec) <> 0;
    finally
      System.SysUtils.FindClose(SearchRec); //delphi中有两个重名的FindClose(所在单元分别是System.SysUtils以及Windows/Winapi.Windows)
    end;
  end;

  Result := RemoveDir(DirPath); //删除空目录
end;

function DeleteReg(const Root: HKEY; const KeyPath: string): Boolean;
var
  Reg: TRegistry;
  SubKeys: TStringList;
  I: Integer;
begin
  Result := False;
  Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    Reg.RootKey := Root;
    if not Reg.KeyExists(KeyPath) then
      Exit(True);
    if Reg.OpenKey(KeyPath, False) then
    begin
      SubKeys := TStringList.Create;
      try
        Reg.GetKeyNames(SubKeys);
        for I := 0 to SubKeys.Count - 1 do
        begin
          if not DeleteReg(Root, KeyPath + '\' + SubKeys[I]) then
            Exit(false);
        end;
      finally
        SubKeys.Free;
      end;
      Reg.CloseKey;

      if Reg.DeleteKey(KeyPath) then
        Result := True;   //删除当前键
    end;
  finally
    Reg.Free;
  end;
end;

function ExtractScript(const ScriptFile: string; const Parameters: string): Boolean;
var
  ShellExecuteInfo: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  Result := False;
  if not FileExists(ScriptFile) then
    Exit;
  FillChar(ShellExecuteInfo, SizeOf(ShellExecuteInfo), 0);
  ShellExecuteInfo.cbSize := SizeOf(ShellExecuteInfo);
  ShellExecuteInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
  ShellExecuteInfo.lpVerb := 'runas';
  ShellExecuteInfo.lpFile := 'powershell.exe';
  ShellExecuteInfo.lpParameters := PChar('-ExecutionPolicy Bypass -File "' + ScriptFile + '" ' + Parameters);
  ShellExecuteInfo.nShow := SW_HIDE;
  if ShellExecuteEx(@ShellExecuteInfo) then
  begin
    WaitForSingleObject(ShellExecuteInfo.hProcess, INFINITE);
    if GetExitCodeProcess(ShellExecuteInfo.hProcess, ExitCode) then
      Result := (ExitCode = 0);
    CloseHandle(ShellExecuteInfo.hProcess);
  end;
end;

{ TEnvManger }
constructor TEnvManger.Create;
begin
  inherited;
  FCheckers := TDictionary<TItemType, TEnvChecker>.Create;
  InitCheckers;
end;

destructor TEnvManger.Destroy;
var
  Checker: TEnvChecker;
begin
  for Checker in FCheckers.Values do
    Checker.Free;
  FCheckers.Free;
  inherited;
end;

procedure TEnvManger.InitCheckers;
begin
  FCheckers.Add(EnvExcel, TExcelChecker.Create);
  FCheckers.Add(EnvJS, TJSChecker.Create);
  FCheckers.Add(EnvACP, TACPChecker.Create);
  FCheckers.Add(EnvShortDate, TShortDateChecker.Create);
  FCheckers.Add(EnvSystemFiles, TSystemFilesChecker.Create);
  FCheckers.Add(EnvCache, TCacheChecker.Create);
end;

{ TExcelChecker }
function TExcelChecker.Check: Boolean;
var
  Reg: TRegistry;
  KeyExists: array[0..5] of Boolean; // 存储6个注册表项的检测结果
begin
  Reg := TRegistry.Create;
  try
    // 依次检测6个注册表路径
    Reg.RootKey := HKEY_CURRENT_USER;
    KeyExists[0] := Reg.KeyExists(REGEXCELCURRENTUSER);

    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyExists[1] := Reg.KeyExists(REGEXCELLOCALMACHINE1);
    KeyExists[2] := Reg.KeyExists(REGEXCELLOCALMACHINE2);
    KeyExists[3] := Reg.KeyExists(REGEXCELLOCALMACHINE3);

    Reg.RootKey := HKEY_CLASSES_ROOT;
    KeyExists[4] := Reg.KeyExists(REGEXCELCLASSESROOT1);
    KeyExists[5] := Reg.KeyExists(REGEXCELCLASSESROOT2);

    // 判断逻辑
    Result := (KeyExists[0] and KeyExists[1]) or (KeyExists[2] or KeyExists[3] or KeyExists[4] or KeyExists[5]);
  finally
    Reg.Free;
  end;
end;

function TExcelChecker.Fix: Boolean;
begin
  Result := True;
end;

{ TJSChecker }
function TJSChecker.Check: Boolean;
var
  Reg: TRegistry;
  APPIDValue: string;
begin
  Result := False;
  Reg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.KeyExists(SJSPATH) then
      Exit(False);
    if Reg.OpenKey(SJSPATH, False) then
    begin
      if Reg.ValueExists('AppID') then
      begin
        APPIDValue := Reg.ReadString('APPID');
        Result := SameText(APPIDValue, SJSVALUE);
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function TJSChecker.CreateJSAPPID: Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create(KEY_WRITE or KEY_WOW64_64KEY);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(SJSPath, False) then
    begin
      Reg.WriteString('AppID', SJSVALUE);
      Reg.CloseKey;
      Result := True;
    end;
  finally
    Reg.Free;
  end;
end;

function TJSChecker.Fix: Boolean;
begin
  if Check then
    Exit(true);

  if CreateJSAPPID then
  begin
    if Check then
    begin
      Result := Check;
      Exit;
    end;
  end;

  if ExtractScript(ExtractFilePath(ParamStr(0)) + 'EscalationPower.ps1', '-RegPath "' + SROOT + SJSPath + '"') then
  begin
    if CreateJSAPPID then
    begin
      Result := Check;
      Exit;
    end;
  end;

  //若所有尝试都失败
  Result := False;
end;

{ TACPChecker }
function TACPChecker.Check: Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SYSTEM\CurrentControlSet\Control\Nls\CodePage', False) then
    begin
      FCurrentACP := StrToInt(Reg.ReadString('ACP'));
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  Result := True;
end;

function TACPChecker.ModifyACP: Boolean;
var
  Reg: TRegistry;
  ExpectedACP: string;
begin
  if not Assigned(FormLanguage) or (FormLanguage.cbbLanguage.ItemIndex < 0) then
    Exit(false);
  ExpectedACP := FormLanguage.lblACPValue.Caption;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SYSTEM\CurrentControlSet\Control\Nls\CodePage', False) then
    begin
      Reg.WriteString('ACP', ExpectedACP);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  Result := True;
end;

constructor TACPChecker.Create;
begin
  inherited;
  FACPDic := TDictionary<Integer, string>.Create;
  FACPDic.Add(932, '日语');
  FACPDic.Add(936, '简体中文');
  FACPDic.Add(949, '韩语');
  FACPDic.Add(950, '繁体中文');
  FACPDic.Add(1250, '中欧语言');
  FACPDic.Add(1251, '俄语');
  FACPDic.Add(1252, '西欧语言');
  FACPDic.Add(1254, '土耳其语');
  FACPDic.Add(1258, '越南语');
end;

destructor TACPChecker.Destroy;
begin
  FACPDic.Free;
  inherited;
end;

function TACPChecker.Fix: Boolean;
begin
  if ModifyACP then
  begin
    Exit(True);
  end;

  if ExtractScript(ExtractFilePath(ParamStr(0)) + 'EscalationPower.ps1', '-RegPath "' + SROOT + SACPPATH + '"') then
  begin
    if ModifyACP then
    begin
      Exit(True);
    end;
  end;

  Result := False;
end;

{ TShortDateChecker }
function TShortDateChecker.Check: Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly('Control Panel\International') then
    begin
      Result := (Reg.ReadString('sShortDate') = 'yyyy/MM/dd') and (Reg.ReadString('DateSeparator') = '/');
      Reg.CloseKey;
    end
    else
      Result := False;
  finally
    Reg.Free;
  end;
end;

function TShortDateChecker.Fix: Boolean;
var
  Locale: LCID;
begin
  Result := False;
  Locale := GetUserDefaultLCID;
  if SetLocaleInfo(Locale, LOCALE_SSHORTDATE, 'yyyy/MM/dd') and SetLocaleInfo(Locale, LOCALE_SDATE, '/') then
    Result := True;
end;

{ TSystemFilesChecker }
function TSystemFilesChecker.Check: Boolean;
begin
  TThread.CreateAnonymousThread(
    procedure
    var
      ScriptPath: string;
    begin
      ScriptPath := ExtractFilePath(ParamStr(0)) + 'RunSFC.ps1';
      ExtractScript(ScriptPath, '');
    end).Start;
  Result := True;
end;

function TSystemFilesChecker.Fix: Boolean;
begin
  Result := True;
end;

{ TCacheChecker }
function TCacheChecker.CheckReg(const Root: HKEY; const KeyPath: string): Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    Reg.RootKey := Root;
    Result := Reg.KeyExists(KeyPath);
  finally
    Reg.Free;
  end;
end;

function TCacheChecker.Check: Boolean;
begin
  LocalExists := DirectoryExists(GetEnvironmentVariable('APPDATA') + FRIENDESS);
  CloudExists := DirectoryExists(GetEnvironmentVariable('APPDATA') + DNCYP);
  RegExists := CheckReg(HKEY_CURRENT_USER, REGFRIENDESS);
  Result := True;
end;

function TCacheChecker.Fix: Boolean;
begin
  ResetLocalCache;
  ResetCloudCache;
  ResetRegFriendess;
  Result := True;
end;

function TCacheChecker.ResetLocalCache: Boolean;
begin
  LocalPath := GetEnvironmentVariable('APPDATA') + FRIENDESS;
  LocalStatus := DeleteDir(LocalPath);
  Result := LocalStatus;
end;

function TCacheChecker.ResetCloudCache: Boolean;
begin
  CloudPath := GetEnvironmentVariable('APPDATA') + DNCYP;
  CloudStatus := DeleteDir(CloudPath);
  Result := CloudStatus;
end;

function TCacheChecker.ResetRegFriendess: Boolean;
begin
  RegStatus := DeleteReg(HKEY_CURRENT_USER, REGFRIENDESS);
  Result := RegStatus;
end;

end.

