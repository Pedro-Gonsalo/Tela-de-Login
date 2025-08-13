unit uUserController;

interface

uses
  Horse, System.JSON, uUserService, uUserRepository;

type
  TUserController = class
  private
    FService: IUserService;
    function JsonGetString(const JsonObject: TJSONObject; const Key: string; const DefaultValue: string = ''): string;
    function JsonToUser(const JsonObject: TJSONObject): TUserRecord;
  public
    constructor Create(const Service: IUserService);
    procedure RegisterRoutes;
  end;

implementation

uses
  System.SysUtils;

constructor TUserController.Create(const Service: IUserService);
begin
  FService := Service;
end;

function TUserController.JsonGetString(const JsonObject: TJSONObject; const Key: string; const DefaultValue: string = ''): string;
var
  JsonValue: TJSONValue;
begin
  JsonValue := JsonObject.GetValue(Key);
  if Assigned(JsonValue) then
    Result := JsonValue.Value
  else
    Result := DefaultValue;
end;

function TUserController.JsonToUser(const JsonObject: TJSONObject): TUserRecord;
begin
  Result.FirstName := JsonGetString(JsonObject, 'first_name', '');
  Result.LastName  := JsonGetString(JsonObject, 'last_name', '');
  Result.Email     := JsonGetString(JsonObject, 'email', '');
  Result.Password  := JsonGetString(JsonObject, 'password', '');
end;

procedure TUserController.RegisterRoutes;
begin
  THorse.Post('/users/login',
    procedure(Request: THorseRequest; Response: THorseResponse)
    var
      RequestBody: TJSONObject;
      EmailAddress, PasswordValue: string;
      AuthenticatedUser: TUserRecord;
    begin
      if Request.Body.IsEmpty then
      begin
        Response.Status(THTTPStatus.BadRequest).Send('Body vazio');
        Exit;
      end;

      RequestBody := TJSONObject.ParseJSONValue(Request.Body) as TJSONObject;
      if not Assigned(RequestBody) then
      begin
        Response.Status(THTTPStatus.BadRequest).Send('JSON inválido');
        Exit;
      end;

      try
        EmailAddress  := JsonGetString(RequestBody, 'email', '');
        PasswordValue := JsonGetString(RequestBody, 'password', '');

        if (EmailAddress = '') or (PasswordValue = '') then
        begin
          Response.Status(THTTPStatus.BadRequest).Send('Email e senha obrigatórios');
          Exit;
        end;

        if FService.Login(EmailAddress, PasswordValue, AuthenticatedUser) then
          Response.Status(THTTPStatus.OK)
                  .Send(TJSONObject.Create
                        .AddPair('message','Acesso liberado')
                        .AddPair('first_name', AuthenticatedUser.FirstName)
                        .AddPair('last_name' , AuthenticatedUser.LastName)
                        .AddPair('email'     , AuthenticatedUser.Email))
        else
          Response.Status(THTTPStatus.Unauthorized).Send('Acesso negado');
      finally
        RequestBody.Free;
      end;
    end);

  THorse.Post('/users/cadastro',
    procedure(Request: THorseRequest; Response: THorseResponse)
    var
      RequestBody: TJSONObject;
      NewUser: TUserRecord;
    begin
      if Request.Body.IsEmpty then
      begin
        Response.Status(THTTPStatus.BadRequest).Send('Body vazio');
        Exit;
      end;

      RequestBody := TJSONObject.ParseJSONValue(Request.Body) as TJSONObject;
      if not Assigned(RequestBody) then
      begin
        Response.Status(THTTPStatus.BadRequest).Send('JSON inválido');
        Exit;
      end;

      try
        NewUser := JsonToUser(RequestBody);
        FService.RegisterUser(NewUser);
        Response.Status(THTTPStatus.OK).Send('Cadastro concluído');
      finally
        RequestBody.Free;
      end;
    end);

  THorse.Post('/users/atualizar',
    procedure(Request: THorseRequest; Response: THorseResponse)
    var
      RequestBody: TJSONObject;
      WhereEmail, WherePassword: string;
      NewUser: TUserRecord;
    begin
      if Request.Body.IsEmpty then
      begin
        Response.Status(THTTPStatus.BadRequest).Send('Body vazio');
        Exit;
      end;

      RequestBody := TJSONObject.ParseJSONValue(Request.Body) as TJSONObject;
      if not Assigned(RequestBody) then
      begin
        Response.Status(THTTPStatus.BadRequest).Send('JSON inválido');
        Exit;
      end;

      try
        WhereEmail    := JsonGetString(RequestBody, 'emailWhere', '');
        WherePassword := JsonGetString(RequestBody, 'passwordWhere', '');
        NewUser       := JsonToUser(RequestBody);

        FService.UpdateUser(WhereEmail, WherePassword, NewUser);
        Response.Status(THTTPStatus.OK).Send('Dados atualizados');
      finally
        RequestBody.Free;
      end;
    end);

  THorse.Post('/users/deletar',
    procedure(Request: THorseRequest; Response: THorseResponse)
    var
      RequestBody: TJSONObject;
      EmailAddress, PasswordValue: string;
    begin
      if Request.Body.IsEmpty then
      begin
        Response.Status(THTTPStatus.BadRequest).Send('Body vazio');
        Exit;
      end;

      RequestBody := TJSONObject.ParseJSONValue(Request.Body) as TJSONObject;
      if not Assigned(RequestBody) then
      begin
        Response.Status(THTTPStatus.BadRequest).Send('JSON inválido');
        Exit;
      end;

      try
        EmailAddress  := JsonGetString(RequestBody, 'email', '');
        PasswordValue := JsonGetString(RequestBody, 'password', '');
        FService.DeleteUser(EmailAddress, PasswordValue);
        Response.Status(THTTPStatus.OK).Send('Usuário deletado');
      finally
        RequestBody.Free;
      end;
    end);
end;

end.

