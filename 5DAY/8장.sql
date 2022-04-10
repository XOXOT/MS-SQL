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
CREATE TABLE userTbl1 -- ȸ�����̺�
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
CREATE TABLE buyTbl1 --ȸ�� ���� ���̺�
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



--UNIQUE ��������
--CHECK ���� ����
--DEFAULT ���� 
--NULL �� ��� 



