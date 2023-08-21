unit uedicaocliente;



interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  DBCtrls, ExtCtrls;

type

  { TFEdicaoCliente }

  TFEdicaoCliente = class(TForm)

    btnCancelar: TSpeedButton;
    btnSalvar: TSpeedButton;
    DBComboBox1: TDBComboBox;
    DBComboBox2: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit5: TDBEdit;
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
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure DBMemo1Change(Sender: TObject);
    procedure DBMemo1Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FEdicaoCliente: TFEdicaoCliente;

implementation

uses udatamodule1, ucadastrocliente;

{$R *.lfm}

{ TFEdicaoCliente }

procedure TFEdicaoCliente.btnSalvarClick(Sender: TObject);
begin
  DataModule1.TCliente.Post;
  DataModule1.TCliente.ApplyUpdates;
  btnCancelar.Enabled:= False;
  Close;
end;

procedure TFEdicaoCliente.DBMemo1Change(Sender: TObject);
begin

end;

procedure TFEdicaoCliente.DBMemo1Exit(Sender: TObject);
begin

end;

procedure TFEdicaoCliente.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if(btnCancelar.Enabled) then
  DataModule1.TCliente.Cancel;
  FCadastroCliente.Show;
end;

procedure TFEdicaoCliente.FormShow(Sender: TObject);
begin
  FCadastroCliente.Hide;
end;

procedure TFEdicaoCliente.btnCancelarClick(Sender: TObject);
begin
  DataModule1.TCliente.Cancel;
  btnCancelar.Enabled:= False;
  Close;
end;

end.

