unit U_FrmPesquisaBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, DBGrids, ComCtrls, StdCtrls, U_Utils, DB, sqldb;

type

  { TFrmPesquisaBase }

  TFrmPesquisaBase = class(TForm)
    btnEditar: TSpeedButton;
    btnListar: TSpeedButton;
    btnSair: TSpeedButton;
    btnExcluir: TSpeedButton;
    DSGrid: TDataSource;
    DBGrid1: TDBGrid;
    edtPesquisa: TEdit;
    lblPesquisa: TLabel;
    Panel1: TPanel;
    statusBar: TStatusBar;
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure edtPesquisaChange(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private

  protected
    goColumn: TColumn;
    procedure AtualizaTotal;

  public
    gControle: TControle;
  end;

var
  FrmPesquisaBase: TFrmPesquisaBase;

implementation

{$R *.lfm}

{ TFrmPesquisaBase }

procedure TFrmPesquisaBase.btnEditarClick(Sender: TObject);
begin
  gControle := tpAlterar;
end;

procedure TFrmPesquisaBase.btnExcluirClick(Sender: TObject);
begin
  gControle := tpExcluir;
end;

procedure TFrmPesquisaBase.btnSairClick(Sender: TObject);
begin
  gControle := tpConsulta;
  Self.Close;
end;

procedure TFrmPesquisaBase.DBGrid1TitleClick(Column: TColumn);
begin
     if DSGrid.DataSet.IsEmpty then
        Exit;

      goColumn.Title.Font.Color:=clBlack;

      if DSGrid.DataSet.ClassType = TSQLQuery then
      begin
        if (Column.Field.ClassType = TStringField) then
        begin
          lblPesquisa.Caption:=Column.Title.Caption+':';
          edtPesquisa.Enabled:=True;
          edtPesquisa.NumbersOnly:=False;
        end
        else if (Column.Field.ClassType = TLongintField) then
        begin
          lblPesquisa.Caption:=Column.Title.Caption+':';
          edtPesquisa.Enabled:=True;
          edtPesquisa.NumbersOnly:=True;
        end
        else
        begin
           lblPesquisa.Caption:=Column.Field.ClassName;
           //lblPesquisa.Caption:='Pesquisa:';
           edtPesquisa.Enabled:=False;
        end;

        TSQLQuery(DSGrid.DataSet).IndexFieldNames:=Column.FieldName;
        Column.Title.Font.Color:=clRed;
        goColumn := Column;
      end;
end;

procedure TFrmPesquisaBase.edtPesquisaChange(Sender: TObject);
begin
  if DSGrid.DataSet.IsEmpty then
     Exit;

  if Trim(edtPesquisa.Text) = '' then
  begin
     DSGrid.DataSet.First;
  end
  else
  begin
     DSGrid.DataSet.Locate(goColumn.FieldName,Trim(edtPesquisa.Text),[loPartialKey, loCaseInsensitive]);
  end;
end;

procedure TFrmPesquisaBase.FormShow(Sender: TObject);
begin
  goColumn := DBGrid1.Columns.Items[0];
end;

procedure TFrmPesquisaBase.AtualizaTotal;
begin
  statusBar.Panels.Items[0].Text :=
    'Registros: ' + FormatFloat('00', DSGrid.DataSet.RecordCount);
end;

end.
