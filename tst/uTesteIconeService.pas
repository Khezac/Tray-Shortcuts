unit uTesteIconeService;

interface

uses
  DUnitX.TestFramework, System.SysUtils, Winapi.Windows, Vcl.Graphics,
  System.Classes, uIconeService;

type
  [TestFixture]
  TTesteIconeService = class
  public

    [Test]
    procedure DeveRedimensionarIcone();

  end;

implementation

{ TTesteIconeService }

procedure TTesteIconeService.DeveRedimensionarIcone;
var
  Icone: TIcon;
  Bitmap: TBitmap;
begin
  Icone := TIcon.Create;
  try
    Icone := TIconeService.ExtrairIconeDeArquivo(
      'C:\Windows\System32\shell32.dll', 0
    );

    Bitmap := TIconeService.RedimensionarIcone(Icone, 32, 32);
    try
      Assert.IsNotNull(Bitmap, 'Bitmap não foi criado');
      Assert.AreEqual(32, Bitmap.Width, 'Largura incorreta');
      Assert.AreEqual(32, Bitmap.Height, 'Altura incorreta');
      Assert.AreEqual(pf32bit, Bitmap.PixelFormat, 'PixelFormat incorreto');
    finally
      Bitmap.Free;
    end;
  finally
    Icone.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteIconeService);

end.
