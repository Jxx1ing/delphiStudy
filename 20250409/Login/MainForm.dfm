object FormLogin: TFormLogin
  Left = 645
  Top = 311
  Caption = #30331#38470
  ClientHeight = 411
  ClientWidth = 598
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object lblQR: TLabel
    Left = 240
    Top = 320
    Width = 78
    Height = 15
    Caption = #35831#25195#25551#20108#32500#30721
  end
  object imgQR: TImage
    Left = 136
    Top = 48
    Width = 281
    Height = 249
    Center = True
    Stretch = True
  end
  object btnQR: TButton
    Left = 240
    Top = 360
    Width = 75
    Height = 25
    Caption = #29983#25104#20108#32500#30721
    TabOrder = 0
    OnClick = btnQRClick
  end
  object tmrAuth: TTimer
    Interval = 2000
    OnTimer = tmrAuthTimer
    Left = 504
    Top = 192
  end
end
