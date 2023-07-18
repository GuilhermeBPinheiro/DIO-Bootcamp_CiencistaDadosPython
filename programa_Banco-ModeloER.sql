'''
--> Descrição do Desafio
Para este cenário você irá utilizar seu esquema conceitual, criado no desafio do módulo de modelagem de BD com modelo ER, para criar o esquema lógico para o contexto de uma oficina. 
Neste desafio, você definirá todas as etapas. Desde o esquema até a implementação do banco de dados. Sendo assim, neste projeto você será o protagonista. 
Tenha os mesmos cuidados, apontados no desafio anterior, ao modelar o esquema utilizando o modelo relacional.

Após a criação do esquema lógico, realize a criação do Script SQL para criação do esquema do banco de dados. 
Posteriormente, realize a persistência de dados para realização de testes. 
Especifique ainda queries mais complexas do que apresentadas durante a explicação do desafio. Sendo assim, crie queries SQL com as cláusulas abaixo:
* Recuperações simples com SELECT Statement;
* Filtros com WHERE Statement;
* Crie expressões para gerar atributos derivados;
* Defina ordenações dos dados com ORDER BY;
* Condições de filtros aos grupos – HAVING Statement;
* Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados.

--> Diretrizes
* Não há um mínimo de queries a serem realizadas;
* Os tópicos supracitados devem estar presentes nas queries;
* Elabore perguntas que podem ser respondidas pelas consultas;
* As cláusulas podem estar presentes em mais de uma query.

-----------------------------------------------------------------------------------------------------------------------------------

Descrição do Projeto Lógico:

Entidades:

  Cliente:
    ID (chave primária)
    Nome
    Endereço
    Telefone

  Veículo:
    ID (chave primária)
    Marca
    Modelo
    Ano
    Placa
    ClienteID (chave estrangeira referenciando Cliente)

  Serviço:
    ID (chave primária)
    Descrição
    Valor

  OrdemServico:
    ID (chave primária)
    Data
    ClienteID (chave estrangeira referenciando Cliente)
    VeiculoID (chave estrangeira referenciando Veiculo)

  Relacionamentos:
    Um Cliente pode ter vários Veículos (relacionamento 1:N entre Cliente e Veiculo)
    Um Veículo pertence a apenas um Cliente (relacionamento N:1 entre Veiculo e Cliente)
    Um Cliente pode fazer várias Ordens de Serviço (relacionamento 1:N entre Cliente e OrdemServico)
    Uma Ordem de Serviço é feita por apenas um Cliente (relacionamento N:1 entre OrdemServico e Cliente)
    Uma Ordem de Serviço pode ter vários Serviços (relacionamento N:M entre OrdemServico e Serviço)

Entidade Associativa:

  OrdemServicoServico:
    OrdemServicoID (chave primária e chave estrangeira referenciando OrdemServico)
    ServicoID (chave primária e chave estrangeira referenciando Serviço)
    Quantidade
'''

''' Script SQL para Criação do Esquema do Banco de Dados: '''

CREATE TABLE Cliente (
  ID INT PRIMARY KEY,
  Nome VARCHAR(100),
  Endereco VARCHAR(200),
  Telefone VARCHAR(20)
);

CREATE TABLE Veiculo (
  ID INT PRIMARY KEY,
  Marca VARCHAR(50),
  Modelo VARCHAR(50),
  Ano INT,
  Placa VARCHAR(10),
  ClienteID INT,
  FOREIGN KEY (ClienteID) REFERENCES Cliente(ID)
);

CREATE TABLE Servico (
  ID INT PRIMARY KEY,
  Descricao VARCHAR(200),
  Valor DECIMAL(10,2)
);

CREATE TABLE OrdemServico (
  ID INT PRIMARY KEY,
  Data DATE,
  ClienteID INT,
  VeiculoID INT,
  FOREIGN KEY (ClienteID) REFERENCES Cliente(ID),
  FOREIGN KEY (VeiculoID) REFERENCES Veiculo(ID)
);

CREATE TABLE OrdemServicoServico (
  OrdemServicoID INT,
  ServicoID INT,
  Quantidade INT,
  PRIMARY KEY (OrdemServicoID, ServicoID),
  FOREIGN KEY (OrdemServicoID) REFERENCES OrdemServico(ID),
  FOREIGN KEY (ServicoID) REFERENCES Servico(ID)
);

''' Recuperação simples com SELECT Statement - Obter todos os clientes: ''' 
  
SELECT * FROM Cliente;

''' Filtro com WHERE Statement - Obter veículos de um determinado cliente: '''

SELECT * FROM Veiculo WHERE ClienteID = 1;

''' Expressão para gerar atributos derivados - Obter o valor total de uma ordem de serviço: '''

SELECT 
  OrdemServico.ID,
  SUM(Servico.Valor * OrdemServicoServico.Quantidade) AS ValorTotal
FROM OrdemServico
JOIN OrdemServicoServico ON OrdemServico.ID = OrdemServicoServico.OrdemServicoID
JOIN Servico ON OrdemServicoServico.ServicoID = Servico.ID
GROUP BY OrdemServico.ID;

''' Ordenação dos dados com ORDER BY - Obter os serviços em ordem alfabética: ''' 

SELECT * FROM Servico ORDER BY Descricao ASC;

''' Condição de filtro aos grupos com HAVING Statement - Obter os clientes que possuem mais de 2 veículos: '''

SELECT ClienteID, COUNT(*) AS TotalVeiculos
FROM Veiculo
GROUP BY ClienteID
HAVING COUNT(*) > 2;

''' Junção entre tabelas para fornecer uma perspectiva mais complexa dos dados - Obter os serviços realizados em uma determinada ordem de serviço: ''' 

SELECT
  Servico.Descricao,
  OrdemServicoServico.Quantidade
FROM OrdemServicoServico
JOIN Servico ON OrdemServicoServico.ServicoID = Servico.ID
WHERE OrdemServicoServico.OrdemServicoID = 1;

