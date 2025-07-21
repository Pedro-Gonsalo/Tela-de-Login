unit uCreateDatabase;

interface

uses
  System.SysUtils,
  uIniConfigStore; // TConnectionParams, TIniConfigStore

{==============================================================================}
{  Interface – contrato que cada driver deve cumprir                           }
{==============================================================================}
type
  IDatabaseDriver = interface
    ['{551CF5AF-6C08-470F-B94F-4A83E7EDA1F1}']
    function  DatabaseExists(const P: TConnectionParams): Boolean;
    procedure CreateDatabaseIfNotExists(const P: TConnectionParams);
  end;

{==============================================================================}
{  Manager – coordena parâmetros e chama o driver                              }
{==============================================================================}
type
  TDatabaseManager = class
  private
    FDriver      : IDatabaseDriver;
    FParams      : TConnectionParams;
    FConfigStore : TIniConfigStore;
    procedure    ValidateConnectionParams;
  public
    constructor Create(const ADriver: IDatabaseDriver);
    destructor  Destroy; override;

    procedure SetConnectionParams(const ADatabaseName, AUser, APassword,
      AHost, APort: string);

    procedure Initialize;  // garante que o banco existe (ou cria)
  end;

implementation

{------------------------------------------------------------------------------}
{  TDatabaseManager                                                            }
{------------------------------------------------------------------------------}
constructor TDatabaseManager.Create(const ADriver: IDatabaseDriver);
begin
  inherited Create;
  FConfigStore := TIniConfigStore.Create;
  FDriver      := ADriver;
end;

destructor TDatabaseManager.Destroy;
begin
  if Assigned(FConfigStore) then
     FConfigStore.Free;

  inherited;
end;

procedure TDatabaseManager.SetConnectionParams(const ADatabaseName, AUser,
  APassword, AHost, APort: string);
begin
  FParams.DatabaseName := ADatabaseName;
  FParams.User         := AUser;
  FParams.Password     := APassword;
  FParams.Host         := AHost;
  FParams.Port         := APort;

  FConfigStore.Save(FParams);
end;

procedure TDatabaseManager.ValidateConnectionParams;
begin
  if FParams.DatabaseName.IsEmpty then
    raise Exception.Create('Nome do banco não informado');
  if FParams.User.IsEmpty then
    raise Exception.Create('Usuário não informado');
  if FParams.Host.IsEmpty then
    raise Exception.Create('Host não informado');
end;

procedure TDatabaseManager.Initialize;
begin
  ValidateConnectionParams;

  if not FDriver.DatabaseExists(FParams) then
    FDriver.CreateDatabaseIfNotExists(FParams);
end;

end.

