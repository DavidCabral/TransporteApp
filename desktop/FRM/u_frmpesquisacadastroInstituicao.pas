unit U_frmpesquisacadastroInstituicao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  U_Utils, U_dtmcadastroInstituicao, U_FrmPesquisaBase;

type

  { TfrmpesquisacadastroInstituicao }

  TfrmpesquisacadastroInstituicao = class(TFrmPesquisaBase)
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure abreGrid;

  public

  end;

var
  frmpesquisacadastroInstituicao: TfrmpesquisacadastroInstituicao;

implementation

{$R *.lfm}

{ TfrmpesquisacadastroInstituicao }

procedure TfrmpesquisacadastroInstituicao.btnEditarClick(Sender: TObject);
begin
  inherited;
  Self.Close;
end;

procedure TfrmpesquisacadastroInstituicao.btnExcluirClick(Sender: TObject);
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
      if dtmcadastroInstituicao.deleteInstituicao(
        DSGrid.DataSet.FieldByName('CODIGO').AsInteger) then
      begin
        gControle := tpConsulta;
        abreGrid;
      end;
  end;
end;

procedure TfrmpesquisacadastroInstituicao.btnListarClick(Sender: TObject);
begin

end;

procedure TfrmpesquisacadastroInstituicao.FormShow(Sender: TObject);
begin
  abreGrid;
  goColumn := DBGrid1.Columns.Items[0];
  DBGrid1TitleClick(goColumn);
  DSGrid.DataSet.First;
end;

procedure TfrmpesquisacadastroInstituicao.abreGrid;
begin
  with dtmcadastroInstituicao do
  begin
    qryPesquisa.Close;
    qryPesquisa.SQL.Text :=
      'SELECT COD_INSTITUICAO AS CODIGO, SIG_INSTITUICAO AS SIGLA, DES_INSTITUICAO AS NOME FROM INSTITUICAO ORDER BY 1';
    qryPesquisa.Open;

    AtualizaTotal;

    Application.ProcessMessages;
  end;
end;

end.
