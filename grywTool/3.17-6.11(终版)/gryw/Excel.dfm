object FormExcel: TFormExcel
  Left = 0
  Top = 0
  Caption = #20462#22797'Excel'
  ClientHeight = 210
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object rgChooseExcel: TRadioGroup
    Left = 100
    Top = 24
    Width = 185
    Height = 105
    Caption = #35831#36873#25321#20351#29992#30340'Excel'#31867#22411
    TabOrder = 0
  end
  object rbMicrosoft: TRadioButton
    Left = 120
    Top = 56
    Width = 113
    Height = 17
    Caption = 'Microsoft Excel'
    TabOrder = 1
  end
  object rbWPS: TRadioButton
    Left = 120
    Top = 88
    Width = 113
    Height = 17
    Caption = 'WPS Excel'
    TabOrder = 2
  end
  object btnExcelFix: TButton
    Left = 147
    Top = 152
    Width = 75
    Height = 25
    Caption = #24320#22987#20462#22797
    ModalResult = 1
    TabOrder = 3
    OnClick = btnExcelFixClick
  end
end
