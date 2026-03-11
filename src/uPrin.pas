unit uPrin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, ShellAPI, System.IOUtils, uArquivoController, Vcl.Menus,
  System.ImageList, Vcl.ImgList, Registry;

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
    ListaDeJogos: TStringList;

    procedure PreencherMenu();
    procedure PreencherImageList();
    procedure LinkarImagemAoJogo();
    procedure IniciarComWindows(pNomeDoApp, pDiretorioApp: string; pSomenteUmaVez: Boolean);
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

  IniciarComWindows(Application.Title, Application.ExeName, False);
end;

procedure TfrmPrincipal.LinkarImagemAoJogo;
begin
  for var I := 0 to Pred(pmJogos.Items.Count) do
    pmJogos.Items[I].ImageIndex := I;
end;

procedure TfrmPrincipal.pmJogosPopup(Sender: TObject);
begin
  Self.BringToFront();
  Self.Left := Mouse.CursorPos.X;
  Self.Top := Mouse.CursorPos.Y;
end;

procedure TfrmPrincipal.PreencherImageList;
begin
  ArquivosController.PreencherImageList(imlIcones);
end;

procedure TfrmPrincipal.PreencherMenu;
begin
  ArquivosController.PreencherMenu(PASTA_RAIZ_JOGOS, pmJogos);
end;

procedure TfrmPrincipal.IniciarComWindows(pNomeDoApp, pDiretorioApp: string;
  pSomenteUmaVez: Boolean);
begin
  const CAMINHO_REGISTRO = 'Software\Microsoft\Windows\CurrentVersion\Run';
  var reg := TRegistry.Create();
  try
    reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKey(CAMINHO_REGISTRO, True) then
      begin
        if pSomenteUmaVez then
          Reg.WriteString(pNomeDoApp, '"' + pDiretorioApp + '"')
        else
          Reg.DeleteValue(pNomeDoApp);

        Reg.CloseKey;
      end;
  finally
    reg.Free;
  end;
end;

end.
