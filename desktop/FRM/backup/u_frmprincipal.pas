unit U_FrmPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, JSONPropStorage, U_Utils;

type

  { TFrmPrincipal }

  TFrmPrincipal = class(TForm)
    btnSincronizar: TBitBtn;
    btnCadastroSocio: TBitBtn;
    btnCadastroCurso: TBitBtn;
    btnCadastroMensalidade: TBitBtn;
    btnCadastroInstituicao: TBitBtn;
    btnSair: TBitBtn;
    Image1: TImage;
    MiRelatoriosSociosInadimplentes: TMenuItem;
    MiRelatorios: TMenuItem;
    MiRelatoriosCarteirinhas: TMenuItem;
    miCadastroCurso: TMenuItem;
    miCadastroMensalidade: TMenuItem;
    miCadastroInstituicao: TMenuItem;
    mmPrincipal: TMainMenu;
    miCadastros: TMenuItem;
    miSistema: TMenuItem;
    miSistemaSair: TMenuItem;
    miCadastroSocio: TMenuItem;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    procedure btnCadastroCursoClick(Sender: TObject);
    procedure btnCadastroInstituicaoClick(Sender: TObject);
    procedure btnCadastroMensalidadeClick(Sender: TObject);
    procedure btnCadastroSocioClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnSincronizarClick(Sender: TObject);
    procedure miCadastroCursoClick(Sender: TObject);
    procedure miCadastroInstituicaoClick(Sender: TObject);
    procedure miCadastroMensalidadeClick(Sender: TObject);
    procedure miCadastroSocioClick(Sender: TObject);
    procedure MiRelatoriosCarteirinhasClick(Sender: TObject);
    procedure MiRelatoriosSociosInadimplentesClick(Sender: TObject);
    procedure miSistemaSairClick(Sender: TObject);
  private

  public

  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.lfm}

{ TFrmPrincipal }

uses
  U_FrmCadastroCurso, U_frmcadastroinstituicao,
  U_frmcadastroMensalidade, U_FrmCadastroSocio,
  U_FrmProgress, u_frmFiltroRelatorioCarteirinhas,
  U_FrmFiltroRelSocioInadimplente;

procedure TFrmPrincipal.btnCadastroSocioClick(Sender: TObject);
begin
  try
    FrmCadastroSocio := TFrmCadastroSocio.Create(Self);
    FrmCadastroSocio.ShowModal;
  finally
    FreeAndNil(FrmCadastroSocio);
  end;
end;

procedure TFrmPrincipal.btnCadastroCursoClick(Sender: TObject);
begin
  try
    FrmCadastroCurso := TFrmCadastroCurso.Create(Self);
    FrmCadastroCurso.ShowModal;
  finally
    FreeAndNil(FrmCadastroCurso);
  end;
end;

procedure TFrmPrincipal.btnCadastroInstituicaoClick(Sender: TObject);
begin
  try
    frmcadastroinstituicao := Tfrmcadastroinstituicao.Create(Self);
    frmcadastroinstituicao.ShowModal;
  finally
    FreeAndNil(frmcadastroinstituicao);
  end;
end;

procedure TFrmPrincipal.btnCadastroMensalidadeClick(Sender: TObject);
begin
  try
    frmcadastroMensalidade := TfrmcadastroMensalidade.Create(Self);
    frmcadastroMensalidade.ShowModal;
  finally
    FreeAndNil(frmcadastroMensalidade);
  end;
end;

procedure TFrmPrincipal.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmPrincipal.btnSincronizarClick(Sender: TObject);
begin
    if MsgConfirmacao('Deseja sincronizar o aparelho?') then
      sincronizaAparelho();
end;

procedure TFrmPrincipal.miCadastroCursoClick(Sender: TObject);
begin
  try
    FrmCadastroCurso := TFrmCadastroCurso.Create(Self);
    FrmCadastroCurso.ShowModal;
  finally
    FreeAndNil(FrmCadastroCurso);
  end;
end;

procedure TFrmPrincipal.miCadastroInstituicaoClick(Sender: TObject);
begin
  try
    frmcadastroinstituicao := Tfrmcadastroinstituicao.Create(Self);
    frmcadastroinstituicao.ShowModal;
  finally
    FreeAndNil(frmcadastroinstituicao);
  end;
end;

procedure TFrmPrincipal.miCadastroMensalidadeClick(Sender: TObject);
begin
  try
    frmcadastroMensalidade := TfrmcadastroMensalidade.Create(Self);
    frmcadastroMensalidade.ShowModal;
  finally
    FreeAndNil(frmcadastroMensalidade);
  end;
end;

procedure TFrmPrincipal.miCadastroSocioClick(Sender: TObject);
begin
  try
    FrmCadastroSocio := TFrmCadastroSocio.Create(Self);
    FrmCadastroSocio.ShowModal;
  finally
    FreeAndNil(FrmCadastroSocio);
  end;
end;

procedure TFrmPrincipal.MiRelatoriosCarteirinhasClick(Sender: TObject);
begin
  frmrelcarteirinhasocioTodas := TfrmrelcarteirinhasocioTodas.Create(Self);
  try
    if frmrelcarteirinhasocioTodas.CarregaCarteirinhas then
      frmrelcarteirinhasocioTodas.RLReport1.PreviewModal;
  finally
    FreeAndNil(frmrelcarteirinhasocioTodas);
  end;
end;

procedure TFrmPrincipal.MiRelatoriosSociosInadimplentesClick(Sender: TObject);
begin
  FrmFiltroRelSocioInadimplente := TFrmFiltroRelSocioInadimplente.Create(Self);
  try
    FrmFiltroRelSocioInadimplente.ShowModal;
  finally
    FreeAndNil(FrmFiltroRelSocioInadimplente);
  end;
end;

procedure TFrmPrincipal.miSistemaSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.

