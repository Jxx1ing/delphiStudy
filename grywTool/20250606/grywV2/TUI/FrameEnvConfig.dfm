object FrmEnv: TFrmEnv
  Left = 0
  Top = 0
  Width = 598
  Height = 399
  TabOrder = 0
  object pnlEnvConfig: TPanel
    Left = 0
    Top = 0
    Width = 598
    Height = 399
    Align = alClient
    TabOrder = 0
    object scrlbxEnvConfig: TScrollBox
      Left = 1
      Top = 31
      Width = 596
      Height = 367
      Align = alClient
      TabOrder = 0
      object lstEnvSystem: TControlList
        Left = 11
        Top = 28
        Width = 561
        Height = 175
        ItemHeight = 35
        ItemMargins.Left = 0
        ItemMargins.Top = 0
        ItemMargins.Right = 0
        ItemMargins.Bottom = 0
        ParentColor = False
        TabOrder = 0
        OnBeforeDrawItem = lstEnvSystemBeforeDrawItem
        object lblKey: TLabel
          Left = 15
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
      object lstEnvCache: TControlList
        Left = 11
        Top = 251
        Width = 561
        Height = 125
        ItemHeight = 35
        ItemMargins.Left = 0
        ItemMargins.Top = 0
        ItemMargins.Right = 0
        ItemMargins.Bottom = 0
        ParentColor = False
        TabOrder = 1
        OnBeforeDrawItem = lstEnvCacheBeforeDrawItem
        object lblCacheKey: TLabel
          Left = 15
          Top = 15
          Width = 3
          Height = 15
        end
        object lblCacheValue: TLabel
          Left = 350
          Top = 15
          Width = 3
          Height = 15
        end
      end
    end
    object grpButton: TGroupBox
      Left = 1
      Top = 1
      Width = 596
      Height = 30
      Align = alTop
      TabOrder = 1
      object btnACPFixed: TButton
        Left = 399
        Top = 3
        Width = 87
        Height = 25
        Caption = #20462#22797#32534#30721#35821#35328
        TabOrder = 0
        OnClick = btnACPFixedClick
      end
      object btnSystemDetection: TButton
        Left = 46
        Top = 2
        Width = 93
        Height = 25
        Caption = #26816#27979#37096#20998#29615#22659
        TabOrder = 1
        OnClick = btnSystemDetectionClick
      end
      object btnSystemFixed: TButton
        Left = 261
        Top = 3
        Width = 119
        Height = 25
        Caption = #20462#22797#37096#20998#31995#32479#29615#22659
        TabOrder = 2
        OnClick = btnSystemFixedClick
      end
      object btnResetCache: TButton
        Left = 499
        Top = 3
        Width = 75
        Height = 25
        Caption = #37325#32622#32531#23384
        TabOrder = 3
        OnClick = btnResetCacheClick
      end
      object btnExcel: TButton
        Left = 159
        Top = 3
        Width = 80
        Height = 25
        Caption = #20462#22797'Excel'
        TabOrder = 4
        OnClick = btnExcelClick
      end
    end
    object actvtyndctrCache: TActivityIndicator
      Left = 200
      Top = 246
    end
  end
end
