CODE 1 - Exemplo de transação sem o uso de procedures:


START TRANSACTION;

-- Consulta de seleção
SELECT * FROM tabela1 WHERE coluna1 = 'valor';

-- Modificação de dados
UPDATE tabela2 SET coluna2 = 'novo_valor' WHERE coluna3 = 'valor';

COMMIT;


CODE 2 - Exemplo de transação dentro de uma procedure com verificação de erro e possível ROLLBACK:
DELIMITER //

CREATE PROCEDURE nome_da_procedure()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Erro encontrado: ' || SQLSTATE;
    END;
    
    START TRANSACTION;

    -- Consulta de seleção
    SELECT * FROM tabela1 WHERE coluna1 = 'valor';

    -- Modificação de dados
    UPDATE tabela2 SET coluna2 = 'novo_valor' WHERE coluna3 = 'valor';

    COMMIT;
END //

DELIMITER ;

CODE 3 - Exemplo de backup e recovery usando mysqldump:
Backup
mysqldump -u nome_de_usuario -p senha nome_do_banco_de_dados > caminho/para/arquivo_de_backup.sql


Recovery
mysql -u nome_de_usuario -p senha nome_do_banco_de_dados < caminho/para/arquivo_de_backup.sql
