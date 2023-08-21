program ComercialBasico;



uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}

  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, pack_powerpdf, datetimectrls, memdslaz, zcomponent, UMenu,
  udatamodule1, ucadastrocliente, uedicaocliente, ucadastroproduto,
  uEdicaoProduto, uPDV, uedicaoitemvenda, uConsultaVendas, uContasAReceber,
  udadoscliente, ucadastrofornecedores, uedicaofornecedores, udadosfornecedores,
  uRelatorioContasAReceber_Mac;



begin
  RequireDerivedFormResource:=True;
    Application.Title:='Comercial Básico';
    Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFMenu, FMenu);

  Application.Run;
end.

