unit uTesteArquivoService;

interface

uses
  DUnitX.TestFramework, uArquivoService, System.SysUtils;

type
  [TestFixture]
  TTesteArquivoService = class
  public

    [Test]
    procedure DeveListarArquivos();

  end;

implementation

{ uTesteArquivoService }

procedure TTesteArquivoService.DeveListarArquivos;
begin
  const DIRETORIO = 'C:\';

  var ListaArquivos := TArquivoService.ListarArquivos(DIRETORIO);
  Assert.IsTrue(ListaArquivos.Count > 0,
    'Não foi possível listar os arquivos do diretório: ' + DIRETORIO);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteArquivoService);

end.
