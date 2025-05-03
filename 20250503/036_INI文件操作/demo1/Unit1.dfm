object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'INI'#37197#32622#25991#20214#25805#20316
  ClientHeight = 477
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object lblName: TLabel
    Left = 56
    Top = 56
    Width = 26
    Height = 15
    Caption = #22995#21517
  end
  object lblgender: TLabel
    Left = 56
    Top = 120
    Width = 26
    Height = 15
    Caption = #24615#21035
  end
  object lblAge: TLabel
    Left = 56
    Top = 88
    Width = 26
    Height = 15
    Caption = #24180#40836
  end
  object lblHobby: TLabel
    Left = 56
    Top = 232
    Width = 26
    Height = 15
    Caption = #29233#22909
  end
  object lblPosition: TLabel
    Left = 56
    Top = 331
    Width = 26
    Height = 15
    Caption = #20303#22336
  end
  object edtName: TEdit
    Left = 128
    Top = 56
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object dbrgrp1: TDBRadioGroup
    Left = 128
    Top = 128
    Width = 185
    Height = 65
    TabOrder = 1
  end
  object rbBoy: TRadioButton
    Left = 128
    Top = 160
    Width = 113
    Height = 17
    Caption = #30007
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object rbGirl: TRadioButton
    Left = 234
    Top = 160
    Width = 113
    Height = 17
    Caption = #22899
    TabOrder = 3
  end
  object edtAge: TEdit
    Left = 128
    Top = 85
    Width = 121
    Height = 23
    NumbersOnly = True
    TabOrder = 4
  end
  object grp1: TGroupBox
    Left = 128
    Top = 216
    Width = 219
    Height = 97
    TabOrder = 5
    object chkMoney: TCheckBox
      Left = 16
      Top = 3
      Width = 97
      Height = 17
      Caption = #38065
      TabOrder = 0
    end
    object chkProgram: TCheckBox
      Left = 104
      Top = 3
      Width = 97
      Height = 17
      Caption = #32534#31243
      TabOrder = 1
    end
  end
  object btnSave: TButton
    Left = 166
    Top = 416
    Width = 75
    Height = 25
    Caption = #20445#23384#35774#32622
    TabOrder = 6
    OnClick = btnSaveClick
  end
  object cbbPostion: TComboBox
    Left = 128
    Top = 328
    Width = 145
    Height = 23
    ItemIndex = 0
    TabOrder = 7
    Text = #21271#20140#28023#28096
    Items.Strings = (
      #21271#20140#28023#28096
      #27993#27743#26477#24030
      #19978#28023#38389#34892)
  end
end
