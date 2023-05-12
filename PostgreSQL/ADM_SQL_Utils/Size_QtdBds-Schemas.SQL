--o select abaixo trará o tamanho aproximado de todas as bases presentes:
SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS size 
FROM pg_database;


--Somatória do tamanho de todas as bases presentes
(SELECT
	datname                                   AS banco,
	pg_database_size(datname)                 AS tamanho,
	pg_size_pretty(pg_database_size(datname)) AS tamanho_pretty
FROM pg_database
WHERE datname NOT IN ('template0', 'template1', 'postgres')
ORDER BY tamanho DESC, banco ASC)

UNION ALL

(SELECT
	'TOTAL'                                        AS banco,
	sum(pg_database_size(datname))                 AS tamanho,
	pg_size_pretty(sum(pg_database_size(datname))) AS tamanho_pretty
FROM pg_database
WHERE datname NOT IN ('template0', 'template1', 'postgres'));

--INDIVIDUAL
SELECT
    pg_size_pretty (
        pg_database_size ('Banco')
    );
    
--Tamanho de uma tabela ou indice
SELECT pg_total_relation_size('tabela');

--Tamanho por tabela
SELECT n.nspname as schemaname,
       c.relname as tablename,
       c.reltuples as registros,
       pg_size_pretty(pg_relation_size(n.nspname || '.' || c.relname)) as Tamanho
FROM pg_class c
     LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
     LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace
WHERE c.relkind = 'r' ::char AND
      nspname NOT IN ('dbateste', 'information_schema', 'pg_catalog',
       'pg_temp_1', 'pg_toast', 'postgres', 'publico', 'public')
ORDER BY n.nspname
    
--Quantidade de registros por tabela
SELECT n.nspname AS schemaname,
        c.relname AS tablename,
        C.reltuples::int AS Registros
 FROM pg_class c
      LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
      LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace
 WHERE c.relkind = 'r' ::char AND
       nspname NOT IN ('dbateste', 'information_schema', 'pg_catalog',
        'pg_temp_1', 'pg_toast', 'postgres', 'publico', 'public')
 ORDER BY n.nspname

--Quantidade de registros po schemas
SELECT n.nspname,
        sum(c.reltuples) ::int
 FROM pg_class c
      LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
 WHERE c.relkind = 'r' ::char AND
       nspname NOT IN ('dbateste', 'information_schema', 'pg_catalog',
                       'pg_temp_1',' pg_toast', 'postgres', 'publico', 'public')
 GROUP BY n.nspname
 
 --TAMANHO DOS INDICES DAS TABELAS
 SELECT 
  schemaname, tablename, indexname, 
  cast(pg_relation_size(cast(schemaname || '.' || indexname as varchar)) as float) / 1024 / 1024 as mb,
  pg_size_pretty(pg_relation_size(cast(schemaname || '.' || indexname as varchar))) as tamanho
from pg_indexes 
order by tamanho desc
/*Para praticidade filtre pelo schema e/ou tabela*/
 

 --Quantidade de registro por schema individual
SELECT n.nspname,
        sum(c.reltuples) ::int
 FROM pg_class c
      LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
 WHERE c.relkind = 'r'::char AND
       nspname = 'NomeDoSchema'
 GROUP BY n.nspname
 
 
