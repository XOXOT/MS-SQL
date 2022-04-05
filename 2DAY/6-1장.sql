--6��

------------------------------�����ͺ��̽� ���� ������ USE 
USE AdventureWorks2016CTP3;

--������ �������� SELECT ���̸� FROM ���̺� �̸� WHERE ���� 
SELECT *FROM HumanResources.Employee;
--��Ģ�����δ� 
SELECT *FROM AdventureWorks2016CTP3.HumanResources.Employee;
--��Ű�� �̸����� �����Ѵٸ�?
SELECT *FROM Employee; --����
--�ʿ�� �ϴ� ���� ��������
SELECT Name FROM HumanResources.Department;
--���� ���� ���� ��������
SELECT Name,GroupName FROM HumanResources.Department;


-----------------------------�� �����ͺ��̽��� �̸� �� ö�ڰ� ��ﳪ�� ���� �� ��ȸ���
--�� �ν��Ͻ��� ������ ���̽� ��ȸ
EXECUTE sp_helpdb; --EXEC�� ���� �� 
--Ư�� ������ ���̽� ���� ����
EXECUTE sp_helpdb AdventureWorks2016CTP3;
USE [AdventureWorks2016CTP3];
--���� ������ ���̽��� �ִ� ���̺� ���� ��ȸ
EXECUTE sp_tables @table_type = "'TABLE'";
--HumanResources.Department ���̺��� ���� ������ �ִ��� Ȯ��(COLUMN_NAME Ȯ��)
EXECUTE sp_columns @table_name = 'Department', @table_owner = 'HumanResources';
--���������� ������ ��ȸ
SELECT Name, GroupName FROM HumanResources.Department;
--��Ī ����� (�� �̸� ���������� ����� ���� ����)
SELECT DepartmentID AS �μ���ȣ, Name �μ��̸�, [�׷��̸�] = GroupName 
FROM HumanResources.Department;

---------------------------------�ǽ�
--���̺� ����
 USE tempdb;
 GO
 CREATE DATABASE sqlDB;
 GO
------------------------------------------------------------------
-- TINYINT(M) [ �ɼ� UNSIGNED , ZEROFILL ] �ڡ�
--: ���������� �� 1Byte ��������� �����ϴ� ������ Ÿ������ -128���� 127 ������ ���ڸ� �����ϱ� ���� ������ Ÿ���̴�. UNSIGNED �ɼ��� �����ϸ� 0���� 255������ ���ڸ� �����Ѵ�.

--SMALLINT(M) [ �ɼ� UNSIGNED , ZEROFILL ]
--: ���������� �� 2Byte ��������� �����ϴ� ������ Ÿ������ -32768���� 32767 ������ ���ڸ� �����ϱ� ���� ������ Ÿ���̴�. UNSIGNED �ɼ��� �����ϸ� 0���� 65535������ ���ڸ� �����Ѵ�.

--MEDIUMINT(M) [ �ɼ� UNSIGNED , ZEROFILL ]
--: ���������� �� 3Byte ��������� �����ϴ� ������ Ÿ������ -8388608���� 8388607������ ���ڸ� �����ϱ� ���� ������ Ÿ���̴�. UNSIGNED �ɼ��� �����ϸ� 0���� 16777215������ ���ڸ� �����Ѵ�.

--INT(M) [ �ɼ� UNSIGNED , ZEROFILL ] �ڡڡ�
--: ���������� �� 4Byte ��������� �����ϴ� ������ Ÿ������ INTEGER ��� ����Ѵ�. -2147483648���� 2147483647 ������ ���ڸ� �����ϱ� ���� ������ Ÿ������ UNSIGNED �ɼ��� �����ϸ� 0���� 4294967295������ ���ڸ� �����Ѵ�.
------------------------------------------------------------------
 USE sqlDB;
 --DROP DATABASE sqlDB;
 CREATE TABLE userTbl -- ȸ�����̺�
 (userID CHAR(8) NOT NULL PRIMARY KEY, --����� ���̵�
  name   NVARCHAR(10) NOT NULL, -- �̸�
  birthYear INT NOT NULL, --����⵵
  addr NCHAR(2) NOT NULL, --����(���, ����, �泲 ������ 2���ڸ� �Է�)
  mobile1 CHAR(3), -- �޴����� ����(011, 016, 017, 019, 010 ��)
  mobile2 CHAR(8), -- �޴����� ������ ��ȭ��ȣ(������ ����)
  height SMALLINT, --Ű
  mDate DATE -- ȸ��������
  );
  GO
  CREATE TABLE buyTbl --ȸ�� ���� ���̺�
  (num INT IDENTITY NOT NULL PRIMARY KEY, -- ����(IDENTITY�� �ڵ� ���� ������)(PK)
   userID CHAR(8) NOT NULL --���̵�(FK)
   FOREIGN KEY REFERENCES userTbl(userID),
   prodName NCHAR(6) NOT NULL, --��ǰ��
   groupName NCHAR(4), --�з�
   price INT NOT NULL, --�ܰ�
   amount SMALLINT NOT NULL -- ����
   );
   GO

-- ������ �Է�
INSERT INTO userTbl VALUES('LSG', '�̽±�', 1987, '����', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTbl VALUES('KBS', '�����', 1979, '�泲', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTbl VALUES('KKH', '���ȣ', 1971, '����', '019', '3333333', 177, '2007-7-7');
INSERT INTO userTbl VALUES('JYP', '������', 1950, '���', '011', '4444444', 166, '2009-4-4');
INSERT INTO userTbl VALUES('SSK', '���ð�', 1979, '����',  NULL,  NULL,     186, '2013-12-12');
INSERT INTO userTbl VALUES('LJB', '�����', 1963, '����', '016', '6666666', 182, '2009-9-9');
INSERT INTO userTbl VALUES('YJS', '������', 1969, '�泲',  NULL,  NULL,     170, '2005-5-5');
INSERT INTO userTbl VALUES('EJW', '������', 1972, '���', '011', '8888888', 174, '2014-3-3');
INSERT INTO userTbl VALUES('JKW', '������', 1965, '���', '018', '9999999', 172, '2010-10-10');
INSERT INTO userTbl VALUES('BBK', '�ٺ�Ŵ', 1973, '����', '010', '0000000', 176, '2013-5-5');
GO
SELECT * FROM userTbl;

INSERT INTO buyTbl VALUES('KBS', '�ȭ',  NULL, 30, 2);
INSERT INTO buyTbl VALUES('KBS', '��Ʈ��', '����',1000,1);
INSERT INTO buyTbl VALUES('JYP', '�����', '����',200,1);
INSERT INTO buyTbl VALUES('BBK', '�����', '����',200,5);
INSERT INTO buyTbl VALUES('KBS', 'û����', '�Ƿ�', 50, 3);
INSERT INTO buyTbl VALUES('BBK', '�޸�', '����',80,10);
INSERT INTO buyTbl VALUES('SSK',   'å',   '����',15, 5);
INSERT INTO buyTbl VALUES('EJW',   'å',   '����',15, 2);
INSERT INTO buyTbl VALUES('EJW', 'û����', '�Ƿ�',50, 1);
INSERT INTO buyTbl VALUES('BBK', '�ȭ', NULL, 30, 2);
INSERT INTO buyTbl VALUES('EJW',   'å',   '����',15, 1);
INSERT INTO buyTbl VALUES('BBK', '�ȭ', NULL, 30, 2);
GO
SELECT * FROM buyTbl;

--���(��ɾ�)
USE tempdb;
BACKUP DATABASE sqlDB TO DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH INIT;

------------------------WHERE
--SELECT ���̸� FROM ���̺� �̸� WHERE ���ǽ�
USE sqlDB;
SELECT * FROM userTbl; -- ��ü ��ȸ
SELECT * FROM userTbl WHERE name = '���ȣ'; -- �̸��� ���ȣ�� ��� ��ȸ

--1970�� ���Ŀ� ����̰� Ű�� 182 �̻��� ����� ���̵�� �̸��� ��ȸ
SELECT userID,name FROM userTbl WHERE birthYear > = 1970 AND height > =182;
--1970�� ���Ŀ� ����߰ų� Ű�� 182 �̻��� ����� ���̵�� �̸��� ��ȸ
SELECT userID,name FROM userTbl WHERE birthYear > = 1970 OR height > =182;

------------------------BETWEEN AND, IN(), LIKE 
--BETWEEN AND (�������� ���� ������ ���� ��츸 ����)
SELECT name �̸�, height ���� FROM userTbl WHERE height > = 180 AND height <=183;
SELECT name �̸�, height ���� FROM userTbl WHERE height BETWEEN 180 AND 183;
--�� �� �������� ���� �ǹ�

--IN() - �������� ���� �ƴ� ��� 
SELECT name �̸�, addr �ּ� FROM userTbl WHERE addr = '�泲' OR addr = '����' OR addr = '���';
SELECT name �̸�, addr �ּ� FROM userTbl WHERE addr IN ('�泲','����','���');
--�� �� �������� ���� �ǹ�

--LIKE (���ڿ� ���� �˻�)
SELECT name �̸�, height ���� FROM userTbl WHERE name LIKE '��%'; --�ձ��ڰ� ������ �����ϴ� �̸��� ������ �̸� �� ���� �÷��� ���� ��� 
SELECT name �̸�, height ���� FROM userTbl WHERE name LIKE '_����'; -- �տ� �ѱ��ڴ� �ƹ��ų� �͵� �����ϸ� �̸��� ������ ��� ���
-- %(�����), _(�ѱ���)


----���� ������
SELECT name �̸�, height ���� FROM userTbl WHERE height > 177; --�� 177�� ���� ���ȣ�� ���ڷ� ���� �ʰ� �������� ���� ���
SELECT name �̸�, height ���� FROM userTbl WHERE height > (SELECT height ���� FROM userTbl WHERE name = '���ȣ');
--������ �泲 ����� Ű���� ũ�ų� ���� ����� ���� 
SELECT name �̸�, height ����, addr �ּ� FROM userTbl WHERE height >= (SELECT height ���� FROM userTbl WHERE addr = '�泲'); --����
-- ���� ���������� ���� �� �� �̻��� ������ �� �� �̻��� ��ȯ�ϱ� ������ ������ �߻������� ANY�� �����
----ANY (���� ������ ���� ���� ��� �� �� ������ �����ص� �� ���) - �泲 ��� Ű 170, 173 ���� ū ��� �� ���
SELECT name �̸�, height ����, addr �ּ� FROM userTbl WHERE height >= ANY (SELECT height ���� FROM userTbl WHERE addr = '�泲');
 
 --ALL (���� ������ ���� ���� ��� ��� ����) -�泲 ��� �� ���� ū ������� Ű�� �� Ŀ���� �� 170���� ũ�� 173���ٵ� Ŀ����
 SELECT name �̸�, height ����, addr �ּ� FROM userTbl WHERE height >= ALL (SELECT height ���� FROM userTbl WHERE addr = '�泲');

 -- ANY�� SOME�� ������ �ǹ� 
 SELECT name �̸�, height ����, addr �ּ� FROM userTbl WHERE height =SOME (SELECT height ���� FROM userTbl WHERE addr = '�泲');
 SELECT name �̸�, height ����, addr �ּ� FROM userTbl WHERE height = ANY (SELECT height ���� FROM userTbl WHERE addr = '�泲');
 -- =ANY�� IN�� ���� �ǹ� 
 SELECT name �̸�, height ����, addr �ּ� FROM userTbl WHERE height IN (SELECT height ���� FROM userTbl WHERE addr = '�泲');


----ORDER BY (���ϴ� ������� ����) ORDER BY���� �������� �� �ڿ� �;��� 
-- �⺻ ��������(ASC) 
SELECT name, mdate FROM userTbl ORDER BY mdate;
-- �������� (DESC)
SELECT name, mdate FROM userTbl ORDER BY mdate DESC;


------------------------DISTINCT, TOP(N), TABLESAMPLE

-- DISTINCT(�ߺ� ����)
SELECT addr FROM userTbl;
SELECT addr FROM userTbl ORDER BY addr;
SELECT DISTINCT addr FROM userTbl ORDER BY addr; -- �ߺ��� �����Ͽ� ������ 

-- TOP(N) ���� � �ุ ��� 
USE AdventureWorks2016CTP3;
SELECT CreditCardID FROM Sales.CreditCard
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;
--TOP�� �տ� ���� 
SELECT TOP(10) CreditCardID FROM Sales.CreditCard
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;
--TOP ������ ����, ���� �� ���������� ��� ����
SELECT TOP(SELECT COUNT(*)/100 FROM Sales.CreditCard) CreditCardID FROM Sales.CreditCard 
-- COUNT(*)�� ��ü ���� ������ ��ȯ�ϰ� �̰��� 100���� ���� ������ 1%�� ���ڴٴ� ��
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;

--TOP()PERCENT - ���� 0.1%�� ��� 
SELECT TOP(0.1)PERCENT CreditCardID, ExpYear, ExpMonth
	FROM Sales.CreditCard 
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;

--���� ���� 0.1%�� ����ߴµ� 100���� 1��, 99���� 1�� 98���� 5���̶�� 98�� 5�� �� ����ϰ� �ؾ��Ѵٸ�
-- ������ ��� ���� ������ ���� �ִٸ�, N%�� �Ѵ��� ����ϴ� WITH TIES �������� �ִ�,
SELECT TOP(0.1)PERCENT WITH TIES CreditCardID, ExpYear, ExpMonth
	FROM Sales.CreditCard 
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;

------- ������ ���ø� (TABLESAMPLE) 
-- �������� ������ ���� �����͸� ���� (�ҷ��� ���� ������ ������ �Ұ�)
USE AdventureWorks2016CTP3;
SELECT * FROM Sales.SalesOrderDetail TABLESAMPLE(5 PERCENT);

--�ʹ� ���� ������ ������ ��� TOP�� Ȱ���ϸ� �ȴ�. 
SELECT TOP(5000) * FROM Sales.SalesOrderDetail TABLESAMPLE(5 PERCENT);

------------------------ OFFSET�� PATCH 
------OFFSET(�ǳʶٱ�)
---���̰� ���� 4�� �ǳʶٱ� 
USE sqlDB;
SELECT userID, name, birthYear FROM userTbl
	ORDER BY birthYear
	OFFSET 4 ROWS;

---��µ� ���� ���� ���� (4���� �ǳʶٰ� ��µ� ������ 3�������� ����϶�)
SELECT userID, name, birthYear FROM userTbl
	ORDER BY birthYear
	OFFSET 4 ROWS
	FETCH NEXT 3 ROWS ONLY; --TOP�� OFFSET ������ ���� �� �� ���� ������ �̰��� ����� 


------------------------ SELECT INTO
-- ���̺��� �����ؼ� ����� ���
--SELECT ������ �� INTO ���ο� ���̺�� FROM �������̺�� 
-- ������ PK�� FK ���� ���� ������ ������� �ʴ´�. 

USE sqlDB;
SELECT * INTO buyTbl2 FROM buyTbl; --����
SELECT * FROM buyTbl2; -- ��ȸ

--�Ϻ� ���� ���� ����
SELECT userID, prodName INTO buyTbl3 FROM buyTbl; --����
SELECT * FROM buyTbl3; -- ��ȸ

------------------------ GROUP BY
-- ORDER BY�� �ߺ��� ���� ID���� �� ��������  
USE sqlDB;
SELECT userID, amount FROM buyTbl ORDER BY userID;

--���� �����Լ��� GROUP BY �Լ��� ����� (���� �Լ� �ʿ�)
SELECT userID AS [����� ���̵�], SUM(amount) AS[�� ���� ����] FROM buyTbl GROUP BY userID;

--���� �Լ� (AVG, MIN, MAX, COUNT, COUNT_BIG(������ ���� ����� bigint��) STDEV(ǥ������) VAR(�л�)
SELECT AVG(amount) AS[��� ���� ����] FROM buyTbl; -- ��� 2.9166�̴�
--����
SELECT AVG(amount*1.0) AS[��� ���� ����] FROM buyTbl; --�̷��� �Ҽ����� �����ְų�
SELECT AVG(CAST(amount AS DECIMAL(10,6))) AS[��� ���� ����] FROM buyTbl; 
--CAST()/CONVERT()�Լ��� �̿��Ͽ� ��� ���⼭ DECIMAL(10,6)�� ��ü 10�ڸ� �� �Ҽ��� 6�ڸ� Ȯ���Ѵٴ� �ǹ�

--���� ū Ű�� ���� ���� Ű�� ȸ�� �̸��� Ű�� ����ϴ� ����
SELECT name, height FROM userTbl WHERE height = (SELECT MAX(height)FROM userTbl) OR  height = (SELECT MIN(height)FROM userTbl);
SELECT name, height FROM userTbl WHERE height IN ((SELECT MAX(height)FROM userTbl) , (SELECT MIN(height)FROM userTbl));
--���� �ǹ� 

--�޴����� �ִ� ������� �� ī��Ʈ
SELECT COUNT(mobile1)AS[�޴����� �ִ� �����] FROM userTbl;

--COUNT ���� �˾ƺ��� 
--�������� ���� �� TSQL_Duration ���� �� ����
USE AdventureWorks2016CTP3;
GO
SELECT * FROM Sales.Customer; --Duration�� 200, 400 �Ѿ 
GO
SELECT COUNT(*) FROM Sales.Customer; --Duration�� 2�� 1 �ۿ� �ȵǴµ� 
GO

--�ӽ����̺��� #, ## ���� 

------------------------ Having 
--����ں� �� ���ž� 
USE sqlDB;
GO 
SELECT userID AS[�����], SUM(price*amount) AS [�� ���ž�]
	FROM buyTbl
	GROUP BY userID;

-- �� ���ž��� 1000 �̻��� ����ڿ��Ը� ����ǰ�� �����ҷ���?
SELECT userID AS[�����], SUM(price*amount) AS [�� ���ž�]
	FROM buyTbl
	WHERE SUM(price*amount) > 1000 --�����Լ��� WHERE �� �� ����
	GROUP BY userID;

--����...
SELECT userID AS[�����], SUM(price*amount) AS [�� ���ž�]
	FROM buyTbl
	GROUP BY userID
	HAVING SUM(price*amount) >1000;

--�߰������� �� ���ž��� ���� ������� ����ҷ��� 
--Having ��!
--WHERE�� ����ϰ� ������ �����ϴ� �������� �����Լ��� ���ؼ� ������ �����ϴ� ������ 
SELECT userID AS[�����], SUM(price*amount) AS [�� ���ž�]
	FROM buyTbl
	GROUP BY userID
	HAVING SUM(price*amount) >1000
	ORDER BY SUM(price*amount);

------------------------ ROLLUP, GROUPING_ID, CUBE 

--���� �Ǵ� �߰��հ谡 �ʿ��ϴٸ� GROUP BY ���� �Բ� ROLLUP �Ǵ� CUBE�� ���
SELECT num, groupName, SUM(price*amount) AS [���]
	FROM buyTbl
	GROUP BY ROLLUP(groupName, num);
-- �߰��� num�� NULL�� ���� �� �׷��� ���հ踦 �ǹ� ���� �� ������ NULL�� ���հ踦 �ǹ���  

--�Ѵ��� ���������� �հ������� �˱� ���ؼ��� GROUPING_ID �Լ��� ����ϸ� �ȴ�. �Լ��� ����� 0�̸� ������, 1�̸� �հ�
SELECT num, groupName, SUM(price*amount) AS [���]
	, GROUPING_ID(groupName) AS [�߰��� ����]
	FROM buyTbl
	GROUP BY ROLLUP(groupName, num);

--CUBE
USE sqlDB;
CREATE TABLE cubeTbl(prodName NCHAR(3), color NCHAR(2), amount INT);
GO
INSERT INTO cubeTbl	VALUES('��ǻ��', '����', 11);
INSERT INTO cubeTbl	VALUES('��ǻ��', '�Ķ�', 22);
INSERT INTO cubeTbl	VALUES('�����', '����', 33)
INSERT INTO cubeTbl	VALUES('�����', '�Ķ�', 44);
GO
SELECT prodName, color, SUM(amount) AS [�����հ�]
	FROM cubeTbl
	GROUP BY CUBE (color, prodName);
