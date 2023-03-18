program FediverseGETURLTester;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  u_urlOpen in '..\lib-externe\librairies\u_urlOpen.pas',
  Olf.FMX.AboutDialog in '..\lib-externe\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externe\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  Olf.RTL.Params in '..\lib-externe\librairies\Olf.RTL.Params.pas',
  uChecksumVerif in '..\lib-externe\librairies\uChecksumVerif.pas',
  u_md5 in '..\lib-externe\librairies\u_md5.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
