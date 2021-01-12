unit U_Fatura;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TFatura = class
    codigo: integer;
    cpf: string;
    codCobranca: integer;
    dataGeracao: TDateTime;
    dataPagamento: TDateTime;
    valor: currency;
    mes: integer;
    ano: integer;
    vencimento: TDateTime;
  end;

implementation

end.

