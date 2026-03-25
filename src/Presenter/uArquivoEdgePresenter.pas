unit uArquivoEdgePresenter;

interface

uses
  System.JSON, uArquivoModel, System.Generics.Collections;

type
  TArquivoEdgePresenter = class
    class function MontarJsonEnvioEdge(ListaDeArquivos: TList<IArquivo>): TJsonObject;
  end;

implementation

{ TArquivoEdgePresenter }

class function TArquivoEdgePresenter.MontarJsonEnvioEdge(ListaDeArquivos: TList<IArquivo>): TJsonObject;
var
  JsonAplicativo: TJsonObject;
begin
  var JsonListaAplicativos := TJsonArray.Create();
  Result := TJsonObject.Create();

  for var Aplicativo in ListaDeArquivos do
    begin
      JsonAplicativo := TJsonObject.Create();
      JsonAplicativo.AddPair('nome', Aplicativo.Nome);
      JsonAplicativo.AddPair('diretorio', Aplicativo.Diretorio);
      JsonListaAplicativos.Add(JsonAplicativo);
    end;

  Result.AddPair('tipo', 'listaAplicativos');
  Result.AddPair('dados', JsonListaAplicativos);
end;

end.
