unit uArquivoController;

interface

uses
  System.Classes, System.IOUtils, ShellAPI, Winapi.Windows, Vcl.Graphics,
  System.SysUtils, Vcl.ExtCtrls, Vcl.Controls,
  Vcl.Dialogs, uDiretorioModel, Vcl.Menus, uArquivoModel,
  System.Generics.Collections, System.UITypes, uIconeService,
  uArquivoService;

type
  IArquivoController = interface
    ['{5C99D15A-9DF2-4841-82DB-2160636E17AA}']

    procedure MenuItemClick(Sender: TObject);
    procedure PreencherMenu(DiretorioJogos: string; var Menu: TPopupMenu);
    procedure CriarItemFecharApp(Menu: TPopupMenu);
    procedure FinalizarAplicacao(Sender: TObject);
  end;

  TArquivoController = class(TInterfacedObject, IArquivoController)
  private
    procedure FinalizarAplicacao(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure CriarItemFecharApp(Menu: TPopupMenu);
  public
    procedure PreencherMenu(DiretorioJogos: string; var Menu: TPopupMenu);
  end;

implementation

{ TArquivoController }

uses
  uShellService;

procedure TArquivoController.MenuItemClick(Sender: TObject);
begin
  TShellService.AbrirArquivo(StringReplace(TMenuItem(Sender).Hint, '&', '', [rfReplaceAll]));
end;

procedure TArquivoController.PreencherMenu(DiretorioJogos: string;
  var Menu: TPopupMenu);
var
  Item: TMenuItem;
begin
  var lListaArquivos := TArquivoService.ListarArquivos(DiretorioJogos);
  try
    for var Jogo in lListaArquivos do
      begin
        Item := TMenuItem.Create(Menu);

        Item.Caption := Jogo.Nome;
        Item.Bitmap := Jogo.Icone;
        Item.Hint := Jogo.Diretorio;
        Item.OnClick := MenuItemClick;
        Menu.Items.Add(Item);
      end;
  finally
    lListaArquivos.Free();
  end;

  CriarItemFecharApp(Menu);
end;

procedure TArquivoController.CriarItemFecharApp(Menu: TPopupMenu);
begin
  var Item := TMenuItem.Create(Menu);
  Item.Caption := 'Fechar';
  Item.OnClick := FinalizarAplicacao;
  Menu.Items.Add(Item);
end;

procedure TArquivoController.FinalizarAplicacao(Sender: TObject);
begin
  if MessageDlg('Deseja mesmo sair?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    Halt;
end;

end.

