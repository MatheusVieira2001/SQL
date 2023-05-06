Pergunta 1: Qual o departamento com maior número de pessoas?

SELECT department_name, COUNT(*) AS num_people
FROM employees
JOIN departments ON employees.department_id = departments.department_id
GROUP BY department_name
ORDER BY num_people DESC
LIMIT 1;

CREATE INDEX idx_employee_dept ON employees (department_id);

Explicação: Esse índice é criado na coluna department_id da tabela employees para ajudar na junção com a tabela departments na consulta. Pois a consulta faz uma contagem de funcionários por departamento


Pergunta 2: Quais são os departamentos por cidade?

SELECT city, GROUP_CONCAT(department_name) AS departments
FROM employees
JOIN departments ON employees.department_id = departments.department_id
JOIN locations ON departments.location_id = locations.location_id
GROUP BY city;

CREATE INDEX idx_dept_location ON departments (location_id);

Explicação: Esse índice é criado na coluna location_id da tabela departments para ajudar na junção com a tabela locations na consulta. Pois a consulta agrupa os departamentos por cidade, é útil ter um índice na coluna location_id

Pergunta 3: Relação de empregados por departamento

SELECT department_name, COUNT(*) AS num_employees
FROM employees
JOIN departments ON employees.department_id = departments.department_id
GROUP BY department_name;

CREATE INDEX idx_employee_dept ON employees (department_id);

Explicação: índice é o mesmo sugerido para a Pergunta 1. Ele é criado na coluna department_id da tabela employees para ajudar na junção com a tabela departments na consulta