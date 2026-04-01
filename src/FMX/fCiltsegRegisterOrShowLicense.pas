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
  Signature : f10c39fe85e75ade7dc49b6161ccfb2217be3e5e
  ***************************************************************************
*)

unit fCiltsegRegisterOrShowLicense;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Edit;

type
  /// <summary>
  /// CilTseg license management default dialog box for your FireMonkey projects
  /// </summary>
  TfrmCilTsegRegisterOrShowLicense = class(TForm)
    pnlRegisterLicense: TLayout;
    pnlShowLicenseDetails: TLayout;
    lblShow: TLabel;
    btnClose: TButton;
    lblUserEmail: TLabel;
    edtUserEmail: TEdit;
    lblLicenseNumber: TLabel;
    edtLicenseNumber: TEdit;
    btnBuy: TButton;
    btnRegister: TButton;
    btnCancel: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnBuyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

{$R *.fmx}

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
{$IF Defined(IOS) or Defined(ANDROID)}
    try
      f.Show;
      Result := true;
    finally
    end;
{$ELSE}
    try
      f.ShowModal;
      Result := true;
    finally
      f.free;
    end;
{$ENDIF}
  except
    Result := false;
  end;
end;

procedure TfrmCilTsegRegisterOrShowLicense.FormClose(Sender: TObject;
var Action: TCloseAction);
begin
{$IF Defined(IOS) or Defined(Android)}
  tthread.ForceQueue(nil,
    procedure
    begin
      Self.free;
    end);
{$ENDIF}
end;

procedure TfrmCilTsegRegisterOrShowLicense.FormCreate(Sender: TObject);
begin
  pnlRegisterLicense.Visible := tconfig.Current.LicenseNumber.IsEmpty or
    tconfig.Current.LicenseActivationNumber.IsEmpty;
  pnlShowLicenseDetails.Visible := not pnlRegisterLicense.Visible;

{$IFDEF MSWINDOWS}
  // Sur Windows c'est exécuté une fois la fenêtre ouverte.
  // Sur Mac c'est exécuté après fermeture de la fenêtre et provoquait une violation d'accès d'où l'ajout de Assigned()
  if pnlRegisterLicense.Visible then
    tthread.ForceQueue(nil,
      procedure
      begin
        if assigned(edtUserEmail) then
          edtUserEmail.SetFocus;
      end);
{$ENDIF}
  if pnlShowLicenseDetails.Visible then
  begin
    lblShow.Text := 'The software has been registered on this computer by ' +
      tconfig.Current.LicenseEmail + '.';
{$IFDEF MSWINDOWS}
    // Sur Windows c'est exécuté une fois la fenêtre ouverte.
    // Sur Mac c'est exécuté après fermeture de la fenêtre et provoquait une violation d'accès d'où l'ajout de Assigned()
    tthread.ForceQueue(nil,
      procedure
      begin
        if assigned(btnClose) then
          btnClose.SetFocus;
      end);
{$ENDIF}
  end;
end;

initialization

TfrmCilTsegRegisterOrShowLicense.HasInstance := 0;

end.
