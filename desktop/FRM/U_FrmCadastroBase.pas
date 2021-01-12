unit U_FrmCadastroBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, ComCtrls, U_Utils;

type

  { TFrmCadastroBase }

  TFrmCadastroBase = class(TForm)
    btnCancelar: TSpeedButton;
    Panel1: TPanel;
    btnIncluir: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnPesquisar: TSpeedButton;
    btnSair: TSpeedButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);

  Protected
    gControle : TControle;
    procedure controleAlterar;

  private

  public

  end;

var
  FrmCadastroBase: TFrmCadastroBase;

implementation

{$R *.lfm}

{ TFrmCadastroBase }

uses
  U_FrmPesquisaBase;

procedure TFrmCadastroBase.btnSairClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmCadastroBase.btnSalvarClick(Sender: TObject);
begin
  btnIncluir.Enabled:=True;
  btnSalvar.Enabled:=False;
  btnCancelar.Enabled:=False;
  btnPesquisar.Enabled:=True;
end;


procedure TFrmCadastroBase.btnIncluirClick(Sender: TObject);
begin
  gControle:= tpNovo;
  btnIncluir.Enabled:=False;
  btnSalvar.Enabled:=True;
  btnCancelar.Enabled:=True;
  btnPesquisar.Enabled:=False;
end;

procedure TFrmCadastroBase.btnCancelarClick(Sender: TObject);
begin
  gControle:=tpConsulta;
  btnIncluir.Enabled:=True;
  btnSalvar.Enabled:=False;
  btnCancelar.Enabled:=False;
  btnPesquisar.Enabled:=True;
end;

procedure TFrmCadastroBase.FormCreate(Sender: TObject);
begin
  gControle:= tpConsulta;
end;

procedure TFrmCadastroBase.FormKeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
  begin
    SelectNext(ActiveControl as TWinControl,True,True);
    key:=#0;
  end;
end;

procedure TFrmCadastroBase.controleAlterar;
begin
  gControle:= tpAlterar;
  btnIncluir.Enabled:=False;
  btnSalvar.Enabled:=True;
  btnCancelar.Enabled:=True;
  btnPesquisar.Enabled:=False;
end;



end.

