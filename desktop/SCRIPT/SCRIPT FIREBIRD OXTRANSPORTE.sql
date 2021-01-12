CREATE TABLE mensalidade (
                           cod_mensalidade integer  NOT NULL ,
                           des_mensalidade VARCHAR(60)    ,
                           dom_ida CHAR(1) DEFAULT 'N',
                           dom_volta CHAR(1) DEFAULT 'N',
                           seg_ida CHAR(1) DEFAULT 'N',
                           seg_volta CHAR(1) DEFAULT 'N',
                           ter_ida CHAR(1) DEFAULT 'N',
                           ter_volta CHAR(1) DEFAULT 'N',
                           qua_ida CHAR(1) DEFAULT 'N',
                           qua_volta CHAR(1) DEFAULT 'N',
                           qui_ida CHAR(1) DEFAULT 'N',
                           qui_volta CHAR(1) DEFAULT 'N',
                           sex_ida CHAR(1) DEFAULT 'N',
                           sex_volta CHAR(1) DEFAULT 'N',
                           sab_ida CHAR(1) DEFAULT 'N',
                           sab_volta CHAR(1) DEFAULT 'N',
                           PRIMARY KEY(cod_mensalidade));




CREATE TABLE instituicao (
                           cod_instituicao integer  NOT NULL ,
                           des_instituicao VARCHAR(60)      ,
                           PRIMARY KEY(cod_instituicao));




CREATE TABLE funcionario (
                           cod_funcionario integer  NOT NULL ,
                           nome VARCHAR(80)    ,
                           endereco VARCHAR(200)    ,
                           fone VARCHAR(15)    ,
                           fone2 VARCHAR(15)    ,
                           cargo VARCHAR(80)      ,
                           PRIMARY KEY(cod_funcionario));




CREATE TABLE cobranca (
                        cod_cobranca integer  NOT NULL ,
                        valor NUMERIC(16,2)    ,
                        mes INTEGER    ,
                        ano INTEGER    ,
                        vencimento DATE      ,
                        PRIMARY KEY(cod_cobranca));




CREATE TABLE curso (
                     cod_curso integer  NOT NULL ,
                     des_curso VARCHAR(60)      ,
                     PRIMARY KEY(cod_curso));




CREATE TABLE despesa (
                       cod_despesa integer  NOT NULL ,
                       des_despesa VARCHAR(200)    ,
                       valor NUMERIC(16,2)    ,
                       mes_cobranca INTEGER    ,
                       ano_cobranca INTEGER    ,
                       tipo INTEGER      ,
                       PRIMARY KEY(cod_despesa));




CREATE TABLE despesa_cobrada (
                               cod_des INTEGER   NOT NULL ,
                               cod_cobranca INTEGER   NOT NULL ,
                               des_des VARCHAR(200)    ,
                               valor NUMERIC(16,2)    ,
                               vencimento DATE    ,
                               mes_cobranca INTEGER    ,
                               ano_cobranca INTEGER    ,
                               tipo INTEGER      ,
                               PRIMARY KEY(cod_des)  ,
                               FOREIGN KEY(cod_cobranca)
                                 REFERENCES cobranca(cod_cobranca));


CREATE INDEX despesa_cobrada_FKIndex1 ON despesa_cobrada (cod_cobranca);


CREATE INDEX IFK_Rel_despesas_cobranca ON despesa_cobrada (cod_cobranca);


CREATE TABLE socio (
                     cod_socio integer  NOT NULL ,
                     cod_mensalidade INTEGER   NOT NULL ,
                     cod_instituicao INTEGER   NOT NULL ,
                     cod_curso INTEGER   NOT NULL ,
                     nome VARCHAR(200)    ,
                     cpf VARCHAR(20)    ,
                     foto VARCHAR(200)    ,
                     endereco VARCHAR(200)    ,
                     fone VARCHAR(15)    ,
                     fone2 VARCHAR(15)    ,
                     email VARCHAR(200)    ,
                     data_cadastramento TIMESTAMP    ,
                     ativo CHAR(1) DEFAULT 'N',
                     mes INTEGER    ,
                     ano INTEGER      ,
                     PRIMARY KEY(cod_socio)      ,
                     FOREIGN KEY(cod_mensalidade)
                       REFERENCES mensalidade(cod_mensalidade),
                     FOREIGN KEY(cod_curso)
                       REFERENCES curso(cod_curso),
                     FOREIGN KEY(cod_instituicao)
                       REFERENCES instituicao(cod_instituicao));


CREATE INDEX passageiro_FKIndex1 ON socio (cod_mensalidade);
CREATE INDEX socio_FKIndex2 ON socio (cod_curso);
CREATE INDEX socio_FKIndex3 ON socio (cod_instituicao);


CREATE INDEX IFK_Rel_04 ON socio (cod_mensalidade);
CREATE INDEX IFK_Rel_05 ON socio (cod_curso);
CREATE INDEX IFK_Rel_06 ON socio (cod_instituicao);


CREATE TABLE fatura (
                      cod_fatura integer  NOT NULL ,
                      cod_socio INTEGER   NOT NULL ,
                      cod_cobranca INTEGER   NOT NULL ,
                      data_geracao TIMESTAMP    ,
                      data_pagamento TIMESTAMP    ,
                      valor NUMERIC(16,2)      ,
                      PRIMARY KEY(cod_fatura)    ,
                      FOREIGN KEY(cod_cobranca)
                        REFERENCES cobranca(cod_cobranca),
                      FOREIGN KEY(cod_socio)
                        REFERENCES socio(cod_socio));


CREATE INDEX fatura_FKIndex1 ON fatura (cod_cobranca);
CREATE INDEX fatura_FKIndex2 ON fatura (cod_socio);


CREATE INDEX IFK_rel_cob_fatura ON fatura (cod_cobranca);
CREATE INDEX IFK_Rel_03 ON fatura (cod_socio);


CREATE TABLE receita (
                       cod_receita integer  NOT NULL ,
                       cod_fatura INTEGER   NOT NULL ,
                       cod_funcionario INTEGER   NOT NULL ,
                       valor NUMERIC(16,2)    ,
                       data_pagamento TIMESTAMP      ,
                       PRIMARY KEY(cod_receita)    ,
                       FOREIGN KEY(cod_funcionario)
                         REFERENCES funcionario(cod_funcionario),
                       FOREIGN KEY(cod_fatura)
                         REFERENCES fatura(cod_fatura));


CREATE INDEX receita_FKIndex1 ON receita (cod_funcionario);
CREATE INDEX receita_FKIndex2 ON receita (cod_fatura);


CREATE INDEX IFK_Rel_07 ON receita (cod_funcionario);
CREATE INDEX IFK_Rel_08 ON receita (cod_fatura);


CREATE TABLE CONTROLE (
    TABELA  VARCHAR(100),
    CAMPO   VARCHAR(100),
    CODIGO  INTEGER
);


CREATE INDEX IDX_CAMPO ON CONTROLE (CAMPO);
CREATE INDEX IDX_CODIGO ON CONTROLE (CODIGO);
CREATE INDEX IDX_TABELA ON CONTROLE (TABELA);


CREATE OR ALTER PROCEDURE DELETA_CONTROLE (
    PE_NOME_TABLEA VARCHAR(1000),
    PE_NOME_CAMPO VARCHAR(1000),
    PE_CONTROLE INTEGER)
AS
DECLARE VARIABLE V_SQL VARCHAR(1000);
BEGIN
  v_sql = 'DELETE FROM CONTROLE WHERE TABELA =  ' || '''' ||  PE_NOME_TABLEA || '''' || '  AND CAMPO =  ' || '''' || PE_NOME_CAMPO || '''' || ' AND CODIGO = ' || PE_CONTROLE;
  EXECUTE STATEMENT v_sql;
  SUSPEND;
END;

CREATE OR ALTER PROCEDURE GET_CONTROLE (
    PE_CAMPO VARCHAR(50),
    PE_TABELA VARCHAR(50))
RETURNS (
    CODIGO_VALIDO DOUBLE PRECISION)
AS
DECLARE VARIABLE CONTADOR DOUBLE PRECISION;
DECLARE VARIABLE CODIGO_ATUAL DOUBLE PRECISION;
DECLARE VARIABLE CODIGO_PROX DOUBLE PRECISION;
DECLARE VARIABLE COLUNA CHAR(50);
DECLARE VARIABLE TABELA CHAR(50);
BEGIN
  /* Procedure PROC_CONTROL_SEQUENCE */
  CODIGO_ATUAL = 0;
  CODIGO_VALIDO = NULL;
  CONTADOR = 0;
  COLUNA = :PE_CAMPO;
  TABELA = :PE_TABELA;
  ------------------- SUGESTAO SEQUENCE TABELA CATEGORIA ---------------------
  FOR EXECUTE STATEMENT 'SELECT ' || COLUNA || ' FROM ' || TABELA || ' UNION ' || ' SELECT CODIGO FROM CONTROLE ' || ' WHERE upper(CAMPO) = ''' || :PE_CAMPO || ''' AND ' || ' UPPER(TABELA) = ''' || :PE_TABELA || ''' ORDER BY 1 '
          INTO :CODIGO_PROX
  DO
  BEGIN
    CONTADOR = CONTADOR + 1;
    IF ((CODIGO_PROX <> CODIGO_ATUAL + 1) AND
        (CODIGO_PROX <> 0)) THEN
    BEGIN
      CODIGO_VALIDO = CODIGO_ATUAL + 1;
      INSERT INTO CONTROLE (CODIGO, CAMPO, TABELA)
      VALUES (:CODIGO_VALIDO, :PE_CAMPO, :PE_TABELA);
      SUSPEND;
      BREAK;
    END
    ELSE
    BEGIN
      CODIGO_ATUAL = CODIGO_PROX;
    END
  END
  IF (CODIGO_VALIDO IS NULL) THEN
  BEGIN
    CODIGO_VALIDO = CODIGO_ATUAL + 1;
    INSERT INTO CONTROLE (CODIGO, CAMPO, TABELA)
    VALUES (:CODIGO_VALIDO, :PE_CAMPO, :PE_TABELA);
    SUSPEND;
  END
END;

CREATE TABLE CONFIG_RELATORIO (
    CABECALHO_TITULO VARCHAR(36),
    CABECALHO_LINHA1 VARCHAR(36),
    CABECALHO_LINHA2 VARCHAR(36),
    CABECALHO_LINHA3 VARCHAR(36));
