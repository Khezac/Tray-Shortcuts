program TrayShortcuts;

uses
  Vcl.Forms,
  uPrin in '..\src\uPrin.pas' {frmPrincipal},
  uArquivoController in '..\src\Controllers\uArquivoController.pas',
  uArquivoModel in '..\src\Models\uArquivoModel.pas',
  uDiretorioModel in '..\src\Models\uDiretorioModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
