unit uInicializacao;

interface

uses
  Registry, Winapi.Windows, Vcl.Forms, Vcl.Dialogs, System.Classes;

type
  TInicializacaoComSistema = class
  private
    class procedure IniciarComSistema(pIniciarComSistema: Boolean);
  public
    class function InicializacaoAtivada: Boolean;
    class procedure Ativar;
    class procedure Desativar;
  end;

implementation

{ TInicializacaoComSistema }

class procedure TInicializacaoComSistema.Ativar;
begin
  IniciarComSistema(True);
end;

class procedure TInicializacaoComSistema.Desativar;
begin
  IniciarComSistema(False);
end;

class function TInicializacaoComSistema.InicializacaoAtivada: Boolean;
begin
  Result := False;
  const CAMINHO_REGISTRO = 'Software\Microsoft\Windows\CurrentVersion\Run';
  var Registro := TRegistry.Create();
  try
    Registro.RootKey := HKEY_CURRENT_USER;

    if Registro.OpenKey(CAMINHO_REGISTRO, False) then
      Result := Registro.ValueExists(Application.Title);
  finally
    Registro.CloseKey;
    Registro.Free;
  end;
end;

class procedure TInicializacaoComSistema.IniciarComSistema(pIniciarComSistema: Boolean);
begin
  const CAMINHO_REGISTRO = 'Software\Microsoft\Windows\CurrentVersion\Run';
  var Registro := TRegistry.Create();
  try
    Registro.RootKey := HKEY_CURRENT_USER;

    if Registro.OpenKey(CAMINHO_REGISTRO, True) then
      begin
        if pIniciarComSistema then
          begin
            if not Registro.ValueExists(Application.Title) then
              begin
                Registro.WriteString(Application.Title, '"' + Application.ExeName + '"')
              end;
          end
        else
          if Registro.ValueExists(Application.Title) then
            Registro.DeleteValue(Application.Title);

        Registro.CloseKey;
      end;
  finally
    Registro.Free;
  end;
end;

end.
