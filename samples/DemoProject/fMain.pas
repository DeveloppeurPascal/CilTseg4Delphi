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
  if edtLicenseNumber.Text.IsEmpty then
  begin
    edtLicenseNumber.SetFocus;
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
        ShowMessage(Result.LicenseNumber + sLineBreak +
          Result.ActivationNumber);
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
          s := Tab[i] + ':' + Result.GetDownloadURL(Tab[i]) + sLineBreak;
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
        ShowMessage(Result.LicenseNumber + sLineBreak + DateToStr(Result.Date));
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
  if edtLicenseNumber.Text.IsEmpty then
  begin
    edtLicenseNumber.SetFocus;
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
