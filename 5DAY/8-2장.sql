--8-2�� 

--���Ľ� ��
-- ������ NULL ���� ���� ����ȭ�� ����Ұ� �ִ� �Ϲ� ���� ������ �� �ִ�.
-- ��, NULL ���� ���� �� ������ ����Ǵ� ���� ���Ľ� ���� ������ ������, ���� ���� ȿ���� Ŀ����.
-- �׷��� NULL ���� ���� ���� ���̶�� ������ ���� ������ ũ�Ⱑ �� �ʿ�������. 

--1. �׽�Ʈ db ����
USE tempdb;
CREATE DATABASE sparseDB;
--2.
USE sparseDB;
CREATE TABLE charTbl (id int identity, data char(100) NULL);
CREATE TABLE sparseCharTbl (id int identity, data char(100) SPARSE NULL); --Ȯ���� ���� charTbl ���� ���� ���� 
--(���̺� �Ӽ����� ����ҿ��� Ȯ��)
--3. ���̺� ������ 4���� �Է� data ������ 75%�� null ������ �Է� 
DECLARE @i INT = 0
WHILE @i < 10000
BEGIN 
	INSERT INTO charTbl VALUES(null); -- null �� 3ȸ
	INSERT INTO charTbl VALUES(null);
	INSERT INTO charTbl VALUES(null);
	INSERT INTO charTbl VALUES(REPLICATE('A', 100)); --���� ������ 1ȸ
	INSERT INTO sparseCharTbl VALUES(null); -- null �� 3ȸ
	INSERT INTO sparseCharTbl VALUES(null);
	INSERT INTO sparseCharTbl VALUES(null);
	INSERT INTO sparseCharTbl VALUES (REPLICATE('A', 100)); --���� ������ 1ȸ
	SET @i += 1
END

--null ���� ���� ���� ���� SPARSE ���� �����ϸ� �� ũ���?
TRUNCATE TABLE charTbl; -- ��ü �� ������ ����
TRUNCATE TABLE sparseCharTbl; -- ��ü �� ������ ����
GO
DECLARE @i INT = 0
WHILE @i < 40000

BEGIN
INSERT INTO charTbl VALUES (REPLICATE('A',100)) ;
INSERT INTO sparseCharTbl VALUES(REPLICATE('A' ,100)); -- �� ���� ������ ������ ũ�Ⱑ charTbl���� Ŀ�� 
SET @i += 1
END

USE tempdb
DROP DATABASE sparseDB;
-- ���Ľ� ���� ������ ���� �� ���� ���� ������ �ִ�. 
-- geometry, geography, image, text, ntext, timestamp, UDT(user Define data Type)���� ������ �� ����. 
-- �翬�� NULL�� ����ؾ� �ϸ�, IDENTITY �Ӽ��� ����� �� ����.
-- FILESTREAM Ư���� ������ �� ����.
-- DEFAULT ���� ������ �� ����.
-- ���Ľ� ���� ����ϸ� ���� �ִ� ũ�Ⱑ 8,060����Ʈ���� 8,018 ����Ʈ�� �پ���.
-- ���Ľ� ���� ���Ե� ���̺��� ������ ���� ����. 
-- �� ���� ������ �����ؼ� ���Ľ� ���� �����ϰ� �� Ȱ���ϸ� ���� ������ ȿ���� ���� �� �ִ�. 
------------------------------------------------------------------------------------------------

-- �ӽ� ���̺�
-- �ӽ� ���̺��� �̸�ó�� �ӽ÷� ��� ���Ǵ� ���̺� 
-- ���̺��� ���� �� ���̺� �̸� �տ� #, ##�� ���̸� �ӽ� ���̺�� �����ȴ�. �ӽ� ���̺��� TEMPDB�� ������ ��, ������ ���� ���� �Ϲ� ���̺�� �����ϰ� ��� ����

-- #�� �տ� ���� ���̺��� ���� �ӽ� ���̺��̶�� �θ���, ���̺��� ������ ����� ����� �� �ִ�. (��, �ٸ� ����ڴ� �ش� ���̺� ���縦 ��)
-- ##�� �տ� ���� ���̺��� ���� �ӽ� ���̺��̶�� �θ���, ��� ����ڰ� ����� �� �ִ� ���̺�

-- �ӽ� ���̺� ���� ����
--1. ����ڰ� DROP TABLE�� ����
--2. SQL SERVER�� �ٽ� ���۵Ǹ� ����
--3. ���� �ӽ� ���̺��� ������ ������� ������ ����� ���� (�� ����â�� ������ ����)
--4. ���� �ӽ� ���̺��� ������ ������� ������ ����� �� ���̺��� ��� ���� ����ڰ� ���� �� ����

-- �ǽ�
USE tableDB;
CREATE TABLE #tempTbl (ID INT, txt NVARCHAR(10));
GO
CREATE TABLE ##tempTbl (ID INT, txt NVARCHAR(10));
GO

INSERT INTO #tempTbl VALUES(1, N'�����ӽ����̺�');
INSERT INTO ##tempTbl VALUES(1, N'�����ӽ����̺�');
GO

--��ȸ (�ӽ� ���̺��� MASTER������ ��ȸ ������)
SELECT * FROM #tempTbl;
SELECT * FROM ##tempTbl;

--���ο� ����â�� ���� ##�� ��ȸ�� ������ #�� ��ȸ�� �ȵ�
BEGIN TRAN
	INSERT INTO ##tempTbl VALUE(2. N'�� ����â���� �Է�');
-- BEGIN TRAN�� ���� �� INSERT, UPDATE, DELETE ���� ������ COMMIT TRAN�� ���� �������� ������ ������ ����� ���°� �ƴϴ�. �� �ش� ���̺��� ��� ������ ����.
-- Ʈ������� Ŀ���ϰ�, �ٽ� ��ȸ�ϸ� ���� �ӽ� ���̺� �� �̻� ����ϴ� ����ڰ� ���� �ڵ� �����ȴ�.
COMMIT TRAN;
SELECT *FROM ##tempTbl;

------------------------------------------------------------
--���̺� ����
DROP TABLE ���̺��̸�;
-- ��, �ܷ� Ű ���� ������ ���� ���̺��� ������ �� ����. ���� �ܷ� Ű�� ������ �ܷ� Ű ���̺��� �����ؾ� ���� ����

------------------------------------------------------------
-- ���̺� ����
-- ALTER TABLE ���� ���
-- �̹� ������ ���̺� �߰�/����/����/������ ��� ALTER TABLE ���

---- ����1 (�� �߰�)
USE tableDB;
ALTER TABLE userTbl
		ADD homepage NVARCHAR(30) --���߰�
		DEFAULT 'http://www.hanb.co.kr' -- ����Ʈ ��
		NULL;
GO
EXEC sp_help userTbl;

---- ����2 (�� ����)
USE tableDB;
ALTER TABLE userTbl
		DROP COLUMN mobile1;
GO
-- ���� ������ ������ ������ ���� 

---- ����3 (���� ������ ���� ����)
USE tableDB;
ALTER TABLE userTbl
	ALTER COLUMN name NVARCHAR(20) NULL;
-- ���� ������ ������ ������ ���� 

--���� �̸� ����
EXEC sp_rename 'userTbl.name', 'username', 'COLUMN'; --�ǵ����̸� ���� �̸��� �������� �ʴ°� ���� (��ũ��Ʈ �� ���� ���ν��� �ջ� ����)
-- �ٸ� ������� �ش� ���̺� ������ Ŭ�� �� ������.

---- ����4 (���� ���� ���� �߰� �� ����)
USE tableDB;
ALTER TABLE userTbl
	DROP CONSTRAINT CD_height; -- ���� ���� �̸�
GO

--�ǽ� 
-- 1. ���̺� �ٽ� ����
USE tableDB;
DROP TABLE buyTbl, userTbl;
GO
CREATE TABLE userTbl
( userID char(8),
name nvarchar(10),
birthYear int,
addr nchar(2),
mobile1 char(3),
mobile2 char(8),
height smallint,
mDate date
);
GO
CREATE TABLE buyTbl
( num int IDENTITY,
userid char(8),
prodName char (6),
groupName nchar(4),
price int,
amount smallint
);
GO

--2. ������ �Է� 
INSERT INTO userTbl VALUES('LSG', N'�̽±�', 1987, N'����' , '011' , '1111111' , 182 ,'2008-8-8') ; 
INSERT INTO userTbl VALUES('KBS', N'�����', NULL, N'�泲', '011', '2222222', 173, '2012-4-4'); 
INSERT INTO userTbl VALUES('KKH', N'���ȣ', 1871, N'����' , '019' , '3333333' ,177,'2007-7-7') ; 
INSERT INTO userTbl VALUES('JYP', N'������', 1950, N'���', '011', '4444444', 166, '2009-4-4'); 
GO 
INSERT INTO buyTbl VALUES('KBS', N'�ȭ' , NULL , 30, 2); 
INSERT INTO buyTbl VALUES('KBS', N'��Ʈ��', N'����', 1000, 1); 
INSERT INTO buyTbl VALUES('JYP', N'�����', N'����', 200, 1); 
INSERT INTO buyTbl VALUES('BBK', N'�����', N'����', 200, 5); 
GO 

--3. ���� ���� ���� 
ALTER TABLE userTbl
ADD CONSTRAINT PK_userTbl_userID
PRIMARY KEY (userID);
-- ���� �߻� PRIMARY KEY�� �����ҷ��� NOT NULL�� ���� �����Ǿ� �־���� 
ALTER TABLE userTbl
ALTER COLUMN userID char (8) NOT NULL;
GO
ALTER TABLE userTbl
	ADD CONSTRAINT PK_userTbl_userID
		PRIMARY KEY (userID);
GO
ALTER TABLE buyTbl
	ADD CONSTRAINT PK_buyTbl_num
		PRIMARY KEY (num);
GO
--BUYTBL�� NUM���� NOT NULL�� �������� �ʾҴµ� ������ ���� �ʰ� PRIMARY KEY�� �����Ǿ� �ִ�.
--�ֳ��ϸ� IDENTITY �Ӽ��� �����ϸ� �ڵ����� NOT NULL �Ӽ��� ������ �����̴�.

--4. �ܷ� Ű ���� 
ALTER TABLE buyTbl
	ADD CONSTRAINT FK_userTbl_buyTbl
		FOREIGN KEY (userID)
		REFERENCES userTbl (userID);
-- BUYTBL�� BBK�� ���ű���� �ִµ� BBK ���̵�  USERTBL�� �������� �ʾ� �浹��
-- �����Ͱ� ���� ��쵵 �ֱ� ������ ������ �Էµ� ���� ���� ����ġ �ϴ��� �����ϰ� �ܷ� Ű ���� ������ �ξ��� �ʿ䰡 �ִ�. 
-- WITH NOCHECK�� Ȱ�� �����ϸ� WITH CHECK�� �⺻�� 
ALTER TABLE buyTbl WITH NOCHECK 
	ADD CONSTRAINT FK_userTbl_buyTbl
		FOREIGN KEY (userID)
		REFERENCES userTbl (userID);
GO
--�׽�Ʈ�� �� �Է�
INSERT INTO buyTbl VALUES('KBS', N'û����', N'�Ƿ�', 50, 3);
INSERT INTO buyTbl VALUES('BBK', N'�޸�', N'����', 80, 1); --BBK�� ���� USERTBL�� ���� ������ ������ ����
-- �̷� ���� ��� �ܷ� Ű ���� ������ ��Ȱ��ȭ ��Ű�� �����͸� ��� �Է� �� �ܷ� Ű ���� ������ Ȱ��ȭ ��Ų��. 
ALTER TABLE buyTbl
	NOCHECK CONSTRAINT FK_userTbl_buyTbl ; -- NOCHECK CONSTRAINT ����_����_�̸� (��Ȱ��ȭ)
GO
INSERT INTO buyTbl VALUES('BBK', N'�޸�', N'����', 80, 10);
INSERT INTO buyTbl VALUES('SSK', N'å', N'����', 15, 5);
INSERT INTO buyTbl VALUES('EJW', N'å', N'����', 15, 2);
INSERT INTO buyTbl VALUES('EJW', N'û����', N'�Ƿ�', 50, 1);
INSERT INTO buyTbl VALUES('BBK', N'�ȭ', NULL, 30, 2);
INSERT INTO buyTbl VALUES('EJW', N'å', N'����', 15, 1);
INSERT INTO buyTbl VALUES('BBK', N'�ȭ', NULL, 30, 2);
GO
ALTER TABLE buyTbl
	CHECK CONSTRAINT FK_userTbl_buyTbl; -- CHECK CONSTRAINT ����_����_�̸� (�ٽ� Ȱ��ȭ)
GO

--5. USERTBL�� ����⵵�� 1900~ ��������� ����
ALTER TABLE userTbl
	ADD CONSTRAINT CK_birthYear
	CHECK
		(birthYear >= 1900 AND birthYear <= YEAR(GETDATE()));
-- �� ���� ���� (�Է½ÿ� ������� ����⵵ NULL, ���ȣ�� ����⵵�� 1871�� �߸��Է� �߱� ����. WITH NOCHECK�� ����!

ALTER TABLE userTbl
	WITH NOCHECK -- ���� ������ ������ ���� �����ϸ� �������� ������ �ٽ� ���� ������ �ߵ�
	ADD CONSTRAINT CK_birthYear
	CHECK
		(birthYear >= 1900 AND birthYear <= YEAR(GETDATE()));

-- USERTBL ������ �Է�

INSERT INTO userTbl VALUES('SSK', '���ð�', 1979, '����',  NULL,  NULL,     186, '2013-12-12');
INSERT INTO userTbl VALUES('LJB', '�����', 1963, '����', '016', '6666666', 182, '2009-9-9');
INSERT INTO userTbl VALUES('YJS', '������', 1969, '�泲',  NULL,  NULL,     170, '2005-5-5');
INSERT INTO userTbl VALUES('EJW', '������', 1972, '���', '011', '8888888', 174, '2014-3-3');
INSERT INTO userTbl VALUES('JKW', '������', 1965, '���', '018', '9999999', 172, '2010-10-10');
INSERT INTO userTbl VALUES('BBK', '�ٺ�Ŵ', 1973, '����', '010', '0000000', 176, '2013-5-5');

--6. ȸ���� �ڽ��� ID�� �����ش޶�� �Ѵ�. BBK�� VVK�� ���� 
UPDATE userTbl SET userID = 'VVK' WHERE userID = 'BBK'; --BBK�� �̹� BUYTBL�� ������ ����� �־� �ٲ��� ���� 
--�������� ��Ȱ��ȭ �� ����
ALTER TABLE buyTbl
		NOCHECK CONSTRAINT FK_userTbl_buyTbl;
GO
UPDATE userTbl SET userID = 'VVK' WHERE userID = 'BBK';
GO
ALTER TABLE buyTbl
		CHECK CONSTRAINT FK_userTbl_buyTbl;
GO
-- ���� ���̺��� ����ڿ��� ��ǰ ����� ���� ȸ�� ���̺�� ���ν��Ѻ���
-- ��, ������ ȸ�� ���̵�, ȸ�� �̸�, ������ ��ǰ, �ּ�, ������ ���
SELECT B.userid, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS [����ó]
	FROM buyTbl B
		INNER JOIN userTbl U
			ON B.userid = U.userID
GO
-- 12���� �Է��ߴµ� 8�Ǹ� ���Դ�? ���� ���̺� �ٽ� Ȯ��
SELECT COUNT(*) FROM buyTbl;
-- 12���� �� �����Ƿ� �ܺ� �������� ���� ���̺��� ������ ��� ���
SELECT B.userid, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS [����ó]
	FROM buyTbl B
		LEFT OUTER JOIN userTbl U
			ON B.userid = U.userID
	ORDER BY B.userid;
GO
-- BBK��� ���̵� VVK�� �����ؼ� �̷��� ������ �߻��� ����. ���� ���� ������ ����������

ALTER TABLE buyTbl
NOCHECK CONSTRAINT FK_userTbl_buyTbl;
GO
UPDATE userTbl SET userID = 'BBK' WHERE userID = 'VVK';
GO
ALTER TABLE buyTbl
CHECK CONSTRAINT FK_userTbl_buyTbl;

-- �տ����� ���� ������ ���ֱ� ����, ȸ�� ���̺��� userID�� �ٲ� ��, �̿� ���õ� ���� ���̺��� userID�� �ڵ� ����ǵ��� �Ѵ�. 
ALTER TABLE buyTbl
	DROP CONSTRAINT FK_userTbl_buyTbl;
GO
ALTER TABLE buyTbl WITH NOCHECK
	ADD CONSTRAINT FK_userTbl_buyTbl
		FOREIGN KEY (userID)
		REFERENCES userTbl (userID)
		ON UPDATE CASCADE; -- �ܷ� Ű ���� ������ ������ �Ŀ� �ٽ� ������ ���� 
GO

-- �ٽ� VVK�� �����غ��� BUYTBL�� �ٲ������ Ȯ�� 
UPDATE userTbl SET userID = 'VVK' WHERE userID= 'BBK';
GO
SELECT B.userid, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS [����ó]
FROM buyTbl B
	INNER JOIN userTbl U
		ON B.userid = U.userid
	ORDER BY B.userid;
GO

-- VVK ȸ���� Ż���ϸ� ������ ��ϵ� ������ �Ǵ��� Ȯ�� 
DELETE userTbl WHERE userID = 'VVK'; -- ���ó� ���� ���� ������ ����
-- ���� ���� 
ALTER TABLE buyTbl
	DROP CONSTRAINT FK_userTbl_buyTbl;
GO
ALTER TABLE buyTbl WITH NOCHECK
	ADD CONSTRAINT FK_userTbl_buyTbl
		FOREIGN KEY (userID)
		REFERENCES userTbl (userID)
		ON UPDATE CASCADE
		ON DELETE CASCADE;
GO
DELETE userTbl WHERE userID= 'VVK';
GO
SELECT * FROM buyTbl;

--7. userTbl���� CHECK ���� ������ �ɸ� ����⵵ ���� ���� 
ALTER TABLE userTbl
		DROP COLUMN birthYear; -- ����
GO
-- ���� ���� CK_birthYear ���� �� �� ����
ALTER TABLE userTbl
		DROP CK_birthYear; -- ����
GO
ALTER TABLE userTbl
		DROP COLUMN birthYear; -- ����
GO
SELECT *FROM userTbl --Ȯ�� 
GO 






