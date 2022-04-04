--SQL 3�� 2022-04-04

--SELECT * FROM	memberTBL;
--GO

--SELECT memberName, memberAddress from memberTBL;

--select *from memberTBL where memberName = '������';

--create table "my testTBL" (id INT); //���̺� ���� ������

--DROP TABLE [my testTBL]; //���̺� ���� ������ 

--select * from productTBL where productName = '��Ź��';

------------------------------------------------------------------
--�ε���(å �ǵ��� ã�ƺ��� ����)

--USE ShopDB; -- ShopDB�� �� ���̴�
--SELECT Name, ProductNumber, ListPrice, Size INTO indexTBL FROM AdventureWorks2016CTP3.Production.Product;
--GO --AdventureWorks���� indexTBL�� ShopDB ���̺�� �����ϴ� �ڵ� 
--SELECT * FROM indexTBL; -- ShopDB ���� ���̺� �̸� 

--SELECT * FROM indexTBL WHERE Name = 'minipump'; --�ε����� ������� �ʰ�  ���̺� ��ĵ(���̺� ��ü�� �˻�)
--create INDEX idx_indexTBL_Name ON indexTBL(Name); 
--���� ��ȹ ���Զ��� Index Seek(�ε����� ���) �� å ��ü�� ����ϴ� ���� �ƴ� ã�ƺ��⿡�� minipump�� ã�� �ű⿡ ���ִ� �������� �ٷ� �켭 �˻��ϴ� ��ɰ� ����.

------------------------------------------------------------------
--��(������ ���̺�) ����� ���忡���� ���̺�� �����ϰ� ��������, ��� ���� �� �����͸� ������ ���� ���� 
CREATE VIEW uv_memberTBL -- �� ���� 
AS
SELECT memberName, memberAddress FROM memberTBL; -- ���� �� ���� ������ ����

SELECT *FROM uv_memberTBL; --���� �� ��ȸ 

------------------------------------------------------------------

--���� ���ν���(SQL���� �ϳ��� ��� ���ϰ� ����ϴ� ���)

SELECT * FROM memberTBL WHERE memberName = '������';
SELECT * FROM productTBL WHERE productName = '�����';
--�̷��� �ΰ��� �������� 

CREATE PROCEDURE myProc --���ν��� ���� CREARE PROCEDURE �̸� AS ���ϴ� ������ GO
AS
SELECT * FROM memberTBL WHERE memberName = '������';
SELECT * FROM productTBL WHERE productName = '�����';
GO

EXECUTE myProc; -- EXECUTE ���ν��� ȣ��
------------------------------------------------------------------
--DROP�� 
--DROP ��ü����(VIEW�� PROCEDURE ���) �ش� �̸�
--DROP PROCEDURE myProc; -- myProc ���ν��� ����
------------------------------------------------------------------

--Ʈ����(���̺� INSERT�� DELETE UPDATE �۾��� �߻��Ǹ� ����Ǵ� �ڵ�)
-- ���� ��� �����̰� ȸ��Ż�� �ߴµ� ���߿� Ż���� ����� �����ΰ��� �� �� ���� ������ �������� �� �����͸� �ٸ� ���� ���� ������ �ڵ����� ����

--1. ȸ�� ���̺� ���ο� ȸ���� ���� �Է�
INSERT INTO memberTBL VALUES ('Figure', '����', '��⵵ ������ ������'); --������ ���� INSERT INTO ���̺�� (�÷��� (�����ϸ� ��ü) VALUES (�÷��� �� ������) 

--2. ���ο� ȸ�� �ּҸ� �ٲ���
UPDATE memberTBL SET memberAddress = '���� ������ ���ﵿ' WHERE memberName = '����'; --������ ������Ʈ UPDATE ���̺�� SET �÷��� WHERE ����

--3. ���ο� ȸ���� Ż�� ������ ȸ�� ���̺��� ����
DELETE memberTBL WHERE memberName = '����';

--4. ��ü memberTBL ��ȸ (���� ���� Ȯ��)
SELECT * FROM memberTBL;

--5. ������ �����͸� ������ ���̺��� ���� (���� ��¥ �߰�)
CREATE TABLE deletedMemberTBL
(memberID char(8), memberName nchar(5), memberAddress nchar(20), deleteDate date);

CREATE TRIGGER trg_deletedMemberTBL
ON memberTBL 
AFTER DELETE
AS
INSERT INTO deletedMemberTBL SELECT memberID, memberName, memberAddress, GETDATE() FROM deleted; --GETDATE()�� ���� ��¥

--6. ȸ�� ���̺� Ȯ��
SELECT * FROM memberTBL;

--7. ������ ����
DELETE memberTBL WHERE memberName = '������';

--8. ȸ�� ���̺� �� ��� ���̺� Ȯ��
SELECT * FROM memberTBL; --ȸ�����̺�
SELECT * FROM deletedMemberTBL; -- ��� ���̺� 

------------------------------------------------------------------

-- ��� 

USE ShopDB;
SELECT * FROM productTBL;

-- ShopDB ������ Ŭ�� �� �׽�ũ -> ��� ShopDB(������ ���̽� ����) ����� ��ġ ����
--ShopDB.bak ���� ���� 

--��� �߻� ��Ű��
--DELETE FROM productTBL; 

--��ȸ 
SELECT * FROM productTBL;

USE tempDB; --����ִ� DB�� �����Ͽ� ShopDB�� ���õ� ����â�� ���� ����
-- �����ͺ��̽� ������ Ŭ�� �� �����ͺ��̽� ���� ������ ����� BAK ���� �ҷ��� 

   USE ShopDB
   GO 
   SP_CHANGEDBOWNER 'sa'

   sp_helpdb 'ShopDB'

   SELECT NAME, OWNER_SID FROM SYS.DATABASES;

   SELECT SID FROM SYS.SYSLOGINS;
