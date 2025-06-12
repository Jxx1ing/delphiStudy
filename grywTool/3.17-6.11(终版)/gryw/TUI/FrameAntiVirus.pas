unit FrameAntiVirus;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.ControlList, CoreAntiVirus, Vcl.StdCtrls,
  System.Generics.Collections, Math, StrUtils, Vcl.Imaging.pngimage;

type
  TDisplayItem = record
    Text: string;
    IsPositive: Boolean;
    constructor Create(AText: string; AIsPositive: Boolean);
  end;

type
  TFrmVirus = class(TFrame)
    pnlAntiVirus: TPanel;
    scrlbxAntiVirus: TScrollBox;
    lstAntiVirus: TControlList;
    lblKey: TLabel;
    lblValue: TLabel;
    btnAntiVirus: TButton;
    pnlbtn: TPanel;
    imgAntiVirus: TImage;
    lblModuleName: TLabel;
    procedure lstAntiVirusBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnAntiVirusClick(Sender: TObject);
    procedure scrlbxAntiVirusMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
  private
    FAntiVirusChecker: TAntiVirusChecker;
    FDic: TDictionary<integer, TDisplayItem>;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateDefender;
    procedure UpdateAntivirus;
    procedure UpdateFireWall;
  end;

const
  WINDOWSDEFENDER = 'Windows Defender';
  ANTIVIRUSSOFTWARE = '第三方杀毒软件';
  FIREWALL = '防火墙';
  CHECKNOANTIVIRUSSOFTWARE = '未开启';
  CHECKANTIVIRUSSOFTWARE = '已开启，请退出以下软件：';
  CHECKNODEFENDER = '未开启';
  CHECKDEFENDER = '已开启';
  CHECKNOFIREWALL = '未开启';
  CHECKFIREWALL = '已开启';

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
  FDic := TDictionary<integer, TDisplayItem>.Create;
  for I := 0 to lstAntiVirus.ItemCount - 1 do
  begin
    FDic.Add(I, TDisplayItem.Create('', False));
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
var
  Item: TDisplayItem;
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

  if FDic.TryGetValue(AIndex, Item) then
  begin
    lblValue.Caption := Item.Text;
    if Item.IsPositive then
      lblValue.Font.Color := clGreen
    else
      lblValue.Font.Color := clRed;
  end;
end;

procedure TFrmVirus.scrlbxAntiVirusMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint; var Handled: Boolean);
begin
  scrlbxAntiVirus.VertScrollBar.Position := scrlbxAntiVirus.VertScrollBar.Position - WheelDelta div 2;
  Handled := True;
end;

procedure TFrmVirus.UpdateDefender;
var
  IsDefenderActive: Boolean;
begin
  IsDefenderActive := FAntiVirusChecker.CheckDefender;
  FDic.AddOrSetValue(Ord(Defender), TDisplayItem.Create(IfThen(IsDefenderActive, CHECKDEFENDER, CHECKNODEFENDER), IsDefenderActive));
end;

procedure TFrmVirus.UpdateAntivirus;
var
  IsAntivirusActive: Boolean;
  DisplayText: string;
begin
  IsAntivirusActive := FAntiVirusChecker.CheckAntiVirus;
  if IsAntivirusActive then
    DisplayText := CHECKANTIVIRUSSOFTWARE + #13#10 + FAntiVirusChecker.AntiVirusThirdSoftWare
  else
    DisplayText := CHECKNOANTIVIRUSSOFTWARE;

  FDic.AddOrSetValue(Ord(ThirdSoftWare), TDisplayItem.Create(DisplayText, not IsAntivirusActive));
end;

procedure TFrmVirus.UpdateFireWall;
var
  IsFirewallActive: Boolean;
begin
  IsFirewallActive := FAntiVirusChecker.CheckFirewall;
  FDic.AddOrSetValue(Ord(UserFireWall), TDisplayItem.Create(IfThen(IsFirewallActive, CHECKFIREWALL, CHECKNOFIREWALL), IsFirewallActive));
end;

{ TDisplayItem }
constructor TDisplayItem.Create(AText: string; AIsPositive: Boolean);
begin
  Text := AText;
  IsPositive := AIsPositive;
end;

end.

