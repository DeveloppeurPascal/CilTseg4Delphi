/// <summary>
/// ***************************************************************************
///
/// CliTseg API client for Delphi
///
/// Copyright 2024 Patrick Prémartin under AGPL 3.0 license.
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
/// File last update : 2024-10-29T19:54:30.000+01:00
/// Signature : 66b13e58ad885146e4b4cf1b5db1ea142abd7bfa
/// ***************************************************************************
/// </summary>

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
  FMX.Menus;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    mnuQuit: TMenuItem;
    Aide1: TMenuItem;
    mnuSearchNewRelease: TMenuItem;
    mnuRegisterTheLicense: TMenuItem;
    mnuBuyALicense: TMenuItem;
    procedure mnuQuitClick(Sender: TObject);
    procedure mnuSearchNewReleaseClick(Sender: TObject);
    procedure mnuRegisterTheLicenseClick(Sender: TObject);
    procedure mnuBuyALicenseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
    procedure ShowCilTsegRegistrationForm;
    procedure CheckAndAskTheLicense;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  uConfig,
  fCiltsegRegisterOrShowLicense,
  Olf.CilTseg.ClientLib,
  u_urlOpen,
  uConsts,
  System.DateUtils,
  FMX.DialogService;

procedure TfrmMain.CheckAndAskTheLicense;
begin
  if tconfig.Current.LicenseNumber.IsEmpty or
    tconfig.Current.LicenseActivationNumber.IsEmpty then
    tthread.CreateAnonymousThread(
      procedure
      begin
        sleep(2000);
        tthread.queue(nil,
          procedure
          begin
            ShowCilTsegRegistrationForm;
          end);
      end).Start;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  CheckAndAskTheLicense;
end;

procedure TfrmMain.mnuBuyALicenseClick(Sender: TObject);
begin
  url_Open_In_Browser(CSoftwareBuyURL);
end;

procedure TfrmMain.mnuQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.mnuRegisterTheLicenseClick(Sender: TObject);
begin
  ShowCilTsegRegistrationForm;
end;

procedure TfrmMain.mnuSearchNewReleaseClick(Sender: TObject);
var
  CilTsegAPI: TCilTsegClientLib;
  Result: TCilTsegLastRelease;
  i: integer;
  s: string;
  Tab: TStringDynArray;
  CurPlatform: string;
  CurReleaseDate: TDate;
  DownloadURL: string;
begin
  CilTsegAPI := TCilTsegClientLib.Create(CCiltsegServerURL, CCiltsegSoftwareID,
    CCiltsegSoftwareToken);
  try
    Result := CilTsegAPI.GetSoftwareLastRelease;
    try
      if Result.Error then
        ShowMessage('A technical problem prevents us from checking whether a ' +
          'new version of the program is available. Please try again later or '
          + 'contact the support if the problem persists.')
      else
      begin
        CurReleaseDate := ISO8601ToDate(CVersionDate);
        CurPlatform := CSoftwareCurrentPlatform.ToLower;
        DownloadURL := '';
        Tab := Result.GetPlatforms;
        s := '';
        for i := 0 to length(Tab) - 1 do
          if Tab[i].ToLower = CurPlatform then
          begin
            DownloadURL := Tab[i];
            break;
          end;
        if DownloadURL.IsEmpty then
          ShowMessage('No new release available.')
        else
          TDialogService.MessageDialog
            ('A new release is available, do you want to download it ?',
            TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbYes, 0,
            procedure(const AModalResult: TModalResult)
            begin
              if AModalResult = mrYes then
                url_Open_In_Browser(DownloadURL);
            end);
      end;
    finally
      Result.free;
    end;
  finally
    CilTsegAPI.free;
  end;
end;

procedure TfrmMain.ShowCilTsegRegistrationForm;
var
  f: TfrmCilTsegRegisterOrShowLicense;
begin
  f := TfrmCilTsegRegisterOrShowLicense.Create(self);
  try
    f.ShowModal;
  finally
    f.free;
  end;
  CheckAndAskTheLicense;
end;

end.
