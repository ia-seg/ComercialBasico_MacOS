unit uConsultaVendas;



interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons, DBGrids, ZDataset,
  DateTimePicker;

type

  { TFConsultaVendas }

  TFConsultaVendas = class(TForm)
    Bevel1: TBevel;
    btnBuscar: TSpeedButton;
    btnCancelar: TSpeedButton;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    pnlTextos: TPanel;
    txtValorTotalListado: TLabel;
    txtHojeListado: TLabel;
    txtValorTotalParcelado: TLabel;
    procedure btnBuscarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure DateTimePicker1Click(Sender: TObject);
    procedure DateTimePicker2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FConsultaVendas: TFConsultaVendas;
  valor_total_listado: Double;
  escolheuData: Boolean;

implementation

uses udatamodule1, UMenu;

{$R *.lfm}

{ TFConsultaVendas }

procedure TFConsultaVendas.btnBuscarClick(Sender: TObject);
var
  valorparcelado, pagoHoje, vistaTotal, totalParcelado:Double;
  quantiParcelas: Integer;
  inicio, fim: String;
begin

    
  DataModule1.TVenda.Open;
  DataModule1.TVenda.Close;


  inicio := DateTimeToStr(DateTimePicker1.Date);
  fim:= DateTimeToStr(DateTimePicker2.Date);

  DataModule1.TVenda.SQL.Text := 'SELECT * FROM VENDAS  where DATA >= :PINICIO AND DATA <= :PFIM';
  DataModule1.TVenda.ParamByName('PINICIO').AsString := inicio ;
  DataModule1.TVenda.ParamByName('PFIM').AsString := fim;

  DataModule1.TVenda.Open;



  valor_total_listado := 0;

  DataModule1.TVenda.First;

  while not(DataModule1.TVenda.EOF) do
  begin
    vistaTotal:= DataModule1.TVendaVALOR_TOTAL.Value ;
    quantiParcelas:= DataModule1.TVendaQUANTIDADE_PARCELAS.Value;

    pagoHoje := DataModule1.TVendaVALOR_PAGO_ENTRADA.Value;
    if quantiParcelas > 0 then
    begin
           valorparcelado := (DataModule1.TVendaVALOR_TOTAL.Value - DataModule1.TVendaVALOR_PAGO_ENTRADA.Value);
           totalParcelado:= totalParcelado + valorparcelado;
           valor_total_listado:= valor_total_listado + vistaTotal - valorparcelado;
    end
    else begin
           valor_total_listado:= valor_total_listado + vistaTotal;
    end;

    DataModule1.TVenda.Next;

  end;
  txtValorTotalListado.Caption:= 'Valor total deste período: ' + FormatFloat('R$ ###,###,##0.00', valor_total_listado);
  txtValorTotalParcelado.Caption:= 'Valor financiado à receber: ' + FormatFloat('R$ ###,###,##0.00', totalParcelado) ;
  if escolheuData = true then
  begin
       txtHojeListado.Visible:= False;
  end
  else
  begin
       txtHojeListado.Visible:= True;
  end;


  if escolheuData = True  then
  begin
      Bevel1.Height:= 80;
  end
  Else
  begin

       Bevel1.Height:= 112;

  end;

end;

procedure TFConsultaVendas.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFConsultaVendas.DateTimePicker1Click(Sender: TObject);
begin
    escolheuData:=True;
end;

procedure TFConsultaVendas.DateTimePicker2Change(Sender: TObject);
begin
  escolheuData:=True;
end;

procedure TFConsultaVendas.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DataModule1.TVenda.Filtered:= False;
      escolheuData:=False;
  FMenu.Show;

end;

procedure TFConsultaVendas.FormShow(Sender: TObject);
begin

  DateTimePicker1.SetFocus;
  DateTimePicker1.Date := Now;
  DateTimePicker2.Date := Now;
  btnBuscar.Click;
  txtValorTotalListado.Caption:= 'Consulte o valor total das vendas por período';
  txtHojeListado.Caption:='Hoje temos o movimento total: ' + FormatFloat('R$ ###,###,##0.00', valor_total_listado);
  txtHojeListado.Font.Color:= $00BDE089;

  escolheuData:=False;
  FMenu.Hide;
  btnBuscar.Click;
end;

end.

