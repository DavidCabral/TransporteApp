unit U_FrmDlgIncluirAlterarFatura;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  MaskEdit, Buttons, U_Fatura, U_Utils;

type

  { TFrmDlgIncluirAlterarFatura }

  TFrmDlgIncluirAlterarFatura = class(TForm)
    btnOk: TSpeedButton;
    BtnCancelar: TSpeedButton;
    EdtAnoDeb: TEdit;
    EdtMesDeb: TEdit;
    EdtValorDeb: TEdit;
    gbDebito: TGroupBox;
    Label1: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    MEdtPagtoDeb: TMaskEdit;
    MEdtVenctoDeb: TMaskEdit;
    procedure btnOkClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure EdtAnoDebChange(Sender: TObject);
    procedure EdtMesDebChange(Sender: TObject);
    procedure EdtValorDebEnter(Sender: TObject);
    procedure EdtValorDebExit(Sender: TObject);
    procedure EdtValorDebKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure MEdtPagtoDebChange(Sender: TObject);
    procedure MEdtVenctoDebChange(Sender: TObject);
  private
    function salvarFatura:boolean;
  public
    gbGravou:Boolean;
    gControle : TControle;
    gsCpf:String;
  end;

var
  FrmDlgIncluirAlterarFatura: TFrmDlgIncluirAlterarFatura;

implementation

uses
  U_DtmFatura;

{$R *.lfm}

{ TFrmDlgIncluirAlterarFatura }

procedure TFrmDlgIncluirAlterarFatura.EdtValorDebEnter(Sender: TObject);
begin
  if EdtValorDeb.Text = '0,00' then
     EdtValorDeb.Clear;
end;

procedure TFrmDlgIncluirAlterarFatura.btnOkClick(Sender: TObject);
begin
     if (EdtMesDeb.Text <> '') then
     begin
       if (StrToInt(EdtMesDeb.Text) = 0) or
          (StrToInt(EdtMesDeb.Text) > 12)then
       begin
         MsgAlerta('Mês inválido!');
         EdtMesDeb.Clear;
         EdtMesDeb.SetFocus;
         Exit;
       end;
     end
     else
     begin
       MsgAlerta('Informe um mês!');
       EdtMesDeb.Clear;
       EdtMesDeb.SetFocus;
       Exit;
     end;

     if (EdtAnoDeb.Text <> '') then
     begin
       if (StrToInt(EdtAnoDeb.Text) = 0) then
       begin
         MsgAlerta('Ano inválido!');
         EdtAnoDeb.Clear;
         EdtAnoDeb.SetFocus;
         Exit;
       end;
     end
     else
     begin
       MsgAlerta('Informe um Ano');
       EdtAnoDeb.Clear;
       EdtAnoDeb.SetFocus;
       Exit;
     end;

     if ( Trim(removeCharEsp(MEdtVenctoDeb.Text)) <> '') then
     begin
       try
          StrToDate(MEdtVenctoDeb.Text);
       except
         MsgAlerta('Data de Vencimento Inválida!');
         MEdtVenctoDeb.Clear;
         MEdtVenctoDeb.SetFocus;
         Exit;
       end;
     end
     else
     begin
       MsgAlerta('Informe um Vencimento!');
       MEdtVenctoDeb.Clear;
       MEdtVenctoDeb.SetFocus;
       Exit;
     end;

     if ( Trim(removeCharEsp(MEdtPagtoDeb.Text)) <> '') then
     begin
       try
          StrToDate(MEdtPagtoDeb.Text);
       except
         MsgAlerta('Data de Pagamento Inválida!');
         MEdtPagtoDeb.Clear;
         MEdtPagtoDeb.SetFocus;
         Exit;
       end;
     end;


     if salvarFatura then
        Self.Close;
end;

procedure TFrmDlgIncluirAlterarFatura.BtnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmDlgIncluirAlterarFatura.EdtAnoDebChange(Sender: TObject);
begin
     if (length(EdtAnoDeb.Text) = 4) and (self.Showing) then
        EdtValorDeb.SetFocus;
end;

procedure TFrmDlgIncluirAlterarFatura.EdtMesDebChange(Sender: TObject);
begin
  if (length(EdtMesDeb.Text) = 2) and (self.Showing) then
     EdtAnoDeb.SetFocus;
end;

procedure TFrmDlgIncluirAlterarFatura.EdtValorDebExit(Sender: TObject);
begin
  if  (EdtValorDeb.Text = '') or (EdtValorDeb.Text = ',') then
      EdtValorDeb.Text := '0,00'
  else
    EdtValorDeb.Text:=FormatFloat('0.00',StrToFloat(EdtValorDeb.Text));
end;

procedure TFrmDlgIncluirAlterarFatura.EdtValorDebKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in ['0'..'9']) then
     if (key <> ',') and (key <> #8) then
        key := #0;
end;

procedure TFrmDlgIncluirAlterarFatura.FormCreate(Sender: TObject);
begin
  gbGravou := False;
end;

procedure TFrmDlgIncluirAlterarFatura.MEdtPagtoDebChange(Sender: TObject);
begin
  if length(Trim(MEdtPagtoDeb.Text)) = 10  then
  begin
    try
       StrToDate(MEdtPagtoDeb.Text);
    except
      MsgAlerta('Data de Pagamento Inválida!');
      MEdtPagtoDeb.Clear;
      Exit;
    end;
  end;
end;

procedure TFrmDlgIncluirAlterarFatura.MEdtVenctoDebChange(Sender: TObject);
begin
  if (length(Trim(MEdtVenctoDeb.Text)) = 10) and (self.Showing)  then
  begin
    try
       StrToDate(MEdtVenctoDeb.Text);
    except
      MsgAlerta('Data de Vencimento Inválida!');
      MEdtVenctoDeb.Clear;
      Exit;
    end;

    MEdtPagtoDeb.SetFocus;
  end;
end;

function TFrmDlgIncluirAlterarFatura.salvarFatura: boolean;
var
  fatura:TFatura;
begin
  try
    fatura := TFatura.Create;
    fatura.cpf:=gsCpf;
    fatura.ano:=StrToInt(EdtAnoDeb.Text);
    fatura.mes:=StrToInt(EdtMesDeb.Text);
    fatura.valor:=StrToFloat(EdtValorDeb.Text);
    fatura.vencimento:=StrToDateTime(MEdtVenctoDeb.Text);
    if Trim(removeCharEsp(MEdtPagtoDeb.Text)) <> '' then
      fatura.dataPagamento:=StrToDateTime(MEdtPagtoDeb.Text);
    Result := DtmFatura.salvarFatura(fatura,gControle);
    gbGravou:= Result;
  finally
    FreeAndNil(fatura);
  end;
end;

end.

