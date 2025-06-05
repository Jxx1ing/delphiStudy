unit FrameAntiVirus;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ControlList, CoreAntiVirus, Vcl.StdCtrls, System.Generics.Collections,
  Math, StrUtils;

type
  TFrmVirus = class(TFrame)
    pnlAntiVirus: TPanel;
    scrlbxAntiVirus: TScrollBox;
    lstAntiVirus: TControlList;
    lblKey: TLabel;
    lblValue: TLabel;
    btnAntiVirus: TButton;
    procedure lstAntiVirusBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnAntiVirusClick(Sender: TObject);
  private
    FAntiVirusChecker: TAntiVirusChecker;
    FDic: TDictionary<Integer, string>;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateDefender;
    procedure UpdateAntivirus;
    procedure UpdateFireWall;
  end;

const
  WINDOWSDEFENDER = 'Windows Defender';
  ANTIVIRUSSOFTWARE = '������ɱ�����';
  FIREWALL = '����ǽ';
  CHECKNOANTIVIRUSSOFTWARE = 'δ����';
  CHECKANTIVIRUSSOFTWARE = '�ѿ��������˳����������';
  CHECKNODEFENDER = 'δ����';
  CHECKDEFENDER = '�ѿ���';
  CHECKNOFIREWALL = 'δ����';
  CHECKFIREWALL = '�ѿ���';

implementation

{$R *.dfm}

{ TFrmVirus }
procedure TFrmVirus.btnAntiVirusClick(Sender: TObject);
begin
  UpdateDefender;
  UpdateAntivirus;
  UpdateFireWall;
  lstAntiVirus.Invalidate;
end;

constructor TFrmVirus.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;
  lstAntiVirus.ItemCount := 3;
  FAntiVirusChecker := TAntiVirusChecker.Create;
  FDic := TDictionary<Integer, string>.Create;
  for I := 0 to lstAntiVirus.ItemCount - 1 do
  begin
    FDic.add(I, '');
  end;
end;

destructor TFrmVirus.Destroy;
begin
  if Assigned(FAntiVirusChecker) then
    FAntiVirusChecker.Free;
  FDic.Free;
  inherited;
end;

procedure TFrmVirus.lstAntiVirusBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  case AIndex of
    0:
      begin
        lblkey.Caption := WINDOWSDEFENDER;
      end;
    1:
      begin
        lblkey.Caption := ANTIVIRUSSOFTWARE;
      end;
    2:
      begin
        lblkey.Caption := FIREWALL;
      end;
  end;
  lblValue.Caption := FDic[AIndex];
end;

procedure TFrmVirus.UpdateDefender;
begin
  FDic.AddOrSetValue(Ord(Defender), IfThen(FAntiVirusChecker.CheckDefender, CHECKDEFENDER, CHECKNODEFENDER));
end;

procedure TFrmVirus.UpdateAntivirus;
begin
  FDic.AddOrSetValue(Ord(ThirdSoftWare), IfThen(FAntiVirusChecker.CheckAntiVirus, CHECKANTIVIRUSSOFTWARE + #13#10 + FAntiVirusChecker.AntiVirusThirdSoftWare, CHECKNOANTIVIRUSSOFTWARE));
end;

procedure TFrmVirus.UpdateFireWall;
begin
  FDic.AddOrSetValue(Ord(UserFireWall), IfThen(FAntiVirusChecker.CheckFirewall, CHECKFIREWALL, CHECKNOFIREWALL));
end;

end.

