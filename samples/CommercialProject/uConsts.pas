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
  File last update : 2025-02-09T11:03:28.216+01:00
  Signature : c3c1ec129763de88e29ff1afcfbb42c03d0b65f0
  ***************************************************************************
*)

unit uConsts;

interface

const
  /// <summary>
  /// Date of this current release as a string in ISO format (YYYY-MM-DD)
  /// </summary>
  /// <remarks>
  /// Needed to use CilTseg API,
  /// don't share it in a public code repository,
  /// store it as a const or string variable in your source code.
  /// </remarks>
  CVersionDate = '2024-10-20';

  /// <summary>
  /// Version of this current release (not used by the API, it's a string, use what you want in it)
  /// </summary>
  CVersionNumber = '1.0.0';

  /// <summary>
  /// Your selling web page URL for this software
  /// </summary>
  /// <remarks>
  /// It's better to use a redirection URL if you want to change your selling
  /// URL without compiling and distribution a new binary, but you can if the
  /// address is supposed to be stable.
  /// </remarks>
  CSoftwareBuyURL = 'https://localhost/BuyThisSoftware';

  /// <summary>
  /// Name of the platform for this program, depending on its operating
  /// system, compiler or other things. It should correspond to a platform
  /// you declared in CilTseg and use as a file attached to new releases of
  /// the software.
  /// </summary>
{$IF Defined(MSWINDOWS)}
  CSoftwareCurrentPlatform = 'Windows';
{$ELSE IF Defined(MACOS)}
  CSoftwareCurrentPlatform = 'macOS';
{$ENDIF}
  /// <summary>
  /// ID given by the CilTseg backoffice for this software
  /// </summary>
  /// <remarks>
  /// Needed to use CilTseg API,
  /// don't share it in a public code repository,
  /// store it as a const or integer variable in your source code.
  /// </remarks>
  CCiltsegSoftwareID = 4;

  /// <summary>
  /// Private token given by the CilTseg backoffice for this software
  /// </summary>
  /// <remarks>
  /// Needed to use CilTseg API,
  /// don't share it in a public code repository,
  /// store it as a const or string variable in your source code.
  /// Don't store it in your screen (DFM or FMX files), it will be in the EXE
  /// resources and could be readable as it.
  /// If you can, crypt it in your code and uncrypt it when you need to use it.
  /// </remarks>
  CCiltsegSoftwareToken =
    'LX7r0rCMeDOLlaAezqvCbW9phKxOq79usqqH1Byhq8yOukaqE9gAEr56r10';

  /// <summary>
  /// CilTseg API server URL
  /// </summary>
  /// <remarks>
  /// Needed to use CilTseg API,
  /// don't share it in a public code repository,
  /// store it as a const or string variable in your source code.
  /// Don't store it in your screen (DFM or FMX files), it will be in the EXE
  /// resources and could be readable as it.
  /// </remarks>
  CCiltsegServerURL = 'http://localhost/ciltseg-server/src/';

implementation

end.
