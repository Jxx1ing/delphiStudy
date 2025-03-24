object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 432
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 604
    Height = 432
    Align = alClient
    OnMouseDown = Image1MouseDown
    OnMouseUp = Image1MouseUp
    ExplicitLeft = 136
    ExplicitTop = 8
    ExplicitWidth = 476
    ExplicitHeight = 420
  end
  object Panel1: TPanel
    Left = 0
    Top = 8
    Width = 121
    Height = 433
    TabOrder = 0
    object btnLine: TButton
      Left = 24
      Top = 32
      Width = 75
      Height = 25
      Caption = #30452#32447
      TabOrder = 0
      OnClick = btnLineClick
    end
    object btnArc: TButton
      Left = 24
      Top = 80
      Width = 75
      Height = 25
      Caption = #22278#24359
      TabOrder = 1
      OnClick = btnArcClick
    end
    object btnEllipse: TButton
      Left = 24
      Top = 136
      Width = 75
      Height = 25
      Caption = #26925#22278
      TabOrder = 2
      OnClick = btnEllipseClick
    end
    object btnSave: TButton
      Left = 24
      Top = 344
      Width = 75
      Height = 25
      Caption = #20445#23384
      TabOrder = 3
      OnClick = btnSaveClick
    end
    object btnLoad: TButton
      Left = 24
      Top = 384
      Width = 75
      Height = 25
      Caption = #21152#36733
      TabOrder = 4
      OnClick = btnLoadClick
    end
    object btnClear: TButton
      Left = 24
      Top = 192
      Width = 75
      Height = 25
      Caption = #28165#31354
      TabOrder = 5
      OnClick = btnClearClick
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 16
    Top = 288
  end
  object OpenDialog1: TOpenDialog
    Left = 72
    Top = 288
  end
end
