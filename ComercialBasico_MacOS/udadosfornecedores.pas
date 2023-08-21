unit udadosfornecedores;



interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBCtrls, udadoscliente;

type

  { TFDadosFornecedores }

  TFDadosFornecedores = class(TFDadosCliente)

    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit26: TDBEdit;
    DBEdit27: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEditFornecedorRazaosocial: TDBEdit;
    DBMemo2: TDBMemo;
    DBRadioGroup2: TDBRadioGroup;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FDadosFornecedores: TFDadosFornecedores;

implementation

uses
  ucadastrofornecedores, udatamodule1;

{$R *.lfm}

{ TFDadosFornecedores }

procedure TFDadosFornecedores.btnCancelarClick(Sender: TObject);
begin


  DataModule1.TFornecedores.Cancel;
  btnCancelar.Enabled:= False;
  Close;

end;

procedure TFDadosFornecedores.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin


  if(btnCancelar.Enabled) then
  DataModule1.TFornecedores.Cancel;
  FCadastroFornecedores.Show;

end;

procedure TFDadosFornecedores.FormShow(Sender: TObject);
begin

    FCadastroFornecedores.Hide;
end;

end.

