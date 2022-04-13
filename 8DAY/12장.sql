---------------커서 

-- 커서는 행의 집합을 다루기에 많은 편리한 기능을 제공해준다. 
-- 테이블에서 여러 개의 행을 쿼리한 후에, 쿼리의 결과인 행 집합을 한 행씩 처리하기 위한 방식이다. 
-- 쉽게 말해 한 행씩 읽을 때마다 '파일 포인터'는 자동으로 다음 줄을 가리킨다. 커서도 이와 비슷한 동작을 한다. 

--- 순서
--1. 파일을 연다.(OPEN) 그러면 파일 포인터는 파일의 제일 시작(BOF: BEGIN OF FLIE)을 가리키게 된다. 
--2. 처음 데이터를 읽는다 그러면 첫 행 데이터가 읽어지고, 파일 포인터는 다음 행으로 이동한다.
--3. 파일 끝(EOF: END OF FILE)까지 반복한다. 
--	3-1. 읽은 데이터를 처리
--	3-2. 현재의 파일포인터가 가리키는 데이터를 읽는다. 파일포인터는 자동으로 다음으로 이동한다. 
-- 4. 파일을 닫는다. 

--- 커서 처리 순서
--1. 커서의 선언(DECLARE)
--2. 커서 열기(OPEN)
--3. 커서에서 데이터 가져오기(FETCH) (WHILE문으로 모든 행이 처리될 때까지 반복)
--4. 데이터 처리 (WHILE문으로 모든 행이 처리될 때까지 반복)
--5. 커서 닫기(CLOSE)
--6. 커서의 해제(DEALLOCATE)

-- 실습
--1. 커서를 이용하여 고객의 평균 키를 구하자

--1-1. 복원
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

--1-2. 커서 선언
USE sqlDB;
GO
DECLARE userTbl_cursor CURSOR GLOBAL
	FOR SELECT height FROM userTbl;

--1-3. 커서 오픈
OPEN userTbl_cursor;

--1-4. 커서에서 데이터를 가져오고, 데이터 처리를 반복. 

--우선, 사용할 변수를 선언
DECLARE @height INT -- 고객의 키
DECLARE @cnt INT = 0 -- 고객의 인원 수(= 읽은 행의 수)
DECLARE @totalHeight INT = 0 -- 키의 합계

FETCH NEXT FROM userTbl_cursor INTO @height -- 첫 행을 읽어서 키를 @height 변수에 넣는다.

--성공적으로 읽었다면 @@FETCH_STATUS 함수는 0을 반환하므로, 계속 처리한다.
--즉, 더 이상 읽은 행이 없다면 (=EOF을 만나면) WHILE 문을 종료한다.
WHILE @@FETCH_STATUS =0
BEGIN
	SET @cnt += 1 --읽은 개수를 증가시킨다.
	SET @totalHeight += @height -- 키를 계속 누적시킨다.
	FETCH NEXT FROM userTbl_cursor INTO @height -- 다음 행을 읽는다.
END 

--고객의 키의 평균을 출력한다.
PRINT '고객 키의 평균==>' + CAST(@totalHeight/@cnt AS CHAR(10))
GO

--1-5. 커서를 닫는다. 
CLOSE userTbl_cursor;
GO

--1-6. 커서 할당을 해제한다. 
DEALLOCATE userTbl_cursor;
GO

-------------커서의 선언 

--1. LOCAL/GLOBAL
	-- GLOBAL은 전역 커서, LOCAL은 지역 커서 
	-- 전역 커서는 모든 저장 프로시저나 일괄 처리에서 커서의 이름을 참조
	-- 지역 커서는 지정된 범위에서만 유효하며 해당 범위를 벗어나면 자동으로 소멸

--2. FORWARD_ONLY/SCROLL
	--FORWARD_ONLY는 시작 행부터 끝 행의 방향으로만 커서가 이동된다. 그러므로 사용할 수 있는 데이터 가져오기(인출)은 FETCH NEXT뿐이다.
	--SCROLL은 자유롭게 커서 이동이 가능하기 때문에 FETCH NEXT/FIRST/LAST/PRIOR 등을 사용할 수 있지만  SCROLL 옵션은 자주 사용X
	
--3. STATIC/KEYSET/DYNAMIC/FAST_FORWARD
	--STATIC은 커서에서 사용할 데이터를 모두 tempdb에 복사한 후에 데이터를 사용하게 된다, 
	--그 데이터가 변경되어도, 커서에서 데이터 인출 시에는 tempdb에 복사된 변경 전의 데이터를 가져오게 된다(즉, 원본 테이불의 변경된 사항을 알 수가 없다). 
	
	--KEYSET/DYNAMIC은 STATIC과 반대의 개념으로 커서에서 행 데이터를 접근할 때마다 원본 테이블에서 가져온다고 생각하면 된다. 
	--두 개의 차이점은 DYNAMIC은 현재의 키 값 만 tempdb에 복사하고, 
	--KEYSET은 모든 키 값을 tempdb에 저장하는 차이점이다, 
	--그러므로 DYNAMIC으로 설정하면 원본 테이블의 UPDATE 및 INSERT된 내용이 모두 보이지만. 
	--KEYSET은 원본 테이릅의 UPDATE된 내용만 보이며 INSERT된 내용은 보이지 않는다. 
	--또한 KEYSET을 사용하기 위해서는 원본 테이불에 꼭 고유 인덱스가 있어야 한다. 

	--FAST FORWARD는 FORWARD_ONLY 옵션과 READ_ONLY 옵션이 합쳐진 것이다. 
	--커서에서 행 데이터를 수정하지 않을 것이라면 성능에는 가장 바람직한 옵션이다. 
	--되도록 필요한 옵션율 지정해서 커서를 정의하는 게 좋다. 
	--특별히 서버의 옵션을 변경하지 않았 다면 디폴트로는 DYNAMIC으로 생성된다. 
	
	--커서 성능별로 나열 
	--FAST_FORWARD >STATIC >KEYSET >DYNAMIC다. 
	
	--커서는 되도록 사용히지 않는 것이 좋다고 에기했지만 그래도 커서를 사용해야 한다면 
	--특별한 경우기 아니라면 DYNAMIC은 사용하지 말자. 성능에 가장 나쁜 방법이다. 
	
--4. READ_ONLY/SCROLL_LOCKS/OPTIMISTIC 
	-- READ_ONLY는 읽기 전용으로 설정하는 것

	-- SCROLL_LOCKS는 위치 지정 업데이트나 삭제가 가능하도록 설정하는 것이다. 

	-- OPTIMISTIC은 커서로 행을 읽어 둘인 후에, 원본 테이 블의 행이 업대이트 되었다면 커서에서는 해당 행을 위치 지정 업데이트나 삭제되지 않도목 지정한다. 
	
--5. TYPE_WARNING 
	-- 요청한 커서 형식이 다른 형식으로 암시적으로 변환된 경우 클라이언트에 경고 메시지률 보낸다. 
	-- 암시적인 변환의 예로는 고유 인덱스가 없을 경우에 , KEYSET 커서로 만들려고 하면 암시적으로 변환이 작동해서 
	-- STATIC 커서로 자동 변경된다. 
	-- 그때, 이 옵션을 설정하지 않으면 아무런 메시지가 나오지 않는다, 
	-- 그렇게 되면 원본 테이불의 업데이트된 데이터를 확인할 수 없으므로, 추후에 문제가 발생함

--6. FOR select_statement 
	-- SELECT 문장을 이 부분에 사용한다. SELECT 문의 결과가 바로 커서에서 한 행씩 처리할 행 집합이 된다. 
	-- COMPUTE, COMPUTE BY, FOR BROWSE, INTO 키워드는 사용할 수 없다. 

--7. FOR UPDATE [OF column_name [,... n]] 
	-- 그냥 FOR UPDATE만 지정하면 SELECT 문의 모든 열을 업데이트 할 수 있으며, 특정 열을 지 정하려면 'OF 열이름’을 지정하면 된다. 
	
--8. DECLARE CURSOR에서 READ_ONLY, OPTIMISTIC, SCROLL_LOCKS를 지정하지 않을 경우 기본값은 다음과같다. 
-- ► 권한이 부족하거나 업데이트되지 않는 테이블일 경우, 커서는 READ_ONLY가 된다.
-- ► STATIC 및 FAST_FORWARD 커서는 기본적으로 READ_ONLY가 된다. 
-- ► DYNAMIC 및 KEYSET 커서는 기본적으로 OPTIMISTIC이 된다. 
GO

------- 커서 열기
-- OPEN userTbl_cursor
-- 지역 커서에 동일한 이름이 없다는 전제하에, 현재 앞에서 선언한 전역 커서가 열린다. 
-- 하지만 전역커서에도 동일한 이름이 있고 지역커서에도 동일한 이름이 있다면 반드시 open 뒤에 GLOBAL을 붙여줘야한다. (지역이 전역보다 우선이기 때문)
GO

------- 커서에서 데이터 가져오기 및 데이터 처리하기
--FETCH NEXT/PRIOR/FIRST/LAST 
--FROM 커서이름
--WHILE @@FETCH_STATUS = 0 --@@FETCH_STATUS 함수는 0을 반환하므로 계속 처리함 
--BEGIN 
----데이터 처리 
--	FETCH NEXT FROM 커서이름 --다음 행을 읽고, WHILE문으로 간다.
--END
GO

------- 커서 닫기
CLOSE userTbl_cursor;
-- 지역커서의 경우 범위를 빠져나가게 되면, 자동으로 커서가 닫힌다.
-- 즉, 저장 프로시저나 트리거에서 커서를 사용하면 해당 프로시저나 트리거가 종료되면 커서도 닫히게 되므로, CLOSE문을 안써줘도 됨
GO

------ 커서 할당 해제
DEALLOCATE userTbl_cursor;
-- 마찬가지로 지역커서의 경우 범위를 빠져나가게 되면, 자동으로 할당도 해제된다.
GO

-- 실습 
-- 2. 커서와 일반 쿼리의 성능 비교

--2-1. 실습에 사용할 DB 생성하고 대량의 데이터 복사 
USE tempdb;
CREATE DATABASE cursorDB;
GO
USE cursorDB;
SELECT * INTO cursorTbl FROM AdventureWorks2016CTP3.Sales.SalesOrderDetail;
GO
--2-2. 실습1과 비슷한 커서를 사용 @LineTotal의 총 합계 및 평균을 구하기 위한 커서

DECLARE cursorTbl_cursor CURSOR GLOBAL FAST_FORWARD
	FOR SELECT LineTotal FROM cursorTbl;
OPEN cursorTbl_cursor;

DECLARE @LineTotal money -- 각 행의 합계
DECLARE @cnt INT -- 읽은 행의 수
DECLARE @sumLineTotal money --총 합계

SET @sumLineTotal = 0 --0으로 초기화
SET @cnt = 0 --0으로 초기화

FETCH NEXT FROM cursorTbl_cursor INTO @LineTotal

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @cnt = @cnt + 1
	SET @sumLineTotal = @sumLineTotal + @LineTotal
	FETCH NEXT FROM cursorTbl_cursor INTO @LineTotal
END

PRINT '총 합계 ==> ' + CAST(@sumLineTotal AS CHAR(20))
PRINT '건당 평균 ==› ' + CAST (@sumLineTotal/@cnt AS CHAR(20))

CLOSE cursorTbl_cursor;
DEALLOCATE cursorTbl_cursor;
GO

--2-3. 동일한 결과를 낼 수 있는 일반적인 쿼리 실행
SELECT SUM(LineTotal) AS [총 합계], AVG(LineTotal) AS [건당 평균] FROM cursorTbl; --커서 보다 훨씬 빠르다. 
GO

----GLOBAL / LOCAL 

--실습3
--3-1. GLOBAL / LOCAL의 설정을 확인. 커서의 유형을 확인
USE cursorDB;
GO

--3-2. 옵션을 주지 말고 커서를 정의
DECLARE cursorTbl_cursor CURSOR
FOR SELECT LineTotal FROM cursorTbl;

--3-3. 커서의 상태 확인
DECLARE @result CURSOR
EXEC sp_describe_cursor @cursor_return = @result OUTPUT,
	@cursor_source = N'GLOBAL', --GLOBAL 커서임을 지정
	@cursor_identity = N'cursorTbl_cursor' -- 커서 이름을 지정

FETCH NEXT from @result
WHILE (@@FETCH_STATUS <> -1) -- <>는 같지 않다는 뜻 
	FETCH NEXT FROM @result
-- CURSOR_SCOPE가 2인 전역 커서인 것을 확인 할 수 있다. 
GO

--3.4. 커서 해제 
DEALLOCATE cursorTbl_cursor;
GO

----- 디폴트가 지역 커서가 되도록 옵션 변경 후 실습

--4-1. 옵션을 주지 말고 커서를 정의 (지역 커서로 정의 될 것이다.)
DECLARE cursorTbl_cursor CURSOR
FOR SELECT LineTotal FROM cursorTbl;
GO
--4-2. 다시 커서의 정보를 확인 
DECLARE @result CURSOR
EXEC sp_describe_cursor @cursor_return = @result OUTPUT,
	@cursor_source = N'LOCAL', --LOCAL 커서임을 지정
	@cursor_identity = N'cursorTbl_cursor' -- 커서 이름을 지정

FETCH NEXT from @result
WHILE (@@FETCH_STATUS <> -1) -- <>는 같지 않다는 뜻 
	FETCH NEXT FROM @result
-- 4-2 부분만 실행하면 오류가 난다. 
-- 4-1에서 두 줄만 실행했으니, 그 두 줄을 벗어나면 지역 커서는 자동으로 해제된다. 
-- 4-1, 4-2를 같이 실행하면 CURSOR_SCOPE가 1인 지역 커서인 것을 확인 할 수 있다. 
-- 지역커서는 해제해 줄 필요가 없다. 자동으로 소멸
GO



----STATIC / DYNAMIC / KEYSET

-- STATIC(정적) 커서를 열면 테이블 모두 복사됨
-- KEYSET(키 집합) 커서를 열면 키 값만 모두 복사됨
-- DYNAMIC(동적) 커서를 열면 현재 커서 포인터의 키 값만 복사됨

-- 실습4
-- 커서의 형태가 내부적으로 작동되는 것을 확인해보자

--4-1 디폴트로 커서를 정의, 커서의 형태를 확인 
--4-1-1 커서 정의
USE cursorDB;
GO
DECLARE cursorTbl_cursor CURSOR
	FOR SELECT LineTotal FROM cursorTbl;
GO
--4-1-2 커서의 정보 확인
DECLARE @result CURSOR
EXEC sp_describe_cursor @cursor_return = @result OUTPUT,
	@cursor_source = N'GLOBAL', --GLOBAL 커서임을 지정
	@cursor_identity = N'cursorTbl_cursor' -- 커서 이름을 지정

FETCH NEXT from @result
WHILE (@@FETCH_STATUS <> -1) -- <>는 같지 않다는 뜻 
	FETCH NEXT FROM @result
-- CURSOR_SCOPE가 2인 전역 커서인 것을 확인 할 수 있다. 
-- 또한 MODEL이 3이라는 것을 알 수 있는데 1은 STATIC(정적) 2는 KEYSET(키 집합) 3은 DYNAMIC(동적) 4는 FAST_FORWARD 의미 
-- 아무것도 설정하지 않으면 디폴트인 DYNAMIC(동적)이 설정되어있다. 
GO
--4-1-3 커서 해제
DEALLOCATE cursorTbl_cursor;
GO

--4-2. 커서를 STATIC(정적)으로 선언 
--4-2-1. SalesOrderDetailID을 UNIQUE KEY로 지정해서 고유 인덱스가 생성되도록 한다.

ALTER TABLE cursorTbl
ADD CONSTRAINT uk_id
UNIQUE (SalesOrderDetailID);
GO

--4-2-2. 전역이며 정적인 커서로 선언 
DECLARE cursorTbl_cursor CURSOR GLOBAL STATIC
FOR SELECT * FROM cursorTbl;
GO

--4-2-3. 커서를 연다. 
OPEN cursorTbl_cursor;
GO

--4-2-4. 커서의 데이터를 인출해서 확인 
FETCH NEXT FROM cursorTbl_cursor; --실행하면 SalesOrderDetailID가 계속 증가됨
GO

--4-2-5. 원본 데이터 SalesOrderID를 전부 0으로 변경
UPDATE cursorTbl SET SalesOrderID = 0;
GO

--4-2-6. 커서에서 다시 인출
FETCH NEXT FROM cursorTbl_cursor; 
-- SalesOrderID가 0으로 보이지 않음 왜냐면 정적 커서는 TEMPDB에 이미 변경되기 전의 모든 행을 복사해 놓았기 때문
GO
--4-2-7. 커서를 닫고 해제
CLOSE cursorTbl_cursor;
DEALLOCATE cursorTbl_cursor;
GO


------커서의 이동 및 암시적 커서 변환
-- 실습 5 
-- 커서의 이동을 확인하고 암시적 커서 변환에 대해서도 알아보자

--5-1. SQLDB를 사용하여 데이터서의 순서를 확인
USE sqlDB;
SELECT name, height FROM userTbl;

--5-2. 커서를 스크롤 가능하도록 정의하고, 커서를 연다.
DECLARE userTbl_cursor CURSOR GLOBAL SCROLL
FOR SELECT name, height FROM userTbl;
GO
OPEN userTbl_cursor;
GO

--5-3. 다음 구문을 두 번 실행
DECLARE @name NVARCHAR(10)
DECLARE @height INT
FETCH NEXT FROM userTbl_cursor INTO @name, @height
SELECT @name, @height

--5-4. 젤 뒤로 가기 (LAST)
DECLARE @name NVARCHAR(10)
DECLARE @height INT
FETCH LAST FROM userTbl_cursor INTO @name, @height
SELECT @name, @height

--5-5. 이전 행으로 가기 (PRIOR)
DECLARE @name NVARCHAR(10)
DECLARE @height INT
FETCH PRIOR FROM userTbl_cursor INTO @name, @height
SELECT @name, @height

--5-6. 처음 행으로 가기 (FIRST)
DECLARE @name NVARCHAR(10)
DECLARE @height INT
FETCH FIRST FROM userTbl_cursor INTO @name, @height
SELECT @name, @height

--5-2-7. 커서를 닫고 해제
CLOSE userTbl_cursor;
DEALLOCATE userTbl_cursor;
GO

----- 암시적 커서 변환 실행

--6-1.고유 인덱스가 없는 테이블 생성
USE sqlDB;
CREATE TABLE keysetTbl(id INT, txt CHAR(5));
INSERT INTO keysetTbl VALUES(1, 'AAA');
INSERT INTO keysetTbl VALUES(2, 'BBB');
INSERT INTO keysetTbl VALUES(3, 'CCC');

--6-2. KEYSET 커서로 선언. 또한 커서를 뒤로 돌릴 일이 없다면 FORWARD_ONLY 옵션을 사용하는 것이 성능에 좋다.
DECLARE keysetTbl_cursor CURSOR GLOBAL FORWARD_ONLY KEYSET
FOR SELECT id, txt FROM keysetTbl;

--6-3. sp_describe_cursor 시스템 저장 프로시저를 이용하여 정보확인
DECLARE @result CURSOR
EXEC sp_describe_cursor @cursor_return = @result OUTPUT,
	@cursor_source = N'GLOBAL', @cursor_identity = N'keysetTbl_cursor'
FETCH NEXT from @result
WHILE (@@FETCH_STATUS <> -1)
FETCH NEXT FROM @result;
-- 커서 선언을 KEYSET으로 실행했는데 MODEL이 1로 되어있는 이유는 테이블 KEYSETTBL에 고유 인덱스가 없기 때문에
-- 암시적인 커서 변환이 일어나서 KEYSET이 STATIC으로 변환된 것이다. 

--6-4. 이러한 암시적인 커서 변환을 모른 채, 첫 번째 행을 인출
OPEN keysetTbl_cursor;
FETCH NEXT FROM keysetTbl_cursor;

--6-5. 원본 테이블의 데이터를 모두 변경한 후에 다시 데이터를 인출
UPDATE keysetTbl SET txt = 'ZZZ';
FETCH NEXT FROM keysetTbl_cursor;
-- 결과를 보니 변경된 데이터가 아닌 처음 커서를 선언할 시점의 데이터가 보임 
-- 현재 이 결과(BBB) 자체가 문제가 아니라, 우리가 기대한 값(ZZZ)이 아니라는 것이 문제

--6-6. 커서를 닫고 해제, 또 샘플 테이블도 다시 만듬
CLOSE keysetTbl_cursor;
DEALLOCATE keysetTbl_cursor;
GO
DROP TABLE keysetTbl;
CREATE TABLE keysetTbl(id INT, txt CHAR (5));
INSERT INTO keysetTbl VALUES(1,'AAA');
INSERT INTO keysetTbl VALUES(2,'BBB');
INSERT INTO keysetTbl VALUES(3,'CCC');
GO

--6-7. TYPE_WARNING 옵션 사용 
DECLARE keysetTbl_cursor CURSOR GLOBAL FORWARD_ONLY KEYSET TYPE_WARNING
FOR SELECT id, txt FROM keysetTbl;
-- 메시지에 의해서 암시적 커서 변환을 예측할 수가 있다. 
GO

--6-8. keysetTblDML ID열을 UNIQUE로 지정해서 고유 인덱스를 생성 (Pimary Key로 지정가능)
ALTER TABLE keysetTbl
ADD CONSTRAINT uk_keysetTbl
UNIQUE (id);
GO

--6-9. 커서 해제 후 다시 선언
DEALLOCATE keysetTbl_cursor;
DECLARE keysetTbl_cursor CURSOR GLOBAL FORWARD_ONLY KEYSET TYPE_WARNING
FOR SELECT id, txt FROM keysetTbl;
GO

--6-10, 커서 정보 확인 
DECLARE @result CURSOR
EXEC sp_describe_cursor @cursor_return = @result OUTPUT,
	@cursor_source = N'GLOBAL', @cursor_identity = N'keysetTbl_cursor'
FETCH NEXT from @result
WHILE (@@FETCH_STATUS <> -1)
FETCH NEXT FROM @result;
-- MODEL이 2번으로 설정된 것을 볼 수 있다. 

--6-11. 커서를 열고 데이터 확인
OPEN keysetTbl_cursor;
FETCH NEXT FROM keysetTbl_cursor;

--6-12. 원본 테이블의 데이터를 모두 변경한 후에 다시 데이터를 인출
UPDATE keysetTbl SET txt = 'ZZZ';
FETCH NEXT FROM keysetTbl_cursor;
-- 변경된 데이터 ZZZ가 확인됨 그 이유는 KEYSET 경우에는 TEMPDB에 keysetTbl의 키인 ID열만 가지고 있기 때문