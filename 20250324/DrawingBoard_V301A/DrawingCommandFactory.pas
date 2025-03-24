unit DrawingCommandFactory;

interface

uses
  DrawingCommands, Vcl.Graphics;

type
  // 工厂类
  TDrawingCommandFactory = class
  public
    class function CreateCommand(Tool: Integer): IDrawingCommand;
  end;

implementation

{ TDrawingCommandFactory }

class function TDrawingCommandFactory.CreateCommand(Tool: Integer): IDrawingCommand;
begin
  case Tool of
    1: Result := TDrawLineCommand.Create;    // 直线
    2: Result := TDrawArcCommand.Create;     // 圆弧
    3: Result := TDrawEllipseCommand.Create; // 椭圆
  else
    Result := nil;
  end
end;

end.
