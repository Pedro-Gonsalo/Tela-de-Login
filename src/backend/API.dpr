program API;

uses
  Vcl.Forms,
  uAPI in 'uAPI.pas' {Form1},
  uDataModule in 'uDataModule.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;

//  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
