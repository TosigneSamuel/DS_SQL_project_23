CREATE DATABASE prescriptionsDB

USE prescriptionsDB;
GO


/*
CREATE TABLE medical_practice(
	practice_code NVARCHAR(50) PRIMARY KEY,
	practice_name NVARCHAR(50) NOT NULL,
	address_1 NVARCHAR(50) NOT NULL,
	address_2 NVARCHAR(50) NULL,
	address_3 NVARCHAR(50) NULL,
	address_4 NVARCHAR(50) NULL,	
	post_code NVARCHAR(50) NOT NULL,
);

CREATE TABLE drugs(
	bnf_code NVARCHAR(50) PRIMARY KEY,
	chemical_substance_bnf_descr NVARCHAR(MAX) NOT NULL,
	bnf_description NVARCHAR(MAX) NOT NULL,
	bnf_chapter_plus_code NVARCHAR(MAX) NOT NULL,
);

CREATE TABLE prescriptions(
	prescription_code INT NOT NULL PRIMARY KEY,
	practice_code NVARCHAR(50) NOT NULL FOREIGN KEY (practice_code) 
	REFERENCES medical_practice (practice_code),
	bnf_code NVARCHAR(50) NOT NULL FOREIGN KEY (bnf_code) 
	REFERENCES drugs (bnf_code),
	quantity FLOAT NOT NULL,
	items INT NOT NULL,
	actual_cost MONEY NOT NULL,
);
*/
ALTER TABLE medical_practice
ADD PRIMARY KEY (practice_code);


SELECT * FROM Medical_Practice;



ALTER TABLE drugs
ADD PRIMARY KEY (bnf_code);

SELECT * FROM drugs;



ALTER TABLE prescriptions
ADD PRIMARY KEY (prescription_code);

ALTER TABLE prescriptions
ADD FOREIGN KEY (practice_code) REFERENCES medical_practice (practice_code);

ALTER TABLE prescriptions
ADD FOREIGN KEY (bnf_code) REFERENCES drugs (bnf_code);

SELECT * FROM prescriptions;



/*
Write a query that returns details of all drugs which are in the form of tablets or capsules. You can 
assume that all drugs in this form will have one of these words in the BNF_DESCRIPTION column.
*/

SELECT *
FROM  drugs 
WHERE bnf_description LIKE '%tablets%' OR bnf_description LIKE '%capsules%';



/*
Write a query that returns the total quantity for each of prescriptions – this is given by the number of 
items multiplied by the quantity. Some of the quantities are not integer values and your client has asked 
you to round the result to the nearest integer value.
*/

SELECT bnf_code,
FLOOR(quantity*items) as TOTAL_QUANTITY
FROM prescriptions;



/*
Write a query that returns a list of the distinct chemical substances which appear in the Drugs table 
(the chemical substance is listed in the CHEMICAL_SUBSTANCE_BNF_DESCR column)
*/

SELECT DISTINCT
		chemical_substance_bnf_descr
AS 
		'DISTINCT CHEMICAL SUBSTANCES'
FROM
		drugs;



/*
Write a query that returns the number of prescriptions for each BNF_CHAPTER_PLUS_CODE, along with 
the average cost for that chapter code, and the minimum and maximum prescription costs for that 
chapter code.
*/

SELECT d.bnf_chapter_plus_code,
COUNT(p.prescription_code) AS num_of_prescription,
AVG(p.actual_cost) AS average_cost,
MIN(p.actual_cost) AS minimum_cost,
MAX(p.actual_cost) AS maxmum_cost

FROM 
		drugs  d

INNER JOIN 
		prescriptions p
ON
		p.bnf_code = d.bnf_code

GROUP BY
		bnf_chapter_plus_code



/*
Write a query that returns the most expensive prescription prescribed by each practice, sorted in 
descending order by prescription cost (the ACTUAL_COST column in the prescription table.) Return only 
those rows where the most expensive prescription is more than £4000. You should include the 
practice name in your result.
*/



SELECT 
		m.practice_name, p.prescription_code, n.bnf_description, 
		MAX(p.actual_cost) AS most_expensive_prescriptions
FROM 
		medical_practice m
INNER JOIN
		prescriptions p
ON
		m.practice_code=p.practice_code
INNER JOIN
		drugs n
ON
		n.bnf_code=p.bnf_code
GROUP BY
		m.practice_name, p.prescription_code, n.bnf_description
HAVING
		MAX(p.actual_cost)>4000
ORDER BY 
		MAX(p.actual_cost)DESC
	
/*
You should also write at least five queries of your own and provide a brief explanation of the results 
which each query returns. You should make use of all of the following at least once:

o Nested query including use of EXISTS or IN
o Joins
o System functions
o Use of GROUP BY, HAVING and ORDER BY clauses
*/


/*
A Nested Query that returns the details of all drugs in the form of oral suspension, powder or solution, 
chewables, pump or aerosol sprays, inhalations and oral dosages.
micro-dosages, inhalers
*/

SELECT *
FROM  drugs 
WHERE bnf_description IN (
SELECT bnf_description
FROM drugs
WHERE bnf_description LIKE '%chewables%' OR bnf_description LIKE '%spy%' 
OR bnf_description LIKE '%haler%' OR bnf_description LIKE '%micro%' OR bnf_description LIKE '%inha%'
OR bnf_description LIKE 'oro%' OR bnf_description LIKE '%oral%'); 




/*
A Function that counts the distinct number of the distinct chemical subtance.
*/

CREATE FUNCTION [dbo].[count_distinct] 

				(@chemical_substance_bnf_descr NVARCHAR(50))

RETURNS INT
AS
	BEGIN
		RETURN 
				(SELECT COUNT(DISTINCT(chemical_substance_bnf_descr))
				FROM drugs
				WHERE chemical_substance_bnf_descr = @chemical_substance_bnf_descr);
	END;


SELECT 
	dbo.count_distinct(chemical_substance_bnf_descr)
FROM drugs

/*
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/


SELECT * FROM Medical_Practice;
SELECT * FROM drugs;
SELECT * FROM prescriptions;




/*
Write a query that returns the practice name, quantity of prescribed drugs and bnf_chapter_plus_code, sorted in 
descending order by quantity. Return only rows with quantity greater than 1000
*/



SELECT 
		m.practice_name, p.quantity, n.bnf_chapter_plus_code
	
FROM 
		medical_practice m
INNER JOIN
		prescriptions p
ON
		m.practice_code=p.practice_code
INNER JOIN
		drugs n
ON
		n.bnf_code=p.bnf_code

GROUP BY
		m.practice_name, p.quantity, n.bnf_chapter_plus_code
HAVING
		(p.quantity)>1000
ORDER BY 
		p.quantity DESC


/*
Write a query to retrieve practice name, chemical substance, bnf_description, actual cost
where the actual cost is gretaer than 250
*/

SELECT 
		m.practice_name, p.prescription_code, n.chemical_substance_bnf_descr, n.bnf_description,
		p.actual_cost
FROM 
		medical_practice m
INNER JOIN
		prescriptions p
ON
		m.practice_code=p.practice_code
INNER JOIN
		drugs n
ON 
		n.bnf_code=p.bnf_code
WHERE
		p.actual_cost>='250';


/*
Select distinct count of bnf_chapter_plus_code and group
*/

SELECT DISTINCT bnf_chapter_plus_code, COUNT('bnf_chapter_plus_code') as count_
FROM drugs
GROUP by BNF_CHAPTER_PLUS_CODE