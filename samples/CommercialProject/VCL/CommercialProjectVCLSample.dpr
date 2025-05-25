(* C2PP
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
  File last update : 2025-02-09T11:03:30.000+01:00
  Signature : bde729e651783f580c26318a1de20e10cc393425
  ***************************************************************************
*)

program CommercialProjectVCLSample;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {frmMain},
  Olf.RTL.Checksum in '..\..\..\lib-externes\librairies\src\Olf.RTL.Checksum.pas',
  u_md5 in '..\..\..\lib-externes\librairies\src\u_md5.pas',
  u_urlOpen in '..\..\..\lib-externes\librairies\src\u_urlOpen.pas',
  uGetDeviceName in '..\..\..\lib-externes\librairies\src\uGetDeviceName.pas',
  Olf.CilTseg.ClientLib in '..\..\..\src\Olf.CilTseg.ClientLib.pas',
  fCiltsegRegisterOrShowLicense in '..\..\..\src\VCL\fCiltsegRegisterOrShowLicense.pas' {frmCilTsegRegisterOrShowLicense},
  uConfig in '..\uConfig.pas',
  uConsts in '..\uConsts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
