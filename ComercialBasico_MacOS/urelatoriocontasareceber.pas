unit uRelatorioContasAReceber;


interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ZDataset, RLReport, RLPDFFilter;

type

  { TFRelatorioContasAReceber }

  TFRelatorioContasAReceber = class(TForm)
    DSRelatorio: TDataSource;
    QRelatorioCHAVE: TLongintField;
    QRelatorioCHAVE_CLIENTE: TLongintField;
    QRelatorioCHAVE_VENDA: TLongintField;
    QRelatorioDATA_PAGAMEMTO: TDateField;
    QRelatorioDATA_VENCIMENTO: TDateField;
    QRelatorioFORMA_PAGTO: TStringField;
    QRelatorioSTATUS: TStringField;
    QRelatorioVALOR: TFloatField;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDraw1: TRLDraw;
    RLDraw2: TRLDraw;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLPDFFilter1: TRLPDFFilter;
    txtTotalRelatorio: TRLLabel;
    RLReport1: TRLReport;
    QRelatorio: TZQuery;
    procedure RLBand2BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBand3BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private

  public

  end;

var
  FRelatorioContasAReceber: TFRelatorioContasAReceber;
  valor_total: Double;

implementation

uses uContasAReceber, udatamodule1;

{$R *.lfm}

{ TFRelatorioContasAReceber }

procedure TFRelatorioContasAReceber.RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  valor_total := 0;
end;

procedure TFRelatorioContasAReceber.RLBand2BeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  valor_total:= valor_total + QRelatorioVALOR.Value;
end;

procedure TFRelatorioContasAReceber.RLBand3BeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  txtTotalRelatorio.Caption:= FormatFloat('R$ ###,###,##0.00', valor_total);
end;

end.

