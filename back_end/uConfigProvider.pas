unit uConfigProvider;

interface

uses
  System.SysUtils,
  uIniConfigStore; // TConnectionParams, TIniConfigStore

type
  IConfigProvider = interface
    ['{8EAC9A50-8E83-4DCA-8C0A-9B37C1EC2FEE}']
    function LoadConnectionParams: TConnectionParams;
  end;

  TIniConfigProvider = class(TInterfacedObject, IConfigProvider)
  private
    FStore: TIniConfigStore;
  public
    constructor Create(const AFileName: string = '');
    function LoadConnectionParams: TConnectionParams;
  end;

implementation

{ TIniConfigProvider }

constructor TIniConfigProvider.Create(const AFileName: string);
begin
  FStore := TIniConfigStore.Create(AFileName);
end;

function TIniConfigProvider.LoadConnectionParams: TConnectionParams;
begin
  Result := FStore.Load;
end;

end.