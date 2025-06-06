﻿(* C2PP
  ***************************************************************************

  CilTseg API client for Delphi

  Copyright 2024-2025 Patrick Prémartin under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

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
  File last update : 2025-05-24T17:30:10.891+02:00
  Signature : 0dc7e82eb47f7339157aadf5792da9c522dae0ec
  ***************************************************************************
*)

unit fMain;

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
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.Layouts;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    edtAPIServerURL: TEdit;
    edtAPISoftID: TEdit;
    edtAPISoftToken: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnSaveAPISettings: TButton;
    Panel2: TPanel;
    Label5: TLabel;
    edtLicenseNumber: TEdit;
    btnGetLicenseInfos: TButton;
    VertScrollBox1: TVertScrollBox;
    Panel3: TPanel;
    btnGetLastRelease: TButton;
    Panel4: TPanel;
    Label4: TLabel;
    edtLicenseNumber2: TEdit;
    Label6: TLabel;
    edtUserEmail: TEdit;
    Label7: TLabel;
    edtDeviceName: TEdit;
    btnActivateALicense: TButton;
    Panel5: TPanel;
    Label8: TLabel;
    edtLicenseNumber3: TEdit;
    Label9: TLabel;
    edtUserEmail2: TEdit;
    Label10: TLabel;
    edtDeviceName2: TEdit;
    edtCheckAnActivation: TButton;
    Label11: TLabel;
    edtActivationNumber: TEdit;
    procedure btnSaveAPISettingsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGetLicenseInfosClick(Sender: TObject);
    procedure btnGetLastReleaseClick(Sender: TObject);
    procedure btnActivateALicenseClick(Sender: TObject);
    procedure edtCheckAnActivationClick(Sender: TObject);
  private
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.DateUtils,
  Consts,
  Olf.RTL.Params,
  Olf.CilTseg.ClientLib,
  uGetDeviceName;

procedure TfrmMain.btnActivateALicenseClick(Sender: TObject);
var
  CilTsegAPI: TCilTsegClientLib;
  Result: TCilTsegLicenseActivation;
begin
  if edtLicenseNumber2.Text.IsEmpty then
  begin
    edtLicenseNumber2.SetFocus;
    raise Exception.Create('A license number is needed !');
  end;
  CilTsegAPI := TCilTsegClientLib.Create(edtAPIServerURL.Text,
    edtAPISoftID.Text.ToInteger, edtAPISoftToken.Text);
  try
    Result := CilTsegAPI.LicenseActivation(edtLicenseNumber2.Text,
      edtUserEmail.Text, edtDeviceName.Text);
    try
      if Result.Error then
        ShowMessage('API Error')
      else
        ShowMessage(Result.LicenseNumber + sLineBreak + Result.ActivationNumber
          + sLineBreak + DateToStr(Result.First_Activation) + sLineBreak +
          DateToStr(Result.End_Of_License) + sLineBreak +
          DateToStr(Result.End_Of_Maintenance));
      edtLicenseNumber3.Text := Result.LicenseNumber;
      edtActivationNumber.Text := Result.ActivationNumber;
    finally
      Result.free;
    end;
  finally
    CilTsegAPI.free;
  end;
end;

procedure TfrmMain.btnGetLastReleaseClick(Sender: TObject);
var
  CilTsegAPI: TCilTsegClientLib;
  Result: TCilTsegLastRelease;
  i: integer;
  s: string;
  Tab: TStringDynArray;
begin
  CilTsegAPI := TCilTsegClientLib.Create(edtAPIServerURL.Text,
    edtAPISoftID.Text.ToInteger, edtAPISoftToken.Text);
  try
    Result := CilTsegAPI.GetSoftwareLastRelease;
    try
      if Result.Error then
        ShowMessage('API Error')
      else
      begin
        Tab := Result.GetPlatforms;
        s := '';
        for i := 0 to length(Tab) - 1 do
          s := s + Tab[i] + ':' + Result.GetDownloadURL(Tab[i]) + sLineBreak;
        ShowMessage(Result.SoftwareLabel + sLineBreak + Result.SoftwareURL +
          sLineBreak + Result.ReleaseVersion + sLineBreak +
          DateToStr(Result.ReleaseDate) + sLineBreak + s);
      end;
    finally
      Result.free;
    end;
  finally
    CilTsegAPI.free;
  end;
end;

procedure TfrmMain.btnGetLicenseInfosClick(Sender: TObject);
var
  CilTsegAPI: TCilTsegClientLib;
  Result: TCilTsegLicenseInfo;
begin
  if edtLicenseNumber.Text.IsEmpty then
  begin
    edtLicenseNumber.SetFocus;
    raise Exception.Create('A license number is needed !');
  end;
  CilTsegAPI := TCilTsegClientLib.Create(edtAPIServerURL.Text,
    edtAPISoftID.Text.ToInteger, edtAPISoftToken.Text);
  try
    Result := CilTsegAPI.GetLicenseInfo(edtLicenseNumber.Text);
    try
      if Result.Error then
        ShowMessage('API Error')
      else
        ShowMessage(Result.LicenseNumber + sLineBreak +
          DateToStr(Result.First_Activation) + sLineBreak +
          DateToStr(Result.End_Of_License) + sLineBreak +
          DateToStr(Result.End_Of_Maintenance));
      edtLicenseNumber2.Text := Result.LicenseNumber;
    finally
      Result.free;
    end;
  finally
    CilTsegAPI.free;
  end;
end;

procedure TfrmMain.btnSaveAPISettingsClick(Sender: TObject);
begin
  tparams.setValue('ServerURL', edtAPIServerURL.Text);
  tparams.setValue('SoftwareID', edtAPISoftID.Text.ToInteger);
  tparams.setValue('SoftwareToken', edtAPISoftToken.Text);
  tparams.Save;
  ShowMessage('Saved');
end;

procedure TfrmMain.edtCheckAnActivationClick(Sender: TObject);
var
  CilTsegAPI: TCilTsegClientLib;
  Result: TCilTsegLicenseActivation;
begin
  if edtLicenseNumber3.Text.IsEmpty then
  begin
    edtLicenseNumber3.SetFocus;
    raise Exception.Create('A license number is needed !');
  end;
  CilTsegAPI := TCilTsegClientLib.Create(edtAPIServerURL.Text,
    edtAPISoftID.Text.ToInteger, edtAPISoftToken.Text);
  try
    Result := CilTsegAPI.CheckLicenseActivation(edtLicenseNumber3.Text,
      edtUserEmail2.Text, edtDeviceName2.Text, edtActivationNumber.Text);
    try
      if Result.Error then
        ShowMessage('API Error')
      else
        ShowMessage(Result.LicenseNumber + sLineBreak +
          Result.ActivationNumber);
    finally
      Result.free;
    end;
  finally
    CilTsegAPI.free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  edtAPIServerURL.Text := tparams.getValue('ServerURL', CServerAPI);
  edtAPISoftID.Text := tparams.getValue('SoftwareID', CSoftwareID).ToString;
  edtAPISoftToken.Text := tparams.getValue('SoftwareToken', CSoftwareToken);
  //
  edtDeviceName.Text := getDeviceName;
  edtDeviceName2.Text := getDeviceName;
end;

initialization

tparams.InitDefaultFileNameV2('CilTsegDemoProject', 'DemoProject');
tparams.Load;

{$IFDEF DEBUG}
ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
