unit U_frmrelcarteirinhasocioTodas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ubarcodes, RLReport, RLBarcode, RLPDFFilter,
  Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, sqldb, db,
  U_DtmPrincipal, U_Utils, IniFiles;

type

  { TfrmrelcarteirinhasocioTodas }

  TfrmrelcarteirinhasocioTodas = class(TForm)
    DSCarteirinha: TDataSource;
    qryCarteirinha: TSQLQuery;
    rlblCurso: TRLLabel;
    rlblCurso1: TRLLabel;
    rlblDataValidade: TRLLabel;
    rlblInstituicao: TRLLabel;
    rlblInstituicao1: TRLLabel;
    rlblNome: TRLLabel;
    rlblNome1: TRLLabel;
    rlblNome2: TRLLabel;
    RLDBText1: TRLDBText;
    RLDetailGrid1: TRLDetailGrid;
    rlImgLogo: TRLImage;
    RLImage3: TRLImage;
    rlImgFoto: TRLImage;
    rlimgqrcode: TRLImage;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLPanel1: TRLPanel;
    RLPDFFilter1: TRLPDFFilter;
    RLReport1: TRLReport;
    procedure RLDetailGrid1BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private

  public

    function CarregaCarteirinhas(listSocios:TListBox):Boolean;

  end;

var
  frmrelcarteirinhasocioTodas: TfrmrelcarteirinhasocioTodas;

implementation

{$R *.lfm}

{ TfrmrelcarteirinhasocioTodas }



procedure TfrmrelcarteirinhasocioTodas.RLDetailGrid1BeforePrint(
  Sender: TObject; var PrintIt: Boolean);
var
  loQRCode:TBarcodeQR;
  bmp: TBitmap;
  R: TRect;
  st:TMemoryStream;
begin
  with qryCarteirinha do
  begin
    rlblNome.Caption:= FieldByName('NOME').AsString;
    rlblInstituicao.Caption:= FieldByName('SIG_INSTITUICAO').AsString;
    rlblCurso.Caption:= FieldByName('DES_CURSO').AsString;
    rlblDataValidade.Caption:= copy(FieldByName('DATA_VALIDADE').AsString,4,length(FieldByName('DATA_VALIDADE').AsString));

     //gerando QRCode;
     loQRCode := TBarcodeQR.Create(Self);
     bmp := TBitmap.Create;
     try
       loQRCode.Text:= FieldByName('CPF').AsString;
       loQRCode.Generate;

       R := Rect(0, 0, 90, 90);
       bmp.SetSize(90, 90);
       bmp.Canvas.Brush.Color := clWhite;
       bmp.Canvas.FillRect(R);
       loQRCode.PaintOnCanvas(bmp.Canvas, R);
       rlimgqrcode.Picture.Bitmap := bmp;

     finally
       bmp.Free;
       FreeAndNil(loQRCode);
     end;

     //foto
     if not FieldByName('FOTO').IsNull then
     begin
       st := TMemoryStream.Create;
       try
         TBlobField(FieldByName('FOTO')).SaveToStream(st);
         st.Position:= 0;
         rlImgFoto.Picture.LoadFromStream(st);
       finally
         st.Free;
       end;
     end
     else
     begin
        rlImgFoto.Picture.Clear;
     end;

  end;
end;

procedure TfrmrelcarteirinhasocioTodas.RLReport1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  I: TIniFile;
begin
  try
    I := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

    if FileExists(I.ReadString('BANCO', 'LOGO_CARTEIRA', '')) then
    begin
      rlImgLogo.Picture.LoadFromFile(I.ReadString('BANCO', 'LOGO_CARTEIRA', ''));
    end;

  finally
    i.Free;
  end;
end;

function TfrmrelcarteirinhasocioTodas.CarregaCarteirinhas(listSocios: TListBox
  ): Boolean;
var
  liCont:Integer;
  lsCondicao:String;
begin
  try

    qryCarteirinha.Close;
    qryCarteirinha.SQL.Text := 'SELECT M.COD_MENSALIDADE,   '#13 +
      '       M.DES_MENSALIDADE,   '#13 +
      '       I.COD_INSTITUICAO,   '#13 +
      '       I.SIG_INSTITUICAO,   '#13 +
      '       I.DES_INSTITUICAO,   '#13 +
      '       C.COD_CURSO,         '#13 +
      '       C.DES_CURSO,         '#13 +
      '       NOME,                '#13 +
      '       CPF,                 '#13 +
      '       FOTO,                '#13 +
      '       ENDERECO,            '#13 +
      '       FONE,                '#13 +
      '       FONE2,               '#13 +
      '       EMAIL,               '#13 +
      '       DATA_CADASTRAMENTO,  '#13 +
      '       ATIVO,               '#13 +
      '       MES,                 '#13 +
      '       ANO,                 '#13 +
      '       S.DATA_VALIDADE      '#13 +
      'FROM SOCIO S                '#13 +
      'LEFT JOIN CURSO C ON C.COD_CURSO = S.COD_CURSO '#13 +
      'LEFT JOIN INSTITUICAO I ON I.COD_INSTITUICAO = S.COD_INSTITUICAO '#13 +
      'LEFT JOIN MENSALIDADE M ON M.COD_MENSALIDADE = S.COD_MENSALIDADE '#13;

    if listSocios.Count > 0 then
    begin
         for liCont := 0 to listSocios.Count -1 do
         begin
              lsCondicao:= removeCharEsp(listSocios.Items.Strings[liCont]) + ',';
         end;

         lsCondicao:= '('+copy(lsCondicao,1,length(lsCondicao)-1)+')';

         qryCarteirinha.SQL.Add('WHERE S.CPF IN ' + lsCondicao);
    end;

    qryCarteirinha.SQL.Add('ORDER BY NOME');

    qryCarteirinha.Open;

    Result := not qryCarteirinha.IsEmpty;
  Except
    On E:Exception do
    begin
      Result := false;
      MsgErro('Ocorreu um erro ao gerar carteirinhas',E);
    end;
  end;
end;

end.

