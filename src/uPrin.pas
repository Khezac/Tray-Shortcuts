unit uPrin;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, System.IOUtils, uArquivoController, Vcl.Menus, System.ImageList,
  Vcl.ImgList, Vcl.ExtCtrls;

type
  TfrmPrincipal = class(TForm)
    pmJogos: TPopupMenu;
    TrayIcon1: TTrayIcon;
    Image1: TImage;
    imlIcones: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure pmJogosPopup(Sender: TObject);
  private
    ArquivosController: IArquivoController;

    procedure PreencherMenu();
  end;

var
  frmPrincipal: TfrmPrincipal;
const
  PASTA_RAIZ_JOGOS = 'D:\Jogos\Atalhos\';
implementation

{$R *.dfm}

uses
  uInicializacao;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  ArquivosController := TArquivoController.Create();

  PreencherMenu();
  TInicializacaoComSistema.Ativar();
end;

procedure TfrmPrincipal.pmJogosPopup(Sender: TObject);
begin
  Self.BringToFront();
  Self.Left := Mouse.CursorPos.X;
  Self.Top := Mouse.CursorPos.Y;
end;

procedure TfrmPrincipal.PreencherMenu;
begin
  ArquivosController.PreencherMenu(PASTA_RAIZ_JOGOS, pmJogos);
end;

end.
