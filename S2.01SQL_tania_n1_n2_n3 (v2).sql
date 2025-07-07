#NIVEL 1
#EJERCICIO 2
#Listado de los países que están generando ventas.

SELECT DISTINCT company.country
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE amount != 0;

SELECT DISTINCT company.country
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE amount > 0;

##2 Desde cuántos países se generan las ventas. 
SELECT COUNT(DISTINCT country) as Num_Paises
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE amount > 0;

#3 Identifica a la compañía con la mayor media de ventas.

SELECT company.id, company_name, AVG(amount) as media_Ventas
FROM company
JOIN transaction
ON company.id = transaction.company_id
Group by company_id, company_name
ORDER BY media_Ventas DESC
LIMIT 1;

#Ejercicio 3
#Utilizando sólo subconsultas (sin utilizar JOIN):
#Muestra todas las transacciones realizadas por empresas de Alemania.

SELECT *
FROM transaction
WHERE company_id IN ( SELECT company_id
						FROM company
						WHERE country = "Germany");
                        

#Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
SELECT id, company_name
FROM company
WHERE id IN (SELECT company_id
			FROM transaction
			WHERE amount > (
							SELECT AVG(amount)
							FROM transaction));
                            
#Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.

SELECT *
FROM company
WHERE id NOT IN (SELECT DISTINCT company_id
				FROM transaction);
                
                
SELECT *
FROM company
LEFT JOIN transaction 
ON company.id = transaction.company_id
WHERE transaction.id IS NULL; -- para hacer comparaciones


#NIVEL2
#
#Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
#Muestra la fecha de cada transacción junto con el total de las ventas.

SELECT DATE(timestamp) as fecha, SUM(amount) as total_ventas #!!! si dejo el timestamp, me considera la hora, dejando fuera transacciones que ocurrieron el mismo dia que no se están contando.
FROM transaction
GROUP BY DATE(timestamp)
ORDER BY total_ventas DESC
LIMIT 5;

#¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.

SELECT country, AVG(amount) as media_ventas
FROM company
JOIN transaction
ON company.id = transaction.company_id
GROUP BY country
ORDER BY media_ventas DESC;

#En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía “Non Institute”. 
#Para ello, te piden la lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.

SELECT transaction.id #, company.company_name, transaction.amount, transaction.timestamp
FROM transaction 
JOIN company ON transaction.company_id = company.id
WHERE company.country = (SELECT country 
							FROM company 
							WHERE company_name = 'Non Institute')
ORDER BY transaction.timestamp DESC;

#Muestra el listado aplicando solo subconsultas.

SELECT transaction.id					
FROM transaction 
WHERE company_id IN 
					(SELECT company.id
					FROM company 
					WHERE company.country =
									(SELECT company.country
									FROM company 
									WHERE company_name = 'Non Institute'));




#NIVEL 3
#Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor comprendido entre 350 y 400 euros 
#y en alguna de estas fechas: 29 de abril de 2015, 20 de julio de 2018 y 13 de marzo de 2024. 
#Ordena los resultados de mayor a menor cantidad.

SELECT company.id, company_name, phone, country, DATE(timestamp) as fecha, amount
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE amount BETWEEN 350 AND 400
AND DATE(transaction.timestamp) IN ("2015-04-29" , "2018-07-20", "2024-07-02")
ORDER BY amount DESC;

#Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera
#, por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, 
#pero el departamento de recursos humanos es exigente y quiere un listado de las empresas 
#en las que especifiques si tienen más de 400 transacciones o menos.


#USAR CASE#
SELECT company_id, company_name, COUNT(*) as numTransacciones,
CASE WHEN COUNT(transaction.id) > 400 THEN 'Más de 400 transacciones'
ELSE '400 transacciones o menos'
END AS "capacidad operativa"
FROM transaction
JOIN company
ON company.id = transaction.company_id
GROUP BY company_id, company_name
ORDER BY numTransacciones DESC;



