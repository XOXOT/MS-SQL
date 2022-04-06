-------7�� 

--������ ����

----���� 
BIT
TINYINT
SMALLINT 
INT
DECIMAL(P,N) 
FLOAT(N)

----���� 
CHAR
NCHAR
VARCHAR 
NVARCHAR

----��¥ 
DATETIME2
DATE
TIME 

----��Ÿ
CURSOR
TABLE
XML
GEOMETRY 

-------���� 

USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE; --����� ���� ���� ������ 

--DECLARE�� �ֹ߼� ������ ���� �Ŀ� ������Ƿ� ���߿� �ٽ� �� ���� ������ �κб��� �ܾ �����ؾ��Ѵ�. 
USE sqlDB;
DECLARE @myVar1 INT;
DECLARE @myVar2 SMALLINT, @myVar3 DECIMAL(5,2);
DECLARE @myVar4 NCHAR(20);

SET @myVar1 = 5;
SET @myVar2 = 3;
SET @myVar3 = 4.25;
SET @myVar4 = '���� �̸�==>>';

SELECT @myVar1;
SELECT @myVar2+@myVar3;
SELECT @myVar4, Name FROM userTbl WHERE height >180;

-- TOP ������ ���� ������ ��� 
DECLARE @myVar1 INT;
SET @myVar1 =3;
SELECT TOP(@myVar1) Name, height FROM userTbl ORDER BY height;

---------- ������ ���İ� ���õ� �ý��� �Լ�

--����� ��ȯ
--���� ���̺��� ��� ���� ���� 
USE sqlDB;
SELECT AVG(amount) AS [��� ���� ����] FROM buyTbl;
--CAST
SELECT AVG(CAST(amount AS FLOAT)) AS [��ձ��Ű���] FROM buyTbl; --cast�� ����Ͽ� float �������� ��ȯ
--CONVERT
SELECT AVG(CONVERT(FLOAT, amount)) AS [[��ձ��Ű���] FROM buyTbl; --CONVERT�� ����Ͽ� float �������� ��ȯ
--TRY_CONVERT -CONVERT�� �ٸ��� ��ȯ�� ������ ��� NULL���� ��ȯ
SELECT AVG(TRY_CONVERT(FLOAT, amount)) AS [[��ձ��Ű���] FROM buyTbl; --TRY_CONVERT�� ����Ͽ� float �������� ��ȯ

--�ܰ�/������ ���
SELECT price, amount, price/amount AS [�ܰ�/����] FROM buyTbl; --������ ��Ȯ�� ���� �ƴϴ�.
--CAST
SELECT price, amount, CAST(CAST(price AS FLOAT)/amount AS DECIMAL(10,2)) AS [�ܰ�/����] FROM buyTbl; --cast�� ����Ͽ� float �������� ��ȯ
--CONVERT
SELECT price, amount, CONVERT(FLOAT, price) /CONVERT(DECIMAL(10,2),amount) AS [�ܰ�/����] FROM buyTbl; --�� �ٸ�?
SELECT price, amount, CONVERT(DECIMAL(10,2),CONVERT(FLOAT, price)/amount) AS [�ܰ�/����] FROM buyTbl; -- �̰� ���� 
--TRY_CONVERT
SELECT price, amount, TRY_CONVERT(FLOAT, price) /TRY_CONVERT(DECIMAL(10,2),amount) AS [�ܰ�/����] FROM buyTbl; --�� �ٸ�?
SELECT price, amount, TRY_CONVERT(DECIMAL(10,2),TRY_CONVERT(FLOAT, price)/amount) AS [�ܰ�/����] FROM buyTbl; -- �̰� ����

--���� CONVERT�Լ����� ���������Ϳ� ���� �������� ��ȣ��ȯ�� ����
SELECT CONVERT(NCHAR(2), 0X48C555B1,0);

--Ư���� ���ڿ��� ��ȯ�� ��� PARSE�� TRY_PARSE�� ����� �� �ִ�.
SELECT PARSE('2019�� 9�� 9��' AS DATE); -- 2019-09-09�� �ٲ�
SELECT PARSE('123.45' AS INT); --���� 
SELECT TRY_PARSE('123.45' AS INT); --���� ���� NULL �� ��� ���� ���� ���α׷��ֿ��� ������ ���� ��� ������ �� TRY�� �� ����� 
GO

--�Ͻ����� ����ȯ
DECLARE @myVar1 CHAR(3);
SET @myVar1 = '100';
SELECT @myVar1 + '200'; --���ڿ� ���ڸ� ���� (����)
SELECT @myVar1 + 200; -- ���ڿ� ������ ����(����: ������ �Ͻ��� �� ��ȯ)
SELECT @myVar1 + 200.0; -- ���ڿ� �Ǽ��� ����(����: �Ǽ��� �Ͻ��� �� ��ȯ)

--����� ��ȯ
DECLARE @myVar1 CHAR(3);
SET @myVar1 = '100';
SELECT @myVar1 + '200'; --���ڿ� ���ڸ� ���� (����)
SELECT CAST(@myVar1 AS INT) + 200; -- ���ڿ� ������ ����(����: ������ �Ͻ��� �� ��ȯ)
SELECT CAST(@myVar1 AS DECIMAL(5,1)) + 200.0; -- ���ڿ� �Ǽ��� ����(����: �Ǽ��� �Ͻ��� �� ��ȯ)

--���ڿ��� ���ڷ� ��ȯ�� �� ������ �ڸ����� �� ����ؾ���
DECLARE @myVar2 DECIMAL(10,5);
SET @myVar2 = 10.12345;
SELECT CAST(@myVar2 AS NCHAR(8)); --5�� �� ��� �����÷ο� �߻�! ���� 8�� ��ȯ

--�Ǽ��� ������ ��ȯ �� �� �ڸ����� �߸� �� �ִٴ� �� ���
DECLARE @myVar3 DECIMAL(10,5);
SET @myVar3 = 10.12345;
SELECT CAST(@myVar3 AS INT); --�� �߸�

DECLARE @myVar4 DECIMAL(10,5);
SET @myVar4 = 10.12345;
SELECT CAST(@myVar4 AS DECIMAL(10,2)); --�� ° �ڸ����� ǥ��
GO

----------------��Į�� �Լ� 

--MAX ������

--1. max�� ������ ����
USE tempdb;
CREATE TABLE maxTbl
(col1 VARCHAR(MAX),
 col2 NVARCHAR(MAX));
--2. ������ ���� 1,000,000(�鸸)�� ������ �뷮 �����͸� �Է�
INSERT INTO maxTbl VALUES(REPLICATE('A',1000000), REPLICATE('��',1000000));
--3. �Էµ� �� ũ�� Ȯ�� 
SELECT LEN(col1) AS [VARCHAR(MAX)], LEN(col2)AS [NVARCHAR(MAX)] FROM maxTbl; --��ü ������ ���� ���� 8000, 4000���ڸ� ��
--4. VARCHAR(MAX)�� NVARCHAR(MAX) ������ ���Ŀ� 8000����Ʈ�� �Ѵ� ���� �Է��Ϸ��� �Է��� ���ڸ� CAST�Լ��� CONVERT �Լ��� �� ��ȯ�� ���Ѿ���
DELETE FROM maxTbl;
INSERT INTO maxTbl VALUES(
	REPLICATE(CAST('A' AS VARCHAR(MAX)), 1000000),
	REPLICATE(CONVERT(VARCHAR(MAX), '��'), 1000000));
SELECT LEN(col1) AS [VARCHAR(MAX)], LEN(col2) AS [NVARCHAR(MAX)] FROM maxTbl;
--5. 'A'�� 'B'�� '��'�� '��'�� ���� 
UPDATE maxTbl SET col1 = REPLACE((SELECT col1 FROM maxTbl), 'A', 'B'),
				  col2 = REPLACE((SELECT col2 FROM maxTbl), '��', '��');
--6. �����Ͱ� �� ����Ǿ����� Ȯ�� (���� �����Ƿ� �޺κ��� ���) - REVERSE�� SUBSTRING �Լ� ���
SELECT REVERSE((SELECT col1 FROM maxTbl));
SELECT SUBSTRING((SELECT col2 FROM maxTbl), 99991, 10); 
--7. ������ ���� �Լ� STUFF, UPDATE���� �������ִ� ���̸�, WRITE�Լ��� �̿��ؼ� �����͸� ���� (���� Ȯ��) WRITE �Լ��� ���� ���� 

--8. STUFF�� �̿��Ͽ� ������ ������ 10���ڸ� 'C'�� '��'�� ����
UPDATE maxTbl SET
	col1 = STUFF((SELECT col1 FROM maxTbl), 999991, 10, REPLICATE('C', 10)),
	col2 = STUFF((SELECT col2 FROM maxTbl), 999991, 10, REPLICATE('��', 10));

--9. WRITE �Լ��� �̿��Ͽ� ������ 5���� 'D'�� '��'�� ����
UPDATE maxTbl SET col1.WRITE('DDDDD',999996,5) , col2.WRITE('������',999996,5); --WRITE �Լ��� ���� ���� 

--10. �����Ͱ� �� ����Ǿ����� Ȯ�� (���� �����Ƿ� �޺κ��� ���) 
SELECT REVERSE((SELECT col1 FROM maxTbl));
SELECT REVERSE((SELECT col2 FROM maxTbl));

------���� �Լ� 
--1. ȸ�� ���̺��� Ű�� ū ������ ������ ���ϰ� ���� ��� ROW_NUMBER() �Լ��� ����Ѵ�. 
USE sqlDB;
SELECT ROW_NUMBER() OVER(ORDER BY height DESC) [Űū����], name, addr, height FROM userTbl;
--2. ������ Ű�� ��� �̸������� ����
SELECT ROW_NUMBER() OVER(ORDER BY height DESC, name ASC) [Űū����], name, addr, height FROM userTbl;
--3. �̹����� ��ü ������ �ƴ� ������ ������ ���, ������ ���� �� Ű ū ����. PARTITION BY ���
SELECT addr, ROW_NUMBER() OVER(PARTITION BY addr ORDER BY height DESC, name ASC) [������Űū����], name, height FROM userTbl;
--4. ���� Ű ���� ���ó�� DENSE_RANK() �Լ� ���
SELECT DENSE_RANK() OVER(ORDER BY height DESC) [Űū����], name, addr, height FROM userTbl;
--5. 2���� �ߺ��̹Ƿ� 3���� ���� 4����� ������ �ű� RANK()�Լ� ���
SELECT RANK() OVER(ORDER BY height DESC) [Űū����], name, addr, height FROM userTbl;
--6. ��ü �ο��� Ű������ ���� �� ��� �׷����� ���� �ϴ� NTILE �Լ� 
SELECT NTILE(2) OVER(ORDER BY height DESC) [�ݹ�ȣ], name, addr, height FROM userTbl; --���� 2���� ���� ���
--6. ��ü �ο��� Ű������ ���� �� ��� �׷����� ���� �ϴ� NTILE �Լ� 
SELECT NTILE(3) OVER(ORDER BY height DESC) [�ݹ�ȣ], name, addr, height FROM userTbl; --�����ϰ� �Ҵ��� �� ó�� �׷���� �ϳ��� ��� �ϹǷ� 1�� ���� 
SELECT NTILE(4) OVER(ORDER BY height DESC) [�ݹ�ȣ], name, addr, height FROM userTbl; -- ���������� 1�� �Ѹ� 2�� �Ѹ�