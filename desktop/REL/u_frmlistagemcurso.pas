unit U_FrmListagemCurso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RLReport, RLPDFFilter, RLXLSXFilter, Forms,
  Controls, Graphics, Dialogs, U_FrmRelatorioBase, db, sqldb;

type

  { TFrmListagemCurso }

  TFrmListagemCurso = class(TFrmRelatorioBase)
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    rldbCodigo: TRLDBText;
    rldbDesc: TRLDBText;
    rlbl_codigo: TRLLabel;
    rlbl_desc: TRLLabel;
    RLDBResult1: TRLDBResult;
  private

  public

  end;

var
  FrmListagemCurso: TFrmListagemCurso;

implementation

{$R *.lfm}

end.

