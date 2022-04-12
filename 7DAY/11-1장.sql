------저장 프로시저

-- 저장 프로시저는 한마디로 쿼리문의 집합으로 어떤 동작을 일괄 처리할 때 사용된다.
-- 자주 사용되는 일반적인 쿼리를 사용하는 것보다는 이것을 모듈화시켜서 필요할 때마다 호출만 하면 훨씬 편리하게 SQL SERVER를 운영할 수 있다.

-- 간단한 형식
USE sqlDB;
GO
CREATE PROCEDURE USP_USERS
AS 
	SELECT *FROM userTbl; -- 저장 프로시저 내용
GO

EXEC USP_USERS;

-- 저장 프로시저의 수정과 삭제
-- 간단히 수정은 ALTER PROCEDURE, 삭제는 DROP PROCEDURE

-- 매개변수의 사용
-- 1. 입력 매개변수를 지정하는 형식
-- @입력_매개_변수_이름 데이터_형식 [ = 디폴트 값] //디폴트 값은 프로시저의 실행 시 매개변수에 값을 전달하지 않았을 때 사용되는 값

-- 2. 입력 매개변수가 있는 저장 프로시저를 실행하는 방법
-- EXEUTE 프로시저_이름 [전달 값] //EXEUTE를 EXEC라고 써도 된다. 

-- 3. 출력 매개변수를 지정하는 형식
-- @출력_매개_변수_이름 데이터_형식 OUTPUT // OUTPUT을 OUT이라고 줄여써도 된다.

-- 4. 출력 매개변수가 있는 저장 프로시저를 실행하는 방법은 다음과 같다.
-- EXECUTE 프로시저_이름 @변수명 OUTPUT 

-- 프로그래밍 기능
-- 7장 후반부에 공부한 SQL 프로그래밍 내용 대부분이 저장 프로시저에 적용 가능

-- 리턴 값을 이용한 저장 프로시저의 성공 및 실패 확인

-- 저장 프로시저 내의 오류 처리
-- @@ERROR 함수를 이용해서 오류 처리를 할 수 있다. 또한 TRY/CATCH 문을 이용해서 더욱 효과적으로 오류 처리 가능

-- 임시 저장 프로시저
-- 생성한 저장 프로시저는 현재의 데이터베이스 내에 저장됨
-- 그런데 저장 프로시저 이름 앞에 # 또는 ##을 붙이면 임시 저장 프로시저로 생성이 되며, 이것은 현재의 데이터베이스가 아닌 TEMPDB에 저장된다. 
GO

-- 실습

-- 1. 복원
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

-- 2. 1개의 입력 매개변수가 있는 저장 프로시저 생성 
USE sqlDB;
GO
CREATE PROCEDURE usp_users1
		@userName NVARCHAR(10)
AS
SELECT * FROM userTbl WHERE name = @userName;
GO
EXEC usp_users1 '조관우';
GO

--3. 2개의 입력 매개변수가 있는 저장 프로시저 생성
CREATE PROCEDURE usp_users2
		@userBirth INT,
		@userHeight INT
AS
		SELECT * FROM userTbl
		WHERE birthYear > @userBirth AND height > @userHeight;
GO
EXEC usp_users2 1970, 178;
GO

--4. 출생년도와 키의 순서를 바꿔서 호출하고 싶다면, 매개변수 이름을 직접 지정
EXEC usp_users2 @userHeight=178, @userBirth=1970;
GO

--5. 디폴트 매개변수를 지정
CREATE PROCEDURE usp_users3
		@userBirth INT = 1970,
		@userHeight INT = 178
AS
		SELECT * FROM userTbl
		WHERE birthYear > @userBirth AND height > @userHeight;
GO
EXEC usp_users3;
GO
-- 6. 출력 매개변수를 설정해서 사용
CREATE PROCEDURE usp_users4
		@txtValue NCHAR(10),
		@outValue INT OUTPUT
AS
INSERT INTO testTbl VALUES (@txtValue);
SELECT @outValue = IDENT_CURRENT ('testTbl'); -- 테이블의 현재 identity 값
GO
CREATE TABLE testTbl (id INT IDENTITY, txt NCHAR(10));
GO

--usp_users4 프로시저를 생성 시에 testTbl이라는 테이블이 존재하지 않았는데 생성된 것을 '지연된 이름 확인'이라고 부른다. 
--즉, 실제 테이블이 없어도 저장 프로시저는 만들어 진다는 의미다.

-- 7. 저장 프로시저를 사용
DECLARE @myValue INT;
EXEC usp_users4 '테스트 값1', @myValue OUTPUT;
PRINT '현재 입력된 ID 값==> ' + CAST(@myValue AS CHAR(5));

-- 8. IF… ELSE문 사용 
CREATE PROC usp_ifElse
		@userName NVARCHAR(10)
AS
		DECLARE @bYear INT     -- 출생년도를 저장할 변수
		SELECT @bYear = birthYear FROM userTbl
			WHERE name = @userName;
		IF (@bYear >= 1980)
				BEGIN
						PRINT '아직 젊군요..';
				END
		ELSE
				BEGIN
						PRINT '나이가 지긋하네요...';
				END
GO
EXEC usp_ifElse '조용필';

-- 9. CASE 문을 사용 
CREATE PROC usp_case
		@userName NVARCHAR(10)
AS
DECLARE @bYear INT
DECLARE @tti NCHAR(3) --띠
SELECT	@bYear = birthYear FROM userTbl
		WHERE name = @userName;
SET @tti =
		CASE
			WHEN ( @bYear%12 = 0) THEN '원숭이'
			WHEN ( @bYear%12 = 1) THEN '닭'
			WHEN ( @bYear%12 = 2) THEN '개'
			WHEN ( @bYear%12 = 3) THEN '돼지'
			WHEN ( @bYear%12 = 4) THEN '쥐'
			WHEN ( @bYear%12 = 5) THEN '소'
			WHEN ( @bYear%12 = 6) THEN '호랑이'
			WHEN ( @bYear%12 = 7) THEN '토끼'
			WHEN ( @bYear%12 = 8) THEN '용'
			WHEN ( @bYear%12 = 9) THEN '뱀'
			WHEN ( @bYear%12 = 10) THEN '말'
			ELSE '양'
		END;
	PRINT @userName + '의 띠==>>' + @tti;
GO
EXEC usp_case '성시경';
GO

--실제 사용될 만한 WHILE문을 사용 
-- 아직 배우지 않은 커서가 나옴
-- 고객 테이블에 고객 등급 열을 하나 추가한 후에 각 구매 테이블에서 고객이 구매한 총액에 따라서 고객 등급 열에 최우수 고객/우수고객 ...
USE sqlDB;
GO
ALTER TABLE userTbl
		ADD grade NVARCHAR(5); -- 고객 등급 열 추가
GO
CREATE PROCEDURE usp_while
AS
	DECLARE userCur CURSOR FOR -- 커서 선언
		SELECT U.userid, sum(price*amount)
		FROM buyTbl B
			RIGHT OUTER JOIN userTbl U
			ON B.userid = U.userid
		GROUP BY U.userid, U.name
	OPEN userCur --커서 열기

	DECLARE @id NVARCHAR(10) --사용자 아이디를 저장할 변수
	DECLARE @SUM BIGINT -- 총 구매액을 저장할 변수
	DECLARE @userGrade NCHAR(5) --고객 등급 변수

	FETCH NEXT FROM userCur INTO @id, @sum --첫 행 값을 대입

	WHILE (@@FETCH_STATUS =0) --행이 없을 때까지 반복(즉, 모든 행 처리)
	BEGIN
		SET @userGrade =
			CASE
				WHEN (@SUM >= 1500) THEN '최우수고객'
				WHEN (@SUM>= 1000) THEN '우수고객'
				WHEN (@SUM >= 1) THEN '일반고객'
				ELSE '유령고객'
			END
		UPDATE userTbl SET grade = @userGrade WHERE userID = @id
		FETCH NEXT FROM userCur INTO @id, @sum -- 다음 행 값을 대입
	END
	CLOSE userCur --커서 닫기
	DEALLOCATE userCur -- 커서 해제
GO
-- 저장 프로시저를 정의 했을 뿐 실행하지 않아 GRADE열에는 NULL 값이 들어 있음 
SELECT *FROM userTbl; --NULL 값 확인
EXEC usp_while; --프로시저 실행
SELECT *FROM userTbl; -- GRADE 확인 


-- 10. RETURN문 사용
CREATE PROC usp_return
		@userName NVARCHAR(10)
AS
		DECLARE @userID char (8);
		SELECT @userID = userID FROM userTbl
					WHERE name = @userName;
		IF (@userID <> '')
				RETURN 0; -- 성공일 경우, 그냥 RETURN만 써도 0을 돌려줌
		ELSE
				RETURN -1; -- 실패일 경우(즉, 해당 이름이 ID가 없을 경우)
GO

DECLARE @retVal INT;
EXEC @retVal=usp_return '은지원'; -- 사용자에 있으므로 0
SELECT @retVal;

DECLARE @retVal INT;
EXEC @retVal= usp_return '나몰라'; -- 사용자에 없으므로 -1
SELECT @retVal;

-- 11. 오류 처리를 위하여 @@ERROR 함수 사용 
CREATE PROC usp_error
		@userid char(8),
		@name NVARCHAR(10),
		@birthYear INT = 1900,
		@addr NCHAR(2) = '서울',
		@mobile1 char(3) = NULL,
		@mobile2 char(8) = NULL,
		@height smallInt = 170,
		@mDate date = '2019-11-11'
AS
		DECLARE @err INT;
		INSERT INTO userTbl(userID,name,birthYear,addr,mobile1,mobile2,height,mDate)
			VALUES (@userid,@name,@birthYear,@addr,@mobile1,@mobile2,@height,@mDate);
		SELECT @err = @@ERROR;
		IF @err != 0
		BEGIN
			PRINT '###' + @name + '을(를) INSERT에 실패했습니다. ###'
		END;
		RETURN @err; --오류번호를 돌려줌
GO

DECLARE @errNum INT;
EXEC @errNum = usp_error 'WDT', '우당탕'; --PRIMARY KEY 제약 조건 위반으로 발생되는 오류
IF (@errNum != 0)
	SELECT @errNum;
GO

-- 12. TRY CATCH 문으로 변경 
CREATE PROC usp_trycatch
		@userid char(8),
		@name NVARCHAR(10),
		@birthYear INT = 1900,
		@addr NCHAR(2) = '서울',
		@mobile1 char(3) = NULL,
		@mobile2 char(8) = NULL,
		@height smallInt = 170,
		@mDate date = '2019-11-11'
AS
		DECLARE @err INT;
		BEGIN TRY
		INSERT INTO userTbl(userID,name,birthYear,addr,mobile1,mobile2,height,mDate)
			VALUES (@userid,@name,@birthYear,@addr,@mobile1,@mobile2,@height,@mDate);
		END TRY

		BEGIN CATCH
			SELECT ERROR_NUMBER()
			SELECT ERROR_MESSAGE()
		END CATCH
GO
EXEC usp_trycatch 'SJJ', '손연재';
GO

--13. 현재 저장된 프로시저 이름 및 내용을 확인
USE sqlDB;
SELECT o.name, m.definition
FROM sys.sql_modules m
		JOIN sys.objects o
		ON m.object_id = o.object_id AND o.type = 'P';
GO

-- 13-1다른 방법으로 SP_HELPTEXT 시스템 저장 프로시저를 이용하면 저장 프로시저의 소스코드를 볼 수 있다. 
EXEC sp_helptext usp_error;

-- 14. 다른 사용자가 소스코드를 볼 수 없도록 저장 프로시저를 생성할 때 암호화
-- WITH ENCRYPTION 옵션을 이용하면 암호화가 된다.

CREATE PROC usp_Encrypt WITH ENCRYPTION
AS
	SELECT SUBSTRING(name,1,1) + '00' as [이름],
				birthYear as '출생년도', height as '키' FROM userTbl;
GO
EXECUTE usp_Encrypt; --프로시저 실행
GO 
EXEC sp_helptext usp_Encrypt; --암호화가 잘되었나 확인
-- 한번 암호화하면 알아낼 방법이 없다. 
GO

-- 15. 임시 저장 프로시저 생성할려면 #, ##를 붙여줌 
CREATE PROC #usp_temp
AS
	SELECT * FROM userTbl;
GO
EXEC #usp_temp;

-- 15-1. 한번만 사용될 저장 프로시저를 생성하는 거라면 임시 저장보다는 다음과 같이 sp_executesql을 쓰는게 시스템 성능에 좋다
EXEC sp_executesql N'SELECT * FROM userTbl';

-- 16. 테이블 형식의 사용자 정의 데이터 형식을 매개변수로 사용
-- 테이블 형식의 사용자 정의 데이터 형식 생성
USE sqlDB;
CREATE TYPE userTblType AS TABLE
( userID char(8),
  name NVARCHAR(10),
  birthYear int,
  addr NCHAR(2)
)
GO

-- 저장 프로시저 생성 
CREATE PROCEDURE usp_tableTypeParameter
	@tblPara userTblType READONLY --테이블 형식의 매개변수는 READONLY를 붙여야 한다.
AS
BEGIN
	SELECT * FROM @tblPara WHERE birthYear < 1970;
END
GO

-- 테이블 형식의 변수 선언하고 그 변수에 원래 회원 테이블의 데이터를 입력 후 저장 프로시저 호출
DECLARE @tblVar userTblType;
INSERT INTO @tblVar
	SELECT userID, name, birthYear,addr FROM userTbl;
EXEC usp_tableTypeParameter @tblVar;
GO


-------------- 저장 프로시저의 특징

--1. SQL SERVER의 성능을 향상시킬 수 있다. 
--2. 유지관리가 편하다. 
--3. 모듈식 프로그래밍이 가능하다.
--4. 보안을 강화할 수 있다.
--5. 네트워크 전송량의 감소로 네트워크 부하를 크게 줄일 수 있다. 

-------------- 저장 프로시저의 종류
--1. 사용자 정의 저장 프로시저 
-- T-SQL 저장 프로시저
-- CLR 저장 프로시저
--2. 확장 저장 프로시저
--3. 시스템 저장 프로시저 
GO 

-- 실습 
---- 1. 일반 T-SQL의 처리 시간을 비교 

-- 처리되는 시간을 비교하기 위해 구문 분석, 컴파일, 실행 시간을 표시하는 옵션을 설정
SET STATISTICS TIME ON;
USE AdventureWorks2016CTP3;

-- 다음 쿼리를 실행하고 '메시지'를 확인
SELECT P.ProductNumber, P.Name AS Product, V.Name AS Vendor, PV.LastReceiptCost
FROM Production.Product AS P
	JOIN Purchasing.ProductVendor AS PV ON P.ProductID = PV.ProductID
	JOIN Purchasing.Vendor AS V ON V.BusinessEntityID = PV.BusinessEntityID
ORDER BY P.Name ;
GO
-- 여러번 실행하면 경과 시간이 완전 줄어듬 이미 메모리(캐시)에 존재하는 실행계획을 가져다가 사용하는 것이기 때문
GO

-- SELECT를 sELECT로 변경
sELECT P.ProductNumber, P.Name AS Product, V.Name AS Vendor, PV.LastReceiptCost
FROM Production.Product AS P
	JOIN Purchasing.ProductVendor AS PV ON P.ProductID = PV.ProductID
	JOIN Purchasing.Vendor AS V ON V.BusinessEntityID = PV.BusinessEntityID
ORDER BY P.Name ;
GO
-- 소문자로 바꿨을 뿐인데 경과 시간이 늘어남 동일한 쿼리로 인정되기 위해서는 글자 하나, 띄어쓰기 하나도 틀리지 않아야 메모리(캐시)의 것으로 수행됨
GO
-- 다시 소문자를 대문자로 바꾸면?
SELECT P.ProductNumber, P.Name AS Product, V.Name AS Vendor, PV.LastReceiptCost
FROM Production.Product AS P
	JOIN Purchasing.ProductVendor AS PV ON P.ProductID = PV.ProductID
	JOIN Purchasing.Vendor AS V ON V.BusinessEntityID = PV.BusinessEntityID
ORDER BY P.Name ;
GO
-- 경과시간이 줄어져있는 것을 볼 수 있음. 
GO


----2. 저장 프로시저의 작동방식
SET STATISTICS TIME ON;
USE AdventureWorks2016CTP3;

-- 위에서 했던 실습 내용을 저장 프로시저로 변경
CREATE PROC usp_Prod
AS
	SELECT P.ProductNumber, P.Name AS Product, V.Name AS Vendor, PV.LastReceiptCost
	FROM Production.Product AS P
		JOIN Purchasing.ProductVendor AS PV ON P.ProductID = PV.ProductID
		JOIN Purchasing.Vendor AS V ON V.BusinessEntityID = PV.BusinessEntityID
	ORDER BY P.Name ;
GO
-- 프로시저 1회 실행
EXEC usp_Prod;
-- 다시 프로시저 실행
EXEC usp_Prod;
-- 통계시간 옵션을 해지
SET STATISTICS TIME OFF;

-- 프로시저가 메모리(캐시)에 저장된 내용을 계속 사용하기 때문에 꼭 저장 프로시저를 사용할 필요가 없지 않을 까 생각을 할 수 있다. 
-- 현실적으로 일반적으로 쿼리는 아래와 같이 동일하지만 조건이 다른 것들이 주로 사용된다. 
USE sqlDB;
SELECT *FROM userTbl WHERE ID = 'LSG';
SELECT *FROM userTbl WHERE ID = 'KBS';
SELECT *FROM userTbl WHERE ID = 'KKH';
-- 이렇게 한글자라도 다르면 다른 쿼리로 인식하기 때문에 위 세 쿼리 모두 다른 것으로 인식

-- 이를 저장 프로시저로 만들고 호출한다면, 우선 아래와 같이 정의한 후에 다음 내용을 실행하게 될 것이다. 
CREATE PROC usp_userid
		@id NVARCHAR(10)
	AS
		SELECT *FROM userTbl WHERE ID = @id
EXEC usp_userid 'LSG';
EXEC usp_userid 'KBS';
EXEC usp_userid 'KKH';
-- 이렇게 이 프로시저를 실행 시 첫 번째 EXEC usp_userid 'LSG'만 최적화 및 컴파일을 수행하고 나머지는 메모리(캐시)의 것을 사용
-- 그러므로 일반적으로 쿼리보다는 저장 프로시저가 시스템의 성능 및 여러가지 면에서 더욱 바람직하다.


---- WITH RECOMPILE 옵션과 저장 프로시저의 문제점 
--인덱스를 사용해서 결과가 빨라지는 경우도 있지만 아닌 경우도 있었다. 

-- 실습 
-- 저장 프로시저의 문제점 파악 

--1. 데이터 준비 
USE sqlDB;
SELECT * INTO spTbl from AdventureWorks2016CTP3.Sales.Customer ORDER BY rowguid;
CREATE NONCLUSTERED INDEX id_spTbl_id on spTbl (CustomerID);
GO

--2. 특정 ID번호 이하를 검색하는 쿼리 확인

--2-1. 번호가 10미만인 쿼리를 실행
SELECT *FROM spTbl WHERE CustomerID < 10;
-- 전체 2만여건 중에서 10건 미만이므로 인덱스를 검색하는 것이 효과적 

--2-2. 번호가 5000미만인 쿼리를 실행 
SELECT *FROM spTbl WHERE CustomerID < 5000;
-- 역시 전체 데이터의 25%를 검색하는거라 인덱스 사용을 하지 않고 스캔을 했음 
GO

--3. 이것을 저장 프로시저로 생성

--3-1. 번호를 매개변수로 하는 저장 프로시저를 생성 
CREATE PROC usp_ID
		@id INT
AS
		SELECT *FROM spTbl WHERE customerID < @id;
GO

--3-2. 10미만의 번호를 조회하기 위해서 처음으로 실행
EXEC usp_ID 10;
-- 마찬가지로 인덱스를 사용했다. 

--3-3. 번호가 5000미만 조회
EXEC usp_ID 5000;
-- 데이터 양이 25%가 넘는데도 인덱스를 사용했다. 이는 엄청난 시스템 부하를 줄 것이다. 
-- 따라서 아래와 같은 방법으로 해결할 수 있다. 
GO

--4. 문제 해결

--4-1. 실행 시에 다시 컴파일 옵션을 사용한다. 
EXEC usp_ID 5000 WITH RECOMPILE; -- 테이블 스캔을 하게 된다.

--4-2. 다른 방법으로는 SP_RECOMPILE을 사용하여 다시 컴파일하도록 설정한다.
EXEC sp_recompile spTbl;
EXEC usp_ID 10;
-- 이렇게 하게 된다면 처음 실행하는 usp_ID만 다시 컴파일하며, 두 번째 실행부터는 다시 컴파일 하지 않는다. 
-- 이제는 인덱스를 사용해야 할 EXEC usp_ID 5000도 인덱스를 사용하게 된다. 이것 역시 문제다. 

--5. DBCC FREEPROCCACHE 문을 사용해서 캐시를 비울 수도 있다. 
EXEC usp_ID 5000;

-- 실행계획을 살펴보면 인덱스를 사용한다. 
DBCC FREEPROCCACHE; -- 전체 저장 프로시저와 관련된 실행 계획 캐시를 지운다. 
EXEC usp_ID 5000;

-- 지금과 같이 인덱스를 사용할지 여부가 저장 프로시저를 실행할 때마다 불분명하다면, 저장 프로시저를 생성할 때 아예 실행 시마다 항상 컴파일이 되도록 설정
DROP PROC usp_ID;
GO
CREATE PROC usp_ID
		@id INT
WITH RECOMPILE
AS
	SELECT * FROM spTbl WHERE CustomerID < @id;
GO
EXEC usp_ID 10;
EXEC usp_ID 5000;