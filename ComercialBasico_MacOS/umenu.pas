unit UMenu;


interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, Buttons, lclintf, ZDataset, ZConnection;

type

  { TFMenu }

  TFMenu = class(TForm)
    btnCadastrarFornecedor: TSpeedButton;
    btnCadastroClientes: TSpeedButton;
    btnIA: TSpeedButton;
    btnCadastroProdutos: TSpeedButton;
    btnConsultaVendas: TSpeedButton;
    btnContasAReceber: TSpeedButton;
    btnFechar: TSpeedButton;
    btnOSS: TSpeedButton;
    btnPDV: TSpeedButton;
    panelBase: TPanel;
    panelCentroBtnDir: TPanel;
    panelCentroBtnDir1: TPanel;
    panelCentroBtnDir2: TPanel;
    panelCentroBtnEsq: TPanel;
    panelCentroBtnEsq1: TPanel;
    panelCentroCentroLinha: TPanel;
    panelCentroCentroLinha1: TPanel;
    panelCentroLinha01: TPanel;
    panelCentroLinha4: TPanel;
    panelCentroLinha5: TPanel;
    panelCentroPaiLinhas: TPanel;
    panelCentroTop: TPanel;
    panelCentroPai: TPanel;
    panelEsq: TPanel;
    QUltimaChaveVendaADD: TLargeintField;
    QUltimaChaveVendaFalha: TZQuery;
    QUltimaChaveVendaFalhaADD: TLongintField;
    QUltimaChaveVenda: TSQLQuery;
    procedure btnCadastrarFornecedorClick(Sender: TObject);
    procedure btnCadastroClientesClick(Sender: TObject);
    procedure btnCadastroProdutosClick(Sender: TObject);
    procedure btnConsultaVendasClick(Sender: TObject);
    procedure btnContasAReceberClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnIAClick(Sender: TObject);
    procedure btnOSSClick(Sender: TObject);
    procedure btnPDVClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    function ValidaFormJaCriado(const TForm: TClass): Boolean;


  private

  public
    resetPDV, resetou: Boolean;
    usarCodigoBarras: Boolean;


  end;

var
  FMenu: TFMenu;

implementation

uses ucadastrocliente, udatamodule1, uPDV, ucadastroproduto, uConsultaVendas, ucadastrofornecedores, uContasAReceber;

{$R *.lfm}

{ TFMenu }

procedure TFMenu.MenuItem2Click(Sender: TObject);
begin
   FCadastroCliente := TFCadastroCliente.Create(Self);
   FCadastroCliente.ShowModal;
end;

procedure TFMenu.MenuItem3Click(Sender: TObject);
begin
  FCadastroProduto := TFCadastroProduto.Create(Self);
  FCadastroProduto.ShowModal;
end;

function TFMenu.ValidaFormJaCriado(const TForm: TClass): Boolean;
begin

end;

procedure TFMenu.btnCadastroClientesClick(Sender: TObject);
begin
   FCadastroCliente := TFCadastroCliente.Create(Self);
   FCadastroCliente.ShowModal;
end;

procedure TFMenu.btnCadastrarFornecedorClick(Sender: TObject);
begin

   FCadastroFornecedores := TFCadastroFornecedores.Create(Self);
   FCadastroFornecedores.ShowModal
end;

procedure TFMenu.btnCadastroProdutosClick(Sender: TObject);
begin
  FCadastroProduto := TFCadastroProduto.Create(Self);
  FCadastroProduto.ShowModal;
end;

procedure TFMenu.btnConsultaVendasClick(Sender: TObject);
begin
    FConsultaVendas := TFConsultaVendas.Create(Self);
    FConsultaVendas.ShowModal;

end;

procedure TFMenu.btnContasAReceberClick(Sender: TObject);
begin
  FContasAReceber := TFContasAReceber.Create(Self);
  FContasAReceber.ShowModal;
end;

procedure TFMenu.btnFecharClick(Sender: TObject);
begin
    Close;
    Application.Terminate;
end;

procedure TFMenu.btnIAClick(Sender: TObject);
begin

  OpenURL('https://www.ia.seg.br');

end;

procedure TFMenu.btnOSSClick(Sender: TObject);
begin

  OpenURL('https://opensource.org/');



end;

procedure TFMenu.btnPDVClick(Sender: TObject);
begin



   if FPDV = nil then
    begin
        try
        //ShowMessage('pdv nill');
        FPDV := TFPDV.Create(nil);
        FPDV.ShowModal;
        FreeAndNil(FPDV);
        except
        FPDV.Release;
        end;
    end
    else
    begin


          FMenu.Enabled := False;
          try

            FPDV.Close;
            FPDV := TFPDV.Create(nil);
            FPDV.ShowModal;

            FPDV.BringToFront;
          finally
            FMenu.Enabled := True;
          end;

    end;


end;

procedure TFMenu.FormActivate(Sender: TObject);
begin

end;

procedure TFMenu.FormCreate(Sender: TObject);
begin


  CurrencyString:= 'R$';
  CurrencyFormat:= 2;
  DecimalSeparator:= ',';
  ThousandSeparator:= '.';

  DateSeparator:= '/';
  ShortDateFormat:= 'dd/mm/yyy';
  LongDateFormat:= 'dddd, dd "de" mmmm "de" yyy';


  usarCodigoBarras:= True;

  DataModule1.TCliente.Open;
  DataModule1.TProduto.Open;

  DataModule1.TContaAReceber.Open;
  DataModule1.TFornecedores.Open;


end;

procedure TFMenu.FormShow(Sender: TObject);
begin
       if (resetou = True) then
          begin


              FPDV.Hide;

              btnPDV.Click;


          end



  end;


end.

