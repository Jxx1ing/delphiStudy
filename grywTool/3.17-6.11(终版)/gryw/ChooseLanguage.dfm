object FormLanguage: TFormLanguage
  Left = 0
  Top = 0
  Caption = 'Language'
  ClientHeight = 170
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object lbltip: TLabel
    Left = 104
    Top = 45
    Width = 68
    Height = 15
    Caption = #35831#36873#25321#35821#35328':'
  end
  object lblACP: TLabel
    Left = 104
    Top = 96
    Width = 88
    Height = 15
    Caption = #23545#24212#30340'ACP'#20540#65306
  end
  object lblACPValue: TLabel
    Left = 200
    Top = 96
    Width = 3
    Height = 15
  end
  object cbbLanguage: TComboBox
    Left = 200
    Top = 42
    Width = 185
    Height = 23
    TabOrder = 0
    OnChange = cbbLanguageChange
    Items.Strings = (
      #31616#20307#20013#25991
      #32321#39636#20013#25991
      'English       '#65288#33521#35821#65289
      #1056#1091#1089#1089#1082#1080#1081'     '#65288#20420#35821#65289
      #54620#44397#50612'       '#65288#38889#35821#65289
      'Polski         '#65288#27874#20848#35821#65289
      #268'e'#353'tina      '#65288#25463#20811#35821#65289
      'Deutsch     '#65288#24503#35821#65289
      'Espa'#241'ol      '#65288#35199#29677#29273#35821#65289
      'Fran'#231'ais     '#65288#27861#35821#65289
      'Italiano      '#65288#24847#22823#21033#35821#65289
      #26085#26412#35486'      '#65288#26085#26412#35821#65289
      'T'#252'rk'#231'e       '#65288#22303#32819#20854#35821#65289
      'Ti'#7871'ng Vi'#7879't  '#65288#36234#21335#35821#65289
      'Portugu'#234's  '#65288#33889#33796#29273#35821#65289
      ''
      ''
      ''
      '')
  end
  object btnok: TButton
    Left = 218
    Top = 128
    Width = 75
    Height = 25
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 1
  end
end
