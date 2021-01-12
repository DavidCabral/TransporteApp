unit U_FrmPesquisaCadastroCurso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  U_Utils, U_DtmCadastroCurso, U_FrmPesquisaBase, DB;

type

  { TFrmPesquisaCadastroCurso }

  TFrmPesquisaCadastroCurso = class(TFrmPesquisaBase)
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure abreGrid;

  public

  end;

var
  FrmPesquisaCadastroCurso: TFrmPesquisaCadastroCurso;

implementation

{$R *.lfm}

{ TFrmPesquisaCadastroCurso }

uses
  U_FrmListagemCurso;

procedure TFrmPesquisaCadastroCurso.btnEditarClick(Sender: TObject);
begin
  inherited;
  Self.Close;
end;

procedure TFrmPesquisaCadastroCurso.btnExcluirClick(Sender: TObject);
begin
  inherited;
  if (DSGrid.DataSet.RecordCount > 0) then
  begin
    if DSGrid.DataSet.FieldByName('CODIGO').AsInteger = 0 then
    begin
      MsgAlerta('Código reservado ao sistema, exclusão não permitida!');
      Exit;
    end;
    if MsgConfirmacao('Deseja Excluir o registro?') then
      if dtmCadastroCurso.deleteCurso(DSGrid.DataSet.FieldByName(
        'CODIGO').AsInteger) then
      begin
        gControle := tpConsulta;
        abreGrid;
      end;
  end;
end;

procedure TFrmPesquisaCadastroCurso.btnListarClick(Sender: TObject);
begin
  if (DSGrid.DataSet.RecordCount > 0) then
  begin
    try
      FrmListagemCurso := TFrmListagemCurso.Create(Self);
      FrmListagemCurso.DSRel.DataSet := DSGrid.DataSet;
      FrmListagemCurso.RlblTitulo.Caption := 'Listagem de Curso';
      FrmListagemCurso.RLReport1.PreviewModal;
    finally
      FreeAndNil(FrmListagemCurso);
    end;
  end;
end;

procedure TFrmPesquisaCadastroCurso.FormShow(Sender: TObject);
begin
  abreGrid;
  goColumn := DBGrid1.Columns.Items[0];
  DBGrid1TitleClick(goColumn);
  DSGrid.DataSet.First;
end;

procedure TFrmPesquisaCadastroCurso.abreGrid;
begin
  with DtmCadastroCurso do
  begin
    qryPesquisa.Close;
    qryPesquisa.SQL.Text :=
      'SELECT COD_CURSO AS CODIGO, DES_CURSO AS NOME FROM CURSO ORDER BY 1';
    qryPesquisa.Open;

    AtualizaTotal;

    Application.ProcessMessages;
  end;
end;

end.
