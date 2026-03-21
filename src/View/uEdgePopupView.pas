unit uEdgePopupView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.WebView2, Winapi.ActiveX,
  Vcl.Edge, Vcl.StdCtrls;

type
  TEdgePopup = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private declarations }
    EdgeBrowser: TEdgeBrowser;
  public
    { Public declarations }
  end;

var
  EdgePopup: TEdgePopup;

implementation

{$R *.dfm}

procedure TEdgePopup.FormCreate(Sender: TObject);
begin
  EdgeBrowser := TEdgeBrowser.Create(Self);
  EdgeBrowser.Parent := Self;
  EdgeBrowser.Align := alClient;
  EdgeBrowser.Navigate('https://youtube.com');
end;

procedure TEdgePopup.FormDeactivate(Sender: TObject);
begin
  Hide;
end;

end.
