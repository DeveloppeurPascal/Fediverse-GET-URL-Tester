unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Olf.FMX.AboutDialog, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.Memo.Types, FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Memo;

type
  TfrmMain = class(TForm)
    ToolBar1: TToolBar;
    OlfAboutDialog1: TOlfAboutDialog;
    btnClose: TButton;
    btnAbout: TButton;
    StatusBar1: TStatusBar;
    btnRegisterLicense: TButton;
    lblStatusText: TLabel;
    edtURLToGet: TEdit;
    btnGETasJSON: TButton;
    btnGETasHTML: TButton;
    mmoResult: TMemo;
    LockScreenBackground: TRectangle;
    zLockScreen: TLayout;
    LockScreenIndicator: TAniIndicator;
    btnWebFinger: TButton;
    procedure btnAboutClick(Sender: TObject);
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure FormCreate(Sender: TObject);
    procedure btnRegisterLicenseClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnGETasJSONClick(Sender: TObject);
    procedure btnGETasHTMLClick(Sender: TObject);
    procedure btnWebFingerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure CheckLicense;
    procedure UnlockScreen;
    procedure LockScreen;
    procedure GETWithAcceptHeader(AcceptHeader: string);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  u_urlOpen, Olf.RTL.Params, System.IOUtils, System.StrUtils,
  System.Net.HttpClient, FMX.DialogService, System.json, Olf.RTL.Checksum;

{$IFDEF RELEASE}
{$I '..\_PRIVE\PrivateConsts.pas'}
{$ELSE}

const
  _LicensePriv = '{6093192A-F09F-4F2D-8B92-0C9E08412120}';
{$ENDIF}

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  OlfAboutDialog1.Execute;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnGETasHTMLClick(Sender: TObject);
begin
  GETWithAcceptHeader('text/html');
end;

procedure TfrmMain.btnGETasJSONClick(Sender: TObject);
begin
  GETWithAcceptHeader
    ('application/ld+json; profile="https://www.w3.org/ns/activitystreams"');
end;

procedure TfrmMain.btnRegisterLicenseClick(Sender: TObject);
begin
  // TODO : à compléter

  url_Open_In_Browser
    ('https://boutique.olfsoftware.fr/l/FediverseGETURLTester');
end;

procedure TfrmMain.CheckLicense;
var
  dt: tdatetime;
  nbd: byte;
  LicenseKey, LicenseEmail, LicenseVerif: string;
begin
  LicenseKey := tparams.getValue('LicenseKey', '');
  LicenseEmail := tparams.getValue('LicenseEmail', '');
  LicenseVerif := tparams.getValue('LicenseToken', '');
  if (not LicenseVerif.IsEmpty) and checksumverif.check(LicenseVerif,
    LicenseKey, LicenseEmail, _LicensePriv) then
  begin
    lblStatusText.text := '';
    lblStatusText.HitTest := false;
    btnRegisterLicense.Visible := false;
  end
  else
  begin
    btnRegisterLicense.Visible := true;

    dt := tparams.getValue('LastStart', Now);
    nbd := tparams.getValue('DaysOfUse', 30);
    if (dt <> Now) and (nbd > 0) then
    begin
      dec(nbd);
      tparams.getValue('DaysOfUse', nbd);
    end;
    tparams.setValue('LastStart', Now);
    tparams.Save;

    if (nbd > 0) then
      lblStatusText.text :=
        'This is a shareware program. If you use it please buy a license. (' +
        nbd.tostring + ' day' + ifthen(nbd > 1, 's', '') + ' left)'
    else
    begin
      lblStatusText.text :=
        'This is a shareware program. Free use period has expired. Please buy a license.';
      showmessage(lblStatusText.text);
    end;
    lblStatusText.HitTest := true;
    lblStatusText.OnClick := btnRegisterLicense.OnClick;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IFDEF DEBUG}
  caption := '[DEBUG] ' + caption;
{$ENDIF}
  UnlockScreen;
  lblStatusText.text := '';
  CheckLicense;
  edtURLToGet.SetFocus;
end;

procedure TfrmMain.GETWithAcceptHeader(AcceptHeader: string);
var
  url: string;
begin
  if edtURLToGet.text.IsEmpty then
  begin
    edtURLToGet.SetFocus;
    raise exception.Create('Please fill the URL to GET.');
  end
  else
    url := edtURLToGet.text;
  LockScreen;
  try
    tthread.CreateAnonymousThread(
      procedure
      var
        server: thttpclient;
        response: ihttpresponse;
      begin
        try
          server := thttpclient.Create;
          try
            server.Accept := AcceptHeader;
            response := server.Get(url);
            tthread.Synchronize(nil,
              procedure
              begin
                mmoResult.Lines.Clear;
                mmoResult.Lines.Add('URL : ' + url);
                mmoResult.Lines.Add('Status code : ' +
                  response.StatusCode.tostring);
                mmoResult.Lines.Add('Status text : ' + response.StatusText);
                mmoResult.Lines.Add('');
                mmoResult.Lines.Add(response.ContentAsString(TEncoding.UTF8));
              end);
          finally
            server.Free;
          end;
        finally
          tthread.Synchronize(nil,
            procedure
            begin
              UnlockScreen;
            end);
        end;
      end).Start;
  except
    UnlockScreen;
  end;
end;

procedure TfrmMain.LockScreen;
begin
  zLockScreen.Visible := true;
  zLockScreen.bringtofront;
  LockScreenIndicator.enabled := true;
end;

procedure TfrmMain.btnWebFingerClick(Sender: TObject);
var
  account: string;
  pseudo: string;
  domain: string;
  tab: TArray<string>;
begin
  TDialogService.InputQuery('WebFinger', ['Fediverse contact address'],
    ['@user@domain'],
    procedure(const AResult: TModalresult; const AValues: array of string)
    begin
      if (AResult = mrok) and (length(AValues) = 1) and
        (not AValues[0].trim.IsEmpty) then
      begin
        account := AValues[0].trim;
        if account.StartsWith('@') then
          account := account.Substring(1);
        tab := account.Split(['@']);
        if length(tab) = 2 then
        begin
          pseudo := tab[0];
          domain := tab[1];
          LockScreen;
          try
            tthread.CreateAnonymousThread(
              procedure
              var
                server: thttpclient;
                response: ihttpresponse;
                url: string;
                ActivityPubUrl: string;
                jso: tjsonobject;
                jsa: tjsonarray;
                jsv: tjsonvalue;
                link: tjsonobject;
              begin
                try
                  ActivityPubUrl := '';
                  url := 'https://' + domain +
                    '/.well-known/webfinger?resource=acct:' + pseudo +
                    '@' + domain;
                  server := thttpclient.Create;
                  try
                    server.Accept := 'application/json';
                    response := server.Get(url);
                    if (response.StatusCode = 200) then
                    begin
                      jso := tjsonobject.ParseJSONValue
                        (response.ContentAsString) as tjsonobject;
                      if assigned(jso) then
                        try
                          jsa := jso.getValue<tjsonarray>('links');
                          if assigned(jsa) then
                            for jsv in jsa do
                            begin
                              link := jsv as tjsonobject;
                              if (link.Values['rel'].Value = 'self') and
                                (link.Values['type']
                                .Value = 'application/activity+json') then
                              begin
                                ActivityPubUrl := link.Values['href'].Value;
                                break;
                              end;
                            end;
                        finally
                          jso.Free;
                        end;
                    end;
                    tthread.Synchronize(nil,
                      procedure
                      begin
                        mmoResult.Lines.Clear;
                        mmoResult.Lines.Add('Pseudo : ' + pseudo);
                        mmoResult.Lines.Add('Domain : ' + domain);
                        mmoResult.Lines.Add('WebFinger : ' + url);
                        if not ActivityPubUrl.IsEmpty then
                        begin
                          mmoResult.Lines.Add('ActivityPub URL : ' +
                            ActivityPubUrl);
                          edtURLToGet.text := ActivityPubUrl;
                        end;
                        mmoResult.Lines.Add('Status code : ' +
                          response.StatusCode.tostring);
                        mmoResult.Lines.Add('Status text : ' +
                          response.StatusText);
                        mmoResult.Lines.Add('');
                        mmoResult.Lines.Add(response.ContentAsString
                          (TEncoding.UTF8));
                      end);
                  finally
                    server.Free;
                  end;
                finally
                  tthread.Synchronize(nil,
                    procedure
                    begin
                      UnlockScreen;
                    end);
                end;
              end).Start;
          except
            UnlockScreen;
          end;
        end;
      end;
    end);
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

procedure TfrmMain.UnlockScreen;
begin
  LockScreenIndicator.enabled := false;
  zLockScreen.Visible := false;
end;

initialization

{$IFDEF DEBUG}
  tparams.setFolderName(tpath.Combine(tpath.Combine(tpath.GetHomePath,
  'OlfSoftware'), 'FediverseGetURLTester-debug'));
{$ELSE}
  tparams.setFolderName(tpath.Combine(tpath.Combine(tpath.GetHomePath,
  'OlfSoftware'), 'FediverseGetURLTester'));
{$ENDIF}
TDialogService.PreferredMode := TDialogService.TPreferredMode.Async;

end.
