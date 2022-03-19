unit Sacola;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Layouts, uFunctions;

type
  TFrmSacola = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    lblTotal: TLabel;
    Label4: TLabel;
    lblEntrega: TLabel;
    Label6: TLabel;
    lblSubtotal: TLabel;
    lvSacola: TListView;
    procedure FormShow(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure rectAdicionarClick(Sender: TObject);
  private
    procedure ListarSacola;
    procedure AddProduto(id_produto, qtd: Integer; nome, url_foto: String;
      valor_unitario, valor_total: double);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSacola: TFrmSacola;

implementation

{$R *.fmx}

uses DM.Principal;

procedure TFrmSacola.AddProduto(id_produto, qtd: Integer; nome, url_foto: String;
  valor_unitario, valor_total: double);
begin
  with lvSacola.Items.Add do
  begin
    // Variavel que controla o elemento não visual
    Tag    := id_produto;
    Height := 100;
    //
    TListItemText(Objects.FindDrawable('txtNome')).Text       := nome;
    TListItemText(Objects.FindDrawable('txtQtd')).Text        := qtd.ToString + ' x ' + FormatFloat('R$ #,##0.00', valor_unitario);
    TListItemText(Objects.FindDrawable('txtValor')).Text      := FormatFloat('R$ #,##0.00', valor_total);
    TListItemImage(Objects.FindDrawable('imgFoto')).TagString := url_foto;
  end;
end;

procedure TFrmSacola.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmSacola.ListarSacola;
var
  I: Integer;
begin
  lvSacola.Items.Clear;
  lvSacola.BeginUpdate;

  // Zerar o subtotal
  DMPrincipal.Subtotal := 0;
  //
  for I := 0 to Pred(DMPrincipal.Itens.Size) do
  begin
    Self.AddProduto(
      DMPrincipal.Itens[I].GetValue<Integer>('id_produto', 0),
      DMPrincipal.Itens[I].GetValue<Integer>('qtd', 0),
      DMPrincipal.Itens[I].GetValue<String>('nome', ''),
      DMPrincipal.Itens[I].GetValue<String>('url_foto', ''),
      DMPrincipal.Itens[I].GetValue<Double>('vl_unitario', 0),
      DMPrincipal.Itens[I].GetValue<Double>('vl_total', 0)
    );

    //
    DMPrincipal.Subtotal := DMPrincipal.Subtotal +
      DMPrincipal.Itens[I].GetValue<Double>('vl_total', 0);
  end;

  lvSacola.EndUpdate;
  // Carrgear todas as imagens da 'ListView'
  DownloadFoto(lvSacola, 'imgFoto');

  // Atualizar valores
  lblSubtotal.Text := FormatFloat('R$ #,##0.00', DMPrincipal.Subtotal);
  lblEntrega.Text  := FormatFloat('R$ #,##0.00', DMPrincipal.Entrega);
  lblTotal.Text    := FormatFloat('R$ #,##0.00', DMPrincipal.Subtotal + DMPrincipal.Entrega);
end;

procedure TFrmSacola.rectAdicionarClick(Sender: TObject);
begin
  try
    DMPrincipal.GerarPedido;
    Close;
  except
    on E: Exception do
      ShowMessage('Erro ao gerar pedido: ' + E.Message);
  end;
end;

procedure TFrmSacola.FormShow(Sender: TObject);
begin
  ListarSacola;
end;

end.
