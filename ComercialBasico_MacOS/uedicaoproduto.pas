unit uEdicaoProduto;



interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, ComboEx;

type

  { TFEdicaoProduto }

  TFEdicaoProduto = class(TForm)

    btnCancelar: TSpeedButton;
    btnSalvar: TSpeedButton;
    CBUnidade: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBMemoProduto: TDBMemo;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblTituloJanela: TLabel;
    Panel1: TPanel;
    pnlFoto: TPanel;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure DBEdit5Exit(Sender: TObject);
    procedure DBEdit5KeyPress(Sender: TObject; var Key: char);
    procedure DBEdit6KeyPress(Sender: TObject; var Key: char);
    procedure DBLookupListBox1Click(Sender: TObject);


    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public

  end;

var
  FEdicaoProduto: TFEdicaoProduto;

implementation

uses udatamodule1, ucadastroproduto;

{$R *.lfm}

{ TFEdicaoProduto }

procedure TFEdicaoProduto.btnSalvarClick(Sender: TObject);
begin
  DataModule1.TProduto.Post;
  DataModule1.TProduto.ApplyUpdates;
  btnCancelar.Enabled := False;

  try
    DataModule1.TProduto.ApplyUpdates;
    DataModule1.GeralSQLTransaction.CommitRetaining;
  except
     DataModule1.TProduto.CancelUpdates;
     DataModule1.GeralSQLTransaction.RollbackRetaining;
     DataModule1.TProduto.Refresh;
     ShowMessage('Nao foi possivel salvar as alteracoes!');
  end;



  Close;
end;

procedure TFEdicaoProduto.DBEdit5Exit(Sender: TObject);
begin

end;

procedure TFEdicaoProduto.DBEdit5KeyPress(Sender: TObject; var Key: char);
begin
    if not (Key in ['0'..'9', ',', #8, #9]) then Key := #0;
end;

procedure TFEdicaoProduto.DBEdit6KeyPress(Sender: TObject; var Key: char);
begin
        if not (Key in ['0'..'9', ',', #8, #9]) then Key := #0;
end;


procedure TFEdicaoProduto.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  if(btnCancelar.Enabled) then
  DataModule1.TProduto.Cancel;


  FCadastroProduto.EditBusca.Clear;

  FCadastroProduto.Show;
end;

procedure TFEdicaoProduto.FormShow(Sender: TObject);
begin
  FCadastroProduto.Hide;

end;

procedure TFEdicaoProduto.Image1Click(Sender: TObject);
var f : TForm;
begin

   f := CreateMessageDialog('Comercial Básico by IA.seg.br','DICAS'+#13#10+ '01 - Use a tecla TAB para navegar'+#13#10+ '02 - Use vírgula para separar centavos'+#13#10+ '03 - Lembre-se de selecionar o Fornecedor na listagem'+#13#10+ '04 - Caso necessite, insira Unidade personalizada para o produto'+#13#10+ '05 - O campo “Código de Barras” não é obrigatório'+#13#10+ '06 - Cadastrar “Código de Barras” agiliza a venda usando um leitor', mtInformation, [mbOK]);
   f.Position := poOwnerFormCenter;
   f.ShowModal;
end;

procedure TFEdicaoProduto.btnCancelarClick(Sender: TObject);
begin
  DataModule1.TProduto.Cancel;
  btnCancelar.Enabled := False;
  Close;
end;

end.

