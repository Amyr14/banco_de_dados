--  Recupere o CPF e o nome dos mecânicos que trabalham nos setores número 1 e 2 (faça a consulta utilizado a cláusula IN) --
select cpf, nome 
from mecanico
where cods in (1, 2)

-- Recupere o CPF e o nome dos mecânicos que trabalham nos setores 'Funilaria' e 'Pintura' (faça a consulta utilizando sub-consultas aninhadas) --
select m.cpf, m.nome
from mecanico m
where m.cods in
   (select s.cods
    from setor s
    where s.nome in ('Funilaria', 'Pintura'))

-- Recupere o CPF e nome dos mecânicos que atenderam no dia 13/06/2014 (faça a consulta usando INNER JOIN) --
select cpf, nome
from mecanico m
inner join conserto c
on m.codm = c.codm
where data = '2014-06-13'

-- Recupere o nome do mecânico, o nome do cliente e a hora do conserto para os consertos realizados no dia 12/06/2014 (faça a consulta usando INNER JOIN) --
select m.nome, cl.nome, c.hora
from mecanico m
inner join conserto c
on m.codm = c.codm
inner join veiculo v
on v.codv = c.codv
inner join cliente cl
on v.codc = cl.codc
where c.data = '2014-06-12'

-- Recupere o nome e a função de todos os mecânicos, e o número e o nome dos setores para os mecânicos que tenham essa informação --
select m.nome, m.funcao, s.cods, s.nome
from mecanico m
left join setor s
on m.cods = s.cods

-- Recupere o nome de todos os mecânicos, e as datas dos consertos para os mecânicos que têm consertos feitos (deve aparecer apenas um registro de nome de mecânico para cada data de conserto) --
select distinct m.nome, c.data
from mecanico m
left join conserto c
on m.codm = c.codm

-- Recupere a média da quilometragem de todos os veículos dos clientes --
select avg(quilometragem)
from veiculo

-- Recupere a soma da quilometragem dos veículos de cada cidade onde residem seus proprietários --
select cidade, sum(v.quilometragem) as soma_quilometragem 
from veiculo v
inner join cliente c
on v.codc = c.codc
group by cidade

-- Recupere a quantidade de consertos feitos por cada mecânico durante o período de 12/06/2014 até 19/06/2014 --
select count(*) as quant_consertos
from (select * from conserto where data > '2014-06-12' and data < '2014-06-19') c
inner join mecanico m
on m.codm = c.codm
group by m.codm

-- Recupere o modelo, a marca e o ano dos veículos que têm quilometragem maior que a média de quilometragem de todos os veículos --
SELECT modelo, marca, ano
FROM veiculo
WHERE quilometragem > (
   SELECT AVG(quilometragem)
   FROM veiculo
)

-- Recupere o nome dos mecânicos que têm mais de um conserto marcado para o mesmo dia --
SELECT DISTINCT c.codm, nome
FROM mecanico m
JOIN conserto c
ON m.codm = c.codm
GROUP BY c.codm, nome, data
HAVING COUNT(*) > 1