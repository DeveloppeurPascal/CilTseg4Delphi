object frmCilTsegRegisterOrShowLicense: TfrmCilTsegRegisterOrShowLicense
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'License registration'
  ClientHeight = 144
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlShowLicenseDetails: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 144
    Align = alClient
    TabOrder = 1
    Visible = False
    DesignSize = (
      624
      144)
    object lblShow: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 616
      Height = 15
      Align = alTop
      Caption = 'xxx'
      ExplicitWidth = 18
    end
    object btnClose: TButton
      Left = 536
      Top = 111
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Close'
      Default = True
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object pnlRegisterLicense: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 144
    Align = alClient
    TabOrder = 0
    DesignSize = (
      624
      144)
    object edtLicenseNumber: TLabeledEdit
      AlignWithMargins = True
      Left = 4
      Top = 77
      Width = 616
      Height = 23
      Margins.Top = 25
      Align = alTop
      EditLabel.Width = 108
      EditLabel.Height = 15
      EditLabel.Caption = 'Your license number'
      TabOrder = 1
      Text = ''
    end
    object edtUserEmail: TLabeledEdit
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 616
      Height = 23
      Margins.Top = 25
      Align = alTop
      EditLabel.Width = 56
      EditLabel.Height = 15
      EditLabel.Caption = 'Your email'
      TabOrder = 0
      Text = ''
    end
    object btnCancel: TButton
      Left = 536
      Top = 111
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      Default = True
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object btnBuy: TButton
      Left = 360
      Top = 111
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Buy'
      TabOrder = 3
      OnClick = btnBuyClick
    end
    object btnRegister: TButton
      Left = 448
      Top = 111
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Register'
      TabOrder = 4
      OnClick = btnRegisterClick
    end
  end
end
