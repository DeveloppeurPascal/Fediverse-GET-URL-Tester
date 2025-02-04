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
