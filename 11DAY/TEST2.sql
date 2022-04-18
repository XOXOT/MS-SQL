--TEST03

-- 1.
--hr.dept 테이블 기반으로 hr.dept_temp 테이블을 생성하세요.
--그리고, hr.dept_temp 데이터를 대상으로 OPERATIONS 부서(dname)의 
--위치를 SEOUL 로 변경하세요. (loc)
--단, 변경시 Sub Query 를 사용하세요.

USE testDB;
GO
SELECT *INTO hr.dept_temp FROM hr.dept
GO
SELECT *FROM HR.dept_temp
GO
--일반
UPDATE hr.dept_temp SET loc = 'BOSTON' WHERE dname = 'OPERATIONS';
GO
--서브쿼리
UPDATE hr.dept_temp SET loc =  'SEOUL' WHERE dname = (SELECT dname FROM hr.dept_temp WHERE dname = 'OPERATIONS');
GO

--2. 
--hr.emp 테이블 기반으로 hr.emp_temp 테이블을 생성하세요.
--그리고, 급여가 1등급인 사원 정보만 입력되도록 하세요.
--hr.emp_temp 데이터를 대상으로 급여 등급이 1등급이며, 
--부서 번호가 30번인 사원 정보를 삭제하도록 하세요. 
--단, 삭제시 Sub Query 를 사용하세요.
USE testDB;
GO
SELECT *INTO hr.emp_temp FROM hr.emp E, hr.salgrade S WHERE S.grade = 1 AND e.sal BETWEEN s.losal AND s.hisal
GO
SELECT *FROM hr.emp_temp --급여가 1등급인 총 3개의 사원이 출력 
GO
--일반
DELETE FROM hr.emp_temp WHERE deptno = 30
GO
--서브쿼리 
DELETE FROM hr.emp_temp WHERE deptno = (SELECT deptno FROM hr.emp_temp WHERE deptno = 30);
GO

--3. 
--세후 급여를 계산하는 함수를 hr 스키마에 생성하세요.
--세금은 일괄적으로 5% 로 계산하세요.
--그리고, 생성된 함수를 사용하여 전 사원의 세전 과 세후를 
--확인할 수 있도록 출력하세요.

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
--hr.emp_temp 에 트리거를 추가하세요.
--트리거의 기능은 토, 일 요일에 insert, update, delete 에 대한
--DML 이벤트가 발생할 경우 
--주말에서 등록, 수정, 삭제 할 수 없습니다.' 메시지를 출력하며,
--트랜잭션이 취소가 되도록 하세요.

-- 날짜 지정법
SELECT DATENAME(WEEKDAY,GETDATE()) -- "일요일", "토요일"
SELECT DATEPART(WEEKDAY,GETDATE()) -- 1(일요일), 7(토요일)
GO

CREATE TRIGGER CHK_EMP_DML
ON  hr.emp_temp 
AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	IF DATEPART(WEEKDAY,GETDATE()) = 1
		BEGIN 
		RAISERROR('주말이라 등록, 수정, 삭제 할 수 없습니다.',10,1)
		ROLLBACK TRAN;
		END
	ELSE IF DATEPART(WEEKDAY,GETDATE()) = 7
		BEGIN
		RAISERROR('주말이라 등록, 수정, 삭제 할 수 없습니다.',10,1)
		ROLLBACK TRAN;
		END
END
GO
UPDATE hr.emp_temp SET sal = '800' WHERE ename = 'SMITH'; --업데이트 확인
UPDATE hr.emp_temp SET sal = '900' WHERE ename = 'SMITH'; --업데이트 확인
SELECT *FROM hr.emp_temp -- 주말이면 변경되지 않음 
GO

-------------- 프로시저
--1. 
--문제의 요구사항을 확인 후, 프로시저를 작성하세요.
--문제에서 사용할 테이블은 아래와 같습니다.CREATE TABLE T매출 
(
 일자 nvarchar(8), 제품 nvarchar(30), 수량 int default 0, primary key (일자, 제품)
)
GO
INSERT INTO T매출(일자, 제품, 수량) VALUES ('20200101', 'A1', 10), ('20200102', 'A2', 20)
GO
--아래는 요구사항입니다.
--update, delete 를 하나의 트랜잭션으로 관리합니다.
--각 DML 문장의 성공 결과는 시스템 변수를 확인합니다.
--참조할 시스템 변수는 @@ERROR, @@ROWCOUNT이고, 트랜잭션의 완료와 취소는 아래를 참고하세요.
--@@ERROR <> 0 또는 @@ROWCOUNT <> 1 아니면 모두 취소이고, 그외는 모두 완료가 되도록 합니다.
--트랜잭션이 완료 또는 취소 후의 데이터를 출력합니다.
--T매출 테이블에 대한 update 문장의 실행 조건입니다.
--조건의 일자, 제품은 각각 '20200101', 'A1' 입니다.
--T매출 테이블에 대한 delete 문장의 실행 조건입니다.
--조건의 일자, 제품은 각각 '20200105', 'A5' 입니다.

--2. 
--문제의 요구사항을 확인 후, 프로시저를 작성하세요.
--문제에서 사용할 임시 로컬 테이블은 아래와 같습니다.
--프로시저의 실행 결과는 제품 코드 상향식으로. 
CREATE TABLE #T제품 
(
제품코드 NVARCHAR(30) ,제품명 NVARCHAR(30)
)
GO
INSERT INTO #T제품 (제품코드, 제품명)
VALUES ('A2', '당근') , ('A1', '사과'), ('A4', '레몬'),
('A3', '포도'), ('A5', '양파'), ('A9', '상추'),
('A7', '감자'), ('A6', '고추') ,('A8', '버섯')
GO
SELECT *FROM #T제품 ORDER BY 제품코드 

--3. 
--문제의 요구사항을 확인 후, 프로시저를 작성하세요.
--아래의 프로시저는 커서를 사용하고 있습니다.
--아래의 코드에서 커서를 사용하지 않고 동일하게 실행이 되도록 
--새로운 프로시저를 작성하세요.--대용량 데이터일 경우 서버의 성능 문제로 가능하면 커서를 사용하지 말자는 의미의 문제CREATE PROCEDURE SP_CURSOR
AS
BEGIN
 CREATE TABLE #T작업1 (
 코드 NVARCHAR(10)
 ,수량 NUMERIC(18,0)
 )
 INSERT INTO #T작업1 (코드, 수량) 
 VALUES ('A1', 10), ('A2', 20), ('A3', 30)

 DECLARE 커서1 CURSOR FOR
 SELECT A.코드, A.수량
 FROM #T작업1 A
 WHERE A.코드 < 'A3'
 ORDER BY 수량 DESC 

 OPEN 커서1;

 DECLARE @커서1_코드 NVARCHAR(10)
 ,@커서1_수량 NUMERIC(18,0)
 
 WHILE (1 = 1) BEGIN
 FETCH NEXT FROM 커서1 INTO @커서1_코드, @커서1_수량
 IF @@FETCH_STATUS <> 0 BREAK
 SELECT 코드 = @커서1_코드,
 수량 = @커서1_수량
 END; 
 
 CLOSE 커서1
 DEALLOCATE 커서1
 
 DROP TABLE #T작업1 
END

--4. 
--문제의 요구사항을 확인 후, 프로시저를 작성하세요.
--문제에서 사용할 임시 로컬 테이블은 아래와 같습니다.
--아래는 프로시저를 실행하여 특정 기간의 재고 수불 정보를 조회
--한 결과입니다. 재고수불 조회 검색 조건은 다음과 같습니다.
--수불 검색 시작일 : 20200101
--수불 검색 종료일 : 20200131--기초 수량은 수불 검색 시작일 이전의 매입 및 매출 데이터를 집계
--해서 출력하면 됩니다.
--기말 수량은 기초수량, 매입수량, 매출수량이 모두 집계가 된 후
--최종적으로 기말수량 = 기초수량 + 매입수량 - 매출수량으로 
--계산이 되도록 하면 됩니다.

CREATE TABLE #제품 (
 제품코드 NVARCHAR(20),
 제품명 NVARCHAR(20) 
 )
 INSERT INTO #제품 (제품코드, 제품명)
 VALUES ('A','사과'), ('B','포도'), ('C','딸기'),
 ('D','수박'), ('E','참외')
 
 CREATE TABLE #매입 (
 제품코드 NVARCHAR(20),
 매입일자 NVARCHAR(20),
 매입수량 NUMERIC(18,0)
 )
 INSERT INTO #매입 (제품코드, 매입일자, 매입수량)
 VALUES ('A', '20191201', 100), ('A', '20200103', 200), 
 ('B', '20200201', 300), ('C', '20200105', 400),
 ('D', '20200107', 500) 
 CREATE TABLE #매출 (
 제품코드 NVARCHAR(20),
 매출일자 NVARCHAR(20),
 매출수량 NUMERIC(18,0)
 )
 INSERT INTO #매출 (제품코드, 매출일자, 매출수량)
 VALUES ('A', '20191220', 10), ('A', '20200103', 20), 
 ('B', '20200305', 30), ('B', '20200217', 40),
 ('C', '20200220', 50) 