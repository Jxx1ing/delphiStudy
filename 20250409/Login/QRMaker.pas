unit QRMaker;

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.ExtCtrls, DelphiZXIngQRCode;

{定义一个函数生成二维码}
function GenerateQRBmp(const Data: WideString; Encoding: TQRCodeEncoding; QuietZone: Integer): TBitmap;

implementation

function GenerateQRBmp(const Data: WideString; Encoding: TQRCodeEncoding; QuietZone: Integer): TBitmap;
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := Data;
    QRCode.Encoding := Encoding;
    QRCode.QuietZone := QuietZone;
    Result := TBitmap.Create;
    Result.SetSize(QRCode.Rows, QRCode.Columns);
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if QRCode.IsBlack[Row, Column] then
          Result.Canvas.Pixels[Column, Row] := clBlack
        else
          Result.Canvas.Pixels[Column, Row] := clWhite;
      end;
    end;
  finally
    QRCode.Free;
  end;
end;


end.
