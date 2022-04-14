--------------14��

--��ü �ؽ�Ʈ �˻� 
-- �� ���ڷ� ������ ����ȭ���� ���� �ؽ�Ʈ ������(EX. �Ź����) SQL �ΰ��� ���
-- ����� �ؽ�Ʈ�� Ű���� ����� ������ ���ؼ� ���� �ε����� ���� 
-- �Ź����� ����, �ؽ�Ʈ�� �̷���� ���ڿ� �������� ������ ������ ������ �ε����� ���Ѵ�.
-- SQL SEVER���� ������ �Ϲ����� �ε����ʹ� �� ���� �������� �ִ�. 
	-- �Ϲ� �ε����� ���̺� �� ���� ���� ������ �� ������, ���� �ؽ�Ʈ �ε����� ���̺� �� �ϴϸ� ������ �� �ִ�. 
	-- �Ϲ� �ȳؽ��� Insert. Update. Delete �Ǹ� �ε����� �ڵ����� ������Ʈ �ȴ�.
	-- ��ü �ؽ�Ʈ �ε����� �����͸� �߰��ϴ� ä���� ���� �����̳� Ư���� ��û�� ���ؼ� ����ǰų�, ���ο� ����Ƽ�� lnsert �ÿ� �ڵ����� ����ǵ��� �Ѵ�.
	-- ��ü �ؽ�Ʈ �ε����� char, varchar, nchar, nvarchar, text, ntext, image, xml, varbinary (max), FILESTREAM ���� ���� ������ ����
	-- ��ü �ؽ�Ʈ �ε����� ������ ���̺��� PRIMARY KEY�� UNIQUE KEY�� �����ؾ� �Ѵ�. 
GO

-- �ǽ� 
--1. ���̺� ���� 
USE tempdb;
GO
CREATE DATABASE FulltextDB;
GO

USE FulltextDB;
CREATE TABLE FulltextTbl
(id int IDENTITY CONSTRAINT pk_id PRIMARY KEY, --���� ��ȣ
 title NVARCHAR(15) NOT NULL, --��ȭ ����
 description NVARCHAR(max)); -- ��ȭ ���� ���
GO

 --2. ���� ������ �Է�
INSERT INTO FulltextTbl VALUES('����, ���� �� ����','������ �ѷ��� �Ƿ� ������ �������� ȥ���� �ؿ� ���� ���ر� 8��');
INSERT INTO FulltextTbl VALUES('��ø','���� ���� ���尣ø 5�� ���� �Ͼ��ϰ� ������ Ư�� �Ƿ� �ٽɺο��� ħ�����ִ�.');
INSERT INTO FulltextTbl VALUES('�ǿ�Ÿ',' �� ���� ���ڰ� �´�! ��Ȥ�� ������� ���� ���� �Ǹ����� ���� ���丮.');
INSERT INTO FulltextTbl VALUES('������Ʈ �̺� 5','�η� ������ ������ ����, �� ���ڰ� ��� ���� ������.');
INSERT INTO FulltextTbl VALUES('�ı��ڵ�','����� ��� ���� �ı��Ѵ�! �� ���ڸ� ���ϱ� ����, �� ������ ������ �׼� ����!');
INSERT INTO FulltextTbl VALUES('ŷ���� ���',' ������ ����� �� �ð�ҳ���� ����� ���� ���� ��ȭ .');
INSERT INTO FulltextTbl VALUES('�׵�','�����ִ� Ȳ��ã�� ������Ʈ! 500�� �� ����� Ȳ�ݵ��ø� ã�ƶ�!');
INSERT INTO FulltextTbl VALUES('Ÿ��Ÿ��','��� �ӿ� ħ���� ������ ���, ��ũ���� �ǻ�Ƴ� ������ ����');
INSERT INTO FulltextTbl VALUES('8���� ũ��������','���Ѻ� �λ� ������� ���� ���� �ܼӿ����� �̹��� ���')
INSERT INTO FulltextTbl VALUES('����� ����','����� ģ���� ��ں� �Ʒ��� �Բ� ���� �ߴ� ���� ���� �̾߱�');
INSERT INTO FulltextTbl VALUES('������ǥ','����ø��� ��ġ�� ���� ���� ������ ��Ű���� ������ǥ���� �����ȴ�.');
INSERT INTO FulltextTbl VALUES('���ũ Ż��','�״� ������ ���� ���ũ ������ ���ݵȴ�. �׸��� �������� Ż��.');
INSERT INTO FulltextTbl VALUES('�λ��� �Ƹ��ٿ�','�͵��� ������ ȣ�ڿ��� �����ͷ� ���ϸ鼭 �� �ٽ� ���� ������.');
INSERT INTO FulltextTbl VALUES('���� ���� ����','���� ������ �����ƴ� �� Ʈ������ ��������� ����');
INSERT INTO FulltextTbl VALUES('��Ʈ����',' 2199��.�ΰ� �γ��� ���� ��ǻ�Ͱ� �����ϴ� ����.');
GO

--3. ���� ��ü �ؽ�Ʈ �ε����� ������ �ʾ����� �� ���¿��� '����'��� �ܾ �˻�
SELECT *FROM FulltextTbl WHERE description LIKE '%����%';
-- ��ĵ�� �� ���� �� �� �ִµ� �̴� ���̺� �˻��� �����ϰ� ��� ������ �������� �˻��� ���.
-- ���� �����Ͱ� �� �� ���� �ʾƼ� ������ ������, ��뷮�� �����Ͷ�� SQL SERVER�� ����� ���ϰ� ���� ���̴�.
GO

--4. ��ü �ؽ�Ʈ īŻ�α� ����
--4-1. ���� īŻ�α� ���� Ȯ��
SELECT *FROM sys.fulltext_catalogs; --�ƹ��͵� ������ �ʾ� ������ ����
GO

--4-2. īŻ�α� ����
CREATE FULLTEXT CATALOG movieCatalog AS DEFAULT;
GO

--4-3. īŻ�α� ���� �ٽ� Ȯ��
SELECT *FROM sys.fulltext_catalogs; --'is_default'�� 1�� ���� �� īŻ�αװ� ����Ʈ īŻ�α׶�� ��
GO

--5. ��ü �ε��� ���� 
--5-1. �ε��� ����
CREATE FULLTEXT INDEX ON FulltextTbl (description)
		KEY INDEX pk_id
		ON movieCatalog
		WITH CHANGE_TRACKING AUTO;

-- CREATE FULLTEXT INDEX ON FulltextTbl (description)
	-- FulltextTbl ���̺��� description ���� ��ü �ؽ�Ʈ �ε����� ����

-- KEY INDEX pk_id
	-- ���� �ÿ� Ű ���� �տ��� Primary Key�� ������ pk_id�� ����

-- ON movieCatalog 
	-- �����Ǵ� īŻ�α״� movieCatalog�� �����ǵ��� �Ѵ�.
	-- īŻ�α� ���� �ÿ� ����Ʈ�� movieCatalog�� ���������Ƿ�, �� �ɼ��� �����ص� �ȴ�.

-- WITH CHANGE_TRACKING AUTO
	-- ����� ������ ���������� SQL SERVER�� �ڵ����� �����ϵ��� �����Ѵ�.(�� �ɼ��� ������ ���� �Ͼ ��쿡 �ý��� ���ɿ� ���� ������ �� �� �ִ�.)

GO

--5-2. ���� Ȯ��
SELECT *FROM sys.fulltext_indexes; --is_enabled�� 1�̶�� ���� ��ü �ؽ�Ʈ�� Ȱ��ȭ ���� ���̴�. 

--5-3. �̹����� ��ü �ؽ�Ʈ �ε����� ������ '�ܾ�'�� '����'�� � �͵����� Ȯ��
SELECT *FROM sys.dm_fts_index_keywords(DB_ID(), OBJECT_ID('dbo.FulltextTbl'));
-- 'display_term'�� �ε����� ������ �ܾ ����
-- 'column_id'�� �� ��° ������ �ǹ�
-- 'document_count'�� �� ���̳� ��� �ִ��� ����
GO

--6. ��ü �ؽ�Ʈ �ε����� ũ�⸦ ���̱� ���ؼ� '���� ���'�� �����, �ʿ���� '���� �ܾ�'�� �߰�
--6-1. �տ��� ������ ��ü �ؽ�Ʈ �ε��� ����
DROP FULLTEXT INDEX ON FULLtextTbl; 
GO

--6-2. ���� ����� ���� 
	-- ������ ���̽� --> ���ϴ� DB --> ����� --> ��ü �ؽ�Ʈ ���� ���
	-- ���⼭ '�ý��� ���� ��Ͽ��� �����'�� �ǹ̴� ���� SQL SERVER�� ������ �ִ� ���� ����� ���뵵 �����Ѵٴ� �ǹ�
	-- ������ ����� ��Ŭ���Ͽ� ���� �ܾ� �߰� 
CREATE FULLTEXT STOPLIST myStopList FROM SYSTEM STOPLIST -- �̷��Ե� ���� ��� ��������
ALTER FULLTEXT STOPLIST myStopList ADD '�׸���' LANGUAGE 'Korean'; -- �̷��� ���� �ܾ� �߰� ����
ALTER FULLTEXT STOPLIST myStopList ADD '��' LANGUAGE 'Korean'; -- �̷��� ���� �ܾ� �߰� ����

--6-3. ��ü �ؽ�Ʈ �ε��� ���� (��� ������ ���� ����� myStopList�� �ɼ����� ����)
CREATE FULLTEXT INDEX ON FulltextTbl (description)
KEY INDEX pk_id
ON movieCatalog
WITH CHANGE_TRACKING AUTO, STOPLIST = myStopList;
GO

--6-4. �ٽ� ��ü �ؽ�Ʈ �ε����� ������ �ܾ ������ � �͵��� �ֳ� ��ȸ
SELECT *FROM sys.dm_fts_index_keywords(DB_ID(), OBJECT_ID('dbo.FulltextTbl'));
GO

--7. ��ü �ؽ�Ʈ �˻�
--7-1. '����'��� �ܾ �˻�
SELECT *FROM FulltextTbl WHERE CONTAINS(description, '����'); --�ε����� ����Ͽ� �˻��ߴٴ� ���� �� �� ����
GO

--7-2. AND���ǰ� OR������ �˻�
SELECT * FROM FulltextTbl
WHERE CONTAINS (description, '���� AND ����');
SELECT * FROM FulltextTbl
WHERE CONTAINS (description, '���� OR ����');
GO

--7-4. CONTAINS�� FREETEXT ����
SELECT * FROM FulltextTbl
	WHERE CONTAINS (description, '�����̾߱�');
GO
SELECT * FROM FulltextTbl
WHERE FREETEXT (description,'�����̾߱�'); --FREETEXT�� �߰��� �ٸ� ���ڰ� ���ԵǾ� �־ �����ϰ� �˻�����
GO

--7-5. CONTAINSTABLE ���
SELECT *FROM CONTAINSTABLE(FulltextTbl, *,'����');
-- key�� ��ü �ؽ�Ʈ �ε����� ������ Ű(pk_id) ���̸�, rank�� �ش� ���� ��ġ�Ǵ� ����ġ �� �� ���� 0~1000���� ���� �� ������ �������� �ش��ϴ� ���� ���� ��ġ�ϰ� �ȴ�.
-- ������ �ش� �������� ������ Ȯ���� ������ �Ʒ��� ���� ������ �̿��Ͽ� �ַ� ����Ѵ�. 
SELECT f.id, C.RANK AS [����ġ], f.title, f.description
FROM FulltextTbl AS f
	INNER JOIN CONTAINSTABLE (FulltextTbl, *, '����') AS C
	ON f.id = C.[KEY]
ORDER BY C.RANK DESC;
GO
--FREETEXTTABLE�� CONTAINSTABLE�� ����� ����� �������� ���� �� ������ �˻��� ��������
SELECT *FROM FREETEXTTABLE(FulltextTbl, *,'����');
GO

--7-6. ��ü �ؽ�Ʈ īŻ�α� ��� �� ���� 
--����
BACKUP DATABASE FulltextDB TO DISK = 'D:\DB\SQL\9DAY\FulltextDB.bak' WITH INIT;

--���� �� ����
USE tempdb;
DROP DATABASE FulltextDB;
GO
RESTORE DATABASE FulltextDB FROM DISK = 'D:\DB\SQL\9DAY\FulltextDB.bak' WITH REPLACE;
GO

--�ٽ� ��ü �ؽ�Ʈ �ε����� ������ �ܾ�, ������ � �͵��� �ֳ� Ȯ�� 
USE FulltextDB;
SELECT *FROM sys.dm_fts_index_keywords(DB_ID(), OBJECT_ID('dbo.FulltextTbl'));
GO

----8. ��ü �ؽ�Ʈ �ε��� �� ��ü �ؽ�Ʈ īŻ�α� ����
-- ��ü �ؽ�Ʈ īŻ�α� ���� 
DROP FULLTEXT CATALOG movieCatalog; -- ��ü �ؽ�Ʈ �ε����� ����־� ���� �Ұ� ���� ��ü �ؽ�Ʈ �ε��� ���� �����ؾ���
GO
-- ��ü �ؽ�Ʈ �ε��� ���� �� �ٽ� ��ü �ؽ�Ʈ īŻ�α� ����
DROP FULLTEXT INDEX ON FulltextTbl; 
DROP FULLTEXT CATALOG movieCatalog; 
GO