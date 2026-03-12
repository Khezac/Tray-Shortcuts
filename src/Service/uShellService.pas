unit uShellService;

interface

uses
  Winapi.Windows;

type
  TShellService = class
  public
    class procedure AbrirArquivo(Diretorio, NomeArquivo: string);
    class function PegarIconeDoArquivo(const pCaminhoAtalho: string): HICON; static;
  end;

implementation

{ TShellService }

uses
  ShellAPI, Winapi.ShlObj, Winapi.ActiveX, System.SysUtils;

class procedure TShellService.AbrirArquivo(Diretorio, NomeArquivo: string);
begin
  ShellExecute(0, 'open', PWideChar(Diretorio + NomeArquivo), '', PWideChar(NomeArquivo), SW_HIDE);
end;

class function TShellService.PegarIconeDoArquivo(const pCaminhoAtalho: string): HICON;
var ShellLink: IShellLink;
  PersistFile: IPersistFile;
  IconFile: array[0..MAX_PATH] of Char;
  IconIndex: Integer;
  WPath: WideString;
  hLarge, hSmall: HICON;
begin
  Result := 0;

  if not FileExists(pCaminhoAtalho) then
    Exit;

  if CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IID_IShellLink, ShellLink) = S_OK then
    begin
      PersistFile := ShellLink as IPersistFile;
      WPath := pCaminhoAtalho;

      if PersistFile.Load(PWideChar(WPath), STGM_READ) = S_OK then
        begin
          if ShellLink.GetIconLocation(IconFile, MAX_PATH, IconIndex) = S_OK then
            begin
              if ExtractIconEx(IconFile, IconIndex, hLarge, hSmall, 1) > 0 then
                begin
                  Result := hLarge;

                  if hSmall <> 0 then
                    DestroyIcon(hSmall);
                end;
            end;
        end;
    end;
end;

end.
