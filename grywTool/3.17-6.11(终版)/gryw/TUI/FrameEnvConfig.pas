unit FrameEnvConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, CoreEnvConfig, Vcl.ControlList, Vcl.StdCtrls,
  System.Generics.Collections, ChooseLanguage, Math, StrUtils, Vcl.WinXCtrls,
  Excel, Vcl.Imaging.pngimage;

const
  EXCELREGISTRY = 'EXCEL ע���';
  JSREGISTRY = 'JS ע���';
  ACPVALUE = '��������';
  SHORTDATE = '������';
  SYSTEMFILES = 'ϵͳɨ��';
  CHECKEXCELSUCESSED = 'EXCEL ��������';
  CHECKEXCELFAILED = '������, ��ο��ֲ�4.5';
  CHECKJSSUCESSED = '����';
  CHECKJSFAILED = '�쳣';
  CHECKSHORTDATESUCCESSED = '����';
  CHECKSHORTDATEFAILED = '�쳣, �����޸�����ϵͳ����';
  FIXACPSUCESSED = '�޸��ɹ�';
  FIXACPFAILED = '�޸�ʧ��, ��ο��ֲ�7.1';
  FIXJSSUCESSED = '�޸��ɹ�';
  FIXJSFAILED = '�޸�ʧ�ܣ� ��ο��ֲ�5.6';
  FIXSHORTDATESUCCESSED = '�޸��ɹ�';
  FIXSHORTDATEFAILED = '�޸�ʧ�ܣ� ��ο��ֲ�4.1';
  SYSTEMFILERESULT = '���/�޸����������';
  LOCALCACHE = '���ػ���';
  CLOUDCACHE = '���Ż���';
  FRIENDESSREG = 'Friendess ע���ڵ�';
  CACHEEXIST = '����';
  CACHENOTEXIST = '������';
  RESETCACHESUCCESSED = '�����';
  RESETCACHEFAILED = '���ʧ�ܣ���ο��ֲ�4.2';
  FIXEXCELSUCESSED = 'Microsoft EXCEL �޸��ɹ�';
  FIXEXCELFAILED = '�޸�ʧ��, ���Գ��԰�װһ��WPS';

type
  TDisplayItem = record
    Text: string;
    IsPositive: Boolean;
    constructor Create(AText: string; AIsPositive: Boolean);
  end;

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
    lblCacheKey: TLabel;
    lblCacheValue: TLabel;
    btnResetCache: TButton;
    actvtyndctrCache: TActivityIndicator;
    btnExcel: TButton;
    pnlbtn: TPanel;
    lblModuleName1: TLabel;
    imgModuleName1: TImage;
    lblModuleName2: TLabel;
    imgModuleName2: TImage;
    procedure lstEnvSystemBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnACPFixedClick(Sender: TObject);
    procedure btnSystemDetectionClick(Sender: TObject);
    procedure btnSystemFixedClick(Sender: TObject);
    procedure lstEnvCacheBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnResetCacheClick(Sender: TObject);
    procedure btnExcelClick(Sender: TObject);
    procedure scrlbxEnvConfigMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    FEnvManger: TEnvManger;
    FSystemDic: TDictionary<Integer, TDisplayItem>;
    FCacheDic: TDictionary<Integer, TDisplayItem>;
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
      FSystemDic.AddOrSetValue(ord(EnvACP), TDisplayItem.Create(Ifthen(FEnvManger.Checkers[EnvACP].Fix, FIXACPSUCESSED, FIXACPFAILED), FEnvManger.Checkers[EnvACP].Fix));
      lstEnvSystem.Repaint;
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
      if FormExcel.rbMicrosoft.Checked then
      begin
        FSystemDic.AddOrSetValue(ord(EnvExcel), TDisplayItem.Create(IfThen(FormExcel.MicrosoftExcelFixedResult, FIXEXCELSUCESSED, FIXEXCELFAILED), FormExcel.MicrosoftExcelFixedResult));
      end
      else if FormExcel.rbWPS.Checked then
      begin
        FSystemDic.AddOrSetValue(ord(EnvExcel), TDisplayItem.Create(IfThen(FormExcel.WPSExcelFixedResult, FIXEXCELSUCESSED, FIXEXCELFAILED), FormExcel.WPSExcelFixedResult));
      end;
      lstEnvSystem.Repaint;
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
          FCacheDic.AddOrSetValue(Ord(CacheLocal), TDisplayItem.Create(Ifthen(CacheChecker.LocalStatus, RESETCACHESUCCESSED, RESETCACHEFAILED), CacheChecker.LocalStatus));
          FCacheDic.AddOrSetValue(Ord(CacheCloud), TDisplayItem.Create(Ifthen(CacheChecker.CloudStatus, RESETCACHESUCCESSED, RESETCACHEFAILED), CacheChecker.CloudStatus));
          FCacheDic.AddOrSetValue(Ord(CacheReg), TDisplayItem.Create(Ifthen(CacheChecker.RegStatus, RESETCACHESUCCESSED, RESETCACHEFAILED), CacheChecker.RegStatus));
          lstEnvCache.Repaint;
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
begin
  inherited;
  FEnvManger := TEnvManger.Create;

  lstEnvSystem.ItemCount := 5;
  lstEnvCache.ItemCount := 3;

  FSystemDic := TDictionary<Integer, TDisplayItem>.Create;
  for I := 0 to lstEnvSystem.ItemCount - 1 do
    FSystemDic.Add(I, TDisplayItem.Create('', False)); // ��ʼ״̬Ϊ��ɫ���ɫ

  FCacheDic := TDictionary<Integer, TDisplayItem>.Create;
  for I := 0 to lstEnvCache.ItemCount - 1 do
    FCacheDic.Add(I, TDisplayItem.Create('', False));

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
var
  Item: TDisplayItem;
begin
  case AIndex of
    0:
      lblCacheKey.Caption := LOCALCACHE;
    1:
      lblCacheKey.Caption := CLOUDCACHE;
    2:
      lblCacheKey.Caption := FRIENDESSREG;
  end;

  if FCacheDic.TryGetValue(AIndex, Item) then
  begin
    lblCacheValue.Caption := Item.Text;
    lblCacheValue.Font.Color := IfThen(Item.IsPositive, clGreen, clRed);
  end;
end;

procedure TFrmEnv.lstEnvSystemBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
var
  Item: TDisplayItem;
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

  if FSystemDic.TryGetValue(AIndex, Item) then
  begin
    lblValue.Caption := Item.Text;
    lblValue.Font.Color := IfThen(Item.IsPositive, clGreen, clRed);
  end;
end;

procedure TFrmEnv.scrlbxEnvConfigMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  scrlbxEnvConfig.VertScrollBar.Position := scrlbxEnvConfig.VertScrollBar.Position - WheelDelta div 2;
  Handled := True;
end;

procedure TFrmEnv.UpdateACPChecked;
var
  CurrentACP: Integer;
  ACPChecker: TACPChecker;
  ACPName: string; // ��������������
begin
  ACPChecker := TACPChecker(FEnvManger.Checkers[EnvACP]);

    // ִ�м���ȡ��ǰACPֵ
  ACPChecker.Check;
  CurrentACP := ACPChecker.CurrentACP;

    // ��FACPDic�ֵ��ѯ��Ӧ��ACP����
  if ACPChecker.ACPDic.TryGetValue(CurrentACP, ACPName) then
    FSystemDic.AddOrSetValue(ord(EnvACP), TDisplayItem.Create(ACPName, True))
  else
    FSystemDic.AddOrSetValue(ord(EnvACP), TDisplayItem.Create(Format('δ֪ACP��%d��', [CurrentACP]), True));

  lstEnvSystem.Repaint;
end;

procedure TFrmEnv.UpdateExcelChecked;
begin
  FSystemDic.AddOrSetValue(ord(EnvExcel), TDisplayItem.Create(IfThen(FEnvManger.Checkers[EnvExcel].Check, CHECKEXCELSUCESSED, CHECKEXCELFAILED), FEnvManger.Checkers[EnvExcel].Check));
  lstEnvSystem.Repaint;
end;

procedure TFrmEnv.UpdateJSChecked;
begin
  FSystemDic.AddOrSetValue(ord(EnvJS), TDisplayItem.Create(IfThen(FEnvManger.Checkers[EnvJS].Check, CHECKJSSUCESSED, CHECKJSFAILED), FEnvManger.Checkers[EnvJS].Check));
  lstEnvSystem.Repaint;
end;

procedure TFrmEnv.UpdateJSFixed;
begin
  FSystemDic.AddOrSetValue(ord(EnvJS), TDisplayItem.Create(Ifthen(FEnvManger.Checkers[EnvJS].Fix, FIXJSSUCESSED, FIXJSFAILED), FEnvManger.Checkers[EnvJS].Fix));
  lstEnvSystem.Repaint;
end;

procedure TFrmEnv.UpdateShortDateChecked;
begin
  FSystemDic.AddOrSetValue(ord(EnvShortDate), TDisplayItem.Create(Ifthen(FEnvManger.Checkers[EnvShortDate].Check, CHECKSHORTDATESUCCESSED, CHECKSHORTDATEFAILED), FEnvManger.Checkers[EnvShortDate].Check));
  lstEnvSystem.Repaint;
end;

procedure TFrmEnv.UpdateShortDateFixed;
begin
  FSystemDic.AddOrSetValue(ord(EnvShortDate), TDisplayItem.Create(Ifthen(FEnvManger.Checkers[EnvShortDate].Fix, FIXSHORTDATESUCCESSED, FIXSHORTDATEFAILED), FEnvManger.Checkers[EnvShortDate].Fix));
  lstEnvSystem.Repaint;
end;

procedure TFrmEnv.UpdateSystemFileCheckedAndAutoFixed;
begin
  FEnvManger.Checkers[EnvSystemFiles].Check;
  FSystemDic.AddOrSetValue(ord(EnvSystemFiles), TDisplayItem.Create(SYSTEMFILERESULT, True));
  lstEnvSystem.Repaint;
end;

procedure TFrmEnv.UpdateCacheChecked;
var
  CacheChecker: TCacheChecker;
begin
  CacheChecker := TCacheChecker(FEnvManger.Checkers[EnvCache]);    //�����޷�����������Ķ������ԣ���Ҫǿ������ת��
  CacheChecker.Check;
  FCacheDic.AddOrSetValue(Ord(CacheLocal), TDisplayItem.Create(Ifthen(CacheChecker.LocalExists, CACHEEXIST, CACHENOTEXIST), not CacheChecker.LocalExists));
  FCacheDic.AddOrSetValue(Ord(CacheCloud), TDisplayItem.Create(Ifthen(CacheChecker.CloudExists, CACHEEXIST, CACHENOTEXIST), not CacheChecker.CloudExists));
  FCacheDic.AddOrSetValue(Ord(CacheReg), TDisplayItem.Create(Ifthen(CacheChecker.RegExists, CACHEEXIST, CACHENOTEXIST), not CacheChecker.RegExists));
  lstEnvCache.Repaint;
end;

{ TDisplayItem }

constructor TDisplayItem.Create(AText: string; AIsPositive: Boolean);
begin
  Text := AText;
  IsPositive := AIsPositive;
end;

end.

