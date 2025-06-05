object FrmEncry: TFrmEncry
  Left = 0
  Top = 0
  Width = 598
  Height = 399
  TabOrder = 0
  object pnlEncryption: TPanel
    Left = 0
    Top = 0
    Width = 598
    Height = 399
    Align = alClient
    TabOrder = 0
    object scrlbxEncrytion: TScrollBox
      Left = 1
      Top = 1
      Width = 596
      Height = 397
      Align = alClient
      TabOrder = 0
      object lstEncrytion: TControlList
        Left = 15
        Top = 60
        Width = 564
        Height = 171
        ItemHeight = 35
        ItemMargins.Left = 0
        ItemMargins.Top = 0
        ItemMargins.Right = 0
        ItemMargins.Bottom = 0
        ParentColor = False
        TabOrder = 0
        OnBeforeDrawItem = lstEncrytionBeforeDrawItem
        object lblkey: TLabel
          Left = 20
          Top = 15
          Width = 3
          Height = 15
        end
        object lblValue: TLabel
          Left = 350
          Top = 15
          Width = 3
          Height = 15
        end
      end
    end
    object btnEncrytion: TButton
      Left = 513
      Top = 25
      Width = 75
      Height = 25
      Caption = #21152#23494#26816#27979
      TabOrder = 1
      OnClick = btnEncrytionClick
    end
  end
end
