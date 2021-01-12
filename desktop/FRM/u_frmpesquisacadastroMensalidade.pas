unit U_frmpesquisacadastroMensalidade;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  U_Utils, U_dtmcadastroMensalidade, U_FrmPesquisaBase;

type

  { TfrmpesquisacadastroMensalidade }

  TfrmpesquisacadastroMensalidade = class(TFrmPesquisaBase)
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure abreGrid;

  public

  end;

var
  frmpesquisacadastroMensalidade: TfrmpesquisacadastroMensalidade;

implementation

{$R *.lfm}

{ TfrmpesquisacadastroMensalidade }

procedure TfrmpesquisacadastroMensalidade.btnEditarClick(Sender: TObject);
begin
  inherited;
  Self.Close;
end;

procedure TfrmpesquisacadastroMensalidade.btnExcluirClick(Sender: TObject);
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
      if dtmcadastroMensalidade.deleteMensalidade(
        DSGrid.DataSet.FieldByName('CODIGO').AsInteger) then
      begin
        gControle := tpConsulta;
        abreGrid;
      end;
  end;
end;

procedure TfrmpesquisacadastroMensalidade.FormShow(Sender: TObject);
begin
  abreGrid;
  goColumn := DBGrid1.Columns.Items[0];
  DBGrid1TitleClick(goColumn);
  DSGrid.DataSet.First;
end;

procedure TfrmpesquisacadastroMensalidade.abreGrid;
begin
  with dtmcadastroMensalidade do
  begin
    qryPesquisa.Close;
    qryPesquisa.SQL.Text := 'SELECT COD_MENSALIDADE AS CODIGO,        '#13 +
      '       DES_MENSALIDADE AS NOME,          '#13 +
      '       SEG_IDA,                          '#13 +
      '       SEG_VOLTA,                        '#13 +
      '       TER_IDA,                          '#13 +
      '       TER_VOLTA,                        '#13 +
      '       QUA_IDA,                          '#13 +
      '       QUA_VOLTA,                        '#13 +
      '       QUI_IDA,                          '#13 +
      '       QUI_VOLTA,                        '#13 +
      '       SEX_IDA,                          '#13 +
      '       SEX_VOLTA,                        '#13 +
      '       SAB_IDA,                          '#13 +
      '       SAB_VOLTA,                        '#13 +
      '       DOM_IDA,                          '#13 +
      '       DOM_VOLTA                         '#13 +
      'FROM MENSALIDADE                         '#13 +
      'ORDER BY 1                               ';
    qryPesquisa.Open;
    qryPesquisa.Last;
    qryPesquisa.First;

    AtualizaTotal;

    Application.ProcessMessages;
  end;
end;

end.
