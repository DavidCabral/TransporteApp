unit U_FrmRelCarteitinhaSocio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ubarcodes, RLReport, RLBarcode, RLPDFFilter,
  Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TFrmRelCarteitinhaSocio }

  TFrmRelCarteitinhaSocio = class(TForm)
    rlblCurso1: TRLLabel;
    rlblInstituicao1: TRLLabel;
    rlblNome: TRLLabel;
    rlblCurso: TRLLabel;
    rlblInstituicao: TRLLabel;
    rlblNome1: TRLLabel;
    rlblNome2: TRLLabel;
    rlblDataValidade: TRLLabel;
    rlImgLogo: TRLImage;
    rlImgFoto: TRLImage;
    RLImage3: TRLImage;
    rlimgqrcode: TRLImage;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLPanel1: TRLPanel;
    RLPDFFilter1: TRLPDFFilter;
    RLReport1: TRLReport;
    procedure RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private

  public

  end;

var
  FrmRelCarteitinhaSocio: TFrmRelCarteitinhaSocio;

implementation

{$R *.lfm}

{ TFrmRelCarteitinhaSocio }




procedure TFrmRelCarteitinhaSocio.RLReport1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  I: TIniFile;
begin
  try
    I := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');

    if FileExists(I.ReadString('BANCO', 'LOGO_CARTEIRA', '')) then
    begin
      rlImgLogo.Picture.LoadFromFile(I.ReadString('BANCO', 'LOGO_CARTEIRA', ''));
    end;

  finally
    i.Free;
  end;
end;

end.

