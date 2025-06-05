unit FrameEnvConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, CoreEnvConfig, Vcl.ControlList, Vcl.StdCtrls,
  System.Generics.Collections, ChooseLanguage, Math, StrUtils, Vcl.WinXCtrls,
  Excel;

const
  EXCELREGISTRY = 'EXCEL 注册表';
  JSREGISTRY = 'JS 注册表';
  ACPVALUE = '编码语言';
  SHORTDATE = '短日期';
  SYSTEMFILES = '系统扫描';
  CHECKEXCELSUCESSED = 'EXCEL 可能正常';
  CHECKEXCELFAILED = '不正常';
  CHECKJSSUCESSED = '正常';
  CHECKJSFAILED = '异常';
  CHECKSHORTDATESUCCESSED = '正常';
  CHECKSHORTDATEFAILED = '异常, 请点击修复部分系统环境';
  FIXACPSUCESSED = '修复成功';
  FIXACPFAILED = '修复失败, 请参考手册';
  FIXJSSUCESSED = '修复成功';
  FIXJSFAILED = '修复失败， 请参考手册';
  FIXSHORTDATESUCCESSED = '修复成功';
  FIXSHORTDATEFAILED = '修复失败， 请参考手册';
  SYSTEMFILERESULT = '检测/修复结果见弹窗';
  LOCALCACHE = '本地缓存';
  CLOUDCACHE = '云排缓存';
  FRIENDESSREG = 'Friendess 注册表节点';
  CACHEEXIST = '存在';
  CACHENOTEXIST = '不存在';
  RESETCACHESUCCESSED = '已清空';
  RESETCACHEFAILED = '清空失败，请参考手册';
  FIXEXCELSUCESSED = 'Microsoft EXCEL 修复成功';
  FIXEXCELFAILED = '修复失败, 可以尝试安装一个WPS';

type
  TFrmEnv = class(TFrame)
    pnlEnvConfig: TPanel;
    scrlbxEnvConfig: TScrollBox;
    lstEnvSystem: TControlList;
    lblKey: TLabel;
    lblValue: TLabel;
    btnACPFixed: TButton;
    btnSystemDetection: TButton;
    btnSystemFixed: TButton;
    lstEnvCache: TControlList;
    grpButton: TGroupBox;
    lblCacheKey: TLabel;
    lblCacheValue: TLabel;
    btnResetCache: TButton;
    actvtyndctrCache: TActivityIndicator;
    btnExcel: TButton;
    procedure lstEnvSystemBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnACPFixedClick(Sender: TObject);
    procedure btnSystemDetectionClick(Sender: TObject);
    procedure btnSystemFixedClick(Sender: TObject);
    procedure lstEnvCacheBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnResetCacheClick(Sender: TObject);
    procedure btnExcelClick(Sender: TObject);
  private
    FEnvManger: TEnvManger;
    FSystemDic: TDictionary<integer, string>;
    FCacheDic: TDictionary<integer, string>;
    procedure UpdateExcelChecked;
    procedure UpdateJSChecked;
    procedure UpdateJSFixed;
    procedure UpdateACPChecked;
    //procedure UpdateACPFixed;
    procedure UpdateShortDateChecked;
    procedure UpdateShortDateFixed;
    procedure UpdateSystemFileCheckedAndAutoFixed;
    procedure UpdateCacheChecked;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TFrmREnv }
procedure TFrmEnv.btnACPFixedClick(Sender: TObject);
begin
  FormLanguage := TFormLanguage.Create(nil);
  try
    FormLanguage.cbbLanguage.ItemIndex := -1;
    if FormLanguage.ShowModal = mrOk then
    begin
      //字典中得到的checker类型是TEnvChecker基类，需要转化
      //ACPChecker := FEnvManger.Checkers[EnvACP] as TACPChecker;
      //FDic.AddOrSetValue(2, Ifthen(ACPChecker.Fix, FIXACPSUCESS, FIXACPFAILED));
      FSystemDic.AddOrSetValue(ord(EnvACP), Ifthen(FEnvManger.Checkers[EnvACP].Fix, FIXACPSUCESSED, FIXACPFAILED));
      lstEnvSystem.Invalidate;
    end;
  finally
    FormLanguage.Free;
  end;
end;

procedure TFrmEnv.btnExcelClick(Sender: TObject);
begin
  FormExcel := TFormExcel.Create(nil);
  try
    if FormExcel.ShowModal = mrOk then
    begin
      //如果注册excel.exe可以成功，说明修复成功；否则，（1）要么excel.exe不存在 （2）要么用户使用WPS 两种情况————解决方法统一视为重新装一个WPS
      //FSystemDic.AddOrSetValue(ord(EnvExcel), IfThen(FormExcel.MicrosoftExcelFixedResult, FIXEXCELSUCESSED, FIXEXCELFAILED));

      if FormExcel.rbMicrosoft.Checked then
      begin
        FSystemDic.AddOrSetValue(ord(EnvExcel), IfThen(FormExcel.MicrosoftExcelFixedResult, FIXEXCELSUCESSED, FIXEXCELFAILED))
      end
      else if FormExcel.rbWPS.Checked then
      begin
        FSystemDic.AddOrSetValue(ord(EnvExcel), IfThen(FormExcel.WPSExcelFixedResult, FIXEXCELSUCESSED, FIXEXCELFAILED));
      end;
      lstEnvSystem.Invalidate;
    end;
  finally
    FormExcel.Free;
  end;
end;

procedure TFrmEnv.btnResetCacheClick(Sender: TObject);
var
  ResetCacheCompleted: Boolean;
  CacheChecker: TCacheChecker;
begin
  btnResetCache.Enabled := False;
  actvtyndctrCache.Animate := True;
  actvtyndctrCache.Visible := True;

  CacheChecker := TCacheChecker(FEnvManger.Checkers[EnvCache]);
  TThread.CreateAnonymousThread(
    procedure
    begin
      ResetCacheCompleted := CacheChecker.Fix;
      //Sleep(10000);
      //重置缓存完成后，回到主线程更新结果
      TThread.Synchronize(nil,
        procedure
        begin
          btnResetCache.Enabled := True;
          actvtyndctrCache.Animate := False;
          FCacheDic.AddOrSetValue(Ord(CacheLocal), Ifthen(CacheChecker.LocalStatus, RESETCACHESUCCESSED, RESETCACHEFAILED));
          FCacheDic.AddOrSetValue(Ord(CacheCloud), Ifthen(CacheChecker.CloudStatus, RESETCACHESUCCESSED, RESETCACHEFAILED));
          FCacheDic.AddOrSetValue(Ord(CacheReg), Ifthen(CacheChecker.RegStatus, RESETCACHESUCCESSED, RESETCACHEFAILED));
          lstEnvCache.Invalidate;
          actvtyndctrCache.Visible := False;
        end)
    end).Start;
end;

procedure TFrmEnv.btnSystemDetectionClick(Sender: TObject);
begin
  UpdateExcelChecked;
  UpdateJSChecked;
  UpdateACPChecked;
  UpdateShortDateChecked;
  UpdateCacheChecked;
end;

procedure TFrmEnv.btnSystemFixedClick(Sender: TObject);
begin
  UpdateJSFixed;
  UpdateShortDateFixed;
  UpdateSystemFileCheckedAndAutoFixed;
end;

constructor TFrmEnv.Create(AOwner: TComponent);
var
  I: Integer;
  J: Integer;
begin
  inherited;
  FEnvManger := TEnvManger.Create;

  lstEnvSystem.ItemCount := 5;
  lstEnvCache.ItemCount := 3;

  FSystemDic := TDictionary<integer, string>.Create;
  for I := 0 to lstEnvSystem.ItemCount - 1 do
  begin
    FSystemDic.add(I, '');
  end;

  FCacheDic := TDictionary<integer, string>.Create;
  for J := 0 to lstEnvSystem.ItemCount - 1 do
  begin
    FCacheDic.add(J, '');
  end;

  actvtyndctrCache.Visible := False;
end;

destructor TFrmEnv.Destroy;
begin
  if Assigned(FEnvManger) then
    FEnvManger.Destroy;
  FSystemDic.Free;
  FCacheDic.Free;
  inherited;
end;

procedure TFrmEnv.lstEnvCacheBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  case AIndex of
    0:
      lblCacheKey.Caption := LOCALCACHE;
    1:
      lblCacheKey.Caption := CLOUDCACHE;
    2:
      lblCacheKey.Caption := FRIENDESSREG;
  end;
  lblCacheValue.Caption := FCacheDic[AIndex];
end;

procedure TFrmEnv.lstEnvSystemBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  case AIndex of
    0:
      lblKey.Caption := EXCELREGISTRY;
    1:
      lblKey.Caption := JSREGISTRY;
    2:
      lblKey.Caption := ACPVALUE;
    3:
      lblKey.Caption := SHORTDATE;
    4:
      lblKey.Caption := SYSTEMFILES;
  end;
  lblValue.Caption := FSystemDic[AIndex];
end;

procedure TFrmEnv.UpdateACPChecked;
begin
  FEnvManger.Checkers[EnvACP].Check;
  //基类没有CurrentACP属性，不会动态绑定。因此需要强制类型转换；而方法由于可以动态绑定，可以采用基类调用。
  case TACPChecker(FEnvManger.Checkers[EnvACP]).CurrentACP of
    932:
      FSystemDic.AddOrSetValue(ord(EnvACP), '日语');
    936:
      FSystemDic.AddOrSetValue(ord(EnvACP), '中文');
    950:
      FSystemDic.AddOrSetValue(ord(EnvACP), '繁体中文');
    1250:
      FSystemDic.AddOrSetValue(ord(EnvACP), '波兰语');
    1251:
      FSystemDic.AddOrSetValue(ord(EnvACP), '俄语');
    1254:
      FSystemDic.AddOrSetValue(ord(EnvACP), '土耳其语');
    1258:
      FSystemDic.AddOrSetValue(ord(EnvACP), '越南语');
    1252:
      FSystemDic.AddOrSetValue(ord(EnvACP), '西欧语,常见如英语……');
  end;
  lstEnvSystem.Invalidate;
end;

procedure TFrmEnv.UpdateExcelChecked;
begin
  FSystemDic.AddOrSetValue(ord(EnvExcel), Ifthen(FEnvManger.Checkers[EnvExcel].Check, CHECKEXCELSUCESSED, CHECKEXCELFAILED));
  lstEnvSystem.Invalidate;
end;

procedure TFrmEnv.UpdateJSChecked;
begin
  FSystemDic.AddOrSetValue(ord(EnvJS), Ifthen(FEnvManger.Checkers[EnvJS].Check, CHECKJSSUCESSED, CHECKJSFAILED));
  lstEnvSystem.Invalidate;
end;

procedure TFrmEnv.UpdateJSFixed;
begin
  FSystemDic.AddOrSetValue(ord(EnvJS), Ifthen(FEnvManger.Checkers[EnvJS].Fix, FIXJSSUCESSED, FIXJSFAILED));
  lstEnvSystem.Invalidate;
end;

procedure TFrmEnv.UpdateShortDateChecked;
begin
  FSystemDic.AddOrSetValue(ord(EnvShortDate), Ifthen(FEnvManger.Checkers[EnvShortDate].Check, CHECKSHORTDATESUCCESSED, CHECKSHORTDATEFAILED));
  lstEnvSystem.Invalidate;
end;

procedure TFrmEnv.UpdateShortDateFixed;
begin
  FSystemDic.AddOrSetValue(ord(EnvShortDate), Ifthen(FEnvManger.Checkers[EnvShortDate].Fix, FIXSHORTDATESUCCESSED, FIXSHORTDATEFAILED));
  lstEnvSystem.Invalidate;
end;

procedure TFrmEnv.UpdateSystemFileCheckedAndAutoFixed;
begin
  FEnvManger.Checkers[EnvSystemFiles].Check;
  FSystemDic.AddOrSetValue(ord(EnvSystemFiles), SYSTEMFILERESULT);
  lstEnvSystem.Invalidate;
end;

procedure TFrmEnv.UpdateCacheChecked;
var
  CacheChecker: TCacheChecker;
begin
  CacheChecker := TCacheChecker(FEnvManger.Checkers[EnvCache]);    //基类无法访问派生类的独有属性，需要强制类型转化
  CacheChecker.Check;
  FCacheDic.AddOrSetValue(Ord(CacheLocal), Ifthen(CacheChecker.LocalExists, CACHEEXIST, CACHENOTEXIST));
  FCacheDic.AddOrSetValue(Ord(CacheCloud), Ifthen(CacheChecker.CloudExists, CACHEEXIST, CACHENOTEXIST));
  FCacheDic.AddOrSetValue(Ord(CacheReg), Ifthen(CacheChecker.RegExists, CACHEEXIST, CACHENOTEXIST));
  lstEnvCache.Invalidate;
end;

end.

