object FrmNet: TFrmNet
  Left = 0
  Top = 0
  Width = 598
  Height = 399
  TabOrder = 0
  object pnlNet: TPanel
    Left = 0
    Top = 0
    Width = 598
    Height = 399
    Align = alClient
    TabOrder = 0
    object scrlbxNet: TScrollBox
      Left = 1
      Top = 1
      Width = 596
      Height = 397
      VertScrollBar.Position = 2
      Align = alClient
      TabOrder = 0
      object btnNet: TButton
        Left = 342
        Top = 14
        Width = 131
        Height = 25
        Caption = #19968#38190#27979#35797#25152#26377#36830#25509
        TabOrder = 0
        OnClick = btnNetClick
      end
      object lstBasicConnet: TControlList
        Left = 15
        Top = 58
        Width = 556
        Height = 125
        ItemHeight = 35
        ItemMargins.Left = 0
        ItemMargins.Top = 0
        ItemMargins.Right = 0
        ItemMargins.Bottom = 0
        ParentColor = False
        TabOrder = 1
        OnBeforeDrawItem = lstBasicConnetBeforeDrawItem
        object lblBasicConnectKey: TLabel
          Left = 15
          Top = 15
          Width = 3
          Height = 15
        end
        object lblBasicConnectValue: TLabel
          Left = 350
          Top = 15
          Width = 3
          Height = 15
        end
      end
      object lstLatencyAndLoss: TControlList
        Left = 14
        Top = 228
        Width = 557
        Height = 100
        ItemHeight = 35
        ItemMargins.Left = 0
        ItemMargins.Top = 0
        ItemMargins.Right = 0
        ItemMargins.Bottom = 0
        ParentColor = False
        TabOrder = 2
        OnBeforeDrawItem = lstLatencyAndLossBeforeDrawItem
        object lblLatencyAndLossKey: TLabel
          Left = 15
          Top = 15
          Width = 3
          Height = 15
        end
        object lblLatencyAndLossValue: TLabel
          Left = 350
          Top = 15
          Width = 3
          Height = 15
        end
      end
      object pbNetCheck: TProgressBar
        Left = 14
        Top = 35
        Width = 299
        Height = 17
        TabOrder = 3
      end
      object lstConfig: TControlList
        Left = 16
        Top = 382
        Width = 556
        Height = 100
        ItemHeight = 35
        ItemMargins.Left = 0
        ItemMargins.Top = 0
        ItemMargins.Right = 0
        ItemMargins.Bottom = 0
        ParentColor = False
        TabOrder = 4
        OnBeforeDrawItem = lstConfigBeforeDrawItem
        object lblConfigKey: TLabel
          Left = 15
          Top = 15
          Width = 3
          Height = 15
        end
        object lblConfigValue: TLabel
          Left = 350
          Top = 15
          Width = 3
          Height = 15
        end
      end
      object btnFix: TButton
        Left = 497
        Top = 14
        Width = 75
        Height = 25
        Caption = #19968#38190#20462#22797
        TabOrder = 5
        OnClick = btnFixClick
      end
    end
  end
  object tmrLatencyAndLoss: TTimer
    Enabled = False
    Interval = 2500
    OnTimer = tmrLatencyAndLossTimer
    Left = 553
    Top = 193
  end
end
