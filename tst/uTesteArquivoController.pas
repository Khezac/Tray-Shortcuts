unit uTesteArquivoController;

interface

uses
  DUnitX.TestFramework, uArquivoController, System.SysUtils;

type
  [TestFixture]
  TTesteIcones = class
  private
    FArquivoController: IArquivoController;
  public

    [SetupFixture]
    procedure Setup;

    [Test]
    procedure DeveListarArquivos();

  end;

implementation

{ TTesteIcones }

procedure TTesteIcones.DeveListarArquivos;
begin
  var DIRETORIO := 'C:\';
  Assert.IsTrue(FArquivoController.ListarArquivos(DIRETORIO).Count > 0,
    'Não foi possível listar os arquivos do diretório: ' + DIRETORIO);
end;

procedure TTesteIcones.Setup;
begin
  FArquivoController := TArquivoController.Create();
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteIcones);

end.
