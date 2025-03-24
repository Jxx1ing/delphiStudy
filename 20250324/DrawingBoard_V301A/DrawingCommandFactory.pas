unit DrawingCommandFactory;

interface

uses
  DrawingCommands, Vcl.Graphics;

type
  // ������
  TDrawingCommandFactory = class
  public
    class function CreateCommand(Tool: Integer): IDrawingCommand;
  end;

implementation

{ TDrawingCommandFactory }

class function TDrawingCommandFactory.CreateCommand(Tool: Integer): IDrawingCommand;
begin
  case Tool of
    1: Result := TDrawLineCommand.Create;    // ֱ��
    2: Result := TDrawArcCommand.Create;     // Բ��
    3: Result := TDrawEllipseCommand.Create; // ��Բ
  else
    Result := nil;
  end
end;

end.
