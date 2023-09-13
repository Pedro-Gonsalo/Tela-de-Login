object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 287
  Width = 475
  object FDConnectionLogin: TFDConnection
    Params.Strings = (
      'User_Name=sa'
      'Password=masterkey'
      'Database=Tela_login'
      'SERVER=grv-not-97\mssqlserver01'
      'OSAuthent=No'
      'ApplicationName=Architect'
      'Workstation=GRV-NOT-97'
      'MARS=yes'
      'DriverID=MSSQL')
    Connected = True
    Left = 208
    Top = 120
  end
  object FDQueryUsers: TFDQuery
    Connection = FDConnectionLogin
    SQL.Strings = (
      'select * from users')
    Left = 344
    Top = 112
  end
end
