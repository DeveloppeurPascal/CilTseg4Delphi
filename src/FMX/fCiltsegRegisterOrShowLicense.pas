/// <summary>
/// ***************************************************************************
///
/// CliTseg API client for Delphi
///
/// Copyright 2024-2025 Patrick Prémartin under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Client units and samples for the Ciltseg API to manage and use licenses
/// keys in your Delphi project.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://ciltseg.olfsoftware.fr/
///
/// Project site :
/// https://github.com/DeveloppeurPascal/CilTseg4Delphi
///
/// ***************************************************************************
/// File last update : 2025-01-17T18:52:54.000+01:00
/// Signature : 104786779ce446bcd98bed1c97bb698b729feaf7
/// ***************************************************************************
/// </summary>

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
  private
    class var HasInstance: byte;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
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
    lblShow.Text := 'The software has been registered on this computer by ' +
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
