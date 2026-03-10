unit uArquivoModel;

interface

uses
  System.Classes, Winapi.Windows, ShellAPI, System.IOUtils, Winapi.ShlObj,
  System.SysUtils, Winapi.ActiveX, Vcl.Graphics;

type
  IArquivo = interface
    ['{6EFF383B-8141-458F-9A76-034F1388678C}']
    function UltimaOcorrenciaDoCaracter(Char, Texto: string): integer;

    procedure AbrirArquivo(NomeArquivo: string);

    function GetNome(): string;
    function GetDiretorio(): string;
    function GetIcon(): TBitMap;

    procedure SetDiretorio(Value: string);
    procedure SetIcon(Value: TBitMap);

    property Nome: string read GetNome;
    property Diretorio: string read GetDiretorio write SetDiretorio;
    property Icone: TBitMap read GetIcon write SetIcon;
  end;

  TArquivo = class(TInterfacedObject, IArquivo)
  private
    FDiretorio: string;
    FIcon: TBitMap;

    procedure SetDiretorio(Value: string);
    procedure SetIcon(Value: TBitMap);
    
    function GetNome(): string;
    function GetDiretorio(): string;
    function GetIcon(): TBitMap;

    function UltimaOcorrenciaDoCaracter(Char, Texto: string): integer;
  public
    procedure AbrirArquivo(NomeArquivo: string);

    property Nome: string read GetNome;
    property Diretorio: string read GetDiretorio write SetDiretorio;
    property Icone: TBitMap read GetIcon write SetIcon;
  end;

implementation

{ TArquivo }

procedure TArquivo.AbrirArquivo(NomeArquivo: string);
begin
  ShellExecute(0, 'open', PWideChar(NomeArquivo), '', PWideChar(NomeArquivo), SW_HIDE);
end;

function TArquivo.GetDiretorio: string;
begin
  Result := FDiretorio;
end;

function TArquivo.GetIcon: TBitMap;
begin
  Result := FIcon;
end;

function TArquivo.GetNome: string;
var
  LastBarPos: integer;
  DotPos: integer;
begin
  LastBarPos := UltimaOcorrenciaDoCaracter('\', FDiretorio);
    
  Result := Copy(FDiretorio, LastBarPos + 1, (Length(FDiretorio) - LastBarPos));

  DotPos := UltimaOcorrenciaDoCaracter('.', Result);

  Delete(Result, DotPos, Length(Result));
end;

function TArquivo.UltimaOcorrenciaDoCaracter(Char, Texto: string): integer;
var
  BarPos: Integer;
begin
  Result := Pos(Char, Texto, 1);
  BarPos := Result;
  
  while BarPos <> 0 do
    begin
      BarPos := Pos(Char, Texto, BarPos + 1);
      if BarPos <> 0 then
        Result := BarPos;
    end;
end;

procedure TArquivo.SetDiretorio(Value: string);
begin
  FDiretorio := Value;
end;

procedure TArquivo.SetIcon(Value: TBitMap);
begin
  FIcon := Value;
end;

end.
