object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'VCL Demo Project'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object MainMenu1: TMainMenu
    Left = 304
    Top = 224
    object Fichier1: TMenuItem
      Caption = 'Fichier'
      object mnuQuit: TMenuItem
        Caption = 'Quitter'
        OnClick = mnuQuitClick
      end
    end
    object Aide1: TMenuItem
      Caption = 'Aide'
      object mnuSearchNewRelease: TMenuItem
        Caption = 'Mettre '#224' jour ce logiciel'
        OnClick = mnuSearchNewReleaseClick
      end
      object mnuRegisterTheLicense: TMenuItem
        Caption = 'Enregistrer le logiciel'
        OnClick = mnuRegisterTheLicenseClick
      end
      object mnuBuyALicense: TMenuItem
        Caption = 'Acheter une licence'
        OnClick = mnuBuyALicenseClick
      end
    end
  end
end
