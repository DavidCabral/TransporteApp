unit U_FrmFiltroRelatorioBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons;

type

  { TFrmFiltroRelatorioBase }

  TFrmFiltroRelatorioBase = class(TForm)
    btnImprimir: TSpeedButton;
    btnSair: TSpeedButton;
    Panel1: TPanel;
    procedure btnSairClick(Sender: TObject);
  private

  public

  end;

var
  FrmFiltroRelatorioBase: TFrmFiltroRelatorioBase;

implementation

{$R *.lfm}

{ TFrmFiltroRelatorioBase }

procedure TFrmFiltroRelatorioBase.btnSairClick(Sender: TObject);
begin
  Self.Close;
end;

end.

