unit uArquivoController;

interface

uses
  System.Classes, System.IOUtils, ShellAPI, Winapi.Windows, Vcl.Graphics,
  System.SysUtils, Vcl.ExtCtrls, Vcl.Controls,
  Dialogs, uDiretorioModel, Vcl.Menus, uArquivoModel,
  System.Generics.Collections, System.UITypes;

type
  IArquivoController = interface
    ['{5C99D15A-9DF2-4841-82DB-2160636E17AA}']
    function ListarArquivos(Diretorio: string): TList<IArquivo>;
    function RedimensionarIcone(const Origem: TIcon; Largura,
      Altura: Integer): TBitMap;

    procedure MenuItemClick(Sender: TObject);
    procedure PreencherMenu(DiretorioJogos: string; var Menu: TPopupMenu);
  end;

  TArquivoController = class(TInterfacedObject, IArquivoController)
  private
    FDiretorioGeral: string;

    procedure FinalizarAplicacao(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);

    function RedimensionarIcone(const Origem: TIcon; Largura,
      Altura: Integer): TBitMap;
    function ListarArquivos(Diretorio: string): TList<IArquivo>;
  public
    procedure PreencherMenu(DiretorioJogos: string; var Menu: TPopupMenu);
  end;

implementation

{ TArquivoController }

uses
  uShellService;

function TArquivoController.ListarArquivos(Diretorio: string): TList<IArquivo>;
begin
  Result := TList<IArquivo>.Create();

  FDiretorioGeral := Diretorio;

  var ListaArquivos := TDiretorio.ListarArquivos(Diretorio);
  for var ArquivoString in ListaArquivos do
    begin
      var NovoIcone := TIcon.Create();
      NovoIcone.Handle := TShellService.PegarIconeDoArquivo(ArquivoString);

      var Arquivo := TArquivo.Create();
      Arquivo.Diretorio := ArquivoString;
      Arquivo.Icone := RedimensionarIcone(NovoIcone, 16, 16);

      Result.Add(Arquivo);
    end;
end;

procedure TArquivoController.MenuItemClick(Sender: TObject);
begin
  TShellService.AbrirArquivo(FDiretorioGeral, StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll]));
end;

procedure TArquivoController.PreencherMenu(DiretorioJogos: string;
  var Menu: TPopupMenu);
var
  Item: TMenuItem;
begin
  FDiretorioGeral := DiretorioJogos;
  var lListaArquivos := ListarArquivos(DiretorioJogos);
  try
    for var Jogo in lListaArquivos do
      begin
        Item := TMenuItem.Create(Menu);

        Item.Caption := Jogo.Nome;
        Item.Bitmap := Jogo.Icone;
        Item.OnClick := MenuItemClick;
        Menu.Items.Add(Item);
      end;
  finally
    lListaArquivos.Free();
  end;

  Item := TMenuItem.Create(Menu);
  Item.Caption := 'Fechar';
  Item.OnClick := FinalizarAplicacao;
  Menu.Items.Add(Item);
end;

procedure TArquivoController.FinalizarAplicacao(Sender: TObject);
begin
  if MessageDlg('Deseja mesmo sair?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    Halt;
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

