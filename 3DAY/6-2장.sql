------------------6-2장
---------비재귀적 CTE

--WITH 새로 만들 테이블 명(열 이름, 열이름 , ...) AS (기존 쿼리문 ) SELECT *아니면 선택 후 별명 ORDER BY ~~ 

USE sqlDB;
GO
SELECT userID AS [사용자], SUM(price* amount) AS [총구매액]
	FROM buyTbl GROUP BY userID ORDER BY SUM(price* amount) DESC; 
--이렇게 하면 복잡? 하니까

WITH abc(userID, TOTAL)
AS
(SELECT userID AS [사용자], SUM(price* amount) AS [총구매액]
	FROM buyTbl GROUP BY userID) 
--SELECT *FROM abc ORDER BY TOTAL DESC; --별명을 붙이고 싶다면 아래와 같이 맨 밑의 SELECT 함수에서 별명을 붙여줌
SELECT userID AS [사용자],TOTAL AS [총구매액] FROM abc ORDER BY TOTAL DESC;

-- 각 지역 별로 가장 큰 키를 한명씩 뽑은 후 그 사람들의 키의 평균 구하기

--1. 각 지역 별로 가장 큰 키를 뽑는 쿼리
SELECT addr, MAX(height) FROM userTbl GROUP BY addr;

--2. 위의 쿼리문을 WITH문으로 바꾸기 
WITH cte_table(addr, maxHeight)
AS
(SELECT addr, MAX(height) FROM userTbl GROUP BY addr);

--3. 키의 평균을 구하는 쿼리 작성
SELECT AVG(maxHeight) FROM cte_table;

--4. 2단계와 3단계 쿼리 합치기 (평균을 실수로 만들기 위해 1.0 곱함)
WITH cte_table(addr, maxHeight)
AS
(SELECT addr, MAX(height) FROM userTbl GROUP BY addr)
SELECT AVG(maxHeight*1.0) AS [각 지역별 최고키의 평균] FROM cte_table;
-- CTE와 파생 테이블은 구문이 끝나면 같이 소멸함

----중복 CTE

--WITH AAA(컬럼들) AS (AAA의 쿼리문), BBB(컬럼들) AS (BBB의 쿼리문), CCC(컬럼들) AS (CCC의 쿼리문) SELECT * FROM [AAA 또는 BBB 또는 CCC]
--CCC쿼리문에서는 AAA나 BBB를 참조할 수 있지만 AAA나 BBB는 CCC 쿼리문을 참조할 수 없다.
WITH 
AAA(userID, total) 
	AS 
	(SELECT userID, SUM(price*amount) FROM buyTbl GROUP BY userID), --USER ID에 따른 총 구매액 테이블 
BBB(sumtotal) 
	AS 
	(SELECT SUM(total) FROM AAA), --ID와 상관없이 전체 총 구매액 
CCC(sumavg) 
	AS 
	(SELECT sumtotal / (SELECT count(*) FROM buyTbl) FROM BBB) -- 총 구매액의 평균 
SELECT * FROM CCC; 

---------재귀적 CTE
-- 재귀적이란 자기자신을 반복적으로 호출한다는 의미를 내포. 
-- 가장 많은 재귀적인 예는 회사의 부서장과 직원의 관계
--형식
--WITH CTE_테이블이름(열이름) AS (<쿼리문1: SELECT * FROM 테이블A> UNION ALL <쿼리문2 : SELECT * FROM 테이블A JOIN CTE_테이블 이름>) SELECT * FROM CTE_테이블이름;
--<쿼리문1>을 앵커 멤버
--<쿼리문2>를 재귀 멤버
--1. <쿼리문1>을 실행하면 전체 흐름의 최초 호출에 해당 그리고 레벨의 시작은 0으로 초기화
--2. <쿼리문2>를 실행하면 레벨+1로 증가시키고 SELECT의 결과가 빈 것이 아니라면 'CTE_테이블이름'을 다시 재귀적으로 호출
--3. 2번을 계속 반복하고 SELECT의 결과가 아무 것도 없다면 재귀적인 호출을 중단시킴
--4. 외부의 SELECT 문을 실행해서 앞 단계에서 누적된 결과(UNION ALL)를 가져온다. 

-----실습 
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

WITH empCTE(empName, mgrName, dept, level)
AS
(
 SELECT emp, manager, department, 0
	FROM empTbl
	WHERE manager IS NULL -- 상관이 없는 사람이 바로 사장 (앵커멤버)
 UNION ALL
 SELECT empTbl.emp, empTbl.manager, empTbl.department, empCTE.level+1
  FROM empTbl INNER JOIN empCTE -- empName, mgrName이 일치하는 것끼리 level화 
	  ON empTbl.manager = empCTE.empName 
)
SELECT * FROM empCTE ORDER BY dept, level;

----트리화 

WITH empCTE(empName, mgrName, dept, level)
AS
(
 SELECT emp, manager, department, 0
	FROM empTbl
	WHERE manager IS NULL -- 상관이 없는 사람이 바로 사장 (앵커멤버)
 UNION ALL
 SELECT empTbl.emp, empTbl.manager, empTbl.department, empCTE.level+1
  FROM empTbl INNER JOIN empCTE -- empName, mgrName이 일치하는 것끼리 level화 
	  ON empTbl.manager = empCTE.empName 
)
SELECT REPLICATE(' ㄴ',level) + empName AS [직원이름], dept [직원부서]  --REPLICATE(문자, 개수) 함수는 해당 문자를 개수만 큼 반복 즉, LEVEL 갯수만큼 ㄴ을 반복
  FROM empCTE ORDER BY dept, level; 

-- 사원급을 제외한 부장/차장/과장 급만 출력
WITH empCTE(empName, mgrName, dept, level)
AS
(
 SELECT emp, manager, department, 0
	FROM empTbl
	WHERE manager IS NULL 
 UNION ALL
 SELECT empTbl.emp, empTbl.manager, empTbl.department, empCTE.level+1
  FROM empTbl INNER JOIN empCTE 
	  ON empTbl.manager = empCTE.empName 
	WHERE level < 2 --간단히 WHERE문을 이용해 레벨 2보다 작은 레벨만 출력
)
SELECT REPLICATE(' ㄴ',level) + empName AS [직원이름], dept [직원부서]  
  FROM empCTE ORDER BY dept, level; 



------------INSERT
-- INSERT [INTO] <테이블 [(열1, 열2, ...)] VALUES (값1, 값2, ...)
-- WITH CTE_테이블명()... INSERT [INTO] <CTE_테이블명> ...

USE tempdb;
CREATE TABLE testTbl1 (id int, userName nchar(3), age int);
GO
INSERT INTO testTbl1 VALUES (1, '홍길동', 25);

--만약 ID와 이름만 입력하고 나이를 입력하고 싶지 않다면? 제한을 주고 넣으면 됨
INSERT INTO testTbl1(id,userName) VALUES (2, '설현');

--만약 순서를 바꿔서 입력하고 싶다면? 열이름을 입력할 순서에 맞춰 나열하면 됨
INSERT INTO testTbl1(userName,age,id) VALUES ('초아', 26, 3);

-------------자동으로 증가하는 IDENTITY
--IDENTITY는 자동으로 1부터 증가하는 값을 입력해준다. 
--DEFAULT 값을 설정해주면 설정해준 값이 들어감 
USE tempdb;
CREATE TABLE testTbl2
(id int IDENTITY,
 userName nchar(3),
 age int,
 nation nchar(4) DEFAULT '대한민국');
GO
INSERT INTO testTbl2 VALUES ('지민', 25, DEFAULT);

--강제로 IDENTITY 값을 입력하고 싶다면?
SET IDENTITY_INSERT testTbl2 ON;
GO
INSERT INTO testTbl2(id,userName,age,nation) VALUES (11, '쯔위', 18, '대만');

-- IDENTITY_INSERT를 ON으로 변경한 테이블은 꼭 입력할 열을 명시적으로 지정해야함
INSERT INTO testTbl2 VALUES (12, '사나', 20, '일본'); --오류

-- IDENTITY_INSERT를 OFF로 변경하고 입력하면, ID값은 최대값 + 1부터 자동 입력
SET IDENTITY_INSERT testTbl2 OFF;
GO
INSERT INTO testTbl2 VALUES ('미나', 21, '일본');
SELECT* FROM testTbl2;

--열의 이름을 까먹었을 때는? 
EXECUTE sp_help testTbl2;

--특정 테이블에 설정된 IDENTITY 값을 확인하려면?
SELECT IDENT_CURRENT('testTbl2'); -- 마지막 IDENTITY 값
SELECT @@IDENTITY; --가장 최근에 생성된 ID 값

-------------SEQUENCE 

USE tempdb;
CREATE TABLE testTbl3
(id int,
 userName nchar(3),
 age int,
 nation nchar(4) DEFAULT '대한민국');
 GO

CREATE SEQUENCE idSEQ
	START WITH 1 --시작값
	INCREMENT BY 1; --증가값
GO

INSERT INTO testTbl3 VALUES (NEXT VALUE FOR idSEQ, '지민', 25, DEFAULT);

--SEQUENCE에서 강제로 ID열에 다른 값을 입력하고 싶다면?
INSERT INTO testTbl3 VALUES (11, '쯔위', 18, '대만');
GO
ALTER SEQUENCE idSEQ
	RESTART WITH 12; -- 시작 값을 다시 설정 
GO
INSERT INTO testTbl3 VALUES (NEXT VALUE FOR idSEQ,'미나', 21, '일본');
SELECT* FROM testTbl3;

--시퀸스를 활용하면 특정 범위의 값을 계속해서 반복해서 입력할 수 있다. 
--EX)100, 200, 300 반복 
CREATE TABLE testTbl4 (id int);
GO
CREATE SEQUENCE cycleSEQ
	START WITH 100
	INCREMENT BY 100
	MINVALUE 100 -- 최소값
	MAXVALUE 300 -- 최대값 
	CYCLE;		 -- 반복설정
GO
INSERT INTO testTbl4 VALUES (NEXT VALUE FOR cycleSEQ);
INSERT INTO testTbl4 VALUES (NEXT VALUE FOR cycleSEQ);
INSERT INTO testTbl4 VALUES (NEXT VALUE FOR cycleSEQ);
INSERT INTO testTbl4 VALUES (NEXT VALUE FOR cycleSEQ);
GO 
SELECT* FROM testTbl4;
 
--시퀸스를 DEFAULT와 함께 사용하면 IDENTITY와 마찬가지로 값이 표기를 생략해도 자동으로 입력하게 할 수 있다.
CREATE SEQUENCE autoSEQ
	START WITH 1
	INCREMENT BY 1;
GO
CREATE TABLE testTbl5 (id int DEFAULT(NEXT VALUE FOR autoSEQ), userName nchar(3));
GO
INSERT INTO testTbl5(userName) VALUES ('지민');
INSERT INTO testTbl5(userName) VALUES ('쯔위');
INSERT INTO testTbl5(userName) VALUES ('미나');
INSERT INTO testTbl5(userName) VALUES ('설현'),('홍길동'),('아이린'); -- SQL 2008부터 이렇게 3건의 데이터를 한 문장으로 입력할 수 있다.  
GO
SELECT* FROM testTbl5;
GO

------------------대량의 샘플데이터 생성
-- INSERT INTO 테이블이름(열이름1, 열이름2) SELECT 문;
USE tempdb;
CREATE TABLE testTbl6 (id int, Fname nvarchar(50), Lname nvarchar(50));
GO
INSERT INTO testTbl6
  SELECT BusinessEntityID, FirstName, LastName
	FROM AdventureWorks2016CTP3.Person.Person;

-- 테이블 정의까지 생략하고 싶다면 SELECT INTO 구문을 이용
USE tempdb;
SELECT BusinessEntityID AS id, FirstName AS Fname, LastName AS Lname -- AS로 바로 별명 붙여줌 
	INTO testTbl7
	FROM AdventureWorks2016CTP3.Person.Person;
GO

------------------UPDATE
--UPDATE 테이블이름 SET 열1 = 값1, 열2 = 값2 .. WHERE 조건;

UPDATE testTbl6
	SET Lname = '없음'
	WHERE Fname = 'Kim';
-- 10개의 행이 영향을 받았는데 WHERE 문을 빼먹고 실행하면 전체 행의 Lname이 모두 없음으로 변경된다. 주의

-- 가끔 전체 테이블의 내용을 변경하고 싶을 때 WHERE를 생략할 수 있는데, 예를 들어 구매 테이블에서 현재의 단가가 모두 1.5배 인상되었다면
USE sqlDB;
UPDATE buyTbl SET price = price * 1.5;
GO

------------------DELETE 
-- DELETE 테이블 이름 WHERE 조건; //WHERE문이 생략되면 전체 테이블이 삭제된다. 
USE tempdb;
DELETE testTbl6 WHERE Fname = 'Kim';

--상위 몇개만 삭제할려면? -- TOP()쓰면 된다. 
USE tempdb;
DELETE TOP(5) testTbl6 WHERE Fname = 'Kim';

--삭제 비교
USE tempdb;
SELECT * INTO bigTbl1 FROM AdventureWorks2016CTP3.Sales.SalesOrderDetail;
SELECT * INTO bigTbl2 FROM AdventureWorks2016CTP3.Sales.SalesOrderDetail;
SELECT * INTO bigTbl3 FROM AdventureWorks2016CTP3.Sales.SalesOrderDetail;
GO

DELETE FROM bigTbl1;
GO
DROP TABLE bigTbl2; -- 젤 빠르고 테이블 자체가 필요 없을 경우 DROP으로 삭제
GO
TRUNCATE TABLE bigTbl3; -- 그 다음으로 빠른 것으로 테이블의 구조는 남겨놓고 싶을 때 TRUNCATE로 삭제
GO

------------------조건부 데이터 변경 MERGE
-- 경우(조건)에 따라서 INSERT, UPDATE, DELETE를 수행
-- 중요한 테이블에서 실수하면 안되니 INSERT, UPDATE, DELETE를 직접 사용하면 안됨. 
-- 그래서 회원의 가입, 변경, 탈퇴가 생기면 변경테이블에 INSERT 문으로 회원의 변경사항을 입력 (변경사항은 신규가입, 주소변경, 회원탈퇴)
-- 변경 테이블의 쌓인 내용은 1주일마다 MERGE 구문을 이용해서 변경테이블이 신규가입이면 멤버 테이블에 새로 등록, 주소변경이면 멤버 테이블에 주소 변경, 탈퇴면 회원삭제

--1. 멤버테이블 정의 및 데이터 입력
USE sqlDB;
SELECT userID, name, addr INTO memberTBL FROM userTbl;
SELECT * FROM memberTBL;

--2. 변경테이블을 정의/ 1명의 신규가입, 2명의 주소변경, 2명의 회원탈퇴
CREATE TABLE changeTBL
(changeType NCHAR(4), --변경 사유
 userID     CHAR(8),
 name       NVARCHAR(10),
 addr		NCHAR(2));
 GO
 INSERT INTO changeTBL VALUES
('신규가입', 'CHO', '초아', '미국'),
('주소변경', 'LSG', NULL, '제주'),
('주소변경', 'LJB', NULL, '영국'),
('회원탈퇴', 'BBK', NULL, NULL),
('회원탈퇴', 'SSK', NULL, NULL);

--3. 일주일이 지났다고 가정하고, 변경사유 열에 의해서 기존 멤버테이블의 데이터를 변경 
MERGE memberTBL AS M -- 변경될 테이블(TARGET 테이블)
 USING changeTBL AS C -- 변경할 기준이 되는 테이블 (SOURCE 테이블)
 ON M.userID = C.userID -- USERID을 기준으로 두 테이블을 비교
 -- TARGET 테이블에 SOURCE 테이블의 행이 없고, 사유가 신규가입이라면 새로운 행을 추가한다.
 WHEN NOT MATCHED AND changeType = '신규가입' THEN
	INSERT (userID, name, addr) VALUES(C.userID, C.name, C.addr)
-- TARGET 테이블에 SOURCE 테이블의 행이 있고, 사유가 주소변경이라면 주소를 변경한다.
 WHEN MATCHED AND changeType = '주소변경' THEN
	UPDATE SET M.addr = C.addr
-- TARGET 테이블에 SOURCE 테이블의 행이 있고, 사유가 회원탈퇴라면 행을 삭제한다.
 WHEN MATCHED AND changeType = '회원탈퇴' THEN
	DELETE;
GO
SELECT *FROM memberTBL;

--MERGE 변경될 테이블 AS 별명 USING 변경할 기준 테이블 AS 별명 ON 변경될 테이블 별명.비교할 컬럼명 = 변경 기준 테이블 별명.컬럼명
--WHEN NOT MATCHED 이거나 MATCHED AND 조건문 THEN INSERT/UPDATE/DELETE  
