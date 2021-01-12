unit U_Utils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, LCLType, U_DtmPrincipal,
  fpjson, jsonparser, jsonConf, U_Socio, U_Curso, U_Mensalidade, U_Instituicao, U_Viajem,
  ShellApi, Windows, dateutils, db;

type
  { TControle }
  TControle = (tpConsulta, tpNovo, tpAlterar, tpExcluir);

function getCodigoValido(pTabela, pCampo: string): integer;
procedure deletaCodigo(pTabela, pCampo: string; pCodigo: integer);
procedure MsgErro(Text: string; E: Exception);
procedure MsgOk(Text: string);
procedure MsgAlerta(Text: string);
function MsgConfirmacao(Text: string): boolean;
function validaCpf(num: string): boolean;
function validaCnpj(num: string): boolean;
function getDataServidor: TDateTime;
function removeCharEsp(texto: string): string;
function removeCharBranco(texto: string): string;
function formataCpfCnpj(fDoc: string): string;
procedure rollBackTransaction;
procedure CommitTransaction;
function ShellExecuteAndWait(Operation, FileName, Parameter, Directory: string;
  Show: word; bWait: boolean): longint;
procedure sincronizaAparelho;
function processarJson(pArquivo: string): boolean;
function criarJsonParaEnvio: boolean;
function enviaFotosSocioParaColetor:Boolean;
function recebeFotosSocioDoColetor: Boolean;


implementation

uses U_DtmCadastroSocio, U_FrmProgress;

function getCodigoValido(pTabela, pCampo: string): integer;
begin
  try
    with DtmPrincipal do
    begin
      qryGeral.Close;
      qryGeral.sql.Text :=
        'SELECT CODIGO_VALIDO FROM GET_CONTROLE(:CAMPO, :TABELA)';
      qryGeral.ParamByName('CAMPO').AsString := pCampo;
      qryGeral.ParamByName('TABELA').AsString := pTabela;
      qryGeral.Open;

      Result := qryGeral.FieldByName('CODIGO_VALIDO').AsInteger;

      DtmPrincipal.FBTrans.CommitRetaining;

      qryGeral.Close;
    end;
  except
    on E: Exception do
    begin
      Result := -1;
      DtmPrincipal.FBTrans.RollbackRetaining;
      MsgErro('Ocorreu um erro ao recuperar o código válido para a tabela: ' +
        pTabela, E);
    end;
  end;
end;

procedure deletaCodigo(pTabela, pCampo: string; pCodigo: integer);
begin
  try
    with DtmPrincipal do
    begin
      qryGeral.Close;
      qryGeral.sql.Text :=
        'EXECUTE PROCEDURE DELETA_CONTROLE(:TABELA, :CAMPO, :CODIGO)';
      qryGeral.ParamByName('CAMPO').AsString := pCampo;
      qryGeral.ParamByName('TABELA').AsString := pTabela;
      qryGeral.ParamByName('CODIGO').AsInteger := pCodigo;
      qryGeral.ExecSQL;
      DtmPrincipal.FBTrans.CommitRetaining;
      qryGeral.Close;
    end;
  except
    on E: Exception do
    begin
      DtmPrincipal.FBTrans.RollbackRetaining;
      MsgErro('Ocorreu um erro ao deletar o código válido para a tabela: ' +
        pTabela, E);
    end;
  end;
end;

procedure MsgErro(Text: string; E: Exception);
begin
  Application.MessageBox(PChar(Text + #13 + 'Erro: ' + E.Message),
    'Erro', mb_OK + mb_iconHand);
end;

procedure MsgOk(Text: string);
begin
  Application.MessageBox(PChar(Text), 'Sucesso', mb_OK + MB_ICONINFORMATION);
end;

procedure MsgAlerta(Text: string);
begin
  Application.MessageBox(PChar(Text), 'Atenção', mb_OK + MB_ICONEXCLAMATION);
end;

function MsgConfirmacao(Text: string): boolean;
begin
  Result := (Application.MessageBox(PChar(Text), 'Atenção', MB_YESNO +
    MB_ICONQUESTION) = idYes);
end;

function validaCpf(num: string): boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9: integer;
  d1, d2: integer;
  digitado, calculado: string;
begin
  num := removeCharEsp(num);
  n1 := StrToInt(num[1]);
  n2 := StrToInt(num[2]);
  n3 := StrToInt(num[3]);
  n4 := StrToInt(num[4]);
  n5 := StrToInt(num[5]);
  n6 := StrToInt(num[6]);
  n7 := StrToInt(num[7]);
  n8 := StrToInt(num[8]);
  n9 := StrToInt(num[9]);
  d1 := n9 * 2 + n8 * 3 + n7 * 4 + n6 * 5 + n5 * 6 + n4 * 7 + n3 * 8 + n2 * 9 + n1 * 10;
  d1 := 11 - (d1 mod 11);
  if d1 >= 10 then
    d1 := 0;
  d2 := d1 * 2 + n9 * 3 + n8 * 4 + n7 * 5 + n6 * 6 + n5 * 7 + n4 *
    8 + n3 * 9 + n2 * 10 + n1 * 11;
  d2 := 11 - (d2 mod 11);
  if d2 >= 10 then
    d2 := 0;
  calculado := IntToStr(d1) + IntToStr(d2);
  digitado := num[10] + num[11];
  if calculado = digitado then
    Result := True
  else
    Result := False;
end;

function validaCnpj(num: string): boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12: integer;
  d1, d2: integer;
  digitado, calculado: string;
begin
  n1 := StrToInt(num[1]);
  n2 := StrToInt(num[2]);
  n3 := StrToInt(num[3]);
  n4 := StrToInt(num[4]);
  n5 := StrToInt(num[5]);
  n6 := StrToInt(num[6]);
  n7 := StrToInt(num[7]);
  n8 := StrToInt(num[8]);
  n9 := StrToInt(num[9]);
  n10 := StrToInt(num[10]);
  n11 := StrToInt(num[11]);
  n12 := StrToInt(num[12]);
  d1 := n12 * 2 + n11 * 3 + n10 * 4 + n9 * 5 + n8 * 6 + n7 * 7 + n6 *
    8 + n5 * 9 + n4 * 2 + n3 * 3 + n2 * 4 + n1 * 5;
  d1 := 11 - (d1 mod 11);
  if d1 >= 10 then
    d1 := 0;
  d2 := d2 * 2 + n12 * 3 + n11 * 4 + n10 * 5 + n9 * 6 + n8 * 7 + n7 *
    8 + n6 * 9 + n5 * 2 + n4 * 3 + n3 * 4 + n2 * 5 + n1 * 6;
  d2 := 11 - (d2 mod 11);
  if d2 >= 10 then
    d2 := 0;
  calculado := IntToStr(d1) + IntToStr(d2);
  digitado := num[13] + num[14];
  if calculado = digitado then
    Result := True
  else
    Result := False;
end;

function getDataServidor: TDateTime;
begin
  try
    with DtmPrincipal do
    begin
      qryGeral.Close;
      qryGeral.sql.Text :=
        'SELECT CURRENT_TIMESTAMP FROM RDB$DATABASE';
      qryGeral.Open;
      Result := qryGeral.Fields[1].AsDateTime;
      qryGeral.Close;
    end;
  except
    on E: Exception do
    begin
      Result := Now;
      MsgErro('Ocorreu um erro ao recuperar a data do servidor.', E);
    end;
  end;
end;

function removeCharEsp(texto: string): string;
  {Função que serve para remover caracteres especiais tipo !@#$%^&*()}
const
  charEsp = '~`!@#$%^&*()_-+=|\<>,.?/æ';
var
  x: integer;
  resultado: string;
begin
  resultado := '';
  for x := 1 to Length(texto) do
    if Pos(texto[x], charEsp) = 0 then
      resultado := resultado + texto[x];

  Result := resultado;
end;

function removeCharBranco(texto: string): string;
  {Função que serve para remover caracteres em branco}
var
  x: integer;
  resultado: string;
begin
  resultado := '';
  for x := 1 to Length(texto) do
    if texto[x] <> ' ' then
      resultado := resultado + texto[x];

  Result := resultado;
end;

function formataCpfCnpj(fDoc: string): string;
  {Função para formatar CPF/CNPJ}
var
  vTam, xx: integer;
  vDoc: string;
begin
  vTam := Length(fDoc);
  for xx := 1 to vTam do
    if (Copy(fDoc, xx, 1) <> '.') and (Copy(fDoc, xx, 1) <> '-') and
      (Copy(fDoc, xx, 1) <> '/') then
      vDoc := vDoc + Copy(fDoc, xx, 1);
  fDoc := vDoc;
  vTam := Length(fDoc);
  vDoc := '';
  vDoc := '';
  for xx := 1 to vTam do
  begin
    vDoc := vDoc + Copy(fDoc, xx, 1);
    if vTam = 11 then
    begin
      if (xx in [3, 6]) then
        vDoc := vDoc + '.';
      if xx = 9 then
        vDoc := vDoc + '-';
    end;
    if vTam = 14 then
    begin
      if (xx in [2, 5]) then
        vDoc := vDoc + '.';
      if xx = 8 then
        vDoc := vDoc + '/';
      if xx = 12 then
        vDoc := vDoc + '-';
    end;
  end;
  Result := vDoc;
end;

procedure rollBackTransaction;
begin
  DtmPrincipal.FBTrans.RollbackRetaining;
end;

procedure CommitTransaction;
begin
  DtmPrincipal.FBTrans.CommitRetaining;
end;

procedure sincronizaAparelho;
var
  lsPasta: string;
begin
  lsPasta := ExtractFilePath(Application.ExeName);
  if not FileExists(lsPasta + '\adb.exe') then
  begin
    MsgAlerta('adb.exe não encontrado na pasta do sistema.');
    Exit;
  end;

  if not FileExists(lsPasta + '\AdbWinApi.dll') then
  begin
    MsgAlerta('AdbWinApi.dll não encontrado na pasta do sistema.');
    Exit;
  end;

  if not FileExists(lsPasta + '\AdbWinUsbApi.dll') then
  begin
    MsgAlerta('AdbWinUsbApi.dll não encontrado na pasta do sistema.');
    Exit;
  end;

  if FileExists(lsPasta + '\coletor\retorno.json') then
  begin
    DeleteFile(PAnsiChar(lsPasta + '\coletor\retorno.json'));
  end;

  FrmProgress := TFrmProgress.Create(nil);

  try
    FrmProgress.Caption := 'Sincronização';
    FrmProgress.ProgressBar.Visible := True;
    FrmProgress.ProgressBar.Max := 5;
    FrmProgress.ProgressBar.Min := 0;
    FrmProgress.ProgressBar.Position := 1;
    FrmProgress.pnlMensagem.Caption := 'Recebendo dados...';
    FrmProgress.Show;
    Application.ProcessMessages;

    //inicia service no aparelho
    ShellExecuteAndWait('', '.\adb.exe',
      'shell am start -n "br.com.assec/br.com.oxente.transp.ui.MainActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER', '', SW_HIDE, True);

    //manda o aparelho gerar o arquivo de retorno.json
    ShellExecuteAndWait('', '.\adb.exe',
      'shell am broadcast -a oxenteReceiver --es tipo "0"', '', SW_HIDE, True);

    //espera para a rotina do aparelho gerar o arquivo
    Sleep(5000);

    FrmProgress.ProgressBar.Position := 2;
    FrmProgress.pnlMensagem.Caption := 'Atualizando dados...';
    Application.ProcessMessages;

    //copia o arquivo do aparelho para a pasta
    ShellExecuteAndWait('', '.\adb.exe',
      'pull /sdcard/android/data/br.com.assec/files/envio/retorno.json ' +
      lsPasta + '\coletor', '', SW_HIDE, True);

    Sleep(5000);

    if not FileExists(lsPasta + '\coletor\retorno.json') then
    begin
      MsgAlerta('arquivo de retorno não foi gerado.');
      Exit;
    end;

    if processarJson(lsPasta + '\coletor\retorno.json') then
    begin
      DeleteFile(PAnsiChar(lsPasta + '\coletor\retorno.json'));
      //MsgOk('Arquivo de retorno processado!');
      //Exit;
    end;

    FrmProgress.ProgressBar.Position := 3;
    FrmProgress.pnlMensagem.Caption := 'Recebendo fotos do aparelho...';
    Application.ProcessMessages;

    recebeFotosSocioDoColetor;

    FrmProgress.ProgressBar.Position := 4;
    FrmProgress.pnlMensagem.Caption := 'Atualizando aparelho...';
    Application.ProcessMessages;

    //criação do arquivo para envio de informações para o coletor.
    criarJsonParaEnvio;

    if FileExists(lsPasta + '\coletor\dados.json') then
    begin
      //copia o arquivo da pasta para o aparelho
      ShellExecuteAndWait('', '.\adb.exe', 'push ' + lsPasta +
        '\coletor\dados.json /sdcard/android/data/br.com.assec/files/recebimento',
        '', SW_HIDE, True);

      Sleep(5000);

      //manda o aparelho ler o arquivo
      ShellExecuteAndWait('', '.\adb.exe',
        'shell am broadcast -a oxenteReceiver --es tipo "1"', '', SW_HIDE, True);
    end;


    FrmProgress.ProgressBar.Position := 5;
    FrmProgress.pnlMensagem.Caption := 'Enviando fotos para o aparelho...';
    Application.ProcessMessages;

    enviaFotosSocioParaColetor;

  finally
    FreeAndNil(FrmProgress);
  end;

  MsgOk('Sincronização concluída com sucesso!');
end;

function processarJson(pArquivo: string): boolean;
var
  S: TFileStream;
  P: TJSONParser;
  D: TJSONData;
  O, Obj: TJSONObject;
  A: TJSONArray;
  liCont, liContAux: integer;
  socio: TSocio;
  viajem: TViajem;
begin
  Result := False;

  if not FileExists(pArquivo) then
  begin
    MsgAlerta('Arquivo JSON não existe!');
    Exit;
  end;


  S := TFileStream.Create(pArquivo, fmOpenRead);
  try
    P := TJSONParser.Create(S);

    try
      D := P.Parse;
    finally
      P.Free;
    end;


    try
      O := TJSONObject(D);

      if o.Count > 0 then
      begin
        DtmCadastroSocio := TDtmCadastroSocio.Create(nil);
      end
      else
      begin
        Exit;
      end;

      a := o.Arrays['socios'];

      for liCont := 0 to a.Count - 1 do
      begin

        try
          try
            Obj := TJSONObject(a.Items[liCont]);
            socio := TSocio.Create;

            socio.documento := Obj.Get('cpf');
            socio.ano := Obj.Get('ano');
            socio.mes := Obj.Get('mes');

            socio.curso := TCurso.Create;
            socio.curso.codigo := Obj.Get('codCurso');

            socio.mensalidade := TMensalidade.Create;
            socio.mensalidade.codigo := Obj.Get('codMensalidade');

            socio.instituicao := TInstituicao.Create;
            socio.instituicao.codigo := Obj.Get('codInstituicao');

            socio.dataCadastramento :=
              StrToDateTime(StringReplace(Obj.Get('dataCadastramento'),
              '-', '/', [rfReplaceAll]));

            socio.Validade :=
              StrToDateTime(StringReplace(Obj.Get('dataValidade'),
              '-', '/', [rfReplaceAll]));

            socio.email := Obj.Get('email');
            socio.endereco := Obj.Get('endereco');
            socio.fone := Obj.Get('fone');
            socio.fone2 := Obj.Get('fone2');
            socio.nome := Obj.Get('nome');
            socio.nome := Obj.Get('nome');
            socio.ativo:= Obj.Get('ativo');

            DtmCadastroSocio.salvarSocio(socio, tpConsulta);

          except
            on E: Exception do
            begin
              MsgErro('Erro ao salvar socio ' + Obj.Get('cpf'), E);
            end;
          end;


        finally
          Obj.Free;
        end;

      end;



      a := o.Arrays['viagens'];

      for liCont := 0 to a.Count - 1 do
      begin

        try
          try
            Obj := TJSONObject(a.Items[liCont]);
            viajem := TViajem.Create;

            viajem.cpf := Obj.Get('cpf');
            viajem.Data := StrToDateTime(StringReplace(Obj.Get('data'),
              '-', '/', [rfReplaceAll]));
            viajem.obs := Obj.Get('obs');
            viajem.tipo := Obj.Get('tipo');

            DtmCadastroSocio.salvarViajem(viajem);

          except
            on E: Exception do
            begin
              MsgErro('Erro ao salvar viajem ' + Obj.Get('cpf'), E);
            end;
          end;

        finally
          Obj.Free;
        end;

      end;


    finally
      if Assigned(DtmCadastroSocio) then
        FreeAndNil(DtmCadastroSocio);
    end;

    Result := True;
  finally
    S.Free;
  end;
end;

function criarJsonParaEnvio: boolean;
var
  JPrincipal, JAux: TJSONObject;
  JArrCurso, JArrInst, JArrMens, JArrSocio, JArrFat, JArrViajem: TJSONArray;
  JData: TJSONData;
  lsPasta: string;
  F: TextFile;
begin

  try

    JPrincipal := TJSONObject.Create;
    JAux := TJSonObject.Create;
    JArrCurso := TJSONArray.Create;
    JArrInst := TJSONArray.Create;
    JArrMens := TJSONArray.Create;
    JArrSocio := TJSONArray.Create;
    JArrFat := TJSONArray.Create;
    JArrViajem := TJSONArray.Create;

    try

      //criando array de curso
      with DtmPrincipal do
      begin
        qryGeral.Close;
        qryGeral.SQL.Text := 'SELECT COD_CURSO, DES_CURSO FROM CURSO';
        qryGeral.Open;

        while not qryGeral.EOF do
        begin

          JAux.Add('codCurso', qryGeral.FieldByName('COD_CURSO').AsInteger);
          JAux.Add('desCurso', qryGeral.FieldByName('DES_CURSO').AsString);

          JData := GetJSON(jaux.AsJSON);

          JAux.Clear;

          JArrCurso.Add(JData);
          qryGeral.Next;
        end;

        JPrincipal.Add('cursos', JArrCurso);
      end;


      //criando array de instituicao
      with DtmPrincipal do
      begin
        qryGeral.Close;
        qryGeral.SQL.Text := 'SELECT COD_INSTITUICAO, DES_INSTITUICAO FROM INSTITUICAO';
        qryGeral.Open;

        JAux.Clear;

        while not qryGeral.EOF do
        begin

          JAux.Add('codInstituicao', qryGeral.FieldByName('COD_INSTITUICAO').AsInteger);
          JAux.Add('desInstituicao', qryGeral.FieldByName('DES_INSTITUICAO').AsString);

          JData := GetJSON(jaux.AsJSON);

          JAux.Clear;

          JArrInst.Add(JData);

          qryGeral.Next;
        end;

        JPrincipal.Add('instituicoes', JArrInst);
      end;


      //criando array de mensalidade
      with DtmPrincipal do
      begin
        qryGeral.Close;
        qryGeral.SQL.Text := 'SELECT COD_MENSALIDADE, '#13 +
          '       DES_MENSALIDADE, '#13 + '       DOM_IDA,         '#13 +
          '       DOM_VOLTA,       '#13 + '       SEG_IDA,         '#13 +
          '       SEG_VOLTA,       '#13 + '       TER_IDA,         '#13 +
          '       TER_VOLTA,       '#13 + '       QUA_IDA,         '#13 +
          '       QUA_VOLTA,       '#13 + '       QUI_IDA,         '#13 +
          '       QUI_VOLTA,       '#13 + '       SEX_IDA,         '#13 +
          '       SEX_VOLTA,       '#13 + '       SAB_IDA,         '#13 +
          '       SAB_VOLTA        '#13 + 'FROM MENSALIDADE        ';
        qryGeral.Open;

        JAux.Clear;

        while not qryGeral.EOF do
        begin

          JAux.Add('codMensalidade', qryGeral.FieldByName('COD_MENSALIDADE').AsInteger);
          JAux.Add('desMensalidade', qryGeral.FieldByName('DES_MENSALIDADE').AsString);

          JAux.Add('domIda', (Trim(qryGeral.FieldByName('DOM_IDA').AsString)='S'));
          JAux.Add('domVolta', (Trim(qryGeral.FieldByName('DOM_VOLTA').AsString)='S'));

          JAux.Add('segIda', (Trim(qryGeral.FieldByName('SEG_IDA').AsString)='S'));
          JAux.Add('segVolta', (Trim(qryGeral.FieldByName('SEG_VOLTA').AsString)='S'));

          JAux.Add('terIda', (Trim(qryGeral.FieldByName('TER_IDA').AsString)='S'));
          JAux.Add('terVolta', (Trim(qryGeral.FieldByName('TER_VOLTA').AsString)='S'));

          JAux.Add('quaIda', (Trim(qryGeral.FieldByName('QUA_IDA').AsString)='S'));
          JAux.Add('quaVolta', (Trim(qryGeral.FieldByName('QUA_VOLTA').AsString)='S'));

          JAux.Add('quiIda', (Trim(qryGeral.FieldByName('QUI_IDA').AsString)='S'));
          JAux.Add('quiVolta', (Trim(qryGeral.FieldByName('QUI_VOLTA').AsString)='S'));

          JAux.Add('sexIda', (Trim(qryGeral.FieldByName('SEX_IDA').AsString)='S'));
          JAux.Add('sexVolta', (Trim(qryGeral.FieldByName('SEX_VOLTA').AsString)='S'));

          JAux.Add('sabIda', (Trim(qryGeral.FieldByName('SAB_IDA').AsString)='S'));
          JAux.Add('sabVolta', (Trim(qryGeral.FieldByName('SAB_VOLTA').AsString)='S'));

          JData := GetJSON(jaux.AsJSON);

          JAux.Clear;

          JArrMens.Add(JData);

          qryGeral.Next;
        end;

        JPrincipal.Add('mensalidades', JArrMens);
      end;

      //criando array de socio
      with DtmPrincipal do
      begin
        qryGeral.Close;
        qryGeral.SQL.Text :=  'SELECT CPF,                '#13 +
                              '       COD_MENSALIDADE,    '#13 +
                              '       COD_INSTITUICAO,    '#13 +
                              '       COD_CURSO,          '#13 +
                              '       NOME,               '#13 +
                              '       FOTO,               '#13 +
                              '       ENDERECO,           '#13 +
                              '       FONE,               '#13 +
                              '       FONE2,              '#13 +
                              '       EMAIL,              '#13 +
                              '       DATA_CADASTRAMENTO, '#13 +
                              '       ATIVO,              '#13 +
                              '       MES,                '#13 +
                              '       ANO,                '#13 +
                              '       DATA_VALIDADE       '#13 +
                              'FROM SOCIO                 ';
        qryGeral.Open;

        JAux.Clear;

        while not qryGeral.EOF do
        begin

          JAux.Add('cpf', qryGeral.FieldByName('CPF').AsString);
          JAux.Add('nome', qryGeral.FieldByName('NOME').AsString);
          JAux.Add('foto', qryGeral.FieldByName('CPF').AsString);
          JAux.Add('endereco', qryGeral.FieldByName('ENDERECO').AsString);
          JAux.Add('fone', qryGeral.FieldByName('FONE').AsString);
          JAux.Add('fone2', qryGeral.FieldByName('FONE2').AsString);
          JAux.Add('email', qryGeral.FieldByName('EMAIL').AsString);

          JAux.Add('dataCadastramento',
            StringReplace(qryGeral.FieldByName('DATA_CADASTRAMENTO').AsString,
            '/', '-', [rfReplaceAll]));

          if qryGeral.FieldByName('DATA_VALIDADE').AsDateTime <> 0 then
            JAux.Add('dataValidade',
              StringReplace(qryGeral.FieldByName('DATA_VALIDADE').AsString,
              '/', '-', [rfReplaceAll]) + ' 00:00:00');

          JAux.Add('ativo', (Trim(qryGeral.FieldByName('ATIVO').AsString) = 'S'));
          JAux.Add('codCurso', qryGeral.FieldByName('COD_CURSO').AsInteger);
          JAux.Add('codMensalidade', qryGeral.FieldByName('COD_MENSALIDADE').AsInteger);
          JAux.Add('codInstituicao', qryGeral.FieldByName('COD_INSTITUICAO').AsInteger);
          JAux.Add('tipo', 0);

          JData := GetJSON(jaux.AsJSON);

          JAux.Clear;

          JArrSocio.Add(JData);

          qryGeral.Next;
        end;

        JPrincipal.Add('socios', JArrSocio);
      end;

      //criando array de faturas
      with DtmPrincipal do
      begin
        qryGeral.Close;
        qryGeral.SQL.Text := 'SELECT COD_FATURA,     '#13 +
          '       CPF,            '#13 + '       COD_COBRANCA,   '#13 +
          '       DATA_GERACAO,   '#13 + '       DATA_PAGAMENTO, '#13 +
          '       VALOR,          '#13 + '       MES,            '#13 +
          '       ANO,            '#13 + '       VENCIMENTO      '#13 +
          'FROM FATURA            ';
        qryGeral.Open;

        JAux.Clear;

        while not qryGeral.EOF do
        begin

          JAux.Add('fatura', qryGeral.FieldByName('COD_FATURA').AsInteger);
          JAux.Add('cpf', qryGeral.FieldByName('CPF').AsString);
          JAux.Add('geracao', StringReplace(qryGeral.FieldByName(
            'DATA_GERACAO').AsString, '/', '-', [rfReplaceAll]) + ' 00:00:00');

          if qryGeral.FieldByName('DATA_PAGAMENTO').AsDateTime <> 0 then
            JAux.Add('pagamento',
              StringReplace(qryGeral.FieldByName('DATA_PAGAMENTO').AsString,
              '/', '-', [rfReplaceAll]) + ' 00:00:00');
          JAux.Add('valor', qryGeral.FieldByName('VALOR').AsFloat);
          JAux.Add('mes', qryGeral.FieldByName('MES').AsInteger);
          JAux.Add('ano', qryGeral.FieldByName('ANO').AsInteger);

          JAux.Add('vencimento',
            StringReplace(qryGeral.FieldByName('VENCIMENTO').AsString,
            '/', '-', [rfReplaceAll]) + ' 00:00:00');

          JData := GetJSON(jaux.AsJSON);

          JAux.Clear;

          JArrFat.Add(JData);

          qryGeral.Next;
        end;

        JPrincipal.Add('faturas', JArrFat);
      end;

      //criando array de viajens
      with DtmPrincipal do
      begin
        qryGeral.Close;
        qryGeral.SQL.Text := 'SELECT CPF,     '#13 + '       DATA,    '#13 +
          '       TIPO,    '#13 + '       OBS      '#13 + 'FROM HST_VIAJEM ';
        qryGeral.Open;

        JAux.Clear;

        while not qryGeral.EOF do
        begin

          JAux.Add('cpf', qryGeral.FieldByName('CPF').AsString);
          JAux.Add('data', StringReplace(qryGeral.FieldByName(
            'DATA').AsString, '/', '-', [rfReplaceAll]));
          JAux.Add('tipo', qryGeral.FieldByName('TIPO').AsInteger);
          JAux.Add('obs', qryGeral.FieldByName('OBS').AsInteger);
          JAux.Add('dia', DayOf(qryGeral.FieldByName('DATA').AsDateTime));
          JAux.Add('mes', MonthOf(qryGeral.FieldByName('DATA').AsDateTime));
          JAux.Add('ano', YearOf(qryGeral.FieldByName('DATA').AsDateTime));
          JAux.Add('hora', HourOf(qryGeral.FieldByName('DATA').AsDateTime));
          JAux.Add('flg', 0);

          JData := GetJSON(jaux.AsJSON);

          JAux.Clear;

          JArrViajem.Add(JData);

          qryGeral.Next;
        end;

        JPrincipal.Add('viagens', JArrViajem);
      end;

      lsPasta := ExtractFilePath(Application.ExeName);

      if FileExists(lsPasta + '\coletor\dados.json') then
        DeleteFile(PAnsiChar(lsPasta + '\coletor\dados.json'));

      AssignFile(f, lsPasta + '\coletor\dados.json');
      Rewrite(f);
      Writeln(f, JPrincipal.AsJSON);
      Closefile(f);

    finally
      JArrMens.Free;
      JArrInst.Free;
      JArrCurso.Free;
      JArrSocio.Free;
      JArrFat.Free;
      JArrViajem.Free;
    end;


  except
    on E: Exception do
    begin
      MsgErro('Ocorreu um erro ao gerar JSON de envio.', E);
    end;
  end;

end;

function recebeFotosSocioDoColetor: Boolean;
var
  lsPasta:String;
  i: integer;
  sr: TSearchRec;
  foto:TMemoryStream;
begin
  try

    lsPasta := ExtractFilePath(Application.ExeName);

    if not DirectoryExists(lsPasta+'\Coletor\Foto') then
      CreateDir(lsPasta+'\Coletor\Foto');

    //copia as fotos novas do aparelho para o pc
    ShellExecuteAndWait('',
    '.\adb.exe', 'pull /sdcard/android/data/br.com.assec/files/fotos_nova ' + lsPasta + '\coletor\Foto',
      '', SW_HIDE, True);

    Sleep(5000);

    with DtmPrincipal do
    begin

      I := FindFirst(lsPasta+'\Coletor\Foto\*.*', faAnyFile, SR);
      while I = 0 do
      begin
        if (SR.Attr <> faDirectory) then
        begin

          foto := TMemoryStream.Create;

          try
            foto.LoadFromFile(lsPasta+'\Coletor\Foto\' + SR.Name);

            qryGeral.Close;
            qryGeral.SQL.Text:= 'UPDATE SOCIO SET FOTO = :FOTO WHERE CPF = :CPF';
            qryGeral.ParamByName('CPF').AsString:= COPY(SR.Name,1,POS('.',SR.Name)-1);
            foto.Seek(0, 0);
            qryGeral.ParamByName('FOTO').LoadFromStream(foto, ftGraphic);
            qryGeral.ExecSQL;

          finally
            foto.Free;
          end;

        end;

        I := FindNext(SR);
      end;

      //apaga as fotos novas do aparelho...
      ShellExecuteAndWait('', '.\adb.exe',
        'shell am broadcast -a oxenteReceiver --es tipo "2"', '', SW_HIDE, True);

      //apaga as fotos da pasta...
      I := FindFirst(lsPasta+'\Coletor\Foto\*.*', faAnyFile, SR);
      while I = 0 do
      begin
        DeleteFile(PChar(lsPasta+'\Coletor\Foto\' + SR.Name));
        I := FindNext(SR);
      end;

      FBTrans.CommitRetaining;
    end;

  except
    on E:Exception do
    begin
      Result := False;
      MsgErro('Ocorreu um erro ao receber fotos do aparelho',E);
    end;
  end;
end;

function enviaFotosSocioParaColetor: Boolean;
var
  lsPasta:String;
  i: integer;
  sr: TSearchRec;
begin
  try

    lsPasta := ExtractFilePath(Application.ExeName);

    if not DirectoryExists(lsPasta+'\Coletor\Foto') then
      CreateDir(lsPasta+'\Coletor\Foto');

    with DtmPrincipal do
    begin
      qryGeral.Close;
      qryGeral.SQL.Text:= 'SELECT CPF, FOTO FROM SOCIO';
      qryGeral.Open;

      while not qryGeral.EOF do
      begin
        if not qryGeral.FieldByName('foto').IsNull then
          TBlobField(qryGeral.FieldByName('foto')).SaveToFile(lsPasta+'\Coletor\Foto\'+qryGeral.FieldByName('CPF').AsString+'.jpg');

        qryGeral.Next;
      end;

      //copia o pasta de fotos para o aparelho
      ShellExecuteAndWait('', '.\adb.exe', 'push ' + lsPasta +
        '\coletor\Foto /sdcard/android/data/br.com.assec/files/fotos',
        '', SW_HIDE, True);

      Sleep(5000);

      I := FindFirst(lsPasta+'\Coletor\Foto\*.*', faAnyFile, SR);
      while I = 0 do
      begin
        DeleteFile(PChar(lsPasta+'\Coletor\Foto\' + SR.Name));
        I := FindNext(SR);
      end;

    end;

  except
    on E:Exception do
    begin
      Result := False;
      MsgErro('Ocorreu um erro ao enviar as fotos para o aparelho',E);
    end;
  end;
end;

function ShellExecuteAndWait(Operation, FileName, Parameter, Directory: string;
  Show: word; bWait: boolean): longint;
var
  bOK: boolean;
  Info: TSHELLEXECUTEINFOA;
begin
  if not FileExists(FileName) then
  begin
    Result := -1;
    Exit;
  end;

  FillChar(Info, SizeOf(Info), Chr(0));
  Info.cbSize := SizeOf(Info);
  Info.fMask := SEE_MASK_NOCLOSEPROCESS;
  Info.lpVerb := PChar(Operation);
  Info.lpFile := PChar(FileName);
  Info.lpParameters := PChar(Parameter);
  Info.lpDirectory := PChar(Directory);
  Info.nShow := Show;
  bOK := boolean(ShellExecuteExA(@Info));
  if bOK then
  begin
    if bWait then
    begin
      while WaitForSingleObject(Info.hProcess, 100) = WAIT_TIMEOUT do
        Application.ProcessMessages;
      bOK := GetExitCodeProcess(Info.hProcess, DWORD(Result));
    end
    else
      Result := 0;
  end;
  if not bOK then
    Result := -1;
end;

end.
