unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TabControl, FMX.Objects, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, uLoading;

type
  TFrmPrincipal = class(TForm)
    rectToolbar: TRectangle;
    Image1: TImage;
    imgSacola: TImage;
    rectAbas: TRectangle;
    imgAba1: TImage;
    imgAba2: TImage;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    lvCardapio: TListView;
    lvPedido: TListView;
    lytDetalhesProd: TLayout;
    rectDetalheProd: TRectangle;
    rectFundo: TRectangle;
    imgFoto: TImage;
    Layout1: TLayout;
    lblDescricao: TLabel;
    recRodape: TRectangle;
    Layout2: TLayout;
    imgMenos: TImage;
    lblQtd: TLabel;
    imgMais: TImage;
    rectAdicionar: TRectangle;
    lblTotal: TLabel;
    imgFecharDetalhe: TImage;
    lblNome: TLabel;
    lblValor: TLabel;
    procedure FormShow(Sender: TObject);
    procedure lvCardapioUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgAba1Click(Sender: TObject);
    procedure lvCardapioItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure imgFecharDetalheClick(Sender: TObject);
    procedure imgCalcClick(Sender: TObject);
    procedure rectAdicionarClick(Sender: TObject);
    procedure imgSacolaClick(Sender: TObject);
  private
    procedure AddCategoria(ACategoria: String);
    procedure AddProduto(id_produto: Integer; nome, descricao, url_foto: String;
      valor: double);
    procedure AddPedido(id_pedido, qtd_item: Integer; dt_pedido, status: String;
      valor: Double);
    procedure ListarProdutos;
    procedure ThreadProdutosTerminate(Sender: TObject);
    procedure MudarAba(Img: TImage);
    procedure ListarPedidos;
    procedure CalculaQtd(ATagValue: Integer);
    procedure CalculaTotal;
    procedure ThreadPedidosTerminate(Sender: TObject);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses DM.Principal, uFunctions, Sacola;

procedure TFrmPrincipal.AddCategoria(ACategoria: String);
begin
  with lvCardapio.Items.Add do
  begin
    // Variavel que controla o elemento não visual
    Tag    := 0;
    Height := 70;

    // Procurar dentro do item desenhado o objeto 'txtTitulo' que é do tipo 'TListItemText'
    TListItemText(Objects.FindDrawable('txtTitulo')).Text := ACategoria;
  end;
end;

procedure TFrmPrincipal.AddProduto(id_produto: Integer; nome, descricao, url_foto: String;
  valor: double);
begin
  with lvCardapio.Items.Add do
  begin
    // Variavel que controla o elemento não visual
    Tag    := id_produto;
    Height := 100;
    //
    TListItemText(Objects.FindDrawable('txtTitulo')).Text     := nome;
    TListItemText(Objects.FindDrawable('txtDescricao')).Text  := descricao;
    TListItemText(Objects.FindDrawable('txtValor')).Text      := FormatFloat('R$ #,##0.00', valor);
    TListItemText(Objects.FindDrawable('txtValor')).TagFloat  := valor;
    TListItemImage(Objects.FindDrawable('imgFoto')).TagString := url_foto;
  end;
end;

procedure TFrmPrincipal.AddPedido(id_pedido, qtd_item: Integer; dt_pedido, status: String;
  valor: Double);
begin
  with lvPedido.Items.Add do
  begin
    // Variavel que controla o elemento não visual
    Tag    := id_pedido;
    Height := 80;
    //
    TListItemText(Objects.FindDrawable('txtPedido')).Text := 'Pedido: '+ id_pedido.ToString;
    TListItemText(Objects.FindDrawable('txtData')).Text   := Copy(dt_pedido, 1, 10) + ' - ' + qtd_item.ToString + ' itens - ' + DMPrincipal.DescrStatus(status);
    TListItemText(Objects.FindDrawable('txtValor')).Text  := FormatFloat('R$ #,##0.00', valor);
  end;
end;

procedure TFrmPrincipal.ThreadProdutosTerminate(Sender: TObject);
begin
  lvCardapio.EndUpdate;
  TLoading.Hide;

  // Verificar se houve alguma fatal excpetion na 'Thread'
  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
      ShowMessage(Exception(TThread(Sender).FatalException).Message);
      Exit;
    end;
  end;

  // Carregar foto do protudo
  DownloadFoto(lvCardapio, 'imgFoto');
end;

procedure TFrmPrincipal.ThreadPedidosTerminate(Sender: TObject);
begin
  lvPedido.EndUpdate;
  TLoading.Hide;

  // Verificar se houve alguma fatal excpetion na 'Thread'
  if Sender is TThread then
  begin
    if Assigned(TThread(Sender).FatalException) then
    begin
      ShowMessage(Exception(TThread(Sender).FatalException).Message);
      Exit;
    end;
  end;
end;

procedure TFrmPrincipal.ListarProdutos;
var
  t: TThread;
  Categoria, CategoriaAnterior: String;
begin
  // Inicializar variaveis
  Categoria := '';
  CategoriaAnterior := '';

  // Limpar a TListView
  lvCardapio.Items.Clear;
  // Iniciar atualização do TListView
  lvCardapio.BeginUpdate;

  // Loading...
  TLoading.Show(FrmPrincipal, '');

  // Criação da Thread de carregamento dos produtos
  t := TThread.CreateAnonymousThread(procedure
    begin
      DMPrincipal.ListarCardapio;
      // Usar dataset
      with DMPrincipal.TabProdutos do
      begin
        while not Eof do
        begin
          Categoria := FieldByName('categoria').AsString;
          // Se não for igual a categoria anterior adicionar como nova categoria
          if Categoria <> CategoriaAnterior then
            Self.AddCategoria(Categoria);

          // Inserir produtos
          Self.AddProduto(
            FieldByName('id_produto').AsInteger,
            FieldByName('nome').AsString,
            FieldByName('descricao').AsString,
            FieldByName('url_foto').AsString,
            StrToFloat((FieldByName('preco').AsString).Replace('.', ','))
          );

          // Atualizar categoria com a current
          CategoriaAnterior := Categoria;
          // Saltar para o proximo registro
          Next;
        end;
      end;
    end
  );

  t.OnTerminate := ThreadProdutosTerminate;
  t.Start;
end;

procedure TFrmPrincipal.ListarPedidos;
var
  t: TThread;
begin
  // Limpar a TListView
  lvPedido.Items.Clear;
  // Iniciar atualização do TListView
  lvPedido.BeginUpdate;

  // Loading...
  TLoading.Show(FrmPrincipal, 'Carregar pedidos...');

  // Criação da Thread de carregamento dos produtos
  t := TThread.CreateAnonymousThread(procedure
    begin
      Sleep(5000);

      DMPrincipal.ListarPedidos;
      // Usar dataset
      with DMPrincipal.TabPedidos do
      begin
        while not Eof do
        begin
          // Inserir produtos
          Self.AddPedido(
            FieldByName('id_pedido').AsInteger,
            FieldByName('qtd_item').AsInteger,
            FieldByName('dt_pedido').AsString,
            FieldByName('status').AsString,
            StrToFloat((FieldByName('vl_total').AsString).Replace('.', ','))
          );

          // Saltar para o proximo registro
          Next;
        end;
      end;
    end
  );

  t.OnTerminate := ThreadPedidosTerminate;
  t.Start;
end;

procedure TFrmPrincipal.lvCardapioItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  imgFoto.TagString := TListItemImage(AItem.Objects.FindDrawable('imgFoto')).TagString;
  imgFoto.Bitmap    := TListItemImage(AItem.Objects.FindDrawable('imgFoto')).Bitmap;
  imgFoto.Tag       := AItem.Tag;
  //
  lblNome.Text      := TListItemText(AItem.Objects.FindDrawable('txtTitulo')).Text;
  lblDescricao.Text := TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Text;
  lblValor.Text     := TListItemText(AItem.Objects.FindDrawable('txtValor')).Text;
  lblValor.TagFloat := TListItemText(AItem.Objects.FindDrawable('txtValor')).TagFloat;
  //
  CalculaQtd(0);
  CalculaTotal;
  //
  lytDetalhesProd.Visible := True;
end;

procedure TFrmPrincipal.lvCardapioUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // Categoria
  if AItem.Tag = 0 then
  begin
    TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Visible := False;
    TListItemText(AItem.Objects.FindDrawable('txtValor')).Visible := False;
    TListItemImage(AItem.Objects.FindDrawable('imgFoto')).Visible := False;

    TListItemText(AItem.Objects.FindDrawable('txtTitulo')).PlaceOffset.X := 5;
    TListItemText(AItem.Objects.FindDrawable('txtTitulo')).PlaceOffset.Y := 30;
    TListItemText(AItem.Objects.FindDrawable('txtTitulo')).Font.Size := 22;
  end
  else
  begin
    TListItemText(AItem.Objects.FindDrawable('txtTitulo')).PlaceOffset.X := 96;
    TListItemText(AItem.Objects.FindDrawable('txtTitulo')).PlaceOffset.Y := 11;
    TListItemText(AItem.Objects.FindDrawable('txtTitulo')).Font.Size := 20;
  end;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  DMPrincipal.CarregarConfig;
  DMPrincipal.IdUsuario := 1; // Viria do login
  Self.ListarProdutos;
end;

procedure TFrmPrincipal.MudarAba(Img: TImage);
begin
  // Efeito de item selecionado nos botoes inferiores
  imgAba1.Opacity := 0.4;
  imgAba2.Opacity := 0.4;
  //
  Img.Opacity := 1;

  // Carregar aba que a Tag de TImage se referencia
  TabControl1.GotoVisibleTab(Img.Tag);

  // Aba de pedidos
  if img.Tag = 1 then
    ListarPedidos;
end;

procedure TFrmPrincipal.rectAdicionarClick(Sender: TObject);
begin
  try
    DMPrincipal.AddProdutoSacola(
      // Identificador do produto
      imgFoto.Tag,
      // Quantidade
      lblQtd.Tag,
      // Nome do produto
      lblNome.Text,
      // Url da foto
      imgFoto.TagString,
      // Valor unitario
      lblValor.TagFloat,
      // Valor total
      lblValor.TagFloat * lblQtd.Tag
    );
    //
    lytDetalhesProd.Visible := False;
  except
    on E: Exception do
      ShowMessage('Erro ao inserir produto: ' + E.Message);
  end;
end;

procedure TFrmPrincipal.imgAba1Click(Sender: TObject);
begin
  Self.MudarAba(TImage(Sender));
end;

procedure TFrmPrincipal.imgFecharDetalheClick(Sender: TObject);
begin
  lytDetalhesProd.Visible := False;
end;

procedure TFrmPrincipal.imgSacolaClick(Sender: TObject);
begin
  if not Assigned(FrmSacola) then
    Application.CreateForm(TFrmSacola, FrmSacola);
  //
  FrmSacola.Show;
end;

procedure TFrmPrincipal.CalculaQtd(ATagValue: Integer);
begin
  try
    if ATagValue = 0 then
      lblQtd.Tag := 0
    else
      lblQtd.Tag := lblQtd.Tag + ATagValue;

    //
    if lblQtd.Tag = 0 then
      lblQtd.Tag := 1;

    lblQtd.Text := lblQtd.Tag.ToString
  except
    on E: Exception do
    begin
      lblQtd.Text := '1';
      lblQtd.Tag := 1;
    end;
  end;
end;

procedure TFrmPrincipal.CalculaTotal;
begin
  try
    lblTotal.Text := 'Adicionar ' + FormatFloat('R$ #,##0.00', lblValor.TagFloat * lblQtd.Tag);
  except
    on E: Exception do
      lblTotal.Text := 'Adicionar 0,00';
  end;
end;

procedure TFrmPrincipal.imgCalcClick(Sender: TObject);
begin
  CalculaQtd(TImage(Sender).Tag);
  CalculaTotal;
end;

end.
