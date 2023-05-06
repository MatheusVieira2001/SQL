/*CRIACAO*/

CREATE TABLE cliente (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  tipo ENUM('PJ', 'PF') NOT NULL,
  cpf_cnpj VARCHAR(14) NOT NULL UNIQUE,
  endereco VARCHAR(255) NOT NULL
);

CREATE TABLE forma_pagamento (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(255) NOT NULL,
  taxa FLOAT NOT NULL
);

CREATE TABLE pedido (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  data_pedido DATE NOT NULL,
  data_entrega DATE,
  status_entrega ENUM('Entregue', 'Em trânsito', 'Pendente') NOT NULL,
  codigo_rastreio VARCHAR(255),
  cliente_id INT NOT NULL,
  forma_pagamento_id INT NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id),
  FOREIGN KEY (forma_pagamento_id) REFERENCES forma_pagamento(id)
);

CREATE TABLE produto (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  preco FLOAT NOT NULL,
  fornecedor_id INT NOT NULL,
  estoque INT NOT NULL,
  FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id)
);

CREATE TABLE fornecedor (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL
);

CREATE TABLE pedido_produto (
  pedido_id INT NOT NULL,
  produto_id INT NOT NULL,
  quantidade INT NOT NULL,
  PRIMARY KEY (pedido_id, produto_id),
  FOREIGN KEY (pedido_id) REFERENCES pedido(id),
  FOREIGN KEY (produto_id) REFERENCES produto(id)
);

CREATE TABLE vendedor (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL
);

CREATE TABLE vendedor_fornecedor (
  vendedor_id INT NOT NULL,
  fornecedor_id INT NOT NULL,
  PRIMARY KEY (vendedor_id, fornecedor_id),
  FOREIGN KEY (vendedor_id) REFERENCES vendedor(id),
  FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id)
);


/*INSERTS_BASE*/
INSERT INTO cliente (nome, tipo, cpf_cnpj, endereco) VALUES ('João da Silva', 'PF', '111.111.111-11', 'Rua A, 123');
INSERT INTO cliente (nome, tipo, cpf_cnpj, endereco) VALUES ('Empresa XYZ', 'PJ', '11.111.111/0001-11', 'Rua B, 456');

INSERT INTO fornecedor (nome) VALUES ('Fornecedor 1');
INSERT INTO fornecedor (nome) VALUES ('Fornecedor 2');

INSERT INTO produto (nome, preco, fornecedor_id, estoque) VALUES ('Produto 1', 10.0, 1, 100);
INSERT INTO produto (nome, preco, fornecedor_id, estoque) VALUES ('Produto 2', 20.0, 2, 50);

INSERT INTO forma_pagamento (descricao, taxa) VALUES ('Cartão de crédito', 0.02);
INSERT INTO forma_pagamento (descricao, taxa) VALUES ('Boleto bancário', 0.05);

INSERT INTO pedido (data_pedido, data_entrega, status_entrega, codigo_rastreio, cliente_id, forma_pagamento_id) VALUES ('2023-05-05', '2023-05-10', 'Em trânsito', 'ABC123', 1, 1);

/*consultas*/
Quantos pedidos foram feitos por cada cliente?
SELECT c.nome, COUNT(p.id) as total_pedidos
FROM cliente c
JOIN pedido p ON c.id = p.cliente_id
GROUP BY c.nome;

Algum vendedor também é fornecedor?
SELECT v.nome as nome_vendedor, f.nome as nome_fornecedor
FROM vendedor v
JOIN fornecedor f ON v.id = f.vendedor_id;

Relação de produtos fornecedores e estoques;
SELECT p.nome as nome_produto, f.nome as nome_fornecedor, e.quantidade
FROM produto p
JOIN fornecedor f ON p.fornecedor_id = f.id
JOIN estoque e ON p.id = e.produto_id;

Relação de nomes dos fornecedores e nomes dos produtos;
SELECT f.nome as nome_fornecedor, p.nome as nome_produto
FROM fornecedor f
JOIN produto p ON f.id = p.fornecedor_id;

Listar os pedidos que foram pagos com mais de uma forma de pagamento:
SELECT p.id, COUNT(pg.id) as total_pagamentos
FROM pedido p
JOIN pagamento pg ON p.id = pg.pedido_id
GROUP BY p.id
HAVING total_pagamentos > 1;

Listar os pedidos em que a data de entrega prevista já passou:
SELECT *
FROM pedido p
WHERE p.data_entrega_prevista < NOW();

Listar os clientes que possuem conta PJ:
SELECT *
FROM cliente
WHERE tipo_conta = 'PJ';

Listar os clientes que possuem conta PF:
SELECT *
FROM cliente
WHERE tipo_conta = 'PF';

Listar o nome do produto e a quantidade total vendida:
SELECT p.nome, SUM(ip.quantidade) as total_vendido
FROM produto p
JOIN item_pedido ip ON p.id = ip.produto_id
GROUP BY p.nome;

Listar o nome do vendedor e a quantidade de vendas realizadas:
SELECT v.nome, COUNT(p.id) as total_vendas
FROM vendedor v
JOIN pedido p ON v.id = p.vendedor_id
GROUP BY v.nome;

Listar os produtos que nunca foram vendidos:
SELECT p.nome
FROM produto p
LEFT JOIN item_pedido ip ON p.id = ip.produto_id
WHERE ip.produto_id IS NULL;

Listar os pedidos com status "entregue" e seu código de rastreio:
SELECT p.id, e.status, e.codigo_rastreio
FROM pedido p
JOIN entrega e ON p.id = e.pedido_id
WHERE e.status = 'entregue';
                            
/*Consultas 2*/
 Recuperação simples com SELECT Statement:
a. Selecione todos os produtos da tabela de produtos:
SELECT * FROM produtos;

b. Selecione apenas o nome e o preço dos produtos da tabela de produtos:
SELECT nome, preco FROM produtos;

Filtros com WHERE Statement:
a. Selecione apenas os produtos que têm um preço maior do que R$ 100:
SELECT * FROM produtos WHERE preco > 100;
                            
b. Selecione apenas os clientes que têm um nome que começa com a letra "A":
SELECT * FROM clientes WHERE nome LIKE 'A%';

Crie expressões para gerar atributos derivados:
a. Adicione uma coluna chamada "valor_total" que multiplique o preço e a quantidade de cada produto:
SELECT nome, preco, quantidade, preco*quantidade AS valor_total FROM produtos;
                            
b. Adicione uma coluna chamada "idade" que calcule a idade atual dos clientes, a partir da data de nascimento:
SELECT nome, data_nascimento, YEAR(CURRENT_DATE()) - YEAR(data_nascimento) AS idade FROM clientes;

Defina ordenações dos dados com ORDER BY:
a. Ordene os produtos por ordem crescente de preço:
SELECT * FROM produtos ORDER BY preco ASC;

b. Ordene os clientes por ordem alfabética do nome:
SELECT * FROM clientes ORDER BY nome ASC;

Condições de filtros aos grupos – HAVING Statement:
a. Selecione apenas os produtos que tiveram mais de 10 unidades vendidas:
SELECT produto_id, SUM(quantidade) AS total_vendido FROM pedidos_produtos GROUP BY produto_id HAVING total_vendido > 10;

b. Selecione apenas os clientes que fizeram mais de 3 pedidos:
SELECT cliente_id, COUNT(*) AS total_pedidos FROM pedidos GROUP BY cliente_id HAVING total_pedidos > 3;

6. Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados:
a. Selecione o nome do cliente e o nome do produto para cada pedido:
SELECT clientes.nome AS cliente, produtos.nome AS produto FROM pedidos
JOIN clientes ON clientes.id = pedidos.cliente_id
JOIN pedidos_produtos ON pedidos_produtos.pedido_id = pedidos.id
JOIN produtos ON produtos.id = pedidos_produtos.produto_id;

b. Selecione o nome do fornecedor e o nome do produto para cada estoque:
SELECT fornecedores.nome AS fornecedor, produtos.nome AS produto, estoques.quantidade FROM estoques
JOIN produtos ON produtos.id = estoques.produto_id
JOIN fornecedores ON fornecedores.id = estoques.fornecedor_id;                           
