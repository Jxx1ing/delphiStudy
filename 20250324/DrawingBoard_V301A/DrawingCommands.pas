unit DrawingCommands;

interface

uses
  Vcl.Graphics, System.Types; // ���� System.Types ��ʹ�� TPoint

type
  // ����ӿ�
  IDrawingCommand = interface
    procedure Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
  end;

  // ��ֱ������
  TDrawLineCommand = class(TInterfacedObject, IDrawingCommand)
  public
    procedure Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
  end;

  // ��Բ������
  TDrawArcCommand = class(TInterfacedObject, IDrawingCommand)
  public
    procedure Execute(Canvas: TCanvas; StartPoint, EndPoint: TPoint);
  end;

  // ����Բ����
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
