unit uedicaofornecedores;


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  DBCtrls, ExtCtrls;

type

  { TFEdicaoFornecedores }

  TFEdicaoFornecedores = class(TForm)

     btnCancelar: TSpeedButton;
    btnSalvar: TSpeedButton;
    DBComboBox2: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBMemo1: TDBMemo;
    DBRadioGroup1: TDBRadioGroup;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
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
    DBEdit3: TDBEdit;
    DBSiteCadFornecedores: TDBEdit;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FEdicaoFornecedores: TFEdicaoFornecedores;

implementation

uses
  ucadastrofornecedores, udatamodule1;

{$R *.lfm}

{ TFEdicaoFornecedores }

procedure TFEdicaoFornecedores.btnCancelarClick(Sender: TObject);
begin

  DataModule1.TFornecedores.Cancel;
  btnCancelar.Enabled:= False;
  Close;
end;

procedure TFEdicaoFornecedores.btnSalvarClick(Sender: TObject);
begin

  DataModule1.TFornecedores.Post;
  DataModule1.TFornecedores.ApplyUpdates;
  btnCancelar.Enabled:= False;
  Close;
end;


procedure TFEdicaoFornecedores.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  if(btnCancelar.Enabled) then
  DataModule1.TFornecedores.Cancel;
  FCadastroFornecedores.Show;
end;

procedure TFEdicaoFornecedores.FormShow(Sender: TObject);
begin

  FCadastroFornecedores.Hide;
end;

end.

