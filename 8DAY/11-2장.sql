---------11-2��

----------- ����� ���� �Լ� 
-- ���� ���ν����� EXECUTE �Ǵ� EXEC�� ���ؼ� ��������� �Լ��� �ַ� SELECT���� ���ԵǾ ����ȴ�.

--�ǽ� 
--1. ����� ���� �Լ� ���

--1-1. ����
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

--1-2. ����⵵�� �Է��ϸ� ���̰� ��µǴ� �Լ�
USE sqlDB;
GO
CREATE FUNCTION ufn_getAge(@byear INT) -- �Ű������� ������ ����
		RETURNS INT -- ���ϰ��� ������
AS
		BEGIN
			  DECLARE @age INT
			  SET @age = YEAR(GETDATE()) - @byear
			  RETURN(@age)
		END
GO

--1-3. �Լ��� ȣ���غ���

--1-3-1. SELECT ���
SELECT dbo.ufn_getAge(1979); -- ȣ��� ��Ű������ �ٿ������
GO
--1-3-2. EXECUTE ���(�ణ ������)
DECLARE @retVal INT;
EXEC @retVal = dbo.ufn_getAge 1979;
PRINT @retVal;
GO

--1-4. �Լ��� �ַ� ���̺��� ��ȸ�� �� Ȱ���� �� �ִ�. 
SELECT userID, name, dbo.ufn_getAge(birthYear) AS [�� ����] FROM userTbl;

--1-5. �Լ��� �����Ϸ��� ALTER���� ����ϸ� �ȴ�. �츮���� ���̷� ����ϵ��� ����
ALTER FUNCTION ufn_getAge(@byear INT)
	  RETURNS INT
AS
	  BEGIN
			DECLARE @age INT
			SET @age = YEAR (GETDATE()) - @byear + 1
			RETURN(@age)
	  END
GO

--1-6. ������ ���������� DROP�� ���
DROP FUNCTION ufn_getAge;
GO

-------------�Լ��� ����

--1. �⺻ ���� �Լ�
	-- �ý��� �Լ� 
--2. ����� ���� ��Į�� �Լ�
	-- RETURN���� ���ؼ� �ϳ��� ���ϰ��� �����ִ� �Լ�
--3. ����� ���� ���̺� ��ȯ �Լ�
	-- ���̺� �Լ���� �Ҹ��� RETURN ���� �ƴ� �ϳ��� ���̺��� �Լ��� ���Ѵ�.
		-- �ζ��� ���̺� ��ȯ �Լ�
			-- ������ ���̺��� �����ִ� �Լ�, �Ű������� �ִ� ��� ����� ������ �Ѵ�.
			-- �ζ��� ���̺� ��ȯ �Լ��� ������ ������ ������ ���� SELECT ���� ���Ǿ� �� ��� ������ �����ش�.
		-- ���� �� ���̺� ��ȯ �Լ�
			-- BEGIN ... END�� ���ǵǸ� �� ���ο� �Ϸ��� T-SQL�� �̿��ؼ� ��ȯ�� ���̺� �� ���� INSERT�ϴ� �����̴�. 
GO

--�ǽ� 
--1. ���̺� �Լ� ���

--1-1. �ζ��� ���̺� ��ȯ �Լ� ���� 
--1-1-1. �Է��� ������ Ű�� ū ����ڵ��� �����ִ� �Լ� ����
USE sqlDB;
GO
CREATE FUNCTION ufn_getUser(@ht INT)
	RETURNS TABLE
AS
	RETURN(
			SELECT userID AS [���̵�], name AS [�̸�], height AS [Ű]
			FROM userTbl
			WHERE height > @ht
		  )
GO
--1-1-2. 177�̻��� ����ڸ� �Լ��� �̿��ؼ� ȣ��
SELECT * FROM dbo.ufn_getUser(177);
GO


--2. ���� �� ���̺� ��ȯ �Լ�
--2-1. ���� ���� �Ű������� �ް� �Ű��������� ����⵵�� ���Ŀ� �¾ ���鸸 ����� �з��ϴ� �Լ�
--     ���� �Է��� �Ű����� ���Ŀ� �¾ ���� ���ٸ� '����'�̶�� �� ���� ��ȯ
CREATE FUNCTION ufn_userGrade(@bYear INT)
--������ ���̺��� ����(@retTable�� BEGIN...END���� ���� ���̺� ����)
	RETURNS @retTable TABLE
			( userID char (8),
			name NCHAR(10),
			grade NCHAR(5))
AS
BEGIN
	 DECLARE @rowCnt INT;
	 -- ���� ������ ī��Ʈ
	 SELECT @rowCnt = COUNT(*) FROM userTbl WHERE birthYear >= @bYear;
	 -- ���� �ϳ��� ������ '����'�̶�� �Է��ϰ� ���̺��� ����
	 IF @rowCnt <= 0
	 BEGIN
		  INSERT INTO @retTable VALUES('����', '����', '����');
		  RETURN;
	 END;
	 -- ���� 1�� �̻� �ִٸ� �Ʒ��� �����ϰ� �� 
	 INSERT INTO @retTable
			SELECT U.userid, U.name,
				   CASE
						WHEN (sum(price*amount) >= 1500) THEN '�ֿ����'
						WHEN (sum(price*amount) >= 1000) THEN '�����'
						WHEN (sum(price*amount) >= 1 ) THEN '�Ϲݰ�'
					    ELSE '���ɰ�'
				   END
			FROM buyTbl B
				RIGHT OUTER JOIN userTbl U
					ON B.userid = U.userid
			WHERE birthYear >= @bYear
			GROUP BY U.userid, U.name;
	 RETURN;
END;

--2-2. 1970�� ������ ���� ���
SELECT *FROM dbo.ufn_userGrade(1970);
GO
--2-3. 1990�� ������ ���� ��� 
SELECT *FROM dbo.ufn_userGrade(1990);
GO

--------------- ��Ű�� �ٿ�� �Լ�
-- ��Ű�� �ٿ�� �Լ��� �Լ����� �����ϴ� ���̺�, ��, ���� �������� ���ϵ��� ������ �Լ��� ���Ѵ�. 
-- ���� �Լ�A�� ������ ���̺�B, �� C�� �����ϰ� ���� ��� ���̺�B, �� C�� �����ǰų� �� �̸��� �ٲ�ٸ� �Լ� A�� ���࿡ ������ �߻�
-- �̷��� ������ �����ϴ� ���� ��Ű�� �ٿ�� �Լ��̴�. 

---- ���̺� ����
-- �Ϲ����� ������ ����ó�� ���̺� ������ �����ؼ� ����� �� �ִ�.
-- ���̺� ������ �뵵�� �ַ� �ӽ� ���̺��� �뵵�� ����ϰ� ���� �� �ִ�. ��� �� �ǽ����� Ȯ��

-- ����� ���� �Լ��� ���� ����
	-- ����� ���� �Լ� ���ο� TRY ... CATCH ���� ����� �� ����.
	-- ����� ���� �Լ� ���ο� CREATE/ALTER/DROP���� ����� �� ����.
	-- ������ �߻��ϸ� ��� �Լ��� ������ ���߰� ���� ��ȯ���� �ʴ´�.

--�ǽ�
--1. ��Į�� �Լ��� ����, ��Ű�� �ٿ�� �Լ� �� ���̺� ������ ���ؼ� �ǽ�

--1-1. ����
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

--1-2. BUYTBL�� �����ϴ� ��Į�� �Լ��� ����. 
--     ���� ������� ���̶�� �����ϰ� �Էµ� ������� �� ������ ���ݿ� ���� ����� �������� �����ϴ� �Լ�
USE SqlDB;
GO
CREATE FUNCTION ufn_discount(@id NVARCHAR(10))
	   RETURNS BIGINT
AS
BEGIN
	   DECLARE @totPrice BIGINT;

	   --�Էµ� �����ID�� �� ���ž�
		SELECT @totPrice = sum(price*amount)
		FROM buyTbl
		WHERE userID = @id
		GROUP BY userID;

	   --�� ���ž׿� ���� ����� ������ ����
	   SET @totPrice = 
				CASE
					WHEN (@totPrice >= 1500) THEN @totPrice*0.7
					WHEN (@totPrice >= 1000) THEN @totPrice*0.8
					WHEN (@totPrice >= 500) THEN @totPrice*0.9
					ELSE @totPrice
				END;
	   --���ű���� ������ 0��
	   IF @totPrice IS NULL
				SET @totPrice = 0;
	   RETURN @totPrice;
END

--1-3. �Լ��� ���
SELECT userID, name, dbo.ufn_discount(userID) AS [���ε� �� ���ž�] FROM userTbl;
GO
--1-4. buyTbl�� price ���� �̸��� cost�� ����
EXEC sp_rename 'buyTbl.price', 'cost', 'COLUMN'; -- ���Ǵ� �������� ������ �ȴ�.
GO
--1-5. �ٽ� �Լ��� ���� 
SELECT userID, name, dbo.ufn_discount(userID) AS [���ε� �� ���ž�] FROM userTbl;
GO
--�Լ����� ������ �� �̸�(PRICE)�� �����Ƿ� �翬�� ������ �߻�

--1-6. ���� �̸��� ������� ���� ����
EXEC sp_rename 'buyTbl.cost', 'price', 'COLUMN';

-------2. ���� ������ �����ϱ� ���� ��Ű�� �ٿ�� �Լ��� ����

--2-1. ALTER FUNCTION ������� ����
ALTER FUNCTION ufn_discount(@id NVARCHAR(10))
	  RETURNS BIGINT
WITH SCHEMABINDING
AS
BEGIN
	   DECLARE @totPrice BIGINT;

	   --�Էµ� �����ID�� �� ���ž�
		SELECT @totPrice = sum(price*amount)
		FROM buyTbl
		WHERE userID = @id
		GROUP BY userID;

	   --�� ���ž׿� ���� ����� ������ ����
	   SET @totPrice = 
				CASE
					WHEN (@totPrice >= 1500) THEN @totPrice*0.7
					WHEN (@totPrice >= 1000) THEN @totPrice*0.8
					WHEN (@totPrice >= 500) THEN @totPrice*0.9
					ELSE @totPrice
				END;
	   --���ű���� ������ 0��
	   IF @totPrice IS NULL
				SET @totPrice = 0;
	   RETURN @totPrice;
END
-- �̷��� �ϸ� ������ �߻��ϹǷ� FROM buyTbl�� FROM dbo.buyTbl�� ����
ALTER FUNCTION ufn_discount(@id NVARCHAR(10))
	  RETURNS BIGINT
WITH SCHEMABINDING
AS
BEGIN
	   DECLARE @totPrice BIGINT;

	   --�Էµ� �����ID�� �� ���ž�
		SELECT @totPrice = sum(price*amount)
		FROM dbo.buyTbl
		WHERE userID = @id
		GROUP BY userID;

	   --�� ���ž׿� ���� ����� ������ ����
	   SET @totPrice = 
				CASE
					WHEN (@totPrice >= 1500) THEN @totPrice*0.7
					WHEN (@totPrice >= 1000) THEN @totPrice*0.8
					WHEN (@totPrice >= 500) THEN @totPrice*0.9
					ELSE @totPrice
				END;
	   --���ű���� ������ 0��
	   IF @totPrice IS NULL
				SET @totPrice = 0;
	   RETURN @totPrice;
END

--2-2. buyTbl�� �� �̸��� ����
EXEC sp_rename 'buyTbl.price', 'cost', 'COLUMN';
-- ��Ű�� �ٿ�� �Լ����� �����ϴ� ���� ������ ���� ����. 

------3. ���̺� ���� ����
--3-1. @tblVar ���̺� ������ �����ϰ� ���� �Է�

DECLARE @tblVar TABLE (id char(8), name NVARCHAR (10), addr NCHAR(2));
INSERT INTO @tblVar
	SELECT userID, name , addr FROM userTbl WHERE birthyear >= 1970;
SELECT * FROM @tblVar;

--3-2. ������ �뵵�� �ӽ� ���̺��� �����ؼ� ��� 
CREATE TABLE #tmpTbl
		(id char(8), name NVARCHAR(10), addr NCHAR(2));
INSERT INTO #tmpTbl
		SELECT userID, name , addr FROM userTbl WHERE birthyear >= 1970;
SELECT * FROM #tmpTbl;
--����� �����ϰ� �ӽ� ���̺� ������ ���� ����. �������� �޸𸮿� �����Ǵ� ���̹Ƿ� �� �� ���� �Ŀ��� �ٽ� ��� x

--�ӽ� ���̺��� tempdb�� �����Ǵ� ���̹Ƿ� SQL Server�� �ٽ� ���۵Ǳ� �������� ��� ���� �ִ�.

--�ý����� ������ ���ؼ��� ���� �����͸� �ӽ÷� ��� �ÿ��� ���̺� ������ ������ �� �ְ�, ��뷮���� ������
--�� �ӽ÷� ����ϱ� ���ؼ��� �ӽ� ���̺��� �� ���� �� �ִ�. ������ �ӽ� ���̺��� �Ϲ� ���̺��� ���� ���
--������ ���� �ǹǷ� ��뷮�� �������� ��� ��Ŭ�������� �ε����� ������ �� ������, ���̺� �������� ��
--�������� �ε����� ������ ���� ����.

--��, ���̺� ������ ������� Ʈ�����(BEGIN TRAN...COMMIT/ROLLBACK TRAN) ���ο� �ִ���
--������ ���� �ʴ´�. ������ ������ ���� ���ذ� �� ���̴�.

DECLARE @tblVar TABLE (id INT);
BEGIN TRAN
	INSERT INTO @tblVar VALUES (1);
	INSERT INTO @tblVar VALUES (2);
ROLLBACK TRAN
SELECT *FROM @tblVar;
--�Ϲ� ���̺��̳� �ӽ� ���̺��� ����� ROLLBACK�� �������� �ƹ� ���� ������ �ʰ�����, ���̺� ����
--�� ����� Ʈ������� ������ ���� �ʾҴ�.
