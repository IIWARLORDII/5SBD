INSERT INTO produtos (nomeProduto, qtd)
SELECT DISTINCT nomeProduto, 0
FROM tabelatemp
WHERE nomeProduto NOT IN (SELECT nomeProduto FROM produtos);