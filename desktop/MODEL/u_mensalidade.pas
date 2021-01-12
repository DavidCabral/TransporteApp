unit U_Mensalidade;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TMensalidade = class
    codigo: integer;
    descicao: string;

    seg_ida:Boolean;
    seg_volta:Boolean;

    ter_ida:Boolean;
    ter_volta:Boolean;

    qua_ida:Boolean;
    qua_volta:Boolean;

    qui_ida:Boolean;
    qui_volta:Boolean;

    sex_ida:Boolean;
    sex_volta:Boolean;

    sab_ida:Boolean;
    sab_volta:Boolean;

    dom_ida:Boolean;
    dom_volta:Boolean;
  end;

implementation

end.

