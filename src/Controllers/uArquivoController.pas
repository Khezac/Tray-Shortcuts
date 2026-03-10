unit uArquivoController;

interface

uses
  System.Classes, System.IOUtils, ShellAPI, Winapi.Windows, Vcl.Graphics,
  Winapi.ShlObj, Winapi.ActiveX, System.SysUtils, Vcl.ExtCtrls, Vcl.Controls,
  uDiretorioModel, Vcl.Menus, uArquivoModel, System.Generics.Collections;

type
  IArquivoController = interface
    ['{5C99D15A-9DF2-4841-82DB-2160636E17AA}']
    function ListarArquivos(Diretorio: string): TList<IArquivo>;
    function PegarIconeDoArquivo(const pCaminhoAtalho: string): HICON;
    function RedimensionarIcone(const Origem: TIcon; Largura,
      Altura: Integer): TBitMap;

    procedure AbrirArquivo(NomeArquivo: string);
    procedure PreencherMenu(DiretorioJogos: string; var Menu: TPopupMenu);
    procedure PreencherImageList(var ListaDeIcones: TImageList);
  end;

  TArquivoController = class(TInterfacedObject, IArquivoController)
  public
    FListaArquivos: TList<IArquivo>;

    function ListarArquivos(Diretorio: string): TList<IArquivo>;
    function PegarIconeDoArquivo(const pCaminhoAtalho: string): HICON;
    function RedimensionarIcone(const Origem: TIcon; Largura,
      Altura: Integer): TBitMap;

    procedure AbrirArquivo(NomeArquivo: string);
    procedure PreencherMenu(DiretorioJogos: string; var Menu: TPopupMenu);
    procedure PreencherImageList(var ListaDeIcones: TImageList);
  end;

implementation

{ TArquivoController }

procedure TArquivoController.AbrirArquivo(NomeArquivo: string);
begin
  ShellExecute(0, 'open', PWideChar(NomeArquivo), '', PWideChar(NomeArquivo), SW_HIDE);
end;

function TArquivoController.ListarArquivos(Diretorio: string): TList<IArquivo>;
var
  ListaArquivos: TStringList;
  Arquivo: IArquivo;
  NovoIcone: TIcon;
begin
  Result := TList<IArquivo>.Create();

  ListaArquivos := TDiretorio.ListarArquivos(Diretorio);
  for var ArquivoString in ListaArquivos do
    begin
      NovoIcone := TIcon.Create();
      NovoIcone.Handle := PegarIconeDoArquivo(ArquivoString);

      Arquivo := TArquivo.Create();
      Arquivo.Diretorio := ArquivoString;
      Arquivo.Icone := RedimensionarIcone(NovoIcone, 16, 16);

      Result.Add(Arquivo);
    end;
end;

function TArquivoController.PegarIconeDoArquivo(const pCaminhoAtalho: string): HICON;
var ShellLink: IShellLink;
  PersistFile: IPersistFile;
  IconFile: array[0..MAX_PATH] of Char;
  IconIndex: Integer;
  WPath: WideString;
  hLarge, hSmall: HICON;
begin
  Result := 0;

  if not FileExists(pCaminhoAtalho) then
    Exit;

  if CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IID_IShellLink, ShellLink) = S_OK then
    begin
      PersistFile := ShellLink as IPersistFile;
      WPath := pCaminhoAtalho;

      if PersistFile.Load(PWideChar(WPath), STGM_READ) = S_OK then
        begin
          if ShellLink.GetIconLocation(IconFile, MAX_PATH, IconIndex) = S_OK then
            begin
              if ExtractIconEx(IconFile, IconIndex, hLarge, hSmall, 1) > 0 then
                begin
                  Result := hLarge;

                  if hSmall <> 0 then
                    DestroyIcon(hSmall);
                end;
            end;
        end;
    end;
end;

procedure TArquivoController.PreencherImageList(var ListaDeIcones: TImageList);
begin
  for var Jogo in FListaArquivos do
    ListaDeIcones.Add(Jogo.Icone, nil);
end;

procedure TArquivoController.PreencherMenu(DiretorioJogos: string;
  var Menu: TPopupMenu);
var
  Item: TMenuItem;
begin
  FListaArquivos := ListarArquivos(DiretorioJogos);

  for var Jogo in FListaArquivos do
    begin
      Item := TMenuItem.Create(Menu);

      Item.Caption := Jogo.Nome;
      Item.Bitmap := Jogo.Icone;
      Menu.Items.Add(Item);
    end;
end;

function TArquivoController.RedimensionarIcone(const Origem: TIcon; Largura, Altura: Integer): TBitMap;
begin
  Result := TBitmap.Create;

    Result.PixelFormat := pf32bit;
    Result.SetSize(Largura, Altura);

    Result.Canvas.Brush.Color := clNone;
    Result.Canvas.FillRect(Rect(0, 0, Largura, Altura));

    DrawIconEx(Result.Canvas.Handle, 0, 0, Origem.Handle, Largura, Altura, 0, 0, DI_NORMAL);

end;

end.
