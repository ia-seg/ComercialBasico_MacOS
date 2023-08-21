unit ucadastroproduto;



interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Buttons, Graphics, Dialogs,
  ExtCtrls, DBGrids, StdCtrls, ZDataset, FileUtil;


type

  { TFCadastroProduto }

  TFCadastroProduto = class(TForm)
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnFechar: TSpeedButton;
    btnInserir: TSpeedButton;
    btnVisualizar: TSpeedButton;
    DSEspelho_TProduto: TDataSource;
    DBGrid1: TDBGrid;
    EditBusca: TEdit;
    Espelho_TProdutoPRECO_COMPRA: TStringField;
    Espelho_TProdutoPRECO_VENDA: TStringField;
    Image1: TImage;
    Label1: TLabel;
    Panel2: TPanel;
    Panel5: TPanel;
    QUltimaChaveProduto: TSQLQuery;
    QUltimaChaveProdutoADD: TLargeintField;
    Espelho_TProduto: TSQLQuery;
    Espelho_TProdutoCHAVE: TLongintField;
    Espelho_TProdutoCHAVE_FORNECEDOR: TLongintField;
    Espelho_TProdutoCODIGOBARRAS: TStringField;
    Espelho_TProdutoDESCRICAO: TStringField;
    Espelho_TProdutoESTOQUE: TFloatField;
    Espelho_TProdutoOBSERVACAO: TStringField;
    Espelho_TProdutoUNIDADE: TStringField;
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure EditBuscaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public

  end;

var
  FCadastroProduto: TFCadastroProduto;

implementation

uses udatamodule1, uEdicaoProduto, UMenu;

{$R *.lfm}

{ TFCadastroProduto }

procedure TFCadastroProduto.btnInserirClick(Sender: TObject);
begin

  DataModule1.TProduto.Filtered:= false;
  QUltimaChaveProduto.Close;
  QUltimaChaveProduto.Open;
  DataModule1.TProduto.Insert;
  DataModule1.TProdutoCHAVE.Value:= QUltimaChaveProdutoADD.Value;
  FEdicaoProduto := TFEdicaoProduto.Create(Self);
  FEdicaoProduto.ShowModal;
end;

procedure TFCadastroProduto.btnVisualizarClick(Sender: TObject);
begin
  DataModule1.TProduto.Filtered:= false;
  DataModule1.TProduto.Edit;
  FEdicaoProduto := TFEdicaoProduto.Create(Self);
  FEdicaoProduto.btnSalvar.Visible:= False;


  FEdicaoProduto.DBEdit2.ReadOnly:=True;
  FEdicaoProduto.DBEdit3.ReadOnly:=True;
  FEdicaoProduto.CBUnidade.ReadOnly:=True;
  FEdicaoProduto.DBEdit4.ReadOnly:=True;
  FEdicaoProduto.DBEdit5.ReadOnly:=True;
  FEdicaoProduto.DBEdit6.ReadOnly:=True;
  FEdicaoProduto.DBLookupComboBox1.ReadOnly:=True;
  FEdicaoProduto.DBLookupComboBox1.ReadOnly:=True;
  FEdicaoProduto.lblTituloJanela.Caption:='Dados'+#13#10+ 'do Produto';
  FEdicaoProduto.Caption:='Dados do Produto';
  FEdicaoProduto.btnCancelar.Caption:='Fechar';


  FEdicaoProduto.ShowModal;
end;

procedure TFCadastroProduto.DBGrid1CellClick(Column: TColumn);
begin


  EditBusca.Text := DBGrid1.Columns.ColumnByFieldname('DESCRICAO').Field.Text;
  DataModule1.TProduto.Filter:= 'DESCRICAO = ' +QuotedStr('*'+EditBusca.Text+'*');
  DataModule1.TProduto.Filtered:= true;


  Espelho_TProduto.Filter:= 'DESCRICAO = ' +QuotedStr('*'+EditBusca.Text+'*');
  Espelho_TProduto.Filtered:= true;

end;

procedure TFCadastroProduto.EditBuscaChange(Sender: TObject);
begin


  DataModule1.TProduto.Filter:= 'DESCRICAO = ' +QuotedStr('*'+EditBusca.Text+'*');
  DataModule1.TProduto.Filtered:= true;


  Espelho_TProduto.Filter:= 'DESCRICAO = ' +QuotedStr('*'+EditBusca.Text+'*');
  Espelho_TProduto.Filtered:= true;

end;

procedure TFCadastroProduto.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  try
    DataModule1.TProduto.ApplyUpdates;
    DataModule1.GeralSQLTransaction.CommitRetaining;
  except
     DataModule1.TProduto.CancelUpdates;
     DataModule1.GeralSQLTransaction.RollbackRetaining;
     DataModule1.TProduto.Refresh;
     ShowMessage('Nao foi possivel salvar as alteracoes!');
  end;

  FMenu.Show;
end;

procedure TFCadastroProduto.FormShow(Sender: TObject);
begin
    FMenu.Hide;
    EditBusca.SetFocus;

    Espelho_TProduto.Close;
    Espelho_TProduto.Open;

end;

procedure TFCadastroProduto.Image1Click(Sender: TObject);
var f : TForm;
begin

   f := CreateMessageDialog('Comercial Básico by IA.seg.br','DICAS'+#13#10+ '01 - Após realizar uma busca - limpe o campo para voltar a exibir toda a listagem'+#13#10+ '02 - Ao buscar - digite o nome como ele foi cadastrado'+#13#10+ '03 - A opção “Visualizar” permite apenas ver todos os dados cadastrados '+#13#10+ '04 - Para alterar dados use a opção “Editar” '+#13#10+ '05 - Antes de usar a opção “Excluir” selecione um ítem na lista ou faça uma busca'+#13#10+ '06 - Ao cadastrar - faça com critério - padronize procedimentos'+#13#10+ '07 -  Manter os dados organizados é fundamental para bons resultados ', mtInformation, [mbOK]);
   f.Position := poOwnerFormCenter;
   f.ShowModal;

end;

procedure TFCadastroProduto.btnEditarClick(Sender: TObject);
begin
  DataModule1.TProduto.Filtered:= false;
  DataModule1.TProduto.Edit;
  FEdicaoProduto := TFEdicaoProduto.Create(Self);
  FEdicaoProduto.lblTituloJanela.Caption:='Editar'+#13#10+ 'Produto';
  FEdicaoProduto.Caption:='Editar Produto';
  FEdicaoProduto.ShowModal;
end;

procedure TFCadastroProduto.btnExcluirClick(Sender: TObject);
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
      DataModule1.TProduto.Delete;
      DataModule1.TProduto.ApplyUpdates
finally
 Free ;
end;
  Espelho_TProduto.Close;
  Espelho_TProduto.Open;
  EditBusca.Clear;
end;

procedure TFCadastroProduto.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.

