unit FrameEnvConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, CoreEnvConfig, Vcl.ControlList, Vcl.StdCtrls,
  System.Generics.Collections, ChooseLanguage, Math, StrUtils, Vcl.WinXCtrls,
  Excel;

const
  EXCELREGISTRY = 'EXCEL ע���';
  JSREGISTRY = 'JS ע���';
  ACPVALUE = '��������';
  SHORTDATE = '������';
  SYSTEMFILES = 'ϵͳɨ��';
  CHECKEXCELSUCESSED = 'EXCEL ��������';
  CHECKEXCELFAILED = '������';
  CHECKJSSUCESSED = '����';
  CHECKJSFAILED = '�쳣';
  CHECKSHORTDATESUCCESSED = '����';
  CHECKSHORTDATEFAILED = '�쳣, �����޸�����ϵͳ����';
  FIXACPSUCESSED = '�޸��ɹ�';
  FIXACPFAILED = '�޸�ʧ��, ��ο��ֲ�';
  FIXJSSUCESSED = '�޸��ɹ�';
  FIXJSFAILED = '�޸�ʧ�ܣ� ��ο��ֲ�';
  FIXSHORTDATESUCCESSED = '�޸��ɹ�';
  FIXSHORTDATEFAILED = '�޸�ʧ�ܣ� ��ο��ֲ�';
  SYSTEMFILERESULT = '���/�޸����������';
  LOCALCACHE = '���ػ���';
  CLOUDCACHE = '���Ż���';
  FRIENDESSREG = 'Friendess ע���ڵ�';
  CACHEEXIST = '����';
  CACHENOTEXIST = '������';
  RESETCACHESUCCESSED = '�����';
  RESETCACHEFAILED = '���ʧ�ܣ���ο��ֲ�';
  FIXEXCELSUCESSED = 'Microsoft EXCEL �޸��ɹ�';
  FIXEXCELFAILED = '�޸�ʧ��, ���Գ��԰�װһ��WPS';

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
      //�ֵ��еõ���checker������TEnvChecker���࣬��Ҫת��
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
      //���ע��excel.exe���Գɹ���˵���޸��ɹ������򣬣�1��Ҫôexcel.exe������ ��2��Ҫô�û�ʹ��WPS ����������������������ͳһ��Ϊ����װһ��WPS
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
      //���û�����ɺ󣬻ص����̸߳��½��
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
  //����û��CurrentACP���ԣ����ᶯ̬�󶨡������Ҫǿ������ת�������������ڿ��Զ�̬�󶨣����Բ��û�����á�
  case TACPChecker(FEnvManger.Checkers[EnvACP]).CurrentACP of
    932:
      FSystemDic.AddOrSetValue(ord(EnvACP), '����');
    936:
      FSystemDic.AddOrSetValue(ord(EnvACP), '����');
    950:
      FSystemDic.AddOrSetValue(ord(EnvACP), '��������');
    1250:
      FSystemDic.AddOrSetValue(ord(EnvACP), '������');
    1251:
      FSystemDic.AddOrSetValue(ord(EnvACP), '����');
    1254:
      FSystemDic.AddOrSetValue(ord(EnvACP), '��������');
    1258:
      FSystemDic.AddOrSetValue(ord(EnvACP), 'Խ����');
    1252:
      FSystemDic.AddOrSetValue(ord(EnvACP), '��ŷ��,������Ӣ���');
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
  CacheChecker := TCacheChecker(FEnvManger.Checkers[EnvCache]);    //�����޷�����������Ķ������ԣ���Ҫǿ������ת��
  CacheChecker.Check;
  FCacheDic.AddOrSetValue(Ord(CacheLocal), Ifthen(CacheChecker.LocalExists, CACHEEXIST, CACHENOTEXIST));
  FCacheDic.AddOrSetValue(Ord(CacheCloud), Ifthen(CacheChecker.CloudExists, CACHEEXIST, CACHENOTEXIST));
  FCacheDic.AddOrSetValue(Ord(CacheReg), Ifthen(CacheChecker.RegExists, CACHEEXIST, CACHENOTEXIST));
  lstEnvCache.Invalidate;
end;

end.

