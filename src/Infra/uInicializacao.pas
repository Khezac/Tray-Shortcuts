unit uInicializacao;

interface

uses
  Registry, Winapi.Windows, Vcl.Forms;

type
  TInicializacaoComSistema = class
  private
    class procedure IniciarComSistema(pIniciarComSistema: Boolean);
  public
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

class procedure TInicializacaoComSistema.IniciarComSistema(pIniciarComSistema: Boolean);
begin
  const CAMINHO_REGISTRO = 'Software\Microsoft\Windows\CurrentVersion\Run';
  var reg := TRegistry.Create();
  try
    reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKey(CAMINHO_REGISTRO, True) then
      begin
        if pIniciarComSistema then
          Reg.WriteString(Application.Title, '"' + Application.ExeName + '"')
        else
          Reg.DeleteValue(Application.Title);

        Reg.CloseKey;
      end;
  finally
    reg.Free;
  end;
end;

end.
