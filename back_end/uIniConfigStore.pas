unit uIniConfigStore;

interface

uses
  System.SysUtils, System.IniFiles;

type
  TConnectionParams = record
    DatabaseName : string;
    User     : string;
    Password : string;
    Host     : string;
    Port     : string;
    class function Empty: TConnectionParams; static;
  end;

  TIniConfigStore = class
  private
    FFileName: string;
    function  GetFileName: string;
  public
    constructor Create(const AFileName: string = '');
    procedure   Save(const Params: TConnectionParams);
    function    Load: TConnectionParams;
    property    FileName: string read GetFileName;
  end;

implementation

class function TConnectionParams.Empty: TConnectionParams;
begin
  Result.DatabaseName := '';
  Result.User     := '';
  Result.Password := '';
  Result.Host     := '';
  Result.Port     := '';
end;

constructor TIniConfigStore.Create(const AFileName: string);
begin
  inherited Create;

  if AFileName <> '' then
    FFileName := AFileName
  else
    FFileName :=
      IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
      'config_database.ini';
end;

function TIniConfigStore.GetFileName: string;
begin
  Result := FFileName;
end;

procedure TIniConfigStore.Save(const Params: TConnectionParams);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FFileName);
  try
    Ini.WriteString('database', 'dbname',    Params.DatabaseName);
    Ini.WriteString('database', 'user',      Params.User);
    Ini.WriteString('database', 'password',  Params.Password);
    Ini.WriteString('database', 'host',      Params.Host);
    Ini.WriteString('database', 'port',      Params.Port);
  finally
    Ini.Free;
  end;
end;

function TIniConfigStore.Load: TConnectionParams;
var
  Ini: TIniFile;
begin
  Result := TConnectionParams.Empty;

  if not FileExists(FFileName) then
    Exit;

  Ini := TIniFile.Create(FFileName);
  try
    Result.DatabaseName := Ini.ReadString('database', 'dbname',    '');
    Result.User     := Ini.ReadString('database', 'user',      '');
    Result.Password := Ini.ReadString('database', 'password',  '');
    Result.Host     := Ini.ReadString('database', 'host',      '');
    Result.Port     := Ini.ReadString('database', 'port',      '');
  finally
    Ini.Free;
  end;
end;

end.

