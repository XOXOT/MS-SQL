--5�� 
--����â �̿� 
USE	AdventureWorks2016CTP3; --(��ü Ž���⿡�� �ش� ������ �巹�׷ε� ����)
GO
SELECT * FROM HumanResources.Employee;
GO
--Ŭ������ �� ��ȯ ���(������ ���縦 �������Ͽ� ctrl + shift + v�� �ϸ� �������� ��� �ٿ�����
USE tempdb;
USE master;
USE	AdventureWorks2016CTP3;
-----------------------------------------------------------
--�ڵ� ���� ������ �ϸ� ������ ������ Ʋ�� �ҷ��ְ�
--�ڵ� ���α⸦ �ϸ� ������ ������ begin, end, if, while �� ������ �����ش�. 
-----------------------------------------------------------
USE tempdb;
GO
CREATE TABLE test(id INT);
GO
--���� �������� ���� �����ϸ� �̹� test ���̺��� ����������Ƿ� ���� �������� ������ �� 
INSERT INTO test VALUES(1);
GO
-----------------------------------------------------------
--���ǥ�� �����Ͽ� �޸����̳� csv���Ϸ� ���� ���� 
USE AdventureWorks2016CTP3;
GO
SELECT * FROM Production.Product;
-----------------------------------------------------------
--���� 
-- DECLARE ������ ������ �����Ѵ�. DECLARE @������ ������ ����;
-- ������ ó�� ����Ǹ� �� ���� NULL�� �����ȴ�. ������ ���� �Ҵ��Ϸ��� SET �� ����Ѵ�.
--����� ��� ���(������ �ľ� ����)
 USE tempdb;
 DECLARE @var1 INT
 DECLARE @var2 INT
 SET @var1 = 100
 SET @var2 = 200
 PRINT @var1 + @var2

 --�������Ϸ� 
 --���� >> SQL SERVER Profiler >> �⺻������ ���� 
 USE AdventureWorks2016CTP3;
 GO
 SELECT TOP 10 * FROM Person.Address;

--CPU: �̺�Ʈ���� ����� CPU �ð�(�и���)
--Read: �̺�Ʈ ��� �������� ������ ���� ��ũ �б� �� 
--Writes: �̺�Ʈ ��� �������� ������ ������ ��ũ ���� ��
--Duration: �̺�Ʈ���� ����� �ð�
--SPID: �����ϴ� ���μ����� ID

--���� >> SQL SERVER Profiler >> TSQL_Duration���� ����
USE AdventureWorks2016CTP3;
GO
SELECT *FROM Production.Product;
GO
SELECT *FROM Production.ProductCostHistory;
GO
SELECT *FROM Sales.Customer; --Duration�� ���� ���� ��ȸ�� �����Ͱ� ���ٴ� �ǹ� �׿ܿ��� SQL���忡 ������ �־� �����ɸ��� ����.
GO