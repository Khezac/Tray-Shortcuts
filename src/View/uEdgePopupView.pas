unit uEdgePopupView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.WebView2, Winapi.ActiveX,
  Vcl.Edge, Vcl.StdCtrls, System.JSON;

const
  WM_EDGEPOPUP_GLOBALCLICK = WM_USER + 100;

type
  TEdgePopup = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FJsonAplicativos: TJsonObject;
    EdgeBrowser: TEdgeBrowser;

    procedure ProcessaMessageGlobalClick(var Msg: TMessage); message WM_EDGEPOPUP_GLOBALCLICK;
    procedure EdgeBrowserNavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: TOleEnum);
    procedure SetJson(const Value: TJsonObject);

    function ClickForaHorizontal(X: Integer): Boolean;
    function ClickForaVertical(Y: Integer): Boolean;
    function GetJson: TJsonObject;
  public
    procedure Navegar(pURL: string);
    procedure FecharEdgePopup(X, Y: Integer);

    property JsonAplicativos: TJsonObject read GetJson write SetJson;
  end;

var
  EdgePopup: TEdgePopup;
const
  PASTA_RAIZ_JOGOS = 'D:\Jogos\Atalhos\';
implementation

{$R *.dfm}

procedure TEdgePopup.FormCreate(Sender: TObject);
begin
  EdgeBrowser := TEdgeBrowser.Create(Self);
  EdgeBrowser.Parent := Self;
  EdgeBrowser.Align := alClient;
  EdgeBrowser.OnNavigationCompleted := EdgeBrowserNavigationCompleted;
end;

procedure TEdgePopup.FormDestroy(Sender: TObject);
begin
  JsonAplicativos.Free();
end;

function TEdgePopup.GetJson: TJsonObject;
begin
  Result := FJsonAplicativos;
end;

procedure TEdgePopup.Navegar(pURL: string);
begin
  EdgeBrowser.Navigate(pURL);
end;

procedure TEdgePopup.EdgeBrowserNavigationCompleted(
  Sender: TCustomEdgeBrowser;
  IsSuccess: Boolean;
  WebErrorStatus: TOleEnum);
var
  JsonStr: string;
  PW: PWideChar;
begin
  if not IsSuccess then
    Exit;

  JsonStr := FJsonAplicativos.ToJSON;
  PW := PWideChar(JsonStr);

  EdgeBrowser.DefaultInterface.PostWebMessageAsJson(PW);
end;

procedure TEdgePopup.ProcessaMessageGlobalClick(var Msg: TMessage);
begin
  FecharEdgePopup(Msg.WParam, Msg.LParam);
end;

procedure TEdgePopup.SetJson(const Value: TJsonObject);
begin
  if FJsonAplicativos <> Value then
    begin
      FJsonAplicativos.Free();
      FJsonAplicativos := Value;
    end;
end;

function TEdgePopup.ClickForaHorizontal(X: Integer): Boolean;
begin
  var DistanciaEsquerda := Left - Screen.MonitorFromWindow(Handle).Left;
  Result := (X < DistanciaEsquerda) or (X > (EdgePopup.Width + DistanciaEsquerda));
end;

function TEdgePopup.ClickForaVertical(Y: Integer): Boolean;
begin
  var DistanciaAcima := Top - Screen.MonitorFromWindow(Handle).Top;
  Result := (Y < DistanciaAcima) or (Y > (EdgePopup.Height + DistanciaAcima));
end;

procedure TEdgePopup.FecharEdgePopup(X, Y: Integer);
begin
  if Visible and
    (ClickForaHorizontal(X) or
    ClickForaVertical(Y)) then
    begin
      Self.Hide();
    end;
end;

end.
