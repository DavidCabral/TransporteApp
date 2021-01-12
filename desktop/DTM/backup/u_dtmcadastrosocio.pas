unit U_DtmCadastroSocio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, U_DtmPrincipal, U_Utils, U_Socio, sqldb, DB,
  U_Curso, U_Instituicao, U_Mensalidade, U_Viajem;

type

  { TDtmCadastroSocio }

  TDtmCadastroSocio = class(TDataModule)
    qryPesquisaViajem: TSQLQuery;
    qryPesquisaATIVO: TStringField;
    qryPesquisaCPF: TStringField;
    qryPesquisaDATA_CADASTRAMENTO: TDateField;
    qryPesquisaDES_CURSO: TStringField;
    qryPesquisaDES_INSTITUICAO: TStringField;
    qryPesquisaDES_MENSALIDADE: TStringField;
    qryPesquisaEMAIL: TStringField;
    qryPesquisaENDERECO: TStringField;
    qryPesquisaFONE: TStringField;
    qryPesquisaFONE2: TStringField;
    qryPesquisaNOME: TStringField;
    qryPesquisaViajemCPF: TStringField;
    qryPesquisaViajemDATA: TDateTimeField;
    qryPesquisaViajemDESC_OBS: TStringField;
    qryPesquisaViajemDESC_TIPO: TStringField;
    qryPesquisaViajemOBS: TLongintField;
    qryPesquisaViajemTIPO: TLongintField;
    qrySocio: TSQLQuery;
    qryPesquisa: TSQLQuery;
    procedure qryPesquisaViajemCalcFields(DataSet: TDataSet);
  private

  public
    function salvarViajem(pviajem: TViajem): boolean;
    function salvarSocio(pSocio: TSocio; pControle: TControle): boolean;
    function getSocio(pCpf: string): TSocio;
    function deleteSocio(pCpf: string): boolean;
    function carregaHstViajem(pCpf: string): boolean;
  end;

var
  DtmCadastroSocio: TDtmCadastroSocio;

implementation

{$R *.lfm}

{ TDtmCadastroSocio }

procedure TDtmCadastroSocio.qryPesquisaViajemCalcFields(DataSet: TDataSet);
begin
  if (qryPesquisaViajem.FieldByName('TIPO').AsInteger = 0) then
    qryPesquisaViajem.FieldByName('DESC_TIPO').AsString := 'Ida'
  else if (qryPesquisaViajem.FieldByName('TIPO').AsInteger = 1) then
    qryPesquisaViajem.FieldByName('DESC_TIPO').AsString := 'Volta';

  if (qryPesquisaViajem.FieldByName('OBS').AsInteger = 0) then
    qryPesquisaViajem.FieldByName('DESC_OBS').AsString := 'Normal'
  else if (qryPesquisaViajem.FieldByName('OBS').AsInteger = 1) then
    qryPesquisaViajem.FieldByName('DESC_OBS').AsString := 'Não era dia';
end;

function TDtmCadastroSocio.salvarViajem(pviajem: TViajem): boolean;
begin
  try
    qrySocio.Close;
    qrySocio.SQL.Text := 'UPDATE OR INSERT INTO HST_VIAJEM (CPF, DATA, TIPO, OBS) '#13 +
      'VALUES (:CPF, :DATA, :TIPO, :OBS)                       '#13 +
      'MATCHING (CPF, DATA, TIPO)                              ';

    qrySocio.ParamByName('CPF').AsString := pviajem.cpf;
    qrySocio.ParamByName('DATA').AsDateTime := pviajem.Data;
    qrySocio.ParamByName('TIPO').AsInteger := pviajem.tipo;
    qrySocio.ParamByName('OBS').AsInteger := pviajem.obs;
    qrySocio.ExecSQL;

    DtmPrincipal.FBTrans.CommitRetaining;
  except
    on E: Exception do
    begin
      Result := False;
      DtmPrincipal.FBTrans.RollbackRetaining;
      MsgErro('Ocorreu um erro ao salvar a viajem', E);
    end;
  end;
end;

function TDtmCadastroSocio.salvarSocio(pSocio: TSocio; pControle: TControle): boolean;
begin
  try
    qrySocio.Close;

    if (pControle = tpNovo) then
      qrySocio.SQL.Text :=
        ' INSERT INTO SOCIO (COD_MENSALIDADE, COD_INSTITUICAO, COD_CURSO, NOME, CPF, FOTO, ENDERECO, FONE, FONE2, '#13+
        '                    EMAIL, DATA_CADASTRAMENTO, ATIVO, MES, ANO, DATA_VALIDADE)                           '#13 +
        ' VALUES (:COD_MENSALIDADE, :COD_INSTITUICAO, :COD_CURSO, :NOME, :CPF, :FOTO, :ENDERECO, :FONE, :FONE2,   '#13 +
        '         :EMAIL, :DATA_CADASTRAMENTO, :ATIVO, :MES, :ANO, :DATA_VALIDADE)                                '
    else if (pControle = tpAlterar) then
      qrySocio.SQL.Text :=  '  UPDATE SOCIO                                  '#13 +
                            '  SET COD_MENSALIDADE = :COD_MENSALIDADE,       '#13 +
                            '      COD_INSTITUICAO = :COD_INSTITUICAO,       '#13 +
                            '      COD_CURSO = :COD_CURSO,                   '#13 +
                            '      NOME = :NOME,                             '#13 +
                            '      FOTO = :FOTO,                             '#13 +
                            '      ENDERECO = :ENDERECO,                     '#13 +
                            '      FONE = :FONE,                             '#13 +
                            '      FONE2 = :FONE2,                           '#13 +
                            '      EMAIL = :EMAIL,                           '#13 +
                            '      DATA_CADASTRAMENTO = :DATA_CADASTRAMENTO, '#13 +
                            '      ATIVO = :ATIVO,                           '#13 +
                            '      MES = :MES,                               '#13 +
                            '      ANO = :ANO,                               '#13 +
                            '      DATA_VALIDADE = :DATA_VALIDADE            '#13 +
                            '  WHERE CPF = :CPF                  '
    else if (pControle = tpConsulta) then
      qrySocio.SQL.Text :=
        ' UPDATE OR INSERT INTO SOCIO (COD_MENSALIDADE, COD_INSTITUICAO, COD_CURSO, NOME, CPF, FOTO, ENDERECO, FONE, FONE2, '#13+
        '                              EMAIL, DATA_CADASTRAMENTO, ATIVO, MES, ANO, DATA_VALIDADE)                           '#13+
        ' VALUES (:COD_MENSALIDADE, :COD_INSTITUICAO, :COD_CURSO, :NOME, :CPF, :FOTO, :ENDERECO, :FONE, :FONE2,             '#13+
        '         :EMAIL, :DATA_CADASTRAMENTO, :ATIVO, :MES, :ANO, :DATA_VALIDADE) MATCHING(CPF)                            ';

    qrySocio.ParamByName('COD_MENSALIDADE').AsInteger := pSocio.Mensalidade.codigo;
    qrySocio.ParamByName('COD_INSTITUICAO').AsInteger := pSocio.Instituicao.codigo;
    qrySocio.ParamByName('COD_CURSO').AsInteger := pSocio.Curso.codigo;
    qrySocio.ParamByName('NOME').AsString := pSocio.nome;
    qrySocio.ParamByName('CPF').AsString := pSocio.documento;

    if pSocio.foto <> nil then
    begin
      pSocio.foto.Seek(0, 0);
      qrySocio.ParamByName('FOTO').LoadFromStream(pSocio.foto, ftGraphic);
    end;

    qrySocio.ParamByName('ENDERECO').AsString := pSocio.endereco;
    qrySocio.ParamByName('FONE').AsString := pSocio.fone;
    qrySocio.ParamByName('FONE2').AsString := pSocio.fone2;
    qrySocio.ParamByName('EMAIL').AsString := pSocio.email;
    qrySocio.ParamByName('DATA_CADASTRAMENTO').AsDateTime := pSocio.dataCadastramento;
    if pSocio.ativo then
      qrySocio.ParamByName('ATIVO').AsString := 'S'
    else
      qrySocio.ParamByName('ATIVO').AsString := 'N';
    qrySocio.ParamByName('MES').AsInteger := pSocio.mes;
    qrySocio.ParamByName('ANO').AsInteger := pSocio.ano;
    qrySocio.ParamByName('DATA_VALIDADE').AsDateTime := pSocio.Validade;

    qrySocio.ExecSQL;

    DtmPrincipal.FBTrans.CommitRetaining;
  except
    on E: Exception do
    begin
      Result := False;
      DtmPrincipal.FBTrans.RollbackRetaining;
      MsgErro('Ocorreu um erro ao salvar o Socio', E);
    end;
  end;
end;

function TDtmCadastroSocio.getSocio(pCpf: string): TSocio;
var
  Socio: TSocio;
begin
  try
    qrySocio.Close;
    qrySocio.SQL.Text := 'SELECT M.COD_MENSALIDADE,   '#13 +
      '       M.DES_MENSALIDADE,   '#13 + '       I.COD_INSTITUICAO,   '#13 +
      '       I.DES_INSTITUICAO,   '#13 + '       C.COD_CURSO,         '#13 +
      '       C.DES_CURSO,         '#13 + '       NOME,                '#13 +
      '       CPF,                 '#13 + '       FOTO,                '#13 +
      '       ENDERECO,            '#13 + '       FONE,                '#13 +
      '       FONE2,               '#13 + '       EMAIL,               '#13 +
      '       DATA_CADASTRAMENTO,  '#13 + '       ATIVO,               '#13 +
      '       MES,                 '#13 + '       ANO,                 '#13 +
      '       S.DATA_VALIDADE      '#13 + 'FROM SOCIO S                '#13 +
      'LEFT JOIN CURSO C ON C.COD_CURSO = S.COD_CURSO '#13 +
      'LEFT JOIN INSTITUICAO I ON I.COD_INSTITUICAO = S.COD_INSTITUICAO '#13 +
      'LEFT JOIN MENSALIDADE M ON M.COD_MENSALIDADE = S.COD_MENSALIDADE '#13 +
      'WHERE CPF = :CPF';
    qrySocio.ParamByName('CPF').AsString := pCpf;
    qrySocio.Open;

    if not (qrySocio.IsEmpty) then
    begin
      Socio := TSocio.Create;
      Socio.Mensalidade := TMensalidade.Create;
      Socio.mensalidade.codigo := qrySocio.FieldByName('COD_MENSALIDADE').AsInteger;
      Socio.mensalidade.descicao := qrySocio.FieldByName('DES_MENSALIDADE').AsString;

      Socio.instituicao := TInstituicao.Create;
      Socio.instituicao.codigo := qrySocio.FieldByName('COD_INSTITUICAO').AsInteger;
      Socio.instituicao.descicao := qrySocio.FieldByName('DES_INSTITUICAO').AsString;

      Socio.curso := TCurso.Create;
      Socio.curso.codigo := qrySocio.FieldByName('COD_CURSO').AsInteger;
      Socio.curso.descicao := qrySocio.FieldByName('DES_CURSO').AsString;

      Socio.nome := qrySocio.FieldByName('NOME').AsString;
      Socio.documento := qrySocio.FieldByName('CPF').AsString;

      if not qrySocio.FieldByName('FOTO').IsNull then
      begin
        Socio.foto := TMemoryStream.Create;
        TBlobField(qrySocio.FieldByName('FOTO')).SaveToStream(Socio.foto);
        Socio.foto.Position := 0;
      end;

      Socio.endereco := qrySocio.FieldByName('ENDERECO').AsString;
      Socio.fone := qrySocio.FieldByName('FONE').AsString;
      Socio.fone2 := qrySocio.FieldByName('FONE2').AsString;
      Socio.email := qrySocio.FieldByName('EMAIL').AsString;
      Socio.dataCadastramento :=
        qrySocio.FieldByName('DATA_CADASTRAMENTO').AsDateTime;
      Socio.ativo := (Trim(qrySocio.FieldByName('ATIVO').AsString) = 'S');
      Socio.mes := qrySocio.FieldByName('MES').AsInteger;
      Socio.ano := qrySocio.FieldByName('ANO').AsInteger;
      Socio.Validade := qrySocio.FieldByName('DATA_VALIDADE').AsDateTime;
      Result := Socio;
    end
    else
      Result := nil;

  except
    on E: Exception do
    begin
      Result := nil;
      MsgErro('Ocorreu um erro ao pesquisar o Socio', E);
    end;
  end;
end;


function TDtmCadastroSocio.deleteSocio(pCpf: string): boolean;
begin
  try
    qrySocio.Close;
    qrySocio.SQL.Text := 'SELECT CPF FROM FATURA WHERE CPF = :CPF';
    qrySocio.ParamByName('CPF').AsString := pCpf;
    qrySocio.Open;

    if not qrySocio.IsEmpty then
    begin
      MsgAlerta('Existe débito relacionado com o sócio.' + #13 +
        'Operação não permitida.');
      Exit;
    end;

    qrySocio.Close;
    qrySocio.SQL.Text := 'SELECT CPF FROM HST_VIAJEM WHERE CPF = :CPF';
    qrySocio.ParamByName('CPF').AsString := pCpf;
    qrySocio.Open;

    if not qrySocio.IsEmpty then
    begin
      MsgAlerta('Existe histórico de viajem relacionado com o sócio.' +
        #13 + 'Operação não permitida.');
      Exit;
    end;

    qrySocio.Close;
    qrySocio.SQL.Text := 'DELETE FROM SOCIO WHERE CPF = :CPF';
    qrySocio.ParamByName('CPF').AsString := pCpf;
    qrySocio.ExecSQL;
    DtmPrincipal.FBTrans.CommitRetaining;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      DtmPrincipal.FBTrans.RollbackRetaining;
      MsgErro('Ocorreu um erro ao deletar o Socio.', E);
    end;
  end;
end;

function TDtmCadastroSocio.carregaHstViajem(pCpf: string): boolean;
begin
  try
    qryPesquisaViajem.Close;
    qryPesquisaViajem.SQL.Text :=
      'SELECT HST.CPF,        '#13 +
      '       HST.DATA,       '#13 +
      '       HST.TIPO,       '#13 +
      '       HST.OBS         '#13 +
      '  FROM HST_VIAJEM HST  '#13;

    if (pCpf <> '') then
    begin
      qryPesquisaViajem.SQL.Text :=
        qryPesquisaViajem.SQL.Text + #13 + 'WHERE HST.CPF = :CPF';
      qryPesquisaViajem.ParamByName('CPF').AsString := pCpf;
    end;

    qryPesquisaViajem.SQL.Text :=
      qryPesquisaViajem.SQL.Text + #13 + 'ORDER BY CPF, DATA, TIPO';
    qryPesquisaViajem.Open;
    Result := not qryPesquisaViajem.IsEmpty;
  except
    on E: Exception do
    begin
      Result := False;
      DtmPrincipal.FBTrans.RollbackRetaining;
      MsgErro('Ocorreu um erro ao Abrir Pesquisa de fatura.', E);
    end;
  end;
end;

end.
