unit uTesteArquivoController;

interface

uses
  DUnitX.TestFramework, uArquivoController, System.SysUtils;

type
  [TestFixture]
  TTesteArquivoController = class
  private
    FArquivoController: IArquivoController;
  public

    [SetupFixture]
    procedure Setup;

    [Test]
    procedure DeveListarArquivos();

  end;

implementation

{ TTesteArquivoController }

procedure TTesteArquivoController.DeveListarArquivos;
begin
  const DIRETORIO = 'C:\';
  Assert.IsTrue(FArquivoController.ListarArquivos(DIRETORIO).Count > 0,
    'Não foi possível listar os arquivos do diretório: ' + DIRETORIO);
end;

procedure TTesteArquivoController.Setup;
begin
  FArquivoController := TArquivoController.Create();
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteArquivoController);

end.
