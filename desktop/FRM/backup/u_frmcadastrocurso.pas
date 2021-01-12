unit U_FrmCadastroCurso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, U_Utils, U_FrmCadastroBase, U_DtmCadastroCurso,
  U_Curso;

type

  { TFrmCadastroCurso }

  TFrmCadastroCurso = class(TFrmCadastroBase)
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
         curso :TCurso;
  public

  end;

var
  FrmCadastroCurso: TFrmCadastroCurso;

implementation

{$R *.lfm}

{ TFrmCadastroCurso }

uses
  U_FrmPesquisaCadastroCurso;


procedure TFrmCadastroCurso.btnIncluirClick(Sender: TObject);
begin
  edtCodigo.Text := FormatFloat('00',getCodigoValido('CURSO','COD_CURSO'));

  inherited;

  edtCodigo.Enabled:=False;
  edtCodigo.Color:=clInfoBk;

  edtNome.Enabled:= True;
  edtNome.Color:=clWhite;
  edtNome.SetFocus;
end;

procedure TFrmCadastroCurso.btnPesquisarClick(Sender: TObject);
begin
  try
    FrmPesquisaCadastroCurso := TFrmPesquisaCadastroCurso.Create(Self);
    FrmPesquisaCadastroCurso.ShowModal;

    if FrmPesquisaCadastroCurso.gControle = tpAlterar then
    begin
      edtCodigo.Text := FrmPesquisaCadastroCurso.DSGrid.DataSet.FieldByName('CODIGO').AsString;
      edtCodigoExit(edtCodigo);
    end;

  finally
    FreeAndNil(FrmPesquisaCadastroCurso);
  end;
end;

procedure TFrmCadastroCurso.btnSalvarClick(Sender: TObject);
begin
  if (Trim(edtNome.Text) = '') then
  begin
    MsgAlerta('Informe o nome!');
    edtNome.SetFocus;
    Exit;
  end;

  try
    curso := TCurso.Create;
    curso.codigo:= StrToInt(edtCodigo.Text);
    curso.descicao:= edtNome.Text;

    if DtmCadastroCurso.salvarCurso(curso,gControle) then
    begin
      if gControle = tpNovo then
        MsgOk('Curso cadastrado com sucesso!')
      else
        MsgOk('Curso alterado com sucesso!');
    end;
  finally
    FreeAndNil(curso);
  end;

  btnCancelarClick(btnCancelar);

  inherited;
end;

procedure TFrmCadastroCurso.edtCodigoExit(Sender: TObject);
begin
  if gControle = tpConsulta then
  begin
    if (Trim(edtCodigo.Text) <> '') then
    begin
         curso := DtmCadastroCurso.getCurso(StrToInt(edtCodigo.Text));
         if (curso <> nil) then
         begin
              try
                 edtCodigo.Text := formatfloat('00',curso.codigo);
                 edtNome.Text := curso.descicao;
                 controleAlterar;
                 edtCodigo.Enabled:=False;
                 edtCodigo.Color:=clInfoBk;

                 if (curso.codigo > 0) then
                 begin
                   edtNome.Enabled:= True;
                   edtNome.Color:=clWhite;
                   edtNome.SetFocus;
                 end;
              finally
                FreeAndNil(curso);
              end;
         end
         else
         begin
           MsgAlerta('Curso não encontrado!');
           btnCancelarClick(btnCancelar);
         end;
    end;
  end;
end;

procedure TFrmCadastroCurso.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if gControle = tpNovo then
    deletaCodigo('CURSO','COD_CURSO',StrToInt(edtCodigo.Text));
end;

procedure TFrmCadastroCurso.FormCreate(Sender: TObject);
begin
  inherited;

  DtmCadastroCurso := TDtmCadastroCurso.Create(Self);
end;

procedure TFrmCadastroCurso.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DtmCadastroCurso);
end;

procedure TFrmCadastroCurso.FormShow(Sender: TObject);
begin
  self.ActiveControl := edtCodigo;
  edtCodigo.SetFocus;
end;


procedure TFrmCadastroCurso.btnCancelarClick(Sender: TObject);
begin
  deletaCodigo('CURSO','COD_CURSO',StrToInt(edtCodigo.Text));

  edtCodigo.Clear;
  edtCodigo.Enabled:= True;
  edtCodigo.Color:=clWhite;
  edtCodigo.SetFocus;

  edtNome.Clear;
  edtNome.Enabled:=False;
  edtNome.Color:=clInfoBk;

  inherited;
end;

end.

