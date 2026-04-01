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
  File last update : 2025-05-25T16:19:26.038+02:00
  Signature : b7f690d5061b4c9279956c6ce597e706e85f12e6
  ***************************************************************************
*)

unit fMain;

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
  Vcl.Menus;

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
    procedure FormShow(Sender: TObject);
    procedure mnuRegisterTheLicenseClick(Sender: TObject);
    procedure mnuBuyALicenseClick(Sender: TObject);
    procedure mnuSearchNewReleaseClick(Sender: TObject);
  private
  public
    procedure ShowCilTsegRegistrationForm;
    procedure CheckAndAskTheLicense;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  System.UITypes,
  uConfig,
  fCiltsegRegisterOrShowLicense,
  Olf.CilTseg.ClientLib,
  u_urlOpen,
  uConsts,
  System.Types,
  System.DateUtils;

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
            DownloadURL := result.GetDownloadURL(Tab[i]);
            break;
          end;
        if DownloadURL.IsEmpty or (CurReleaseDate >= Result.ReleaseDate) then
          ShowMessage('No new release available.')
        else if mryes = MessageDlg
          ('A new release is available, do you want to download it ?',
          TMsgDlgType.mtConfirmation, mbYesNo, 0, mbyes) then
          url_Open_In_Browser(DownloadURL);
      end;
    finally
      Result.free;
    end;
  finally
    CilTsegAPI.free;
  end;
end;

procedure TfrmMain.ShowCilTsegRegistrationForm;
begin
  if TfrmCilTsegRegisterOrShowLicense.Execute(self) then
    CheckAndAskTheLicense;
end;

end.
