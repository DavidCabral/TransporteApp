unit U_dtmcadastroInstituicao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, U_Utils, U_DtmPrincipal,
  U_Instituicao;

type

  { TdtmcadastroInstituicao }

  TdtmcadastroInstituicao = class(TDataModule)
    qryInstituicao: TSQLQuery;
    qryPesquisa: TSQLQuery;
    qryPesquisaCODIGO: TLongintField;
    qryPesquisaNOME: TStringField;
    qryPesquisaSIGLA: TStringField;
  private

  public

    function salvarInstituicao(pInstituicao:TInstituicao; pControle:TControle):boolean;
    function getInstituicao(pCodigo:Integer):TInstituicao;
    function deleteInstituicao(pCodigo:Integer):Boolean;

  end;

var
  dtmcadastroInstituicao: TdtmcadastroInstituicao;

implementation

{$R *.lfm}

{ TdtmcadastroInstituicao }

function TdtmcadastroInstituicao.salvarInstituicao(pInstituicao:TInstituicao; pControle: TControle): boolean;
begin
     try
       qryInstituicao.Close;

       if (pControle = tpNovo) then
         qryInstituicao.SQL.Text:='INSERT INTO INSTITUICAO (COD_INSTITUICAO, DES_INSTITUICAO, SIG_INSTITUICAO) VALUES (:COD_INSTITUICAO, :DES_INSTITUICAO, :SIG_INSTITUICAO)'
       else
         qryInstituicao.SQL.Text:='UPDATE INSTITUICAO SET DES_INSTITUICAO = :DES_INSTITUICAO, SIG_INSTITUICAO = :SIG_INSTITUICAO WHERE COD_INSTITUICAO = :COD_INSTITUICAO';

       qryInstituicao.ParamByName('COD_INSTITUICAO').AsInteger:=pInstituicao.codigo;
       qryInstituicao.ParamByName('SIG_INSTITUICAO').AsString:=pInstituicao.sigla;
       qryInstituicao.ParamByName('DES_INSTITUICAO').AsString:=pInstituicao.descicao;

       qryInstituicao.ExecSQL;

       DtmPrincipal.FBTrans.CommitRetaining;
     except
       on E:exception do
       begin
            Result := False;
            DtmPrincipal.FBTrans.RollbackRetaining;
            MsgErro('Ocorreu um erro ao salvar o instituição',E);
       end;
     end;
end;

function TdtmcadastroInstituicao.getInstituicao(pCodigo: Integer): TInstituicao;
var
  instituicao : TInstituicao;
begin
     try
       qryInstituicao.Close;
       qryInstituicao.SQL.Text:='SELECT COD_INSTITUICAO, DES_INSTITUICAO, SIG_INSTITUICAO FROM INSTITUICAO WHERE COD_INSTITUICAO = :COD_INSTITUICAO';
       qryInstituicao.ParamByName('COD_INSTITUICAO').AsInteger := pCodigo;
       qryInstituicao.Open;

       if not (qryInstituicao.IsEmpty) then
       begin
         instituicao := TInstituicao.Create;
         instituicao.codigo := qryInstituicao.FieldByName('COD_INSTITUICAO').AsInteger;
         instituicao.sigla := qryInstituicao.FieldByName('SIG_INSTITUICAO').AsString;
         instituicao.descicao := qryInstituicao.FieldByName('DES_INSTITUICAO').AsString;
         Result := instituicao;
       end
       else
        Result := nil;

     except
       on E:exception do
       begin
            Result := nil;
            MsgErro('Ocorreu um erro ao pesquisar o instituição',E);
       end;
     end;
end;

function TdtmcadastroInstituicao.deleteInstituicao(pCodigo: Integer): Boolean;
begin
     try
       qryInstituicao.Close;
       qryInstituicao.SQL.Text:='DELETE FROM INSTITUICAO WHERE COD_INSTITUICAO = :COD_INSTITUICAO';
       qryInstituicao.ParamByName('COD_INSTITUICAO').AsInteger := pCodigo;
       qryInstituicao.ExecSQL;
       DtmPrincipal.FBTrans.CommitRetaining;
       Result := True;
     except
       on E:exception do
       begin
            Result := False;
            DtmPrincipal.FBTrans.RollbackRetaining;
            MsgErro('Ocorreu um erro ao deletar o insituição.',E);
       end;
     end;
end;

end.

