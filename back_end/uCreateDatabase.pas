unit uCreateDatabase;

interface

uses
  System.SysUtils, System.IniFiles, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDatabaseManager = class
  private
    FConnectionString: string;
    FDatabaseName: string;
    FUser: string;
    FPassword: string;
    FHost: string;
    FPort: string;
    FADOConnection: TADOConnection;
    procedure CreateDatabaseIfNotExists;
    procedure CreateUsersTableIfNotExists;
    function DatabaseExists: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetConnectionParams(const ADatabaseName, AUser, APassword, AHost, APort: string);
    property Connection: TADOConnection read FADOConnection;
  end;

implementation

constructor TDatabaseManager.Create;
begin
  inherited;
  FADOConnection := TADOConnection.Create(nil);

  try
    // Criar banco de dados se não existir
    CreateDatabaseIfNotExists;

    // Configurar conexão com o banco de dados específico
    FConnectionString := Format('Provider=MSDASQL;Driver={PostgreSQL Unicode};Server=%s;Port=%s;Database=%s;Uid=%s;Pwd=%s;',
                              [FHost, FPort, FDatabaseName, FUser, FPassword]);
    FADOConnection.ConnectionString := FConnectionString;
    FADOConnection.LoginPrompt := False;

    // Criar tabela users se não existir
    CreateUsersTableIfNotExists;
  except
    on E: Exception do
      raise Exception.Create('Erro ao inicializar DatabaseManager: ' + E.Message);
  end;
end;

destructor TDatabaseManager.Destroy;
begin
  if Assigned(FADOConnection) then
  begin
    if FADOConnection.Connected then
      FADOConnection.Close;
    FreeAndNil(FADOConnection);
  end;
  inherited;
end;



function TDatabaseManager.DatabaseExists: Boolean;
var
  TempConn: TADOConnection;
begin
  Result := False;
  TempConn := TADOConnection.Create(nil);
  try
    TempConn.ConnectionString := Format('Provider=MSDASQL;Driver={PostgreSQL Unicode};Server=%s;Port=%s;Database=%s;Uid=%s;Pwd=%s;',
                                      [FHost, FPort, FDatabaseName, FUser, FPassword]);
    TempConn.LoginPrompt := False;
    try
      TempConn.Open;
      Result := True;
      TempConn.Close;
    except
      // Se ocorrer exceção, provavelmente o banco não existe
      Result := False;
    end;
  finally
    TempConn.Free;
  end;
end;

procedure TDatabaseManager.CreateDatabaseIfNotExists;
var
  MasterConn: TADOConnection;
  Query: TADOQuery;
begin
  if DatabaseExists then Exit;

  MasterConn := TADOConnection.Create(nil);
  Query := TADOQuery.Create(nil);
  try
    // Conectar ao banco padrão 'postgres' para criar o novo banco
    MasterConn.ConnectionString := Format('Provider=MSDASQL;Driver={PostgreSQL Unicode};Server=%s;Port=%s;Database=postgres;Uid=%s;Pwd=%s;',
                                        [FHost, FPort, FUser, FPassword]);
    MasterConn.LoginPrompt := False;
    MasterConn.Open;

    Query.Connection := MasterConn;
    Query.SQL.Text := Format('CREATE DATABASE "%s"', [FDatabaseName]);
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
  Query: TADOQuery;
begin
  Query := TADOQuery.Create(nil);

  try
    Query.Connection := FADOConnection;
    FADOConnection.Open;

    // Verificar se a tabela já existe
    Query.SQL.Text :=
      'SELECT EXISTS (' +
      'SELECT 1 FROM information_schema.tables ' +
      'WHERE table_name = ''users'')';
    Query.Open;

    if not Query.Fields[0].AsBoolean then
    begin
      Query.Close;
      Query.SQL.Text :=
        'CREATE TABLE users (' +
        'id SERIAL PRIMARY KEY, ' +
        'first_name VARCHAR(100) NOT NULL, ' +
        'last_name VARCHAR(100) NOT NULL, ' +
        'email VARCHAR(255) UNIQUE NOT NULL, ' +
        'password VARCHAR(255) NOT NULL, ' +
        'creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)';
      Query.ExecSQL;
    end;
  finally
    Query.Free;
  end;
end;

procedure TDatabaseManager.SetConnectionParams(const ADatabaseName, AUser, APassword, AHost, APort: string);
begin
  FDatabaseName := ADatabaseName;
  FUser := AUser;
  FPassword := APassword;
  FHost := AHost;
  FPort := APort;
end;

end.
