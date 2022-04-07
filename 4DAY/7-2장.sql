--7-2 

--분석 함수 

USE sqlDB;
--OVER함수는 ORDER BY, GROUP BY 서브쿼리를 개선하기 위해 나온 함수
--누적이라던가, 순위, 퍼센테이지, 평균, 총합 등 데이터를 통계나 집계할 때
--단일함수랑 집계함수랑 같이 올 수 없기 때문에, 서브쿼리를 사용하게 되는데요
--특히 다수의 집계결과가 필요할 때 여러 서브쿼리와 그룹바이로 인해 쿼리가 지저분해져요.  
--이를 마법처럼 간단하게 만들어주는 절이 OVER절입니다.

--LEAD 함수 : 다음 행의 값을 리턴
--LEAD(기준열이름, 몇번째 다음행 값 표시, 가져올 행이 없을 경우 반환값)

------ 다음 사람과 키 차이 구하기 
SELECT name, addr, height AS [키],
	height - (LEAD(height,1,0) OVER (ORDER BY height DESC)) AS [다음 사람과 키 차이]
	FROM userTbl;
--height 열 사용 후 1번째 행(바로 다음 행)이 비교 대상이며 다음 행이 없을 경우 0을 출력 

------ 지역별로 가장 키가 큰 사람과의 차이 
SELECT name, addr, height AS [키],
	height - (FIRST_VALUE(height)OVER (PARTITION BY addr ORDER BY height DESC)) AS [지역별 가장 큰 키와 차이]
	FROM userTbl;

------ 누적 합계, 현 지역에서 자신보다 키가 같거나 큰 인원의 백분율 구하기 CUME_DIST 함수 사용
SELECT addr, name, height AS [가입일],
	(CUME_DIST() OVER (PARTITION BY addr ORDER BY height DESC)) * 100 AS [누적인원 백분율%]
	FROM userTbl;
-- 다른 예로 직원별 연봉이 소속 부서 중에서 몇 퍼센트 안에 드는지 확인할 때도 사용 가능 

------ 각 지역별로 키의 중앙값을 계산 PERCENTILE_CONT()
SELECT DISTINCT addr,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY height) OVER (PARTITION BY addr)
		AS [지역별 키의 중앙값]
	FROM userTbl;
GO

------------ PIVOT / UNPIVOT 
--한 열에 포함된 여러 값을 출력하고, 이를 여러 열로 변환하여 테이블 반환 식을 회전하고 필요하면 집계까지 수행 
--PIVOT (집계함수(열) FOR 새로운 열로 변경할 열이름 IN (열 목록) AS 피벗이름)

--임시 테이블 만들기
USE tempdb;
CREATE TABLE pivotTest
(uName NCHAR(3),
 season NCHAR(2),
 amount INT);

--데이터 입력 
INSERT INTO pivotTest VALUES
	('김범수', '겨울', 10), ('윤종신', '여름', 15), ('김범수', '가을', 25),
	('김범수', '봄', 3), ('김범수', '봄', 37), ('윤종신', '겨울', 40),
	('김범수', '여름', 14), ('김범수', '겨울', 22), ('윤종신', '여름', 64);
SELECT * FROM pivotTest;

--PIVIT 연산자 수행 
SELECT * FROM pivotTest
	PIVOT (SUM(amount)
		   FOR season
		   IN ([봄],[여름],[가을],[겨울])) AS resultPivot;
--UNPIVOT은 PIVOT 반대로 행을 열로 변환

--------JSON 데이터
-- JSON은 현대의 웹과 모바일 응용 프로그램 등과 데이터를 교환하는 표준 포맷
-- 속성(KEY)과 값(VALUE)으로 쌍을 이뤄 구성된다. 

--SQL 테이블 JSON화 시키기 
USE sqlDB;
SELECT name, height FROM userTbl
WHERE height >= 180
FOR JSON AUTO;

--결과 값
--[{"name":"임재범","height":182},
--{"name":"이승기","height":182},
--{"name":"성시경","height":186}]

-- JSON 데이터 SQL화 시키기 
DECLARE @json VARCHAR(MAX)
SET @json = N' {"userTBL":
	[
		{"name":"임재범","height":182},
		{"name":"이승기","height":182},
		{"name":"성시경","height":186}
	]
 }'
 SELECT ISJSON(@json); --문자열이 JSON 형식을 만족하면 1 그렇지 않으면 0을 반환
 SELECT JSON_QUERY(@json, '$.userTBL[0]'); -- JSON 데이터 중 하나의 행을 추출 
 SELECT JSON_VALUE(@json, '$.userTBL[0].name'); -- 속성(KEY)이 가지는 값(VALUE)을 추출 
 SELECT * FROM OPENJSON(@json, '$.userTBL')
 WITH (
		name NCHAR(8)	'$.name', 
		height INT		'$.height');
		--$.name, $.height은 JSON 데이터의 속성을 나타냄

-----------------------조인 

--INNER JOIN (내부 조인)
--형식 
--SELECT <열목록> FROM <첫 번째 테이블> INNER JOIN <두 번째 테이블> ON <조인될 조건> [WHERE 검색 조건] //WHERE 생략 가능 

USE sqlDB;
--JYP(조용필)의 구매 테이블 및 판매 테이블 조인 
SELECT * 
	FROM buyTbl
	INNER JOIN userTbl
		ON buyTbl.userID = userTbl.userID
	WHERE buyTbl.userID = 'JYP';

-- 구매 테이블 및 판매 테이블 전체 데이터 조인(WHERE 생략)
SELECT * 
	FROM buyTbl
	INNER JOIN userTbl
		ON buyTbl.userID = userTbl.userID;

-- 아이디/ 이름/ 구매물품/주소/연락처 추출 
SELECT userID, name, prodName, addr, mobile1+mobile2 AS [연락처]
	FROM buyTbl
		INNER JOIN userTbl
			ON buyTbl.userID = userTbl.userID; --오류 
-- 이 경우 두 테이블 모두 USERID가 들어있어 어느 테이블의 USERID를 추출을 할 것인지 명시해야함
SELECT buyTbl.userID, name, prodName, addr, mobile1+mobile2 AS [연락처] --지금은 buyTbl을 기준으로 하는 것이라 buyTbl의 userID를 선택
	FROM buyTbl
		INNER JOIN userTbl
			ON buyTbl.userID = userTbl.userID;

-- 코드를 명확하게 표현하기 위해 모두 열이름으로 ... 별칭 붙여서.
SELECT B.userID, U.name, B.prodName, U.addr, U.mobile1+U.mobile2 AS [연락처] --지금은 buyTbl을 기준으로 하는 것이라 buyTbl의 userID를 선택
	FROM buyTbl B
		INNER JOIN userTbl U
			ON B.userID = U.userID;

-- 회원 테이블을 기준으로 아이디가 JYP인 사용자가 구매한 물건의 목록 보기 (차이 없음)
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1+ U.mobile2 AS [연락처] --지금은 buyTbl을 기준으로 하는 것이라 buyTbl의 userID를 선택
	FROM userTbl U
		INNER JOIN buyTbl B
			ON U.userID = B.userID
		WHERE B.userID = 'JYP';

--전체 회원이 구매한 목록 출력하고 회원ID 순으로 정렬 (이너 조인이라 구매 이력이 있는 사람만 출력 가능)
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1+ U.mobile2 AS [연락처] --지금은 buyTbl을 기준으로 하는 것이라 buyTbl의 userID를 선택
	FROM userTbl U
		INNER JOIN buyTbl B
			ON U.userID = B.userID
		ORDER BY U.userID;

-- 쇼핑몰에서 한 번이라도 구매한 기록이 있는 회원을 출력하여 감사 안내문을 보내고 싶을 때 (DISTINCT문을 사용하여 중복 제거)
SELECT DISTINCT U.userID, U.name, U.addr
	FROM userTbl U
		INNER JOIN buyTbl B
			ON U.userID = B.userID
		ORDER BY U.userID;

-- EXISTS 문을 사용해도 동일한 결과를 낼 수 있다. (JOIN 보다 성능이 떨어져서 권장 X)
-- EXISTS(서브 쿼리)는 서브 쿼리의 결과가 "한 건이라도 존재하면" TRUE 없으면 FALSE를 리턴
SELECT U.userID, U.name, U.addr
	FROM userTbl U
	WHERE EXISTS(
		SELECT * 
		FROM buyTbl B
		WHERE U.userID = B.userID);

-------세 개 조인 실습 
USE sqlDB;
CREATE TABLE stdTbl
(stdName NVARCHAR(10) NOT NULL PRIMARY KEY,
 addr NCHAR(4) NOT NULL);
 GO
 CREATE TABLE clubTbl
 (clubName NVARCHAR(10) NOT NULL PRIMARY KEY,
  roomNo NCHAR(4) NOT NULL);
 GO
 CREATE TABLE stdclubTbl
 (num int IDENTITY NOT NULL PRIMARY KEY,
  stdName NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES stdTbl(stdName),
  clubName NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES clubTbl(clubName));
GO
INSERT INTO stdTbl VALUES ('김범수', '경남'), ('성시경', '서울'), ('조용필', '경기'), ('은지원', '경북'), ('바비킴', '서울');
INSERT INTO clubTbl VALUES ('수영', '101호'), ('바둑', '102호'), ('축구', '103호'), ('봉사', '104호');
INSERT INTO stdclubTbl VALUES ('김범수', '바둑'), ('김범수', '축구'),('조용필', '축구'), ('은지원', '축구'), 
								('은지원', '봉사'), ('바비킴', '봉사');
GO

-- 학생을 기준으로 목록 출력 
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdTbl S
		INNER JOIN stdclubTbl SC
			ON S.stdName = SC.stdName
		INNER JOIN clubTbl C
			ON SC.clubName = C.clubName
		ORDER BY S.stdName;

-- 동아리를 기준으로 가입한 학생 목록 출력 (위와 별 차이 없음)
SELECT C.clubName, C.roomNo, S.stdName, S.addr
	FROM stdTbl S
		INNER JOIN stdclubTbl SC
			ON SC.stdName = S.stdName
		INNER JOIN clubTbl C
			ON SC.clubName = C.clubName
		ORDER BY C.clubName;

-------------OUTER JOIN
--LEFT OUTER JOIN
USE sqlDB;
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS[연락처]
	FROM userTbl U
		LEFT OUTER JOIN buyTbl B --왼쪽 테이블의 것은 모두 출력되어야 한다는 의미 
			ON U.userID = B.userID
		ORDER BY U.userID;

--RIGHT OUTER JOIN
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS[연락처]
	FROM buyTbl B
		RIGHT OUTER JOIN userTbl U --오른쪽 테이블의 것은 모두 출력되어야 한다는 의미 
			ON U.userID = B.userID
		ORDER BY U.userID;

-- 한 번도 구매를 하지 않은 회원을 조회 
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS[연락처]
	FROM userTbl U
		LEFT OUTER JOIN buyTbl B
			ON U.userID = B.userID
	WHERE B.prodName IS NULL
	ORDER BY U.userID; 

--동아리에 가입하지 않은 학생까지 출력 (실습 6-2 응용)
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdTbl S
		LEFT OUTER JOIN stdclubTbl SC
			ON S.stdName = SC.stdName
		LEFT OUTER JOIN clubTbl C
			ON SC.clubName = C.clubName
		ORDER BY S.stdName;

--동아리를 기준으로 학생을 출력하되, 가입 학생이 하나도 없는 동아리도 출력 
SELECT C.clubName, C.roomNo, S.stdName, S.addr
	FROM stdTbl S
		LEFT OUTER JOIN stdclubTbl SC
			ON S.stdName = SC.stdName
		RIGHT OUTER JOIN clubTbl C -- 클럽을 기준으로 조인을 해야해서 여기는 RIGHT OUTER JOIN을 해줌
			ON SC.clubName = C.clubName
		ORDER BY C.clubName;

--위의 두 결과를 하나로 합친다면? -- 학생이 없는 동아리 및 동아리에 가입하지 않은 학생도 출력됨
SELECT S.stdName, S.addr, C.clubName, C.roomNo
	FROM stdTbl S
		FULL OUTER JOIN stdclubTbl SC
			ON S.stdName = SC.stdName
		FULL OUTER JOIN clubTbl C
			ON SC.clubName = C.clubName
		ORDER BY S.stdName;

------------------CROSS JOIN 
-- CROSS JOIN(상호 조인)은 한쪽 테이블의 모든 행과 다른 쪽 테이블의 모든 행을 조인 : 결과 개수 = 두 테이블을 곱한 개수

USE sqlDB;
SELECT * FROM buyTbl CROSS JOIN userTbl;
SELECT * FROM buyTbl, userTbl; --위와 같은 결과가 나오지만 권장X

-- CROSS JOIN은 ON 구문을 사용할 수 없으며 테스트로 많은 용량의 데이터를 생성할 때 주로 사용 
USE AdventureWorks2016CTP3;
SELECT COUNT_BIG(*) AS [데이터 개수]
	FROM Sales.SalesOrderDetail
		CROSS JOIN Sales.SalesOrderHeader;
GO

------------------SELF JOIN
-- 자기 자신과 자기 자신이 조인한다는 의미 대표적인 예가 6장의 empTbl

USE sqlDB;
CREATE TABLE empTbl (emp NCHAR(3), manager NCHAR(3), department NCHAR(3));
GO

INSERT INTO empTbl VALUES('나사장', NULL, NULL);
INSERT INTO empTbl VALUES('김재무', '나사장', '재무부');
INSERT INTO empTbl VALUES('김부장', '김재무', '재무부');
INSERT INTO empTbl VALUES('이부장', '김재무', '재무부');
INSERT INTO empTbl VALUES('우대리', '이부장', '재무부');
INSERT INTO empTbl VALUES('지사원', '이부장', '재무부');
INSERT INTO empTbl VALUES('이영업', '나사장', '영업부');
INSERT INTO empTbl VALUES('한과장', '이영업', '영업부');
INSERT INTO empTbl VALUES('최정보', '나사장', '정보부');
INSERT INTO empTbl VALUES('윤차장', '최정보', '정보부');
INSERT INTO empTbl VALUES('이주임', '윤차장', '정보부');

--하나의 테이블에 같은 데이터가 있으나 의미가 다른 경우에는 두 테이블을 서로 SELF JOIN 시켜서 정보를 확인 할 수 있다.
SELECT A.emp AS[부하직원], B.emp AS [직속상관], B.department AS[직속상관부서] 
	FROM empTbl A 
		INNER JOIN empTbl B 
			ON A.manager = B.emp 
		WHERE A.emp = '우대리';
GO

----------------UNION, UNION ALL, EXCEPT, INTERSECT
--UNION은 두 쿼리의 결과를 행으로 합치는 것 
-- SELECT (문장1) UNION [ALL] SELECT (문장2)
-- 대신 문장1과 문장2의 결과열의 개수가 같아야 하며, 데이터 형식도 각 열 단위로 같거나 서로 호환되는 데이터 형식이여야함
USE sqlDB;
SELECT stdName, addr FROM stdTbl
	UNION ALL
SELECT clubName, roomNo FROM clubTbl

---- EXCEPT
-- 위의 쿼리 결과 중에서 두 번째 쿼리에 해당하는 것을 제외하기 위한 구문.
-- sqlDB의 사용자를 모두 조회하되 전화가 없는 사람을 제외하고자 함
SELECT name, mobile1 + mobile2 AS[전화번호] FROM userTbl
	EXCEPT 
SELECT name, mobile1 + mobile2 AS[전화번호] FROM userTbl WHERE mobile1 IS NULL;

---- INTERSECT
-- EXCEPT와 반대로 두 번째 쿼리에 해당되는 것만 조회함
-- 전화가 없는 사람만 조회하고자 할 때
SELECT name, mobile1 + mobile2 AS[전화번호] FROM userTbl
	INTERSECT 
SELECT name, mobile1 + mobile2 AS[전화번호] FROM userTbl WHERE mobile1 IS NULL;
GO


-------------SQL PROGRAMING 

----IF...ELSE...
DECLARE @var1 INT --- @var1 변수 선언
SET @var1 = 100 -- 변수에 값 대입
--DECLARE @var1 INT = 100 이렇게 바로 값을 대입 할 수 있다. 

IF @var1 = 100
	BEGIN 
		PRINT '@VAR1이 100이다.'
	END
ELSE 
	BEGIN 
		PRINT '@VAR1이 100이 아니다.'
	END
GO

--직원번호 111에 해당하는 직원의 입사일이 5년이 넘었는지 확인 
USE AdventureWorks2016CTP3;

DECLARE @hireDATE SMALLDATETIME --입사일
DECLARE @curDATE SMALLDATETIME --오늘
DECLARE @years DECIMAL(5,2) -- 근무한 년수
DECLARE @days INT --근무한 일수 

SELECT @hireDATE = HireDATE --hireDATE 열의 결과를 @hireDATE에 대입 
	FROM HumanResources.Employee
	WHERE BusinessEntityID = 111
SET @curDATE = GETDATE() --현재 날짜
SET @years =  DATEDIFF(year, @hireDATE, @curDATE) -- 날짜의 차이, 년 단위
SET @days = DATEDIFF(day, @hireDATE, @curDATE) -- 날짜의 차이, 일 단위

IF (@years >= 5)
	BEGIN
		PRINT N'입사한지 ' + CAST(@days AS NCHAR(5)) + N'일이나 지났습니다.'
		PRINT N'축하합니다. '
	END
ELSE 
	BEGIN 
		PRINT N'입사한지 ' + CAST(@days AS NCHAR(5)) + N'일밖에 안 되었네요.'
		PRINT N'열심히 일하세요. '
	END
GO

----CASE 

--IF문과 CASE 비교 
--IF문 
DECLARE @POINT INT = 77, @CREDIT NCHAR(1)

IF @POINT >= 90
	SET @CREDIT = 'A'
ELSE 
	IF @POINT >=80
		SET @CREDIT = 'B'
	ELSE
		IF @POINT >= 70
			SET @CREDIT ='C'
		ELSE
			IF @POINT >= 60
				SET @CREDIT ='D'
			ELSE 
				SET @CREDIT = 'F'
PRINT N'취득점수 ==>>' + CAST(@POINT AS NCHAR(3))
PRINT N'학점==>' + @CREDIT 
GO
--CASE문 
DECLARE @POINT INT = 77, @CREDIT NCHAR(1)

SET @CREDIT = 
	CASE 
		WHEN (@POINT >= 90) THEN 'A'
		WHEN (@POINT >= 80) THEN 'B'
		WHEN (@POINT >= 70) THEN 'C'
		WHEN (@POINT >= 60) THEN 'D'
		ELSE 'F'
	END
PRINT N'취득점수 ==>>' + CAST(@POINT AS NCHAR(3))
PRINT N'학점==>' + @CREDIT 

--CASE문 실습 
-- SQLDB 구매 테이블에 구매액(PRICE * AMOUNT)이 1500원 이상인 고객은 '최우수 고객', 1000원 이상은 '우수 고객', 1원 이상은 '일반 고객'
-- 구매 실적이 전혀 없으면 '유령 고객' 

--1. 먼저 buyTbl 구매액을 사용자 아이디 별로 묶는다. 
USE sqlDB;
SELECT userID, SUM(price*amount) AS [총 구매액]
	FROM buyTbl 
	GROUP BY userID 
	ORDER BY SUM(price*amount) DESC;
GO

--2. 사용자 이름 조인하기 
SELECT B.userID, U.name, SUM(price*amount) AS [총 구매액]
	FROM buyTbl B
		INNER JOIN userTbl U
			ON B.userID = U.userID
		GROUP BY B.userID, U.name
		ORDER BY SUM(price*amount) DESC;

--3. 구매하지 않은 고객 명단도 출력. 오른쪽 테이블(USERTBL)의 내용이 없더라도 나오게 하기 위해 RIGHT OUTER JOIN으로 변경
SELECT B.userID, U.name, SUM(price*amount) AS [총 구매액]
	FROM buyTbl B
		RIGHT OUTER JOIN userTbl U
			ON B.userID = U.userID
		GROUP BY B.userID, U.name
		ORDER BY SUM(price*amount) DESC;
GO

--4. 위의 결과를 보니 NAME은 제대로 나왔으나 구매 기록이 없는 고객은 USERID가 NULL로 나왔다. 
-- 왜냐면 SELECT절에서 B.USERID를 출력하기 때문. 
-- BUYTBL에는 윤종신, 김경호 등이 구매한 적이 없으므로 해당 데이터가 전혀 없다. 
-- USERID 기준을 BUYTBL에서 USERTBL로 변경
SELECT U.userID, U.name, SUM(price*amount) AS [총 구매액]
	FROM buyTbl B 
		RIGHT OUTER JOIN userTbl U
			ON B.userID = U.userID
		GROUP BY U.userID, U.name
		ORDER BY SUM(price*amount) DESC;
GO

--5. 총 구매액에 따른 고객 분류를 처음에 제시했던 대로 CASE 문만 따로 고려(실행X)
--CASE 
--	WHEN(총 구매액 >= 1500) THEN N'최우수 고객'
--	WHEN(총 구매액 >= 1000) THEN N'우수 고객'
--	WHEN(총 구매액 >= 1) THEN N'일반 고객'
--	ELSE N'유령고객'
--END
GO

--6. 작성한 CASE 구문을 SELECT에 추가.
SELECT U.userID, U.name, SUM(price*amount) AS [총 구매액],
	CASE 
		WHEN(SUM(price*amount) >= 1500) THEN N'최우수 고객'
		WHEN(SUM(price*amount) >= 1000) THEN N'우수 고객'
		WHEN(SUM(price*amount) >= 1) THEN N'일반 고객'
		ELSE N'유령고객'
	END AS [고객 등급]
 FROM buyTbl B
	RIGHT OUTER JOIN userTbl U
		ON B.userID = U.userID
	GROUP BY U.userID, U.name
	ORDER BY SUM(price*amount) DESC;
GO

-------------WHILE, BREAK, CONTINUE, RETURN

---1. WHILE 
-- 참인 동안에 계속 반복되는 반복문 
-- 1부터 100까지의 값을 모두 더하는 기능 
-- 커서와 함께 자주 사용됨 => 12장
DECLARE @i INT = 1, @hap BIGINT = 0

WHILE (@i <= 100)
BEGIN 
	SET @hap += @i -- HAP의 원래의 값에 @I를 더해서 다시 @HAP에 넣음 
	SET @i += 1 
END

PRINT @hap
GO

-- 1부터 100까지의 값을 더하지만 7의 배수는 제외 그리고 합계가 1000이 넘으면 그만둠 
DECLARE @i INT = 1, @hap BIGINT = 0
WHILE (@i <= 100)
BEGIN
	IF(@i % 7 = 0)
	BEGIN
		PRINT N'7의 배수: ' + CAST (@i AS NCHAR(3))
		SET @i += 1
		CONTINUE --만나면 바로 WHILE문으로 이동해서 다시 비교
	END

	SET @hap += @i 
	IF (@hap > 1000) BREAK -- 여기에 RETURN을 써버리면 '합계 =>1029'를 출력하지 않고 마침    
	SET @i += 1
END
PRINT N'합계 =>' + CAST(@hap AS NCHAR(10));
GO

-----GOTO문
--GOTO문을 만나면 지정한 위치로 무조건 이동함. 프로그램 자체의 논리의 흐름을 깨는 것
-- 위의 예제인 BREAK 대신 GOTO를 쓰면 된다.  

--(중간 생략)
--	SET @hap += @i 
--	IF (@hap > 1000) GOTO ENDPRINT //BREAK 대신 GOTO문    
--	SET @i += 1
--END

--ENDPRINT:
--PRINT N'합계 =>' + CAST(@hap AS NCHAR(10));
GO

-----WAITFOR
-- 코드 실행을 일시정지할 때 사용 
--WAITFOR DELAY - 지정한 시간만큼 일시정지
--WAITFOR TIME - 지정한 시각에 실행 
BEGIN 
	WAITFOR DELAY '00:00:05';
	PRINT N'5초간 멈춘 후 진행되었음';
END
GO 

----------------TRY/CATCH, RAISEERROR, THROW

--TRY/CATCH
-- 오류를 처리하는 데 아주 편리하고 강력한 기능을 발휘함
--형식 
--BEGIN TRY
--	원래 사용하던 SQL 문장들
--END TRY
--BEGIN CATCH
--	만약 BEGIN ...TRY에서 오류가 발생하면 처리할 일들
--END CATCH

--예시
USE sqlDB;
BEGIN TRY
	INSERT INTO userTbl VALUES('LSG', '이상구', 1988, '서울', NULL, NULL, 170, GETDATE())
	-- userTbl에 이미 LSG라는 ID가 있어 오류가 뜰 것이다. 
	PRINT '정상적으로 입력되었습니다.'
END TRY
BEGIN CATCH
	PRINT '오류가 발생했습니다.'
END CATCH

--오류 원인 출력 코드 
ERROR_NUMBER() --오류 번호
ERROR_MESSAGE() --오류 메시지
ERROR_SEVERITY() --오류 심각도
ERROR_STATE() --오류 상태 번호
ERROR_LINE() --오류를 발생시킨 행 번호
ERROR_PROCEDURE() --오류가 발생한 저장 프로시저나 트리거의 이름

BEGIN TRY
	INSERT INTO userTbl VALUES('LSG', '이상구', 1988, '서울', NULL, NULL, 170, GETDATE())
	-- userTbl에 이미 LSG라는 ID가 있어 오류가 뜰 것이다. 
	PRINT '정상적으로 입력되었습니다.'
END TRY

BEGIN CATCH 
	PRINT N'---------오류가 발생했습니다.-----------'
	PRINT N'오류 번호->'
	PRINT ERROR_NUMBER() --오류 번호
	PRINT N'오류 메시지->'
	PRINT ERROR_MESSAGE() --오류 메시지
	PRINT N'오류 심각도->'
	PRINT ERROR_SEVERITY() --오류 심각도
	PRINT N'오류 상태 번호->'
	PRINT ERROR_STATE() --오류 상태 번호
	PRINT N'오류 발생 행 번호->'
	PRINT ERROR_LINE() --오류를 발생시킨 행 번호
	PRINT N'오류 발생 프로시저/트리거->'
	PRINT ERROR_PROCEDURE() --오류가 발생한 저장 프로시저나 트리거의 이름
END CATCH
GO

-- 강제 오류 발생 코드 RAISERROR/THROW 
--RAISERROR 형식
RAISERROR ( { msg_id | msg_str | @local_variable }  
    { ,severity ,state }  
    [ ,argument [ ,...n ] ] )  
    [ WITH option [ ,...n ] ]  
-- msg_id는 50000~21억을 사용자가 메시지 번호로 지정할 수 있다. OR msg_str을 사용하여 출력할 문자열을 써줌 
-- severity로 오류의 심각도를 설정 0~18까지 state는  0~255까지 지정가능하며 추후에 오류가 어디서 발생했는지 찾을 때 유용 

--THROW 형식
THROW [ { error_number | @local_variable },  
        { message | @local_variable },  
        { state | @local_variable } ]   
[ ; ]  
-- error_number는 50000~21억미만의 정수를 사용자가 예외 번호 지정
-- message는 출력할 문자열
-- state는  0~255까지 지정가능하며 추후에 오류가 어디서 발생했는지 찾을 때 유용 

--예시 

RAISERROR('이건 RAISERROR 오류 발생', 16, 1);
THROW 55555, '이건 THROW 오류 발생', 1;
GO


------------EXEC (동적 SQL)
--EXEC 문장 (또는 EXECUTE)은 SQL 문을 실행시켜주는 역할을 한다. 

USE sqlDB
DECLARE @sql VARCHAR(100)
SET @sql = 'SELECT * FROM userTbl WHERE userid = ''EJW'' ' --모두 작은 따옴표
EXEC(@sql)

-- SELECT * FROM userTbl WHERE userid = 'EJW' 문장을 바로 실행하지 않고 변수 @sql에 입력시켜놓고 EXEC() 함수로 실행할 수 있다. 
-- 이렇게 쿼리문을 실행하는 것을 동적SQL 이라고 부른다. 