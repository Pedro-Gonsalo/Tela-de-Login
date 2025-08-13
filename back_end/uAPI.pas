unit uAPI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uIniConfigStore;

type
  TFormMain = class(TForm)
    Label1: TLabel;
    EditNomeBanco: TEdit;
    LabelNomeBanco: TLabel;
    LabelUsuario: TLabel;
    EditUsuario: TEdit;
    LabelSenha: TLabel;
    EditSenha: TEdit;
    LabelHost: TLabel;
    EditHost: TEdit;
    LabelPorta: TLabel;
    EditPorta: TEdit;
    ButtonIniciar: TButton;
    ButtonParar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonIniciarClick(Sender: TObject);
  private
    FConnectionParams: TConnectionParams;
    procedure LoadIniToUI;
    procedure UpdateParamsFromUI;
  public
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  uConfigProvider, uApp;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  LoadIniToUI;
end;

procedure TFormMain.LoadIniToUI;
var
  ConfigProvider: IConfigProvider;
  IniPath: string;
begin
  IniPath := ExtractFilePath(ParamStr(0)) + 'config_database.ini';
  ConfigProvider := TIniConfigProvider.Create(IniPath);
  FConnectionParams := ConfigProvider.LoadConnectionParams;

  EditNomeBanco.Text := FConnectionParams.DatabaseName;
  EditUsuario.Text   := FConnectionParams.User;
  EditSenha.Text     := FConnectionParams.Password;
  EditHost.Text      := FConnectionParams.Host;
  EditPorta.Text     := FConnectionParams.Port;
end;

procedure TFormMain.UpdateParamsFromUI;
begin
  FConnectionParams.DatabaseName := EditNomeBanco.Text;
  FConnectionParams.User         := EditUsuario.Text;
  FConnectionParams.Password     := EditSenha.Text;
  FConnectionParams.Host         := EditHost.Text;
  FConnectionParams.Port         := EditPorta.Text;
end;

procedure TFormMain.ButtonIniciarClick(Sender: TObject);
begin
  UpdateParamsFromUI;
  try
    TApp.Start(FConnectionParams, 9000);
    ButtonIniciar.Caption := 'Rodando';
  except
    on E: Exception do
      ShowMessage('Erro ao iniciar: ' + E.Message);
  end;
end;

end.

