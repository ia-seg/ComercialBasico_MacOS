unit udadoscliente;



interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, uedicaocliente;

type

  { TFDadosCliente }

  TFDadosCliente = class(TFEdicaoCliente)
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FDadosCliente: TFDadosCliente;

implementation

uses
  ucadastrocliente;

{$R *.lfm}

{ TFDadosCliente }

procedure TFDadosCliente.FormShow(Sender: TObject);
begin
  FCadastroCliente.Hide;
end;

end.

