object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 429
  ClientWidth = 576
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object image1: TImage
    Left = 304
    Top = 40
    Width = 241
    Height = 209
    Stretch = True
  end
  object lblStatus: TLabel
    Left = 344
    Top = 272
    Width = 3
    Height = 15
  end
  object Button1: TButton
    Left = 368
    Top = 344
    Width = 121
    Height = 25
    Caption = #29983#25104#20108#32500#30721
    TabOrder = 0
    OnClick = Button1Click
  end
  object memo1: TMemo
    Left = 16
    Top = 40
    Width = 265
    Height = 369
    TabOrder = 1
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 544
    Top = 8
  end
end
