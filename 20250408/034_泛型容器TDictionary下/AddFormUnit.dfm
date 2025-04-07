object FormAdd: TFormAdd
  Left = 613
  Top = 295
  Caption = #26032#22686#23398#29983#20449#24687
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  TextHeight = 15
  object lblName: TLabel
    Left = 56
    Top = 96
    Width = 26
    Height = 15
    Caption = #22995#21517
  end
  object lblAge: TLabel
    Left = 56
    Top = 168
    Width = 26
    Height = 15
    Caption = #24180#40836
  end
  object edtName: TEdit
    Left = 160
    Top = 93
    Width = 121
    Height = 23
    TabOrder = 0
    Text = 'edtName'
    OnClick = edtNameClick
  end
  object edtAge: TEdit
    Left = 160
    Top = 165
    Width = 121
    Height = 23
    TabOrder = 1
    Text = 'edtAge'
    OnClick = edtAgeClick
  end
  object btnSave: TButton
    Left = 120
    Top = 272
    Width = 75
    Height = 25
    Caption = #20445#23384
    TabOrder = 2
    OnClick = btnSaveClick
  end
end
