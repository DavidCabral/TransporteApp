unit U_FrmRelSociosInadimplentes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, RLReport, RLPDFFilter,
  RLXLSXFilter, U_FrmRelatorioBase, db, sqldb, U_Utils, maskutils;

type

  { TFrmRelSociosInadimplentes }

  TFrmRelSociosInadimplentes = class(TFrmRelatorioBase)
    DSRelFaturas: TDataSource;
    QryRelFaturas: TSQLQuery;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBandContaTit: TRLBand;
    RLBandSocio: TRLBand;
    RLBandConta: TRLBand;
    RLBandSocioTit: TRLBand;
    RLBandTotalConta: TRLBand;
    rlbl_DatGeracao: TRLDBText;
    rlbl_DatVcto: TRLDBText;
    rlbl_QtdSocio: TRLLabel;
    rlbl_QtdTotalContas: TRLLabel;
    rlbl_TitAtivo: TRLLabel;
    rlbl_TitAtivo1: TRLLabel;
    rlbl_TitCPF: TRLLabel;
    rlbl_TitCurso: TRLLabel;
    rlbl_TitEmail: TRLLabel;
    rlbl_TitEnde: TRLLabel;
    rlbl_TitFone: TRLLabel;
    rlbl_TitInsti: TRLLabel;
    rlbl_TitMensa: TRLLabel;
    rlbl_TitNome: TRLLabel;
    rlbl_ValGeralConta: TRLLabel;
    rldb_Email1: TRLDBText;
    rldb_Nome: TRLDBText;
    rldb_Endereco: TRLDBText;
    rldb_Email: TRLDBText;
    RlGroupSocio: TRLGroup;
    rlbl_CPF: TRLLabel;
    rlbl_TitMesAno: TRLLabel;
    rlbl_TitDatGeracao: TRLLabel;
    rlbl_TitDatVcto: TRLLabel;
    rlbl_TitValor: TRLLabel;
    rlbl_Ativo: TRLLabel;
    rlbl_Mensalidade: TRLLabel;
    rlbl_Instituicao: TRLLabel;
    rlbl_Curso: TRLLabel;
    rlbl_MesAno: TRLLabel;
    rlbl_Valor: TRLLabel;
    rlbl_QtdConta: TRLLabel;
    rlbl_ValTotalConta: TRLLabel;
    rlbl_fone: TRLLabel;
    rlbl_FiltroStatus: TRLLabel;
    rlbl_qtdFatIndividual: TRLLabel;
    rlbl_ValTotalIndividual: TRLLabel;
    RLSubDtContas: TRLSubDetail;
    procedure FormCreate(Sender: TObject);
    procedure RLBand1BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBandContaBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBandSocioBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBandTotalContaBeforePrint(Sender: TObject; var PrintIt: Boolean
      );
    procedure RlGroupSocioBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    giQtdConta,giQtdSocio,giQtdGeralConta:Integer;
    gdValTotalConta, gdValGeralConta:Double;
    function carregaFaturas(strCPF:String;pListarFaturas:Boolean):boolean;
  public
    gbListaFaturas:Boolean;
    gbInadimplencia:Boolean;
    function carregaRelatorio(strFiltroSql:String):boolean;
  end;

var
  FrmRelSociosInadimplentes: TFrmRelSociosInadimplentes;

implementation

{$R *.lfm}

{ TFrmRelSociosInadimplentes }

procedure TFrmRelSociosInadimplentes.RLBandSocioBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  rlbl_CPF.Caption:= formataCpfCnpj(Trim(QryRel.FieldByName('CPF').AsString));

  if Trim(QryRel.FieldByName('ATIVO').AsString) = 'S' then
  begin
     rlbl_Ativo.Font.Color:= clBlue;
     rlbl_Ativo.Caption:= 'Ativo'
  end
  else
  begin
    rlbl_Ativo.Font.Color:= clRed;
    rlbl_Ativo.Caption:= 'Inativo';
  end;

  rlbl_Mensalidade.Caption:= Trim(QryRel.FieldByName('COD_MENSALIDADE').AsString) + ' - ' + Trim(QryRel.FieldByName('DES_MENSALIDADE').AsString);
  rlbl_Instituicao.Caption:= Trim(QryRel.FieldByName('COD_INSTITUICAO').AsString) + ' - ' + Trim(QryRel.FieldByName('DES_INSTITUICAO').AsString);
  rlbl_Curso.Caption:= Trim(QryRel.FieldByName('COD_CURSO').AsString) + ' - ' + Trim(QryRel.FieldByName('DES_CURSO').AsString);

  giQtdSocio:=giQtdSocio+1;

  if Length(Trim(QryRel.FieldByName('FONE').AsString)) = 10 then
    rlbl_fone.Caption := FormatmaskText('\(00\)0000\-0000;0;',QryRel.FieldByName('FONE').AsString)
  else if Length(Trim(QryRel.FieldByName('FONE').AsString)) = 11 then
    rlbl_fone.Caption := FormatmaskText('\(00\)00000\-0000;0;',QryRel.FieldByName('FONE').AsString)
  else
    rlbl_fone.Caption := QryRel.FieldByName('FONE').AsString;

  if gbListaFaturas then
  begin
     RLBandSocio.Height:=36;
     rlbl_qtdFatIndividual.Caption:= '';
     rlbl_ValTotalIndividual.Caption:= '';
  end
  else
  begin
    RLBandSocio.Height:=53;
    rlbl_qtdFatIndividual.Caption:= 'Qtd. Faturas: ' + FormatFloat('#,#00',QryRelFaturas.FieldByName('QTD').AsInteger);
    rlbl_ValTotalIndividual.Caption:= 'Valor Total: ' + FormatFloat('#,##0.00',QryRelFaturas.FieldByName('VALOR').AsFloat);
    giQtdGeralConta:= giQtdGeralConta + QryRelFaturas.FieldByName('QTD').AsInteger;
    gdValGeralConta:=gdValGeralConta + QryRelFaturas.FieldByName('VALOR').AsFloat;
  end;
end;

procedure TFrmRelSociosInadimplentes.RLBandTotalContaBeforePrint(
  Sender: TObject; var PrintIt: Boolean);
begin
  rlbl_QtdConta.Caption:= 'Qtd. Faturas: ' + FormatFloat('#,#00',giQtdConta);
  rlbl_ValTotalConta.Caption:= 'Valor Total: ' + FormatFloat('#,##0.00',gdValTotalConta);
end;

procedure TFrmRelSociosInadimplentes.RLBandContaBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  rlbl_MesAno.Caption:= FormatFloat('00',QryRelFaturas.FieldByName('MES').AsInteger)+'/'+QryRelFaturas.FieldByName('ANO').AsString;
  rlbl_Valor.Caption:=FormatFloat('#,##0.00',QryRelFaturas.FieldByName('VALOR').AsFloat);
  giQtdConta:=giQtdConta+1;
  giQtdGeralConta:=giQtdGeralConta+1;
  gdValTotalConta:=gdValTotalConta+QryRelFaturas.FieldByName('VALOR').AsFloat;
  gdValGeralConta:=gdValGeralConta+QryRelFaturas.FieldByName('VALOR').AsFloat;
end;

procedure TFrmRelSociosInadimplentes.RLBand1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  rlbl_QtdSocio.Caption:= 'Qtd. Sócio: ' + FormatFloat('#,#00',giQtdSocio);
  rlbl_QtdTotalContas.Caption:= 'Qtd. Total Faturas: ' + FormatFloat('#,#00',giQtdGeralConta);
  rlbl_ValGeralConta.Caption:= 'Total Geral: ' + FormatFloat('#,##0.00',gdValGeralConta);
end;

procedure TFrmRelSociosInadimplentes.FormCreate(Sender: TObject);
begin
  inherited;
  gbListaFaturas := False;
  gbInadimplencia := True;
end;

procedure TFrmRelSociosInadimplentes.RlGroupSocioBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
    giQtdConta:=0;
    gdValTotalConta:=0;
    if gbListaFaturas then
    begin
       RLSubDtContas.Visible:= carregaFaturas(QryRel.FieldByName('CPF').AsString,gbListaFaturas);
    end
    else
    begin
      carregaFaturas(QryRel.FieldByName('CPF').AsString,gbListaFaturas);
      RLSubDtContas.Visible:=False;
    end;
end;

procedure TFrmRelSociosInadimplentes.RLReport1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  giQtdSocio:=0;
  gdValGeralConta:=0;
  giQtdGeralConta:=0;
end;

function TFrmRelSociosInadimplentes.carregaFaturas(strCPF: String;
  pListarFaturas: Boolean): boolean;
begin
  try
    QryRelFaturas.Close;
     if not pListarFaturas then
     begin
        QryRelFaturas.SQL.Text := 'SELECT F.CPF, '#13 +
          '       Count(*) AS QTD,               '#13 +
          '       SUM(F.VALOR) AS VALOR          '#13 +
          'FROM FATURA F                         '#13 +
          'WHERE F.CPF = :CPF                    '#13;
        if gbInadimplencia then
          QryRelFaturas.SQL.Add('AND F.DATA_PAGAMENTO IS NULL AND F.VENCIMENTO < CURRENT_DATE');
        QryRelFaturas.SQL.Add('GROUP BY 1');
     end
     else
     begin
       QryRelFaturas.SQL.Text := 'SELECT F.CPF, '#13 +
         '       F.MES,               '#13 +
         '       F.ANO,               '#13 +
         '       F.DATA_GERACAO,      '#13 +
         '       F.VENCIMENTO,        '#13 +
         '       F.DATA_PAGAMENTO,    '#13 +
         '       F.VALOR              '#13 +
         'FROM FATURA F               '#13 +
         'WHERE F.CPF = :CPF          '#13;
         if gbInadimplencia then
           QryRelFaturas.SQL.Add('AND F.DATA_PAGAMENTO IS NULL AND F.VENCIMENTO < CURRENT_DATE');
         QryRelFaturas.SQL.Add('ORDER BY ANO DESC, MES DESC ');
     end;

     QryRelFaturas.ParamByName('CPF').AsString:= strCPF;
     QryRelFaturas.Open;

     Result := not QryRel.IsEmpty;

  Except
    On E:Exception do
    begin
      Result := false;
      MsgErro('Ocorreu um erro ao carregar relatório de inadimplência',E);
    end;
  end;
end;

function TFrmRelSociosInadimplentes.carregaRelatorio(strFiltroSql: String
  ): boolean;
begin
  try
    QryRel.Close;
    QryRel.SQL.Text := 'SELECT M.COD_MENSALIDADE,   '#13 +
      '       M.DES_MENSALIDADE,   '#13 +
      '       I.COD_INSTITUICAO,   '#13 +
      '       I.DES_INSTITUICAO,   '#13 +
      '       C.COD_CURSO,         '#13 +
      '       C.DES_CURSO,         '#13 +
      '       S.NOME,              '#13 +
      '       S.CPF,               '#13 +
      '       S.ENDERECO,          '#13 +
      '       S.FONE,              '#13 +
      '       S.EMAIL,             '#13 +
      '       S.ATIVO,             '#13 +
      '       S.DATA_VALIDADE      '#13 +
      'FROM SOCIO S                '#13 +
      'LEFT JOIN CURSO C ON C.COD_CURSO = S.COD_CURSO '#13 +
      'LEFT JOIN INSTITUICAO I ON I.COD_INSTITUICAO = S.COD_INSTITUICAO '#13+
      'LEFT JOIN MENSALIDADE M ON M.COD_MENSALIDADE = S.COD_MENSALIDADE '#13+
      'WHERE 1=1                                                        '#13+
       strFiltroSql+#13;

     if gbInadimplencia then
        QryRel.SQL.Add(' AND EXISTS (SELECT F.CPF FROM FATURA F WHERE F.DATA_PAGAMENTO IS NULL AND F.VENCIMENTO < CURRENT_DATE AND F.CPF = S.CPF) '+#13);

    QryRel.SQL.Add('ORDER BY NOME');
    QryRel.Open;

    Result := not QryRel.IsEmpty;

  Except
    On E:Exception do
    begin
      Result := false;
      MsgErro('Ocorreu um erro ao carregar relatório de inadimplência',E);
    end;
  end;
end;

end.

