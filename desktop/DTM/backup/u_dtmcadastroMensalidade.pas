unit U_dtmcadastroMensalidade;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, U_Utils, U_DtmPrincipal,
  U_Mensalidade;

type

  { TdtmcadastroMensalidade }

  TdtmcadastroMensalidade = class(TDataModule)
    qryMensalidade: TSQLQuery;
    qryPesquisa: TSQLQuery;
    qryPesquisaCODIGO: TLongintField;
    qryPesquisaNOME: TStringField;
    qryPesquisaSEG_IDA: TStringField;
  private

  public

    function salvarMensalidade(pMensalidade:TMensalidade; pControle:TControle):boolean;
    function getMensalidade(pCodigo:Integer):TMensalidade;
    function deleteMensalidade(pCodigo:Integer):Boolean;

  end;

var
  dtmcadastroMensalidade: TdtmcadastroMensalidade;

implementation

{$R *.lfm}

{ TdtmcadastroMensalidade }

function TdtmcadastroMensalidade.salvarMensalidade(pMensalidade:TMensalidade; pControle: TControle): boolean;
begin
     try
       qryMensalidade.Close;

       if (pControle = tpNovo) then
         qryMensalidade.SQL.Text:=' INSERT INTO MENSALIDADE (COD_MENSALIDADE, DES_MENSALIDADE, DOM_IDA, DOM_VOLTA, SEG_IDA, SEG_VOLTA, TER_IDA, TER_VOLTA, '#13+
                                  '                          QUA_IDA, QUA_VOLTA, QUI_IDA, QUI_VOLTA, SEX_IDA, SEX_VOLTA, SAB_IDA, SAB_VOLTA)               '#13+
                                  ' VALUES (:COD_MENSALIDADE, :DES_MENSALIDADE, :DOM_IDA, :DOM_VOLTA, :SEG_IDA, :SEG_VOLTA, :TER_IDA, :TER_VOLTA,          '#13+
                                  '                          :QUA_IDA, :QUA_VOLTA, :QUI_IDA, :QUI_VOLTA, :SEX_IDA, :SEX_VOLTA, :SAB_IDA, :SAB_VOLTA)       '
       else
         qryMensalidade.SQL.Text:= ' UPDATE MENSALIDADE                      '#13+
                                   ' SET DES_MENSALIDADE = :DES_MENSALIDADE, '#13+
                                   '     SEG_IDA = :SEG_IDA,                 '#13+
                                   '     SEG_VOLTA = :SEG_VOLTA,             '#13+
                                   '     TER_IDA = :TER_IDA,                 '#13+
                                   '     TER_VOLTA = :TER_VOLTA,             '#13+
                                   '     QUA_IDA = :QUA_IDA,                 '#13+
                                   '     QUA_VOLTA = :QUA_VOLTA,             '#13+
                                   '     QUI_IDA = :QUI_IDA,                 '#13+
                                   '     QUI_VOLTA = :QUI_VOLTA,             '#13+
                                   '     SEX_IDA = :SEX_IDA,                 '#13+
                                   '     SEX_VOLTA = :SEX_VOLTA,             '#13+
                                   '     SAB_IDA = :SAB_IDA,                 '#13+
                                   '     SAB_VOLTA = :SAB_VOLTA,             '#13+
                                   '     DOM_IDA = :DOM_IDA,                 '#13+
                                   '     DOM_VOLTA = :DOM_VOLTA              '#13+
                                   ' WHERE COD_MENSALIDADE = :COD_MENSALIDADE';

       qryMensalidade.ParamByName('COD_MENSALIDADE').AsInteger:=pMensalidade.codigo;
       qryMensalidade.ParamByName('DES_MENSALIDADE').AsString:=pMensalidade.descicao;

       if pMensalidade.seg_ida then
         qryMensalidade.ParamByName('SEG_IDA').AsString := 'S'
       else
         qryMensalidade.ParamByName('SEG_IDA').AsString := 'N';

       if pMensalidade.seg_volta then
         qryMensalidade.ParamByName('SEG_VOLTA').AsString := 'S'
       else
         qryMensalidade.ParamByName('SEG_VOLTA').AsString := 'N';

       if pMensalidade.ter_ida then
         qryMensalidade.ParamByName('TER_IDA').AsString := 'S'
       else
         qryMensalidade.ParamByName('TER_IDA').AsString := 'N';

       if pMensalidade.ter_volta then
         qryMensalidade.ParamByName('TER_VOLTA').AsString := 'S'
       else
         qryMensalidade.ParamByName('TER_VOLTA').AsString := 'N';

       if pMensalidade.qua_ida then
         qryMensalidade.ParamByName('QUA_IDA').AsString := 'S'
       else
         qryMensalidade.ParamByName('QUA_IDA').AsString := 'N';

       if pMensalidade.qua_volta then
         qryMensalidade.ParamByName('QUA_VOLTA').AsString := 'S'
       else
         qryMensalidade.ParamByName('QUA_VOLTA').AsString := 'N';

       if pMensalidade.qui_ida then
         qryMensalidade.ParamByName('QUI_IDA').AsString := 'S'
       else
         qryMensalidade.ParamByName('QUI_IDA').AsString := 'N';

       if pMensalidade.qui_volta then
         qryMensalidade.ParamByName('QUI_VOLTA').AsString := 'S'
       else
         qryMensalidade.ParamByName('QUI_VOLTA').AsString := 'N';

       if pMensalidade.sex_ida then
         qryMensalidade.ParamByName('SEX_IDA').AsString := 'S'
       else
         qryMensalidade.ParamByName('SEX_IDA').AsString := 'N';

       if pMensalidade.sex_volta then
         qryMensalidade.ParamByName('SEX_VOLTA').AsString := 'S'
       else
         qryMensalidade.ParamByName('SEX_VOLTA').AsString := 'N';

       if pMensalidade.sab_ida then
         qryMensalidade.ParamByName('SAB_IDA').AsString := 'S'
       else
         qryMensalidade.ParamByName('SAB_IDA').AsString := 'N';

       if pMensalidade.sab_volta then
         qryMensalidade.ParamByName('SAB_VOLTA').AsString := 'S'
       else
         qryMensalidade.ParamByName('SAB_VOLTA').AsString := 'N';

       if pMensalidade.dom_ida then
         qryMensalidade.ParamByName('DOM_IDA').AsString := 'S'
       else
         qryMensalidade.ParamByName('DOM_IDA').AsString := 'N';

       if pMensalidade.dom_volta then
         qryMensalidade.ParamByName('DOM_VOLTA').AsString := 'S'
       else
         qryMensalidade.ParamByName('DOM_VOLTA').AsString := 'N';

       qryMensalidade.ExecSQL;

       DtmPrincipal.FBTrans.CommitRetaining;
     except
       on E:exception do
       begin
            Result := False;
            DtmPrincipal.FBTrans.RollbackRetaining;
            MsgErro('Ocorreu um erro ao salvar a mensalidade',E);
       end;
     end;
end;

function TdtmcadastroMensalidade.getMensalidade(pCodigo: Integer): TMensalidade;
var
  mensalidade : TMensalidade;
begin
     try
       qryMensalidade.Close;
       qryMensalidade.SQL.Text:='SELECT COD_MENSALIDADE,                  '#13+
                                '       DES_MENSALIDADE,                  '#13+
                                '       SEG_IDA,                          '#13+
                                '       SEG_VOLTA,                        '#13+
                                '       TER_IDA,                          '#13+
                                '       TER_VOLTA,                        '#13+
                                '       QUA_IDA,                          '#13+
                                '       QUA_VOLTA,                        '#13+
                                '       QUI_IDA,                          '#13+
                                '       QUI_VOLTA,                        '#13+
                                '       SEX_IDA,                          '#13+
                                '       SEX_VOLTA,                        '#13+
                                '       SAB_IDA,                          '#13+
                                '       SAB_VOLTA,                        '#13+
                                '       DOM_IDA,                          '#13+
                                '       DOM_VOLTA                         '#13+
                                'FROM MENSALIDADE                         '#13+
                                'WHERE COD_MENSALIDADE = :COD_MENSALIDADE ';
       qryMensalidade.ParamByName('COD_MENSALIDADE').AsInteger := pCodigo;
       qryMensalidade.Open;

       if not (qryMensalidade.IsEmpty) then
       begin
         mensalidade := TMensalidade.Create;
         mensalidade.codigo := qryMensalidade.FieldByName('COD_MENSALIDADE').AsInteger;
         mensalidade.descicao := qryMensalidade.FieldByName('DES_MENSALIDADE').AsString;

         mensalidade.seg_ida := (qryMensalidade.FieldByName('SEG_IDA').AsString = 'S');
         mensalidade.seg_volta := (qryMensalidade.FieldByName('SEG_VOLTA').AsString = 'S');

         mensalidade.ter_ida := (qryMensalidade.FieldByName('TER_IDA').AsString = 'S');
         mensalidade.ter_volta := (qryMensalidade.FieldByName('TER_VOLTA').AsString = 'S');

         mensalidade.qua_ida := (qryMensalidade.FieldByName('QUA_IDA').AsString = 'S');
         mensalidade.qua_volta := (qryMensalidade.FieldByName('QUA_VOLTA').AsString = 'S');

         mensalidade.qui_ida := (qryMensalidade.FieldByName('QUI_IDA').AsString = 'S');
         mensalidade.qui_volta := (qryMensalidade.FieldByName('QUI_VOLTA').AsString = 'S');

         mensalidade.sex_ida := (qryMensalidade.FieldByName('SEX_IDA').AsString = 'S');
         mensalidade.sex_volta := (qryMensalidade.FieldByName('SEX_VOLTA').AsString = 'S');

         mensalidade.sab_ida := (qryMensalidade.FieldByName('SAB_IDA').AsString = 'S');
         mensalidade.sab_volta := (qryMensalidade.FieldByName('SAB_VOLTA').AsString = 'S');

         mensalidade.dom_ida := (qryMensalidade.FieldByName('DOM_IDA').AsString = 'S');
         mensalidade.dom_volta := (qryMensalidade.FieldByName('DOM_VOLTA').AsString = 'S');

         Result := mensalidade;
       end
       else
        Result := nil;

     except
       on E:exception do
       begin
            Result := nil;
            MsgErro('Ocorreu um erro ao pesquisar a mensalidade',E);
       end;
     end;
end;

function TdtmcadastroMensalidade.deleteMensalidade(pCodigo: Integer): Boolean;
begin
     try
       qryMensalidade.Close;
       qryMensalidade.SQL.Text:='DELETE FROM MENSALIDADE WHERE COD_MENSALIDADE = :COD_MENSALIDADE';
       qryMensalidade.ParamByName('COD_MENSALIDADE').AsInteger := pCodigo;
       qryMensalidade.ExecSQL;
       DtmPrincipal.FBTrans.CommitRetaining;
       Result := True;
     except
       on E:exception do
       begin
            Result := False;
            DtmPrincipal.FBTrans.RollbackRetaining;
            MsgErro('Ocorreu um erro ao deletar a mensalidade.',E);
       end;
     end;
end;

end.

