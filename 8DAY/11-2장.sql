---------11-2장

----------- 사용자 정의 함수 
-- 저장 프로시저는 EXECUTE 또는 EXEC에 의해서 실행되지만 함수는 주로 SELECT문에 포함되어서 실행된다.

--실습 
--1. 사용자 정의 함수 사용

--1-1. 복원
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

--1-2. 출생년도를 입력하면 나이가 출력되는 함수
USE sqlDB;
GO
CREATE FUNCTION ufn_getAge(@byear INT) -- 매개변수를 정수로 받음
		RETURNS INT -- 리턴값은 정수형
AS
		BEGIN
			  DECLARE @age INT
			  SET @age = YEAR(GETDATE()) - @byear
			  RETURN(@age)
		END
GO

--1-3. 함수를 호출해보자

--1-3-1. SELECT 사용
SELECT dbo.ufn_getAge(1979); -- 호출시 스키마명을 붙여줘야함
GO
--1-3-2. EXECUTE 사용(약간 복잡함)
DECLARE @retVal INT;
EXEC @retVal = dbo.ufn_getAge 1979;
PRINT @retVal;
GO

--1-4. 함수는 주로 테이블을 조회할 때 활용할 수 있다. 
SELECT userID, name, dbo.ufn_getAge(birthYear) AS [만 나이] FROM userTbl;

--1-5. 함수를 수정하려면 ALTER문을 사용하면 된다. 우리나라 나이로 계산하도록 수정
ALTER FUNCTION ufn_getAge(@byear INT)
	  RETURNS INT
AS
	  BEGIN
			DECLARE @age INT
			SET @age = YEAR (GETDATE()) - @byear + 1
			RETURN(@age)
	  END
GO

--1-6. 삭제는 마찬가지로 DROP을 사용
DROP FUNCTION ufn_getAge;
GO

-------------함수의 종류

--1. 기본 제공 함수
	-- 시스템 함수 
--2. 사용자 정의 스칼라 함수
	-- RETURN문에 의해서 하나의 단일값을 돌려주는 함수
--3. 사용자 정의 테이블 반환 함수
	-- 테이블 함수라고도 불리며 RETURN 값이 아닌 하나의 테이블인 함수를 말한다.
		-- 인라인 테이블 반환 함수
			-- 간단히 테이블을 돌려주는 함수, 매개변수가 있는 뷰와 비슷한 역할을 한다.
			-- 인라인 테이블 반환 함수는 별도의 내용이 없으며 단지 SELECT 문만 사용되어 그 결과 집합을 돌려준다.
		-- 다중 문 테이블 반환 함수
			-- BEGIN ... END로 정의되며 그 내부에 일련의 T-SQL을 이용해서 반환될 테이블 행 값을 INSERT하는 형식이다. 
GO

--실습 
--1. 테이블 함수 사용

--1-1. 인라인 테이블 반환 함수 정의 
--1-1-1. 입력한 값보다 키가 큰 사용자들을 돌려주는 함수 정의
USE sqlDB;
GO
CREATE FUNCTION ufn_getUser(@ht INT)
	RETURNS TABLE
AS
	RETURN(
			SELECT userID AS [아이디], name AS [이름], height AS [키]
			FROM userTbl
			WHERE height > @ht
		  )
GO
--1-1-2. 177이상인 사용자를 함수를 이용해서 호출
SELECT * FROM dbo.ufn_getUser(177);
GO


--2. 다중 문 테이블 반환 함수
--2-1. 정수 값을 매개변수로 받고 매개변수보다 출생년도가 이후에 태어난 고객들만 등급을 분류하는 함수
--     만약 입력한 매개변수 이후에 태어난 고객이 없다면 '없음'이라는 행 값을 반환
CREATE FUNCTION ufn_userGrade(@bYear INT)
--리턴할 테이블의 정의(@retTable은 BEGIN...END에서 사용될 테이블 변수)
	RETURNS @retTable TABLE
			( userID char (8),
			name NCHAR(10),
			grade NCHAR(5))
AS
BEGIN
	 DECLARE @rowCnt INT;
	 -- 행의 개수를 카운트
	 SELECT @rowCnt = COUNT(*) FROM userTbl WHERE birthYear >= @bYear;
	 -- 행이 하나도 없으면 '없음'이라고 입력하고 테이블을 리턴
	 IF @rowCnt <= 0
	 BEGIN
		  INSERT INTO @retTable VALUES('없음', '없음', '없음');
		  RETURN;
	 END;
	 -- 행이 1개 이상 있다면 아래를 수행하게 됨 
	 INSERT INTO @retTable
			SELECT U.userid, U.name,
				   CASE
						WHEN (sum(price*amount) >= 1500) THEN '최우수고객'
						WHEN (sum(price*amount) >= 1000) THEN '우수고객'
						WHEN (sum(price*amount) >= 1 ) THEN '일반고객'
					    ELSE '유령고객'
				   END
			FROM buyTbl B
				RIGHT OUTER JOIN userTbl U
					ON B.userid = U.userid
			WHERE birthYear >= @bYear
			GROUP BY U.userid, U.name;
	 RETURN;
END;

--2-2. 1970년 이후의 고객을 출력
SELECT *FROM dbo.ufn_userGrade(1970);
GO
--2-3. 1990년 이후의 고객을 출력 
SELECT *FROM dbo.ufn_userGrade(1990);
GO

--------------- 스키마 바운드 함수
-- 스키마 바운드 함수란 함수에서 참조하는 테이블, 뷰, 등이 수정되지 못하도록 설정한 함수를 말한다. 
-- 예로 함수A의 내용이 테이블B, 뷰 C를 참조하고 있을 경우 테이블B, 뷰 C가 삭제되거나 열 이름이 바뀐다면 함수 A의 실행에 문제가 발생
-- 이러한 문제를 방지하는 것이 스키마 바운드 함수이다. 

---- 테이블 변수
-- 일반적인 변수의 선언처럼 테이블 변수도 선언해서 사용할 수 있다.
-- 테이블 변수의 용도는 주로 임시 테이블의 용도와 비슷하게 사용될 수 있다. 잠시 후 실습에서 확인

-- 사용자 정의 함수의 제약 사항
	-- 사용자 정의 함수 내부에 TRY ... CATCH 문을 사용할 수 없다.
	-- 사용자 정의 함수 내부에 CREATE/ALTER/DROP문을 사용할 수 없다.
	-- 오류가 발생하면 즉시 함수의 실행이 멈추고 값을 반환하지 않는다.

--실습
--1. 스칼라 함수를 연습, 스키마 바운드 함수 및 테이블 변수에 대해서 실습

--1-1. 복원
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

--1-2. BUYTBL을 참조하는 스칼라 함수를 생성. 
--     현재 할인행사 중이라고 가정하고 입력된 사용자의 총 구매한 가격에 따라서 차등된 할인율을 적용하는 함수
USE SqlDB;
GO
CREATE FUNCTION ufn_discount(@id NVARCHAR(10))
	   RETURNS BIGINT
AS
BEGIN
	   DECLARE @totPrice BIGINT;

	   --입력된 사용자ID의 총 구매액
		SELECT @totPrice = sum(price*amount)
		FROM buyTbl
		WHERE userID = @id
		GROUP BY userID;

	   --총 구매액에 따라서 차등된 할인율 적용
	   SET @totPrice = 
				CASE
					WHEN (@totPrice >= 1500) THEN @totPrice*0.7
					WHEN (@totPrice >= 1000) THEN @totPrice*0.8
					WHEN (@totPrice >= 500) THEN @totPrice*0.9
					ELSE @totPrice
				END;
	   --구매기록이 없으면 0원
	   IF @totPrice IS NULL
				SET @totPrice = 0;
	   RETURN @totPrice;
END

--1-3. 함수를 사용
SELECT userID, name, dbo.ufn_discount(userID) AS [할인된 총 구매액] FROM userTbl;
GO
--1-4. buyTbl의 price 열의 이름을 cost로 변경
EXEC sp_rename 'buyTbl.price', 'cost', 'COLUMN'; -- 주의는 나오지만 변경은 된다.
GO
--1-5. 다시 함수를 실행 
SELECT userID, name, dbo.ufn_discount(userID) AS [할인된 총 구매액] FROM userTbl;
GO
--함수에서 참조된 열 이름(PRICE)이 없으므로 당연히 오류가 발생

--1-6. 열의 이름을 원래대로 돌려 놓기
EXEC sp_rename 'buyTbl.cost', 'price', 'COLUMN';

-------2. 위의 문제를 방지하기 위해 스키마 바운드 함수로 변경

--2-1. ALTER FUNCTION 명령으로 변경
ALTER FUNCTION ufn_discount(@id NVARCHAR(10))
	  RETURNS BIGINT
WITH SCHEMABINDING
AS
BEGIN
	   DECLARE @totPrice BIGINT;

	   --입력된 사용자ID의 총 구매액
		SELECT @totPrice = sum(price*amount)
		FROM buyTbl
		WHERE userID = @id
		GROUP BY userID;

	   --총 구매액에 따라서 차등된 할인율 적용
	   SET @totPrice = 
				CASE
					WHEN (@totPrice >= 1500) THEN @totPrice*0.7
					WHEN (@totPrice >= 1000) THEN @totPrice*0.8
					WHEN (@totPrice >= 500) THEN @totPrice*0.9
					ELSE @totPrice
				END;
	   --구매기록이 없으면 0원
	   IF @totPrice IS NULL
				SET @totPrice = 0;
	   RETURN @totPrice;
END
-- 이렇게 하면 오류가 발생하므로 FROM buyTbl을 FROM dbo.buyTbl로 변경
ALTER FUNCTION ufn_discount(@id NVARCHAR(10))
	  RETURNS BIGINT
WITH SCHEMABINDING
AS
BEGIN
	   DECLARE @totPrice BIGINT;

	   --입력된 사용자ID의 총 구매액
		SELECT @totPrice = sum(price*amount)
		FROM dbo.buyTbl
		WHERE userID = @id
		GROUP BY userID;

	   --총 구매액에 따라서 차등된 할인율 적용
	   SET @totPrice = 
				CASE
					WHEN (@totPrice >= 1500) THEN @totPrice*0.7
					WHEN (@totPrice >= 1000) THEN @totPrice*0.8
					WHEN (@totPrice >= 500) THEN @totPrice*0.9
					ELSE @totPrice
				END;
	   --구매기록이 없으면 0원
	   IF @totPrice IS NULL
				SET @totPrice = 0;
	   RETURN @totPrice;
END

--2-2. buyTbl의 열 이름을 변경
EXEC sp_rename 'buyTbl.price', 'cost', 'COLUMN';
-- 스키마 바운드 함수에서 참조하는 열은 변경할 수가 없다. 

------3. 테이블 변수 연습
--3-1. @tblVar 테이블 변수를 선언하고 값을 입력

DECLARE @tblVar TABLE (id char(8), name NVARCHAR (10), addr NCHAR(2));
INSERT INTO @tblVar
	SELECT userID, name , addr FROM userTbl WHERE birthyear >= 1970;
SELECT * FROM @tblVar;

--3-2. 동일한 용도의 임시 테이블을 선언해서 사용 
CREATE TABLE #tmpTbl
		(id char(8), name NVARCHAR(10), addr NCHAR(2));
INSERT INTO #tmpTbl
		SELECT userID, name , addr FROM userTbl WHERE birthyear >= 1970;
SELECT * FROM #tmpTbl;
--결과는 동일하고 임시 테이블 변수는 거의 같다. 차이점은 메모리에 생성되는 것이므로 한 번 사용된 후에는 다시 사용 x

--임시 테이블은 tempdb에 생성되는 것이므로 SQL Server가 다시 시작되기 전까지는 계속 남아 있다.

--시스템의 성능을 위해서는 작은 데이터를 임시로 사용 시에는 테이블 변수가 유리할 수 있고, 대용량랑의 데이터
--를 임시로 사용하기 위해서는 임시 테이블이 더 나을 수 있다. 이유는 임시 테이블은 일반 테이블이 갖는 모든
--성격을 갖게 되므로 대용량의 데이터의 경우 비클러스터형 인덱스를 생성할 수 있으나, 테이블 변수에는 비를
--러스터형 인덱스를 생성할 수가 없다.

--또, 테이블 변수는 명시적인 트랜잭션(BEGIN TRAN...COMMIT/ROLLBACK TRAN) 내부에 있더라도
--영향을 받지 않는다. 다음의 예제를 보면 이해가 될 것이다.

DECLARE @tblVar TABLE (id INT);
BEGIN TRAN
	INSERT INTO @tblVar VALUES (1);
	INSERT INTO @tblVar VALUES (2);
ROLLBACK TRAN
SELECT *FROM @tblVar;
--일반 테이블이나 임시 테이블의 경우라면 ROLLBACK을 시켰으니 아무 값도 나오지 않겠지만, 테이블 변수
--는 명시적 트랜잭션의 영향을 받지 않았다.
