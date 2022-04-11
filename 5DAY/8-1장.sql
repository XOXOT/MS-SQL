--8�� ���̺�� ��  

USE tempdb;
GO 
CREATE DATABASE tableDB;

--���̺��� ����� ���� dbo�� ��Ű���� �̸��̴�. 

--�Է� �Ǽ� �Ǵ� ������ �ٽ� �Է��� ��� IDENTITY ���� ������ NUM ���� ó������ ���ư��� �ʰ�
--��� ������ ������ �Է��� �Ǵµ� �̷� ��쿡�� 
USE tableDB;
DBCC CHECKIDENT('buyTbl');
DBCC CHECKIDENT('buyTbl',RESEED,0); -- DBCC CHECKIDENT('���̺��̸�',RESEED,�ʱⰪ);
--�̷��� �������ָ� �ȴ�.

------------T-SQL�� ����
USE tableDB;
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
FOREIGN KEY REFERENCES userTbl(userID), --�ܷ� Ű ���� 
prodName NCHAR(6) NOT NULL, --��ǰ��
groupName NCHAR(4), --�з�
price INT NOT NULL, --�ܰ�
amount SMALLINT NOT NULL -- ����
);
GO
----NOT NULL �����ϸ� NULL�� ����Ʈ�̸� �����ִ� ���� ������
--IDENTITY(SEED, INCREMENT) ���� �����ϸ� �ڵ����� IDENTITY(1,1)�̸� �����ִ� ���� ������

INSERT INTO userTbl VALUES('LSG', N'�̽±�', 1987, N'����', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTbl VALUES('KBS', N'�����', 1979, N'�泲', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTbl VALUES('KKH', N'���ȣ', 1971, N'����', '019', '3333333', 177, '2007-7-7');

INSERT INTO buyTbl VALUES('KBS', N'�ȭ',  NULL, 30, 2);
INSERT INTO buyTbl VALUES('KBS', N'��Ʈ��', N'����',1000,1);
INSERT INTO buyTbl VALUES('JYP', N'�����', N'����',200,1); -- ����

--�������� 
--PRIMARY KEY ��������

--�Ʊ� ��ó�� �ٷ� PRIMARYŰ�� �Է����൵ ������ �⺻Ű�� ������ �� ������ ���� ���� �� �� �ִ�
CREATE TABLE userTbl2 -- ȸ�����̺�
(userID CHAR(8) NOT NULL PRIMARY KEY, --����� ���̵�
);

--�̰��� �Ʒ��� ���� �⺻ Ű�� �̸��� �����ϴ� ���̴�. 

CREATE TABLE userTbl3 -- ȸ�����̺�
(userID CHAR(8) NOT NULL
	CONSTRAINT PK_userTbl_userID PRIMARY KEY, );
GO
-- �̷��� �����ϰų� 
-- ��翭�� �����ϰ� ���� �� �������� ���� �� ���� �ִ�. 
CREATE TABLE userTbl4 -- ȸ�����̺�
(userID CHAR(8) NOT NULL, --����� ���̵�
name   NVARCHAR(10) NOT NULL, -- �̸�
birthYear INT NOT NULL, --����⵵
addr NCHAR(2) NOT NULL, --����(���, ����, �泲 ������ 2���ڸ� �Է�)
mobile1 CHAR(3), -- �޴����� ����(011, 016, 017, 019, 010 ��)
mobile2 CHAR(8), -- �޴����� ������ ��ȭ��ȣ(������ ����)
height SMALLINT, --Ű
mDate DATE -- ȸ��������
CONSTRAINT PK_userTbl4_userID PRIMARY KEY -- �̷��� ������ �࿡ ���� ���� 
);
GO
-- ���������� ���ϳ��� ����� ALTER TABLE���� ����ϴ� ���̴�. 
--��� ���� �����ϰ� ���� �Ʒ��� ���� �� �߰����ش�. 

ALTER TABLE userTbl -- userTbl�� �������� 
	ADD CONSTRAINT PK_userTbl_userID -- ���������� �߰����� �߰��� �������� �̸��� PK_userTbl_userID
	PRIMARY KEY (userID); -- �߰��� ���������� �⺻ Ű ���� �����̴�. �׸��� ���� ������ ������ ���� userID ���̴�.
GO

--�⺻Ű�� �ϳ��� ���θ� �����ؾ� �ϴ� ���� �ƴϴ�. �ʿ信 ���� �� �� �̻����� ��������.
--���� ��ǰ�ڵ尡 AAA�� �����, BBB�� ��Ź��, CCC�� TV��� �����ϸ� ���� ��ǰ�ڵ常���δ� 
-- �ߺ��� ���ۿ� �����Ƿ�, �⺻ Ű�� ������ �� ���� ��ǰ �Ϸù�ȣ�� ���������� ǰ���� 
-- 0001������ �ο��ϴ� ü��� �⺻ Ű�� ������ ���� �����Ƿ� '��ǰ�ڵ� + ��ǰ�Ϸù�ȣ'�� Ű�� ����

CREATE TABLE prodTbl
(prodCode NCHAR(3) NOT NULL,
 prodID NCHAR(4) NOT NULL,
 prodDate SMALLDATETIME NOT NULL,
 prodCur NCHAR(10) NULL
);
GO
ALTER TABLE prodTbl
		ADD CONSTRAINT PK_prodTbl_proCode_prodID
		PRIMARY KEY (prodCode, prodID);
GO

--�Ǵ� CREATE TABLE ���� �ȿ� ���� ��� ����
DROP TABLE prodTbl;
GO
CREATE TABLE prodTbl
(prodCode NCHAR(3) NOT NULL,
 prodID NCHAR(4) NOT NULL,
 prodDate SMALLDATETIME NOT NULL,
 prodCur NCHAR(10) NULL,
 CONSTRAINT PK_prodTbl_proCode_prodID
		PRIMARY KEY (prodCode, prodID)
);

EXEC sp_help prodTbl -- ���̺� Ȯ�� 

----------------------------------------------------
--FOREIGN KEY ��������
-- �ܷ� Ű ���̺� �����͸� �Է��� ���� �� ���� ���̺��� ���� �ؼ� �Է��ϹǷ�, ���� ���̺� �̹� �����Ͱ� �����ؾ� �Ѵ�. 
-- �տ� �ǽ����� buyTbl�� JYP(������)�� �Է��� �ȵǴ� ���� Ȯ���ߴµ� �װ��� �ܷ� Ű ���� ������ �����߱� �����̴�. 
--1.
CREATE TABLE buyTbl --ȸ�� ���� ���̺�
(num INT IDENTITY NOT NULL PRIMARY KEY,
userID CHAR(8) NOT NULL --���̵�(FK)
FOREIGN KEY REFERENCES userTbl(userID), --�ܷ� Ű ���� (ù�� ° ���)
prodName NCHAR(6) NOT NULL, --��ǰ��
);
GO
--2.
CREATE TABLE buyTbl --ȸ�� ���� ���̺�
(num INT IDENTITY NOT NULL PRIMARY KEY,
userID CHAR(8) NOT NULL --���̵�(FK)
	CONSTRAINT FK_userTbl_buyTbl --�ܷ� Ű �̸� ����
	FOREIGN KEY REFERENCES userTbl(userID), --�ܷ� Ű ���� (�ι� ° ���)
prodName NCHAR(6) NOT NULL,); --��ǰ��
GO
--3.
CREATE TABLE buyTbl --ȸ�� ���� ���̺�
(num INT IDENTITY NOT NULL PRIMARY KEY, -- ����(IDENTITY�� �ڵ� ���� ������)(PK)
userID CHAR(8) NOT NULL --���̵�(FK)
prodName NCHAR(6) NOT NULL, --��ǰ��
groupName NCHAR(4), --�з�
price INT NOT NULL, --�ܰ�
amount SMALLINT NOT NULL -- ����
CONSTRAINT FK_userTbl_buyTbl --�ܷ� Ű �̸� ����
	FOREIGN KEY REFERENCES userTbl(userID),); --�� �������� �ܷ� Ű ���� (���� ° ���)
GO
--4. 
CREATE TABLE buyTbl --ȸ�� ���� ���̺�
(num INT IDENTITY NOT NULL PRIMARY KEY, -- ����(IDENTITY�� �ڵ� ���� ������)(PK)
userID CHAR(8) NOT NULL --���̵�(FK)
prodName NCHAR(6) NOT NULL, --��ǰ��
groupName NCHAR(4), --�з�
price INT NOT NULL, --�ܰ�
amount SMALLINT NOT NULL -- ����
);
GO
ALTER TABLE buyTbl -- buyTbl�� �����Ѵ�.
		ADD CONSTRAINT FK_userTbl_buyTbl -- ���� ������ ���Ѵ�. ���� ���� �̸��� 'FK_userTbl_buyTbl'�� �Ѵ�.
		FOREIGN KEY (userID) -- �ܷ� Ű ���� ������ buyTbl�� userID�� �����Ѵ�,
		REFERENCES userTbl(userID); --������ ���� ���̺��� userTbl�� userID ���̴�. 
GO

--###���� 
--sp_help ���� ���ν��� �ܿ��� sp_helpconstraint ���� ���ν����� ���� ������ Ȯ���� �� �ִ�.
--�Ǵ� īŻ�α� �並 ����� �� �ִ�. �⺻ Ű�� ���õ� īŻ�α� ��� sys.key_onstraints�̸�, �ܷ� Ű�� ���õ� ���� sys.foreign_keys�̸�
-- ������ SELECT * FROM īŻ�α׺�_�̸����� Ȯ���ϸ� �ȴ�. 
------------------------------------------------------------------------------------------------
--UNIQUE ��������
-- �ߺ����� �ʴ� ������ ���� �Է��ؾ� �ϴ� ��������.
-- �⺻ Ű�� ���� ����ϸ� �������� UNIQUE�� NULL ���� ����Ѵٴ� �����̴�. �� NULL�� �� ���� ���ȴ�.
-- NULL���� �� ����� �̹� �������� �ʴٴ� ���̴�. 
-- ���� ȸ�� ���̺����� �̸��� �ּҸ� Unique�� �����ϴ� ��찡 ���� �ִ�. 
--ǥ���� 
--1.
CREATE TABLE userTbl -- ȸ�����̺�
(userID CHAR(8) NOT NULL PRIMARY KEY, --����� ���̵�
--------
 email char(30) NULL UNIQUE
);
GO
--2. 
CREATE TABLE userTbl -- ȸ�����̺�
(userID CHAR(8) NOT NULL PRIMARY KEY, --����� ���̵�
--------
 email char(30) NULL 
		CONSTRAINT AK_email UNIQUE
);
GO
--3.
CREATE TABLE userTbl -- ȸ�����̺�
(userID CHAR(8) NOT NULL PRIMARY KEY, --����� ���̵�
--------
 email char(30) NULL,
CONSTRAINT AK_email UNIQUE (email)
);
GO
------------------------------------------------------------------------------------------------
--CHECK ���� ����
--CHECK ���� ������ �ԷµǴ� �����͸� �����ϴ� ����̴�.
-- Ű�� ���̳ʽ� ���� ���� �� ���� �Ѵٰų�, ��� ������ 1900�� �����̰� ���� ���� ���� �̾�� �Ѵٵ��� ���� ������ �����Ѵ�. 

--1.��� ������ 1900�� �����̰� ���� ���� ����
ALTER TABLE userTbl
	ADD CONSTRAINT CK_birthYear
	CHECK (birthYear >= 1900 AND birthYear <= YEAR(GETDATE()));
GO

--2. �޴��� ���� üũ
ALTER TABLE userTbl
	ADD CONSTRAINT CK_mobile1
	CHECK (mobile1 IN ('010', '011', '016', '017', '018', '019'));
GO

--3. Ű�� 0�̻��̾�� ��
ALTER TABLE userTbl
	ADD CONSTRAINT CK_height
	CHECK (height >= 0);
GO

--4. WITH CHECK, WITH NOCHECK 
-- ���� �Էµ� �����Ͱ� CHECK ���� ���ǿ� ���� ���� ��쿡 ��� ó���� ������ �������ִ� ��
-- ���� 012�� �Է��ߴµ� �׳� �Ѿ�� �ϰ� ���� ���
ALTER TABLE userTbl
	WITH NOCHECK
	ADD CONSTRAINT CK_mobile1
	CHECK (mobile1 IN ('010', '011', '016', '017', '018', '019'));
GO
------------------------------------------------------------------------------------------------
--DEFAULT ���� 
-- DEFAULT�� ���� �Է����� �ʾ��� ��, �ڵ����� �ԷµǴ� �⺻ ���� �����ϴ� ����̴�. 
-- ���� ��� ����⵵�� �Է����� ������ �׳� ������ ������ �Է�, �ּҸ� Ư���� �Է����� �ʾҴٸ� ������ �Է�, Ű�� �Է����� �ʾҴٸ� 170
USE tempdb;
CREATE TABLE userTbl -- ȸ�����̺�
(userID CHAR(8) NOT NULL PRIMARY KEY, --����� ���̵�
 name   NVARCHAR(10) NOT NULL, -- �̸�
 birthYear INT NOT NULL DEFAULT YEAR(GETDATE()), --����⵵
 addr NCHAR(2) NOT NULL DEFAULT N'����', --����(���, ����, �泲 ������ 2���ڸ� �Է�)
 mobile1 CHAR(3), -- �޴����� ����(011, 016, 017, 019, 010 ��)
 mobile2 CHAR(8), -- �޴����� ������ ��ȭ��ȣ(������ ����)
 height SMALLINT NULL DEFAULT 170, --Ű
 mDate DATE unique -- ȸ�������� 
);
--ALTER TABLE ��� 
USE tempdb;
CREATE TABLE userTbl -- ȸ�����̺�
(userID CHAR(8) NOT NULL PRIMARY KEY, --����� ���̵�
 name   NVARCHAR(10) NOT NULL, -- �̸�
 birthYear INT NOT NULL DEFAULT YEAR(GETDATE()), --����⵵
 addr NCHAR(2) NOT NULL DEFAULT N'����', --����(���, ����, �泲 ������ 2���ڸ� �Է�)
 mobile1 CHAR(3), -- �޴����� ����(011, 016, 017, 019, 010 ��)
 mobile2 CHAR(8), -- �޴����� ������ ��ȭ��ȣ(������ ����)
 height SMALLINT NULL DEFAULT 170, --Ű
 mDate DATE unique -- ȸ�������� 
);
GO
ALTER TABLE userTbl
	ADD CONSTRAINT CD_birthYear
		DEFAULT YEAR(GETDATE()) FOR birthYear;
GO
ALTER TABLE userTbl
	ADD CONSTRAINT CD_addr
		DEFAULT N'����' FOR addr;
GO
ALTER TABLE userTbl
	ADD CONSTRAINT CD_height
		DEFAULT 170 FOR height;
GO
-- ������ �Է�
-- default ���� DEFAULT�� ������ ���� �ڵ� �Է��Ѵ�. 
INSERT INTO userTbl VALUES('LHL', N'���ظ�', default, default, '011' ,'1234567' , default, '2019.12.12');
-- ���̸��� ��õ��� ������ DEFAULT�� ������ ���� �ڵ� �Է��Ѵ�. 
INSERT INTO userTbl(userID, name) VALUES('KAY', N'��ƿ�');
-- ���� ���� ���Ǹ� DEFAULT�� ������ ���� ���õȴ�. 
INSERT INTO userTbl VALUES('WB', N'����', 1982, N'����', '019' ,'9876543' , 176, '2017.5.5');
GO
SELECT * FROM userTbl;
GO
------------------------------------------------------------------------------------------------
--NULL �� ��� 
-- �ƹ� �͵� ���ٴ� �ǹ� ����(' ')�̳� 0�� ���� ������ �ٸ��ٴ� �� ���� 
--1. ANSI_NULL_DEFAULT OFF �� ���̺� ����
USE tempdb
CREATE DATABASE nullDB;
GO
ALTER DATABASE nullDB
	SET ANSI_NULL_DEFAULT OFF; -- ���� �������� �ʾƵ� �⺻�� OFF
GO
USE nullDB;
CREATE TABLE t1 (id int);
GO
INSERT INTO t1 VALUES (NULL);
EXEC sp_help t1; --Nullable yes�� �Ǿ����� ��? ���� ����â�� �ɼ� �߿� ANSI_NULL_DFLT_ON �ɼ��� ON���� �����Ǿ� �ֱ� ����
--�� ���� �ɼ��� �����ͺ��̽� �ɼǺ��� �� �켱 ����Ǳ� ������ �ƹ� �͵� ������ ������ NULL�� ���� �Ͱ� ���� �� ȿ���� �ִ� ���̴�. 
--2. ������ �ɼ��� ���� �Ŀ� ����
USE tempdb;
DROP DATABASE nullDB;
GO
CREATE DATABASE nullDB;
GO
ALTER DATABASE nullDB
	SET ANSI_NULL_DEFAULT OFF; -- ���� �������� �ʾƵ� �⺻�� OFF
GO
SET ANSI_NULL_DFLT_ON OFF;
USE nullDB;
CREATE TABLE t1 (id int);
GO
INSERT INTO t1 VALUES (NULL);
EXEC sp_help t1; --Nullable NO�� �Ǿ�����
-- ANSI_NULL_DFLT_ON ������ ����â�� ������ ������� ���ư�
-- ��������� NULL�� NOT NULL�� ���� �ٿ��ִ� ���� ����