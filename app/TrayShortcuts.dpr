program TrayShortcuts;

uses
  Vcl.Forms,
  uPrin in '..\src\uPrin.pas' {frmPrincipal},
  uArquivoController in '..\src\Controllers\uArquivoController.pas',
  uArquivoModel in '..\src\Models\uArquivoModel.pas',
  uDiretorioModel in '..\src\Models\uDiretorioModel.pas',
  uInicializacao in '..\src\Infra\uInicializacao.pas',
  uShellService in '..\src\Service\uShellService.pas',
  uIconeService in '..\src\Service\uIconeService.pas',
  uArquivoService in '..\src\Service\uArquivoService.pas',
  uEdgePopupView in '..\src\View\uEdgePopupView.pas' {EdgePopup},
  uArquivoEdgePresenter in '..\src\Presenter\uArquivoEdgePresenter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TEdgePopup, EdgePopup);
  Application.Run;
end.
