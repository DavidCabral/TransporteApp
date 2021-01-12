unit U_frmpesquisacadastroSocio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    U_FrmPesquisaBase, U_DtmCadastroSocio, U_Utils;

type

  { TfrmpesquisacadastroSocio }

  TfrmpesquisacadastroSocio = class(TFrmPesquisaBase)
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure abreGrid;

  public

  end;

var
  frmpesquisacadastroSocio: TfrmpesquisacadastroSocio;

implementation

uses
  U_FrmRelSociosInadimplentes;

{$R *.lfm}

{ TfrmpesquisacadastroSocio }

procedure TfrmpesquisacadastroSocio.btnEditarClick(Sender: TObject);
begin
  inherited;
  Self.Close;
end;

procedure TfrmpesquisacadastroSocio.btnExcluirClick(Sender: TObject);
begin
  inherited;
  if MsgConfirmacao('Deseja Excluir o registro?') then
    if DtmCadastroSocio.deleteSocio(DSGrid.DataSet.FieldByName('CPF').AsString) then
    begin
      gControle:=tpConsulta;
      abreGrid;
    end;
end;

procedure TfrmpesquisacadastroSocio.btnListarClick(Sender: TObject);
begin
  FrmRelSociosInadimplentes := TFrmRelSociosInadimplentes.Create(Self);
  try
    btnListar.Enabled:= False;
    FrmRelSociosInadimplentes.RlblTitulo.Caption:='Listagem Sócios';
    FrmRelSociosInadimplentes.gbListaFaturas:=False;
    FrmRelSociosInadimplentes.RLBand2.Visible:= False;
    FrmRelSociosInadimplentes.gbInadimplencia:= False;
    FrmRelSociosInadimplentes.carregaRelatorio('');
    FrmRelSociosInadimplentes.RLReport1.PreviewModal;
  finally
    btnListar.Enabled:= True;
    FreeAndNil(FrmRelSociosInadimplentes);
  end;
end;

procedure TfrmpesquisacadastroSocio.FormShow(Sender: TObject);
begin
  abreGrid;
  goColumn := DBGrid1.Columns.Items[1];
  DBGrid1TitleClick(goColumn);
  DSGrid.DataSet.First;
end;

procedure TfrmpesquisacadastroSocio.abreGrid;
begin
  with dtmcadastroSocio do
  begin
    qryPesquisa.Close;
    qryPesquisa.SQL.Text:=    'SELECT M.COD_MENSALIDADE,   '#13+
                              '       M.DES_MENSALIDADE,   '#13+
                              '       I.COD_INSTITUICAO,   '#13+
                              '       I.DES_INSTITUICAO,   '#13+
                              '       C.COD_CURSO,         '#13+
                              '       C.DES_CURSO,         '#13+
                              '       NOME,                '#13+
                              '       CPF,                 '#13+
                              '       FOTO,                '#13+
                              '       ENDERECO,            '#13+
                              '       FONE,                '#13+
                              '       FONE2,               '#13+
                              '       EMAIL,               '#13+
                              '       DATA_CADASTRAMENTO,  '#13+
                              '       ATIVO,               '#13+
                              '       MES,                 '#13+
                              '       ANO,                 '#13+
                              '       S.DATA_VALIDADE      '#13+
                              'FROM SOCIO S                '#13+
                              'LEFT JOIN CURSO C ON C.COD_CURSO = S.COD_CURSO '#13+
                              'LEFT JOIN INSTITUICAO I ON I.COD_INSTITUICAO = S.COD_INSTITUICAO '#13+
                              'LEFT JOIN MENSALIDADE M ON M.COD_MENSALIDADE = S.COD_MENSALIDADE '#13+
                              'ORDER BY 1';
    qryPesquisa.Open;

    qryPesquisa.Last;
    qryPesquisa.First;

    AtualizaTotal;

    Application.ProcessMessages;
  end;
end;

end.

