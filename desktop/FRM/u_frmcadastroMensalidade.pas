unit U_frmcadastroMensalidade;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, U_Utils, U_FrmCadastroBase, U_dtmcadastroMensalidade,
  U_Mensalidade;

type

  { TfrmcadastroMensalidade }

  TfrmcadastroMensalidade = class(TFrmCadastroBase)
    cgIda: TCheckGroup;
    cgVolta: TCheckGroup;
    edtCodigo: TEdit;
    edtNome: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtCodigoExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    mensalidade: TMensalidade;
    procedure limparIdaVolta;
  public

  end;

var
  frmcadastroMensalidade: TfrmcadastroMensalidade;

implementation

{$R *.lfm}

{ TfrmcadastroMensalidade }

uses
  U_frmpesquisacadastroMensalidade;

procedure TfrmcadastroMensalidade.btnIncluirClick(Sender: TObject);
begin
  edtCodigo.Text := FormatFloat('00', getCodigoValido('MENSALIDADE', 'COD_MENSALIDADE'));

  inherited;

  edtCodigo.Enabled := False;
  edtCodigo.Color := clInfoBk;

  edtNome.Enabled := True;
  edtNome.Color := clWhite;
  edtNome.SetFocus;

  cgIda.Enabled := True;
  cgVolta.Enabled := True;

  limparIdaVolta;
end;

procedure TfrmcadastroMensalidade.btnPesquisarClick(Sender: TObject);
begin
  try
    frmpesquisacadastroMensalidade := TfrmpesquisacadastroMensalidade.Create(Self);
    frmpesquisacadastroMensalidade.ShowModal;

    if frmpesquisacadastroMensalidade.gControle = tpAlterar then
    begin
      edtCodigo.Text := frmpesquisacadastroMensalidade.DSGrid.DataSet.FieldByName(
        'CODIGO').AsString;
      edtCodigoExit(edtCodigo);
    end;

  finally
    FreeAndNil(frmpesquisacadastroMensalidade);
  end;
end;

procedure TfrmcadastroMensalidade.btnSalvarClick(Sender: TObject);
begin
  if (Trim(edtNome.Text) = '') then
  begin
    MsgAlerta('Informe o nome!');
    edtNome.SetFocus;
    Exit;
  end;

  try
    mensalidade := TMensalidade.Create;
    mensalidade.codigo := StrToInt(edtCodigo.Text);
    mensalidade.descicao := edtNome.Text;

    mensalidade.seg_ida := cgIda.Checked[0];
    mensalidade.seg_volta := cgVolta.Checked[0];

    mensalidade.ter_ida := cgIda.Checked[1];
    mensalidade.ter_volta := cgVolta.Checked[1];

    mensalidade.qua_ida := cgIda.Checked[2];
    mensalidade.qua_volta := cgVolta.Checked[2];

    mensalidade.qui_ida := cgIda.Checked[3];
    mensalidade.qui_volta := cgVolta.Checked[3];

    mensalidade.sex_ida := cgIda.Checked[4];
    mensalidade.sex_volta := cgVolta.Checked[4];

    mensalidade.sab_ida := cgIda.Checked[5];
    mensalidade.sab_volta := cgVolta.Checked[5];

    mensalidade.dom_ida := cgIda.Checked[6];
    mensalidade.dom_volta := cgVolta.Checked[6];

    if dtmcadastroMensalidade.salvarMensalidade(mensalidade, gControle) then
    begin
      if gControle = tpNovo then
        MsgOk('Mensalidade cadastrado com sucesso!')
      else
        MsgOk('Mensalidade alterado com sucesso!');
    end;
  finally
    FreeAndNil(mensalidade);
  end;

  btnCancelarClick(btnCancelar);

  inherited;
end;

procedure TfrmcadastroMensalidade.edtCodigoExit(Sender: TObject);
begin
  if gControle = tpConsulta then
  begin
    if (Trim(edtCodigo.Text) <> '') then
    begin
      mensalidade := dtmcadastroMensalidade.getMensalidade(StrToInt(edtCodigo.Text));
      if (mensalidade <> nil) then
      begin
        try
          edtCodigo.Text := formatfloat('00', mensalidade.codigo);
          edtNome.Text := mensalidade.descicao;

          cgIda.Checked[0] := mensalidade.seg_ida;
          cgVolta.Checked[0] := mensalidade.seg_volta;

          cgIda.Checked[1] := mensalidade.ter_ida;
          cgVolta.Checked[1] := mensalidade.ter_volta;

          cgIda.Checked[2] := mensalidade.qua_ida;
          cgVolta.Checked[2] := mensalidade.qua_volta;

          cgIda.Checked[3] := mensalidade.qui_ida;
          cgVolta.Checked[3] := mensalidade.qui_volta;

          cgIda.Checked[4] := mensalidade.sex_ida;
          cgVolta.Checked[4] := mensalidade.sex_volta;

          cgIda.Checked[5] := mensalidade.sab_ida;
          cgVolta.Checked[5] := mensalidade.sab_volta;

          cgIda.Checked[6] := mensalidade.dom_ida;
          cgVolta.Checked[6] := mensalidade.dom_volta;

          controleAlterar;
          edtCodigo.Enabled := False;
          edtCodigo.Color := clInfoBk;

          if (mensalidade.codigo > 0) then
          begin
            edtNome.Enabled := True;
            edtNome.Color := clWhite;
            edtNome.SetFocus;

            cgIda.Enabled := True;
            cgVolta.Enabled := True;
          end;
        finally
          FreeAndNil(mensalidade);
        end;
      end
      else
      begin
        MsgAlerta('Mensalidade não encontrado!');
        btnCancelarClick(btnCancelar);
      end;
    end;
  end;
end;

procedure TfrmcadastroMensalidade.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if gControle = tpNovo then
    deletaCodigo('MENSALIDADE', 'COD_MENSALIDADE', StrToInt(edtCodigo.Text));
end;

procedure TfrmcadastroMensalidade.FormCreate(Sender: TObject);
begin
  inherited;

  dtmcadastroMensalidade := TdtmcadastroMensalidade.Create(Self);
end;

procedure TfrmcadastroMensalidade.FormDestroy(Sender: TObject);
begin
  FreeAndNil(dtmcadastroMensalidade);
end;

procedure TfrmcadastroMensalidade.FormShow(Sender: TObject);
begin
  self.ActiveControl := edtCodigo;
  edtCodigo.SetFocus;
end;

procedure TfrmcadastroMensalidade.limparIdaVolta;
var
  i: integer;
begin
  for i := 0 to 6 do
  begin
    cgIda.Checked[i] := False;
    cgVolta.Checked[i] := False;
  end;
end;

procedure TfrmcadastroMensalidade.btnCancelarClick(Sender: TObject);
begin
  deletaCodigo('MENSALIDADE', 'COD_MENSALIDADE', StrToInt(edtCodigo.Text));

  edtCodigo.Clear;
  edtCodigo.Enabled := True;
  edtCodigo.Color := clWhite;
  edtCodigo.SetFocus;

  edtNome.Clear;
  edtNome.Enabled := False;
  edtNome.Color := clInfoBk;

  cgIda.Enabled := False;
  cgVolta.Enabled := False;

  limparIdaVolta;

  inherited;
end;

end.

