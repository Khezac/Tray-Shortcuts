unit uIconeService;

interface

uses
  System.Classes, Winapi.Windows, Winapi.ShellAPI, Vcl.Graphics, System.SysUtils;

type
  TIconeService = class
    class function RedimensionarIcone(const Origem: TIcon; Largura,
      Altura: Integer): TBitMap;
    class function ExtrairIconeDeArquivo(const Caminho: string;
      Index: Integer = 0): TIcon;
  end;

implementation

{ TIconeService }

class function TIconeService.ExtrairIconeDeArquivo(const Caminho: string; Index: Integer = 0): TIcon;
var
  LargeIcon, SmallIcon: HICON;
begin
  Result := TIcon.Create;
  LargeIcon := 0;
  SmallIcon := 0;

  if ExtractIconEx(PChar(Caminho), Index, LargeIcon, SmallIcon, 1) > 0 then
  begin
    if LargeIcon <> 0 then
      Result.Handle := LargeIcon
    else if SmallIcon <> 0 then
      Result.Handle := SmallIcon
    else
      raise Exception.Create('Nenhum ícone encontrado');
  end
  else
    raise Exception.Create('Falha ao extrair ícone');
end;

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
