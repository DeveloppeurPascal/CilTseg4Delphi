(* C2PP
  ***************************************************************************

  CilTseg API client for Delphi
  Copyright (c) 2024-2026 Patrick PREMARTIN

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as
  published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.

  ***************************************************************************

  Client units and samples for the Ciltseg API to manage and use licenses
  keys in your Delphi project.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://ciltseg.olfsoftware.fr/

  Project site :
  https://github.com/DeveloppeurPascal/CilTseg4Delphi

  ***************************************************************************
  File last update : 2025-05-25T16:19:26.083+02:00
  Signature : 05057b4500b32c57df0681b4085d3ce53218d0a1
  ***************************************************************************
*)

unit fCiltsegRegisterOrShowLicense;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Mask;

type
  /// <summary>
  /// CilTseg license management default dialog box for your VCL projects
  /// </summary>
  TfrmCilTsegRegisterOrShowLicense = class(TForm)
    pnlRegisterLicense: TPanel;
    pnlShowLicenseDetails: TPanel;
    lblShow: TLabel;
    btnClose: TButton;
    edtUserEmail: TLabeledEdit;
    edtLicenseNumber: TLabeledEdit;
    btnCancel: TButton;
    btnBuy: TButton;
    btnRegister: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnBuyClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
  private
    class var HasInstance: byte;
  protected
  public
    /// <summary>
    /// Constructor of this class. It's better to call the Execute() method
    /// then Create() but it depends on what you want to personalize.
    /// </summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>
    /// Destructor for this class. Call ".Free()" or "FreeAndNil()" on your
    /// instance.
    /// </summary>
    destructor Destroy; override;
    /// <summary>
    /// Open an instance of this dialog box as a modal form and manage the
    /// license registration process for you.
    /// </summary>
    class function Execute(AOwner: TComponent): boolean;
  end;

implementation

{$R *.dfm}

uses
  Olf.CilTseg.ClientLib,
  u_urlOpen,
  uConfig,
  uConsts;

procedure TfrmCilTsegRegisterOrShowLicense.btnBuyClick(Sender: TObject);
begin
  url_Open_In_Browser(CSoftwareBuyURL);
end;

procedure TfrmCilTsegRegisterOrShowLicense.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCilTsegRegisterOrShowLicense.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCilTsegRegisterOrShowLicense.btnRegisterClick(Sender: TObject);
var
  CilTsegAPI: TCilTsegClientLib;
  Result: TCilTsegLicenseActivation;
begin
  edtUserEmail.Text := string(edtUserEmail.Text).Trim.ToLower;
  if string(edtUserEmail.Text).IsEmpty then
  begin
    edtUserEmail.SetFocus;
    raise Exception.Create('Your email address is needed.');
  end;

  edtLicenseNumber.Text := string(edtLicenseNumber.Text).Trim.ToUpper;
  if string(edtLicenseNumber.Text).IsEmpty then
  begin
    edtLicenseNumber.SetFocus;
    raise Exception.Create('Your license number is needed.');
  end;

  CilTsegAPI := TCilTsegClientLib.Create(CCiltsegServerURL, CCiltsegSoftwareID,
    CCiltsegSoftwareToken);
  try
    Result := CilTsegAPI.LicenseActivation(edtLicenseNumber.Text,
      edtUserEmail.Text, tconfig.Current.LicenseDeviceName);
    try
      if Result.Error or (Result.LicenseNumber <> edtLicenseNumber.Text) or
        Result.ActivationNumber.IsEmpty then
        ShowMessage
          ('We can''t activate your license for now, please try later or contact the support.')
      else
      begin
        tconfig.Current.LicenseNumber := Result.LicenseNumber;
        tconfig.Current.LicenseEmail := edtUserEmail.Text;
        tconfig.Current.LicenseActivationNumber := Result.ActivationNumber;
        tconfig.Current.save;
        ShowMessage('Your license has been registered.');
        tthread.Queue(nil,
          procedure
          begin
            Close;
          end);
      end;
    finally
      Result.free;
    end;
  finally
    CilTsegAPI.free;
  end;
end;

constructor TfrmCilTsegRegisterOrShowLicense.Create(AOwner: TComponent);
begin
  inc(HasInstance);
  if (HasInstance > 1) then
{$IFDEF DEBUG}
    raise Exception.Create
      ('Use previous instance of this form, don''t create a new one.');
{$ELSE}
    abort;
{$ENDIF}
  inherited;
end;

destructor TfrmCilTsegRegisterOrShowLicense.Destroy;
begin
  inherited;
  dec(HasInstance);
end;

class function TfrmCilTsegRegisterOrShowLicense.Execute
  (AOwner: TComponent): boolean;
var
  f: TfrmCilTsegRegisterOrShowLicense;
begin
  f := TfrmCilTsegRegisterOrShowLicense.Create(AOwner);
  try
    try
      f.ShowModal;
      Result := true;
    finally
      f.free;
    end;
  except
    Result := false;
  end;
end;

procedure TfrmCilTsegRegisterOrShowLicense.FormCreate(Sender: TObject);
begin
  pnlRegisterLicense.Visible := tconfig.Current.LicenseNumber.IsEmpty or
    tconfig.Current.LicenseActivationNumber.IsEmpty;
  pnlShowLicenseDetails.Visible := not pnlRegisterLicense.Visible;

  if pnlRegisterLicense.Visible then
    tthread.forcequeue(nil,
      procedure
      begin
        edtUserEmail.SetFocus;
      end);

  if pnlShowLicenseDetails.Visible then
  begin
    lblShow.Caption := 'The software has been registered on this computer by ' +
      tconfig.Current.LicenseEmail + '.';
    tthread.forcequeue(nil,
      procedure
      begin
        btnClose.SetFocus;
      end);
  end;
end;

initialization

TfrmCilTsegRegisterOrShowLicense.HasInstance := 0;

end.
