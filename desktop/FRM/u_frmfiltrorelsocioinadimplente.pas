unit U_FrmFiltroRelSocioInadimplente;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, U_FrmFiltroRelatorioBase, U_Utils;

type

  { TFrmFiltroRelSocioInadimplente }

  TFrmFiltroRelSocioInadimplente = class(TFrmFiltroRelatorioBase)
    chkDetalharFaturas: TCheckBox;
    rgStatus: TRadioGroup;
    procedure btnImprimirClick(Sender: TObject);
  private

  public

  end;

var
  FrmFiltroRelSocioInadimplente: TFrmFiltroRelSocioInadimplente;

implementation

uses
  U_FrmRelSociosInadimplentes;
{$R *.lfm}

{ TFrmFiltroRelSocioInadimplente }

procedure TFrmFiltroRelSocioInadimplente.btnImprimirClick(Sender: TObject);
var
  lsFiltroSql:String;
begin

  lsFiltroSql := '';

  FrmRelSociosInadimplentes := TFrmRelSociosInadimplentes.Create(Self);
  try
    btnImprimir.Enabled:= False;
    if rgStatus.ItemIndex = 1 then
    begin
      lsFiltroSql:= lsFiltroSql + ' AND S.ATIVO = ''S''';
      FrmRelSociosInadimplentes.rlbl_FiltroStatus.Caption:='Status: Ativo';
    end
    else if rgStatus.ItemIndex = 2 then
    begin
        lsFiltroSql:= lsFiltroSql + ' AND S.ATIVO = ''N''';
        FrmRelSociosInadimplentes.rlbl_FiltroStatus.Caption:='Status: Inativo';
    end
    else
      FrmRelSociosInadimplentes.rlbl_FiltroStatus.Caption:='Status: Geral';

    FrmRelSociosInadimplentes.gbListaFaturas:=chkDetalharFaturas.Checked;

    if FrmRelSociosInadimplentes.carregaRelatorio(lsFiltroSql) then
      FrmRelSociosInadimplentes.RLReport1.PreviewModal
    else
      MsgAlerta('Sem registros para este filtro!');
  finally
    btnImprimir.Enabled:= True;
    FreeAndNil(FrmRelSociosInadimplentes);
  end;
end;

end.

