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
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    EdgePopup: TEdgePopup;
    ArquivosController: IArquivoController;

    procedure ConfigurarMouseHook;
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
begin
  if nCode = HC_ACTION then
    begin
      var Info := PMSLLHOOKSTRUCT(lParam);

      if (wParam = WM_LBUTTONDOWN) or (wParam = WM_RBUTTONDOWN) then
        begin
          if (Assigned(frmPrincipal)) and (Assigned(frmPrincipal.EdgePopup)) then
            begin
              PostMessage(
                frmPrincipal.EdgePopup.Handle,
                WM_EDGEPOPUP_GLOBALCLICK,
                Info.pt.X,
                Info.pt.Y
              );
            end;
        end;
    end;

  Result := CallNextHookEx(MouseHook, nCode, wParam, lParam);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  ArquivosController := TArquivoController.Create();
  EdgePopup := TEdgePopup.Create(Self);

  ConfigurarMouseHook();
  TInicializacaoComSistema.Ativar();
end;

procedure TfrmPrincipal.ConfigurarMouseHook();
begin
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

      ArquivosController.PreencherEdgePopup(PASTA_RAIZ_JOGOS, EdgePopup);
      EdgePopup.Navegar(Format('file:///%s/../../../../src/View/Web/uEdgePopupView.html', [ExtractFilePath(Application.ExeName)]));
    end;
end;

end.
