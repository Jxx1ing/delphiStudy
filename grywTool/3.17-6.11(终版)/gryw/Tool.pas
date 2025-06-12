unit Tool;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, FrameAntiVirus, FrameEncrytion, FrameNet, FrameEnvConfig;

type
  TToolForm = class(TForm)
    pgcTool: TPageControl;
    tsAntiVirus: TTabSheet;
    tsEncrytion: TTabSheet;
    tsNet: TTabSheet;
    tsEnvConfig: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private
    FAntiVirus: TFrmVirus;
    FEncryption: TFrmEncry;
    FEnvConfig: TFrmEnv;
    FNet: TFrmNet;
  public
    { Public declarations }
  end;

var
  ToolForm: TToolForm;

implementation

{$R *.dfm}

procedure TToolForm.FormCreate(Sender: TObject);
begin
  FAntiVirus := TFrmVirus.Create(Self);
  FAntiVirus.Parent := tsAntiVirus;
  FAntiVirus.Align := alClient;

  FEncryption := TFrmEncry.Create(Self);
  FEncryption.Parent := tsEncrytion;
  FEncryption.Align := alClient;

  FEnvConfig := TFrmEnv.Create(Self);
  FEnvConfig.Parent := tsEnvCOnfig;
  FEnvConfig.Align := alClient;

  FNet := TFrmNet.Create(Self);
  FNet.Parent := tsNet;
  FNet.Align := alClient;
end;

end.

