'''
--> Descrição do Desafio
Replique a modelagem do projeto lógico de banco de dados para o cenário de e-commerce. 
Fique atento as definições de chave primária e estrangeira, assim como as constraints presentes no cenário modelado. 
Perceba que dentro desta modelagem haverá relacionamentos presentes no modelo EER. Sendo assim, consulte como proceder para estes casos. 

Além disso, aplique o mapeamento de modelos aos refinamentos propostos no módulo de modelagem conceitual.
Assim como demonstrado durante o desafio, realize a criação do Script SQL para criação do esquema do banco de dados. 
Posteriormente, realize a persistência de dados para realização de testes. 
Especifique ainda queries mais complexas dos que apresentadas durante a explicação do desafio. Sendo assim, crie queries SQL com as cláusulas abaixo:
* Recuperações simples com SELECT Statement
* Filtros com WHERE Statement
* Crie expressões para gerar atributos derivados
* Defina ordenações dos dados com ORDER BY
* Condições de filtros aos grupos – HAVING Statement
* Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados

--> Diretrizes
* Não há um mínimo de queries a serem realizadas;
* Os tópicos supracitados devem estar presentes nas queries;
* Elabore perguntas que podem ser respondidas pelas consultas;
* As cláusulas podem estar presentes em mais de uma query;

--> Objetivo:
[Relembrando] Aplique o mapeamento para o  cenário:
“Refine o modelo apresentado acrescentando os seguintes pontos”
* Cliente PJ e PF – Uma conta pode ser PJ ou PF, mas não pode ter as duas informações;
* Pagamento – Pode ter cadastrado mais de uma forma de pagamento;
* Entrega – Possui status e código de rastreio;

Algumas das perguntas que podes fazer para embasar as queries SQL:
* Quantos pedidos foram feitos por cada cliente?
* Algum vendedor também é fornecedor?
* Relação de produtos fornecedores e estoques;
* Relação de nomes dos fornecedores e nomes dos produtos.

--------------------------------------------------------------------------------------------------------------

Descrição do Projeto Lógico:

Entidades:

  ClientePF (Cliente Pessoa Física):
    ID (chave primária)
    Nome
    Email
    CPF
    Endereço
    Telefone

  ClientePJ (Cliente Pessoa Jurídica):
    ID (chave primária)
    Razão Social
    Email
    CNPJ
    Endereço
    Telefone

  Vendedor:
    ID (chave primária)
    Nome
    Email
    CPF
    Endereço
    Telefone

  Fornecedor:
    ID (chave primária)
    Nome
    Email
    CNPJ
    Endereço
    Telefone

  Produto:
    ID (chave primária)
    Nome
    Descrição
    Preço
    Estoque (quantidade disponível)

  FormaPagamento:
    ID (chave primária)
    Nome

  Pedido:
    ID (chave primária)
    Data
    ClienteID (chave estrangeira referenciando ClientePF ou ClientePJ)
    VendedorID (chave estrangeira referenciando Vendedor)

Relacionamentos:
  Um Cliente pode fazer muitos Pedidos (relacionamento 1:N entre ClientePF/ClientePJ e Pedido)
  Um Pedido é feito por apenas um Cliente (relacionamento N:1 entre Pedido e ClientePF/ClientePJ)
  Um Vendedor pode fazer muitos Pedidos (relacionamento 1:N entre Vendedor e Pedido)
  Um Pedido possui uma Forma de Pagamento (relacionamento N:1 entre Pedido e FormaPagamento)
  Um Pedido pode ter mais de um Produto (relacionamento N:M entre Pedido e Produto)
  Um Produto pode ser fornecido por vários Fornecedores (relacionamento N:M entre Produto e Fornecedor)
  Um Pedido pode ter uma Entrega (relacionamento 1:1 entre Pedido e Entrega)

Entidade Adicional:

  Entrega:
    PedidoID (chave primária e chave estrangeira referenciando Pedido)
    Status
    CodigoRastreio
'''

''' Script SQL para Criação do Esquema do Banco de Dados: '''

CREATE TABLE ClientePF (
  ID INT PRIMARY KEY,
  Nome VARCHAR(100),
  Email VARCHAR(100),
  CPF VARCHAR(11),
  Endereco VARCHAR(200),
  Telefone VARCHAR(20)
);

CREATE TABLE ClientePJ (
  ID INT PRIMARY KEY,
  RazaoSocial VARCHAR(100),
  Email VARCHAR(100),
  CNPJ VARCHAR(14),
  Endereco VARCHAR(200),
  Telefone VARCHAR(20)
);

CREATE TABLE Vendedor (
  ID INT PRIMARY KEY,
  Nome VARCHAR(100),
  Email VARCHAR(100),
  CPF VARCHAR(11),
  Endereco VARCHAR(200),
  Telefone VARCHAR(20)
);

CREATE TABLE Fornecedor (
  ID INT PRIMARY KEY,
  Nome VARCHAR(100),
  Email VARCHAR(100),
  CNPJ VARCHAR(14),
  Endereco VARCHAR(200),
  Telefone VARCHAR(20)
);

CREATE TABLE Produto (
  ID INT PRIMARY KEY,
  Nome VARCHAR(100),
  Descricao VARCHAR(200),
  Preco DECIMAL(10,2),
  Estoque INT
);

CREATE TABLE FormaPagamento (
  ID INT PRIMARY KEY,
  Nome VARCHAR(100)
);

CREATE TABLE Pedido (
  ID INT PRIMARY KEY,
  Data DATE,
  ClienteID INT,
  VendedorID INT,
  FormaPagamentoID INT,
  FOREIGN KEY (ClienteID) REFERENCES ClientePF(ID) ON DELETE CASCADE,
  FOREIGN KEY (ClienteID) REFERENCES ClientePJ(ID) ON DELETE CASCADE,
  FOREIGN KEY (VendedorID) REFERENCES Vendedor(ID),
  FOREIGN KEY (FormaPagamentoID) REFERENCES FormaPagamento(ID)
);

CREATE TABLE ProdutoFornecedor (
  ProdutoID INT,
  FornecedorID INT,
  PRIMARY KEY (ProdutoID, FornecedorID),
  FOREIGN KEY (ProdutoID) REFERENCES Produto(ID),
  FOREIGN KEY (FornecedorID) REFERENCES Fornecedor(ID)
);

CREATE TABLE Entrega (
  PedidoID INT PRIMARY KEY,
  Status VARCHAR(100),
  CodigoRastreio VARCHAR(100),
  FOREIGN KEY (PedidoID) REFERENCES Pedido(ID)
);

''' Quantos pedidos foram feitos por cada cliente? '''

SELECT 
  CASE
    WHEN ClientePF.ID IS NOT NULL THEN ClientePF.Nome
    WHEN ClientePJ.ID IS NOT NULL THEN ClientePJ.RazaoSocial
  END AS Cliente,
  COUNT(*) AS TotalPedidos
FROM Pedido
LEFT JOIN ClientePF ON Pedido.ClienteID = ClientePF.ID
LEFT JOIN ClientePJ ON Pedido.ClienteID = ClientePJ.ID
GROUP BY Cliente;

''' Algum vendedor também é fornecedor? '''

SELECT 
  Vendedor.Nome AS Vendedor,
  CASE
    WHEN Fornecedor.ID IS NOT NULL THEN 'Sim'
    ELSE 'Não'
  END AS EForFornecedor
FROM Vendedor
LEFT JOIN Fornecedor ON Vendedor.ID = Fornecedor.ID;

''' Relação de produtos, fornecedores e estoques: '''

SELECT 
  Produto.Nome AS Produto,
  Fornecedor.Nome AS Fornecedor,
  Produto.Estoque
FROM Produto
INNER JOIN ProdutoFornecedor ON Produto.ID = ProdutoFornecedor.ProdutoID
INNER JOIN Fornecedor ON ProdutoFornecedor.FornecedorID = Fornecedor.ID;

