

/*
The purpose of the lib_data_db is to maintain the data for the library's processing of hundreds of loans a day
by storing the details of: 
-items on loans; 
-information on their existing and new members;
-their library catalogue;
-loan history; and,
-overdue fines.

The specific tasks which the library needs and expects so as to perform their tasks correctly andaccomplish 
their work are:
-to access and know the repayment date/time, status and method of its members;
-to access and know the loan history of its members;
-to access and know the status of every item in its catalogue;
-to keep and access the record of all its current and past loans, with each loan specifying the member, the item, 
the date the item was takenoout, the date the item is due back, the date the item was returned, and the overdue
fee that should be charged members on overdue items;
-to avoid data loss in case of a system outage.

Since there isn't yet data to work with, the next step when designing a database from scratch, is to first extract the
list of entities and the list of attributes from the body of research, decipher the relationships between them and 
factor them into the splitting of the tables with a goal of  being in at least a third normal form (nf).

Member and Loan History

As a library is literally non-functional without active members, they are therefore a part of the rudimentary
element in our library system; the database will naturally need to hold information about them and their Loan 
History. It goes without saying that  two tables will be created: member and loan_history.

Note_1 - a many-to-many relationship has been identified between these tables; this is because a member can 
take out a loan on many (books, journals, DVDs, or/and other media) items thereby, having many loan history. 
Also, a loan history is not necessarily unique to only one member, as several members could share a similar
loan history. Hence there's an m:n relationship between member and loan_history tables.
Since an M:N relationship exists between member and loan_history tables, it gives rise to an intersection or 
intermediary table that connects to both the member and loan_history tables by combining their Primary Keys
to give attributes that create a Composite Primary Key. This is due to the  complexities that somewhat arise when 
designing an M:N relationship. The attributes of this Composite Primary Key when combined, create a unique 
combination which can only occur once. 

Note_2 - the overdue fine repayments for a member is dependent and ascertained by the loan history. We've 
established that several members could share a similar loan history; so let's consider that some members have 
the same loan history, they will as a result have  similar overdue fine payments. This is taken into consideration
when normalising the database.

Note_3 - the 'loan status' of an item, the 'item type', and the overdue fine are determined also by the loan history.
This is because to have a fully functional 'loan history' data, the type of item on loan would need to be known, 
and determining the current status of that item, whether it's lost or removed, still on loan, available or overdue 
- and if overdue by how many days; so as to calculate the overdue fee, would lead us back to the information in 
the loan history table. This is also takeninto consideration during the database normalisation.

Note_4 - since our database needs to record and access what 'repayment method' was used by, and the 
'repayment status' of every member,  they were also taken into consideration in designing of the database.
*/


/*
	--The Data Model


Our library database is a centralised data model where our users are allowed to sign up with a password and a
unique username to browse through its entire catalogue of items and borrow book, DVD, journal, and other media 
items. Also, our members have a loan history of the items borrowed and overdue fine repayments should an item
become overdue.

Our library database consists of eleven (11) tables divided into four (4) subject areas;

-Member
-Library Catalogue
-Loan History
-Overdue Fine Repayments

The entities are:

-Member
-Library Catalogue
-Loan History
-Overdue Fine Repayments
-Loan Status
-Repayment Method
-Repayment Status
-Membership
-Member Loan History
-Item Type
-Address

The attributes are:

	Member
first_name
middle_name
last_name
address_id
date_of_birth
username 
password
email_address
telephone_number
membership_id

	Loan History
loan_history_id
username
item_type_id
date_loaned_out
date_due_back
date_returned
overdue_id
loan_status_id

	Loan Status
loan_status_id
loan_status_name
date_identified

	Overdue Fine Repayment
fine_repayment_id
loan_history_id
overdue_fines
amount_repaid
outstanding balance
repayment_method_id
repayment_status_id

	Repayment Method
repayment_method_id
method_name

	Repayment Status
repayment_status_id
repayment_status_name

	Library Catalogue
library_catalogue_id
item_title
item_type_id
author
year_of_publication
loan_status_id
date_of_addition

	Membership
date_started
date_ended
username

	Member Loan History
username
loan_history_id

	Item Type
item_type_id
library_catalogue_id
isbn

	Address
address_id
address_1
address_2
city
postcode


	--Relationships - Cardinality

-Members have Loan History										(M:N)
-Current Status have Loan History								(1:N)
-Library Catalogue contains Item Type							(1:N)
-Library Catalogue issues Current Status						(1:N)
-Overdue Fine Repayment needs Loan History				(N:1)
-Item type contains Loan History									(1:N)
*/

/*
Since the member table is part of the base elements in our library database system, the 'member' table is first 
created. the 'member' table will hold the identifying information specific to every member such as every member's
first name, middle name, last name, address, password.The  table should also hold data on the date every 
member's membership started,  and if a member leaves, the day the membership ended. For our library database
to be in the third normal format the minimum, any issue of atomicity that could arise from names is dealt with 
by creating a seperate table fornames and any form of dependencies that could arise from addresses is thwarted
by creating a seperate address table. Also, we may decide to add check and  unique constraints to the email 
addresses provided by customers just so we could make sure members are not only inputting a right or valid 
email format when creating their memberships but also using unique email address for every customer that 
signs up. This would help enforce some level of data intergrity.

Also, to ensure our library database is protected from unauthorized access, data security is enforced. Using a mix
of varying characters, uppercase and lowercase letters, numbers, and special symbols are not enough to maintain
our database security if the passwords are fundamentally not stored in a secure way. To maintain our database 
security, the passwords in the databse will be encrypted and made as undecipherable as possible.

To encrypt the passwords, a one-way hashing algorithm is used. The HASHBYTES function in SQL Server 
Management Studio uses an allgorithm to return a hash for any inputted password. Possible algorithms include
MD2, SHA1, SHA_256, MD4 and others. SHA_512 is the most recent and strongest so far (REFERENCES) however,
for our library database, we'll be using SHA1. (WHY and REFERENCE).
To try and make our hash ever more uncrackable irrespective of whether or not a member chooses a weak 
password, we'll make a hash generated from the combination of a password and randomly generated text; 
randomly generated text is known as a Salt in cryptography. When salting, an excellent rule of practice is that it
should be unique for each user otherwise, say two members use the same password when creating an account,
their password hashes as well as their salts will be thesame. For the database security and integrity, we 
shouldn't have this (REFERENCE).

*/



	--create the database


CREATE DATABASE lib_data_db;

USE lib_data_db;
GO



	--create member table

CREATE TABLE member (
user_id INT IDENTITY(1,1) PRIMARY KEY,
first_name NVARCHAR(50) NOT NULL,
middle_name NVARCHAR(50) NULL,
last_name NVARCHAR(50) NOT NULL,
member_dob DATE NOT NULL,
username NVARCHAR(50) NOT NULL,
member_pass NVARCHAR(64) NOT NULL,
salt UNIQUEIDENTIFIER,
member_email NVARCHAR(100) UNIQUE NOT NULL CHECK(member_email LIKE '%_@_%._%'),
member_telephone NVARCHAR(50) NULL,
membership_date_started DATE NOT NULL,
membership_date_ended DATE NULL,
);


/*
The next table to be created is the 'loan_history' table which holds the loan history information of the library
users. This table helps us know and record what items are out on loans, by whom has this loan been taken out, 
the loan status of every item in the library catalogue, and the overdue status of any item.
*/


	--create loan_history table

CREATE TABLE loan_history(
loan_history_id INT IDENTITY(1,1) PRIMARY KEY,
date_loaned_out DATE NOT NULL,
date_due_back DATE NOT NULL,
date_returned DATE NULL,
overdue_fine_id INT NULL,
loan_status NVARCHAR(50) NOT NULL,
item_type_id INT NOT NULL,
);


/*
The next table to be created is the 'member_loan_history' table. Remember that since there exists a many-to-many 
relationship between the members and the accounts (a member can take out a loan on many items and the same 
type of loan_history can be owned by many members), both tables will not directly reference one another instead,
an intersection table member_loan_history is created to populate the unique loan details of every member.
*/


	--create member_loan_history table

CREATE TABLE member_loan_history(
user_id INT NOT NULL FOREIGN KEY (user_id) REFERENCES member (user_id),
loan_history_id INT NOT NULL FOREIGN KEY (loan_history_id) REFERENCES loan_history (loan_history_id),
PRIMARY KEY (user_id, loan_history_id),
);


/*
Up next for creation is the 'current_status' table. This relationship between 'date_identified' (the date an item was
identified to be lost or removed) and 'current_status' is what is described as a full functional dependency; the 
date of identification of a lost or removed item from the library catalogue is completely dependent on the current 
status: otherwiswe the current_status of some items in the catalogue wouldn't be known.
*/


	--create current_status table

CREATE TABLE current_status(
current_status_id INT PRIMARY KEY,
status_name NVARCHAR(50) NOT NULL,
date_identified DATE NULL,
library_catalogue_id INT NOT NULL,
);


/*
In the 'overdue_fine_repayments' table, the 'amount repaid by a loan defaulter is dependent on the 'overdue 
fines', whichis dependent on the 'loan history'. If J -> S and S -> T, then J -> T is a transitive dependency. Here, the 
'amount repaid' depends on the 'overdue fines' which depends on the 'loan history' and as such, this transitive
dependency must be eliminated in order to achieve 3nf. To do this, a seperate table is created to hold the 
'overdue fine repayments'.
*/


	--create overdue_fine_repayments table

CREATE TABLE overdue_fine_repayment(
overdue_fine_id INT PRIMARY KEY,
overdue_fines MONEY NOT NULL,
amount_repaid MONEY NOT NULL,
outstanding_balance MONEY NOT NULL,
repayment_date DATE NOT NULL,
repayment_time TIME NOT NULL,
);


/*
A trivial functional dependency exists between 'repayment_method' and 'overdue_fine_repayment' tables. The 
dependent column (repayment method name) describes the form in which payment was made, either by cash or
by card.
An overdue_fine_repayment will definitely need a repayment method: cash or card. This creates a 
dependency relationship.
*/


	--create repayment method table

CREATE TABLE repayment_method(
repayment_method_id INT PRIMARY KEY,
repayment_method_name NVARCHAR(20) NOT NULL,
overdue_fine_id INT NOT NULL FOREIGN KEY REFERENCES overdue_fine_repayment (overdue_fine_id)
);


/*
furthermore, trivial functional dependency also exists between 'repayment_status' and 'overdue_fine_repayment' 
tables. The dependent column (repayment status name) describes the status of every member's loan, either 
current or past.
To have and be able to access the repayment_status and history of every member, so as to have an idea
of members who are yet to clear off their debts and for how long they've been holding such debts, a 
repayment_status is needed. Again, this creates a child, parent dependency.
*/


	--create repayment status  table

CREATE TABLE repayment_status(
repayment_status_id INT PRIMARY KEY,
repayment_status_name NVARCHAR(20) NOT NULL,
overdue_fine_id INT NOT NULL FOREIGN KEY REFERENCES overdue_fine_repayment (overdue_fine_id)
);


/*
Next up is the creating of an 'address' table. Mostly, the combination of address1 and postcode serve as a unique
identifier for addresses. therefore, it's worth including a unique constraints with these two attributes.

The 'address_id' was spun out of the 'member' table to enable atomicity of our data. The 'address_id table
is as a result the child table pointimg to its parent table via the foreign key 'member_id'. I've done it the 
other way (put the 'address_id' in the 'member' table); in this instance, it's non-consequential.
*/


	--create address table

CREATE TABLE address(
address_id INT IDENTITY NOT NULL PRIMARY KEY,
address1 NVARCHAR(50) NOT NULL,
address2 NVARCHAR(50) NULL,
city NVARCHAR(50) NULL,
postcode NVARCHAR(10) NOT NULL,
CONSTRAINT uk_address UNIQUE (address1, postcode),
user_id INT NOT NULL FOREIGN KEY (user_id) REFERENCES member (user_id),
);


/*
The 'library catalogue' holds the information of every item title, item type (books, journals, DVD, and other
media), the author, year of publication, current status, and date of every item addition contained in the library.
*/

	--create library_catalogue table

CREATE TABLE library_catalogue(
library_catalogue_id INT PRIMARY KEY,
item_title NVARCHAR(50) NOT NULL,
author NVARCHAR(50) NULL,
year_of_publication DATE NULL,
date_of_addition DATE NOT NULL,
);


/*
Lastly, the 'item_type' table is created. The 'ISBN' is fully functionally dependent on the 'item_type' , since we
can't have an 'ISBN without a book item and as such the 'item-type table has been created to hold this 
information. Furthermore, there can't be an 'item_type' (book, DVD, other media or journal items) without
the 'library_catalogue to hold the items. Therefore a transitive functional dependency exists between 'ISBN'
and 'item_type', and a fully functional dependency exists betwwen the 'item_type' and 'library_catalogue'
Therefore, a one-to-many relationship exists between the 'library_catalogue' and the 'item_type' tables
(the 'library catalogue' holds many types of the items but different item types are not contained in several
'library catalogues' but in the'library catalogue we're creating a database for).

In a one-to-many relationship, the parent table is referenced by the child table; the child table has a form 
of either partial or total dependency on the parent table as explained above and as a result, the foreign
key is held in the child table (referencing the parent table). This is why the 'library_catalogue_id' is 
contained in the 'item_type' table and not the other way around (the item_type_id being held in the 
library_catalogue table).

This is a typical depiction of a normalization standard in the third normal form (nf).
*/


	--create the item_type table

CREATE TABLE item_type(
item_type_id INT PRIMARY KEY,
item_type_name NVARCHAR(50),
library_catalogue_id INT NOT NULL FOREIGN KEY (library_catalogue_id) REFERENCES library_catalogue (library_catalogue_id),
isbn NVARCHAR(50) NULL,
);

/*
After creating all the tables in order to have a normalised database, five (5) more additional foreign key 
constraints will be added to in order to create a complete relationship.
*/

/*
A 'loan_history' is attached to a single item of an item_type that is overdue however, a bulk 
overdue fine repayment for many items could be made by a single member who was loaned different item
types; a one-to-many relationship therefore exists; a single overdue fine repayment could account for 
many loan history (summed up in one), but a loan history can only reference a single item_type of an
item at a time.

Knowing this, a relationship is created between both tables with the 'loan_history' table being the child
table that contains a foreign key that references the parent, 'overdue_fine_repayment' table. 
Hence, this column hasn't been specified to contain unique values as an overdue fine repayment can be
associated with many loan history. In addition, this column has been allowed the liberty of containig 
NULL values which will mean some members may not necessarily be associated with an 'overdue_fine'
at all since they return loaned items on or before the deu date.
*/


	--foreign key constraint

ALTER TABLE loan_history ADD CONSTRAINT fk_overdue_fine_repayment
FOREIGN KEY (overdue_fine_id) REFERENCES overdue_fine_repayment (overdue_fine_id);


/*
An 'item_type would typically consist of many loan history. So many people would loan the 'item_type' 
book for instance but every book item loaned out will have a unique loan history. So it's a one-to-many
relationship.
*/


	--foreign key constraint

ALTER TABLE loan_history ADD CONSTRAINT fk_item_type
FOREIGN KEY (item_type_id) REFERENCES item_type (item_type_id);


/*
A 'current_status' means whether an item (book, journal, DVD, or other media items) in the 
'library_catalogue' is either available, overdue, on loan or lost/removed. This is impossible to ascertain
without a 'library_catalogue' holding such items and as such, a one-to-many relationship exists between
both entities, as our single library_catalogue will have many statuses but these statuses will only be 
pointing towards the lone catalogue.
*/


	--foreign key constraint

ALTER TABLE current_status ADD CONSTRAINT fk_library_catalogue
FOREIGN KEY (library_catalogue_id) REFERENCES library_catalogue (library_catalogue_id);


SELECT * FROM member;


	--populating the database tables


/*
To make sure library data database model works perfectly, for demonstarting to our client, some records
of at least five (5) rows will be inserted into each table; this is so as to allow us adequately test that all
SELECT queries, user-defined functions and system functions, triggers, and stored procedures are working
as planned. To do this, the INSERT statements is used. 

Since we're not populating our database with a pre-existing data, we're at liberty of using two (2) basic 
types of SQL INSERT syntax:

-Using INSERT with column names or,
-Using INSERT without column names

We'll be using both.

Note_5 - Due to all the Foreign Keys relationship, a somewhat intertwined and complex pattern is created,
meaning that when inserting information into our library database table, it'll have to be done in a specific
way. 

To understand this better, an understanding of a parent table and a child table is needed. To put it 
simply, the table that is made up of the primary key is called the parent (referenced) table, while the
table that contains the foreign key (referencing the primary key) in which a relationship exists between 
both tables is known as the child table.

As an instance, our library database contains the address table and the member table; the address table 
has an 'address_id' column and the member table also has an 'address_id' column however, the 
'address_id' column in the member table is a foreign key and is dependent on the 'address_id' in the 
address table which is a primary key. So going by what has been classified as parent and child tables 
above, the member table is a child table while the address table is the parent table and as such, the 
address table must first be populated with data before inserting data into the member table. This is 
because the value of the address_id column in the address table (primary key value) is needed to have 
values for insertion in the address_id column in the member table (foreign key).

Should we try to insert values first in the member table before the address table, the address_id column 
in the member table has a constraint to not accept null values and as such it would be impossible to 
populate the member table with values and still maintain data intergrity.

There's no one universal approach to doing this however, a useful rule of thumb is to prevent actions that
could or would sever links between tables.
*/


/*
The INSERT statement below populates the 'address' table. 

Note_6 - for IDENTITY, If you don't want the database server to provide the values for you for the 'identity 
column, for instance, in the loan_history table, in order to have complete autonomy to specify explicit 
values for the 'address_id' column, an INSERT with column names, and  IDENTITY (auto-increment) are used.
*/


	--using insert without without column names

			--insert into 'member' table

INSERT INTO member 
VALUES
	('MICHAEL', 'BEN', 'EDWIN', '1976-09-29', 'ben', HASHBYTES('SHA1', 'MEntee123&&'), NEWID(), 'info@mbeaberdeen.co.uk', '01224211671', '2022-03-20', NULL),
	('SHIRLEY', 'ZAIRE', 'DALTON', '1986-04-10', 'zaire', HASHBYTES('SHA1', 'weRUNtheWORLD989@'), NEWID(), 'info@mbealtricham.co.uk', '01612330500', '2021-05-20', '2022-05-22'),
	('MARGARET', 'AMARA', 'CLARK', '1997-01-11', 'gamara', HASHBYTES('SHA1', 'MAGicjohnsonnn232@*'), NEWID(), 'info@mbeandover.co.uk', '01264362767', '2022-04-29', NULL), 
	('PERSEPHONE', 'STELLA', 'ATHENS', '2003-01-01', 'athena', HASHBYTES('SHA1', 'qwertyuIOP098!@#'), NEWID(), 'info@mbeayr.co.uk', '01292618600', '2021-02-18', NULL),
	('AUDREY', 'CLAIRE', 'STEPHENS', '2004-09-19', 'sens', HASHBYTES('SHA1', 'PURSUITOFhappyness23'), NEWID(), 'mbebanbury@btopenworld.com', '0129527773', '2020-04-20', '2022-09-13'),
	('ZARA', 'CLAIRE', 'OLIVE', '2001-10-19', 'zolive', HASHBYTES('SHA1', 'writtenINtheClo34!&*'), NEWID(), 'info@mbebath.co.uk', '01225483777', '2010-04-21', '2012-05-17'),
	('MAYA', 'AYLA', 'SAMS', '2000-12-29', 'lams', HASHBYTES('SHA1', 'bOUrne3455^*99'), NEWID(), 'stloyehouse@021.mbe.uk.com', '01234305544', '2020-04-21', NULL),
	('WILLA', 'ELOWEN', 'AMARA', '1994-09-19', 'wira', HASHBYTES('SHA1', 'weDRINKTOthat5^$#!@*'), NEWID(), 'info@mbebelfast.co.uk', '01216858300', '2020-12-22', NULL);


SELECT * FROM member;


		--insert into 'address' table

INSERT INTO address
VALUES 
	('73 HOLBURN STREET', NULL, 'ABERDEEN', 'AB10 6DN', 1),
	('PEEL HOUSE', '30 THE DOWNS', 'ALTRICHAM', 'WA14 2PU', 2 ),
	('ANDOVER HOUSE', 'GEORGE YARD', 'ANDOVER', 'SP10 1PB', 3),
	('4 FULLARTON STREET', NULL, 'AYR', 'KA7 1UB', 4),
	('29-30 HORSEFAIR', NULL, 'BANBURY', 'OX16 0BW', 5),
	('3 EDGAR BUILDING', 'GEORGE STREET', 'BATH', 'BA1 2FJ', 6),
	('ST LOYES HOUSE', '20 LOYES HOUSE', 'BEDFORD', 'MK40 1ZL', 7),
	('THOMAS HOUSE', '47 BOTANIC AVENUE', 'BELFAST', 'BT7 1JJ', 8);


SELECT * FROM address;


	--using insert with column names


		--insert into 'library_catalogue' table

INSERT INTO library_catalogue (library_catalogue_id, item_title, author, year_of_publication, date_of_addition)
VALUES 
	(001, 'HEAVEN IS FOR REAL', NULL, NULL, '2018-09-03'),
	(002, 'THE HUNGER GAMES MOCKINGJAY', 'SUZANNA COLLINS', '2010', '2013-07-11'),
	(003, 'THE HUNGER GAMES', 'SUZANNE COLLINS', '2008', '2011-01-01'),
	(004, 'CATCHING FIRE', 'SUZANNA COLLINS', '2009', '2009-09-21'),
	(005, 'KITCHEN CONFIDENTIAL', 'BOURDAIN ANTHONY', NULL, '2018-10-21'),
	(006, 'TELL THE WOLVES I AM HOME', 'BRUNT CAROL RIFKA', '2012', '2021-08-14'),
	(007, 'CALIFORNIA MEDICAL JOURNAL', 'ROBERTO et al', '2021', '2021-07-06'),
	(008, 'ELSEVIER', 'JUAN et al', '2021', '2022-09-01'),
	(009, 'THINK AND GROW RICH', 'NAPOLEON HILL', '1975', '2010-03-06'),
	(010, 'SEVEN HABITS OF HIGHLY EFFECTIVE PEOPLE', 'STEPHEN COVEY', '2008', '2012-09-12'),
	(011, 'WHEN I WAS YOUR MAN', 'BRUNO MARS', '2009', '2009-06-30'),
	(012, 'MIRRORS', 'JUSTIN TIMBERLAKE', '2012', '2021-11-11'),
	(013, 'SOMEBODY', 'WHITHNEY HOUSTON', '1993', '2021-11-12');


INSERT INTO library_catalogue (library_catalogue_id, item_title, author, year_of_publication, date_of_addition)
VALUES 
	(014, 'HELL IS REAL', NULL, NULL, '2020-09-03');

SELECT * FROM library_catalogue;


		--insert into 'item_type' table

INSERT INTO item_type
VALUES
	(3, 'BOOK_ITEM', 1, '4395699267');

INSERT INTO item_type
VALUES
	(4, 'BOOK_ITEM', 2, '1019674234');

INSERT INTO item_type
VALUES
	(5, 'BOOK_ITEM', 3, '1984762378'),
	(6, 'BOOK_ITEM', 4, '2310657790'),
	(7, 'DVD_ITEM', 5, NULL),
	(8, 'BOOK_ITEM', 6, '0904527761'),
	(9, 'JOURNAL_ITEM', 7, NULL),
	(10, 'JOURNAL_ITEM', 8, NULL),
	(11, 'DVD_ITEM', 9, NULL),
	(12, 'DVD_ITEM', 10, NULL),
	(13, 'OTHER_MEDIA_ITEM', 11, NULL),
	(14, 'OTHER_MEDIA_ITEM', 12, NULL),
	(15, 'OTHER_MEDIA_ITEM', 13, NULL);


SELECT * FROM item_type;


	--insert into current_status table

INSERT INTO current_status
VALUES
	(101, 'LOST/REMOVED', '2017-05-10', 2),
	(102, 'LOAN', NULL, 1),
	(103, 'OVERDUE', NULL, 3),
	(104, 'AVAILABLE', NULL, 4),
	(105, 'LOAN', NULL, 5),
	(106, 'AVAILABLE', NULL, 6),
	(107, 'LOAN', NULL, 7),
	(108, 'LOST/REMOVED', '2022-02-07', 10),
	(109, 'OVERDUE', '2010-04-30', 11),
	(110, 'LOST/REMOVED', NULL, 8),
	(111, 'OVERDUE', NULL, 13),
	(112, 'AVAILABLE', NULL, 12),
	(113, 'AVAILABLE', NULL, 9);


SELECT * FROM current_status;


	--insert into overdue_fine_repayment

INSERT INTO overdue_fine_repayment
VALUES
	(230, 10.50, 10.50, 0.00, '2022-11-01', '05:43:54.1259')
	;

INSERT INTO overdue_fine_repayment
VALUES
	(231, 12.50, 7.50, 5.00, '2020-12-27', '07:59:54.3478'),
	(232, 20.00, 1.50, 18.50, '2022-10-13', '23:26:54.1009'),
	(233, 25.00, 10.00, 15.00, '2021-03-29', '17:23:21.2101'),
	(234, 32.50, 32.50, 0.00, '2022-12-01', '20:00:54.1478');

INSERT INTO overdue_fine_repayment
VALUES
	(235, 2.50, 2.50, 0.00, '2023-03-01', '05:37:54.1419')
	;


SELECT * FROM overdue_fine_repayment


	--inserting into the loan_history table

INSERT INTO loan_history
VALUES
	('2022-02-08', '2022-02-25', '2022-05-24', 230, 'PAST', 8 ),
	('2023-01-20', '2023-02-03', NULL, 235, 'CURRENT', 15),
	('2020-04-24', '2020-05-08', '2020-09-10', 231, 'CURRENT', 7),
	('2020-05-15', '2020-05-29', '2021-02-03', 233, 'CURRENT', 12),
	('2022-01-07', '2022-01-21', '2022-08-09', 232, 'CURRENT', 14),
	('2022-01-30', '2022-01-13', '2023-01-04', 234, 'PAST', 4 );


SELECT * FROM loan_history


	--inserting into the member_loan_history table

INSERT INTO member_loan_history (user_id, loan_history_id)
VALUES
	(3,1),
	(4,2),
	(5,3),
	(6,4),
	(7,5),
	(8,6);


SELECT * FROM member_loan_history


	--inserting into the repayment_method table

INSERT INTO repayment_method (repayment_method_id, repayment_method_name, overdue_fine_id)
VALUES
	(001, 'INCOMPLETE', 230),
	(002, 'INCOMPLETE', 231),
	(003, 'INCOMPLETE', 232),
	(004, 'INCOMPLETE', 233),
	(005, 'INCOMPLETE', 234),
	(006, 'COMPLETE', 235);


SELECT * FROM repayment_method


	--inserting into the repayment_status table

INSERT INTO repayment_status (repayment_status_id, repayment_status_name, overdue_fine_id)
VALUES
	(0010, 'CARD', 230),
	(0020, 'CARD', 231),
	(0030, 'CASH', 232),
	(0040, 'CARD', 233),
	(0050, 'CARD', 234),
	(0060, 'CASH', 235);


SELECT * FROM repayment_status


/*
Q2A	
Search the catalogue for matching character strings by title. Results should be sorted with most recent 
publication date first. This will allow them to query the catalogue looking for a specific item.
*/


	--creating a user_defined function

CREATE FUNCTION match_xter(@xter AS NVARCHAR(50))
RETURNS TABLE 
AS 
RETURN
(SELECT item_title, year_of_publication
FROM library_catalogue
WHERE item_title LIKE @xter+'%')


	--executing the above code adds a table-valued function to lib_data_db
	
SELECT * 
FROM match_xter('t') ORDER BY year_of_publication DESC


	--just a basic SELECT query
SELECT item_title, year_of_publication
FROM library_catalogue
WHERE item_title LIKE '%Hunger%'
ORDER BY year_of_publication DESC;

SELECT item_title, year_of_publication
FROM library_catalogue
WHERE item_title LIKE '%The%'
ORDER BY year_of_publication DESC;


/*
Q2B
Return a full list of all items currently on loan which have a due date of less than five days from the 
current date (i.e., the system date when the query is run)
*/


	--creating a stored procedure

CREATE PROCEDURE loaned_items_u5 
AS
SELECT loan_status, item_type_id, DATEDIFF(DAY, date_due_back, GETDATE())
AS elapsed_days
FROM loan_history
WHERE loan_status LIKE '%Current%' 
AND 
DATEDIFF(DAY, date_due_back, GETDATE())<5;


EXEC loaned_items_u5;

/* 
There is only an item on loan and the due date has exceeded five days from the current date.
So, there is no item (item_type_id) with a CURRENT 'loan_status' that has a due date of less than 5 days.

This can be confirmed by running the same query but where the due date has exceeded five days from
the current date.
*/

CREATE PROCEDURE loaned_items
AS
SELECT loan_status, item_type_id, DATEDIFF(DAY, date_due_back, GETDATE())
AS elapsed_days
FROM loan_history
WHERE loan_status LIKE '%Current%' 
AND 
DATEDIFF(DAY, date_due_back, GETDATE())>5;


EXEC loaned_items;



/*	
Q2C
Insert a new member into the database
*/


	--creating a stored procedure

CREATE PROCEDURE add_member
	@tfirst_name NVARCHAR(40),
	@tmiddle_name NVARCHAR(40),
	@tlast_name NVARCHAR(40),
	@tmember_dob DATE,
	@tusername NVARCHAR(50),
	@tmember_pass NVARCHAR(50),
	@tmember_email NVARCHAR(50),
	@tmember_telephone NVARCHAR(50),
	@tmembership_date_started DATE,
	@tmembership_date_ended DATE
AS

BEGIN

	DECLARE @SALT UNIQUEIDENTIFIER=NEWID()
		--BEGIN TRY

		INSERT INTO member(first_name, middle_name, last_name, member_dob, username, 
										member_pass, salt, member_email, member_telephone, 
										membership_date_started, membership_date_ended)

		VALUES(@tfirst_name, @tmiddle_name, @tlast_name, @tmember_dob,@tusername, 
					HASHBYTES('SHA1', @tmember_pass+CAST(@salt AS NVARCHAR(36))), @salt, 
					@tmember_email, @tmember_telephone,@tmembership_date_started, 
					@tmembership_date_ended);

		--END TRY

END


	--using stored procedure to insert a new member

EXEC add_member
				@tfirst_name = 'Aaliyah',
				@tmiddle_name = NULL,
				@tlast_name ='Jamie',
				@tmember_dob = '2000-03-31',
				@tusername = 'jaaron',
				@tmember_pass = 'dixie@4ReAl&*()',
				@tmember_email = 'info@mbsterling.co.uk',
				@tmember_telephone = '01623441611',
				@tmembership_date_started = '2022-12-23',
				@tmembership_date_ended = NULL;

				SELECT * FROM member



/*
Q2D
Update the details for an existing member
*/


	--create stored procedure

CREATE PROCEDURE update_member
@user_id INT

AS
BEGIN
	UPDATE member
	SET 
	membership_date_ended='2023-03-03',
	first_name='AISHWARYA',
	middle_name = 'RAI',
	last_name = 'BACHCHAN',
	member_dob = '1973-11-1'
	WHERE user_id=@user_id
END


	--Calling the above stored procedure

EXEC update_member @user_id = 9


SELECT * FROM member



/*
Q3
The library wants be able to view the loan history, showing all previous and current loans, and including 
details of the item borrowed, borrowed date, due date and any associated fines for each loan. You should 
create a view containing all the required information.
*/


	--creating a view

CREATE VIEW loan_history_details 
AS

SELECT h.loan_status, h.date_loaned_out, h.date_due_back, h.date_returned, 
	h.overdue_fine_id, h.item_type_id, i.item_type_name,DATEDIFF(DAY, date_due_back, 
	GETDATE())AS elapsed_days, 
	DATEDIFF(DAY, date_due_back, date_returned)*0.10 AS total_overdue_fines, i.library_catalogue_id,
	c.status_name

FROM loan_history AS h INNER JOIN overdue_fine_repayment AS f

ON h.overdue_fine_id = f.overdue_fine_id

INNER JOIN item_type AS i 

ON h.item_type_id = i.item_type_id

INNER JOIN current_status AS c

ON i.library_catalogue_id = c.library_catalogue_id;


SELECT * FROM loan_history_details;




/*
Q4
Create triggers so that the current status of an item automatically updates to Available when the book is returned.
*/



SELECT c.status_name, l.date_due_back, i.item_type_id, i.item_type_name INTO book_details

FROM current_status AS c INNER JOIN item_type AS i

ON c.library_catalogue_id = i.library_catalogue_id

INNER JOIN loan_history as l

ON i.item_type_id = l.item_type_id;


SELECT * FROM book_details
	--DROP TABLE book_details;


CREATE TABLE trigger_notifications(
item_id INT PRIMARY KEY,
item_name NVARCHAR(30) NOT NULL,
item_status NVARCHAR(30) NOT NULL,
);

SELECT * FROM trigger_notifications;
	--DROP TABLE trigger_notifications;




DROP TRIGGER IF EXISTS available_item;
	
	GO

CREATE TRIGGER available_item ON book_details
		AFTER UPDATE
AS 
BEGIN

		SET NOCOUNT ON;
		DECLARE @item_id INT
		DECLARE @item_name NVARCHAR(30)
		DECLARE @item_status NVARCHAR(30)
		
		SELECT @item_id = INSERTED.item_type_id
		FROM INSERTED

		SELECT @item_name = INSERTED.item_type_name
		FROM INSERTED

		IF UPDATE(status_name)
		SET @item_status = 'AVAILABLE'
		
		INSERT INTO trigger_notifications 
		VALUES (@item_id, @item_name, @item_status);

END;


UPDATE book_details SET status_name = 'AVAILABLE' WHERE item_type_id = 7;
UPDATE book_details SET status_name = 'AVAILABLE' WHERE item_type_id = 8;
UPDATE book_details SET status_name = 'AVAILABLE' WHERE item_type_id =15;
	




/*
Q5
You should provide a function, view, or SELECT query which allows the library to identify the total number
of loans made on a specified date.
*/


	--a function which allows the library to identify the total number of loans per day

CREATE FUNCTION total_loans(@out_date DATE)
RETURNS TABLE
AS

RETURN

(SELECT COUNT(date_loaned_out) AS total_loan FROM loan_history 
WHERE date_loaned_out=@out_date)


	--executing the function
SELECT *
FROM total_loans('2022-01-07')


/*SELECT *
FROM loan_history*/

