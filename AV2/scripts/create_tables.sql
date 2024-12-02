-- Tabela Aeroporto
CREATE TABLE aeroportos (
    codigo VARCHAR(10) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    localizacao VARCHAR(100) NOT NULL
);

-- Tabela Pista
CREATE TABLE pistas (
    identificacao VARCHAR(10) PRIMARY KEY,
    comprimento FLOAT NOT NULL,
    largura FLOAT NOT NULL,
    status VARCHAR(20) NOT NULL,
    aeroportoCodigo VARCHAR(10) NOT NULL,
    FOREIGN KEY (aeroportoCodigo) REFERENCES aeroportos(codigo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
