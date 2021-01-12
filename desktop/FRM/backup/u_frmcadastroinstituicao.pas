unit U_frmcadastroinstituicao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, U_Utils, U_FrmCadastroBase, U_dtmcadastroInstituicao,
  U_Instituicao;

type

  { Tfrmcadastroinstituicao }

  Tfrmcadastroinstituicao = class(TFrmCadastroBase)
    edtCodigo: TEdit;
    edtNome: TEdit;
    edtSigla: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
         instituicao :TInstituicao;
  public

  end;

var
  frmcadastroinstituicao: Tfrmcadastroinstituicao;

implementation

{$R *.lfm}

{ Tfrmcadastroinstituicao }

uses
  U_frmpesquisacadastroInstituicao;


procedure Tfrmcadastroinstituicao.btnIncluirClick(Sender: TObject);
begin
  edtCodigo.Text := FormatFloat('00',getCodigoValido('INSTITUICAO','COD_INSTITUICAO'));

  inherited;

  edtCodigo.Enabled:=False;
  edtCodigo.Color:=clInfoBk;

  edtNome.Enabled:= True;
  edtNome.Color:=clWhite;

  edtSigla.Enabled:= True;
  edtSigla.Color:=clWhite;
  edtSigla.SetFocus;
end;

procedure Tfrmcadastroinstituicao.btnPesquisarClick(Sender: TObject);
begin
  try
    frmpesquisacadastroInstituicao := TfrmpesquisacadastroInstituicao.Create(Self);
    frmpesquisacadastroInstituicao.ShowModal;

    if frmpesquisacadastroInstituicao.gControle = tpAlterar then
    begin
      edtCodigo.Text := frmpesquisacadastroInstituicao.DSGrid.DataSet.FieldByName('CODIGO').AsString;
      edtCodigoExit(edtCodigo);
    end;

  finally
    FreeAndNil(frmpesquisacadastroInstituicao);
  end;
end;

procedure Tfrmcadastroinstituicao.btnSalvarClick(Sender: TObject);
begin
  if (Trim(edtSigla.Text) = '') then
  begin
    MsgAlerta('Informe a Sigla!');
    edtSigla.SetFocus;
    Exit;
  end;

  if (Trim(edtNome.Text) = '') then
  begin
    MsgAlerta('Informe o nome!');
    edtNome.SetFocus;
    Exit;
  end;

  try
    instituicao := TInstituicao.Create;
    instituicao.codigo:= StrToInt(edtCodigo.Text);
    instituicao.sigla:= edtSigla.Text;
    instituicao.descicao:= edtNome.Text;

    if dtmcadastroInstituicao.salvarInstituicao(instituicao,gControle) then
    begin
      if gControle = tpNovo then
        MsgOk('Instituição cadastrado com sucesso!')
      else
        MsgOk('Instituição alterado com sucesso!');
    end;
  finally
    FreeAndNil(instituicao);
  end;

  btnCancelarClick(btnCancelar);

  inherited;
end;

procedure Tfrmcadastroinstituicao.edtCodigoExit(Sender: TObject);
begin
  if gControle = tpConsulta then
  begin
    if (Trim(edtCodigo.Text) <> '') then
    begin
         instituicao := dtmcadastroInstituicao.getInstituicao(StrToInt(edtCodigo.Text));
         if (instituicao <> nil) then
         begin
              try
                 edtCodigo.Text := formatfloat('00',instituicao.codigo);
                 edtNome.Text := instituicao.descicao;
                 controleAlterar;
                 edtCodigo.Enabled:=False;
                 edtCodigo.Color:=clInfoBk;

                 if (instituicao.codigo > 0) then
                 begin
                   edtNome.Enabled:= True;
                   edtNome.Color:=clWhite;
                   edtNome.SetFocus;
                 end;
              finally
                FreeAndNil(instituicao);
              end;
         end
         else
         begin
           MsgAlerta('Instituição não encontrado!');
           btnCancelarClick(btnCancelar);
         end;
    end;
  end;
end;

procedure Tfrmcadastroinstituicao.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if gControle = tpNovo then
    deletaCodigo('INSTITUICAO','COD_INSTITUICAO',StrToInt(edtCodigo.Text));
end;

procedure Tfrmcadastroinstituicao.FormCreate(Sender: TObject);
begin
  inherited;

  dtmcadastroInstituicao := TdtmcadastroInstituicao.Create(Self);
end;

procedure Tfrmcadastroinstituicao.FormDestroy(Sender: TObject);
begin
  FreeAndNil(dtmcadastroInstituicao);
end;

procedure Tfrmcadastroinstituicao.FormShow(Sender: TObject);
begin
  self.ActiveControl := edtCodigo;
  edtCodigo.SetFocus;
end;

procedure Tfrmcadastroinstituicao.btnCancelarClick(Sender: TObject);
begin
  deletaCodigo('INSTITUICAO','COD_INSTITUICAO',StrToInt(edtCodigo.Text));

  edtCodigo.Clear;
  edtCodigo.Enabled:= True;
  edtCodigo.Color:=clWhite;
  edtCodigo.SetFocus;

  edtSigla.Clear;
  edtSigla.Enabled:=False;
  edtSigla.Color:=clInfoBk;

  edtNome.Clear;
  edtNome.Enabled:=False;
  edtNome.Color:=clInfoBk;

  inherited;
end;

end.

