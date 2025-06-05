object FrmVirus: TFrmVirus
  Left = 0
  Top = 0
  Width = 598
  Height = 399
  TabOrder = 0
  object pnlAntiVirus: TPanel
    Left = 0
    Top = 0
    Width = 598
    Height = 399
    Align = alClient
    TabOrder = 0
    object scrlbxAntiVirus: TScrollBox
      Left = 1
      Top = 1
      Width = 596
      Height = 397
      Align = alClient
      TabOrder = 0
      object lstAntiVirus: TControlList
        Left = 15
        Top = 60
        Width = 564
        Height = 171
        ItemHeight = 45
        ItemMargins.Left = 0
        ItemMargins.Top = 0
        ItemMargins.Right = 0
        ItemMargins.Bottom = 0
        ParentColor = False
        TabOrder = 0
        OnBeforeDrawItem = lstAntiVirusBeforeDrawItem
        object lblKey: TLabel
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
      object btnAntiVirus: TButton
        Left = 504
        Top = 29
        Width = 75
        Height = 25
        Caption = #20840#38754#25195#25551
        TabOrder = 1
        OnClick = btnAntiVirusClick
      end
    end
  end
end
