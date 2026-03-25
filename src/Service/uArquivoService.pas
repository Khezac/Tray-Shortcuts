unit uArquivoService;

interface

uses
  uArquivoModel, System.Generics.Collections, Vcl.Graphics, System.JSON,
  uArquivoEdgePresenter;

type
  TArquivoService = class
    class function ListarArquivos(Diretorio: string): TList<IArquivo>;
    class function PreencherJsonEnvioAplicativos(DiretorioJogos: string): TJsonObject; static;
  end;

implementation

{ TArquivoService }

uses
  uDiretorioModel, uShellService, uIconeService;

class function TArquivoService.ListarArquivos(
  Diretorio: string): TList<IArquivo>;
begin
  Result := TList<IArquivo>.Create();

  var ListaArquivos := TDiretorio.ListarArquivos(Diretorio);
  for var ArquivoDiretorioString in ListaArquivos do
    begin
      var NovoIcone := TIcon.Create();
      NovoIcone.Handle := TShellService.PegarIconeDoArquivo(ArquivoDiretorioString);

      var Arquivo := TArquivo.Create();
      Arquivo.Diretorio := ArquivoDiretorioString;
      Arquivo.Icone := TIconeService.RedimensionarIcone(NovoIcone, 16, 16);

      Result.Add(Arquivo);
    end;
end;

class function TArquivoService.PreencherJsonEnvioAplicativos(DiretorioJogos: string): TJsonObject;
begin
  var ListaArquivos := TList<IArquivo>.Create();
  try
    ListaArquivos := TArquivoService.ListarArquivos(DiretorioJogos);
    Result := TArquivoEdgePresenter.MontarJsonEnvioEdge(ListaArquivos);
  finally
    ListaArquivos.Free();
  end;
end;

end.
