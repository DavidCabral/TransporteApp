unit U_DtmCadastroCurso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, U_Utils, U_DtmPrincipal,
  U_Curso;

type

  { TDtmCadastroCurso }

  TDtmCadastroCurso = class(TDataModule)
    qryCurso: TSQLQuery;
    qryPesquisa: TSQLQuery;
    qryPesquisaCODIGO: TLongintField;
    qryPesquisaNOME: TStringField;
  private

  public

    function salvarCurso(pCurso:TCurso; pControle:TControle):boolean;
    function getCurso(pCodigo:Integer):TCurso;
    function deleteCurso(pCodigo:Integer):Boolean;

  end;

var
  DtmCadastroCurso: TDtmCadastroCurso;

implementation

{$R *.lfm}

{ TDtmCadastroCurso }

function TDtmCadastroCurso.salvarCurso(pCurso:TCurso; pControle: TControle): boolean;
begin
     try
       qryCurso.Close;

       if (pControle = tpNovo) then
         qryCurso.SQL.Text:='INSERT INTO CURSO (COD_CURSO, DES_CURSO) VALUES (:COD_CURSO, :DES_CURSO)'
       else
         qryCurso.SQL.Text:='UPDATE CURSO SET DES_CURSO = :DES_CURSO WHERE COD_CURSO = :COD_CURSO';

       qryCurso.ParamByName('COD_CURSO').AsInteger:=pCurso.codigo;
       qryCurso.ParamByName('DES_CURSO').AsString:=pCurso.descicao;

       qryCurso.ExecSQL;

       DtmPrincipal.FBTrans.CommitRetaining;
     except
       on E:exception do
       begin
            Result := False;
            DtmPrincipal.FBTrans.RollbackRetaining;
            MsgErro('Ocorreu um erro ao salvar o curso',E);
       end;
     end;
end;

function TDtmCadastroCurso.getCurso(pCodigo: Integer): TCurso;
var
  curso : TCurso;
begin
     try
       qryCurso.Close;
       qryCurso.SQL.Text:='SELECT COD_CURSO, DES_CURSO FROM CURSO WHERE COD_CURSO = :COD_CURSO';
       qryCurso.ParamByName('COD_CURSO').AsInteger := pCodigo;
       qryCurso.Open;

       if not (qryCurso.IsEmpty) then
       begin
         curso := TCurso.Create;
         curso.codigo := qryCurso.FieldByName('COD_CURSO').AsInteger;
         curso.descicao := qryCurso.FieldByName('DES_CURSO').AsString;
         Result := curso;
       end
       else
        Result := nil;

     except
       on E:exception do
       begin
            Result := nil;
            MsgErro('Ocorreu um erro ao pesquisar o curso',E);
       end;
     end;
end;

function TDtmCadastroCurso.deleteCurso(pCodigo: Integer): Boolean;
begin
     try
       qryCurso.Close;
       qryCurso.SQL.Text:='DELETE FROM CURSO WHERE COD_CURSO = :COD_CURSO';
       qryCurso.ParamByName('COD_CURSO').AsInteger := pCodigo;
       qryCurso.ExecSQL;
       DtmPrincipal.FBTrans.CommitRetaining;
       Result := True;
     except
       on E:exception do
       begin
            Result := False;
            DtmPrincipal.FBTrans.RollbackRetaining;
            MsgErro('Ocorreu um erro ao deletar o curso.',E);
       end;
     end;
end;

end.

