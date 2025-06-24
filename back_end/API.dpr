program API;

uses
  Vcl.Forms,
  uAPI in 'uAPI.pas' {Form1},
  uCreateDatabase in 'uCreateDatabase.pas';

{$R *.res}

begin
  Application.Initialize;

//  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
