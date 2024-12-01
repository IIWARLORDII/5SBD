DELIMITER $$

CREATE PROCEDURE processarPedidos()
BEGIN
  
  DECLARE done INT DEFAULT 0;
  DECLARE cur_codigoPedido VARCHAR(20);
  DECLARE cur_dataPedido DATE;
  DECLARE cur_SKU VARCHAR(20);
  DECLARE cur_UPC INT;
  DECLARE cur_nomeProduto VARCHAR(100);
  DECLARE cur_qtd INT;
  DECLARE cur_valor DECIMAL(10, 2);
  DECLARE cur_frete DECIMAL(10, 2);
  DECLARE cur_email VARCHAR(100);
  DECLARE cur_codigoComprador INT;
  DECLARE cur_nomeComprador VARCHAR(100);
  DECLARE cur_endereco VARCHAR(255);
  DECLARE cur_CEP VARCHAR(8);
  DECLARE cur_UF VARCHAR(2);
  DECLARE cur_pais VARCHAR(50);

  
  DECLARE temp_cursor CURSOR FOR
  SELECT codigoPedido, dataPedido, SKU, UPC, nomeProduto, qtd, valor, frete, email, codigoComprador, nomeComprador, endereco, CEP, UF, pais
  FROM tabelatemp;

  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  
  OPEN temp_cursor;

  
  REPEAT
    
    FETCH temp_cursor INTO cur_codigoPedido, cur_dataPedido, cur_SKU, cur_UPC, cur_nomeProduto, cur_qtd, cur_valor, cur_frete, cur_email, cur_codigoComprador, cur_nomeComprador, cur_endereco, cur_CEP, cur_UF, cur_pais;

    
    IF NOT done THEN
     
      IF NOT EXISTS (SELECT 1 FROM pedidos WHERE codigoPedido = cur_codigoPedido) THEN
        
        INSERT IGNORE INTO clientes (codigoComprador, nomeComprador, email, CEP, endereco, UF, pais)
        VALUES (cur_codigoComprador, cur_nomeComprador, cur_email, cur_CEP, cur_endereco, cur_UF, cur_pais);

        
        INSERT INTO pedidos (codigoPedido, dataPedido, codigoComprador, nomeComprador, CEP, endereco, UF, pais, valorSubTotal, frete, valorTotal, status)
        VALUES (
          cur_codigoPedido,
          cur_dataPedido,
          cur_codigoComprador,
          cur_nomeComprador,
          cur_CEP,
          cur_endereco,
          cur_UF,
          cur_pais,
          cur_valor * cur_qtd, 
          cur_frete, 
          (cur_valor * cur_qtd) + cur_frete, 
          0 
        );

        
        INSERT INTO itenspedidos (codigoPedido, dataPedido, SKU, UPC, nomeProduto, qtd, valor, frete)
        VALUES (
          cur_codigoPedido,
          cur_dataPedido,
          cur_SKU,
          cur_UPC,
          cur_nomeProduto,
          cur_qtd,
          cur_valor,
          cur_frete
        );

      ELSE
        
        IF NOT EXISTS (
          SELECT 1 FROM itenspedidos 
          WHERE codigoPedido = cur_codigoPedido 
          AND dataPedido = cur_dataPedido 
          AND SKU = cur_SKU 
          AND UPC = cur_UPC
          AND nomeProduto = cur_nomeProduto 
          AND qtd = cur_qtd 
          AND valor = cur_valor 
          AND frete = cur_frete
        ) THEN
          
          INSERT INTO itenspedidos (codigoPedido, dataPedido, SKU, UPC, nomeProduto, qtd, valor, frete)
          VALUES (
            cur_codigoPedido,
            cur_dataPedido,
            cur_SKU,
            cur_UPC,
            cur_nomeProduto,
            cur_qtd,
            cur_valor,
            cur_frete
          );

         
          SET 
            valorSubTotal = (
              SELECT SUM(valor * qtd) FROM itenspedidos WHERE codigoPedido = cur_codigoPedido
            ),
            valorTotal = valorSubTotal + frete
          WHERE codigoPedido = cur_codigoPedido;
        END IF;
      END IF;
    END IF;

  UNTIL done END REPEAT;

  
  CLOSE temp_cursor;
END $$

DELIMITER ;

-- Apagar Procedure
DROP PROCEDURE IF EXISTS `processarPedidos`

--Processar pedido se tem todos os itens em estoque
DELIMITER $$

CREATE PROCEDURE processarPedidosEstoque()
BEGIN
  
  DECLARE done INT DEFAULT 0;
  DECLARE cur_codigoPedido VARCHAR(20);
  DECLARE cur_valorTotal DECIMAL(10, 2);
  DECLARE cur_nomeProduto VARCHAR(100);
  DECLARE cur_qtd INT;
  DECLARE estoque_qtd INT;
  DECLARE pedido_invalido INT DEFAULT 0;

  
  DECLARE pedidos_cursor CURSOR FOR
  SELECT codigoPedido, valorTotal
  FROM pedidos
  ORDER BY valorTotal DESC;

  
  DECLARE itens_cursor CURSOR FOR
  SELECT nomeProduto, qtd
  FROM itenspedidos
  WHERE codigoPedido = cur_codigoPedido;

  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  
  OPEN pedidos_cursor;

  
  pedidos_loop: REPEAT
   
    FETCH pedidos_cursor INTO cur_codigoPedido, cur_valorTotal;

    
    IF NOT done THEN
      
      SET pedido_invalido = 0;
      SET done = 0;  

      
      OPEN itens_cursor;

      
      itens_loop: REPEAT
        
        FETCH itens_cursor INTO cur_nomeProduto, cur_qtd;

       
        IF NOT done THEN
          
          SELECT qtd INTO estoque_qtd 
          FROM produtos
          WHERE nomeProduto = cur_nomeProduto;

          
          IF estoque_qtd < cur_qtd THEN
            SET pedido_invalido = 1;
            LEAVE itens_loop;  
          ELSE
            
            UPDATE produtos
            SET qtd = qtd - cur_qtd
            WHERE nomeProduto = cur_nomeProduto;
          END IF;
        END IF;

      UNTIL done END REPEAT;

      
      CLOSE itens_cursor;

      
      IF pedido_invalido = 0 THEN
        
        UPDATE pedidos
        SET status = 1
        WHERE codigoPedido = cur_codigoPedido;
      END IF;
    END IF;

  UNTIL done END REPEAT;

  
  CLOSE pedidos_cursor;
END $$

DELIMITER ;

-- Apagar procedure
DROP PROCEDURE IF EXISTS `processarPedidosEstoque`

-- Verificar estoque de todos os pedidos válidos
DELIMITER $$

CREATE PROCEDURE processarPedidosAteCompletar()
BEGIN
  DECLARE alteracao INT DEFAULT 1;

  
  WHILE alteracao > 0 DO
    
    CALL processarPedidosEstoque();
    
    
    SELECT alteracao INTO alteracao FROM processarPedidosEstoque();
  END WHILE;

END $$

DELIMITER ;

-- Apagar procedure
DROP PROCEDURE IF EXISTS `processarPedidosAteCompletar`


-- Procedure inserir entregas de pedidos completos
DELIMITER $$

CREATE PROCEDURE inserirEntregas()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE cur_codigoPedido VARCHAR(20);
    DECLARE cur_dataPedido DATE;
    DECLARE cur_SKU VARCHAR(20);
    DECLARE cur_UPC INT;
    DECLARE cur_codigoComprador INT;
    DECLARE cur_valorSubTotal DECIMAL(10,2);
    DECLARE cur_frete DECIMAL(10,2);
    DECLARE cur_valorTotal DECIMAL(10,2);
    DECLARE cur_status INT;

    
    DECLARE pedidos_cursor CURSOR FOR
    SELECT codigoPedido, dataPedido, SKU, UPC, codigoComprador, valorSubTotal, frete, valorTotal, status
    FROM pedidos
    WHERE status = 1;

    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

   
    OPEN pedidos_cursor;

    
    pedidos_loop: REPEAT

        FETCH pedidos_cursor INTO cur_codigoPedido, cur_dataPedido, cur_SKU, cur_UPC, cur_codigoComprador, cur_valorSubTotal, cur_frete, cur_valorTotal, cur_status;

        
        IF NOT done THEN
            
            DECLARE nomeComprador VARCHAR(100);
            DECLARE CEP VARCHAR(8);
            DECLARE endereco VARCHAR(255);
            DECLARE UF VARCHAR(2);
            DECLARE pais VARCHAR(50);

            
            SELECT nomeComprador, CEP, endereco, UF, pais
            INTO nomeComprador, CEP, endereco, UF, pais
            FROM clientes
            WHERE codigoComprador = cur_codigoComprador;

            
            INSERT INTO entregas (codigoPedido, dataPedido, SKU, UPC, codigoComprador, nomeComprador, CEP, endereco, UF, pais, valorSubTotal, frete, valorTotal, status)
            VALUES (cur_codigoPedido, cur_dataPedido, cur_SKU, cur_UPC, cur_codigoComprador, nomeComprador, CEP, endereco, UF, pais, cur_valorSubTotal, cur_frete, cur_valorTotal, 1);

            
            UPDATE pedidos
            SET status = 1
            WHERE codigoPedido = cur_codigoPedido;
        END IF;
    UNTIL done END REPEAT;

    
    CLOSE pedidos_cursor;
END $$

DELIMITER ;

-- Apagar procedure
DROP PROCEDURE IF EXISTS `inserirEntregas`