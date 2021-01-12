unit U_FrmRelatorioBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, RLReport, RLPDFFilter, RLXLSXFilter,
  Forms, Controls, Graphics, Dialogs, IniFiles, U_Utils, U_DtmPrincipal;


type

  { TFrmRelatorioBase }

  TFrmRelatorioBase = class(TForm)
    DSRel: TDataSource;
    rlBandFooter: TRLBand;
    rlBandCabecalho: TRLBand;
    rlBandTitulo: TRLBand;
    RlblTitulo: TRLLabel;
    RlImg1: TRLImage;
    RlImg2: TRLImage;
    rlbl_CabeTitulo: TRLLabel;
    rlbl_CabeLinha1: TRLLabel;
    rlbl_CabeLinha3: TRLLabel;
    rlbl_CabeLinha2: TRLLabel;
    RLPDFFilter1: TRLPDFFilter;
    RLReport1: TRLReport;
    RLSystemInfo1: TRLSystemInfo;
    RLXLSXFilter1: TRLXLSXFilter;
    QryRel: TSQLQuery;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FrmRelatorioBase: TFrmRelatorioBase;

implementation

{$R *.lfm}

{ TFrmRelatorioBase }

procedure TFrmRelatorioBase.FormCreate(Sender: TObject);
var
  I: TIniFile;
begin
  try
    I := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

    if FileExists(I.ReadString('BANCO', 'LOGO1', '')) then
    begin
      if FileExists(I.ReadString('BANCO', 'LOGO2', '')) then
      begin
        RlImg2.Picture.LoadFromFile(I.ReadString('BANCO', 'LOGO2', ''));
      end
      else
        RlImg2.Picture.LoadFromFile(I.ReadString('BANCO', 'LOGO1', ''));

      RlImg1.Picture.LoadFromFile(I.ReadString('BANCO', 'LOGO1', ''));
    end
    else if FileExists(I.ReadString('BANCO', 'LOGO2', '')) then
    begin
      RlImg1.Picture.LoadFromFile(I.ReadString('BANCO', 'LOGO2', ''));
      RlImg2.Picture.LoadFromFile(I.ReadString('BANCO', 'LOGO2', ''));
    end;

  finally
    i.Free;
  end;

  try
     QryRel.Close;
     QryRel.SQL.Text := 'SELECT CODIGO,           '#13+
                        '       CABECALHO_TITULO, '#13+
                        '       CABECALHO_LINHA1, '#13+
                        '       CABECALHO_LINHA2, '#13+
                        '       CABECALHO_LINHA3  '#13+
                        'FROM CONFIG_RELATORIO    '#13+
                        'ORDER BY CODIGO ';
     QryRel.Open;

     rlbl_CabeTitulo.Caption:= QryRel.FieldByName('CABECALHO_TITULO').AsString;
     rlbl_CabeLinha1.Caption:= QryRel.FieldByName('CABECALHO_LINHA1').AsString;
     rlbl_CabeLinha2.Caption:= QryRel.FieldByName('CABECALHO_LINHA2').AsString;
     rlbl_CabeLinha3.Caption:= QryRel.FieldByName('CABECALHO_LINHA3').AsString;

     QryRel.Close;
  except
    on E:Exception do
    begin
         MsgErro('Ocorreu um erro ao carregar o cabeçalho do relatório.',E);
    end;
  end;
end;

end.

