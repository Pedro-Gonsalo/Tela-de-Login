unit uConnectionFactory;

interface

uses
  FireDAC.Comp.Client,
  uIniConfigStore;

type
  IDBConnectionFactory = interface
    ['{0A5E8E61-38C6-4B9C-93C8-4E8B9CF9895E}']
    function NewConnection: TFDConnection; // caller owns
  end;

  TMSSQLConnectionFactory = class(TInterfacedObject, IDBConnectionFactory)
  private
    FParams: TConnectionParams;
  public
    constructor Create(const AParams: TConnectionParams);
    function NewConnection: TFDConnection;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Stan.Intf, FireDAC.Phys.Intf,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.Stan.Option, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async;

constructor TMSSQLConnectionFactory.Create(const AParams: TConnectionParams);
begin
  FParams := AParams;
end;

function TMSSQLConnectionFactory.NewConnection: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  try
    Result.LoginPrompt := False;
    Result.Params.Clear;
    Result.Params.Add('DriverID=MSSQL');
    Result.Params.Values['Server']   := FParams.Host;
    Result.Params.Values['Database'] := FParams.DatabaseName;
    Result.Params.Values['User_Name']:= FParams.User;
    Result.Params.Values['Password'] := FParams.Password;
    Result.Connected := True;
  except
    Result.Free;
    raise;
  end;
end;

end.