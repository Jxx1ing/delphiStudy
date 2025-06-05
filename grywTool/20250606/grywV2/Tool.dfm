object ToolForm: TToolForm
  Left = 0
  Top = 0
  Caption = 'gryw'
  ClientHeight = 437
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pgcTool: TPageControl
    Left = 0
    Top = 0
    Width = 608
    Height = 437
    ActivePage = tsNet
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 24
    ExplicitTop = 8
    object tsAntiVirus: TTabSheet
      Caption = #26432#27602#26816#27979
    end
    object tsEncrytion: TTabSheet
      Caption = #21152#23494#26816#27979
      ImageIndex = 1
    end
    object tsNet: TTabSheet
      Caption = #32593#32476#26816#27979
      ImageIndex = 2
    end
    object tsEnvConfig: TTabSheet
      Caption = #29615#22659#26816#27979
      ImageIndex = 3
    end
  end
end
