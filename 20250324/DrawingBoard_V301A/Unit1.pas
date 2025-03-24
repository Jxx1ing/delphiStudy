unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, DrawingCommands, DrawingCommandFactory, System.Types,
  PngImage;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    btnLine: TButton;
    btnArc: TButton;
    btnEllipse: TButton;
    btnSave: TButton;
    btnLoad: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    btnClear: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnLineClick(Sender: TObject);
    procedure btnArcClick(Sender: TObject);
    procedure btnEllipseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
    FStartPoint, FEndPoint: TPoint;
    FCurrentTool: Integer;
    procedure DrawShape;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  TOOL_LINE = 1;
  TOOL_ARC = 2;
  TOOL_ELLIPSE = 3;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FCurrentTool := TOOL_LINE;
  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Pen.Width := 2;
end;

procedure TForm1.btnLineClick(Sender: TObject);
begin
  FCurrentTool := TOOL_LINE;
end;

procedure TForm1.btnArcClick(Sender: TObject);
begin
  FCurrentTool := TOOL_ARC;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  Image1.Picture.Graphic := nil;
end;

procedure TForm1.btnEllipseClick(Sender: TObject);
begin
  FCurrentTool := TOOL_ELLIPSE;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
var
  Png: TPngImage;
begin
  if SaveDialog1.Execute then
  begin
    Png := TPngImage.Create;
    try
      // 将TImage控件中的Bitmap内容赋值给TPngImage
      Png.Assign(Image1.Picture.Graphic);
      // 保存为PNG格式
      Png.SaveToFile(SaveDialog1.FileName);
    finally
      Png.Free;
    end;
  end;
end;

procedure TForm1.btnLoadClick(Sender: TObject);
var
  Bitmap: TBitmap;
  Png: TPngImage;
  SourceRect, DestRect: TRect;
begin
  if OpenDialog1.Execute then
  begin
    Bitmap := TBitmap.Create;
    try
      Png := TPngImage.Create;
      try
        Png.LoadFromFile(OpenDialog1.FileName); // 加载PNG图片
        Bitmap.Assign(Png);                     // 将PNG图片转换为Bitmap
        // 计算源矩形和目标矩形
        SourceRect := Rect(0, 0, Bitmap.Width, Bitmap.Height);
        DestRect := Rect(0, 0, Image1.Width, Image1.Height);
        // 调整目标矩形，使图片居中
        OffsetRect(DestRect, (Image1.Width - Bitmap.Width) div 2, (Image1.Height - Bitmap.Height) div 2);
        // 在Image1的Canvas上绘制Bitmap，使其居中
        Image1.Canvas.Draw(DestRect.Left, DestRect.Top, Bitmap);
      finally
        Png.Free;
      end;
    finally
      Bitmap.Free;
    end;
  end;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FStartPoint := Point(X, Y);
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FEndPoint := Point(X, Y);
  DrawShape;
end;

procedure TForm1.DrawShape;
var
  Command: IDrawingCommand;
begin
  Command := TDrawingCommandFactory.CreateCommand(FCurrentTool);
  if Assigned(Command) then
    Command.Execute(Image1.Canvas, FStartPoint, FEndPoint);
end;

end.
