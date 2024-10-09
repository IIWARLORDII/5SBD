
CREATE TEMPORARY TABLE tabelatemp (
  codigoPedido VARCHAR(20),
  dataPedido DATE,
  SKU VARCHAR(20),
  UPC INT,
  nomeProduto VARCHAR(100),
  qtd INT,
  valor VARCHAR(20),
  frete VARCHAR(20),
  email VARCHAR(100),
  codigoComprador INT,
  nomeComprador VARCHAR(100),
  endereco VARCHAR(255),
  CEP VARCHAR(8),
  UF VARCHAR(2),
  pais VARCHAR(50)
);


LOAD DATA INFILE 'C:/wamp64/tmp/pedidos.txt'
INTO TABLE tabelatemp
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


UPDATE tabelatemp
SET 
valor = CAST(REPLACE(valor, ',', '.') AS DECIMAL(10, 2)),
frete = CAST(REPLACE(frete, ',', '.') AS DECIMAL(10, 2));


CALL processarPedidos();

CALL processarPedidosEstoque();

CALL processarPedidosAteCompletar();

CALL inserirEntregas();