unit U_Socio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, U_Curso, U_Instituicao, U_Mensalidade, Graphics;

type
  TSocio = class
    mensalidade: TMensalidade;
    instituicao: TInstituicao;
    curso: TCurso;
    nome: string;
    documento: string;
    foto: TMemoryStream;
    endereco: string;
    fone: string;
    fone2: string;
    email: string;
    dataCadastramento: TDateTime;
    ativo: boolean;
    mes: integer;
    ano: integer;
    Validade: TDate;
  end;


implementation

end.

