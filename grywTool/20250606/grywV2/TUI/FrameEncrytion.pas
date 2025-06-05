unit FrameEncrytion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ControlList, Math, StrUtils, CoreEncrytion,
  System.Generics.Collections;

type
  TFrmEncry = class(TFrame)
    pnlEncryption: TPanel;
    scrlbxEncrytion: TScrollBox;
    lstEncrytion: TControlList;
    lblkey: TLabel;
    lblValue: TLabel;
    btnEncrytion: TButton;
    procedure lstEncrytionBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure btnEncrytionClick(Sender: TObject);
  private
    FEncryptionChecker: TEncryptionChecker;
    FDic: TDictionary<integer, string>;
  public
    constructor Create(AOwner: TComponent); override;   //重写Frame的Create方法，指明TControlList的条目数量
    destructor Destroy; override;
  end;

const
  NETCRYTION = '网络拦截加密检测';
  FILECRYTION = '文件保存加密检测';
  NETISENCRYTIONRESULT = '启用：网络通讯被加密';
  NETISNOTENCRYTIONRESULT = '未启用：网络通讯正常';
  FILEISENCRYTIONRESULT = '启用：文件保存被加密';
  FILEISNOTENCRYTIONRESULT = '未启用：文件保存正常';

implementation

{$R *.dfm}

procedure TFrmEncry.btnEncrytionClick(Sender: TObject);
begin
  FDic.AddOrSetValue(Ord(EncryNet), IfThen(FEncryptionChecker.CheckNet, NETISNOTENCRYTIONRESULT, NETISENCRYTIONRESULT));
  FDic.AddOrSetValue(Ord(EncryFile), IfThen(FEncryptionChecker.CheckFile, FILEISNOTENCRYTIONRESULT, FILEISENCRYTIONRESULT));

  lstEncrytion.Invalidate;   //立即重绘
end;

constructor TFrmEncry.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;
  lstEncrytion.ItemCount := 2;
  FEncryptionChecker := TEncryptionChecker.Create;
  FDic := TDictionary<integer, string>.Create;
  for I := 0 to lstEncrytion.ItemCount - 1 do
  begin
    FDic.add(I, '');
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
  lblValue.Caption := FDic[AIndex];
end;

end.

