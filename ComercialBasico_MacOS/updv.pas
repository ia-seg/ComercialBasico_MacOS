unit uPDV;


interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Buttons, DBGrids, StdCtrls, DBCtrls, ZDataset, ZSqlUpdate, Types,
  Math;

type

  { TFPDV }

  TFPDV = class(TForm)

    btnAprazo: TSpeedButton;
    btnAvista: TSpeedButton;
    btnCancelarParcela: TSpeedButton;
    btnExcluirItem: TSpeedButton;
    btnCancelar: TSpeedButton;
    btnNovaVenda: TSpeedButton;
    btnGerarParcelas: TSpeedButton;
    btnInserirItem: TSpeedButton;
    btnEditarItem: TSpeedButton;
    CBFormaPagamento: TComboBox;
    CBFormaPagamentoVista: TComboBox;
    chavevenda: TLongintField;
    DSEspelhoTItemVenda: TDataSource;
    DBComboBox1: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    DBText1: TDBText;
    edtRecebido: TEdit;
    edtTaxaJuros: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lblTaxaJuros: TLabel;
    lblTroco: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LabelPagar: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    btnConcluir: TSpeedButton;
    QSomaItensSUM: TFloatField;
    QUltimaChaveContaAReceberADD: TLargeintField;
    QUltimaChaveItemVendaADD: TLargeintField;
    RadioGroupJuros: TRadioGroup;
    QSomaItens: TSQLQuery;
    QUltimaChaveItemVenda: TSQLQuery;
    QUltimaChaveContaAReceber: TSQLQuery;
    QSomaItensWin: TSQLQuery;
    QSomaItensWinSUM: TFloatField;


    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    EspelhoTItemVenda: TSQLQuery;
    EspelhoTItemVendaCHAVE: TLongintField;
    EspelhoTItemVendaCHAVE_PRODUTO: TLongintField;
    EspelhoTItemVendaCHAVE_VENDA: TLongintField;
    EspelhoTItemVendaPRECO_UNITARIO: TFloatField;
    EspelhoTItemVendaQUANTIDADE: TFloatField;
    EspelhoTItemVendaVALOR_TOTAL: TFloatField;
    procedure btnAprazoClick(Sender: TObject);
    procedure btnAvistaClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnCancelarParcelaClick(Sender: TObject);
    procedure btnConcluirClick(Sender: TObject);
    procedure btnEditarItemClick(Sender: TObject);
    procedure btnExcluirItemClick(Sender: TObject);
    procedure btnGerarParcelasClick(Sender: TObject);
    procedure btnInserirItemClick(Sender: TObject);
    procedure btnNovaVendaClick(Sender: TObject);
    procedure CBFormaPagamentoVistaCloseUp(Sender: TObject);
    procedure DBComboBox1Change(Sender: TObject);
    procedure DBEdit5Click(Sender: TObject);
    procedure DBEdit6KeyPress(Sender: TObject; var Key: char);
    procedure DBEdit7KeyPress(Sender: TObject; var Key: char);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edtRecebidoExit(Sender: TObject);
    procedure edtRecebidoKeyPress(Sender: TObject; var Key: char);
    procedure edtRecebidoKeyUp(Sender: TObject; var Key: Word;
        Shift: TShiftState);
    procedure edtTaxaJurosChange(Sender: TObject);
    procedure edtTaxaJurosKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RadioGroupJurosClick(Sender: TObject);
  private

  public
     cancelou, cancelouParcelamento, vendeu: Boolean;
     totalParcial:Float;
  end;

var
  FPDV: TFPDV;
  inserindo_novo_item, concluiu, prazo: Boolean;
  totalVenda: Float;


implementation

  uses udatamodule1, UMenu, uedicaoitemvenda;

{$R *.lfm}

  { TFPDV }

  procedure TFPDV.btnInserirItemClick(Sender: TObject);
  begin


    cancelouParcelamento:= False;

    inserindo_novo_item := True;

    QUltimaChaveItemVenda.Close;

    QUltimaChaveItemVenda.Open;


    DataModule1.TItemVenda.Close;
    DataModule1.TItemVenda.Open;
    DataModule1.TItemVenda.Insert;

    DataModule1.TItemVendaCHAVE.Value:= QUltimaChaveItemVendaADD.Value;

    DataModule1.TItemVendaCHAVE_VENDA.Value:= DataModule1.TVendaCHAVE.Value;


    vendeu:= False;

    FEdicaoItemVenda := TFEdicaoItemVenda.Create(Self);
    FEdicaoItemVenda.ShowModal;

    QSomaItens.Close;
    QSomaItens.ParamByName('chavevenda').Value:= DataModule1.TVendaCHAVE.Value;
    QSomaItens.Open;
    DataModule1.TVendaVALOR_TOTAL.Value:= QSomaItensSUM.Value;



  end;

procedure TFPDV.btnNovaVendaClick(Sender: TObject);

begin

   btnNovaVenda.Enabled:=False;
   FMenu.resetPDV:= True;
   FMenu.resetou:= True;
   concluiu:= True;
   btnCancelar.Click;



end;

procedure TFPDV.CBFormaPagamentoVistaCloseUp(Sender: TObject);
begin
  totalVenda := StrToFloat(DBEdit5.Text);
  if NOT(CBFormaPagamentoVista.Text = 'Dinheiro') then
  begin
    Label13.Visible:=False;
    edtRecebido.Visible:=False;
    Label14.Visible:=False;
    lblTroco.Visible:=False;
    btnConcluir.Enabled:=True;

  end;
end;

procedure TFPDV.DBComboBox1Change(Sender: TObject);
begin
  btnGerarParcelas.Enabled:=True;
end;

procedure TFPDV.DBEdit5Click(Sender: TObject);
begin
  ShowMessage('Este valor é gerado automaticamente pelo sistema');
end;

procedure TFPDV.DBEdit6KeyPress(Sender: TObject; var Key: char);
begin
    if not (Key in ['0'..'9', ',', #8, #9]) then Key := #0;
end;

procedure TFPDV.DBEdit7KeyPress(Sender: TObject; var Key: char);
begin
    if not (Key in ['0'..'9', #8, #9]) then Key := #0;
end;

procedure TFPDV.DBGrid1CellClick(Column: TColumn);
begin
    DataModule1.TItemVenda.Open;
    DataModule1.TItemVenda.Edit;
end;

procedure TFPDV.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    DataModule1.TItemVenda.Open;
    DataModule1.TItemVenda.Edit;
end;

procedure TFPDV.edtRecebidoExit(Sender: TObject);
var
  recebido: Double;
  valortotal: Double;

begin
    recebido := StrToFloat(edtRecebido.Text);
    valortotal := StrToFloat(DBEdit5.Text);
    lblTroco.Caption := FormatFloat('R$ ###,###,##0.00', ((recebido - valortotal)));
    btnConcluir.Enabled:=True;
end;

procedure TFPDV.edtRecebidoKeyPress(Sender: TObject; var Key: char);
begin
            if not (Key in ['0'..'9', ',', #8, #9]) then Key := #0;
end;

procedure TFPDV.edtRecebidoKeyUp(Sender: TObject; var Key: Word;
    Shift: TShiftState);
begin

end;

procedure TFPDV.edtTaxaJurosChange(Sender: TObject);
begin

end;

procedure TFPDV.edtTaxaJurosKeyPress(Sender: TObject; var Key: char);
begin
    if not (Key in ['0'..'9', ',', #8, #9]) then Key := #0;
end;

procedure TFPDV.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

    if (btnCancelar.Enabled = False) then
      begin

        try
         DataModule1.TVenda.Cancel;
         DataModule1.TItemVenda.Cancel;

        except
          ShowMessage('ERRO AO EXECUTAR A TAREFA SOLICITADA');
        end;

      try

        DataModule1.TVenda.ApplyUpdates;
        DataModule1.TItemVenda.ApplyUpdates;
        DataModule1.GeralSQLTransaction.CommitRetaining;

      except
         DataModule1.TVenda.CancelUpdates;
         DataModule1.TItemVenda.CancelUpdates;
         DataModule1.GeralSQLTransaction.RollbackRetaining;
         DataModule1.TVenda.Refresh;
         DataModule1.TItemVenda.Refresh;

         ShowMessage('Nao foi possivel salvar as alteracoes!');
      end;

      end
    else
    begin

      try
 
        DataModule1.TVenda.ApplyUpdates;
        DataModule1.TItemVenda.ApplyUpdates;
        DataModule1.GeralSQLTransaction.CommitRetaining;

      except
         DataModule1.TVenda.CancelUpdates;
         DataModule1.TItemVenda.CancelUpdates;
         DataModule1.GeralSQLTransaction.RollbackRetaining;
         DataModule1.TVenda.Refresh;
         DataModule1.TItemVenda.Refresh;

         ShowMessage('Nao foi possivel salvar as alteracoes!');
      end;



      try

         while NOT DataModule1.TItemVenda.IsEmpty do
           begin
            DataModule1.TItemVenda.Delete;
            DataModule1.TItemVenda.ApplyUpdates;

           end;
      except
         ShowMessage('ERRO AO EXECUTAR A TAREFA SOLICITADA');

      end;



    end;


  ModalResult:=mrAll;

  CloseAction:= caFree;

  FMenu.Show;
  FMenu.BringToFront;



end;

procedure TFPDV.FormShow(Sender: TObject);
begin

     FMenu.resetou:= False;
     FMenu.resetPDV:= False;

     if (FMenu.resetou = True) then
     begin
         vendeu:=False;
         FMenu.resetou:=False;

     end;




       if (concluiu = True) then
      begin
         btnInserirItem.Enabled:= True;
      end;







  PageControl1.PageIndex:= 0;
  btnConcluir.Enabled:= False;
  DBEdit2.SetFocus;
  DBGrid1.SetFocus;
  concluiu:=False;
  prazo:= False;


  if (vendeu = True) then
  begin
  btnAprazo.Enabled:=True;
  btnAvista.Enabled:=True;
  btnEditarItem.Enabled:=True;
  btnExcluirItem.Enabled:=True;

      QSomaItens.Close;
      QSomaItens.ParamByName('chavevenda').Value:= DataModule1.TVendaCHAVE.Value;
      QSomaItens.Open;
      DataModule1.TVendaVALOR_TOTAL.Value:= QSomaItensSUM.Value;


  DataModule1.TItemVenda.Close;
  DataModule1.TItemVenda.Open;



  end
  else
  begin

  DataModule1.TItemVenda.Close;
  DataModule1.TItemVenda.Open;

  end;

  FMenu.Hide;

end;

procedure TFPDV.RadioGroupJurosClick(Sender: TObject);
begin
  
     case RadioGroupJuros.ItemIndex of
      0: begin
           DBEdit6.SetFocus;
           lblTaxaJuros.Visible:=False;
           edtTaxaJuros.Visible:=False;

         end;

      1: begin
           lblTaxaJuros.Visible:=True;
           edtTaxaJuros.Visible:=True;
           edtTaxaJuros.SetFocus;

         end;

     end;

end;

procedure TFPDV.btnEditarItemClick(Sender: TObject);
begin
  inserindo_novo_item:=False;
  DataModule1.TItemVenda.Edit;
  FEdicaoItemVenda := TFEdicaoItemVenda.Create(Self);
  FEdicaoItemVenda.ShowModal;

  QSomaItens.Close;
  QSomaItens.ParamByName('chavevenda').Value := DataModule1.TVendaCHAVE.Value;
  QSomaItens.Open;
  DataModule1.TVendaVALOR_TOTAL.Value := QSomaItensSUM.Value;
end;

procedure TFPDV.btnCancelarClick(Sender: TObject);
begin


  if btnInserirItem.Enabled then
  begin

     while NOT DataModule1.TItemVenda.IsEmpty do             
     begin

      DataModule1.TItemVenda.Delete;
      DataModule1.TItemVenda.ApplyUpdates;

     end;

        QSomaItens.Close;
        QSomaItens.ParamByName('chavevenda').Value := DataModule1.TVendaCHAVE.Value;
        QSomaItens.Open;
        DataModule1.TVendaVALOR_TOTAL.Value := QSomaItensSUM.Value;
  end
  Else
  begin

     while NOT DataModule1.TItemVenda.IsEmpty do
       begin

        DataModule1.TItemVenda.Delete;
        DataModule1.TItemVenda.ApplyUpdates;

       end;

        QSomaItens.Close;
        QSomaItens.ParamByName('chavevenda').Value := DataModule1.TVendaCHAVE.Value;
        QSomaItens.Open;
        DataModule1.TVenda.Edit;

        if (concluiu = False) then
        begin

          DataModule1.TVendaVALOR_TOTAL.Value := QSomaItensSUM.Value;
          DataModule1.TVenda.Post;
          DataModule1.TVenda.ApplyUpdates;
        end;


  end;



  DataModule1.TVenda.Cancel;


  btnNovaVenda.Enabled:=False;

  Close;



end;

procedure TFPDV.btnCancelarParcelaClick(Sender: TObject);
begin
   prazo:= False;

   while NOT DataModule1.TItemVenda.IsEmpty do
   begin
    DataModule1.TItemVenda.Delete;
    DataModule1.TItemVenda.ApplyUpdates;
   end;


  if (btnCancelar.Enabled = False) then
  begin
    DataModule1.TVenda.Cancel; 


     while NOT DataModule1.TItemVenda.IsEmpty do
     begin

      DataModule1.TItemVenda.Delete;
      DataModule1.TItemVenda.Post;
      DataModule1.TItemVenda.ApplyUpdates;
     end;


  end;



  lblTaxaJuros.Visible:=False;
  edtTaxaJuros.Text:= '0';
  edtTaxaJuros.Visible:=False;
  DBEdit6.Text:= '0';
  DBEdit7.Text:='0';
  DBComboBox1.ClearSelection;
  CBFormaPagamento.ClearSelection;
  RadioGroupJuros.ItemIndex:=0;
  TabSheet2.Visible:= False;
  PageControl1.PageIndex:=0;
  btnConcluir.Enabled:=False;
  btnCancelar.Enabled:= True;
  btnEditarItem.Enabled:=False;
  btnExcluirItem.Enabled:=False;
  btnAvista.Enabled:=False;
  btnAprazo.Enabled:=False;
  btnNovaVenda.Enabled:=True;
  cancelouParcelamento:= True;


end;

procedure TFPDV.btnAprazoClick(Sender: TObject);
begin
  prazo:= True;

  TabSheet1.Visible:= False;
  TabSheet2.Visible:= True;

  DataModule1.TContaAReceber.Close;
  DataModule1.TContaAReceber.Open;

  QUltimaChaveContaAReceber.Close;
  QUltimaChaveContaAReceber.Open;


  btnCancelar.Enabled := False;
  btnCancelarParcela.Enabled:=True;
  btnNovaVenda.Enabled:=False;
  btnGerarParcelas.Enabled:=False;

  btnInserirItem.Enabled:=False;
  PageControl1.PageIndex:=1;
  PageControl1.TabIndex:=1;
  TabSheet2.Visible:= True;
  PageControl1.TabIndex:= 1;


end;

procedure TFPDV.btnAvistaClick(Sender: TObject);
begin

  btnAprazo.Enabled:= False;
  btnInserirItem.Enabled:= False;
  btnEditarItem.Enabled:=False;
  btnExcluirItem.Enabled:=False;


  Label12.Visible:=True;
  CBFormaPagamentoVista.Visible:=True;
  Label13.Visible:=True;
  edtRecebido.Visible:=True;
  Label14.Visible:=True;
  lblTroco.Visible:=True;


  CBFormaPagamentoVista.SetFocus;
  CBFormaPagamentoVista.TabStop:=True;
  edtRecebido.TabStop:=True;

end;

procedure TFPDV.btnConcluirClick(Sender: TObject);
begin

  totalVenda := DBEdit5.Field.Value;
  if  DBEdit5.Field.Value > 0 then
  begin
           btnInserirItem.Enabled:=False;
           btnCancelar.Enabled:= False;

      DataModule1.TItemVenda.First;
      while not(DataModule1.TItemVenda.EOF) do
      begin
        if (DataModule1.TProduto.Locate('CHAVE', DataModule1.TItemVendaCHAVE_PRODUTO.Value, [])) then
        begin


          DataModule1.TProduto.Locate('CHAVE', DataModule1.TItemVendaCHAVE_PRODUTO.Value, []);
          DataModule1.TProduto.Edit;

          DataModule1.TProdutoESTOQUE.Value:= DataModule1.TProdutoESTOQUE.Value - DataModule1.TItemVendaQUANTIDADE.Value;

          DataModule1.TProduto.Post;

          DataModule1.TProduto.ApplyUpdates;

        end;
        DataModule1.TItemVenda.Next;
      end;

      if prazo then
      begin


        DataModule1.TVendaFORM_PGTO_VISTA.Value:= 'Entrada ' + CBFormaPagamento.Text;


        DataModule1.TContaAReceber.Last;
        DataModule1.TContaAReceber.Insert;
        DataModule1.TContaAReceberCHAVE.Value:= DataModule1.TContaAReceberCHAVE.Value;



        DataModule1.TContaAReceber.Post;

      end
      else begin
        DataModule1.TVendaFORM_PGTO_VISTA.Value:= CBFormaPagamentoVista.Text;
      end;

      DataModule1.TVendaVALOR_TOTAL.Value := totalVenda;

      DataModule1.TVenda.Post;
      DataModule1.TVenda.ApplyUpdates;
      btnNovaVenda.Enabled:= True;
      btnConcluir.Enabled:= False;
      btnCancelarParcela.Enabled:=False;
      btnAvista.Enabled:=False;

      try
        DataModule1.TContaAReceber.ApplyUpdates;
        DataModule1.GeralSQLTransaction.CommitRetaining;
      except
         DataModule1.TContaAReceber.CancelUpdates;
         DataModule1.GeralSQLTransaction.RollbackRetaining;
         DataModule1.TContaAReceber.Refresh;
         ShowMessage('Nao foi possivel salvar as alteracoes Nas Contas a Receber!');
      end;


      ShowMessage('VENDA REALIZADA COM SUCESSO!');
      concluiu:= True;

      PageControl1.PageIndex:= 0;

      TabSheet2.Visible:= False;
      TabSheet1.Visible:=True;
      PageControl1.PageIndex:=0;
      btnCancelar.Enabled:=True;
      btnCancelarParcela.Enabled:= False;
      btnAprazo.Enabled:=False;
      btnExcluirItem.Enabled:=False;
      btnEditarItem.Enabled:= False;



  end

  else
  ShowMessage('Nenhum valor foi adicionado!'#13'Use o botão Fechar ou Adicione um produto.');



end;

procedure TFPDV.btnExcluirItemClick(Sender: TObject);
var
  acabou: Boolean;
begin

  try

       DataModule1.TItemVenda.Delete;
       DataModule1.TItemVenda.Open;
       DataModule1.TItemVenda.ApplyUpdates;

  except
       acabou:= True;
  end;

  if not acabou then
  begin
      DataModule1.TItemVenda.Open;
      DataModule1.TItemVenda.ApplyUpdates;
  end;

  QSomaItens.Open;
  QSomaItens.Close;
  QSomaItens.ParamByName('chavevenda').Value := DataModule1.TVendaCHAVE.Value;
  QSomaItens.Open;
  DataModule1.TVenda.Open;

  DataModule1.TVendaVALOR_TOTAL.Value := QSomaItensSUM.Value;

end;

procedure TFPDV.btnGerarParcelasClick(Sender: TObject);
var
  valor_parcela: Double;
  parcelas_lancadas: Integer;
  data_vencimento: String;
  mes, ano, nrParcelas: Integer;

  principal, taxa, coefiDeFinanciamento: Double;

begin
  prazo:= true;
  DataModule1.TContaAReceber.Last;

  if DataModule1.TVendaQUANTIDADE_PARCELAS.Value > 0 then
  begin

     case RadioGroupJuros.ItemIndex of
      0: begin
           valor_parcela := (DataModule1.TVendaVALOR_TOTAL.Value -
           DataModule1.TVendaVALOR_PAGO_ENTRADA.Value) /
           DataModule1.TVendaQUANTIDADE_PARCELAS.Value;


         end;

      1: begin

            principal := StrToFloat(DBEdit5.Text);
            taxa := (StrToFloat(edtTaxaJuros.Text))/100;
            nrParcelas := StrToIntDef(DBEdit7.Text, 0);
            principal:= principal - StrToFloatDef(DBEdit6.Text, 0);
              coefiDeFinanciamento:= Power((1 + taxa), nrParcelas);
              coefiDeFinanciamento:= 1 / coefiDeFinanciamento;
              coefiDeFinanciamento:= 1 - coefiDeFinanciamento;
              coefiDeFinanciamento:= taxa / coefiDeFinanciamento ;

            valor_parcela := principal * coefiDeFinanciamento;


         end;

     end;


  end;
  if DataModule1.TVendaVALOR_PAGO_ENTRADA.Value > 0 then
  begin
     QUltimaChaveContaAReceber.Close;
     QUltimaChaveContaAReceber.Open;
     DataModule1.TContaAReceber.Insert;
     DataModule1.TContaAReceberCHAVE.Value:= QUltimaChaveContaAReceberADD.Value;
     DataModule1.TContaAReceberCHAVE_CLIENTE.Value:= DataModule1.TVendaCHAVE_CLIENTE.Value;
     DataModule1.TContaAReceberCHAVE_VENDA.Value:= DataModule1.TVendaCHAVE.Value;
     DataModule1.TContaAReceberDATA_PAGAMEMTO.Value:= DataModule1.TVendaDATA.Value;
     DataModule1.TContaAReceberDATA_VENCIMENTO.Value:= DataModule1.TVendaDATA.Value;
     DataModule1.TContaAReceberSTATUS.Value:= 'PAGO';

     DataModule1.TContaAReceberFORMA_PAGTO.Value:= CBFormaPagamento.Text;

     DataModule1.TContaAReceberVALOR.Value:= DataModule1.TVendaVALOR_PAGO_ENTRADA.Value;
     DataModule1.TContaAReceber.Post;
     DataModule1.TContaAReceber.ApplyUpdates;
  end;
  mes:= StrToInt(FormatDateTime('MM', DataModule1.TVendaDATA.Value));
  ano:= StrToInt(FormatDateTime('YYYY', DataModule1.TVendaDATA.Value));
  parcelas_lancadas:= 0;
  while (parcelas_lancadas < DataModule1.TVendaQUANTIDADE_PARCELAS.Value) do
  begin
    if mes = 12 then
    begin
      mes:= 1;
      ano:= ano + 1;
    end else
    begin
      mes:= mes + 1;
    end;

    data_vencimento:= DataModule1.TVendaDIA_DO_MES_PRA_VENCER.AsString + '/' + IntToStr(mes) + '/' + IntToStr(ano);

    QUltimaChaveContaAReceber.Close;
    QUltimaChaveContaAReceber.Open;
    DataModule1.TContaAReceber.Insert;
    DataModule1.TContaAReceberCHAVE.Value := QUltimaChaveContaAReceberADD.Value;
    DataModule1.TContaAReceberCHAVE_CLIENTE.Value := DataModule1.TVendaCHAVE_CLIENTE.Value;
    DataModule1.TContaAReceberCHAVE_VENDA.Value := DataModule1.TVendaCHAVE.Value;
    DataModule1.TContaAReceberDATA_VENCIMENTO.Value := StrToDateTime(data_vencimento);
    DataModule1.TContaAReceberSTATUS.Value := 'PENDENTE';
    DataModule1.TContaAReceberVALOR.Value := valor_parcela;
    DataModule1.TContaAReceber.Post;
    DataModule1.TContaAReceber.ApplyUpdates;

    parcelas_lancadas:= parcelas_lancadas + 1;
  end;
  btnConcluir.Enabled:= True;
  btnNovaVenda.Enabled:=False;
  btnCancelarParcela.Enabled:= False;
  btnCancelar.Enabled:= False;
  btnGerarParcelas.Enabled:=False;
  DBGrid2.Visible:= True;



end;

end.

