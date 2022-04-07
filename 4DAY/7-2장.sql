--7-2 

--�м� �Լ� 

USE sqlDB;
--OVER�Լ��� ORDER BY, GROUP BY ���������� �����ϱ� ���� ���� �Լ�
--�����̶����, ����, �ۼ�������, ���, ���� �� �����͸� ��質 ������ ��
--�����Լ��� �����Լ��� ���� �� �� ���� ������, ���������� ����ϰ� �Ǵµ���
--Ư�� �ټ��� �������� �ʿ��� �� ���� ���������� �׷���̷� ���� ������ ������������.  
--�̸� ����ó�� �����ϰ� ������ִ� ���� OVER���Դϴ�.

--LEAD �Լ� : ���� ���� ���� ����
--LEAD(���ؿ��̸�, ���° ������ �� ǥ��, ������ ���� ���� ��� ��ȯ��)

------ ���� ����� Ű ���� ���ϱ� 
SELECT name, addr, height AS [Ű],
	height - (LEAD(height,1,0) OVER (ORDER BY height DESC)) AS [���� ����� Ű ����]
	FROM userTbl;
--height �� ��� �� 1��° ��(�ٷ� ���� ��)�� �� ����̸� ���� ���� ���� ��� 0�� ��� 

------ �������� ���� Ű�� ū ������� ���� 
SELECT name, addr, height AS [Ű],
	height - (FIRST_VALUE(height)OVER (PARTITION BY addr ORDER BY height DESC)) AS [������ ���� ū Ű�� ����]
	FROM userTbl;

------ ���� �հ�, �� �������� �ڽź��� Ű�� ���ų� ū �ο��� ����� ���ϱ� CUME_DIST �Լ� ���
SELECT addr, name, height AS [������],
	(CUME_DIST() OVER (PARTITION BY addr ORDER BY height DESC)) * 100 AS [�����ο� �����%]
	FROM userTbl;
-- �ٸ� ���� ������ ������ �Ҽ� �μ� �߿��� �� �ۼ�Ʈ �ȿ� ����� Ȯ���� ���� ��� ���� 

------ �� �������� Ű�� �߾Ӱ��� ��� PERCENTILE_CONT()
SELECT DISTINCT addr,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY height) OVER (PARTITION BY addr)
		AS [������ Ű�� �߾Ӱ�]
	FROM userTbl;
GO

------------ PIVOT / UNPIVOT 
--�� ���� ���Ե� ���� ���� ����ϰ�, �̸� ���� ���� ��ȯ�Ͽ� ���̺� ��ȯ ���� ȸ���ϰ� �ʿ��ϸ� ������� ���� 
--PIVOT (�����Լ�(��) FOR ���ο� ���� ������ ���̸� IN (�� ���) AS �ǹ��̸�)

--�ӽ� ���̺� �����
USE tempdb;
CREATE TABLE pivotTest
(uName NCHAR(3),
 season NCHAR(2),
 amount INT);

--������ �Է� 
INSERT INTO pivotTest VALUES
	('�����', '�ܿ�', 10), ('������', '����', 15), ('�����', '����', 25),
	('�����', '��', 3), ('�����', '��', 37), ('������', '�ܿ�', 40),
	('�����', '����', 14), ('�����', '�ܿ�', 22), ('������', '����', 64);
SELECT * FROM pivotTest;

--PIVIT ������ ���� 
SELECT * FROM pivotTest
	PIVOT (SUM(amount)
		   FOR season
		   IN ([��],[����],[����],[�ܿ�])) AS resultPivot;
--UNPIVOT�� PIVOT �ݴ�� ���� ���� ��ȯ

--------JSON ������
-- JSON�� ������ ���� ����� ���� ���α׷� ��� �����͸� ��ȯ�ϴ� ǥ�� ����
-- �Ӽ�(KEY)�� ��(VALUE)���� ���� �̷� �����ȴ�. 

--SQL ���̺� JSONȭ ��Ű�� 
USE sqlDB;
SELECT name, height FROM userTbl
WHERE height >= 180
FOR JSON AUTO;

--��� ��
--[{"name":"�����","height":182},
--{"name":"�̽±�","height":182},
--{"name":"���ð�","height":186}]

-- JSON ������ SQLȭ ��Ű�� 
DECLARE @json VARCHAR(MAX)
SET @json = N' {"userTBL":
	[
		{"name":"�����","height":182},
		{"name":"�̽±�","height":182},
		{"name":"���ð�","height":186}
	]
 }'
 SELECT ISJSON(@json); --���ڿ��� JSON ������ �����ϸ� 1 �׷��� ������ 0�� ��ȯ
 SELECT JSON_QUERY(@json, '$.userTBL[0]'); -- JSON ������ �� �ϳ��� ���� ���� 
 SELECT JSON_VALUE(@json, '$.userTBL[0].name'); -- �Ӽ�(KEY)�� ������ ��(VALUE)�� ���� 
 SELECT * FROM OPENJSON(@json, '$.userTBL')
 WITH (
		name NCHAR(8)	'$.name', 
		height INT		'$.height');
		--$.name, $.height�� JSON �������� �Ӽ��� ��Ÿ��

-----------------------���� 

--INNER JOIN (���� ����)
--���� 
--SELECT <�����> FROM <ù ��° ���̺�> INNER JOIN <�� ��° ���̺�> ON <���ε� ����> [WHERE �˻� ����] //WHERE ���� ���� 

USE sqlDB;
--JYP(������)�� ���� ���̺� �� �Ǹ� ���̺� ���� 
SELECT * 
	FROM buyTbl
	INNER JOIN userTbl
		ON buyTbl.userID = userTbl.userID
	WHERE buyTbl.userID = 'JYP';

-- ���� ���̺� �� �Ǹ� ���̺� ��ü ������ ����(WHERE ����)
SELECT * 
	FROM buyTbl
	INNER JOIN userTbl
		ON buyTbl.userID = userTbl.userID;

-- ���̵�/ �̸�/ ���Ź�ǰ/�ּ�/����ó ���� 
SELECT userID, name, prodName, addr, mobile1+mobile2 AS [����ó]
	FROM buyTbl
		INNER JOIN userTbl
			ON buyTbl.userID = userTbl.userID; --���� 
-- �� ��� �� ���̺� ��� USERID�� ����־� ��� ���̺��� USERID�� ������ �� ������ ����ؾ���
SELECT buyTbl.userID, name, prodName, addr, mobile1+mobile2 AS [����ó] --������ buyTbl�� �������� �ϴ� ���̶� buyTbl�� userID�� ����
	FROM buyTbl
		INNER JOIN userTbl
			ON buyTbl.userID = userTbl.userID;

-- �ڵ带 ��Ȯ�ϰ� ǥ���ϱ� ���� ��� ���̸����� ... ��Ī �ٿ���.
SELECT B.userID, U.name, B.prodName, U.addr, U.mobile1+U.mobile2 AS [����ó] --������ buyTbl�� �������� �ϴ� ���̶� buyTbl�� userID�� ����
	FROM buyTbl B
		INNER JOIN userTbl U
			ON B.userID = U.userID;

-- ȸ�� ���̺��� �������� ���̵� JYP�� ����ڰ� ������ ������ ��� ���� (���� ����)
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1+ U.mobile2 AS [����ó] --������ buyTbl�� �������� �ϴ� ���̶� buyTbl�� userID�� ����
	FROM userTbl U
		INNER JOIN buyTbl B
			ON U.userID = B.userID
		WHERE B.userID = 'JYP';

--��ü ȸ���� ������ ��� ����ϰ� ȸ��ID ������ ���� (�̳� �����̶� ���� �̷��� �ִ� ����� ��� ����)
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1+ U.mobile2 AS [����ó] --������ buyTbl�� �������� �ϴ� ���̶� buyTbl�� userID�� ����
	FROM userTbl U
		INNER JOIN buyTbl B
			ON U.userID = B.userID
		ORDER BY U.userID;

-- ���θ����� �� ���̶� ������ ����� �ִ� ȸ���� ����Ͽ� ���� �ȳ����� ������ ���� �� (DISTINCT���� ����Ͽ� �ߺ� ����)
SELECT DISTINCT U.userID, U.name, U.addr
	FROM userTbl U
		INNER JOIN buyTbl B
			ON U.userID = B.userID
		ORDER BY U.userID;

-- EXISTS ���� ����ص� ������ ����� �� �� �ִ�. (JOIN ���� ������ �������� ���� X)
-- EXISTS(���� ����)�� ���� ������ ����� "�� ���̶� �����ϸ�" TRUE ������ FALSE�� ����
SELECT U.userID, U.name, U.addr
	FROM userTbl U
	WHERE EXISTS(
		SELECT * 
		FROM buyTbl B
		WHERE U.userID = B.userID);

-------�� �� ���� �ǽ� 
USE sqlDB;
CREATE TABLE stdTbl
(stdName NVARCHAR(10) NOT NULL PRIMARY KEY,
 addr NCHAR(4) NOT NULL);
 GO
 CREATE TABLE clubTbl
 (clubName NVARCHAR(10) NOT NULL PRIMARY KEY,
  roomNo NCHAR(4) NOT NULL);
 GO
 CREATE TABLE stdclubTbl
 (num int IDENTITY NOT NULL PRIMARY KEY,
  stdName NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES stdTbl(stdName),
  clubName NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES clubTbl(clubName));
GO
INSERT INTO stdTbl VALUES ('�����', '�泲'), ('���ð�', '����'), ('������', '���'), ('������', '���'), ('�ٺ�Ŵ', '����');
INSERT INTO clubTbl VALUES ('����', '101ȣ'), ('�ٵ�', '102ȣ'), ('�౸', '103ȣ'), ('����', '104ȣ');
INSERT INTO stdclubTbl VALUES ('�����', '�ٵ�'), ('�����', '�౸'),('������', '�౸'), ('������', '�౸'), 
								('������', '����'), ('�ٺ�Ŵ', '����');
GO

-- �л��� �������� ��� ��� 
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdTbl S
		INNER JOIN stdclubTbl SC
			ON S.stdName = SC.stdName
		INNER JOIN clubTbl C
			ON SC.clubName = C.clubName
		ORDER BY S.stdName;

-- ���Ƹ��� �������� ������ �л� ��� ��� (���� �� ���� ����)
SELECT C.clubName, C.roomNo, S.stdName, S.addr
	FROM stdTbl S
		INNER JOIN stdclubTbl SC
			ON SC.stdName = S.stdName
		INNER JOIN clubTbl C
			ON SC.clubName = C.clubName
		ORDER BY C.clubName;

-------------OUTER JOIN
--LEFT OUTER JOIN
USE sqlDB;
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS[����ó]
	FROM userTbl U
		LEFT OUTER JOIN buyTbl B --���� ���̺��� ���� ��� ��µǾ�� �Ѵٴ� �ǹ� 
			ON U.userID = B.userID
		ORDER BY U.userID;

--RIGHT OUTER JOIN
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS[����ó]
	FROM buyTbl B
		RIGHT OUTER JOIN userTbl U --������ ���̺��� ���� ��� ��µǾ�� �Ѵٴ� �ǹ� 
			ON U.userID = B.userID
		ORDER BY U.userID;

-- �� ���� ���Ÿ� ���� ���� ȸ���� ��ȸ 
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS[����ó]
	FROM userTbl U
		LEFT OUTER JOIN buyTbl B
			ON U.userID = B.userID
	WHERE B.prodName IS NULL
	ORDER BY U.userID; 

--���Ƹ��� �������� ���� �л����� ��� (�ǽ� 6-2 ����)
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdTbl S
		LEFT OUTER JOIN stdclubTbl SC
			ON S.stdName = SC.stdName
		LEFT OUTER JOIN clubTbl C
			ON SC.clubName = C.clubName
		ORDER BY S.stdName;

--���Ƹ��� �������� �л��� ����ϵ�, ���� �л��� �ϳ��� ���� ���Ƹ��� ��� 
SELECT C.clubName, C.roomNo, S.stdName, S.addr
	FROM stdTbl S
		LEFT OUTER JOIN stdclubTbl SC
			ON S.stdName = SC.stdName
		RIGHT OUTER JOIN clubTbl C -- Ŭ���� �������� ������ �ؾ��ؼ� ����� RIGHT OUTER JOIN�� ����
			ON SC.clubName = C.clubName
		ORDER BY C.clubName;

--���� �� ����� �ϳ��� ��ģ�ٸ�? -- �л��� ���� ���Ƹ� �� ���Ƹ��� �������� ���� �л��� ��µ�
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdTbl S
		FULL OUTER JOIN stdclubTbl SC
			ON S.stdName = SC.stdName
		FULL OUTER JOIN clubTbl C
			ON SC.clubName = C.clubName
		ORDER BY S.stdName;

------------------CROSS JOIN 
-- CROSS JOIN(��ȣ ����)�� ���� ���̺��� ��� ��� �ٸ� �� ���̺��� ��� ���� ���� : ��� ���� = �� ���̺��� ���� ����

USE sqlDB;
SELECT * FROM buyTbl CROSS JOIN userTbl;
SELECT * FROM buyTbl, userTbl; --���� ���� ����� �������� ����X

-- CROSS JOIN�� ON ������ ����� �� ������ �׽�Ʈ�� ���� �뷮�� �����͸� ������ �� �ַ� ��� 
USE AdventureWorks2016CTP3;
SELECT COUNT_BIG(*) AS [������ ����]
	FROM Sales.SalesOrderDetail
		CROSS JOIN Sales.SalesOrderHeader;
GO

------------------SELF JOIN
-- �ڱ� �ڽŰ� �ڱ� �ڽ��� �����Ѵٴ� �ǹ� ��ǥ���� ���� 6���� empTbl

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

--�ϳ��� ���̺� ���� �����Ͱ� ������ �ǹ̰� �ٸ� ��쿡�� �� ���̺��� ���� SELF JOIN ���Ѽ� ������ Ȯ�� �� �� �ִ�.
SELECT A.emp AS[��������], B.emp AS [���ӻ��], B.department AS[���ӻ���μ�] 
	FROM empTbl A 
		INNER JOIN empTbl B 
			ON A.manager = B.emp 
		WHERE A.emp = '��븮';
GO

----------------UNION, UNION ALL, EXCEPT, INTERSECT
--UNION�� �� ������ ����� ������ ��ġ�� �� 
-- SELECT (����1) UNION [ALL] SELECT (����2)
-- ��� ����1�� ����2�� ������� ������ ���ƾ� �ϸ�, ������ ���ĵ� �� �� ������ ���ų� ���� ȣȯ�Ǵ� ������ �����̿�����
USE sqlDB;
SELECT stdName, addr FROM stdTbl
	UNION ALL
SELECT clubName, roomNo FROM clubTbl

---- EXCEPT
-- ���� ���� ��� �߿��� �� ��° ������ �ش��ϴ� ���� �����ϱ� ���� ����.
-- sqlDB�� ����ڸ� ��� ��ȸ�ϵ� ��ȭ�� ���� ����� �����ϰ��� ��
SELECT name, mobile1 + mobile2 AS[��ȭ��ȣ] FROM userTbl
	EXCEPT 
SELECT name, mobile1 + mobile2 AS[��ȭ��ȣ] FROM userTbl WHERE mobile1 IS NULL;

---- INTERSECT
-- EXCEPT�� �ݴ�� �� ��° ������ �ش�Ǵ� �͸� ��ȸ��
-- ��ȭ�� ���� ����� ��ȸ�ϰ��� �� ��
SELECT name, mobile1 + mobile2 AS[��ȭ��ȣ] FROM userTbl
	INTERSECT 
SELECT name, mobile1 + mobile2 AS[��ȭ��ȣ] FROM userTbl WHERE mobile1 IS NULL;
GO


-------------SQL PROGRAMING 

----IF...ELSE...
DECLARE @var1 INT --- @var1 ���� ����
SET @var1 = 100 -- ������ �� ����
--DECLARE @var1 INT = 100 �̷��� �ٷ� ���� ���� �� �� �ִ�. 

IF @var1 = 100
	BEGIN 
		PRINT '@VAR1�� 100�̴�.'
	END
ELSE 
	BEGIN 
		PRINT '@VAR1�� 100�� �ƴϴ�.'
	END
GO

--������ȣ 111�� �ش��ϴ� ������ �Ի����� 5���� �Ѿ����� Ȯ�� 
USE AdventureWorks2016CTP3;

DECLARE @hireDATE SMALLDATETIME --�Ի���
DECLARE @curDATE SMALLDATETIME --����
DECLARE @years DECIMAL(5,2) -- �ٹ��� ���
DECLARE @days INT --�ٹ��� �ϼ� 

SELECT @hireDATE = HireDATE --hireDATE ���� ����� @hireDATE�� ���� 
	FROM HumanResources.Employee
	WHERE BusinessEntityID = 111
SET @curDATE = GETDATE() --���� ��¥
SET @years =  DATEDIFF(year, @hireDATE, @curDATE) -- ��¥�� ����, �� ����
SET @days = DATEDIFF(day, @hireDATE, @curDATE) -- ��¥�� ����, �� ����

IF (@years >= 5)
	BEGIN
		PRINT N'�Ի����� ' + CAST(@days AS NCHAR(5)) + N'���̳� �������ϴ�.'
		PRINT N'�����մϴ�. '
	END
ELSE 
	BEGIN 
		PRINT N'�Ի����� ' + CAST(@days AS NCHAR(5)) + N'�Ϲۿ� �� �Ǿ��׿�.'
		PRINT N'������ ���ϼ���. '
	END
GO

----CASE 

--IF���� CASE �� 
--IF�� 
DECLARE @POINT INT = 77, @CREDIT NCHAR(1)

IF @POINT >= 90
	SET @CREDIT = 'A'
ELSE 
	IF @POINT >=80
		SET @CREDIT = 'B'
	ELSE
		IF @POINT >= 70
			SET @CREDIT ='C'
		ELSE
			IF @POINT >= 60
				SET @CREDIT ='D'
			ELSE 
				SET @CREDIT = 'F'
PRINT N'������� ==>>' + CAST(@POINT AS NCHAR(3))
PRINT N'����==>' + @CREDIT 
GO
--CASE�� 
DECLARE @POINT INT = 77, @CREDIT NCHAR(1)

SET @CREDIT = 
	CASE 
		WHEN (@POINT >= 90) THEN 'A'
		WHEN (@POINT >= 80) THEN 'B'
		WHEN (@POINT >= 70) THEN 'C'
		WHEN (@POINT >= 60) THEN 'D'
		ELSE 'F'
	END
PRINT N'������� ==>>' + CAST(@POINT AS NCHAR(3))
PRINT N'����==>' + @CREDIT 

--CASE�� �ǽ� 
-- SQLDB ���� ���̺� ���ž�(PRICE * AMOUNT)�� 1500�� �̻��� ���� '�ֿ�� ��', 1000�� �̻��� '��� ��', 1�� �̻��� '�Ϲ� ��'
-- ���� ������ ���� ������ '���� ��' 

--1. ���� buyTbl ���ž��� ����� ���̵� ���� ���´�. 
USE sqlDB;
SELECT userID, SUM(price*amount) AS [�� ���ž�]
	FROM buyTbl 
	GROUP BY userID 
	ORDER BY SUM(price*amount) DESC;
GO

--2. ����� �̸� �����ϱ� 
SELECT B.userID, U.name, SUM(price*amount) AS [�� ���ž�]
	FROM buyTbl B
		INNER JOIN userTbl U
			ON B.userID = U.userID
		GROUP BY B.userID, U.name
		ORDER BY SUM(price*amount) DESC;

--3. �������� ���� �� ��ܵ� ���. ������ ���̺�(USERTBL)�� ������ ������ ������ �ϱ� ���� RIGHT OUTER JOIN���� ����
SELECT B.userID, U.name, SUM(price*amount) AS [�� ���ž�]
	FROM buyTbl B
		RIGHT OUTER JOIN userTbl U
			ON B.userID = U.userID
		GROUP BY B.userID, U.name
		ORDER BY SUM(price*amount) DESC;
GO

--4. ���� ����� ���� NAME�� ����� �������� ���� ����� ���� ���� USERID�� NULL�� ���Դ�. 
-- �ֳĸ� SELECT������ B.USERID�� ����ϱ� ����. 
-- BUYTBL���� ������, ���ȣ ���� ������ ���� �����Ƿ� �ش� �����Ͱ� ���� ����. 
-- USERID ������ BUYTBL���� USERTBL�� ����
SELECT U.userID, U.name, SUM(price*amount) AS [�� ���ž�]
	FROM buyTbl B 
		RIGHT OUTER JOIN userTbl U
			ON B.userID = U.userID
		GROUP BY U.userID, U.name
		ORDER BY SUM(price*amount) DESC;
GO

--5. �� ���ž׿� ���� �� �з��� ó���� �����ߴ� ��� CASE ���� ���� ���(����X)
--CASE 
--	WHEN(�� ���ž� >= 1500) THEN N'�ֿ�� ��'
--	WHEN(�� ���ž� >= 1000) THEN N'��� ��'
--	WHEN(�� ���ž� >= 1) THEN N'�Ϲ� ��'
--	ELSE N'���ɰ�'
--END
GO

--6. �ۼ��� CASE ������ SELECT�� �߰�.
SELECT U.userID, U.name, SUM(price*amount) AS [�� ���ž�],
	CASE 
		WHEN(SUM(price*amount) >= 1500) THEN N'�ֿ�� ��'
		WHEN(SUM(price*amount) >= 1000) THEN N'��� ��'
		WHEN(SUM(price*amount) >= 1) THEN N'�Ϲ� ��'
		ELSE N'���ɰ�'
	END AS [�� ���]
 FROM buyTbl B
	RIGHT OUTER JOIN userTbl U
		ON B.userID = U.userID
	GROUP BY U.userID, U.name
	ORDER BY SUM(price*amount) DESC;
GO

-------------WHILE, BREAK, CONTINUE, RETURN

---1. WHILE 
-- ���� ���ȿ� ��� �ݺ��Ǵ� �ݺ��� 
-- 1���� 100������ ���� ��� ���ϴ� ��� 
-- Ŀ���� �Բ� ���� ���� => 12��
DECLARE @i INT = 1, @hap BIGINT = 0

WHILE (@i <= 100)
BEGIN 
	SET @hap += @i -- HAP�� ������ ���� @I�� ���ؼ� �ٽ� @HAP�� ���� 
	SET @i += 1 
END

PRINT @hap
GO

-- 1���� 100������ ���� �������� 7�� ����� ���� �׸��� �հ谡 1000�� ������ �׸��� 
DECLARE @i INT = 1, @hap BIGINT = 0
WHILE (@i <= 100)
BEGIN
	IF(@i % 7 = 0)
	BEGIN
		PRINT N'7�� ���: ' + CAST (@i AS NCHAR(3))
		SET @i += 1
		CONTINUE --������ �ٷ� WHILE������ �̵��ؼ� �ٽ� ��
	END

	SET @hap += @i 
	IF (@hap > 1000) BREAK -- ���⿡ RETURN�� ������� '�հ� =>1029'�� ������� �ʰ� ��ħ    
	SET @i += 1
END
PRINT N'�հ� =>' + CAST(@hap AS NCHAR(10));
GO

-----GOTO��
--GOTO���� ������ ������ ��ġ�� ������ �̵���. ���α׷� ��ü�� ���� �帧�� ���� ��
-- ���� ������ BREAK ��� GOTO�� ���� �ȴ�.  

--(�߰� ����)
--	SET @hap += @i 
--	IF (@hap > 1000) GOTO ENDPRINT //BREAK ��� GOTO��    
--	SET @i += 1
--END

--ENDPRINT:
--PRINT N'�հ� =>' + CAST(@hap AS NCHAR(10));
GO

-----WAITFOR
-- �ڵ� ������ �Ͻ������� �� ��� 
--WAITFOR DELAY - ������ �ð���ŭ �Ͻ�����
--WAITFOR TIME - ������ �ð��� ���� 
BEGIN 
	WAITFOR DELAY '00:00:05';
	PRINT N'5�ʰ� ���� �� ����Ǿ���';
END
GO 

----------------TRY/CATCH, RAISEERROR, THROW

--TRY/CATCH
-- ������ ó���ϴ� �� ���� ���ϰ� ������ ����� ������
--���� 
--BEGIN TRY
--	���� ����ϴ� SQL �����
--END TRY
--BEGIN CATCH
--	���� BEGIN ...TRY���� ������ �߻��ϸ� ó���� �ϵ�
--END CATCH

--����
USE sqlDB;
BEGIN TRY
	INSERT INTO userTbl VALUES('LSG', '�̻�', 1988, '����', NULL, NULL, 170, GETDATE())
	-- userTbl�� �̹� LSG��� ID�� �־� ������ �� ���̴�. 
	PRINT '���������� �ԷµǾ����ϴ�.'
END TRY
BEGIN CATCH
	PRINT '������ �߻��߽��ϴ�.'
END CATCH

--���� ���� ��� �ڵ� 
ERROR_NUMBER() --���� ��ȣ
ERROR_MESSAGE() --���� �޽���
ERROR_SEVERITY() --���� �ɰ���
ERROR_STATE() --���� ���� ��ȣ
ERROR_LINE() --������ �߻���Ų �� ��ȣ
ERROR_PROCEDURE() --������ �߻��� ���� ���ν����� Ʈ������ �̸�

BEGIN TRY
	INSERT INTO userTbl VALUES('LSG', '�̻�', 1988, '����', NULL, NULL, 170, GETDATE())
	-- userTbl�� �̹� LSG��� ID�� �־� ������ �� ���̴�. 
	PRINT '���������� �ԷµǾ����ϴ�.'
END TRY

BEGIN CATCH 
	PRINT N'---------������ �߻��߽��ϴ�.-----------'
	PRINT N'���� ��ȣ->'
	PRINT ERROR_NUMBER() --���� ��ȣ
	PRINT N'���� �޽���->'
	PRINT ERROR_MESSAGE() --���� �޽���
	PRINT N'���� �ɰ���->'
	PRINT ERROR_SEVERITY() --���� �ɰ���
	PRINT N'���� ���� ��ȣ->'
	PRINT ERROR_STATE() --���� ���� ��ȣ
	PRINT N'���� �߻� �� ��ȣ->'
	PRINT ERROR_LINE() --������ �߻���Ų �� ��ȣ
	PRINT N'���� �߻� ���ν���/Ʈ����->'
	PRINT ERROR_PROCEDURE() --������ �߻��� ���� ���ν����� Ʈ������ �̸�
END CATCH
GO

-- ���� ���� �߻� �ڵ� RAISERROR/THROW 
--RAISERROR ����
RAISERROR ( { msg_id | msg_str | @local_variable }  
    { ,severity ,state }  
    [ ,argument [ ,...n ] ] )  
    [ WITH option [ ,...n ] ]  
-- msg_id�� 50000~21���� ����ڰ� �޽��� ��ȣ�� ������ �� �ִ�. OR msg_str�� ����Ͽ� ����� ���ڿ��� ���� 
-- severity�� ������ �ɰ����� ���� 0~18���� state��  0~255���� ���������ϸ� ���Ŀ� ������ ��� �߻��ߴ��� ã�� �� ���� 

--THROW ����
THROW [ { error_number | @local_variable },  
        { message | @local_variable },  
        { state | @local_variable } ]   
[ ; ]  
-- error_number�� 50000~21��̸��� ������ ����ڰ� ���� ��ȣ ����
-- message�� ����� ���ڿ�
-- state��  0~255���� ���������ϸ� ���Ŀ� ������ ��� �߻��ߴ��� ã�� �� ���� 

--���� 

RAISERROR('�̰� RAISERROR ���� �߻�', 16, 1);
THROW 55555, '�̰� THROW ���� �߻�', 1;
GO


------------EXEC (���� SQL)
--EXEC ���� (�Ǵ� EXECUTE)�� SQL ���� ��������ִ� ������ �Ѵ�. 

USE sqlDB
DECLARE @sql VARCHAR(100)
SET @sql = 'SELECT * FROM userTbl WHERE userid = ''EJW'' ' --��� ���� ����ǥ
EXEC(@sql)

-- SELECT * FROM userTbl WHERE userid = 'EJW' ������ �ٷ� �������� �ʰ� ���� @sql�� �Է½��ѳ��� EXEC() �Լ��� ������ �� �ִ�. 
-- �̷��� �������� �����ϴ� ���� ����SQL �̶�� �θ���. 