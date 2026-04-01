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
  File last update : 2025-05-25T16:19:28.000+02:00
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
