CREATE TABLE clientes (
    codigoComprador INT PRIMARY KEY,
    nomeComprador VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    CEP VARCHAR(8) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    UF VARCHAR(2) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

CREATE TABLE pedidos (
    codigoPedido VARCHAR(20) PRIMARY KEY,
    dataPedido DATE NOT NULL,
    codigoComprador INT NOT NULL,
    nomeComprador VARCHAR(100) NOT NULL,
    CEP VARCHAR(8) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    UF VARCHAR(2) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    valorSubTotal DECIMAL(10, 2) NOT NULL,
    frete DECIMAL(10, 2) NOT NULL,
    valorTotal DECIMAL(10, 2) NOT NULL,
    status INT NOT NULL DEFAULT 0,
    FOREIGN KEY (codigoComprador) REFERENCES clientes(codigoComprador)
);

CREATE TABLE itenspedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigoPedido VARCHAR(20) NOT NULL,
    dataPedido DATE NOT NULL,
    SKU VARCHAR(20) NOT NULL,
    UPC INT NOT NULL,
    nomeProduto VARCHAR(100) NOT NULL,
    qtd INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    frete DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (codigoPedido) REFERENCES pedidos(codigoPedido)
);

CREATE TABLE entregas (
    id  INT AUTO_INCREMENT PRIMARY KEY,
    codigoPedido VARCHAR(20) NOT NULL,
    dataPedido DATE NOT NULL,
    codigoComprador INT NOT NULL,
    nomeComprador VARCHAR(100) NOT NULL,
    CEP VARCHAR(8) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    UF VARCHAR(2) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    valorSubTotal DECIMAL(10, 2) NOT NULL,
    frete DECIMAL(10, 2) NOT NULL,
    valorTotal DECIMAL(10, 2) NOT NULL,
    status INT NOT NULL DEFAULT 0,
    FOREIGN KEY (codigoPedido) REFERENCES pedidos(codigoPedido),
    FOREIGN KEY (codigoComprador) REFERENCES clientes(codigoComprador)
);

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nomeProduto VARCHAR(100) NOT NULL,
    qtd INT NOT NULL
);
