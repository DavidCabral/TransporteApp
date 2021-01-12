unit U_FrmProgress;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls;

type

  { TFrmProgress }

  TFrmProgress = class(TForm)
    pnlMensagem: TPanel;
    ProgressBar: TProgressBar;
  private

  public

  end;

var
  FrmProgress: TFrmProgress;

implementation

{$R *.lfm}

end.

