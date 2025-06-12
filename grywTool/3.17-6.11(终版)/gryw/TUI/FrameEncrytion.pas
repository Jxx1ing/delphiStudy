unit FrameEncrytion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ControlList, Math, StrUtils, CoreEncrytion,
  System.Generics.Collections, System.ImageList, Vcl.ImgList,
  Vcl.Imaging.pngimage;

type
  TDisplayItem = record
    Text: string;
    IsPositive: Boolean;
    constructor Create(AText: string; AIsPositive: Boolean);
  end;

type
  TFrmEncry = class(TFrame)
    pnlEncryption: TPanel;
    scrlbxEncrytion: TScrollBox;
    lstEncrytion: TControlList;
    lblkey: TLabel;
    lblValue: TLabel;
    btnEncrytion: TButton;
    pnlbtn: TPanel;
    imgEncrytion: TImage;
    lblModuleName: TLabel;
    procedure lstEncrytionBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnEncrytionClick(Sender: TObject);
    procedure scrlbxEncrytionMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    FEncryptionChecker: TEncryptionChecker;
    FDic: TDictionary<integer, TDisplayItem>;
  public
    constructor Create(AOwner: TComponent); override;   //��дFrame��Create������ָ��TControlList����Ŀ����
    destructor Destroy; override;
  end;

const
  NETCRYTION = '�������ؼ��ܼ��';
  FILECRYTION = '�ļ�������ܼ��';
  NETISENCRYTIONRESULT = '���ã�����ͨѶ������';
  NETISNOTENCRYTIONRESULT = 'δ���ã�����ͨѶ����';
  FILEISENCRYTIONRESULT = '���ã��ļ����汻����';
  FILEISNOTENCRYTIONRESULT = 'δ���ã��ļ���������';

implementation

{$R *.dfm}

procedure TFrmEncry.btnEncrytionClick(Sender: TObject);
var
  NetStatus: Boolean;
  FileStatus: Boolean;
begin
  NetStatus := FEncryptionChecker.CheckNet;
  FileStatus := FEncryptionChecker.CheckFile;

  FDic.AddOrSetValue(Ord(EncryNet), TDisplayItem.Create(IfThen(NetStatus, NETISNOTENCRYTIONRESULT, NETISENCRYTIONRESULT), NetStatus));
  FDic.AddOrSetValue(Ord(EncryFile), TDisplayItem.Create(IfThen(FileStatus, FILEISNOTENCRYTIONRESULT, FILEISENCRYTIONRESULT), FileStatus));

  lstEncrytion.Repaint;   //�����ػ�
end;

constructor TFrmEncry.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;
  lstEncrytion.ItemCount := 2;
  FEncryptionChecker := TEncryptionChecker.Create;
  FDic := TDictionary<integer, TDisplayItem>.Create;
  for I := 0 to lstEncrytion.ItemCount - 1 do
  begin
    FDic.Add(I, TDisplayItem.Create('', False));
  end;
end;

destructor TFrmEncry.Destroy;
begin
  if Assigned(FEncryptionChecker) then
    FEncryptionChecker.Free;
  FDic.Free;
  inherited;
end;

procedure TFrmEncry.lstEncrytionBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
var
  Item: TDisplayItem;
begin
  case AIndex of
    0:
      begin
        lblkey.Caption := NETCRYTION;
      end;
    1:
      begin
        lblkey.Caption := FILECRYTION;
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

procedure TFrmEncry.scrlbxEncrytionMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  scrlbxEncrytion.VertScrollBar.Position := scrlbxEncrytion.VertScrollBar.Position - WheelDelta div 2;
  Handled := True;
end;

{ TDisplayItem }
constructor TDisplayItem.Create(AText: string; AIsPositive: Boolean);
begin
  Text := AText;
  IsPositive := AIsPositive;
end;

end.

