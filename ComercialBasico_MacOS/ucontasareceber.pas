unit uContasAReceber;


interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons, DBGrids, Menus, ZDataset,
  DateTimePicker;


type

  { TFContasAReceber }

  TFContasAReceber = class(TForm)
    btnBuscar: TSpeedButton;
    btnFechar: TSpeedButton;
    btnRelatorio: TSpeedButton;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    txtValorTotalListado: TLabel;
    procedure btnBuscarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  private

  public
    relatou: Boolean;

  end;

var
  FContasAReceber: TFContasAReceber;

implementation

uses udatamodule1, UMenu, uRelatorioContasAReceber_Mac;

{$R *.lfm}

{ TFContasAReceber }

procedure TFContasAReceber.btnBuscarClick(Sender: TObject);
var
  inicio, fim: String;
  valor_total: Double;

begin


  DataModule1.TContaAReceber.Open;
  DataModule1.TContaAReceber.Close;


  inicio := DateTimeToStr(DateTimePicker1.Date);
  fim:= DateTimeToStr(DateTimePicker2.Date);

  DataModule1.TContaAReceber.SQL.Text := 'SELECT * FROM CONTA_A_RECEBER  where DATA_VENCIMENTO >= :PINICIO AND DATA_VENCIMENTO <= :PFIM';
  DataModule1.TContaAReceber.ParamByName('PINICIO').AsString := inicio ;
  DataModule1.TContaAReceber.ParamByName('PFIM').AsString := fim;

  DataModule1.TContaAReceber.Open;

  if ComboBox1.ItemIndex = 1 then
  begin


    DataModule1.TContaAReceber.Close;

    DataModule1.TContaAReceber.SQL.Add(' AND STATUS = ''PAGO''');

    DataModule1.TContaAReceber.Open;


  end else

    if ComboBox1.ItemIndex = 2 then
  begin
    DataModule1.TContaAReceber.Close;

    DataModule1.TContaAReceber.SQL.Add(' AND STATUS = ''PENDENTE''');

    DataModule1.TContaAReceber.Open;

  end;

  valor_total:= 0;
  DataModule1.TContaAReceber.First;
  while not DataModule1.TContaAReceber.EOF do
  begin
    valor_total:= valor_total + DataModule1.TContaAReceberVALOR.Value;

    DataModule1.TContaAReceber.Next;

  end;
  txtValorTotalListado.Caption:= 'Valor Total Listado: '+FormatFloat('R$ ###,###,##0.00', valor_total);
  if valor_total > 0 then
  begin
      txtValorTotalListado.Visible:= True;
  end;

end;

procedure TFContasAReceber.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFContasAReceber.btnRelatorioClick(Sender: TObject);
begin

  if relatou = True then

  begin
      relatou:= False;

  end
  else
  begin
      FRelatorioContasAReceber_Mac := TFRelatorioContasAReceber_Mac.Create(Self);
  end;


  FRelatorioContasAReceber_Mac.QRelatorio.Close;
  FRelatorioContasAReceber_Mac.QRelatorio.SQL.Clear;
  FRelatorioContasAReceber_Mac.QRelatorio.SQL.Add('SELECT * FROM CONTA_A_RECEBER');
  FRelatorioContasAReceber_Mac.QRelatorio.SQL.Add('WHERE DATA_VENCIMENTO >= :datainicio ');
  FRelatorioContasAReceber_Mac.QRelatorio.SQL.Add('AND DATA_VENCIMENTO <= :datafim ');
  FRelatorioContasAReceber_Mac.QRelatorio.ParamByName('datainicio').AsDate:= DateTimePicker1.Date;
  FRelatorioContasAReceber_Mac.QRelatorio.ParamByName('datafim').AsDate:= DateTimePicker2.Date;
  if ComboBox1.ItemIndex = 1 then
  begin
    FRelatorioContasAReceber_Mac.QRelatorio.SQL.Add(' AND STATUS = :status');
    FRelatorioContasAReceber_Mac.QRelatorio.ParamByName('status').AsString:= 'PAGO';
  end else
    if ComboBox1.ItemIndex = 2 then
  begin
    FRelatorioContasAReceber_Mac.QRelatorio.SQL.Add(' AND STATUS = :status');
    FRelatorioContasAReceber_Mac.QRelatorio.ParamByName('status').AsString:= 'PENDENTE';
  end;
  FRelatorioContasAReceber_Mac.QRelatorio.Open;
  FRelatorioContasAReceber_Mac.ShowModal;

end;

procedure TFContasAReceber.ComboBox1Click(Sender: TObject);
begin
    DataModule1.TContaAReceber.Close;

    DataModule1.TContaAReceber.SQL.Clear;

    DataModule1.TContaAReceber.SQL.Text:= 'SELECT * FROM CONTA_A_RECEBER';

    DataModule1.TContaAReceber.Open;

end;

procedure TFContasAReceber.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DataModule1.TContaAReceber.Filtered:= False; 
  FMenu.Show;
end;

procedure TFContasAReceber.FormCreate(Sender: TObject);
begin
    relatou := False;
end;

procedure TFContasAReceber.FormShow(Sender: TObject);
begin


  DateTimePicker1.SetFocus;
  DateTimePicker1.Date := Now;
  DateTimePicker2.Date := Now;



  FMenu.Hide;
end;

procedure TFContasAReceber.MenuItem1Click(Sender: TObject);
begin

  DataModule1.TContaAReceber.Edit;
  DataModule1.TContaAReceberSTATUS.Value:= 'PAGO';
  DataModule1.TContaAReceber.Post;
  DataModule1.TContaAReceber.ApplyUpdates;

  DataModule1.TContaAReceber.Close;
  DataModule1.TContaAReceber.Open;
end;

procedure TFContasAReceber.MenuItem2Click(Sender: TObject);
begin

  DataModule1.TContaAReceber.Edit;
  DataModule1.TContaAReceberSTATUS.Value:= 'PENDENTE';
  DataModule1.TContaAReceber.Post;
  DataModule1.TContaAReceber.ApplyUpdates;

  DataModule1.TContaAReceber.Close;
  DataModule1.TContaAReceber.Open;
end;

end.

