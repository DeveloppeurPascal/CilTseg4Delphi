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
/// File last update : 2024-10-26T18:35:14.000+02:00
/// Signature : e970f748fd885585740623600b26f07ea66d4584
/// ***************************************************************************
/// </summary>

program CommercialProjectVCLSample;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {frmMain},
  fCiltsegRegisterOrShowLicense in '..\..\src\VCL\fCiltsegRegisterOrShowLicense.pas' {frmCilTsegRegisterOrShowLicense},
  Olf.CilTseg.ClientLib in '..\..\src\Olf.CilTseg.ClientLib.pas',
  uConsts in 'uConsts.pas',
  Olf.RTL.Checksum in '..\..\lib-externes\librairies\src\Olf.RTL.Checksum.pas',
  u_md5 in '..\..\lib-externes\librairies\src\u_md5.pas',
  uConfig in 'uConfig.pas',
  u_urlOpen in '..\..\lib-externes\librairies\src\u_urlOpen.pas',
  uGetDeviceName in '..\..\lib-externes\librairies\src\uGetDeviceName.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmCilTsegRegisterOrShowLicense, frmCilTsegRegisterOrShowLicense);
  Application.Run;
end.
