program API;

uses
  Vcl.Forms,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  uAPI in 'uAPI.pas' {Form1},
  uCreateDatabase in 'uCreateDatabase.pas',
  uIniConfigStore in 'uIniConfigStore.pas',
  uMssqlDriver in 'uMssqlDriver.pas';

{$R *.res}

begin
  Application.Initialize;

//  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
