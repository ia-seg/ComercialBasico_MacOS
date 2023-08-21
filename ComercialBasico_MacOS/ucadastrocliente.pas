unit ucadastrocliente;



interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  DBGrids, StdCtrls, Buttons, ZDataset;

type

  { TFCadastroCliente }

  TFCadastroCliente = class(TForm)
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnFechar: TSpeedButton;
    btnInserir: TSpeedButton;
    btnVisualizar: TSpeedButton;
    DBGrid1: TDBGrid;
    EditBusca: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    QUltimaChaveClienteADD: TLargeintField;
    QUltimaChaveCliente: TSQLQuery;
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure EditBuscaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public

  end;

var
  FCadastroCliente: TFCadastroCliente;

implementation

uses udatamodule1, uedicaocliente, udadoscliente, UMenu;

{$R *.lfm}

{ TFCadastroCliente }

procedure TFCadastroCliente.btnInserirClick(Sender: TObject);
begin
  DataModule1.TCliente.Filtered:= false;
  QUltimaChaveCliente.Close;
  QUltimaChaveCliente.Open;
  DataModule1.TCliente.Insert;
  DataModule1.TClienteCHAVE.Value:= QUltimaChaveClienteADD.Value;
  FEdicaoCliente := TFEdicaoCliente.Create(Self);
  FEdicaoCliente.ShowModal;
end;

procedure TFCadastroCliente.btnVisualizarClick(Sender: TObject);
begin
  DataModule1.TCliente.Filtered:= false;
  DataModule1.TCliente.Edit;
  FDadosCliente := TFDadosCliente.Create(Self);
  FDadosCliente.ShowModal;
end;

procedure TFCadastroCliente.EditBuscaChange(Sender: TObject);
begin
  DataModule1.TCliente.Filter:= 'NOME = ' +QuotedStr('*'+EditBusca.Text+'*');
  DataModule1.TCliente.Filtered:= true;
end;

procedure TFCadastroCliente.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin


  try
    DataModule1.TCliente.ApplyUpdates;
    DataModule1.GeralSQLTransaction.CommitRetaining;
  except
     DataModule1.TCliente.CancelUpdates;
     DataModule1.GeralSQLTransaction.RollbackRetaining;
     DataModule1.TCliente.Refresh;
     ShowMessage('Nao foi possivel salvar as alteracoes!');
  end;
  FMenu.Show;
end;

procedure TFCadastroCliente.FormShow(Sender: TObject);
begin
  FMenu.Hide;
  EditBusca.SetFocus;
end;

procedure TFCadastroCliente.Image1Click(Sender: TObject);
var f : TForm;
begin

   f := CreateMessageDialog('Comercial Básico by IA.seg.br','DICAS'+#13#10+ '01 - Após realizar uma busca - limpe o campo para voltar a exibir toda a listagem'+#13#10+ '02 - Ao buscar - digite o nome como ele foi cadastrado'+#13#10+ '03 - A opção “Visualizar” permite apenas ver todos os dados cadastrados '+#13#10+ '04 - Para alterar dados use a opção “Editar” '+#13#10+ '05 - Antes de usar a opção “Excluir” selecione um ítem na lista ou faça uma busca'+#13#10+ '06 - Ao cadastrar - faça com critério - padronize procedimentos'+#13#10+ '07 -  Manter os dados organizados é fundamental para bons resultados ', mtInformation, [mbOK]);
   f.Position := poOwnerFormCenter;
   f.ShowModal;

end;

procedure TFCadastroCliente.btnEditarClick(Sender: TObject);
begin
  DataModule1.TCliente.Filtered:= false;
  DataModule1.TCliente.Edit;
  FEdicaoCliente := TFEdicaoCliente.Create(Self);
  FEdicaoCliente.Caption:='Editar dados do Cliente';
  FEdicaoCliente.lblTituloJanela.Caption:=' Editar ' +#13#10+ ' dados do Cliente';
  FEdicaoCliente.ShowModal;
end;

procedure TFCadastroCliente.btnExcluirClick(Sender: TObject);
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
          DataModule1.TCliente.Delete;
          DataModule1.TCliente.ApplyUpdates;
    finally
     Free ;
    end

end;

procedure TFCadastroCliente.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.

