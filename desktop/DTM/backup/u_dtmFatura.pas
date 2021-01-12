unit U_DtmFatura;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, U_Utils, U_DtmPrincipal,
  U_Fatura;

type

  { TDtmFatura }

  TDtmFatura = class(TDataModule)
    qryFatura: TSQLQuery;
    qryPesquisa: TSQLQuery;
    qryPesquisaANO: TLongintField;
    qryPesquisaCOD_COBRANCA: TLongintField;
    qryPesquisaCOD_FATURA: TLongintField;
    qryPesquisaCPF: TStringField;
    qryPesquisaDATA_GERACAO: TDateTimeField;
    qryPesquisaDATA_PAGAMENTO: TDateTimeField;
    qryPesquisaMES: TLongintField;
    qryPesquisaMesAno: TStringField;
    qryPesquisaVALOR: TBCDField;
    qryPesquisaVENCIMENTO: TDateField;
  private

  public

    function salvarFatura(pFatura:TFatura; pControle:TControle; pCommit:Boolean = false):boolean;
    function getFatura(pCpf:String; pMes,pAno:Integer):TFatura;
    function deleteFatura(pCpf:String; pMes,pAno:Integer; pCommit:Boolean = false):Boolean;
    function abrePesquisa(pCpf:String):Boolean;

  end;

var
  DtmFatura: TDtmFatura;

implementation

{$R *.lfm}

{ TDtmFatura }

function TDtmFatura.salvarFatura(pFatura: TFatura; pControle: TControle;
  pCommit: Boolean): boolean;
begin
     Result := False;
     try
       qryFatura.Close;

       if (pControle = tpNovo) then
       begin
         if getFatura(pfatura.cpf, pfatura.mes,pfatura.ano) <> nil then
         begin
           MsgAlerta('Já existe uma fatura com esse Mês/Ano');
           Exit;
         end;

         qryFatura.SQL.Text:= ' INSERT INTO FATURA (CPF, COD_COBRANCA, DATA_GERACAO, DATA_PAGAMENTO, VALOR, MES, ANO, VENCIMENTO) '#13+
                              ' VALUES (:CPF, :COD_COBRANCA, CURRENT_DATE, :DATA_PAGAMENTO, :VALOR, :MES, :ANO, :VENCIMENTO)    ';

         if pfatura.codCobranca > 0 then
           qryFatura.ParamByName('COD_COBRANCA').AsInteger := pfatura.codCobranca;
       end
       else
       begin
         qryFatura.SQL.Text:= 'UPDATE FATURA                         '#13+
                              'SET DATA_PAGAMENTO = :DATA_PAGAMENTO, '#13+
                              '    VALOR = :VALOR,                   '#13+
                              '    VENCIMENTO = :VENCIMENTO          '#13+
                              'WHERE CPF = :CPF AND                  '#13+
                              '      MES = :MES AND                  '#13+
                              '      ANO = :ANO                      ';

       end;

       qryFatura.ParamByName('CPF').AsString := pfatura.cpf;
       if pfatura.dataPagamento > 0 then
         qryFatura.ParamByName('DATA_PAGAMENTO').AsDateTime := pfatura.dataPagamento;
       qryFatura.ParamByName('VENCIMENTO').AsDateTime := pfatura.vencimento;
       qryFatura.ParamByName('VALOR').AsFloat := pfatura.valor;
       qryFatura.ParamByName('MES').AsInteger := pfatura.mes;
       qryFatura.ParamByName('ANO').AsInteger := pfatura.ano;

       qryFatura.ExecSQL;

       if pCommit then
         DtmPrincipal.FBTrans.CommitRetaining;

       Result := True;
     except
       on E:exception do
       begin
            Result := False;
            DtmPrincipal.FBTrans.RollbackRetaining;
            MsgErro('Ocorreu um erro ao salvar a Fatura',E);
       end;
     end;
end;

function TDtmFatura.getFatura(pCpf: String; pMes, pAno: Integer): TFatura;
var
  Fatura : TFatura;
begin
     try
       qryFatura.Close;
       qryFatura.SQL.Text:= 'SELECT FAT.COD_FATURA,                                          '#13+
                              '       FAT.CPF,                                                 '#13+
                              '       FAT.COD_COBRANCA,                                        '#13+
                              '       FAT.DATA_GERACAO,                                        '#13+
                              '       FAT.DATA_PAGAMENTO,                                      '#13+
                              '       FAT.VALOR,                                               '#13+
                              '       FAT.MES,                                                 '#13+
                              '       FAT.ANO,                                                 '#13+
                              '       (LPAD(FAT.MES, 2, ''0'') || ''/'' || FAT.ANO) AS MESANO, '#13+
                              '       FAT.VENCIMENTO                                           '#13+
                              'FROM FATURA FAT                                                 '#13+
                              'WHERE FAT.CPF = :CPF AND FAT.MES = :MES AND FAT.ANO = :ANO      ';
       qryFatura.ParamByName('CPF').AsString:= pCpf;
       qryFatura.ParamByName('MES').AsInteger:= pMes;
       qryFatura.ParamByName('ANO').AsInteger:= pAno;
       qryFatura.Open;

       if not (qryFatura.IsEmpty) then
       begin
         Fatura := TFatura.Create;
         Fatura.codigo := qryFatura.FieldByName('COD_Fatura').AsInteger;
         Fatura.cpf := qryFatura.FieldByName('CPF').AsString;
         Fatura.codCobranca := qryFatura.FieldByName('COD_COBRANCA').AsInteger;
         Fatura.dataGeracao := qryFatura.FieldByName('DATA_GERACAO').AsDateTime;
         Fatura.dataPagamento := qryFatura.FieldByName('DATA_PAGAMENTO').AsDateTime;
         Fatura.valor := qryFatura.FieldByName('VALOR').AsFloat;
         Fatura.mes := qryFatura.FieldByName('MES').AsInteger;
         Fatura.ano := qryFatura.FieldByName('ANO').AsInteger;
         Fatura.vencimento := qryFatura.FieldByName('VENCIMENTO').AsDateTime;
         Result := Fatura;
       end
       else
        Result := nil;

     except
       on E:exception do
       begin
            Result := nil;
            MsgErro('Ocorreu um erro ao pesquisar a Fatura',E);
       end;
     end;
end;

function TDtmFatura.deleteFatura(pCpf: String; pMes, pAno: Integer;
  pCommit: Boolean): Boolean;
begin
     try
       qryFatura.Close;
       qryFatura.SQL.Text:='SELECT CPF FROM Fatura WHERE CPF = :CPF AND MES = :MES AND ANO = :ANO AND DATA_PAGAMENTO IS NOT NULL ';
       qryFatura.ParamByName('CPF').AsString:= pCpf;
       qryFatura.ParamByName('MES').AsInteger:= pMes;
       qryFatura.ParamByName('ANO').AsInteger:= pAno;
       qryFatura.Open;

       if not qryFatura.IsEmpty then
       begin
         MsgAlerta('Débito está pago, exclusão não permitida!');
         Result := False;
         Exit;
       end;

       qryFatura.Close;
       qryFatura.SQL.Text:='DELETE FROM Fatura WHERE CPF = :CPF AND MES = :MES AND ANO = :ANO ';
       qryFatura.ParamByName('CPF').AsString:= pCpf;
       qryFatura.ParamByName('MES').AsInteger:= pMes;
       qryFatura.ParamByName('ANO').AsInteger:= pAno;
       qryFatura.ExecSQL;

       if pCommit then
         DtmPrincipal.FBTrans.CommitRetaining;
       Result := True;
     except
       on E:exception do
       begin
            Result := False;
            DtmPrincipal.FBTrans.RollbackRetaining;
            MsgErro('Ocorreu um erro ao deletar a Fatura.',E);
       end;
     end;
end;

function TDtmFatura.abrePesquisa(pCpf: String): Boolean;
begin
     try
       qryPesquisa.Close;
       qryPesquisa.SQL.Text:= 'SELECT FAT.COD_FATURA,                                          '#13+
                              '       FAT.CPF,                                                 '#13+
                              '       FAT.COD_COBRANCA,                                        '#13+
                              '       FAT.DATA_GERACAO,                                        '#13+
                              '       FAT.DATA_PAGAMENTO,                                      '#13+
                              '       FAT.VALOR,                                               '#13+
                              '       FAT.MES,                                                 '#13+
                              '       FAT.ANO,                                                 '#13+
                              '       (LPAD(FAT.MES, 2, ''0'') || ''/'' || FAT.ANO) AS MESANO, '#13+
                              '       FAT.VENCIMENTO                                           '#13+
                              'FROM FATURA FAT                                                 ';

       if (pCpf <> '') then
       begin
          qryPesquisa.SQL.Text:= qryPesquisa.SQL.Text +#13+ 'WHERE CPF = :CPF';
          qryPesquisa.ParamByName('CPF').AsString:= pCpf;
       end;

       qryPesquisa.SQL.Text:= qryPesquisa.SQL.Text +#13+ 'ORDER BY CPF, VENCIMENTO DESC';
       qryPesquisa.Open;
       Result := not qryPesquisa.IsEmpty;
     except
       on E:exception do
       begin
            Result := False;
            DtmPrincipal.FBTrans.RollbackRetaining;
            MsgErro('Ocorreu um erro ao Abrir Pesquisa de fatura.',E);
       end;
     end;
end;

end.

