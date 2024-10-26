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
/// File last update : 2024-10-26T21:13:24.000+02:00
/// Signature : 6dba1f157ad5d7922719707d436570198e4b9636
/// ***************************************************************************
/// </summary>

unit uConfig;

interface

type
  TConfig = class
  private
    FLicenseEmail: string;
    FLicenseDeviceName: string;
    FLicenseActivationNumber: string;
    FLicenseNumber: string;
    procedure SetLicenseActivationNumber(const Value: string);
    procedure SetLicenseDeviceName(const Value: string);
    procedure SetLicenseEmail(const Value: string);
    procedure SetLicenseNumber(const Value: string);
  protected
  public
    /// <summary>
    /// License number, given by the user with its email address when registering the software
    /// </summary>
    property LicenseNumber: string read FLicenseNumber write SetLicenseNumber;
    /// <summary>
    /// User email, given by the user with its license number when registering the software
    /// </summary>
    property LicenseEmail: string read FLicenseEmail write SetLicenseEmail;
    /// <summary>
    /// Activatio number, given by the server if the license has been activated
    /// </summary>
    property LicenseActivationNumber: string read FLicenseActivationNumber
      write SetLicenseActivationNumber;
    /// <summary>
    /// Not supposed to be stored, a unique (or not) name for this device, to associate with this license activation and check sometimes to verify the license has not been copied on an other computer
    /// (you can use the device name, the ID of the computer or its hard drive, ...)
    /// </summary>
    property LicenseDeviceName: string read FLicenseDeviceName
      write SetLicenseDeviceName;
    /// <summary>
    /// Returns the singleton instance of this configuration
    /// </summary>
    class function Current: TConfig;
    constructor Create;
    procedure Load;
    procedure Save;
  end;

implementation

uses
  System.IOUtils,
  System.IniFiles,
  uGetDeviceName;

var
  Config: TConfig;

  { TConfig }

constructor TConfig.Create;
begin
  inherited;
  FLicenseEmail := '';
  FLicenseDeviceName := getDeviceName;
  FLicenseActivationNumber := '';
  FLicenseNumber := '';
end;

class function TConfig.Current: TConfig;
begin
  if not assigned(Config) then
  begin
    Config := TConfig.Create;
    Config.Load;
  end;
  result := Config;
end;

procedure TConfig.Load;
var
  ini: TIniFile;
  section: string;
begin
  // use a more secured way to store licenses data
  if tfile.Exists(tpath.Combine(tpath.GetDocumentsPath, 'CilTsegSamples.lic'))
  then
  begin
    ini := TIniFile.Create(tpath.Combine(tpath.GetDocumentsPath,
      'CilTsegSamples.lic'));
    try
      section := '[' + tpath.GetFileNameWithoutExtension(paramstr(0)) + ']';
      FLicenseEmail := ini.ReadString(section, 'le', '');
      FLicenseDeviceName := ini.ReadString(section, 'ldn', getDeviceName);
      FLicenseActivationNumber := ini.ReadString(section, 'lan', '');
      FLicenseNumber := ini.ReadString(section, 'ln', '');
    finally
      ini.free;
    end;
  end;
end;

procedure TConfig.Save;
var
  ini: TIniFile;
  section: string;
begin
  // use a more secured way to store licenses data
  ini := TIniFile.Create(tpath.Combine(tpath.GetDocumentsPath,
    'CilTsegSamples.lic'));
  try
    section := '[' + tpath.GetFileNameWithoutExtension(paramstr(0)) + ']';
    ini.WriteString(section, 'le', FLicenseEmail);
    ini.WriteString(section, 'ldn', FLicenseDeviceName);
    ini.WriteString(section, 'lan', FLicenseActivationNumber);
    ini.WriteString(section, 'ln', FLicenseNumber);
  finally
    ini.free;
  end;
end;

procedure TConfig.SetLicenseActivationNumber(const Value: string);
begin
  FLicenseActivationNumber := Value;
end;

procedure TConfig.SetLicenseDeviceName(const Value: string);
begin
  FLicenseDeviceName := Value;
end;

procedure TConfig.SetLicenseEmail(const Value: string);
begin
  FLicenseEmail := Value;
end;

procedure TConfig.SetLicenseNumber(const Value: string);
begin
  FLicenseNumber := Value;
end;

initialization

Config := nil;

finalization

Config.free;

end.
