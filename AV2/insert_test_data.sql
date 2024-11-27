-- Inserindo dados na tabela Aeroporto
INSERT INTO aeroportos (codigo, nome, localizacao) VALUES
('GRU', 'Aeroporto Internacional de Guarulhos', 'Guarulhos - SP'),
('SDU', 'Aeroporto Santos Dumont', 'Rio de Janeiro - RJ'),
('BSB', 'Aeroporto Internacional de Brasília', 'Brasília - DF');

-- Inserindo dados na tabela Pista
INSERT INTO pistas (identificacao, comprimento, largura, status, aeroportoCodigo) VALUES
('P1-GRU', 3800, 45, 'Ativa', 'GRU'),
('P2-GRU', 3000, 50, 'Ativa', 'GRU'),
('P1-SDU', 1323, 42, 'Ativa', 'SDU'),
('P1-BSB', 3300, 60, 'Manutenção', 'BSB');
