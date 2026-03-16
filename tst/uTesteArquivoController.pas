unit uTesteArquivoController;

interface

uses
  DUnitX.TestFramework, uArquivoController, System.SysUtils, Vcl.Menus;

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
  var Menu := TPopupMenu.Create(nil);
  const DIRETORIO = 'C:\';

  try
    FArquivoController.PreencherMenu(DIRETORIO, Menu);
    Assert.IsTrue(Menu.Items.Count > 0,
      'Não foi possível preencher o menu com os itens do diretório: ' + DIRETORIO);
  finally
    Menu.Free();
  end;
end;

procedure TTesteArquivoController.Setup;
begin
  FArquivoController := TArquivoController.Create();
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteArquivoController);

end.
