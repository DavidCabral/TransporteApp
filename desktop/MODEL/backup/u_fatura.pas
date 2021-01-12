unit U_Fatura;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TFatura = Class
    codigo :integer;
    cpf :String;
    codCobranca :Integer;
    dataGeracao:TDateTime;
    dataPagamento:TDateTime;
    valor :Currency;
    mes :Integer;
    ano :Integer;
    vencimento :TDateTime;
  end;

implementation

end.

