unit u_frmFiltroRelatorioCarteirinhas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  MaskEdit, StdCtrls, U_FrmFiltroRelatorioBase, U_Utils, U_DtmCadastroSocio,
  U_frmrelcarteirinhasocioTodas;

type

  { TFrmFiltroRelatorioCarteirinhas }

  TFrmFiltroRelatorioCarteirinhas = class(TFrmFiltroRelatorioBase)
    btnIncluir: TSpeedButton;
    btnRemover: TSpeedButton;
    ckSocios: TCheckBox;
    gbSocios: TGroupBox;
    Label3: TLabel;
    listSocios: TListBox;
    mEdtCpf: TMaskEdit;
    procedure btnImprimirClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure ckSociosChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mEdtCpfChange(Sender: TObject);
    procedure mEdtCpfExit(Sender: TObject);
    procedure mEdtCpfKeyPress(Sender: TObject; var Key: char);
  private

  public

  end;

var
  FrmFiltroRelatorioCarteirinhas: TFrmFiltroRelatorioCarteirinhas;

implementation

{$R *.lfm}

{ TFrmFiltroRelatorioCarteirinhas }

procedure TFrmFiltroRelatorioCarteirinhas.mEdtCpfChange(Sender: TObject);
begin
end;

procedure TFrmFiltroRelatorioCarteirinhas.btnIncluirClick(Sender: TObject);
begin
  if (Trim(removeCharEsp(mEdtCpf.Text)) <> '') then
  begin
    if listSocios.Items.IndexOf(formataCpfCnpj(mEdtCpf.Text)) > 0 then
    begin
      MsgAlerta('Sócio já adicionado!');
      mEdtCpf.Clear;
      mEdtCpf.SetFocus;
      Exit;
    end;

    if not validaCpf(mEdtCpf.Text) then
    begin
      MsgAlerta('CPF Inválido!');
      mEdtCpf.SetFocus;
      Exit;
    end;

    if DtmCadastroSocio.getSocio(Trim(removeCharEsp(mEdtCpf.Text))) = nil then
    begin
      MsgAlerta('CPF não Cadastrado!');
      mEdtCpf.SetFocus;
      Exit;
    end;

    listSocios.items.Add(formataCpfCnpj(mEdtCpf.Text));
    mEdtCpf.Clear;
    mEdtCpf.SetFocus;
  end;
end;

procedure TFrmFiltroRelatorioCarteirinhas.btnImprimirClick(Sender: TObject);
begin
  frmrelcarteirinhasocioTodas := TfrmrelcarteirinhasocioTodas.Create(Self);
  try
    if frmrelcarteirinhasocioTodas.CarregaCarteirinhas(listSocios) then
      frmrelcarteirinhasocioTodas.RLReport1.PreviewModal;
  finally
    FreeAndNil(frmrelcarteirinhasocioTodas);
  end;
end;

procedure TFrmFiltroRelatorioCarteirinhas.btnRemoverClick(Sender: TObject);
var
  i: integer;
begin
  if listSocios.SelCount > 0 then
  begin
    for i := listSocios.Items.Count - 1 downto 0 do
      if listSocios.Selected[i] then
        listSocios.Items.Delete(i);
  end
  else
  begin
    ShowMessage('Selecione um CPF!');
  end;
end;

procedure TFrmFiltroRelatorioCarteirinhas.ckSociosChange(Sender: TObject);
begin
  if ckSocios.Checked then
  begin
    gbSocios.Enabled:= True;
  end
  else
  begin
    mEdtCpf.Clear;
    listSocios.Clear;
    gbSocios.Enabled:= False;
  end;
end;

procedure TFrmFiltroRelatorioCarteirinhas.FormCreate(Sender: TObject);
begin
  DtmCadastroSocio := TDtmCadastroSocio.Create(Self);
end;

procedure TFrmFiltroRelatorioCarteirinhas.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DtmCadastroSocio);
end;

procedure TFrmFiltroRelatorioCarteirinhas.mEdtCpfExit(Sender: TObject);
begin

end;

procedure TFrmFiltroRelatorioCarteirinhas.mEdtCpfKeyPress(Sender: TObject;
  var Key: char);
begin
  if key = #13 then
     btnIncluir.Click;
end;

end.
