unit ucadastrofornecedores;



interface

uses
 Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
 DBGrids, StdCtrls, Buttons, ZDataset, UITypes;


type

  { TFCadastroFornecedores }


  TFCadastroFornecedores = class(TForm)
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnFechar: TSpeedButton;
    btnInserir: TSpeedButton;
    btnVisualizar: TSpeedButton;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DSLigaFornecedorProdutos: TDataSource;
    EditBusca: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    QBuscaLiga: TDataSource;
    QLigaForProdDESCRICAO: TStringField;
    QUltimaChaveFornecedores: TSQLQuery;
    QLigaForProd: TSQLQuery;
    QUltimaChaveFornecedoresADD: TLargeintField;
    ZTLigaForneceProdutos: TSQLQuery;
    ZTLigaForneceProdutosBAIRRO: TStringField;
    ZTLigaForneceProdutosCEP: TStringField;
    ZTLigaForneceProdutosCHAVE: TLongintField;
    ZTLigaForneceProdutosCHAVE_PRODUTO: TLongintField;
    ZTLigaForneceProdutosCIDADE: TStringField;
    ZTLigaForneceProdutosCOMPLEMENTO: TStringField;
    ZTLigaForneceProdutosCPF_CNPJ: TStringField;
    ZTLigaForneceProdutosEMAIL: TStringField;
    ZTLigaForneceProdutosLOGRADOURO: TStringField;
    ZTLigaForneceProdutosNOME: TStringField;
    ZTLigaForneceProdutosNUMERO: TStringField;
    ZTLigaForneceProdutosOBSERVACAO: TStringField;
    ZTLigaForneceProdutosRAZAO_SOCIAL: TStringField;
    ZTLigaForneceProdutosSITE: TStringField;
    ZTLigaForneceProdutosTELEFONE_1: TStringField;
    ZTLigaForneceProdutosTELEFONE_2: TStringField;
    ZTLigaForneceProdutosTIPO_PESSOA: TStringField;
    ZTLigaForneceProdutosUF: TStringField;

    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnVerProdutosClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure EditBuscaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public

  end;

var
  FCadastroFornecedores: TFCadastroFornecedores;
  apontaProduto : Integer;

implementation

uses
  udatamodule1, udadosfornecedores, uedicaofornecedores, UMenu;

{$R *.lfm}

{ TFCadastroFornecedores }

procedure TFCadastroFornecedores.btnEditarClick(Sender: TObject);
begin
  DataModule1.TFornecedores.Filtered:= false;
  DataModule1.TFornecedores.Edit;
  FEdicaoFornecedores := TFEdicaoFornecedores.Create(Self);
  FEdicaoFornecedores.Caption:='Editar dados do Fornecedor';
  FEdicaoFornecedores.lblTituloJanela.Caption:= ' Editar '#13#10'dados do Fornecedor';
  FEdicaoFornecedores.ShowModal;
end;

procedure TFCadastroFornecedores.btnExcluirClick(Sender: TObject);

begin

      with TTaskDialog.Create(self) do
    try
      Title := 'ESTA AÇÃO NÃO PODE SER DESFEITA!';
      Caption := 'ATENÇÃO';
      Text := 'Deseja realmente apagar este registro?';

      CommonButtons := [];
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := 'APAGAR';
        ModalResult := mrYes;
      end;
      with TTaskDialogButtonItem(Buttons.Add) do
      begin
        Caption := 'CANCELAR';
        ModalResult := mrNo;
      end;
      MainIcon := tdiWarning;
      if Execute then
        if ModalResult = mrYes then
          DataModule1.TFornecedores.Delete;
          DataModule1.TFornecedores.ApplyUpdates;

    finally
     Free ;
    end

end;

procedure TFCadastroFornecedores.btnInserirClick(Sender: TObject);
begin


  DataModule1.TFornecedores.Filtered:= false;

  QUltimaChaveFornecedores.Close;
  QUltimaChaveFornecedores.Open;

  DataModule1.TFornecedores.Insert;
  DataModule1.TFornecedoresCHAVE.Value:= QUltimaChaveFornecedoresADD.Value;
  FEdicaoFornecedores := TFEdicaoFornecedores.Create(Self);
  FEdicaoFornecedores.ShowModal;


end;

procedure TFCadastroFornecedores.btnVerProdutosClick(Sender: TObject);
begin
    QLigaForProd.Close;
    QLigaForProd.SQL.Clear;
    QLigaForProd.SQL.Add('SELECT DESCRICAO FROM PRODUTOS INNER JOIN FORNECEDORES ON PRODUTOS.CHAVE_FORNECEDOR  = FORNECEDORES.CHAVE WHERE FORNECEDORES.CHAVE = :PARAMETRO');
    QLigaForProd.Params.ParamByName('PARAMETRO').Value := apontaProduto;
    QLigaForProd.Open;
end;

procedure TFCadastroFornecedores.btnVisualizarClick(Sender: TObject);
begin

  DataModule1.TFornecedores.Active:= True;
  DataModule1.TFornecedores.Filtered := False;
  DataModule1.TFornecedores.Edit;
  FDadosFornecedores := TFDadosFornecedores.Create(Self);
  FDadosFornecedores.ShowModal;
end;

procedure TFCadastroFornecedores.DBGrid1CellClick(Column: TColumn);
begin
    QLigaForProd.Close;
    QLigaForProd.SQL.Clear;
    QLigaForProd.SQL.Add('SELECT DESCRICAO FROM PRODUTOS INNER JOIN FORNECEDORES ON PRODUTOS.CHAVE_FORNECEDOR  = FORNECEDORES.CHAVE WHERE FORNECEDORES.CHAVE = :PARAMETRO');
    QLigaForProd.Params.ParamByName('PARAMETRO').Value := apontaProduto;
    apontaProduto:= DataModule1.TFornecedores.FieldByName('CHAVE').Value;
    QLigaForProd.Open;
end;

procedure TFCadastroFornecedores.DBGrid1DblClick(Sender: TObject);
begin
    QLigaForProd.Close;
    QLigaForProd.SQL.Clear;
    QLigaForProd.SQL.Add('SELECT DESCRICAO FROM PRODUTOS INNER JOIN FORNECEDORES ON PRODUTOS.CHAVE_FORNECEDOR  = FORNECEDORES.CHAVE WHERE FORNECEDORES.CHAVE = :PARAMETRO');
    QLigaForProd.Params.ParamByName('PARAMETRO').Value := apontaProduto;
    apontaProduto:= DataModule1.TFornecedores.FieldByName('CHAVE').Value;
    QLigaForProd.Open;
end;

procedure TFCadastroFornecedores.EditBuscaChange(Sender: TObject);
begin

  DataModule1.TFornecedores.Filter:= 'NOME = ' +QuotedStr('*'+EditBusca.Text+'*');
  DataModule1.TFornecedores.Filtered:= true;
  apontaProduto:= DataModule1.TFornecedores.FieldByName('CHAVE').Value;
  QLigaForProd.Close;
  QLigaForProd.SQL.Clear;
  QLigaForProd.SQL.Add('SELECT DESCRICAO FROM PRODUTOS INNER JOIN FORNECEDORES ON PRODUTOS.CHAVE_FORNECEDOR  = FORNECEDORES.CHAVE WHERE FORNECEDORES.CHAVE = :PARAMETRO');
  QLigaForProd.Params.ParamByName('PARAMETRO').Value := apontaProduto;
  QLigaForProd.Open;

end;

procedure TFCadastroFornecedores.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   // Bloco para salvar fisicamente no BD as alteracoes ao fechar a janela - Mac usando TSQLQuery e TSQLTransaction
  try
    DataModule1.TFornecedores.ApplyUpdates;
    DataModule1.GeralSQLTransaction.CommitRetaining;
  except
     DataModule1.TFornecedores.CancelUpdates;
     DataModule1.GeralSQLTransaction.RollbackRetaining;
     DataModule1.TFornecedores.Refresh;
     ShowMessage('Nao foi possivel salvar as alteracoes!');
  end;

  FMenu.Show;
end;

procedure TFCadastroFornecedores.FormShow(Sender: TObject);
begin
  FMenu.Hide;
  ZTLigaForneceProdutos.Open;
  EditBusca.SetFocus;
end;

procedure TFCadastroFornecedores.Image1Click(Sender: TObject);
var f : TForm;
begin

   f := CreateMessageDialog('Comercial Básico by IA.seg.br','DICAS'+#13#10+ '01 - Após realizar uma busca - limpe o campo para voltar a exibir toda a listagem'+#13#10+ '02 - Ao buscar - digite o nome como ele foi cadastrado'+#13#10+ '03 - A opção “Visualizar” permite apenas ver todos os dados cadastrados '+#13#10+ '04 - Para alterar dados use a opção “Editar” '+#13#10+ '05 - Antes de usar a opção “Excluir” selecione um ítem na lista ou faça uma busca'+#13#10+ '06 - Ao cadastrar - faça com critério - padronize procedimentos'+#13#10+ '07 -  Manter os dados organizados é fundamental para bons resultados'+#13#10+ '08 - Para ver produtos de cada Fornecedor use “duplo clique” na listagem superior', mtInformation, [mbOK]);
   f.Position := poOwnerFormCenter;
   f.ShowModal;

end;

procedure TFCadastroFornecedores.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.

