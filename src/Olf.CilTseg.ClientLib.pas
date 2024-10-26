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
/// File last update : 2024-10-26T19:00:28.000+02:00
/// Signature : e100cc7484337b1c297a9b119655a4392967fbf5
/// ***************************************************************************
/// </summary>

unit Olf.CilTseg.ClientLib;

interface

uses
  System.Types,
  System.Generics.Collections;

type
  TCilTsegData = class
  private
    FError: boolean;
    procedure SetError(const Value: boolean);
  protected
  public
    property Error: boolean read FError write SetError;
    constructor Create; virtual;
  end;

  TCilTsegLicenseInfo = class(TCilTsegData)
  private
    FDate: TDate;
    FLicenseNumber: string;
    procedure SetDate(const Value: TDate);
    procedure SetLicenseNumber(const Value: string);
  protected
  public
    property LicenseNumber: string read FLicenseNumber write SetLicenseNumber;
    property Date: TDate read FDate write SetDate;
    constructor Create; override;
  end;

  TCilTsegLastRelease = class(TCilTsegData)
  private
    FReleaseVersion: string;
    FSoftwareURL: string;
    FReleaseDate: TDate;
    FSoftwareLabel: string;
    procedure SetReleaseDate(const Value: TDate);
    procedure SetReleaseVersion(const Value: string);
    procedure SetSoftwareLabel(const Value: string);
    procedure SetSoftwareURL(const Value: string);
  protected type
    TPlatforms = TDictionary<string, string>;

  var
    FPlatforms: TPlatforms;
  public
    property SoftwareLabel: string read FSoftwareLabel write SetSoftwareLabel;
    property SoftwareURL: string read FSoftwareURL write SetSoftwareURL;
    property ReleaseVersion: string read FReleaseVersion
      write SetReleaseVersion;
    property ReleaseDate: TDate read FReleaseDate write SetReleaseDate;
    function GetPlatforms: TStringDynArray;
    function GetDownloadURL(const APlatform: string): string;
    procedure AddPlatform(const APlatform, ADownloadURL: string);
    constructor Create; Override;
    destructor Destroy; override;
  end;

  TCilTsegLicenseActivation = class(TCilTsegData)
  private
    FActivationNumber: string;
    FLicenseNumber: string;
    procedure SetActivationNumber(const Value: string);
    procedure SetLicenseNumber(const Value: string);
  protected
  public
    property LicenseNumber: string read FLicenseNumber write SetLicenseNumber;
    property ActivationNumber: string read FActivationNumber
      write SetActivationNumber;
    constructor Create; override;
  end;

  TCilTsegClientLib = class
  private
    FSoftwareToken: string;
    FServerURL: string;
    FSoftwareID: integer;
    procedure SetServerURL(const Value: string);
    procedure SetSoftwareID(const Value: integer);
    procedure SetSoftwareToken(const Value: string);
  protected
    procedure CheckSettings;
  public
    property ServerURL: string read FServerURL write SetServerURL;
    property SoftwareID: integer read FSoftwareID write SetSoftwareID;
    property SoftwareToken: string read FSoftwareToken write SetSoftwareToken;
    constructor Create(const AServerURL: string; const ASoftwareID: integer;
      const ASoftwareToken: string);
    function GetLicenseInfo(const ALicenseNumber: string): TCilTsegLicenseInfo;
    function GetSoftwareLastRelease: TCilTsegLastRelease;
    function LicenseActivation(const ALicenseNumber, AUserEmail,
      ADeviceName: string): TCilTsegLicenseActivation;
    function CheckLicenseActivation(const ALicenseNumber, AUserEmail,
      ADeviceName, AActivationNumber: string): TCilTsegLicenseActivation;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Net.HttpClient,
  System.DateUtils,
  Olf.RTL.Checksum;

// Get Olf.RTL.Checksum unit from https://github.com/DeveloppeurPascal/librairies/src/Olf.RTL.Checksum.pas

{ TCilTsegData }

constructor TCilTsegData.Create;
begin
  inherited;
  FError := true;
end;

procedure TCilTsegData.SetError(const Value: boolean);
begin
  FError := Value;
end;

{ TCilTsegLicenseInfo }

constructor TCilTsegLicenseInfo.Create;
begin
  inherited;
  FDate := now;
  FLicenseNumber := '';
end;

procedure TCilTsegLicenseInfo.SetDate(const Value: TDate);
begin
  FDate := Value;
end;

procedure TCilTsegLicenseInfo.SetLicenseNumber(const Value: string);
begin
  FLicenseNumber := Value;
end;

{ TCilTsegLastRelease }

procedure TCilTsegLastRelease.AddPlatform(const APlatform,
  ADownloadURL: string);
begin
  FPlatforms.Add(APlatform, ADownloadURL);
end;

constructor TCilTsegLastRelease.Create;
begin
  inherited;
  FSoftwareLabel := '';
  FSoftwareURL := '';
  FReleaseVersion := '';
  FReleaseDate := now;
  FPlatforms := TPlatforms.Create;
end;

destructor TCilTsegLastRelease.Destroy;
begin
  FPlatforms.Free;
  inherited;
end;

function TCilTsegLastRelease.GetDownloadURL(const APlatform: string): string;
begin
  if not FPlatforms.TryGetValue(APlatform, result) then
    result := '';
    // TODO : ajouter une recherche case insensitive
end;

function TCilTsegLastRelease.GetPlatforms: TStringDynArray;
var
  i: integer;
  s: string;
begin
  setlength(result, FPlatforms.Keys.Count);
  i := 0;
  for s in FPlatforms.Keys do
  begin
    result[i] := s;
    inc(i);
  end;
end;

procedure TCilTsegLastRelease.SetReleaseDate(const Value: TDate);
begin
  FReleaseDate := Value;
end;

procedure TCilTsegLastRelease.SetReleaseVersion(const Value: string);
begin
  FReleaseVersion := Value;
end;

procedure TCilTsegLastRelease.SetSoftwareLabel(const Value: string);
begin
  FSoftwareLabel := Value;
end;

procedure TCilTsegLastRelease.SetSoftwareURL(const Value: string);
begin
  FSoftwareURL := Value;
end;

{ TCilTsegLicenseActivation }

constructor TCilTsegLicenseActivation.Create;
begin
  inherited;
  FLicenseNumber := '';
  FActivationNumber := '';
end;

procedure TCilTsegLicenseActivation.SetActivationNumber(const Value: string);
begin
  FActivationNumber := Value;
end;

procedure TCilTsegLicenseActivation.SetLicenseNumber(const Value: string);
begin
  FLicenseNumber := Value;
end;

{ TCilTsegClientLib }

function TCilTsegClientLib.CheckLicenseActivation(const ALicenseNumber,
  AUserEmail, ADeviceName, AActivationNumber: string)
  : TCilTsegLicenseActivation;
var
  Server: THTTPClient;
  Response: IHTTPResponse;
  jso: TJSONObject;
  b: boolean;
  s: string;
  Params: TStringList;
  LLicenseNumber, LUserEmail: string;
begin
  LLicenseNumber := ALicenseNumber.ToUpper;
  LUserEmail := AUserEmail.ToLower;
  CheckSettings;
  result := TCilTsegLicenseActivation.Create;
  Server := THTTPClient.Create;
  try
    Params := TStringList.Create;
    try
      Params.AddPair('c', SoftwareID.ToString);
      Params.AddPair('n', LLicenseNumber);
      Params.AddPair('e', LUserEmail);
      Params.AddPair('a', ADeviceName);
      Params.AddPair('d', AActivationNumber);
      Params.AddPair('v', TOlfChecksumVerif.Get(FSoftwareToken,
        FSoftwareID.ToString, LLicenseNumber, LUserEmail, ADeviceName,
        AActivationNumber));
      Response := Server.Post(FServerURL + '/api-activation-check.php', Params);
    finally
      Params.Free;
    end;
    if Response.StatusCode = 200 then
    begin
      jso := TJSONObject.ParseJSONValue(Response.ContentAsString(tencoding.UTF8)
        ) as TJSONObject;
      try
        if jso.TryGetValue<boolean>('error', b) then
          result.Error := b;
        if not result.Error then
        begin
          if jso.TryGetValue<string>('license', s) then
            result.LicenseNumber := s;
          if jso.TryGetValue<string>('activation', s) then
            result.ActivationNumber := s;
        end;
      finally
        jso.Free;
      end;
    end;
  finally
    Server.Free;
  end;
end;

procedure TCilTsegClientLib.CheckSettings;
begin
  if FServerURL.IsEmpty then
    raise exception.Create('The server API URL is needed !');
  if (FSoftwareID < 1) then
    raise exception.Create('The software ID is needed !');
  if FServerURL.IsEmpty then
    raise exception.Create('The software private token is needed !');
end;

constructor TCilTsegClientLib.Create(const AServerURL: string;
  const ASoftwareID: integer; const ASoftwareToken: string);
begin
  inherited Create;
  FServerURL := AServerURL;
  FSoftwareID := ASoftwareID;
  FSoftwareToken := ASoftwareToken;
  CheckSettings;
end;

function TCilTsegClientLib.GetLicenseInfo(const ALicenseNumber: string)
  : TCilTsegLicenseInfo;
var
  Server: THTTPClient;
  Response: IHTTPResponse;
  jso: TJSONObject;
  b: boolean;
  s: string;
  Params: TStringList;
  LLicenseNumber: string;
begin
  LLicenseNumber := ALicenseNumber.ToUpper;
  CheckSettings;
  result := TCilTsegLicenseInfo.Create;
  Server := THTTPClient.Create;
  try
    Params := TStringList.Create;
    try
      Params.AddPair('c', SoftwareID.ToString);
      Params.AddPair('n', LLicenseNumber);
      Params.AddPair('v', TOlfChecksumVerif.Get(FSoftwareToken,
        FSoftwareID.ToString, LLicenseNumber));
      Response := Server.Post(FServerURL + '/api-license-get.php', Params);
    finally
      Params.Free;
    end;
    if Response.StatusCode = 200 then
    begin
      jso := TJSONObject.ParseJSONValue(Response.ContentAsString(tencoding.UTF8)
        ) as TJSONObject;
      try
        if jso.TryGetValue<boolean>('error', b) then
          result.Error := b;
        if not result.Error then
        begin
          if jso.TryGetValue<string>('license', s) then
            result.LicenseNumber := s;
          if jso.TryGetValue<string>('date', s) then
            result.Date := ISO8601ToDate(s);
        end;
      finally
        jso.Free;
      end;
    end;
  finally
    Server.Free;
  end;
end;

function TCilTsegClientLib.GetSoftwareLastRelease: TCilTsegLastRelease;
var
  Server: THTTPClient;
  Response: IHTTPResponse;
  jso: TJSONObject;
  jsa1, jsa2: TJSONArray;
  i: integer;
  b: boolean;
  s1, s2: string;
begin
  CheckSettings;
  result := TCilTsegLastRelease.Create;
  Server := THTTPClient.Create;
  try
    Response := Server.Get(FServerURL + '/api-software-lastrelease.php?c=' +
      FSoftwareID.ToString + '&v=' + TOlfChecksumVerif.Get(FSoftwareToken,
      FSoftwareID.ToString));
    if Response.StatusCode = 200 then
    begin
      jso := TJSONObject.ParseJSONValue(Response.ContentAsString(tencoding.UTF8)
        ) as TJSONObject;
      try
        if jso.TryGetValue<boolean>('error', b) then
          result.Error := b;
        if not result.Error then
        begin
          if jso.TryGetValue<string>('label', s1) then
            result.SoftwareLabel := s1;
          if jso.TryGetValue<string>('url', s1) then
            result.SoftwareURL := s1;
          if jso.TryGetValue<TJSONArray>('releases', jsa1) and (jsa1.Count = 1)
          then
          begin
            if jsa1[0].TryGetValue<string>('version', s1) then
              result.ReleaseVersion := s1;
            if jsa1[0].TryGetValue<string>('date', s1) then
              result.ReleaseDate := ISO8601ToDate(s1);
            if jsa1[0].TryGetValue<TJSONArray>('platforms', jsa2) then
              for i := 0 to jsa2.Count - 1 do
                if jsa2[i].TryGetValue<string>('label', s1) and
                  jsa2[i].TryGetValue<string>('url', s2) then
                  result.AddPlatform(s1, s2);
          end;
        end;
      finally
        jso.Free;
      end;
    end;
  finally
    Server.Free;
  end;
end;

function TCilTsegClientLib.LicenseActivation(const ALicenseNumber, AUserEmail,
  ADeviceName: string): TCilTsegLicenseActivation;
var
  Server: THTTPClient;
  Response: IHTTPResponse;
  jso: TJSONObject;
  b: boolean;
  s: string;
  Params: TStringList;
  LLicenseNumber, LUserEmail: string;
begin
  LLicenseNumber := ALicenseNumber.ToUpper;
  LUserEmail := AUserEmail.ToLower;
  CheckSettings;
  result := TCilTsegLicenseActivation.Create;
  Server := THTTPClient.Create;
  try
    Params := TStringList.Create;
    try
      Params.AddPair('c', SoftwareID.ToString);
      Params.AddPair('n', LLicenseNumber);
      Params.AddPair('e', LUserEmail);
      Params.AddPair('a', ADeviceName);
      Params.AddPair('v', TOlfChecksumVerif.Get(FSoftwareToken,
        FSoftwareID.ToString, LLicenseNumber, LUserEmail, ADeviceName));
      Response := Server.Post(FServerURL + '/api-license-activate.php', Params);
    finally
      Params.Free;
    end;
    if Response.StatusCode = 200 then
    begin
      jso := TJSONObject.ParseJSONValue(Response.ContentAsString(tencoding.UTF8)
        ) as TJSONObject;
      try
        if jso.TryGetValue<boolean>('error', b) then
          result.Error := b;
        if not result.Error then
        begin
          if jso.TryGetValue<string>('license', s) then
            result.LicenseNumber := s;
          if jso.TryGetValue<string>('activation', s) then
            result.ActivationNumber := s;
        end;
      finally
        jso.Free;
      end;
    end;
  finally
    Server.Free;
  end;
end;

procedure TCilTsegClientLib.SetServerURL(const Value: string);
begin
  FServerURL := Value;
end;

procedure TCilTsegClientLib.SetSoftwareID(const Value: integer);
begin
  FSoftwareID := Value;
end;

procedure TCilTsegClientLib.SetSoftwareToken(const Value: string);
begin
  FSoftwareToken := Value;
end;

end.
