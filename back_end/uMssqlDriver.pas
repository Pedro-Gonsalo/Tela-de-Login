unit uMssqlDriver;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client, FireDAC.DApt,
  FireDAC.Stan.Intf, FireDAC.Phys.Intf,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.Stan.Option, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  uIniConfigStore,
  uCreateDatabase; // IDatabaseDriver

const
  DEFAULT_DATABASE = 'master';

type
  TMssqlDriver = class(TInterfacedObject, IDatabaseDriver)
  private
    FConnection: TFDConnection;
    procedure ConfigureConnection(const Params: TConnectionParams);
    function InternalCheckDatabaseExists(const DatabaseName: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function DatabaseExists(const Params: TConnectionParams): Boolean;
    procedure CreateDatabaseIfNotExists(const Params: TConnectionParams);
  end;

implementation

{ TMssqlDriver }

constructor TMssqlDriver.Create;
begin
  inherited;
  FConnection := TFDConnection.Create(nil);
end;

destructor TMssqlDriver.Destroy;
begin
  if Assigned(FConnection) then
  begin
    if FConnection.Connected then
      FConnection.Close;
    FreeAndNil(FConnection);
  end;
  inherited;
end;

procedure TMssqlDriver.ConfigureConnection(const Params: TConnectionParams);
begin
  try
    FConnection.Params.Clear;
    with FConnection.Params do
    begin
      Add('DriverID=MSSQL');
      if Params.Port.IsEmpty then
        Add('Server=' + Params.Host)
      else
        Add('Server=' + Params.Host + ',' + Params.Port);
      Add('Database=' + DEFAULT_DATABASE); // Sempre conecta ao master
      Add('User_Name=' + Params.User);
      Add('Password=' + Params.Password);
    end;
    FConnection.LoginPrompt := False;
    FConnection.Open; // Conecta ao master
  except
    on E: Exception do
      raise Exception.Create('ConfigureConnection: ' + E.Message);
  end;
end;

function TMssqlDriver.InternalCheckDatabaseExists(const DatabaseName: string): Boolean;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT 1 FROM sys.databases WHERE name = :DatabaseName';
    Query.ParamByName('DatabaseName').AsString := DatabaseName;
    Query.Open;
    Result := not Query.IsEmpty;
  finally
    Query.Free;
  end;
end;

function TMssqlDriver.DatabaseExists(const Params: TConnectionParams): Boolean;
begin
  try
    ConfigureConnection(Params); // Conecta ao master
    Result := InternalCheckDatabaseExists(Params.DatabaseName); // Verifica se o banco alvo existe
  except
    on E: Exception do
      raise Exception.Create('DatabaseExists: ' + E.Message);
  end;
end;

procedure TMssqlDriver.CreateDatabaseIfNotExists(const Params: TConnectionParams);
var
  Query: TFDQuery;
begin
  try
    ConfigureConnection(Params); // Conecta ao master

    if not InternalCheckDatabaseExists(Params.DatabaseName) then
    begin
      Query := TFDQuery.Create(nil);
      try
        Query.Connection := FConnection;
        Query.SQL.Text := Format('CREATE DATABASE [%s]', [Params.DatabaseName]);
        Query.ExecSQL;
      finally
        Query.Free;
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create('CreateDatabaseIfNotExists: ' + E.Message);
  end;
end;

end.
