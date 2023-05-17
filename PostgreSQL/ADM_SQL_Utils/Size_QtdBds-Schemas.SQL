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
SELECT
	 table_name,
	 pg_size_pretty(table_size)   || ' (' || CASE WHEN total_size = 0 THEN 0.00 ELSE round(table_size * 100 / total_size) END   || ' %)' AS table_size,
	 pg_size_pretty(indexes_size) || ' (' || CASE WHEN total_size = 0 THEN 0.00 ELSE round(indexes_size * 100 / total_size) END || ' %)' AS indexes_size,
	 pg_size_pretty(total_size)                                                                                                          AS total_size
FROM (
	(SELECT
		table_name,
		pg_table_size(table_name)          AS table_size,
		pg_indexes_size(table_name)        AS indexes_size,
		pg_total_relation_size(table_name) AS total_size
	FROM (
		SELECT ('"' || table_schema || '"."' || table_name || '"') AS table_name
		FROM information_schema.tables
		WHERE NOT table_schema IN ('pg_catalog', 'information_schema')
	) AS all_tables
	ORDER BY total_size DESC)
	UNION ALL
	(SELECT
		'TOTAL',
		sum(pg_table_size(table_name))          AS table_size,
		sum(pg_indexes_size(table_name))        AS indexes_size,
		sum(pg_total_relation_size(table_name)) AS total_size
	FROM (
		SELECT ('"' || table_schema || '"."' || table_name || '"') AS table_name
		FROM information_schema.tables
		WHERE NOT table_schema IN ('pg_catalog', 'information_schema')
	) AS all_tables)

) AS pretty_sizes;

 --Quantidade de registro por schema individual
SELECT n.nspname,
        sum(c.reltuples) ::int
 FROM pg_class c
      LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
 WHERE c.relkind = 'r'::char AND
       nspname = 'NomeDoSchema'
 GROUP BY n.nspname
 
 
 
 --Listar as tabelas e a quantidade de colunas por tabela
 Select c.relname as tabela, count(a.attname) as total_colunas  
from pg_catalog.pg_attribute a 
inner join pg_stat_user_tables c on a.attrelid = c.relid
WHERE
a.attnum > 0 AND NOT a.attisdropped AND c.schemaname = 'nome_schema'
group by c.relname
order by c.relname

 --Listar as tabelas e as respectivas colunas
Select c.relname, a.attname as "Coluna"  
from pg_catalog.pg_attribute a 
inner join pg_stat_user_tables c on a.attrelid = c.relid
WHERE
a.attnum > 0 AND NOT a.attisdropped and c.schemaname = 'nome_schema' and c.relname = 'nome_tabela'
order by c.relname, a.attname

--SELECT table_name FROM information_schema.tables WHERE table_schema =:schema

--selecionar as sequências do PostgreSQL
SELECT * FROM information_schema.sequences;

--Seleciona somente as sequências do schema public:
SELECT * FROM information_schema.sequences WHERE sequence_schema = 'public';

--Seleciona apenas os nomes das sequências:
SELECT sequence_name FROM information_schema.sequences;

/*apenas as tabelas de usuário*/
SELECT table_name FROM information_schema.tables WHERE table_schema=:SCHEMA AND table_type='BASE TABLE'
