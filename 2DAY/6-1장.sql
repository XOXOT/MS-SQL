--6장

------------------------------데이터베이스 지정 쿼리문 USE 
USE AdventureWorks2016CTP3;

--데이터 가져오기 SELECT 열이름 FROM 테이블 이름 WHERE 조건 
SELECT *FROM HumanResources.Employee;
--원칙적으로는 
SELECT *FROM AdventureWorks2016CTP3.HumanResources.Employee;
--스키마 이름까지 생략한다면?
SELECT *FROM Employee; --오류
--필요로 하는 열만 가져오기
SELECT Name FROM HumanResources.Department;
--여러 개의 열을 가져오기
SELECT Name,GroupName FROM HumanResources.Department;


-----------------------------각 데이터베이스의 이름 및 철자가 기억나지 않을 때 조회방법
--현 인스턴스의 데이터 베이스 조회
EXECUTE sp_helpdb; --EXEC로 많이 씀 
--특정 데이터 베이스 정보 보기
EXECUTE sp_helpdb AdventureWorks2016CTP3;
USE [AdventureWorks2016CTP3];
--현재 데이터 베이스에 있는 테이블 정보 조회
EXECUTE sp_tables @table_type = "'TABLE'";
--HumanResources.Department 테이블의 열이 무엇이 있는지 확인(COLUMN_NAME 확인)
EXECUTE sp_columns @table_name = 'Department', @table_owner = 'HumanResources';
--최종적으로 데이터 조회
SELECT Name, GroupName FROM HumanResources.Department;
--별칭 만들기 (열 이름 변경이지만 출력할 때만 변경)
SELECT DepartmentID AS 부서번호, Name 부서이름, [그룹이름] = GroupName 
FROM HumanResources.Department;

---------------------------------실습
--테이블 생성
 USE tempdb;
 GO
 CREATE DATABASE sqlDB;
 GO
------------------------------------------------------------------
-- TINYINT(M) [ 옵션 UNSIGNED , ZEROFILL ] ★★
--: 정수형으로 총 1Byte 저장공간을 차지하는 데이터 타입으로 -128에서 127 사이의 숫자를 저장하기 위한 데이터 타입이다. UNSIGNED 옵션을 적용하면 0에서 255까지의 숫자를 저장한다.

--SMALLINT(M) [ 옵션 UNSIGNED , ZEROFILL ]
--: 정수형으로 총 2Byte 저장공간을 차지하는 데이터 타입으로 -32768에서 32767 사이의 숫자를 저장하기 위한 데이터 타입이다. UNSIGNED 옵션을 적용하면 0에서 65535까지의 숫자를 저장한다.

--MEDIUMINT(M) [ 옵션 UNSIGNED , ZEROFILL ]
--: 정수형으로 총 3Byte 저장공간을 차지하는 데이터 타입으로 -8388608에서 8388607사이의 숫자를 저장하기 위한 데이터 타입이다. UNSIGNED 옵션을 적용하면 0에서 16777215까지의 숫자를 저장한다.

--INT(M) [ 옵션 UNSIGNED , ZEROFILL ] ★★★
--: 정수형으로 총 4Byte 저장공간을 차지하는 데이터 타입으로 INTEGER 라고도 사용한다. -2147483648에서 2147483647 사이의 숫자를 저장하기 위한 데이터 타입으로 UNSIGNED 옵션을 적용하면 0에서 4294967295까지의 숫자를 저장한다.
------------------------------------------------------------------
 USE sqlDB;
 --DROP DATABASE sqlDB;
 CREATE TABLE userTbl -- 회원테이블
 (userID CHAR(8) NOT NULL PRIMARY KEY, --사용자 아이디
  name   NVARCHAR(10) NOT NULL, -- 이름
  birthYear INT NOT NULL, --출생년도
  addr NCHAR(2) NOT NULL, --지역(경기, 서울, 경남 식으로 2글자만 입력)
  mobile1 CHAR(3), -- 휴대폰의 국번(011, 016, 017, 019, 010 등)
  mobile2 CHAR(8), -- 휴대폰의 나머지 전화번호(하이폰 제외)
  height SMALLINT, --키
  mDate DATE -- 회원가입일
  );
  GO
  CREATE TABLE buyTbl --회원 구매 테이블
  (num INT IDENTITY NOT NULL PRIMARY KEY, -- 순번(IDENTITY는 자동 증가 쿼리문)(PK)
   userID CHAR(8) NOT NULL --아이디(FK)
   FOREIGN KEY REFERENCES userTbl(userID),
   prodName NCHAR(6) NOT NULL, --물품명
   groupName NCHAR(4), --분류
   price INT NOT NULL, --단가
   amount SMALLINT NOT NULL -- 수량
   );
   GO

-- 데이터 입력
INSERT INTO userTbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO userTbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO userTbl VALUES('SSK', '성시경', 1979, '서울',  NULL,  NULL,     186, '2013-12-12');
INSERT INTO userTbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO userTbl VALUES('YJS', '윤종신', 1969, '경남',  NULL,  NULL,     170, '2005-5-5');
INSERT INTO userTbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO userTbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO userTbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
GO
SELECT * FROM userTbl;

INSERT INTO buyTbl VALUES('KBS', '운동화',  NULL, 30, 2);
INSERT INTO buyTbl VALUES('KBS', '노트북', '전자',1000,1);
INSERT INTO buyTbl VALUES('JYP', '모니터', '전자',200,1);
INSERT INTO buyTbl VALUES('BBK', '모니터', '전자',200,5);
INSERT INTO buyTbl VALUES('KBS', '청바지', '의류', 50, 3);
INSERT INTO buyTbl VALUES('BBK', '메모리', '전자',80,10);
INSERT INTO buyTbl VALUES('SSK',   '책',   '서적',15, 5);
INSERT INTO buyTbl VALUES('EJW',   '책',   '서적',15, 2);
INSERT INTO buyTbl VALUES('EJW', '청바지', '의류',50, 1);
INSERT INTO buyTbl VALUES('BBK', '운동화', NULL, 30, 2);
INSERT INTO buyTbl VALUES('EJW',   '책',   '서적',15, 1);
INSERT INTO buyTbl VALUES('BBK', '운동화', NULL, 30, 2);
GO
SELECT * FROM buyTbl;

--백업(명령어)
USE tempdb;
BACKUP DATABASE sqlDB TO DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH INIT;

------------------------WHERE
--SELECT 열이름 FROM 테이블 이름 WHERE 조건식
USE sqlDB;
SELECT * FROM userTbl; -- 전체 조회
SELECT * FROM userTbl WHERE name = '김경호'; -- 이름이 김경호인 사람 조회

--1970년 이후에 출생이고 키가 182 이상의 사람의 아이디와 이름을 조회
SELECT userID,name FROM userTbl WHERE birthYear > = 1970 AND height > =182;
--1970년 이후에 출생했거나 키가 182 이상의 사람의 아이디와 이름을 조회
SELECT userID,name FROM userTbl WHERE birthYear > = 1970 OR height > =182;

------------------------BETWEEN AND, IN(), LIKE 
--BETWEEN AND (연속적인 값을 가지고 있을 경우만 가능)
SELECT name 이름, height 신장 FROM userTbl WHERE height > = 180 AND height <=183;
SELECT name 이름, height 신장 FROM userTbl WHERE height BETWEEN 180 AND 183;
--위 두 쿼리문은 같은 의미

--IN() - 연속적인 값이 아닐 경우 
SELECT name 이름, addr 주소 FROM userTbl WHERE addr = '경남' OR addr = '전남' OR addr = '경북';
SELECT name 이름, addr 주소 FROM userTbl WHERE addr IN ('경남','전남','경북');
--위 두 쿼리문은 같은 의미

--LIKE (문자열 내용 검색)
SELECT name 이름, height 신장 FROM userTbl WHERE name LIKE '김%'; --앞글자가 김으로 시작하는 이름의 데이터 이름 및 신장 컬럼을 전부 출력 
SELECT name 이름, height 신장 FROM userTbl WHERE name LIKE '_종신'; -- 앞에 한글자는 아무거나 와도 가능하며 이름이 종신인 사람 출력
-- %(몇글자), _(한글자)


----서브 쿼리문
SELECT name 이름, height 신장 FROM userTbl WHERE height > 177; --이 177을 가진 김경호를 숫자로 적지 않고 쿼리문을 통해 출력
SELECT name 이름, height 신장 FROM userTbl WHERE height > (SELECT height 신장 FROM userTbl WHERE name = '김경호');
--지역이 경남 사람의 키보다 크거나 같은 사람을 추출 
SELECT name 이름, height 신장, addr 주소 FROM userTbl WHERE height >= (SELECT height 신장 FROM userTbl WHERE addr = '경남'); --오류
-- 서브 쿼리문에서 값이 두 개 이상이 나오면 두 개 이상을 반환하기 때문에 오류가 발생함으로 ANY를 써야함
----ANY (서브 쿼리의 여러 개의 결과 중 한 가지만 만족해도 다 출력) - 경남 사람 키 170, 173 보다 큰 사람 다 출력
SELECT name 이름, height 신장, addr 주소 FROM userTbl WHERE height >= ANY (SELECT height 신장 FROM userTbl WHERE addr = '경남');
 
 --ALL (서브 쿼리의 여러 개의 결과 모두 만족) -경남 사람 중 가장 큰 사람보다 키가 다 커야함 즉 170보다 크고 173보다도 커야함
 SELECT name 이름, height 신장, addr 주소 FROM userTbl WHERE height >= ALL (SELECT height 신장 FROM userTbl WHERE addr = '경남');

 -- ANY와 SOME은 동일한 의미 
 SELECT name 이름, height 신장, addr 주소 FROM userTbl WHERE height =SOME (SELECT height 신장 FROM userTbl WHERE addr = '경남');
 SELECT name 이름, height 신장, addr 주소 FROM userTbl WHERE height = ANY (SELECT height 신장 FROM userTbl WHERE addr = '경남');
 -- =ANY와 IN은 같은 의미 
 SELECT name 이름, height 신장, addr 주소 FROM userTbl WHERE height IN (SELECT height 신장 FROM userTbl WHERE addr = '경남');


----ORDER BY (원하는 순서대로 정렬) ORDER BY절은 쿼리문의 젤 뒤에 와야함 
-- 기본 오름차순(ASC) 
SELECT name, mdate FROM userTbl ORDER BY mdate;
-- 내림차순 (DESC)
SELECT name, mdate FROM userTbl ORDER BY mdate DESC;


------------------------DISTINCT, TOP(N), TABLESAMPLE

-- DISTINCT(중복 제거)
SELECT addr FROM userTbl;
SELECT addr FROM userTbl ORDER BY addr;
SELECT DISTINCT addr FROM userTbl ORDER BY addr; -- 중복을 제거하여 보여줌 

-- TOP(N) 상위 몇개 행만 출력 
USE AdventureWorks2016CTP3;
SELECT CreditCardID FROM Sales.CreditCard
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;
--TOP은 앞에 써줌 
SELECT TOP(10) CreditCardID FROM Sales.CreditCard
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;
--TOP 구문은 변수, 수식 및 서브쿼리도 사용 가능
SELECT TOP(SELECT COUNT(*)/100 FROM Sales.CreditCard) CreditCardID FROM Sales.CreditCard 
-- COUNT(*)은 전체 행의 갯수를 반환하고 이것을 100으로 나눈 것으로 1%만 보겠다는 뜻
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;

--TOP()PERCENT - 상위 0.1%만 출력 
SELECT TOP(0.1)PERCENT CreditCardID, ExpYear, ExpMonth
	FROM Sales.CreditCard 
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;

--만약 상위 0.1%를 출력했는데 100점에 1명, 99점에 1명 98점이 5명이라면 98점 5명도 다 출력하게 해야한다면
-- 마지막 출력 값이 동일한 값이 있다면, N%가 넘더라도 출력하는 WITH TIES 쿼리문이 있다,
SELECT TOP(0.1)PERCENT WITH TIES CreditCardID, ExpYear, ExpMonth
	FROM Sales.CreditCard 
	WHERE CardType = 'Vista'
	ORDER BY ExpYear, ExpMonth;

------- 데이터 샘플링 (TABLESAMPLE) 
-- 무작위로 일정한 샘플 데이터를 추출 (소량의 행이 있으면 실행이 불가)
USE AdventureWorks2016CTP3;
SELECT * FROM Sales.SalesOrderDetail TABLESAMPLE(5 PERCENT);

--너무 많다 싶으면 위에서 배운 TOP을 활용하면 된다. 
SELECT TOP(5000) * FROM Sales.SalesOrderDetail TABLESAMPLE(5 PERCENT);

------------------------ OFFSET과 PATCH 
------OFFSET(건너뛰기)
---나이가 많은 4명 건너뛰기 
USE sqlDB;
SELECT userID, name, birthYear FROM userTbl
	ORDER BY birthYear
	OFFSET 4 ROWS;

---출력된 행의 수를 지정 (4열을 건너뛰고 출력될 열에서 3열까지만 출력하라)
SELECT userID, name, birthYear FROM userTbl
	ORDER BY birthYear
	OFFSET 4 ROWS
	FETCH NEXT 3 ROWS ONLY; --TOP은 OFFSET 쿼리와 같이 쓸 수 없기 때문에 이것을 써야함 


------------------------ SELECT INTO
-- 테이블을 복사해서 사용할 경우
--SELECT 복사할 열 INTO 새로운 테이블명 FROM 기존테이블명 
-- 하지만 PK나 FK 등의 제약 조건은 복사되지 않는다. 

USE sqlDB;
SELECT * INTO buyTbl2 FROM buyTbl; --복사
SELECT * FROM buyTbl2; -- 조회

--일부 열만 복사 가능
SELECT userID, prodName INTO buyTbl3 FROM buyTbl; --복사
SELECT * FROM buyTbl3; -- 조회

------------------------ GROUP BY
-- ORDER BY는 중복된 유저 ID까지 쫙 나열해줌  
USE sqlDB;
SELECT userID, amount FROM buyTbl ORDER BY userID;

--따라서 집계함수인 GROUP BY 함수를 사용함 (집계 함수 필요)
SELECT userID AS [사용자 아이디], SUM(amount) AS[총 구매 개수] FROM buyTbl GROUP BY userID;

--집계 함수 (AVG, MIN, MAX, COUNT, COUNT_BIG(개수를 세고 결과는 bigint형) STDEV(표준편차) VAR(분산)
SELECT AVG(amount) AS[평균 구매 개수] FROM buyTbl; -- 사실 2.9166이다
--따라서
SELECT AVG(amount*1.0) AS[평균 구매 개수] FROM buyTbl; --이렇게 소수점을 곱해주거나
SELECT AVG(CAST(amount AS DECIMAL(10,6))) AS[평균 구매 개수] FROM buyTbl; 
--CAST()/CONVERT()함수를 이용하여 출력 여기서 DECIMAL(10,6)은 전체 10자리 중 소수점 6자리 확보한다는 의미

--가장 큰 키와 가장 작은 키의 회원 이름과 키를 출력하는 쿼리
SELECT name, height FROM userTbl WHERE height = (SELECT MAX(height)FROM userTbl) OR  height = (SELECT MIN(height)FROM userTbl);
SELECT name, height FROM userTbl WHERE height IN ((SELECT MAX(height)FROM userTbl) , (SELECT MIN(height)FROM userTbl));
--같은 의미 

--휴대폰이 있는 사용자의 수 카운트
SELECT COUNT(mobile1)AS[휴대폰이 있는 사용자] FROM userTbl;

--COUNT 성능 알아보기 
--프로파일 실행 후 TSQL_Duration 선택 후 실행
USE AdventureWorks2016CTP3;
GO
SELECT * FROM Sales.Customer; --Duration이 200, 400 넘어감 
GO
SELECT COUNT(*) FROM Sales.Customer; --Duration이 2나 1 밖에 안되는데 
GO

--임시테이블은 #, ## 붙임 

------------------------ Having 
--사용자별 총 구매액 
USE sqlDB;
GO 
SELECT userID AS[사용자], SUM(price*amount) AS [총 구매액]
	FROM buyTbl
	GROUP BY userID;

-- 총 구매액이 1000 이상인 사용자에게만 사은품을 증정할려면?
SELECT userID AS[사용자], SUM(price*amount) AS [총 구매액]
	FROM buyTbl
	WHERE SUM(price*amount) > 1000 --집계함수는 WHERE 쓸 수 없음
	GROUP BY userID;

--따라서...
SELECT userID AS[사용자], SUM(price*amount) AS [총 구매액]
	FROM buyTbl
	GROUP BY userID
	HAVING SUM(price*amount) >1000;

--추가적으로 총 구매액이 적은 사람부터 출력할려면 
--Having 절!
--WHERE과 비슷하게 조건을 제한하는 것이지만 집계함수에 대해서 조건을 제한하는 쿼리문 
SELECT userID AS[사용자], SUM(price*amount) AS [총 구매액]
	FROM buyTbl
	GROUP BY userID
	HAVING SUM(price*amount) >1000
	ORDER BY SUM(price*amount);

------------------------ ROLLUP, GROUPING_ID, CUBE 

--총합 또는 중간합계가 필요하다면 GROUP BY 절과 함께 ROLLUP 또는 CUBE를 사용
SELECT num, groupName, SUM(price*amount) AS [비용]
	FROM buyTbl
	GROUP BY ROLLUP(groupName, num);
-- 중간에 num이 NULL인 것은 각 그룹의 소합계를 의미 또한 맨 마지막 NULL은 총합계를 의미함  

--한눈에 데이터인지 합계인지를 알기 위해서는 GROUPING_ID 함수를 사용하면 된다. 함수의 결과가 0이면 데이터, 1이면 합계
SELECT num, groupName, SUM(price*amount) AS [비용]
	, GROUPING_ID(groupName) AS [추가행 여부]
	FROM buyTbl
	GROUP BY ROLLUP(groupName, num);

--CUBE
USE sqlDB;
CREATE TABLE cubeTbl(prodName NCHAR(3), color NCHAR(2), amount INT);
GO
INSERT INTO cubeTbl	VALUES('컴퓨터', '검정', 11);
INSERT INTO cubeTbl	VALUES('컴퓨터', '파랑', 22);
INSERT INTO cubeTbl	VALUES('모니터', '검정', 33)
INSERT INTO cubeTbl	VALUES('모니터', '파랑', 44);
GO
SELECT prodName, color, SUM(amount) AS [수량합계]
	FROM cubeTbl
	GROUP BY CUBE (color, prodName);
