unit uPrin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, ShellAPI, System.IOUtils, uArquivoController, Vcl.Menus,
  System.ImageList, Vcl.ImgList;

type
  TfrmPrincipal = class(TForm)
    pmJogos: TPopupMenu;
    TrayIcon1: TTrayIcon;
    Image1: TImage;
    imlIcones: TImageList;
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    ArquivosController: IArquivoController;
    ListaDeJogos: TStringList;

    procedure PreencherMenu();
    procedure PreencherImageList();
    procedure LinkarImagemAoJogo();
  end;

var
  frmPrincipal: TfrmPrincipal;
const
  PASTA_RAIZ_JOGOS = 'D:\Jogos\Atalhos\';
implementation

{$R *.dfm}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  ArquivosController := TArquivoController.Create();

  PreencherMenu();
  PreencherImageList();
  LinkarImagemAoJogo();
end;

procedure TfrmPrincipal.LinkarImagemAoJogo;
begin
  for var I := 0 to Pred(pmJogos.Items.Count) do
    pmJogos.Items[I].ImageIndex := I;
end;

procedure TfrmPrincipal.PreencherImageList;
begin
  ArquivosController.PreencherImageList(imlIcones);
end;

procedure TfrmPrincipal.PreencherMenu;
begin
  ArquivosController.PreencherMenu(PASTA_RAIZ_JOGOS, pmJogos);
end;

procedure TfrmPrincipal.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ArquivosController.AbrirArquivo(ListaDeJogos[0]);
end;

end.
