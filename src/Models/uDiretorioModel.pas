unit uDiretorioModel;

interface

uses
  System.Classes, System.IOUtils;

type
  TDiretorio = class
    class function ListarArquivos(Diretorio: string): TStringList;
  end;

implementation

{ TDiretorioModel }

class function TDiretorio.ListarArquivos(Diretorio: string): TStringList;
begin
  var ListaDeArquivos := TDirectory.GetFiles(Diretorio);
  Result := TStringList.Create();

  for var I := 0 to Length(ListaDeArquivos) - 1 do
    Result.Add(ListaDeArquivos[I]);
end;

end.
