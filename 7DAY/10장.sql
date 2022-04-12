--10�� 

-------Ʈ�����

-- ������ ���̽��� ���Ἲ�� ���� ������ �ϳ��� ���� �۾� ������ ����Ǵ� �Ϸ��� �۾� (SQL ����)
-- Ʈ������� '�����͸� �����Ű�� INSERT, UPDATE, DELETE�� ����'

USE sqlDB;
--�Ʒ��� ���� SQL���� Ʈ������� 1�� ���°�ó�� �������� 3�� ���� ���̴�.
GO
		UPDATE USERTBL SET ADDR = N'����' WHERE USERID = N'KBS' -- �����
		UPDATE USERTBL SET ADDR = N'����' WHERE USERID = N'KBS' -- �����
		UPDATE USERTBL SET ADDR = N'����' WHERE USERID = N'KBS' -- �����
GO
--���� �Ʒ��� ���� 3���� Ʈ������� �ϳ��� ���� �۾��̴�. 
BEGIN TRAN 
		UPDATE USERTBL SET ADDR = N'����' WHERE USERID = N'KBS' -- �����
		UPDATE USERTBL SET ADDR = N'����' WHERE USERID = N'KBS' -- �����
		UPDATE USERTBL SET ADDR = N'����' WHERE USERID = N'KBS' -- �����
COMMIT TRAN
-- Ʈ����� �α� ������ ���� �߻� �ÿ� �������� ���Ἲ�� �������ִ� ������ �Ѵ�. 
GO

---- Ʈ������� Ư��
--���ڼ�
--Ʈ������� �и��� �� ���� �ϳ��� �����ν�, �۾��� ��� ����ǰų� �ϳ��� ������� �ʾƾ� �Ѵ�. 

--�ϰ���
--Ʈ����ǿ��� ���Ǵ� ��� �����ʹ� �ϰ��Ǿ�� �Ѵ�. �� �ϰ����� ��ݰ� ������ ���.

--�ݸ���
-- ���� Ʈ����ǿ��� �����ϰ� �ִ� �����ʹ� �ٸ� Ʈ����ǿ��� �ݸ��Ǿ�� �Ѵٴ� ���� �ǹ��Ѵ�.
-- Ʈ������� �߻��Ǳ� ���� ���³� �Ϸ�� ���� ���¸� �� ���� ������, Ʈ������� ���� ���� �߰� �����͸� �� �� ����.

--���Ӽ�
-- Ʈ������� ���������� ����ȴٸ� �� ����� �ý��� ������ �߻��ϴ��� �ý��ۿ� ���������� ����ȴ�.

--�ǽ�
USE tempdb;
CREATE TABLE BankBook
	(uName NVARCHAR(10),
	 uMoney INT,
		CONSTRAINT CK_money
		CHECK (uMoney >=0)
	);
GO
INSERT INTO BankBook VALUES(N'������', 1000);
INSERT INTO BankBook VALUES(N'�Ǹ���', 0);

--1. ���� ������ �Ǹ��� ���·� 500���� �۱��Ϸ��� �켱 ������ ���¿��� 500���� ���� �Ǹ��� ���¿� ������
UPDATE BankBook SET uMoney = uMoney -500 WHERE uName = N'������';
UPDATE BankBook SET uMoney = uMoney +500 WHERE uName = N'�Ǹ���';
SELECT *FROM BankBook;

-- ���� �������� ������ ���� ������ ���� ���̴�. (���� X)
BEGIN TRAN
	UPDATE BankBook SET uMoney = uMoney -500 WHERE uName = N'������';
COMMIT TRAN

BEGIN TRAN
UPDATE BankBook SET uMoney = uMoney +500 WHERE uName = N'�Ǹ���';
COMMIT TRAN

--2. �̹����� �����ڰ� �Ǹ��ڿ��� 600���� �۱�
UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'������';
UPDATE BankBook SET uMoney = uMoney +600 WHERE uName = N'�Ǹ���';
SELECT *FROM BankBook;
--������ ���¿��� ���� ���������� �ʰ� �Ǹ��� ���¿� 600���� �ԱݵǴ� ������� �߻�
--������ ������ ����. (���� X)
BEGIN TRAN
	UPDATE BankBook SET uMoney = uMoney -500 WHERE uName = N'������';
	-- ������ �߻��Ǿ� ������ �ȵ�(���� Ʈ������� 1�� Ʈ����ǿ� �ѹ��� �Ͼ ������ ����)
COMMIT TRAN

BEGIN TRAN
	UPDATE BankBook SET uMoney = uMoney +500 WHERE uName = N'�Ǹ���';
	-- ���������� �����
COMMIT TRAN
-- �ᱹ 1�� Ʈ����ǰ� 2�� Ʈ������� ���� ������� ���������� ����Ǿ� �̷��� ���� ������ �߻��� ��

--3. �̷��� ���� �� ���� UPDATE�� �ϳ��� Ʈ��������� ����� �Ѵ�. 
-- ���� '�Ǹ���'�� ���¸� ������� ����
UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'�Ǹ���';
-- �ΰ��� UPDATE�� ���´�.
BEGIN TRAN
	UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'������';
	UPDATE BankBook SET uMoney = uMoney +600 WHERE uName = N'�Ǹ���';
COMMIT TRAN
SELECT *FROM BankBook; -- �����൵ ���� ������ �߻�
-- �ֳĸ� ���� ������ ���� ������ �ѹ��� ���� �ʱ� ������ ���� ������ ���� �߻� �ÿ� ������ �ѹ��� ������� �Ѵ�.
-- ��, ù ��° UPDATE���� ������ ���¿��� 600���� ���� ��, ������ �߻��Ǿ� �� �ุ ������ ���� ���� ���� ��, �ѹ��� ����� ���� �ƴ�
-- �ٽ� '�Ǹ���'�� ���¸� ������� ����
UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'�Ǹ���';
--TRY CATCH ������ �̿�
BEGIN TRY
	BEGIN TRAN
		UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'������';
		UPDATE BankBook SET uMoney = uMoney +600 WHERE uName = N'�Ǹ���';
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SELECT *FROM BankBook;


--����� Ʈ����ǰ� �Ͻ��� Ʈ����� 
USE tempdb;
--1-1 ���� Ʈ������� ������ ������ ���̺� ����
CREATE TABLE testTbl (id int IDENTITY); -- INSERT �׽�Ʈ��
CREATE TABLE tranTbl (save_id int, tranNum int); -- Ʈ����� ������ ����

--1-2 testTbl�� Ʈ���Ÿ� ���� (���� Ʈ���Ÿ� ����� ����)
CREATE TRIGGER trgTranCount
		ON testTbl
		FOR INSERT
	AS
		DECLARE @id int;
		SELECT @id = id FROM inserted;
		INSERT INTO tranTbl VALUES (@id, @@TRANCOUNT);
-- testTbl�� Insert�� �߻��� ��� testTbl�� id�� ���� �߻��� Ʈ������� ����(�ý��� �Լ� @@TRANCOUNT)�� tranTbl�� �ڵ����� �����Ѵٴ� �ǹ�
 GO
-- �Ʒ� ������ 3���� ����
INSERT INTO testTbl DEFAULT VALUES;
-- ������ Ȯ��
SELECT *FROM testTbl;
SELECT *FROM tranTbl;
-- ����� Ȯ���غ��� tranNum�� 0�� �ƴϹǷ�, �� insert�� ���� �ø��� Ʈ������� �߻����� Ȯ���� �� �ִ�. �� �ڵ� Ŀ�� Ʈ������� ���ǰ� �ִٴ� �ǹ�

---- ����� Ʈ�����
--1.1
BEGIN TRAN
	PRINT 'BEGIN ���� Ʈ����� ����==> ' + CAST (@@TRANCOUNT AS CHAR(3));
COMMIT TRAN
PRINT 'COMMIT �Ŀ� Ʈ����� ����==> ' + CAST (@@TRANCOUNT AS CHAR(3));
-- ����� Ʈ����ǿ� ���ؼ� Ʈ������� �߻��Ǵ� ���� Ȯ���� �� �ִ�.

--1.2 ��������� ��ø�� Ʈ������� Ȯ��
BEGIN TRAN
	BEGIN TRAN
		PRINT 'BEGIN 2�� ���� Ʈ����� ����==> ' + CAST (@@TRANCOUNT AS CHAR(3));
	COMMIT TRAN
		PRINT 'BEGIN 1�� ���� Ʈ����� ����==> ' + CAST (@@TRANCOUNT AS CHAR(3));
COMMIT TRAN
PRINT 'COMMIT �Ŀ� Ʈ����� ����==> ' + CAST (@@TRANCOUNT AS CHAR(3));

--1.3 �ѹ��� ���Ѻ��ٸ�? SELECT�� � ���� ������ �����Ѵٸ�?
CREATE TABLE #tranTest (id int);
INSERT INTO #tranTest VALUES(0);
GO
BEGIN TRAN --1�� Ʈ�����
	UPDATE #tranTest SET id =111;
	BEGIN TRAN --2�� Ʈ�����
		UPDATE #tranTest SET id =222;
		SELECT *FROM #tranTest;
	ROLLBACK TRAN -- ù ��° �ѹ�
		SELECT *FROM #tranTest;
ROLLBACK TRAN -- �� ��° �ѹ� (����)
SELECT *FROM #tranTest;
--�ѹ��� �ٷ� ���� Ʈ����Ǳ����� �ѹ��ϴ� ���� �ƴ϶�, ��� Ʈ������� �ѹ��ϱ� ������ �� ��° �ѹ��� ����

--1.4 ���� ���ϴ� ���������� �ѹ��� �ϰ� �ʹٸ�? SAVE TRAN ���
BEGIN TRAN --1�� Ʈ�����
	UPDATE #tranTest SET id =111;
	SAVE TRAN [tranPoint1]
	BEGIN TRAN --2�� Ʈ�����
		UPDATE #tranTest SET id =222;
		SELECT *FROM #tranTest;
	ROLLBACK TRAN [tranPoint1] -- ù ��° �ѹ� ([tranPoint1]���� �ѹ�)
		SELECT *FROM #tranTest;
ROLLBACK TRAN -- �� ��° �ѹ� (����)
SELECT *FROM #tranTest;
GO

---- �Ͻ��� Ʈ�����
--2.1 �Ͻ��� Ʈ������� ����ϴ� ����
SET IMPLICIT_TRANSACTIONS ON;

--2.2 ��� ������ ����
USE tempdb;
CREATE DATABASE tranDB;
GO

USE tranDB;
CREATE TABLE tranTbl (id int); -- �� ������ Ʈ������� ����
GO

INSERT INTO tranTbl VALUES(1);
INSERT INTO tranTbl VALUES(2);

SELECT *FROM tranTbl;

--3.3 ��â���� �Ʒ��� ������ �����ϸ� tranTbl�� �۵� ���� Ʈ������� Ŀ�Ե��� �ʾƼ� ����ؼ� ������ �����ϴ� ������ ��
USE tranDB;
SELECT *FROM tranTbl;

--3.4 ������ ����â���� �ѹ��Ŵ
ROLLBACK TRAN;
-- �׷��� ������ �����ϴ� ���� �����޽����� ����Ǿ��ִ� ���� �� �� �ִ�.
GO
--3.5 ��� 
CREATE TABLE tranTbl (id int); -- �� ������ Ʈ������� ����
GO
INSERT INTO tranTbl VALUES(1);
SELECT @@TRANCOUNT; -- 1
BEGIN TRAN --Ʈ����� 1�� �߰�
		INSERT INTO tranTbl VALUES(2);
		SELECT @@TRANCOUNT; --2
COMMIT TRAN --  -1

SELECT @@TRANCOUNT; -- 1 

BEGIN TRAN --Ʈ����� 1�� �߰�
		INSERT INTO tranTbl VALUES(3);
		SELECT @@TRANCOUNT; --2
ROLLBACK TRAN  --  -2

SELECT @@TRANCOUNT; -- 0
SELECT *FROM tranTbl; -- �̹� �ѹ�Ǿ� ����(����)
GO
--3.6 �ٽ� �ڵ� Ŀ�� Ʈ����� ���� ���� 
SET IMPLICIT_TRANSACTIONS OFF;
