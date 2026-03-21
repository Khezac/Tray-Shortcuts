unit uPrin;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, System.IOUtils, uArquivoController, Vcl.Menus, System.ImageList,
  Vcl.ImgList, Vcl.ExtCtrls, uEdgePopupView, System.Types, Winapi.Windows,
  Winapi.Messages;

type
  TfrmPrincipal = class(TForm)
    pmJogos: TPopupMenu;
    TrayIcon1: TTrayIcon;
    Image1: TImage;
    imlIcones: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure pmJogosClose(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FecharEdgePopup(X, Y: Integer);
    procedure TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    EdgePopup: TEdgePopup;
    ArquivosController: IArquivoController;

    procedure PreencherMenu();
    function ClickForaHorizontal(X: Integer): Boolean;
    function ClickForaVertical(Y: Integer): Boolean;
  end;

  // Hook para capturar clicks do mouse globalmente
  PMSLLHOOKSTRUCT = ^MSLLHOOKSTRUCT;
  MSLLHOOKSTRUCT = record
    pt: TPoint;
    mouseData: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: ULONG_PTR;
  end;

var
  frmPrincipal: TfrmPrincipal;
  MouseHook: HHOOK = 0;

const
  PASTA_RAIZ_JOGOS = 'D:\Jogos\Atalhos\';
implementation

{$R *.dfm}

uses
  uInicializacao, Vcl.Dialogs;

function LowLevelMouseProc(
  nCode: Integer;
  wParam: WPARAM;
  lParam: LPARAM
): LRESULT; stdcall;
var
  Info: PMSLLHOOKSTRUCT;
begin
  Result := 0;

  if nCode <> HC_ACTION then
    Exit;

  Info := PMSLLHOOKSTRUCT(lParam);

  case wParam of
    WM_LBUTTONDOWN:
      begin
        frmPrincipal.FecharEdgePopup(Info.pt.X, Info.pt.Y);
      end;

    WM_RBUTTONDOWN:
      begin
        frmPrincipal.FecharEdgePopup(Info.pt.X, Info.pt.Y);
      end;
  end;

  Result := CallNextHookEx(MouseHook, nCode, wParam, lParam);
end;

function TfrmPrincipal.ClickForaHorizontal(X: Integer): Boolean;
begin
  Result := (X < EdgePopup.Left) or (X > (EdgePopup.Width + EdgePopup.Left));
end;

function TfrmPrincipal.ClickForaVertical(Y: Integer): Boolean;
begin
  Result := (Y < (EdgePopup.Top + EdgePopup.Height)) or (Y > EdgePopup.Top);
end;

procedure TfrmPrincipal.FecharEdgePopup(X, Y: Integer);
begin
  if ClickForaHorizontal(X) or
     ClickForaVertical(Y) and
     EdgePopup.Visible then
    begin
      EdgePopup.Hide();
    end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  ArquivosController := TArquivoController.Create();

  PreencherMenu();
  TInicializacaoComSistema.Ativar();

  EdgePopup := TEdgePopup.Create(Self);

  MouseHook := SetWindowsHookEx(
    WH_MOUSE_LL,
    @LowLevelMouseProc,
    HInstance,
    0
  );

  if MouseHook = 0 then
    RaiseLastOSError;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  UnhookWindowsHookEx(MouseHook);
end;

procedure TfrmPrincipal.pmJogosClose(Sender: TObject);
begin
  EdgePopup.Hide();
end;

procedure TfrmPrincipal.PreencherMenu;
begin
  ArquivosController.PreencherMenu(PASTA_RAIZ_JOGOS, pmJogos);
end;

procedure TfrmPrincipal.TrayIcon1DblClick(Sender: TObject);
begin
  Halt;
end;

procedure TfrmPrincipal.TrayIcon1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = TMouseButton.mbRight then
    begin
      EdgePopup.Show();
      EdgePopup.Left := Mouse.CursorPos.X - EdgePopup.Width;
      EdgePopup.Top := Mouse.CursorPos.Y - EdgePopup.Height;
      EdgePopup.BringToFront();
    end;
end;

end.
