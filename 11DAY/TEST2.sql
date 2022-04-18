--TEST03

-- 1.
--hr.dept ���̺� ������� hr.dept_temp ���̺��� �����ϼ���.
--�׸���, hr.dept_temp �����͸� ������� OPERATIONS �μ�(dname)�� 
--��ġ�� SEOUL �� �����ϼ���. (loc)
--��, ����� Sub Query �� ����ϼ���.

USE testDB;
GO
SELECT *INTO hr.dept_temp FROM hr.dept
GO
SELECT *FROM HR.dept_temp
GO
--�Ϲ�
UPDATE hr.dept_temp SET loc = 'BOSTON' WHERE dname = 'OPERATIONS';
GO
--��������
UPDATE hr.dept_temp SET loc =  'SEOUL' WHERE dname = (SELECT dname FROM hr.dept_temp WHERE dname = 'OPERATIONS');
GO

--2. 
--hr.emp ���̺� ������� hr.emp_temp ���̺��� �����ϼ���.
--�׸���, �޿��� 1����� ��� ������ �Էµǵ��� �ϼ���.
--hr.emp_temp �����͸� ������� �޿� ����� 1����̸�, 
--�μ� ��ȣ�� 30���� ��� ������ �����ϵ��� �ϼ���. 
--��, ������ Sub Query �� ����ϼ���.
USE testDB;
GO
SELECT *INTO hr.emp_temp FROM hr.emp E, hr.salgrade S WHERE S.grade = 1 AND e.sal BETWEEN s.losal AND s.hisal
GO
SELECT *FROM hr.emp_temp --�޿��� 1����� �� 3���� ����� ��� 
GO
--�Ϲ�
DELETE FROM hr.emp_temp WHERE deptno = 30
GO
--�������� 
DELETE FROM hr.emp_temp WHERE deptno = (SELECT deptno FROM hr.emp_temp WHERE deptno = 30);
GO

--3. 
--���� �޿��� ����ϴ� �Լ��� hr ��Ű���� �����ϼ���.
--������ �ϰ������� 5% �� ����ϼ���.
--�׸���, ������ �Լ��� ����Ͽ� �� ����� ���� �� ���ĸ� 
--Ȯ���� �� �ֵ��� ����ϼ���.

USE testDB;
GO
CREATE FUNCTION hr.After_tax(@sal INT)
	   RETURNS INT
AS
	BEGIN 
	     DECLARE @AfterTax INT
		 SET @AfterTax = @sal - (@sal * 0.05)
		 RETURN(@AfterTax)
	END
GO
SELECT EMPNO, ENAME, SAL, HR.After_tax(SAL) AS [AFTERTAX] FROM hr.emp;
GO

--4. 
--hr.emp_temp �� Ʈ���Ÿ� �߰��ϼ���.
--Ʈ������ ����� ��, �� ���Ͽ� insert, update, delete �� ����
--DML �̺�Ʈ�� �߻��� ��� 
--�ָ����� ���, ����, ���� �� �� �����ϴ�.' �޽����� ����ϸ�,
--Ʈ������� ��Ұ� �ǵ��� �ϼ���.

-- ��¥ ������
SELECT DATENAME(WEEKDAY,GETDATE()) -- "�Ͽ���", "�����"
SELECT DATEPART(WEEKDAY,GETDATE()) -- 1(�Ͽ���), 7(�����)
GO

CREATE TRIGGER CHK_EMP_DML
ON  hr.emp_temp 
AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	IF DATEPART(WEEKDAY,GETDATE()) = 1
		BEGIN 
		RAISERROR('�ָ��̶� ���, ����, ���� �� �� �����ϴ�.',10,1)
		ROLLBACK TRAN;
		END
	ELSE IF DATEPART(WEEKDAY,GETDATE()) = 7
		BEGIN
		RAISERROR('�ָ��̶� ���, ����, ���� �� �� �����ϴ�.',10,1)
		ROLLBACK TRAN;
		END
END
GO
UPDATE hr.emp_temp SET sal = '800' WHERE ename = 'SMITH'; --������Ʈ Ȯ��
UPDATE hr.emp_temp SET sal = '900' WHERE ename = 'SMITH'; --������Ʈ Ȯ��
SELECT *FROM hr.emp_temp -- �ָ��̸� ������� ���� 
GO

-------------- ���ν���
--1. 
--������ �䱸������ Ȯ�� ��, ���ν����� �ۼ��ϼ���.
--�������� ����� ���̺��� �Ʒ��� �����ϴ�.CREATE TABLE T���� 
(
 ���� nvarchar(8), ��ǰ nvarchar(30), ���� int default 0, primary key (����, ��ǰ)
)
GO
INSERT INTO T����(����, ��ǰ, ����) VALUES ('20200101', 'A1', 10), ('20200102', 'A2', 20)
GO
--�Ʒ��� �䱸�����Դϴ�.
--update, delete �� �ϳ��� Ʈ��������� �����մϴ�.
--�� DML ������ ���� ����� �ý��� ������ Ȯ���մϴ�.
--������ �ý��� ������ @@ERROR, @@ROWCOUNT�̰�, Ʈ������� �Ϸ�� ��Ҵ� �Ʒ��� �����ϼ���.
--@@ERROR <> 0 �Ǵ� @@ROWCOUNT <> 1 �ƴϸ� ��� ����̰�, �׿ܴ� ��� �Ϸᰡ �ǵ��� �մϴ�.
--Ʈ������� �Ϸ� �Ǵ� ��� ���� �����͸� ����մϴ�.
--T���� ���̺� ���� update ������ ���� �����Դϴ�.
--������ ����, ��ǰ�� ���� '20200101', 'A1' �Դϴ�.
--T���� ���̺� ���� delete ������ ���� �����Դϴ�.
--������ ����, ��ǰ�� ���� '20200105', 'A5' �Դϴ�.

--2. 
--������ �䱸������ Ȯ�� ��, ���ν����� �ۼ��ϼ���.
--�������� ����� �ӽ� ���� ���̺��� �Ʒ��� �����ϴ�.
--���ν����� ���� ����� ��ǰ �ڵ� ���������. 
CREATE TABLE #T��ǰ 
(
��ǰ�ڵ� NVARCHAR(30) ,��ǰ�� NVARCHAR(30)
)
GO
INSERT INTO #T��ǰ (��ǰ�ڵ�, ��ǰ��)
VALUES ('A2', '���') , ('A1', '���'), ('A4', '����'),
('A3', '����'), ('A5', '����'), ('A9', '����'),
('A7', '����'), ('A6', '����') ,('A8', '����')
GO
SELECT *FROM #T��ǰ ORDER BY ��ǰ�ڵ� 

--3. 
--������ �䱸������ Ȯ�� ��, ���ν����� �ۼ��ϼ���.
--�Ʒ��� ���ν����� Ŀ���� ����ϰ� �ֽ��ϴ�.
--�Ʒ��� �ڵ忡�� Ŀ���� ������� �ʰ� �����ϰ� ������ �ǵ��� 
--���ο� ���ν����� �ۼ��ϼ���.--��뷮 �������� ��� ������ ���� ������ �����ϸ� Ŀ���� ������� ���ڴ� �ǹ��� ����CREATE PROCEDURE SP_CURSOR
AS
BEGIN
 CREATE TABLE #T�۾�1 (
 �ڵ� NVARCHAR(10)
 ,���� NUMERIC(18,0)
 )
 INSERT INTO #T�۾�1 (�ڵ�, ����) 
 VALUES ('A1', 10), ('A2', 20), ('A3', 30)

 DECLARE Ŀ��1 CURSOR FOR
 SELECT A.�ڵ�, A.����
 FROM #T�۾�1 A
 WHERE A.�ڵ� < 'A3'
 ORDER BY ���� DESC 

 OPEN Ŀ��1;

 DECLARE @Ŀ��1_�ڵ� NVARCHAR(10)
 ,@Ŀ��1_���� NUMERIC(18,0)
 
 WHILE (1 = 1) BEGIN
 FETCH NEXT FROM Ŀ��1 INTO @Ŀ��1_�ڵ�, @Ŀ��1_����
 IF @@FETCH_STATUS <> 0 BREAK
 SELECT �ڵ� = @Ŀ��1_�ڵ�,
 ���� = @Ŀ��1_����
 END; 
 
 CLOSE Ŀ��1
 DEALLOCATE Ŀ��1
 
 DROP TABLE #T�۾�1 
END

--4. 
--������ �䱸������ Ȯ�� ��, ���ν����� �ۼ��ϼ���.
--�������� ����� �ӽ� ���� ���̺��� �Ʒ��� �����ϴ�.
--�Ʒ��� ���ν����� �����Ͽ� Ư�� �Ⱓ�� ��� ���� ������ ��ȸ
--�� ����Դϴ�. ������ ��ȸ �˻� ������ ������ �����ϴ�.
--���� �˻� ������ : 20200101
--���� �˻� ������ : 20200131--���� ������ ���� �˻� ������ ������ ���� �� ���� �����͸� ����
--�ؼ� ����ϸ� �˴ϴ�.
--�⸻ ������ ���ʼ���, ���Լ���, ��������� ��� ���谡 �� ��
--���������� �⸻���� = ���ʼ��� + ���Լ��� - ����������� 
--����� �ǵ��� �ϸ� �˴ϴ�.

CREATE TABLE #��ǰ (
 ��ǰ�ڵ� NVARCHAR(20),
 ��ǰ�� NVARCHAR(20) 
 )
 INSERT INTO #��ǰ (��ǰ�ڵ�, ��ǰ��)
 VALUES ('A','���'), ('B','����'), ('C','����'),
 ('D','����'), ('E','����')
 
 CREATE TABLE #���� (
 ��ǰ�ڵ� NVARCHAR(20),
 �������� NVARCHAR(20),
 ���Լ��� NUMERIC(18,0)
 )
 INSERT INTO #���� (��ǰ�ڵ�, ��������, ���Լ���)
 VALUES ('A', '20191201', 100), ('A', '20200103', 200), 
 ('B', '20200201', 300), ('C', '20200105', 400),
 ('D', '20200107', 500) 
 CREATE TABLE #���� (
 ��ǰ�ڵ� NVARCHAR(20),
 �������� NVARCHAR(20),
 ������� NUMERIC(18,0)
 )
 INSERT INTO #���� (��ǰ�ڵ�, ��������, �������)
 VALUES ('A', '20191220', 10), ('A', '20200103', 20), 
 ('B', '20200305', 30), ('B', '20200217', 40),
 ('C', '20200220', 50) 