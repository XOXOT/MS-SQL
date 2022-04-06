------------------6-2��
---------������� CTE

--WITH ���� ���� ���̺� ��(�� �̸�, ���̸� , ...) AS (���� ������ ) SELECT *�ƴϸ� ���� �� ���� ORDER BY ~~ 

USE sqlDB;
GO
SELECT userID AS [�����], SUM(price* amount) AS [�ѱ��ž�]
	FROM buyTbl GROUP BY userID ORDER BY SUM(price* amount) DESC; 
--�̷��� �ϸ� ����? �ϴϱ�

WITH abc(userID, TOTAL)
AS
(SELECT userID AS [�����], SUM(price* amount) AS [�ѱ��ž�]
	FROM buyTbl GROUP BY userID) 
--SELECT *FROM abc ORDER BY TOTAL DESC; --������ ���̰� �ʹٸ� �Ʒ��� ���� �� ���� SELECT �Լ����� ������ �ٿ���
SELECT userID AS [�����],TOTAL AS [�ѱ��ž�] FROM abc ORDER BY TOTAL DESC;

-- �� ���� ���� ���� ū Ű�� �Ѹ� ���� �� �� ������� Ű�� ��� ���ϱ�

--1. �� ���� ���� ���� ū Ű�� �̴� ����
SELECT addr, MAX(height) FROM userTbl GROUP BY addr;

--2. ���� �������� WITH������ �ٲٱ� 
WITH cte_table(addr, maxHeight)
AS
(SELECT addr, MAX(height) FROM userTbl GROUP BY addr);

--3. Ű�� ����� ���ϴ� ���� �ۼ�
SELECT AVG(maxHeight) FROM cte_table;

--4. 2�ܰ�� 3�ܰ� ���� ��ġ�� (����� �Ǽ��� ����� ���� 1.0 ����)
WITH cte_table(addr, maxHeight)
AS
(SELECT addr, MAX(height) FROM userTbl GROUP BY addr)
SELECT AVG(maxHeight*1.0) AS [�� ������ �ְ�Ű�� ���] FROM cte_table;
-- CTE�� �Ļ� ���̺��� ������ ������ ���� �Ҹ���

----�ߺ� CTE

--WITH AAA(�÷���) AS (AAA�� ������), BBB(�÷���) AS (BBB�� ������), CCC(�÷���) AS (CCC�� ������) SELECT * FROM [AAA �Ǵ� BBB �Ǵ� CCC]
--CCC������������ AAA�� BBB�� ������ �� ������ AAA�� BBB�� CCC �������� ������ �� ����.
WITH 
AAA(userID, total) 
	AS 
	(SELECT userID, SUM(price*amount) FROM buyTbl GROUP BY userID), --USER ID�� ���� �� ���ž� ���̺� 
BBB(sumtotal) 
	AS 
	(SELECT SUM(total) FROM AAA), --ID�� ������� ��ü �� ���ž� 
CCC(sumavg) 
	AS 
	(SELECT sumtotal / (SELECT count(*) FROM buyTbl) FROM BBB) -- �� ���ž��� ��� 
SELECT * FROM CCC; 

---------����� CTE
-- ������̶� �ڱ��ڽ��� �ݺ������� ȣ���Ѵٴ� �ǹ̸� ����. 
-- ���� ���� ������� ���� ȸ���� �μ���� ������ ����
--����
--WITH CTE_���̺��̸�(���̸�) AS (<������1: SELECT * FROM ���̺�A> UNION ALL <������2 : SELECT * FROM ���̺�A JOIN CTE_���̺� �̸�>) SELECT * FROM CTE_���̺��̸�;
--<������1>�� ��Ŀ ���
--<������2>�� ��� ���
--1. <������1>�� �����ϸ� ��ü �帧�� ���� ȣ�⿡ �ش� �׸��� ������ ������ 0���� �ʱ�ȭ
--2. <������2>�� �����ϸ� ����+1�� ������Ű�� SELECT�� ����� �� ���� �ƴ϶�� 'CTE_���̺��̸�'�� �ٽ� ��������� ȣ��
--3. 2���� ��� �ݺ��ϰ� SELECT�� ����� �ƹ� �͵� ���ٸ� ������� ȣ���� �ߴܽ�Ŵ
--4. �ܺ��� SELECT ���� �����ؼ� �� �ܰ迡�� ������ ���(UNION ALL)�� �����´�. 

-----�ǽ� 
USE sqlDB;
CREATE TABLE empTbl (emp NCHAR(3), manager NCHAR(3), department NCHAR(3));
GO

INSERT INTO empTbl VALUES('������', NULL, NULL);
INSERT INTO empTbl VALUES('���繫', '������', '�繫��');
INSERT INTO empTbl VALUES('�����', '���繫', '�繫��');
INSERT INTO empTbl VALUES('�̺���', '���繫', '�繫��');
INSERT INTO empTbl VALUES('��븮', '�̺���', '�繫��');
INSERT INTO empTbl VALUES('�����', '�̺���', '�繫��');
INSERT INTO empTbl VALUES('�̿���', '������', '������');
INSERT INTO empTbl VALUES('�Ѱ���', '�̿���', '������');
INSERT INTO empTbl VALUES('������', '������', '������');
INSERT INTO empTbl VALUES('������', '������', '������');
INSERT INTO empTbl VALUES('������', '������', '������');

WITH empCTE(empName, mgrName, dept, level)
AS
(
 SELECT emp, manager, department, 0
	FROM empTbl
	WHERE manager IS NULL -- ����� ���� ����� �ٷ� ���� (��Ŀ���)
 UNION ALL
 SELECT empTbl.emp, empTbl.manager, empTbl.department, empCTE.level+1
  FROM empTbl INNER JOIN empCTE -- empName, mgrName�� ��ġ�ϴ� �ͳ��� levelȭ 
	  ON empTbl.manager = empCTE.empName 
)
SELECT * FROM empCTE ORDER BY dept, level;

----Ʈ��ȭ 

WITH empCTE(empName, mgrName, dept, level)
AS
(
 SELECT emp, manager, department, 0
	FROM empTbl
	WHERE manager IS NULL -- ����� ���� ����� �ٷ� ���� (��Ŀ���)
 UNION ALL
 SELECT empTbl.emp, empTbl.manager, empTbl.department, empCTE.level+1
  FROM empTbl INNER JOIN empCTE -- empName, mgrName�� ��ġ�ϴ� �ͳ��� levelȭ 
	  ON empTbl.manager = empCTE.empName 
)
SELECT REPLICATE(' ��',level) + empName AS [�����̸�], dept [�����μ�]  --REPLICATE(����, ����) �Լ��� �ش� ���ڸ� ������ ŭ �ݺ� ��, LEVEL ������ŭ ���� �ݺ�
  FROM empCTE ORDER BY dept, level; 

-- ������� ������ ����/����/���� �޸� ���
WITH empCTE(empName, mgrName, dept, level)
AS
(
 SELECT emp, manager, department, 0
	FROM empTbl
	WHERE manager IS NULL 
 UNION ALL
 SELECT empTbl.emp, empTbl.manager, empTbl.department, empCTE.level+1
  FROM empTbl INNER JOIN empCTE 
	  ON empTbl.manager = empCTE.empName 
	WHERE level < 2 --������ WHERE���� �̿��� ���� 2���� ���� ������ ���
)
SELECT REPLICATE(' ��',level) + empName AS [�����̸�], dept [�����μ�]  
  FROM empCTE ORDER BY dept, level; 



------------INSERT
-- INSERT [INTO] <���̺� [(��1, ��2, ...)] VALUES (��1, ��2, ...)
-- WITH CTE_���̺��()... INSERT [INTO] <CTE_���̺��> ...

USE tempdb;
CREATE TABLE testTbl1 (id int, userName nchar(3), age int);
GO
INSERT INTO testTbl1 VALUES (1, 'ȫ�浿', 25);

--���� ID�� �̸��� �Է��ϰ� ���̸� �Է��ϰ� ���� �ʴٸ�? ������ �ְ� ������ ��
INSERT INTO testTbl1(id,userName) VALUES (2, '����');

--���� ������ �ٲ㼭 �Է��ϰ� �ʹٸ�? ���̸��� �Է��� ������ ���� �����ϸ� ��
INSERT INTO testTbl1(userName,age,id) VALUES ('�ʾ�', 26, 3);

-------------�ڵ����� �����ϴ� IDENTITY
--IDENTITY�� �ڵ����� 1���� �����ϴ� ���� �Է����ش�. 
--DEFAULT ���� �������ָ� �������� ���� �� 
USE tempdb;
CREATE TABLE testTbl2
(id int IDENTITY,
 userName nchar(3),
 age int,
 nation nchar(4) DEFAULT '���ѹα�');
GO
INSERT INTO testTbl2 VALUES ('����', 25, DEFAULT);

--������ IDENTITY ���� �Է��ϰ� �ʹٸ�?
SET IDENTITY_INSERT testTbl2 ON;
GO
INSERT INTO testTbl2(id,userName,age,nation) VALUES (11, '����', 18, '�븸');

-- IDENTITY_INSERT�� ON���� ������ ���̺��� �� �Է��� ���� ��������� �����ؾ���
INSERT INTO testTbl2 VALUES (12, '�糪', 20, '�Ϻ�'); --����

-- IDENTITY_INSERT�� OFF�� �����ϰ� �Է��ϸ�, ID���� �ִ밪 + 1���� �ڵ� �Է�
SET IDENTITY_INSERT testTbl2 OFF;
GO
INSERT INTO testTbl2 VALUES ('�̳�', 21, '�Ϻ�');
SELECT* FROM testTbl2;

--���� �̸��� ��Ծ��� ����? 
EXECUTE sp_help testTbl2;

--Ư�� ���̺� ������ IDENTITY ���� Ȯ���Ϸ���?
SELECT IDENT_CURRENT('testTbl2'); -- ������ IDENTITY ��
SELECT @@IDENTITY; --���� �ֱٿ� ������ ID ��

-------------SEQUENCE 

USE tempdb;
CREATE TABLE testTbl3
(id int,
 userName nchar(3),
 age int,
 nation nchar(4) DEFAULT '���ѹα�');
 GO

CREATE SEQUENCE idSEQ
	START WITH 1 --���۰�
	INCREMENT BY 1; --������
GO

INSERT INTO testTbl3 VALUES (NEXT VALUE FOR idSEQ, '����', 25, DEFAULT);

--SEQUENCE���� ������ ID���� �ٸ� ���� �Է��ϰ� �ʹٸ�?
INSERT INTO testTbl3 VALUES (11, '����', 18, '�븸');
GO
ALTER SEQUENCE idSEQ
	RESTART WITH 12; -- ���� ���� �ٽ� ���� 
GO
INSERT INTO testTbl3 VALUES (NEXT VALUE FOR idSEQ,'�̳�', 21, '�Ϻ�');
SELECT* FROM testTbl3;

--�������� Ȱ���ϸ� Ư�� ������ ���� ����ؼ� �ݺ��ؼ� �Է��� �� �ִ�. 
--EX)100, 200, 300 �ݺ� 
CREATE TABLE testTbl4 (id int);
GO
CREATE SEQUENCE cycleSEQ
	START WITH 100
	INCREMENT BY 100
	MINVALUE 100 -- �ּҰ�
	MAXVALUE 300 -- �ִ밪 
	CYCLE;		 -- �ݺ�����
GO
INSERT INTO testTbl4 VALUES (NEXT VALUE FOR cycleSEQ);
INSERT INTO testTbl4 VALUES (NEXT VALUE FOR cycleSEQ);
INSERT INTO testTbl4 VALUES (NEXT VALUE FOR cycleSEQ);
INSERT INTO testTbl4 VALUES (NEXT VALUE FOR cycleSEQ);
GO 
SELECT* FROM testTbl4;
 
--�������� DEFAULT�� �Բ� ����ϸ� IDENTITY�� ���������� ���� ǥ�⸦ �����ص� �ڵ����� �Է��ϰ� �� �� �ִ�.
CREATE SEQUENCE autoSEQ
	START WITH 1
	INCREMENT BY 1;
GO
CREATE TABLE testTbl5 (id int DEFAULT(NEXT VALUE FOR autoSEQ), userName nchar(3));
GO
INSERT INTO testTbl5(userName) VALUES ('����');
INSERT INTO testTbl5(userName) VALUES ('����');
INSERT INTO testTbl5(userName) VALUES ('�̳�');
INSERT INTO testTbl5(userName) VALUES ('����'),('ȫ�浿'),('���̸�'); -- SQL 2008���� �̷��� 3���� �����͸� �� �������� �Է��� �� �ִ�.  
GO
SELECT* FROM testTbl5;
GO

------------------�뷮�� ���õ����� ����
-- INSERT INTO ���̺��̸�(���̸�1, ���̸�2) SELECT ��;
USE tempdb;
CREATE TABLE testTbl6 (id int, Fname nvarchar(50), Lname nvarchar(50));
GO
INSERT INTO testTbl6
  SELECT BusinessEntityID, FirstName, LastName
	FROM AdventureWorks2016CTP3.Person.Person;

-- ���̺� ���Ǳ��� �����ϰ� �ʹٸ� SELECT INTO ������ �̿�
USE tempdb;
SELECT BusinessEntityID AS id, FirstName AS Fname, LastName AS Lname -- AS�� �ٷ� ���� �ٿ��� 
	INTO testTbl7
	FROM AdventureWorks2016CTP3.Person.Person;
GO

------------------UPDATE
--UPDATE ���̺��̸� SET ��1 = ��1, ��2 = ��2 .. WHERE ����;

UPDATE testTbl6
	SET Lname = '����'
	WHERE Fname = 'Kim';
-- 10���� ���� ������ �޾Ҵµ� WHERE ���� ���԰� �����ϸ� ��ü ���� Lname�� ��� �������� ����ȴ�. ����

-- ���� ��ü ���̺��� ������ �����ϰ� ���� �� WHERE�� ������ �� �ִµ�, ���� ��� ���� ���̺��� ������ �ܰ��� ��� 1.5�� �λ�Ǿ��ٸ�
USE sqlDB;
UPDATE buyTbl SET price = price * 1.5;
GO

------------------DELETE 
-- DELETE ���̺� �̸� WHERE ����; //WHERE���� �����Ǹ� ��ü ���̺��� �����ȴ�. 
USE tempdb;
DELETE testTbl6 WHERE Fname = 'Kim';

--���� ��� �����ҷ���? -- TOP()���� �ȴ�. 
USE tempdb;
DELETE TOP(5) testTbl6 WHERE Fname = 'Kim';

--���� ��
USE tempdb;
SELECT * INTO bigTbl1 FROM AdventureWorks2016CTP3.Sales.SalesOrderDetail;
SELECT * INTO bigTbl2 FROM AdventureWorks2016CTP3.Sales.SalesOrderDetail;
SELECT * INTO bigTbl3 FROM AdventureWorks2016CTP3.Sales.SalesOrderDetail;
GO

DELETE FROM bigTbl1;
GO
DROP TABLE bigTbl2; -- �� ������ ���̺� ��ü�� �ʿ� ���� ��� DROP���� ����
GO
TRUNCATE TABLE bigTbl3; -- �� �������� ���� ������ ���̺��� ������ ���ܳ��� ���� �� TRUNCATE�� ����
GO

------------------���Ǻ� ������ ���� MERGE
-- ���(����)�� ���� INSERT, UPDATE, DELETE�� ����
-- �߿��� ���̺��� �Ǽ��ϸ� �ȵǴ� INSERT, UPDATE, DELETE�� ���� ����ϸ� �ȵ�. 
-- �׷��� ȸ���� ����, ����, Ż�� ����� �������̺� INSERT ������ ȸ���� ��������� �Է� (��������� �ű԰���, �ּҺ���, ȸ��Ż��)
-- ���� ���̺��� ���� ������ 1���ϸ��� MERGE ������ �̿��ؼ� �������̺��� �ű԰����̸� ��� ���̺� ���� ���, �ּҺ����̸� ��� ���̺� �ּ� ����, Ż��� ȸ������

--1. ������̺� ���� �� ������ �Է�
USE sqlDB;
SELECT userID, name, addr INTO memberTBL FROM userTbl;
SELECT * FROM memberTBL;

--2. �������̺��� ����/ 1���� �ű԰���, 2���� �ּҺ���, 2���� ȸ��Ż��
CREATE TABLE changeTBL
(changeType NCHAR(4), --���� ����
 userID     CHAR(8),
 name       NVARCHAR(10),
 addr		NCHAR(2));
 GO
 INSERT INTO changeTBL VALUES
('�ű԰���', 'CHO', '�ʾ�', '�̱�'),
('�ּҺ���', 'LSG', NULL, '����'),
('�ּҺ���', 'LJB', NULL, '����'),
('ȸ��Ż��', 'BBK', NULL, NULL),
('ȸ��Ż��', 'SSK', NULL, NULL);

--3. �������� �����ٰ� �����ϰ�, ������� ���� ���ؼ� ���� ������̺��� �����͸� ���� 
MERGE memberTBL AS M -- ����� ���̺�(TARGET ���̺�)
 USING changeTBL AS C -- ������ ������ �Ǵ� ���̺� (SOURCE ���̺�)
 ON M.userID = C.userID -- USERID�� �������� �� ���̺��� ��
 -- TARGET ���̺� SOURCE ���̺��� ���� ����, ������ �ű԰����̶�� ���ο� ���� �߰��Ѵ�.
 WHEN NOT MATCHED AND changeType = '�ű԰���' THEN
	INSERT (userID, name, addr) VALUES(C.userID, C.name, C.addr)
-- TARGET ���̺� SOURCE ���̺��� ���� �ְ�, ������ �ּҺ����̶�� �ּҸ� �����Ѵ�.
 WHEN MATCHED AND changeType = '�ּҺ���' THEN
	UPDATE SET M.addr = C.addr
-- TARGET ���̺� SOURCE ���̺��� ���� �ְ�, ������ ȸ��Ż���� ���� �����Ѵ�.
 WHEN MATCHED AND changeType = 'ȸ��Ż��' THEN
	DELETE;
GO
SELECT *FROM memberTBL;

--MERGE ����� ���̺� AS ���� USING ������ ���� ���̺� AS ���� ON ����� ���̺� ����.���� �÷��� = ���� ���� ���̺� ����.�÷���
--WHEN NOT MATCHED �̰ų� MATCHED AND ���ǹ� THEN INSERT/UPDATE/DELETE  
