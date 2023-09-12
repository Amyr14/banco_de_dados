-- Usando o banco de dados apresentado no exercício anterior,
-- crie as seguintes views: --

-- Mostre o nome e a função dos mecânicos --

CREATE VIEW nome_funcao AS
SELECT nome, funcao
FROM mecanico;

SELECT * FROM nome_funcao;

-- Mostre o modelo e a marca dos veículos dos clientes --

CREATE VIEW modelo_marca AS
SELECT v.modelo, v.marca
FROM cliente c
JOIN veiculo v
ON c.codc = v.codc;

SELECT * FROM modelo_marca;

-- Mostre o nome dos mecânicos, o nome dos clientes, o modelo dos veículos e a data e hora dos consertos realizados --

CREATE VIEW info_conserto AS
SELECT m.nome, c.nome, v.modelo, data, hora
FROM conserto co
JOIN veiculo v
ON co.codv = v.codv
JOIN cliente c
ON c.codc = v.codc;

SELECT * FROM info_conserto;

-- Mostre o ano dos veículos e a média de quilometragem para cada ano --

CREATE VIEW media_quilometragem_por_ano AS
SELECT ano, AVG(quilometragem)
FROM veiculo
GROUP BY ano;

SELECT * FROM media_quilometragem_por_ano;

-- Mostre o nome dos mecânicos e o total de consertos feitos por um mecânico em cada dia --

CREATE VIEW total_consertos_por_mecanico AS
SELECT m.codm, nome, data, COUNT(m.codm)
FROM mecanico m 
JOIN conserto c
ON m.codm = c.codm
GROUP BY m.codm, nome, data;

SELECT * FROM total_consertos_por_mecanico;

-- Mostre o nome dos setores e o total de consertos feitos em um setor em cada dia --

CREATE VIEW total_consertos_por_setor AS
SELECT s.cods, s.nome, data, COUNT(s.cods)
FROM conserto c
JOIN mecanico m
ON m.codm = c.codm
JOIN setor s
ON m.cods = s.cods
GROUP BY s.cods, data;

SELECT * FROM total_consertos_por_setor;

-- Mostre o nome das funções e o número de mecânicos que têm uma destas funções --

CREATE VIEW mecanicos_por_funcao AS
SELECT funcao, COUNT(codm)
FROM mecanico
GROUP BY funcao;

SELECT * FROM mecanicos_por_funcao;

-- Mostre o nome dos mecânicos e suas funções e, para os mecânicos que estejam alocados a um setor, informe também o número e nome do setor --
CREATE VIEW mecanicos_com_funcao AS
SELECT m.nome, funcao, s.cods, s.nome AS nome_setor
FROM mecanico m
LEFT JOIN setor s
ON m.cods = s.cods;

SELECT * FROM mecanicos_com_funcao;

-- Mostre o nome das funções dos mecânicos e a quantidade de consertos feitos agrupado por cada função --
CREATE VIEW consertos_por_funcao AS
SELECT funcao, COUNT(*)
FROM mecanico m
JOIN conserto c
ON m.codm = c.codm
GROUP BY funcao;

SELECT * FROM consertos_por_funcao;