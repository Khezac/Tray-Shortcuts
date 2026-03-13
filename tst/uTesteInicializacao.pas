unit uTesteInicializacao;

interface

uses
  DUnitX.TestFramework, uInicializacao, System.SysUtils, Registry,
  Winapi.Windows;

type
  [TestFixture]
  TTesteInicializacao = class
  public

    [Test]
    procedure DeveAtivarInicializacaoComSistema();

    [Test]
    procedure DeveDesativarInicializacaoComSistema();

  end;

implementation

{ TTesteInicializacao }

procedure TTesteInicializacao.DeveAtivarInicializacaoComSistema;
begin
  TInicializacaoComSistema.Ativar;

  Assert.IsTrue(TInicializacaoComSistema.InicializacaoAtivada,
    'A ativação da inicialização com o sistema falhou.');

  TInicializacaoComSistema.Desativar;
end;

procedure TTesteInicializacao.DeveDesativarInicializacaoComSistema;
begin
  TInicializacaoComSistema.Ativar;
  TInicializacaoComSistema.Desativar;

  Assert.IsFalse(TInicializacaoComSistema.InicializacaoAtivada,
    'A desativação da inicialização com o sistema falhou.');
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteInicializacao);

end.
