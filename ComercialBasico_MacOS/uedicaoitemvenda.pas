     unit uedicaoitemvenda;



interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  Buttons, ExtCtrls, DB, SQLDB;

type

  { TFEdicaoItemVenda }

  TFEdicaoItemVenda = class(TForm)

    btnCancelar: TSpeedButton;
    btnSalvar: TSpeedButton;
    CheckBox1: TCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    Edit1: TEdit;
    edtBusca: TEdit;
    Image1: TImage;
    Label1: TLabel;
    escreveNomeProduto: TLabel;
    lblAviso: TLabel;
    lblEstoque: TLabel;
    lblMemorizaEstoque: TLabel;
    LProduto: TLabel;
    LProduto1: TLabel;
    LProduto2: TLabel;
    LProduto3: TLabel;
    LProduto4: TLabel;
    LProduto5: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Bevel1ChangeBounds(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox1ChangeBounds(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure DBEdit1Exit(Sender: TObject);
    procedure DBEdit2Change(Sender: TObject);
    procedure DBEdit2Exit(Sender: TObject);
    procedure DBEdit3Change(Sender: TObject);
    procedure DBEdit3Exit(Sender: TObject);
    procedure DBEdit3KeyPress(Sender: TObject; var Key: char);
    procedure DBEdit4Change(Sender: TObject);
    procedure DBEdit4Exit(Sender: TObject);
    procedure DBEdtCodigoBarraChange(Sender: TObject);
    procedure DBLookupComboBox1Change(Sender: TObject);
    procedure DBLookupComboBox1Click(Sender: TObject);
    procedure DBLookupComboBox1Enter(Sender: TObject);
    procedure DBLookupComboBox1Exit(Sender: TObject);
    procedure DBLookupComboBox1KeyPress(Sender: TObject; var Key: char);
    procedure DBLookupComboBox1KeyUp(Sender: TObject; var Key: Word;
        Shift: TShiftState);
    procedure DBLookupComboBox1Select(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure edtBuscaChange(Sender: TObject);
    procedure edtBuscaEnter(Sender: TObject);
    procedure edtBuscaExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure LProduto4Click(Sender: TObject);
  private

  public

  end;

var
  FEdicaoItemVenda: TFEdicaoItemVenda;
  quantidadePedida: integer;
  estoqueInicial: string;
   escolheu: Boolean;
   apontaProduto: Integer;


implementation

uses udatamodule1,UMenu, uPDV;

{$R *.lfm}

{ TFEdicaoItemVenda }

procedure TFEdicaoItemVenda.btnCancelarClick(Sender: TObject);
begin
  btnCancelar.Enabled:= False;
  DataModule1.TItemVenda.Cancel;

  FPDV.EspelhoTItemVenda.Cancel;
  FPDV.cancelou:=True;
  FPDV.vendeu:=False;
  DataModule1.TProduto.Filtered:= False; 
  Close;
end;

procedure TFEdicaoItemVenda.Bevel1ChangeBounds(Sender: TObject);
begin

end;

procedure TFEdicaoItemVenda.btnSalvarClick(Sender: TObject);
begin


    if quantidadePedida > (StrToIntDef(estoqueInicial, 0)) then
    begin

      with TTaskDialog.Create(Self) do
        try
          Caption := 'AVISO DO SISTEMA';
          Title := 'ATENÇÃO!';
          Text := 'A quantidade deste pedido excede o estoque atual.' +
            'Favor avisar ao cliente e limitar o pedido ao estoque.';
          CommonButtons := [tcbClose];
          Execute;
        finally
           Free;
        end;


      btnSalvar.Enabled := False;
    end
    else if  quantidadePedida <= (StrToIntDef(estoqueInicial, 0)) then
     begin
      btnCancelar.Enabled := False;
      DataModule1.TItemVenda.Post;
      DataModule1.TItemVenda.ApplyUpdates;

      FPDV.totalParcial:= DataModule1.TItemVendaVALOR_TOTAL.Value;



        FPDV.QSomaItens.Open;
        FPDV.QSomaItens.Close;
        FPDV.QSomaItens.ParamByName('chavevenda').Value := DataModule1.TVendaCHAVE.Value;
        FPDV.QSomaItens.Open;


        DataModule1.TVenda.Open;



        DataModule1.TVendaVALOR_TOTAL.Value := FPDV.QSomaItensSUM.Value;



      lblEstoque.Caption := ((StrToIntDef(lblEstoque.Caption, 0)) -
      (StrToIntDef(DBEdit3.Text, 0))).ToString;

      FPDV.vendeu:= True;


      DataModule1.TProduto.Filtered:= False; 

      Close;


     end


end;


procedure TFEdicaoItemVenda.CheckBox1Click(Sender: TObject);
begin
    Edit1.Clear;
    if (CheckBox1.State = cbChecked) then
    begin




        DBLookupComboBox1.Visible:= False;

        try
            escreveNomeProduto.Caption:=(DataModule1.TProdutoDESCRICAO.Value);
        finally
            FMenu.usarCodigoBarras:= True;
        end;



        escreveNomeProduto.Top:= 184;
        escreveNomeProduto.Visible:= True;
        Edit1.SetFocus;
        lblEstoque.Visible:= False;
        LProduto5.Visible:= False;
        edtBusca.Visible:= False;
        LProduto4.Caption:= 'NOME DO PRODUTO';


    end
    Else
    begin




        FMenu.usarCodigoBarras:= False;

        DBLookupComboBox1.Visible:= True;
        LProduto5.Visible:= True;

        escreveNomeProduto.Top:= 219;
        escreveNomeProduto.Visible:= True;
        escreveNomeProduto.Caption:= '';

        LProduto4.Caption:= 'BUSCAR PELO NOME DO PRODUTO';
        lblEstoque.Visible:= False;

        edtBusca.Visible:=True;
        edtBusca.SetFocus;

    end;
end;

procedure TFEdicaoItemVenda.DBEdit1Exit(Sender: TObject);
begin

end;

procedure TFEdicaoItemVenda.DBEdit2Change(Sender: TObject);
begin

end;

procedure TFEdicaoItemVenda.DBEdit2Exit(Sender: TObject);
begin
   DataModule1.TItemVendaVALOR_TOTAL.Value:= DataModule1.TItemVendaPRECO_UNITARIO.Value * DataModule1.TItemVendaQUANTIDADE.Value;
end;

procedure TFEdicaoItemVenda.DBEdit3Change(Sender: TObject);

begin

  estoqueInicial := lblMemorizaEstoque.Caption;
  lblEstoque.Caption := estoqueInicial;

  quantidadePedida := (StrToIntDef(DBEdit3.Text, 0));

  if not (DBEdit3.DataField.IsEmpty) then
  begin
    if quantidadePedida > (StrToIntDef(lblEstoque.Caption, 0)) then
      begin
        lblEstoque.Font.Color:= clRed;

      end
      else
      begin
        lblEstoque.Caption := ((StrToIntDef(lblEstoque.Caption, 0)) -
          (StrToIntDef(DBEdit3.Text, 0))).ToString;
          lblEstoque.Font.Color:= clDefault;
      end;
  end
  else
  begin

       DBEdit3.Text := '0';
  end;
end;

procedure TFEdicaoItemVenda.DBEdit3Exit(Sender: TObject);
begin

  if edtBusca.Visible then
  begin
     edtBusca.TabStop := True;
  end;



  DataModule1.TItemVendaVALOR_TOTAL.Value:= DataModule1.TItemVendaPRECO_UNITARIO.Value * DataModule1.TItemVendaQUANTIDADE.Value;

end;

procedure TFEdicaoItemVenda.DBEdit3KeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', '.', #8, #9]) then Key := #0;
end;

procedure TFEdicaoItemVenda.DBEdit4Change(Sender: TObject);
begin
  if (DBEdit4.Text <> '0') and NOT(DBEdit4.Text = Null)  then
  begin
        btnSalvar.Enabled := True;
  end


end;

procedure TFEdicaoItemVenda.DBEdit4Exit(Sender: TObject);
begin
      if (DBEdit4.Text <> '0') and NOT(DBEdit4.Text = Null)  then
  begin
        btnSalvar.Enabled := True;
  end
  Else
  begin
       ShowMessage('Digite quantidade e pressione ENTER ou TAB para gerar o valor total');

       try
          DBEdit3.SetFocus;
       finally

       end;


  end;
end;

procedure TFEdicaoItemVenda.DBEdtCodigoBarraChange(Sender: TObject);
begin


end;

procedure TFEdicaoItemVenda.DBLookupComboBox1Change(Sender: TObject);
begin

    if (edtBusca.Text <> '') then
      begin
         edtBusca.Clear;                

      end;

  DBEdit4.Clear;
  DataModule1.TItemVendaQUANTIDADE.Value:= 0;
  btnSalvar.Enabled:=False;

end;

procedure TFEdicaoItemVenda.DBLookupComboBox1Click(Sender: TObject);
begin

  if (edtBusca.Text <> '') then
  begin
     edtBusca.Clear;      

  end;


   apontaProduto:= DataModule1.TProduto.FieldByName('CHAVE').Value;    

   DataModule1.TItemVendaQUANTIDADE.Value:= 0;
   btnSalvar.Enabled:=False;
   DBEdit4.Clear;


end;

procedure TFEdicaoItemVenda.DBLookupComboBox1Enter(Sender: TObject);
begin

      if (edtBusca.Text <> '') then
      begin
         edtBusca.Clear;   

      end;


end;

procedure TFEdicaoItemVenda.DBLookupComboBox1Exit(Sender: TObject);
begin




  if (DataModule1.TProduto.Locate('CHAVE', DataModule1.TItemVendaCHAVE_PRODUTO.Value, [])) then





  begin
     DBEdit3.Text := '0';
     lblEstoque.Caption:= (DataModule1.TProdutoESTOQUE.Value).ToString();
     lblMemorizaEstoque.Caption:= lblEstoque.Caption;
     DataModule1.TProduto.Locate('CHAVE', DataModule1.TItemVendaCHAVE_PRODUTO.Value, []);

     apontaProduto:= DataModule1.TProduto.FieldByName('CHAVE').Value;

     DataModule1.TItemVendaPRECO_UNITARIO.Value:= StrToCurr(DataModule1.TProdutoPRECO_VENDA.Value);
     DataModule1.TItemVendaVALOR_TOTAL.Value:= DataModule1.TItemVendaPRECO_UNITARIO.Value * DataModule1.TItemVendaQUANTIDADE.Value;
     lblAviso.Visible:=True;
     lblEstoque.Visible:=True;
  end;

end;

procedure TFEdicaoItemVenda.DBLookupComboBox1KeyPress(Sender: TObject;
    var Key: char);
begin


end;

procedure TFEdicaoItemVenda.DBLookupComboBox1KeyUp(Sender: TObject;
    var Key: Word; Shift: TShiftState);
begin


end;

procedure TFEdicaoItemVenda.DBLookupComboBox1Select(Sender: TObject);
begin



   if (DataModule1.TProduto.Locate('CHAVE', DataModule1.TItemVendaCHAVE_PRODUTO.Value, [])) then





      begin
         DBEdit3.Text := '0';
         lblEstoque.Caption:= (DataModule1.TProdutoESTOQUE.Value).ToString();
         lblMemorizaEstoque.Caption:= lblEstoque.Caption;
         DataModule1.TProduto.Locate('CHAVE', DataModule1.TItemVendaCHAVE_PRODUTO.Value, []);

         apontaProduto:= DataModule1.TProduto.FieldByName('CHAVE').Value;

         DataModule1.TItemVendaPRECO_UNITARIO.Value:= StrToCurr(DataModule1.TProdutoPRECO_VENDA.Value);
         DataModule1.TItemVendaVALOR_TOTAL.Value:= DataModule1.TItemVendaPRECO_UNITARIO.Value * DataModule1.TItemVendaQUANTIDADE.Value;
         lblAviso.Visible:=True;
         lblEstoque.Visible:=True;
      end;


  DBEdit3.SetFocus;

end;

procedure TFEdicaoItemVenda.Edit1Change(Sender: TObject);
begin
    
  DataModule1.TProduto.Filter:= 'CODIGOBARRAS = ' +QuotedStr('*'+Edit1.Text+'*');
  DataModule1.TProduto.Filtered:= true;

  escreveNomeProduto.Caption:=(DataModule1.TProdutoDESCRICAO.Value);

  apontaProduto:= DataModule1.TProduto.FieldByName('CHAVE').Value;


    if (DataModule1.TProduto.Locate('CHAVE', DataModule1.TItemVendaCHAVE_PRODUTO.Value, [])) then
      begin
         DBEdit3.Text := '0';
         lblEstoque.Caption:= (DataModule1.TProdutoESTOQUE.Value).ToString();
         lblMemorizaEstoque.Caption:= lblEstoque.Caption;
         DataModule1.TProduto.Locate('CHAVE', DataModule1.TItemVendaCHAVE_PRODUTO.Value, []);
         DataModule1.TItemVendaPRECO_UNITARIO.Value:= StrToCurr(DataModule1.TProdutoPRECO_VENDA.Value);
         DataModule1.TItemVendaVALOR_TOTAL.Value:= DataModule1.TItemVendaPRECO_UNITARIO.Value * DataModule1.TItemVendaQUANTIDADE.Value;
         lblAviso.Visible:=True;
         lblEstoque.Visible:=True;
      end;

end;

procedure TFEdicaoItemVenda.Edit1Exit(Sender: TObject);
begin

  DataModule1.TProduto.Filter:= 'CODIGOBARRAS = ' +QuotedStr('*'+Edit1.Text+'*');
  DataModule1.TProduto.Filtered:= true;

  escreveNomeProduto.Caption:=(DataModule1.TProdutoDESCRICAO.Value);

  apontaProduto:= DataModule1.TProduto.FieldByName('CHAVE').Value;


     DBEdit3.Text := '0';
     lblEstoque.Caption:= (DataModule1.TProdutoESTOQUE.Value).ToString();
     lblMemorizaEstoque.Caption:= lblEstoque.Caption;
     DataModule1.TItemVendaCHAVE_PRODUTO.Value := apontaProduto;
     DataModule1.TItemVendaPRECO_UNITARIO.Value:= StrToCurr(DataModule1.TProdutoPRECO_VENDA.Value);
     DataModule1.TItemVendaVALOR_TOTAL.Value:= DataModule1.TItemVendaPRECO_UNITARIO.Value * DataModule1.TItemVendaQUANTIDADE.Value;
     lblAviso.Visible:=True;
     lblEstoque.Visible:=True;

end;

procedure TFEdicaoItemVenda.edtBuscaChange(Sender: TObject);
begin


  DataModule1.TProduto.Filter:= 'DESCRICAO = ' +QuotedStr('*'+edtBusca.Text+'*'); 
  DataModule1.TProduto.Filtered:= true;
  escreveNomeProduto.Caption:= DataModule1.TProdutoDESCRICAO.Value;



end;

procedure TFEdicaoItemVenda.edtBuscaExit(Sender: TObject);
begin

     DBLookupComboBox1.Text:= DataModule1.TProdutoDESCRICAO.Value;

     apontaProduto:= DataModule1.TProduto.FieldByName('CHAVE').Value;


     lblEstoque.Caption:= (DataModule1.TProdutoESTOQUE.Value).ToString();
     lblMemorizaEstoque.Caption:= lblEstoque.Caption;
     DataModule1.TItemVendaCHAVE_PRODUTO.Value := apontaProduto;
     DataModule1.TItemVendaPRECO_UNITARIO.Value:= StrToCurr(DataModule1.TProdutoPRECO_VENDA.Value);
     DataModule1.TItemVendaVALOR_TOTAL.Value:= DataModule1.TItemVendaPRECO_UNITARIO.Value * DataModule1.TItemVendaQUANTIDADE.Value;
     lblAviso.Visible:=True;
     lblEstoque.Visible:=True;
end;

procedure TFEdicaoItemVenda.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (btnCancelar.Enabled = True) then
     begin
       FPDV.EspelhoTItemVenda.Cancel;
       DataModule1.TItemVenda.Cancel;
     end;

  DataModule1.TProduto.Filtered:= False; 
  lblEstoque.Caption:= '0';
  FPDV.Show;
end;

procedure TFEdicaoItemVenda.FormShow(Sender: TObject);
begin
  FPDV.Hide;
  if (FMenu.usarCodigoBarras = True) then
  begin

        DBLookupComboBox1.TabStop:= False;
        DBLookupComboBox1.Visible:= False;
        edtBusca.Visible:= False;
        LProduto4.Caption:= 'NOME DO PRODUTO';
        LProduto5.Visible:=False;

        try
            escreveNomeProduto.Caption:=(DataModule1.TProdutoDESCRICAO.Value);
        finally
             CheckBox1.Checked:= True;
        end;


        escreveNomeProduto.Top:= 184;
        escreveNomeProduto.Visible:= True;
        Edit1.SetFocus;

  end
  else
  begin

     escreveNomeProduto.Top:= 219;
     CheckBox1.Checked:= False;
     escreveNomeProduto.Visible:=True;
     LProduto5.Visible:=True;
     edtBusca.Visible:= True;
     edtBusca.SetFocus;
  end;


end;

procedure TFEdicaoItemVenda.Image1Click(Sender: TObject);
var f : TForm;
begin

   f := CreateMessageDialog('Comercial Básico by IA.seg.br','DICAS'+#13#10+ '01 - Use a tecla TAB para navegar'+#13#10+ '02 - Use vírgula para separar centavos'+#13#10+ '03 - Digite uma quantidade e pressione TAB para poder salvar'+#13#10+ '04 - Os campos de busca são independentes'+#13#10+ '05 - A opção “Buscar usando Código de Barras” torna a interface mais simples'+#13#10+ '06 - A opção “Selecionar na Lista” é acessível apenas por toque ou usando o mouse'+#13#10+ '07 - Qualquer erro, refaça a operação ou feche a janela e abra novamente', mtInformation, [mbOK]);
   f.Position := poOwnerFormCenter;
   f.ShowModal;

end;


end.


