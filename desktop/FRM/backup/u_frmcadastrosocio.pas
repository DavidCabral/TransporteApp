unit U_FrmCadastroSocio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SpinEx, ubarcodes, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, MaskEdit, ComCtrls, DBGrids,
  U_FrmCadastroBase, U_DtmCadastroSocio, U_Socio, U_Utils, U_Curso,
  U_Instituicao, U_Mensalidade, DB, U_Fatura;

type

  { TFrmCadastroSocio }

  TFrmCadastroSocio = class(TFrmCadastroBase)
    btnCadCurso: TSpeedButton;
    btnCadInsti: TSpeedButton;
    btnCadMensalidade: TSpeedButton;
    btnCancelar2: TSpeedButton;
    btnCancelar3: TSpeedButton;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnIncluir1: TSpeedButton;
    btnListarViajens: TSpeedButton;
    btnListarDebitos: TSpeedButton;
    btnPesquisaCurso: TSpeedButton;
    btnPesquisarCurso: TSpeedButton;
    btnPesquisarInstituicao: TSpeedButton;
    btnPesquisarMensalidade: TSpeedButton;
    btnQrCodeEmail: TButton;
    btnQrCodeImp: TButton;
    btnLocalizarFoto: TButton;
    chkAtivo: TCheckBox;
    DSDebito: TDataSource;
    DSViajem: TDataSource;
    gbFoto: TGroupBox;
    gridDebito: TDBGrid;
    edtCodCurso: TEdit;
    edtCodInstituicao: TEdit;
    edtCodMensalidade: TEdit;
    edtEmail: TEdit;
    edtEndereco: TEdit;
    edtNome: TEdit;
    edtNomeCurso: TEdit;
    edtNomeInstituicao: TEdit;
    edtNomeMensalidade: TEdit;
    gbCurso: TGroupBox;
    gbInstiuicao: TGroupBox;
    gbMensalidade: TGroupBox;
    gbQrCode: TGroupBox;
    gridViajens: TDBGrid;
    Foto: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbl_Cadastrado: TLabel;
    mEdtCpf: TMaskEdit;
    mEdtTel1: TMaskEdit;
    mEdtTel2: TMaskEdit;
    mEdtValidade: TMaskEdit;
    OpenDlg: TOpenDialog;
    pnl_Debito: TPanel;
    PGSocio: TPageControl;
    pnl_Debito1: TPanel;
    QRCode: TBarcodeQR;
    TBS_Viajem: TTabSheet;
    TBS_Socio: TTabSheet;
    TBS_Debito: TTabSheet;
    procedure btnCadCursoClick(Sender: TObject);
    procedure btnCadInstiClick(Sender: TObject);
    procedure btnCadMensalidadeClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnIncluir1Click(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnLocalizarFotoClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnPesquisarCursoClick(Sender: TObject);
    procedure btnPesquisarInstituicaoClick(Sender: TObject);
    procedure btnPesquisarMensalidadeClick(Sender: TObject);
    procedure btnQrCodeImpClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtCodCursoEnter(Sender: TObject);
    procedure edtCodCursoExit(Sender: TObject);
    procedure edtCodCursoKeyPress(Sender: TObject; var Key: char);
    procedure edtCodInstituicaoEnter(Sender: TObject);
    procedure edtCodInstituicaoExit(Sender: TObject);
    procedure edtCodInstituicaoKeyPress(Sender: TObject; var Key: char);
    procedure edtCodMensalidadeEnter(Sender: TObject);
    procedure edtCodMensalidadeExit(Sender: TObject);
    procedure edtCodMensalidadeKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mEdtCpfChange(Sender: TObject);
    procedure mEdtCpfExit(Sender: TObject);
    procedure mEdtValidadeChange(Sender: TObject);
    procedure mEdtValidadeExit(Sender: TObject);
  private
    socio: TSocio;
  public

  end;

var
  FrmCadastroSocio: TFrmCadastroSocio;

implementation

{$R *.lfm}

{ TFrmCadastroSocio }

uses
  U_FrmCadastroCurso, U_frmcadastroinstituicao,
  U_frmcadastroMensalidade, U_FrmRelCarteitinhaSocio,
  U_DtmCadastroCurso, U_dtmcadastroInstituicao,
  U_dtmcadastroMensalidade, U_frmpesquisacadastroSocio,
  U_FrmDlgIncluirAlterarFatura, U_DtmFatura,
  U_FrmPesquisaCadastroCurso, U_frmpesquisacadastroInstituicao,
  U_frmpesquisacadastroMensalidade;

procedure TFrmCadastroSocio.btnIncluir1Click(Sender: TObject);
begin
  try
    FrmDlgIncluirAlterarFatura := TFrmDlgIncluirAlterarFatura.Create(Self);
    FrmDlgIncluirAlterarFatura.gControle := tpNovo;
    FrmDlgIncluirAlterarFatura.gsCpf := removeCharEsp(mEdtCpf.Text);
    FrmDlgIncluirAlterarFatura.ShowModal;

    if FrmDlgIncluirAlterarFatura.gbGravou then
      DtmFatura.abrePesquisa(removeCharEsp(mEdtCpf.Text));
  finally
    FreeAndNil(FrmDlgIncluirAlterarFatura);
  end;
end;

procedure TFrmCadastroSocio.btnExcluirClick(Sender: TObject);
begin
  if (DtmFatura.qryPesquisa.RecordCount > 0) then
  begin
    if MsgConfirmacao('Tem certeza em excluir a fatura?') then
    begin
      if DtmFatura.deleteFatura(DSDebito.DataSet.FieldByName('CPF').AsString,
        DSDebito.DataSet.FieldByName('MES').AsInteger,
        DSDebito.DataSet.FieldByName('ANO').AsInteger) then
      begin
        MsgOk('Fatura excluído!');
        DtmFatura.abrePesquisa(DSDebito.DataSet.FieldByName('CPF').AsString);
      end;
    end;
  end;
end;

procedure TFrmCadastroSocio.btnEditarClick(Sender: TObject);
begin
  if (DtmFatura.qryPesquisa.RecordCount > 0) then
  begin
    try
      FrmDlgIncluirAlterarFatura := TFrmDlgIncluirAlterarFatura.Create(Self);
      FrmDlgIncluirAlterarFatura.gControle := tpAlterar;
      FrmDlgIncluirAlterarFatura.gsCpf := removeCharEsp(mEdtCpf.Text);
      FrmDlgIncluirAlterarFatura.EdtMesDeb.Text :=
        FormatFloat('00', DtmFatura.qryPesquisa.FieldByName('MES').AsInteger);
      FrmDlgIncluirAlterarFatura.EdtAnoDeb.Text :=
        DtmFatura.qryPesquisa.FieldByName('ANO').AsString;

      FrmDlgIncluirAlterarFatura.EdtMesDeb.Enabled := False;
      FrmDlgIncluirAlterarFatura.EdtAnoDeb.Enabled := False;

      FrmDlgIncluirAlterarFatura.EdtValorDeb.Text :=
        DtmFatura.qryPesquisa.FieldByName('VALOR').AsString;
      FrmDlgIncluirAlterarFatura.MEdtVenctoDeb.Text :=
        DtmFatura.qryPesquisa.FieldByName('VENCIMENTO').AsString;
      FrmDlgIncluirAlterarFatura.MEdtPagtoDeb.Text :=
        DtmFatura.qryPesquisa.FieldByName('DATA_PAGAMENTO').AsString;
      FrmDlgIncluirAlterarFatura.ShowModal;

      if FrmDlgIncluirAlterarFatura.gbGravou then
        DtmFatura.abrePesquisa(removeCharEsp(mEdtCpf.Text));
    finally
      FreeAndNil(FrmDlgIncluirAlterarFatura);
    end;
  end;
end;

procedure TFrmCadastroSocio.btnCadCursoClick(Sender: TObject);
begin
  try
    FrmCadastroCurso := TFrmCadastroCurso.Create(Self);
    FrmCadastroCurso.ShowModal;
    if (FrmCadastroCurso.edtCodigo.Text <> '') then
    begin
      edtCodCurso.Text := FrmCadastroCurso.edtCodigo.Text;
      edtCodCursoExit(edtCodCurso);
    end;
  finally
    FreeAndNil(FrmCadastroCurso);
  end;
end;

procedure TFrmCadastroSocio.btnCadInstiClick(Sender: TObject);
begin
  try
    frmcadastroinstituicao := Tfrmcadastroinstituicao.Create(Self);
    frmcadastroinstituicao.ShowModal;
    if (frmcadastroinstituicao.edtCodigo.Text <> '') then
    begin
      edtCodInstituicao.Text := frmcadastroinstituicao.edtCodigo.Text;
      edtCodInstituicaoExit(edtCodInstituicao);
    end;
  finally
    FreeAndNil(frmcadastroinstituicao);
  end;
end;

procedure TFrmCadastroSocio.btnCadMensalidadeClick(Sender: TObject);
begin
  try
    frmcadastroMensalidade := TfrmcadastroMensalidade.Create(Self);
    frmcadastroMensalidade.ShowModal;
    if (frmcadastroMensalidade.edtCodigo.Text <> '') then
    begin
      edtCodMensalidade.Text := frmcadastroMensalidade.edtCodigo.Text;
      edtCodMensalidadeExit(edtCodMensalidade);
    end;
  finally
    FreeAndNil(frmcadastroMensalidade);
  end;
end;

procedure TFrmCadastroSocio.btnCancelarClick(Sender: TObject);
begin
  PGSocio.ActivePage := TBS_Socio;

  mEdtCpf.Clear;
  mEdtCpf.Enabled := True;
  mEdtCpf.Color := clWhite;
  mEdtCpf.SetFocus;

  chkAtivo.Checked := False;
  chkAtivo.Enabled := False;

  edtNome.Clear;
  edtNome.Enabled := False;

  mEdtTel1.Clear;
  mEdtTel1.Enabled := False;

  mEdtTel2.Clear;
  mEdtTel2.Enabled := False;

  mEdtValidade.Clear;
  mEdtValidade.Enabled := False;

  edtEndereco.Clear;
  edtEndereco.Enabled := False;

  edtEmail.Clear;
  edtEmail.Enabled := False;

  gbCurso.Enabled := False;
  edtCodCurso.Clear;
  edtNomeCurso.Clear;

  gbMensalidade.Enabled := False;
  edtCodMensalidade.Clear;
  edtNomeMensalidade.Clear;

  gbInstiuicao.Enabled := False;
  edtCodInstituicao.Clear;
  edtNomeInstituicao.Clear;

  gbQrCode.Visible := False;
  QRCode.Text := '';
  QRCode.Generate;

  foto.Picture.Clear;
  gbFoto.Enabled:= False;

  DtmFatura.qryPesquisa.Close;
  DtmCadastroSocio.qryPesquisaViajem.Close;

  rollBackTransaction;

  pnl_Debito.Enabled := False;
  TBS_Viajem.TabVisible := False;

  inherited;
end;

procedure TFrmCadastroSocio.btnIncluirClick(Sender: TObject);
begin
  inherited;

  chkAtivo.Enabled := True;
  chkAtivo.Checked := True;
  edtNome.Enabled := True;
  edtEndereco.Enabled := True;
  mEdtTel1.Enabled := True;
  mEdtTel2.Enabled := True;
  mEdtValidade.Enabled:= True;
  edtEmail.Enabled := True;
  gbCurso.Enabled := True;
  gbMensalidade.Enabled := True;
  gbInstiuicao.Enabled := True;
end;

procedure TFrmCadastroSocio.btnLocalizarFotoClick(Sender: TObject);
var
  bmp: TBitmap;
  JPEGImage: TJPEGImage;
  R : TRect;
begin
  if OpenDlg.Execute then
  begin
    bmp := TBitmap.Create;
    JPEGImage := TJPEGImage.Create;
    JPEGImage.LoadFromFile(OpenDlg.FileName);

    try
      R := Rect(0, 0, 71, 85);
      bmp.Assign(JPEGImage);
      bmp.SetSize(71, 85);
      bmp.Canvas.StretchDraw(R, JPEGImage);
      foto.Picture.Bitmap := bmp;
    finally
      bmp.Free;
      JPEGImage.Free;
    end;
  end;
end;

procedure TFrmCadastroSocio.btnPesquisarClick(Sender: TObject);
begin
  try
    frmpesquisacadastroSocio := TfrmpesquisacadastroSocio.Create(Self);
    frmpesquisacadastroSocio.ShowModal;

    if frmpesquisacadastroSocio.gControle = tpAlterar then
    begin
      mEdtCpf.Text := frmpesquisacadastroSocio.DSGrid.DataSet.FieldByName(
        'CPF').AsString;
      mEdtCpfExit(mEdtCpf);
    end;

  finally
    FreeAndNil(frmpesquisacadastroSocio);
  end;
end;

procedure TFrmCadastroSocio.btnPesquisarCursoClick(Sender: TObject);
begin
  try
    FrmCadastroCurso := TFrmCadastroCurso.Create(Self);
    FrmPesquisaCadastroCurso := TFrmPesquisaCadastroCurso.Create(Self);
    FrmPesquisaCadastroCurso.btnExcluir.Visible:= False;
    FrmPesquisaCadastroCurso.btnListar.Visible:=False;
    FrmPesquisaCadastroCurso.ShowModal;

    if FrmPesquisaCadastroCurso.gControle = tpAlterar then
    begin
      edtCodCurso.Text := FrmPesquisaCadastroCurso.DSGrid.DataSet.FieldByName(
        'CODIGO').AsString;
      edtCodCursoExit(edtCodCurso);
    end;

  finally
    FreeAndNil(FrmPesquisaCadastroCurso);
    FreeAndNil(FrmCadastroCurso);
  end;
end;

procedure TFrmCadastroSocio.btnPesquisarInstituicaoClick(Sender: TObject);
begin
  try
    frmcadastroinstituicao := Tfrmcadastroinstituicao.Create(Self);
    frmpesquisacadastroInstituicao := TfrmpesquisacadastroInstituicao.Create(Self);
    frmpesquisacadastroInstituicao.btnListar.Visible:= False;
    frmpesquisacadastroInstituicao.btnExcluir.Visible:=False;
    frmpesquisacadastroInstituicao.ShowModal;

    if frmpesquisacadastroInstituicao.gControle = tpAlterar then
    begin
      edtCodInstituicao.Text := frmpesquisacadastroInstituicao.DSGrid.DataSet.FieldByName('CODIGO').AsString;
      edtCodInstituicaoExit(edtCodInstituicao);
    end;

  finally
    FreeAndNil(frmpesquisacadastroInstituicao);
    FreeAndNil(frmcadastroinstituicao);
  end;
end;

procedure TFrmCadastroSocio.btnPesquisarMensalidadeClick(Sender: TObject);
begin
  try
    frmcadastroMensalidade := TfrmcadastroMensalidade.Create(Self);
    frmpesquisacadastroMensalidade := TfrmpesquisacadastroMensalidade.Create(Self);
    frmpesquisacadastroMensalidade.btnExcluir.Visible:=False;
    frmpesquisacadastroMensalidade.btnListar.Visible:=False;
    frmpesquisacadastroMensalidade.ShowModal;

    if frmpesquisacadastroMensalidade.gControle = tpAlterar then
    begin
      edtCodMensalidade.Text := frmpesquisacadastroMensalidade.DSGrid.DataSet.FieldByName(
        'CODIGO').AsString;
      edtCodMensalidadeExit(edtCodMensalidade);
    end;

  finally
    FreeAndNil(frmpesquisacadastroMensalidade);
    FreeAndNil(frmcadastroMensalidade);
  end;
end;

procedure TFrmCadastroSocio.btnQrCodeImpClick(Sender: TObject);
var
  bmp: TBitmap;
  R: TRect;
  st:TMemoryStream;
  instituicao: TInstituicao;
begin
  try
    FrmRelCarteitinhaSocio := TFrmRelCarteitinhaSocio.Create(Self);

    bmp := TBitmap.Create;
    st := TMemoryStream.Create;
    try
      R := Rect(0, 0, 90, 90);
      bmp.SetSize(90, 90);
      bmp.Canvas.Brush.Color := clWhite;
      bmp.Canvas.FillRect(R);
      QRCode.PaintOnCanvas(bmp.Canvas, R);
      FrmRelCarteitinhaSocio.rlimgqrcode.Picture.Bitmap := bmp;
      if not foto.Picture.Bitmap.Empty then
        FrmRelCarteitinhaSocio.rlImgFoto.Picture := foto.Picture;

    finally
      bmp.Free;
      st.free;
    end;

    FrmRelCarteitinhaSocio.rlblNome.Caption := edtNome.Text;
    FrmRelCarteitinhaSocio.rlblCurso.Caption := edtNomeCurso.Text;


    if (Trim(edtCodInstituicao.Text) <> '') then
    begin
      dtmcadastroInstituicao := TdtmcadastroInstituicao.Create(Self);
      try
        instituicao := dtmcadastroInstituicao.getInstituicao(
          StrToInt(edtCodInstituicao.Text));

        if instituicao <> nil then
        begin
          FrmRelCarteitinhaSocio.rlblInstituicao.Caption := instituicao.sigla;
        end;
      finally
        FreeAndNil(instituicao);
        FreeAndNil(dtmcadastroInstituicao);
      end;
    end;

    if Trim(removeCharEsp(mEdtValidade.Text)) <> '' then
        FrmRelCarteitinhaSocio.rlblDataValidade.Caption := copy(mEdtValidade.Text,4,length(mEdtValidade.Text));

    FrmRelCarteitinhaSocio.RLReport1.PreviewModal;
  finally
    FreeAndNil(FrmRelCarteitinhaSocio);
  end;
end;

procedure TFrmCadastroSocio.btnSalvarClick(Sender: TObject);
var
   st:TStream;
begin
  if (Trim(edtNome.Text) = '') then
  begin
    MsgAlerta('Informe o nome!');
    edtNome.SetFocus;
    Exit;
  end;

  if (Trim(removeCharEsp(mEdtCpf.Text)) = '') then
  begin
    MsgAlerta('Informe o CPF!');
    mEdtCpf.SetFocus;
    Exit;
  end;

  if (Trim(removeCharEsp(mEdtTel1.Text)) = '') and
    (Trim(removeCharEsp(mEdtTel2.Text)) = '') then
  begin
    MsgAlerta('Informe um telefone!');
    mEdtTel1.SetFocus;
    Exit;
  end;

  if (Trim(removeCharEsp(edtEndereco.Text)) = '') then
  begin
    MsgAlerta('Informe o Endereço!');
    edtEndereco.SetFocus;
    Exit;
  end;

  if (Trim(removeCharEsp(mEdtValidade.Text)) = '') then
  begin
    MsgAlerta('Informe a validade do sócio!');
    mEdtValidade.SetFocus;
    Exit;
  end;

  if (Trim(removeCharEsp(edtEmail.Text)) = '') then
  begin
    MsgAlerta('Informe o E-mail!');
    edtEmail.SetFocus;
    Exit;
  end;

  if (Trim(removeCharEsp(edtCodCurso.Text)) = '') then
  begin
    MsgAlerta('Informe um curso!');
    edtCodCurso.SetFocus;
    Exit;
  end;

  if (Trim(removeCharEsp(edtCodMensalidade.Text)) = '') then
  begin
    MsgAlerta('Informe uma mensalidade!');
    edtCodMensalidade.SetFocus;
    Exit;
  end;

  if (Trim(removeCharEsp(edtCodInstituicao.Text)) = '') then
  begin
    MsgAlerta('Informe uma instituicao!');
    edtCodInstituicao.SetFocus;
    Exit;
  end;

  try
    if gControle = tpNovo then
      socio := TSocio.Create;
    socio.nome := edtNome.Text;
    socio.ativo := chkAtivo.Checked;
    if not lbl_Cadastrado.Visible then
      socio.dataCadastramento := now;
    socio.documento := removeCharEsp(mEdtCpf.Text);
    socio.fone := removeCharEsp(mEdtTel1.Text);
    socio.fone2 := removeCharEsp(mEdtTel2.Text);
    socio.endereco := edtEndereco.Text;
    socio.email := edtEmail.Text;
    socio.Validade:= StrToDate(mEdtValidade.Text);

    socio.Curso := TCurso.Create;
    socio.Curso.codigo := StrToInt(edtCodCurso.Text);

    socio.instituicao := TInstituicao.Create;
    socio.Instituicao.codigo := StrToInt(edtCodInstituicao.Text);

    socio.mensalidade := TMensalidade.Create;
    socio.Mensalidade.codigo := StrToInt(edtCodMensalidade.Text);

    if not foto.Picture.Bitmap.Empty then
    begin
      socio.foto := TMemoryStream.Create;
      foto.Picture.Graphic.SaveToStream(socio.foto);
    end;

    if DtmCadastroSocio.salvarSocio(socio, gControle) then
    begin
      if gControle = tpNovo then
        MsgOk('Sócio cadastrado com sucesso!')
      else
        MsgOk('Sócio alterado com sucesso!');
    end;
  finally
    FreeAndNil(socio);
  end;

  btnCancelarClick(btnCancelar);

  inherited;
end;

procedure TFrmCadastroSocio.edtCodCursoEnter(Sender: TObject);
begin
end;

procedure TFrmCadastroSocio.edtCodCursoExit(Sender: TObject);
var
  curso: TCurso;
begin
  if Trim(edtCodCurso.Text) <> '' then
  begin
    DtmCadastroCurso := TDtmCadastroCurso.Create(Self);
    try
      curso := DtmCadastroCurso.getCurso(StrToInt(edtCodCurso.Text));
      if curso = nil then
      begin
        MsgAlerta('Curso não encontrado!');
        edtCodCurso.SetFocus;
        Exit;
      end;

      edtNomeCurso.Text := curso.descicao;
    finally
      FreeAndNil(curso);
      FreeAndNil(DtmCadastroCurso);
    end;
  end;
end;

procedure TFrmCadastroSocio.edtCodCursoKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    selectnext(activecontrol, True, True);
end;

procedure TFrmCadastroSocio.edtCodInstituicaoEnter(Sender: TObject);
begin
end;

procedure TFrmCadastroSocio.edtCodInstituicaoExit(Sender: TObject);
var
  instituicao: TInstituicao;
begin
  if Trim(edtCodInstituicao.Text) <> '' then
  begin
    dtmcadastroInstituicao := TdtmcadastroInstituicao.Create(Self);
    try
      instituicao := dtmcadastroInstituicao.getInstituicao(
        StrToInt(edtCodInstituicao.Text));
      if instituicao = nil then
      begin
        MsgAlerta('Instituição não encontrada!');
        edtCodInstituicao.SetFocus;
        Exit;
      end;

      edtNomeInstituicao.Text := instituicao.descicao;
    finally
      FreeAndNil(instituicao);
      FreeAndNil(dtmcadastroInstituicao);
    end;
  end;
end;

procedure TFrmCadastroSocio.edtCodInstituicaoKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    selectnext(activecontrol, True, True);
end;

procedure TFrmCadastroSocio.edtCodMensalidadeEnter(Sender: TObject);
begin
end;

procedure TFrmCadastroSocio.edtCodMensalidadeExit(Sender: TObject);
var
  mensalidade: TMensalidade;
begin
  if Trim(edtCodMensalidade.Text) <> '' then
  begin
    dtmcadastroMensalidade := TdtmcadastroMensalidade.Create(Self);
    try
      mensalidade := dtmcadastroMensalidade.getMensalidade(
        StrToInt(edtCodMensalidade.Text));
      if mensalidade = nil then
      begin
        MsgAlerta('Mensalidade não encontrada!');
        edtCodMensalidade.SetFocus;
        Exit;
      end;

      edtNomeMensalidade.Text := mensalidade.descicao;
    finally
      FreeAndNil(mensalidade);
      FreeAndNil(dtmcadastroMensalidade);
    end;
  end;
end;

procedure TFrmCadastroSocio.edtCodMensalidadeKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    selectnext(activecontrol, True, True);
end;

procedure TFrmCadastroSocio.FormCreate(Sender: TObject);
begin
  inherited;
  PGSocio.ActivePage := TBS_Socio;
  TBS_Viajem.TabVisible := False;
  pnl_Debito.Enabled := False;

  DtmCadastroSocio := TDtmCadastroSocio.Create(Self);
  DtmFatura := TDtmFatura.Create(Self);
end;

procedure TFrmCadastroSocio.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DtmCadastroSocio);
  FreeAndNil(DtmFatura);
end;

procedure TFrmCadastroSocio.FormShow(Sender: TObject);
begin
  self.ActiveControl := mEdtCpf;
  mEdtCpf.SetFocus;
end;

procedure TFrmCadastroSocio.mEdtCpfChange(Sender: TObject);
begin
  if Length(Trim(removeCharEsp(mEdtCpf.Text))) = 11 then
    TBS_Socio.SetFocus;
end;

procedure TFrmCadastroSocio.mEdtCpfExit(Sender: TObject);
begin
  if (Trim(removeCharEsp(mEdtCpf.Text)) <> '') then
  begin
    if not validaCpf(mEdtCpf.Text) then
    begin
      MsgAlerta('CPF Inválido!');
      mEdtCpf.SetFocus;
      Exit;
    end;
  end;

  if gControle = tpNovo then
  begin
    if (DtmCadastroSocio.getSocio(removeCharEsp(mEdtCpf.Text)) <> nil) then
    begin
      MsgAlerta('CPF Inválido!');
      mEdtCpf.SetFocus;
      Exit;
    end;
  end;

  begin
    if gControle = tpConsulta then
    begin
      if (Trim(removeCharEsp(mEdtCpf.Text)) <> '') then
      begin
        socio := DtmCadastroSocio.getSocio(removeCharEsp(mEdtCpf.Text));
        if (socio <> nil) then
        begin
          controleAlterar;
          edtNome.Text := socio.nome;
          chkAtivo.Checked := socio.ativo;
          lbl_Cadastrado.Caption :=
            'Cadastrado em: ' + DateTimeToStr(socio.dataCadastramento);
          mEdtCpf.Text := removeCharBranco(socio.documento);
          mEdtTel1.Text := removeCharBranco(socio.fone);
          mEdtTel2.Text := removeCharBranco(socio.fone2);
          edtEndereco.Text := socio.endereco;
          edtEmail.Text := socio.email;
          edtCodCurso.Text := IntToStr(socio.Curso.codigo);
          edtNomeCurso.Text := socio.curso.descicao;
          edtCodInstituicao.Text := IntToStr(socio.Instituicao.codigo);
          edtNomeInstituicao.Text := socio.instituicao.descicao;
          edtCodMensalidade.Text := IntToStr(socio.Mensalidade.codigo);
          edtNomeMensalidade.Text := socio.mensalidade.descicao;
          if socio.Validade <> 0 then
            mEdtValidade.Text:= DateToStr(socio.Validade);

          mEdtCpf.Enabled := False;
          mEdtCpf.Color := clInfoBk;

          chkAtivo.Enabled := True;
          edtNome.Enabled := True;
          mEdtTel1.Enabled := True;
          mEdtTel2.Enabled := True;
          mEdtValidade.Enabled := True;
          edtEndereco.Enabled := True;
          edtEmail.Enabled := True;
          gbCurso.Enabled := True;
          gbMensalidade.Enabled := True;
          gbInstiuicao.Enabled := True;

          //gbQrCode.Visible := True;
          QRCode.Text := removeCharEsp(mEdtCpf.Text);
          QRCode.Generate;

          if socio.foto <> nil then
          begin
            foto.Picture.LoadFromStream(socio.foto);
          end;

          gbFoto.Enabled:= True;
          pnl_Debito.Enabled := True;
          DtmFatura.abrePesquisa(removeCharEsp(mEdtCpf.Text));

          TBS_Viajem.TabVisible :=
            DtmCadastroSocio.carregaHstViajem(removeCharEsp(mEdtCpf.Text));

          gControle := tpAlterar;
        end
        else
        begin
          MsgAlerta('Sócio não encontrado!');
          btnCancelarClick(btnCancelar);
        end;
      end;
    end;
  end;
end;

procedure TFrmCadastroSocio.mEdtValidadeChange(Sender: TObject);
begin
  if mEdtValidade.Focused then
    if Length(Trim(removeCharEsp(mEdtValidade.Text))) = 8 then
       edtEndereco.SetFocus;
end;

procedure TFrmCadastroSocio.mEdtValidadeExit(Sender: TObject);
var
  ldtAux:TDateTime;
begin
     if Trim(removeCharEsp(mEdtValidade.Text)) <> '' then
     begin
       if not TryStrToDate(mEdtValidade.Text,ldtAux) then
       begin
         MsgAlerta('Data inválida!');
         mEdtValidade.Clear;
         mEdtValidade.SetFocus;
       end;
     end;
end;

end.
