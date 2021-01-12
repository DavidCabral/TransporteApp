unit U_DtmPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, FileUtil, IniFiles, Forms;

type

  { TDtmPrincipal }

  TDtmPrincipal = class(TDataModule)
    FBCon: TIBConnection;
    FBTrans: TSQLTransaction;
    qryGeral: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

  public

  end;

var
  DtmPrincipal: TDtmPrincipal;

implementation

{$R *.lfm}

{ TDtmPrincipal }

procedure TDtmPrincipal.DataModuleCreate(Sender: TObject);
var
  I: TIniFile;
begin
  try
    I := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

    FBCon.HostName := I.ReadString('BANCO', 'SERVIDOR', '');
    FBCon.DatabaseName := I.ReadString('BANCO', 'CAMINHO', '');

    try
      FBCon.Connected := True;
      FBTrans.Active := True;
    except
      application.MessageBox(
        'Não foi possível conectar ao banco de dados, contate o suporte!',
        'Atenção');
      application.Terminate;
    end;

  finally
    i.Free;
  end;


  //atualizando campo de foto se precisar
  qryGeral.Close;
  qryGeral.SQL.Text:=' SELECT R.RDB$FIELD_NAME                                          '#13+
                     ' FROM RDB$RELATION_FIELDS R                                       '#13+
                     ' INNER JOIN RDB$FIELDS F ON R.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME '#13+
                     ' WHERE R.RDB$RELATION_NAME = ''SOCIO'' AND                        '#13+
                     '       R.RDB$FIELD_NAME = ''FOTO'' AND                            '#13+
                     '       F.RDB$FIELD_TYPE = 37';
  qryGeral.Open;

  if not qryGeral.IsEmpty then
  begin
    qryGeral.Close;
    qryGeral.SQL.Text:='ALTER TABLE SOCIO DROP FOTO';
    qryGeral.ExecSQL;
    FBTrans.CommitRetaining;

    qryGeral.Close;
    qryGeral.SQL.Text:='ALTER TABLE SOCIO ADD FOTO BLOB SUB_TYPE 0 SEGMENT SIZE 14000';
    qryGeral.ExecSQL;
    FBTrans.CommitRetaining;
  end;

  //atualizando tabela de socio, adicionando o campo data_validade se nao existir
  qryGeral.Close;
  qryGeral.SQL.Text:=' SELECT R.RDB$FIELD_NAME                    '#13+
                     ' FROM RDB$RELATION_FIELDS R                 '#13+
                     ' WHERE R.RDB$RELATION_NAME = ''SOCIO'' AND  '#13+
                     '       R.RDB$FIELD_NAME = ''DATA_VALIDADE'' ';
  qryGeral.Open;

  if qryGeral.IsEmpty then
  begin
    qryGeral.Close;
    qryGeral.SQL.Text:='ALTER TABLE SOCIO ADD DATA_VALIDADE DATE';
    qryGeral.ExecSQL;
    FBTrans.CommitRetaining;
  end;

  //INSERINDO SE NAO TIVER INSTITUIÇÃO - 0
  qryGeral.Close;
  qryGeral.SQL.Text:= ' SELECT COD_INSTITUICAO FROM INSTITUICAO WHERE COD_INSTITUICAO = 0 ';
  qryGeral.Open;
  if qryGeral.IsEmpty then
  begin
    qryGeral.Close;
    qryGeral.SQL.Text:=' INSERT INTO INSTITUICAO (COD_INSTITUICAO, DES_INSTITUICAO)  '#13+
                       ' VALUES (0, ''NÃO INFORMADO'')                               ';
    qryGeral.ExecSQL;
    FBTrans.CommitRetaining;
  end;

end;

procedure TDtmPrincipal.DataModuleDestroy(Sender: TObject);
begin
  FBTrans.Active := False;
  FBCon.Connected := False;
end;

end.
