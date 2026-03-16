unit uIconeService;

interface

uses
  System.Classes, Winapi.Windows, Vcl.Graphics;

type
  TIconeService = class
    class function RedimensionarIcone(const Origem: TIcon; Largura,
      Altura: Integer): TBitMap;
  end;

implementation

{ TIconeService }

class function TIconeService.RedimensionarIcone(const Origem: TIcon; Largura, Altura: Integer): TBitMap;
begin
  Result := TBitmap.Create;

  Result.PixelFormat := pf32bit;
  Result.SetSize(Largura, Altura);

  Result.Canvas.Brush.Color := clNone;
  Result.Canvas.FillRect(Rect(0, 0, Largura, Altura));

  DrawIconEx(Result.Canvas.Handle, 0, 0, Origem.Handle, Largura, Altura, 0, 0, DI_NORMAL);
end;

end.
