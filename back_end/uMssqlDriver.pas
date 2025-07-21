unit uMssqlDriver;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.Phys.Intf,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.Stan.Option, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  uIniConfigStore,
  uCreateDatabase;      // IDatabaseDriver

type
  TMssqlDriver = class(TInterfacedObject, IDatabaseDriver)
  private
    procedure ConfigureConnection(const Conn: TFDConnection;
      const P: TConnectionParams);
  public
    function  DatabaseExists(const P: TConnectionParams): Boolean;
    procedure CreateDatabaseIfNotExists(const P: TConnectionParams);
  end;

implementation

procedure TMssqlDriver.ConfigureConnection(const Conn: TFDConnection;
  const P: TConnectionParams);
begin
  try
    Conn.Params.Clear;
    with Conn.Params do
    begin
      Add('DriverID=MSSQL');
      if P.Port.IsEmpty
        then Add('Server=' + P.Host)
        else Add('Server=' + P.Host + ',' + P.Port);
      Add('Database=' + P.DatabaseName);
      Add('User_Name=' + P.User);
      Add('Password=' + P.Password);
    end;
    Conn.LoginPrompt := False;
  except
    on E: Exception do
      raise Exception.Create('ConfigureConnection: ' + E.Message);
  end;
end;

function TMssqlDriver.DatabaseExists(const P: TConnectionParams): Boolean;
var
  Conn: TFDConnection;
begin
  Result := False;
  Conn := TFDConnection.Create(nil);
  try
    try
      ConfigureConnection(Conn, P);
      try
        Conn.Open;
        Result := True;
      except
        Result := False;
      end;
    except
      on E: Exception do
        raise Exception.Create('DatabaseExists: ' + E.Message);
    end;
  finally
    Conn.Free;
  end;
end;

procedure TMssqlDriver.CreateDatabaseIfNotExists(const P: TConnectionParams);
var
  Conn: TFDConnection;
  Q   : TFDQuery;
begin
  try
    if DatabaseExists(P) then
      Exit;

    Conn := TFDConnection.Create(nil);
    Q    := TFDQuery.Create(nil);
    try
      ConfigureConnection(Conn, P);
      Conn.Open;

      Q.Connection := Conn;
      Q.SQL.Text := Format('CREATE DATABASE [%s]', [P.DatabaseName]);
      Q.ExecSQL;
    finally
      Q.Free;
      Conn.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('CreateDatabaseIfNotExists: ' + E.Message);
  end;
end;

end.

