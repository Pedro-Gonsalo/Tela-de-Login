unit uCreateDatabase;

interface

uses
  System.SysUtils, System.IniFiles, System.Classes,
  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Stan.Def,  FireDAC.Stan.Pool,  FireDAC.Stan.Async,

  FireDAC.Phys.Intf, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,

  FireDAC.UI.Intf,
  FireDAC.Comp.Client,
  FireDAC.DApt;

type
  TDatabaseManager = class
  private
    FConnectionString: string;
    FDatabaseName: string;
    FUser: string;
    FPassword: string;
    FHost: string;
    FPort: string;
    FFDConnection: TFDConnection;
    procedure CreateDatabaseIfNotExists;
    procedure CreateUsersTableIfNotExists;
    function DatabaseExists: Boolean;
    procedure ValidateConnectionParams;
    procedure SetupConnection;
    procedure SavesConfigurationFromIniFile;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetConnectionParams(const ADatabaseName, AUser, APassword, AHost, APort: string);
    procedure Initialize;
    property Connection: TFDConnection read FFDConnection;
  end;

implementation

constructor TDatabaseManager.Create;
begin
  inherited;
  FFDConnection := TFDConnection.Create(nil);
  FFDConnection.LoginPrompt := False;
end;

destructor TDatabaseManager.Destroy;
begin
  if Assigned(FFDConnection) then
  begin
    if FFDConnection.Connected then
      FFDConnection.Close;
    FreeAndNil(FFDConnection);
  end;
  inherited;
end;

procedure TDatabaseManager.SetConnectionParams(const ADatabaseName, AUser, APassword, AHost, APort: string);
begin
  FDatabaseName := ADatabaseName;
  FUser := AUser;
  FPassword := APassword;
  FHost := AHost;
  FPort := APort;

  SavesConfigurationFromIniFile;
end;

procedure TDatabaseManager.SavesConfigurationFromIniFile;
var
  Ini: TIniFile;
  IniPath: string;
begin
  IniPath := ExtractFilePath(ParamStr(0)) + 'config_database.ini';

  Ini := TIniFile.Create(IniPath);
  try
    Ini.WriteString('database', 'dbname', FDatabaseName);
    Ini.WriteString('database', 'user', FUser);
    Ini.WriteString('database', 'password', FPassword);
    Ini.WriteString('database', 'host', FHost);
    Ini.WriteString('database', 'port', FPort);
  finally
    Ini.Free;
  end;
end;

procedure TDatabaseManager.ValidateConnectionParams;
begin
  if FDatabaseName.IsEmpty then
    raise Exception.Create('Nome do banco de dados não informado');

  if FUser.IsEmpty then
    raise Exception.Create('Usuário não informado');

  if FHost.IsEmpty then
    raise Exception.Create('Host não informado');
end;

procedure TDatabaseManager.SetupConnection;
begin
  // Configuração do FireDAC para SQL Server
  FFDConnection.Params.Clear;

  with FFDConnection.Params do
  begin
    Add('DriverID=MSSQL');
    Add('Server=' + FHost + ',' + FPort);
    Add('Database=' + FDatabaseName);
    Add('User_Name=' + FUser);
    Add('Password=' + FPassword);
  end;

  FFDConnection.Open;
end;

procedure TDatabaseManager.Initialize;
begin
  ValidateConnectionParams;
  CreateDatabaseIfNotExists;
  SetupConnection;
  CreateUsersTableIfNotExists;
end;

function TDatabaseManager.DatabaseExists: Boolean;
var
  TempConn: TFDConnection;
begin
  Result := False;
  TempConn := TFDConnection.Create(nil);

  try
    TempConn.Params.Clear;

    with TempConn.Params do
    begin
      Add('DriverID=MSSQL');
      Add('Server=' + FHost + ',' + FPort);
      Add('Database=' + FDatabaseName);
      Add('User_Name=' + FUser);
      Add('Password=' + FPassword);
    end;

    TempConn.LoginPrompt := False;
    try
      TempConn.Open;
      Result := True;
      TempConn.Close;
    except
      Result := False;
    end;
  finally
    TempConn.Free;
  end;
end;

procedure TDatabaseManager.CreateDatabaseIfNotExists;
var
  MasterConn: TFDConnection;
  Query: TFDQuery;
begin
  if DatabaseExists then Exit;

  MasterConn := TFDConnection.Create(nil);
  Query := TFDQuery.Create(nil);

  try
    MasterConn.Params.Clear;

    with MasterConn.Params do
    begin
      Add('DriverID=MSSQL');
      Add('Server=' + FHost + ',' + FPort);
      Add('Database=' + FDatabaseName);
      Add('User_Name=' + FUser);
      Add('Password=' + FPassword);
    end;


    MasterConn.LoginPrompt := False;
    MasterConn.Open;

    Query.Connection := MasterConn;
    Query.SQL.Text := Format('CREATE DATABASE [%s]', [FDatabaseName]);
    try
      Query.ExecSQL;
    except
      on E: Exception do
        raise Exception.Create('Erro ao criar banco de dados: ' + E.Message);
    end;
  finally
    Query.Free;
    MasterConn.Free;
  end;
end;

procedure TDatabaseManager.CreateUsersTableIfNotExists;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FFDConnection;
    FFDConnection.Open;

    // Verifica se a tabela já existe (sintaxe SQL Server)
    Query.SQL.Text :=
      'IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = ''users'') ' +
      'BEGIN ' +
      '  CREATE TABLE users (' +
      '    id INT IDENTITY(1,1) PRIMARY KEY, ' +
      '    first_name NVARCHAR(100) NOT NULL, ' +
      '    last_name NVARCHAR(100) NOT NULL, ' +
      '    email NVARCHAR(255) UNIQUE NOT NULL, ' +
      '    password NVARCHAR(255) NOT NULL, ' +
      '    creation_date DATETIME DEFAULT GETDATE()) ' +
      'END';
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
