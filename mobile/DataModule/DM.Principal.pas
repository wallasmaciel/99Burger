unit DM.Principal;

interface

uses
  System.SysUtils, System.Classes, RESTRequest4D, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.JSON;

type
  TDMPrincipal = class(TDataModule)
    TabProdutos: TFDMemTable;
    TabPedidos: TFDMemTable;
    TabConfig: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FItens: TJSONArray;
    FSubtotal: Double;
    FEntrega: Double;
    FId_usuario: Integer;
  public
    procedure ListarCardapio;
    procedure ListarPedidos;
    procedure CarregarConfig;
    procedure AddProdutoSacola(id_produto, qtd: Integer; nome, url_foto: String;
      vl_unitario, vl_total: Double);
    procedure GerarPedido;

    function DescrStatus(Str: String): String;

    property Itens: TJSONArray read FItens write FItens;
    property Subtotal: Double read FSubtotal write FSubtotal;
    property Entrega: Double read FEntrega write FEntrega;
    property IdUsuario: Integer read FId_usuario write FId_usuario;
  end;

var
  DMPrincipal: TDMPrincipal;

const
  URL_BASE = 'http://localhost:3000';

implementation

uses uFunctions;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDMPrincipal.DataModuleCreate(Sender: TObject);
begin
  FItens := TJSONArray.Create;
end;

procedure TDMPrincipal.DataModuleDestroy(Sender: TObject);
begin
  FItens.DisposeOf;
end;

function TDMPrincipal.DescrStatus(Str: String): String;
begin
  if Str = 'A' then
    Result := 'Aguardando'
  else if Str = 'P' then
    Result := 'Pedido em produção'
  else if Str = 'E' then
    Result := 'Saiu para entrega'
  else
    Result := '';
end;

procedure TDMPrincipal.ListarCardapio;
var
  Resp: IResponse;
begin
  TabProdutos.FieldDefs.Clear;

  Resp := TRequest.New.BaseURL(URL_BASE)
    .Resource('produtos/cardapio')
      .Accept('application/json')
      .Get;
    //
    if Resp.StatusCode = 200 then
      JsonToDataset(TabProdutos, Resp.Content)
    else
      raise Exception.Create('Erro ao carregar produtos: ' + Resp.Content);
end;

procedure TDMPrincipal.ListarPedidos;
var
  Resp: IResponse;
begin
  TabPedidos.FieldDefs.Clear;

  Resp := TRequest.New.BaseURL(URL_BASE)
    .Resource('pedidos')
      .Accept('application/json')
      .Get;
    //
    if Resp.StatusCode = 200 then
      JsonToDataset(TabPedidos, Resp.Content)
    else
      raise Exception.Create('Erro ao carregar pedidos: ' + Resp.Content);
end;

procedure TDMPrincipal.CarregarConfig;
var
  Resp: IResponse;
begin
  TabConfig.FieldDefs.Clear;

  Resp := TRequest.New.BaseURL(URL_BASE)
    // Rota
    .Resource('configs')
      .Accept('application/json')
      .Get;
    //
    if Resp.StatusCode = 200 then
    begin
      JsonToDataset(TabConfig, Resp.Content);
      Entrega :=  StrToFloat((TabConfig.FieldByName('vl_entrega').AsString).Replace('.', ','));
    end
    else
      raise Exception.Create('Erro ao carregar configurações: ' + Resp.Content); 
end;

procedure TDMPrincipal.AddProdutoSacola(id_produto, qtd: Integer; nome, url_foto: String;
  vl_unitario, vl_total: Double);
var
  Item: TJSONObject;
begin
  Item := TJSONObject.Create;
  item.AddPair('id_produto', TJSONNumber.Create(id_produto));
  item.AddPair('nome', nome);
  item.AddPair('qtd', TJSONNumber.Create(qtd));
  item.AddPair('vl_unitario', TJSONNumber.Create(vl_unitario));
  item.AddPair('vl_total', TJSONNumber.Create(vl_total));
  item.AddPair('url_foto', url_foto);

  Itens.Add(Item);
end;

procedure TDMPrincipal.GerarPedido;
var
  Resp: IResponse;
  Json: TJSONObject;
begin
  try
    json := TJSONObject.Create;
    json.AddPair('id_usuario', TJSONNumber.Create(IdUsuario));
    json.AddPair('vl_subtotal', TJSONNumber.Create(Subtotal));
    json.AddPair('vl_entrega', TJSONNumber.Create(Entrega));
    json.AddPair('vl_total', TJSONNumber.Create(Entrega + Subtotal));
    json.AddPair('itens', Itens);

    Resp := TRequest.New.BaseURL(URL_BASE)
      .Resource('pedidos')
      .Accept('application/json')
      .AddBody(Json.ToJSON)
      .Post;

    if Resp.StatusCode = 201 then
    begin
        Entrega := 0;
        Subtotal := 0;
        Itens := TJSONArray.Create;
    end
    else
      raise Exception.Create('Erro ao carregar pedidos: ' + Resp.Content);
  finally
    Json.DisposeOf;
  end;
end;

end.
