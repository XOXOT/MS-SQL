----- 9�� �ε���

--�ε����� ����
--1. �˻� �ӵ��� ��ô ������ �� �ִ�. (�׻� �׷� ���� �ƴϴ�)
--2. �� ��� �ش� ������ ���ϰ� �پ��, �ý��� ��ü�� ������ ���ȴ�. 

-- �ε����� ����
--1. �ε����� �����ͺ��̽� ������ �����ؼ� �����ͺ��̽� ũ���� 10% ������ �߰� ������ �ʿ�
--2. ó�� �ε����� �����ϴ� �� �ð��� ���� �ҿ�� �� �ִ�.
--3. �������� ���� �۾�(INSERT, UPDATE, DELETE)�� ���� �Ͼ ��쿡�� ������ ������ ������ �� �ִ�.

-- �ε����� ���� 
-- Ŭ�������� �ε���(�������), ��Ŭ�������� �ε���(å ���� ã�ƺ���)
-- Ŭ�������� �ε����� ���̺�� �� ���� ���� �����ϸ� �� �����͸� �ε����� ������ ���� ���缭 �ڵ� ���� ����
-- ��Ŭ�������� �ε����� ���̺�� ���� �� ���� ����

-- UserTbl�� ������ �� userID�� �⺻ Ű�� ���� �߱� ������ �ڵ����� userID ���� Ŭ�������� �ε����� ������
-- ���� ����� ���� �⺻ Ű�� �ϳ��� ������ �����ϹǷ� ���������� Ŭ�������� �ε����� ���̺� �� �� ���� ���� �����ϴ�.

EXEC sp_helpindex userTbl -- �ڵ����� clustered�� �ִ� ���� Ȯ���� �� �ִ�. 

--���� ��Ŭ�����͸� ����� �ʹٸ�?
CREATE TABLE userTbl 
(userID CHAR(8) NOT NULL PRIMARY KEY NONCLUSTERED, -- �⺻ Ű ���� ���� ��Ŭ�����͸� �ٿ��� 
name   NVARCHAR(10) NOT NULL,
birthYear INT NOT NULL, 
addr NCHAR(2) NOT NULL,
mobile1 CHAR(3), 
mobile2 CHAR(8), 
height SMALLINT, 
mDate DATE 
);
-- �̷��� �Ǹ� userTbl�� Ŭ�������� �ε����� �����Ƿ� �� ���� Ŭ�������� �ε����� ���� ������ �ְ� �ȴ�. 
-- ���̺� ���� �� �ε����� ������� �ݵ�� ���� ������ ����ؾ� �ϸ�, �ε����� ����� ���� ���� ������ primary key �Ǵ� unique ���̴�. 

--unique ���� ���ǵ� �����غ���.
CREATE TABLE tbl2
		(a INT PRIMARY KEY,
		 b INT UNIQUE, 
		 c INT UNIQUE, 
		 d INT
		);
GO
EXEC sp_helpindex tbl2;

-- ������ TBL2�� PRIMARY KEY�� ��Ŭ������ �ε����� ���� 
CREATE TABLE tbl3
		(a INT PRIMARY KEY NONCLUSTERED,
		 b INT UNIQUE, 
		 c INT UNIQUE, 
		 d INT
		);
GO
EXEC sp_helpindex tbl3;

-- ������ UNIQUE�� Ŭ������ �ε��� ����
CREATE TABLE tbl4
		(a INT PRIMARY KEY NONCLUSTERED,
		 b INT UNIQUE CLUSTERED, 
		 c INT UNIQUE, 
		 d INT
		);
GO
EXEC sp_helpindex tbl4;
GO
-- Ŭ������ �� �� (���� ��)
CREATE TABLE tbl5
		(a INT PRIMARY KEY NONCLUSTERED,
		 b INT UNIQUE CLUSTERED, 
		 c INT UNIQUE CLUSTERED,  -- Ŭ������ �ε����� ������ �ϳ��� ������
		 d INT
		);
GO
EXEC sp_helpindex tbl5;
GO 
-- UNIQUE���� ����ϰ� PRIMARY KEY�� ��Ŭ������ ���Ѵٸ�? --�ڵ����� ��Ŭ������ ó���� �ȴ�. 
CREATE TABLE tbl6
		(a INT PRIMARY KEY,
		 b INT UNIQUE CLUSTERED, 
		 c INT UNIQUE,  -- Ŭ������ �ε����� ������ �ϳ��� ������
		 d INT
		);
GO
EXEC sp_helpindex tbl6;
GO 

--Ŭ�������� �ε����� �� �����͸� �ڽ��� ���� �������� �����Ѵٰ� �ߴµ� �ѹ� �˾ƺ���
USE tempdb;
CREATE TABLE userTbl3 -- ȸ�����̺�
(userID CHAR(8) NOT NULL PRIMARY KEY, --����� ���̵�
name   NVARCHAR(10) NOT NULL, -- �̸�
birthYear INT NOT NULL, --����⵵
addr NCHAR(2) NOT NULL, --����(���, ����, �泲 ������ 2���ڸ� �Է�)
);

INSERT INTO userTbl3 VALUES('LSG', N'�̽±�', 1987, N'����');
INSERT INTO userTbl3 VALUES('KBS', N'�����', 1979, N'�泲');
INSERT INTO userTbl3 VALUES('KKH', N'���ȣ', 1971, N'����');
INSERT INTO userTbl3 VALUES('JYP', N'������', 1950, N'���');
INSERT INTO userTbl3 VALUES('SSK', N'���ð�', 1979, N'����'); 
GO
SELECT *FROM userTbl3; --�Է°� �ٸ��� USERID ���� �������� ���ĵ� ���� �� �� �ִ�.

--B-Tree
-- ����Ʈ���� �ڷᱸ������ ������ ���������� ���Ǵ� �������� ����
-- �� ������ �ַ� �ε����� ǥ���� ���� �� �ܿ����� ���� ���ȴ�. 
-- ���� Ʈ�� �������� �����Ͱ� �����ϴ� �����̴�.
-- ��Ʈ ���� ���� ������ �ִ� ���
-- ���� ���� ���� ���ܿ� �ִ� ��� 
-- ��Ʈ�� ���� ���̴� �׳� �߰� ���� ��� 
-- SQL SERVER���� �� ��忡 �ش�Ǵ� ���� ��������. (�������� 8Kbyte)
-- �ƹ��� ���� �����͸� �� ���� �����ص� �� �� ������(8Kbyte)�� �����ϰ� �ȴٴ� �ǹ�
-- B-Tree ������ �ƴ϶�� ���� �������� �����Ͽ� �׳� ó������ �˻��ϰ� �ȴ�. 
-- B-Tree ������ SELECT �ӵ��� �ް��ϰ� ���� 

-- ���� ���� �������� �� ������ ���ٸ� ������ ���� �۾��� �Ͼ. 

------------------- Ŭ������ 
USE tempdb;
CREATE TABLE clusterTbl
( userID char(8) NOT NULL,
  name nvarchar(10) NOT NULL
);
GO
INSERT INTO clusterTbl VALUES('LSG', '�̽±�');
INSERT INTO clusterTbl VALUES('KBS', '�����');
INSERT INTO clusterTbl VALUES('KKH', '���ȣ');
INSERT INTO clusterTbl VALUES('JYP', '������');
INSERT INTO clusterTbl VALUES('SSK', '���ð�');
INSERT INTO clusterTbl VALUES('LIB', '�����');
INSERT INTO clusterTbl VALUES('YJS', '������');
INSERT INTO clusterTbl VALUES('EJW', '������');
INSERT INTO clusterTbl VALUES('JKW', '������');
INSERT INTO clusterTbl VALUES('BBK', '�ٺ�Ŵ');

SELECT * FROM clusterTbl; --�Է��� ������ ����
GO
ALTER TABLE clusterTbl
		ADD CONSTRAINT PK_clusterTbl_userID
				PRIMARY KEY (userID);
SELECT * FROM clusterTbl; --userID�� �������� ���� �ֳĸ� PRIMARY KEY�� ���������Ƿ� Ŭ�������� �ε����� �����Ǿ���. 
-- Ŭ�������� �ε����� �������� �˻� �ӵ��� ��Ŭ�������� �ε������� �� ������.
GO
---------------- ��Ŭ������
USE tempdb;
CREATE TABLE nonclusterTbl
( userID char(8) NOT NULL,
  name nvarchar(10) NOT NULL
);
GO
INSERT INTO nonclusterTbl VALUES('LSG', '�̽±�');
INSERT INTO nonclusterTbl VALUES('KBS', '�����');
INSERT INTO nonclusterTbl VALUES('KKH', '���ȣ');
INSERT INTO nonclusterTbl VALUES('JYP', '������');
INSERT INTO nonclusterTbl VALUES('SSK', '���ð�');
INSERT INTO nonclusterTbl VALUES('LIB', '�����');
INSERT INTO nonclusterTbl VALUES('YJS', '������');
INSERT INTO nonclusterTbl VALUES('EJW', '������');
INSERT INTO nonclusterTbl VALUES('JKW', '������');
INSERT INTO nonclusterTbl VALUES('BBK', '�ٺ�Ŵ');

SELECT * FROM nonclusterTbl; --�Է��� ������ ����
GO
ALTER TABLE nonclusterTbl
		ADD CONSTRAINT PK_nonclusterTbl_userID
				UNIQUE (userID);
SELECT * FROM nonclusterTbl; --��Ŭ�����ʹ� ��ȭ ���� 
-- ��Ŭ�����ʹ� Ŭ�������� �ε����� �޸� '������ ��ȣ + #������'�� ��ϵǾ� �ٷ� �������� ��ġ�� ����Ű�� �ȴ�. 

INSERT INTO clusterTbl VALUES('FNT', 'Ǫ��Ÿ');
INSERT INTO clusterTbl VALUES('KAI', 'ī����');

INSERT INTO nonclusterTbl VALUES('FNT', 'Ǫ��Ÿ');
INSERT INTO nonclusterTbl VALUES('KAI', 'ī����');

-- Ŭ�������� �ε����� �����ÿ��� ������ ������ ��ü�� �ٽ� ���ĵȴ�. -- �̹� ��뷮�� �����Ͱ� �Էµ� ���¶� �� �����ð��� Ŭ�������� �ε����� �����ϴ� ���� �ɰ��� �ý��� ���ϸ� �� �� �����Ƿ� �����ϰ� �����ؾ� �Ѵ�.-- Ŭ�������� �ε����� �ε��� ��ü�� ���� �������� �� �����ʹ�. �ε��� ��ü�� �����Ͱ� ������ �Ǿ��ִٰ� �� ���ִ�. -- ��Ŭ������������ �˻� �ӵ��� �� ������. ������, �������� �Է�/����/������ �� ������. -- Ŭ������ �ε����� ������ ������ ���̺� �� ���� ������ �� �ִ�. -- �׷��Ƿ� ��� ���� Ŭ�������� �ε����� �����ϴ��� ���� �ý����� ������ �޶��� �� �ִ�.-- ��Ŭ�������� �ε����� ���� �ÿ��� ������ �������� �׳� �� ���¿��� ������ �������� �ε����� �����Ѵ�.-- ��Ŭ�������� �ε����� �ε��� ��ü�� ���� �������� �����Ͱ� �ƴ϶�, �����Ͱ� ��ġ�ϴ� ������(RID)��. -- Ŭ������������ �˻� �ӵ��� �� ��������, �������� �Է�/����/������ �� ������. -- ��Ŭ�������� �ε����� ���� �� ������ ���� �ִ�. ������, �Ժη� ������ ��쿡�� -- ������ �ý��� ������ ����߸��� ����� �ʷ��� �� �����Ƿ� �� �ʿ��� ������ �����ϴ� ���� ����.-----------------------Ŭ������ ��Ŭ�������� �ε��� ȥ�� USE tempdb;
CREATE TABLE mixedTbl
( userID char(8) NOT NULL,
  name nvarchar(10) NOT NULL,
  addr nchar(2)
);
GO
INSERT INTO mixedTbl VALUES('LSG', '�̽±�', '����');
INSERT INTO mixedTbl VALUES('KBS', '�����', '�泲');
INSERT INTO mixedTbl VALUES('KKH', '���ȣ', '����');
INSERT INTO mixedTbl VALUES('JYP', '������', '���');
INSERT INTO mixedTbl VALUES('SSK', '���ð�', '����');
INSERT INTO mixedTbl VALUES('LIB', '�����', '����');
INSERT INTO mixedTbl VALUES('YJS', '������', '�泲');
INSERT INTO mixedTbl VALUES('EJW', '������', '���');
INSERT INTO mixedTbl VALUES('JKW', '������', '���');
INSERT INTO mixedTbl VALUES('BBK', '�ٺ�Ŵ', '����');
GO
ALTER TABLE mixedTbl
		ADD CONSTRAINT PK_mixedTbl_userID
				PRIMARY KEY (userID);
GO
ALTER TABLE mixedTbl
		ADD CONSTRAINT PK_mixedTbl_name
				UNIQUE (name);
GO
EXEC sp_helpindex mixedTbl;

SELECT addr FROM mixedTbl WHERE name = '�����';

SELECT * FROM mixedTbl WHERE userID = 'LJB';

SELECT * FROM mixedTbl;

-------------------------------------------------
-- �ε��� ����/����/����

---- �ε��� ���� 
--PAD_INDEX�� FILLFACTOR 
--PAD_INDEX�� �⺻���� OFF�̸� ���� ON���� �����Ǿ��ٸ� FILLFACTOR�� ������ ���� �ǹ̸� ���� �ȴ�. 
--�̴� �ε��� �������� ������ �� �󸶸�ŭ�� ������ �ΰڳĴ� �ǹ�
--�� ���� �������� ������ SQL SERVER�� �ε��� �����ÿ� �ε��� �������� �� ���� ���ڵ带 �Է��� ������ ���� ���� �� ä���. 

--SORT_IN_TEMPDB
--ON���� �����ϸ� ��ũ�� �и� ȿ���� �߻��� �ε����� �����ϴµ� ��� �ð��� ���� ���� �ִ�. ����Ʈ�� OFF
--�ε����� ������ �� �ʿ�� �ϴ� �ӽ� ������ �б�/���� �۾��� TEMPDB���� �����ϰڴٴ� �ǹ�

--ONLINE 
--ONLINE�� ����Ʈ�� OFF�̴�. ON���� �����ϸ� �ε��� ���� �߿��� �⺻ ���̺� ������ ����
--��ö� �ߴܵǾ �ȵǴ� �ý��ۿ��� ����

--MAXDOP
--�ε��� ���� �ÿ� ����� CPU�� ������ ������ ����
--�ִ� 64���� ������ �� �ִ�.

--DATA_COMPRESSION
--�ε����� ������ �������� ����
GO

---- �ε��� ����

--REBUILD
--�ε����� �����ϰ� �ٽ� �����ϴ� ȿ��
--����, ��Ŭ�������� �ε����� ��� ������ ����ġ�� ����ٸ�, �ٽ� �����ؼ� ������ �ذ��� ���� �ִ�. 
--�Ʒ��� ���� SQLDB�� USERTBL�� ������ ��Ŭ�������� �ε����� ������ �ذ�����

USE sqlDB;
ALTER INDEX ALL ON userTbl
	REBUILD
	WITH (ONLINE=ON); -- ��뷮 �����ͺ��̽��� ��� �������� �Ŀ� ��ü �ε����� ������� �����ɸ� �� �����Ƿ� ONLINE=ON�� �ϸ� �ε��� ����� �߿��� �ý����� ��� ������(�ý����� ������ �� ����)

--REORGANIZE
--�ε����� �ٽ� �������ش�. REBUILD�� �޸� �ε����� �����ϰ� �ٽ� �������ִ� ���� �ƴϴ�. 
--�� �ɼ��� ����ϴ� ���� ���̺��� �������� ����ϸ� �ε����� ����ȭ�Ǿ� �ִ� ���� ����ִ� ȿ���� ���� �ý��� ���ɿ� �ణ ������ �� �� �ִ�.
GO

---- �ε��� ����
DROP INDEX ���̺��̸�.�ε����̸�
--�⺻Ű ���� ���ǰ� ����ũ ���� �������� �ڵ� ������ �ε����� DROP INDEX�� ���� �� �� ����.
--�� ��쿡�� ALTER TABLE �������� ���� ������ �����ϸ� �ε����� �ڵ����� ���� �ȴ�. 
--DROP INDEX�� �ý��� ���̺��� �ε����� ������ �� ����. 
--�ε����� ��� ������ ���� ��Ŭ������������ �����ϴ� ���� ����. 
GO

---- �ǽ� 
--1. ����
USE tempdb
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO 
--2. ������ Ȯ�� 
USE sqlDB;
SELECT *FROM userTbl;
GO

EXEC sp_helpindex userTbl; --���⼭ ���̴� �ε����� Ŭ�������� �ε�����, �ߺ����� �ʴ� �ε�����. �� UNIQUE CLUSTERED INDEX
GO

--Ŭ�������� �ε����� �̹� �����Ƿ� �� ���̺��� ���� Ŭ�������� �ε����� ������ �� ����. 
--�ּҿ� �ܼ� ��Ŭ�������� �ε��� ���� '�ܼ�'�� �ߺ��� ����Ѵٴ� �ǹ̷� ������ �ݴ��� ����

CREATE INDEX idx_userTbl_addr
		ON userTbl(addr);
GO
EXEC sp_helpindex USERTBL;

--������� ���ð��� 1979������ �ߺ��̿��� ����⵵���� ���� ��Ŭ�������� �ε����� ������ �� ����
--���� �̸��� ���� ��Ŭ�������� �ε����� ����
CREATE UNIQUE INDEX idx_userTbl_name
		ON userTbl(name);
GO
EXEC sp_helpindex USERTBL;
-- ������ ���� ��� �ÿ��� �̸��� �ߺ��Ǵ� ����� �����Ƿ� �̷��� �ϸ� �ȵǰ� �ֹι�ȣ�� �й� �̸��� �ּҷ� �����ؾ���

-- ���� �̸��� ����⵵ ���� �����ؼ� �ε��� ����
CREATE NONCLUSTERED INDEX idx_userTbl_name_birthYear
		ON userTbl(name, birthYear);
GO
EXEC sp_helpindex USERTBL;

--�Ʒ��� ���� �������� ��������� �̷� ������ ���� ������� �ʴ´ٸ� �� �ε����� ���ɿ� ���� ������ �ش�. 
SELECT *FROM userTbl WHERE name = '������' AND birthYear = '1969';
GO

--�޴��� ���� ���� �ε����� ����
CREATE NONCLUSTERED INDEX idx_userTbl_mobile1
		ON userTbl(mobile1);
GO
SELECT *FROM userTbl WHERE mobile1 = '011';
-- ���� ������ �󸶵��� �ʾ� ���°� �� ����. (���� ��ȹ������ Clustered Index Scan���� ���� �ε����� ������� �ʰ� ��ü ���̺��� �˻��� �Ͱ� �Ȱ��� ����)

--�ε��� ���� 
EXEC sp_helpindex USERTBL;

DROP INDEX USERTBL.idx_userTbl_addr;
DROP INDEX USERTBL.idx_userTbl_mobile1;
DROP INDEX USERTBL.idx_userTbl_name;
DROP INDEX USERTBL.idx_userTbl_name_birthYear;

DROP INDEX USERTBL.PK__userTbl__CB9A1CDF5C49B816; --���� �������� ������ �ε����� DROP INDEX �������� ������ �� ����. 

EXEC sp_help USERTBL; --��ȸ
EXEC sp_help buyTbl; -- ��ȸ

--���� ������ ���� ���� �ϰ� �ִ� FK�� �����ϰ� ������ �Ѵ�.
ALTER TABLE buyTbl
	DROP CONSTRAINT FK__buyTbl__userID__25869641;
GO
ALTER TABLE USERTBL
	DROP CONSTRAINT PK__userTbl__CB9A1CDF5C49B816;
GO
EXEC sp_help USERTBL; --��ȸ 