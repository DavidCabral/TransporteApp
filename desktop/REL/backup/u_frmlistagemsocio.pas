unit U_FrmListagemSocio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RLReport, RLPDFFilter, RLXLSXFilter, Forms,
  Controls, Graphics, Dialogs, U_FrmRelatorioBase, db, BufDataset, sqldb, memds;

type

  { TFrmListagemSocio }

  TFrmListagemSocio = class(TFrmRelatorioBase)
    CDSDebito: TBufDataset;
    DSDebito: TDataSource;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLBand4: TRLBand;
    RLGroup1: TRLGroup;
    RLSubDetail1: TRLSubDetail;
    procedure FormCreate(Sender: TObject);
    procedure RLGroup1BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private

  public

  end;

var
  FrmListagemSocio: TFrmListagemSocio;

implementation

{$R *.lfm}

{ TFrmListagemSocio }

procedure TFrmListagemSocio.RLGroup1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  CDSDebito.Filtered:= False;
  CDSDebito.Filter:= 'CPF = ' + QuotedStr(QryRel.FieldByName('CPF').AsString);
  CDSDebito.Filtered:= True;
end;

procedure TFrmListagemSocio.FormCreate(Sender: TObject);
begin
  inherited;

  CDSDebito.Close;
  CDSDebito.FieldDefs.Add('CPF',ftString,20);
  CDSDebito.FieldDefs.Add('MES_ANO',ftString,10);
  CDSDebito.FieldDefs.Add('DATA_GERACAO',ftDateTime);
  CDSDebito.FieldDefs.Add('DATA_PAGAMENTO',ftDateTime);
  CDSDebito.FieldDefs.Add('VENCIMENTO',ftDateTime);
  CDSDebito.FieldDefs.Add('VALOR',ftCurrency);
  TCurrencyField(CDSDebito.FieldDefs.Find('VALOR')).DisplayFormat:='###,###,##0.00';
  //CDSDebito.CreateTable;
  CDSDebito.Open;

end;

end.

