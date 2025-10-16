(* C2PP
  ***************************************************************************

  Fediverse GET URL Tester

  Copyright 2022-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://fediversegeturltester.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/Fediverse-GET-URL-Tester

  ***************************************************************************
  File last update : 2025-10-16T10:43:57.847+02:00
  Signature : 1ac05cc16bfb3d306931fdd6d172690bd27eaa9c
  ***************************************************************************
*)

program FediverseGETURLTester;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  Olf.FMX.AboutDialog in '..\lib-externe\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externe\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  Olf.RTL.Checksum in '..\lib-externe\librairies\src\Olf.RTL.Checksum.pas',
  Olf.RTL.Params in '..\lib-externe\librairies\src\Olf.RTL.Params.pas',
  u_md5 in '..\lib-externe\librairies\src\u_md5.pas',
  u_urlOpen in '..\lib-externe\librairies\src\u_urlOpen.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
