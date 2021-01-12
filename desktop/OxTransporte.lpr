program OxTransporte;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, memdslaz, sysutils, U_FrmPrincipal, U_FrmCadastroBase,
  U_DtmPrincipal, U_FrmCadastroCurso, U_FrmPesquisaBase, U_DtmCadastroCurso,
  U_dtmcadastroInstituicao, U_dtmcadastroMensalidade, U_Utils,
  U_FrmPesquisaCadastroCurso, U_Curso, U_Instituicao, U_FrmCadastroInstituicao,
  U_FrmPesquisaInstituicao, U_frmpesquisacadastroInstituicao,
  U_frmpesquisacadastroMensalidade, U_frmcadastroMensalidade, U_Mensalidade,
  U_FrmRelatorioBase, U_FrmListagemCurso, U_Socio, U_FrmCadastroSocio,
  U_DtmCadastroSocio, U_DtmFatura, U_FrmRelCarteitinhaSocio,
  U_frmpesquisacadastroSocio, U_Fatura, U_FrmDlgIncluirAlterarFatura,
  U_FrmListagemSocio, U_frmrelcarteirinhasocioTodas, U_Viajem, U_FrmProgress,
  U_FrmRelSociosInadimplentes, U_FrmFiltroRelatorioBase,
  U_FrmFiltroRelSocioInadimplente, u_frmFiltroRelatorioCarteirinhas;

{$R *.res}
begin
  Application.Title:='Assec';
  RequireDerivedFormResource:=True;
  Application.Initialize;

  if not FileExists(ExtractFilePath(application.ExeName)+'config.ini') then
  begin
     application.MessageBox('Arquivo de configuração não encontrado, contate o suporte!','Atenção');
     application.Terminate;
  end;

  Application.CreateForm(TDtmPrincipal, DtmPrincipal);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.

