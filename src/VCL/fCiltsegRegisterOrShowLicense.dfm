object frmCilTsegRegisterOrShowLicense: TfrmCilTsegRegisterOrShowLicense
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'License registration'
  ClientHeight = 141
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlRegisterLicense: TPanel
    Left = 0
    Top = 0
    Width = 384
    Height = 141
    Align = alClient
    TabOrder = 0
    Visible = False
    ExplicitWidth = 624
    ExplicitHeight = 144
    DesignSize = (
      384
      141)
    object edtLicenseNumber: TLabeledEdit
      AlignWithMargins = True
      Left = 4
      Top = 77
      Width = 376
      Height = 23
      Margins.Top = 25
      Align = alTop
      EditLabel.Width = 108
      EditLabel.Height = 15
      EditLabel.Caption = 'Your license number'
      TabOrder = 1
      Text = ''
      ExplicitWidth = 616
    end
    object edtUserEmail: TLabeledEdit
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 376
      Height = 23
      Margins.Top = 25
      Align = alTop
      EditLabel.Width = 56
      EditLabel.Height = 15
      EditLabel.Caption = 'Your email'
      TabOrder = 0
      Text = ''
      ExplicitWidth = 616
    end
    object btnCancel: TButton
      Left = 296
      Top = 108
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      Default = True
      TabOrder = 4
      OnClick = btnCancelClick
      ExplicitLeft = 536
      ExplicitTop = 111
    end
    object btnBuy: TButton
      Left = 208
      Top = 108
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Buy'
      TabOrder = 3
      OnClick = btnBuyClick
    end
    object btnRegister: TButton
      Left = 120
      Top = 108
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Register'
      TabOrder = 2
      OnClick = btnRegisterClick
    end
  end
  object pnlShowLicenseDetails: TPanel
    Left = 0
    Top = 0
    Width = 384
    Height = 141
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 624
    ExplicitHeight = 144
    DesignSize = (
      384
      141)
    object lblShow: TLabel
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 362
      Height = 15
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Caption = 'xxx'
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitWidth = 18
    end
    object btnClose: TButton
      Left = 296
      Top = 108
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
      ExplicitLeft = 536
      ExplicitTop = 111
    end
  end
end
