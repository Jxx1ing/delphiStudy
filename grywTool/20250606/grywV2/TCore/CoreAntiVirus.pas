unit CoreAntiVirus;

interface

uses
  System.Generics.Collections, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, WinSvc, Vcl.StdCtrls, TlHelp32, ComObj, ActiveX, StrUtils;

type
  TItemType = (Defender, ThirdSoftWare, UserFireWall);

type
  TAntiVirusChecker = class
  private
    FSoftDic: TDictionary<string, TArray<string>>;
    FSoftWare: string;
    function IsProcessRunning(const ExeName: string): Boolean;
  public
    function CheckDefender: Boolean;
    function CheckFirewall: Boolean;
    function CheckAntivirus: Boolean;
    constructor Create;
    destructor Destroy; override;
    property AntiVirusThirdSoftWare: string read FSoftWare;
  end;

const
  //WINDOWSDEFENDER = 'Windows Defender';
  DEFENDERPROCESS: TArray<string> = ['MsMpEng.exe', 'NisSrv.exe', 'SecurityHealthService.exe', 'SecurityHealthSystray.exe', 'MpCmdRun.exe'];
  SOFTWARE: TArray<string> = ['金山毒霸', '腾讯电脑管家', '360安全卫士'];
  KINGSOFTPROCESS: TArray<string> = ['kislive.exe', 'kwsprotect64.exe', 'kxecenter.exe', 'kxescore.exe', 'kxetray.exe', 'kxewsc.exe'];
  TENCENTPROCESS: TArray<string> = ['QQPCTray.exe', 'QQPCRTP.exe'];
  QIHOO360PROCESS: TArray<string> = ['360tray.exe', 'ZhudongFangYu.exe', 'safesvr.exe'];

implementation

{ TAntiVirusChecker }
function TAntiVirusChecker.CheckAntivirus: Boolean;
var
  Antivirus: string;
  Processes: string;
begin
  Result := False;
  FSoftWare := '';
  for Antivirus in FSoftDic.Keys do
  begin
    for Processes in FSoftDic[Antivirus] do
    begin
      if IsProcessRunning(Processes) then
      begin
        if FSoftWare <> '' then
          FSoftWare := FSoftWare + ', ';
        FSoftWare := Antivirus;
        Result := True;
        Break;
      end;
    end;
  end;
end;

function TAntiVirusChecker.CheckDefender: Boolean;
var
  Processes: string;
begin
  Result := False;
  for Processes in DEFENDERPROCESS do
  begin
    if IsProcessRunning(Processes) then
    begin
      Result := True;
    end;
  end;
end;

function TAntiVirusChecker.CheckFirewall: Boolean;
var
  fwMgr: OleVariant;
begin
  try
    CoInitialize(nil);
    try
      fwMgr := CreateOleObject('HNetCfg.FwMgr');
      Result := fwMgr.LocalPolicy.CurrentProfile.FirewallEnabled;
    finally
      CoUninitialize;
    end;
  except
    Result := False;
  end;
end;

constructor TAntiVirusChecker.Create;
begin
  inherited;
  FSoftDic := TDictionary<string, TArray<string>>.Create;

  FSoftDic.Add(SOFTWARE[0], KINGSOFTPROCESS);
  FSoftDic.Add(SOFTWARE[1], TENCENTPROCESS);
  FSoftDic.Add(SOFTWARE[2], QIHOO360PROCESS);
end;

destructor TAntiVirusChecker.Destroy;
begin
  FSoftDic.Free;
  inherited;
end;

function TAntiVirusChecker.IsProcessRunning(const ExeName: string): Boolean;
var
  SnapShot: THandle;
  ProcessEntry: TProcessEntry32;
begin
  Result := False;
  SnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if SnapShot <> INVALID_HANDLE_VALUE then
  begin
    ProcessEntry.dwSize := SizeOf(TProcessEntry32);
    if Process32First(SnapShot, ProcessEntry) then
    begin
      repeat
        if CompareText(ProcessEntry.szExeFile, ExeName) = 0 then
        begin
          Result := True;
          Break;
        end;
      until not Process32Next(SnapShot, ProcessEntry);
    end;
    CloseHandle(SnapShot);
  end;
end;

end.

