unit DrawingCommands;

interface

uses
  Vcl.Graphics, System.Types; // 引入 System.Types 以使用 TPoint

type
  // 命令接口
  IDrawingCommand = interface
    procedure Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
  end;

  // 画直线命令
  TDrawLineCommand = class(TInterfacedObject, IDrawingCommand)
  public
    procedure Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
  end;

  // 画圆弧命令
  TDrawArcCommand = class(TInterfacedObject, IDrawingCommand)
  public
    procedure Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
  end;

  // 画椭圆命令
  TDrawEllipseCommand = class(TInterfacedObject, IDrawingCommand)
  public
    procedure Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
  end;

implementation

{ TDrawLineCommand }

procedure TDrawLineCommand.Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
begin
  Canvas.MoveTo(StartPoint.X, StartPoint.Y);
  Canvas.LineTo(EndPoint.X, EndPoint.Y);
end;

{ TDrawArcCommand }

procedure TDrawArcCommand.Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
begin
  Canvas.Arc(StartPoint.X, StartPoint.Y, EndPoint.X, EndPoint.Y,
             StartPoint.X, StartPoint.Y, EndPoint.X, EndPoint.Y);
end;

{ TDrawEllipseCommand }

procedure TDrawEllipseCommand.Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
begin
  Canvas.Ellipse(StartPoint.X, StartPoint.Y, EndPoint.X, EndPoint.Y);
end;

end.
