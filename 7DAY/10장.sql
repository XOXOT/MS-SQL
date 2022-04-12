--10장 

-------트랜잭션

-- 데이터 베이스의 무결성을 위한 것으로 하나의 논리적 작업 단위로 수행되는 일련의 작업 (SQL 묶음)
-- 트랜잭션은 '데이터를 변경시키는 INSERT, UPDATE, DELETE의 묶음'

USE sqlDB;
--아래와 같은 SQL문은 트랜잭션이 1번 나온거처럼 보이지만 3번 나온 것이다.
GO
		UPDATE USERTBL SET ADDR = N'제주' WHERE USERID = N'KBS' -- 김범수
		UPDATE USERTBL SET ADDR = N'제주' WHERE USERID = N'KBS' -- 김범수
		UPDATE USERTBL SET ADDR = N'제주' WHERE USERID = N'KBS' -- 김범수
GO
--따라서 아래와 같이 3개의 트랜잭션을 하나로 묶는 작업이다. 
BEGIN TRAN 
		UPDATE USERTBL SET ADDR = N'제주' WHERE USERID = N'KBS' -- 김범수
		UPDATE USERTBL SET ADDR = N'제주' WHERE USERID = N'KBS' -- 김범수
		UPDATE USERTBL SET ADDR = N'제주' WHERE USERID = N'KBS' -- 김범수
COMMIT TRAN
-- 트랜잭션 로그 파일은 문제 발생 시에 데이터의 무결성을 보장해주는 역할을 한다. 
GO

---- 트랜잭션의 특성
--원자성
--트랜잭션은 분리할 수 없는 하나의 단위로써, 작업이 모두 수행되거나 하나도 수행되지 않아야 한다. 

--일관성
--트랜잭션에서 사용되는 모든 데이터는 일관되어야 한다. 이 일관성은 잠금과 관련이 깊다.

--격리성
-- 현재 트랜잭션에서 접근하고 있는 데이터는 다른 트랜잭션에서 격리되어야 한다는 것을 의미한다.
-- 트랜잭션이 발생되기 이전 상태나 완료된 이후 상태를 볼 수는 있지만, 트랜잭션이 진행 중인 중간 데이터를 볼 수 없다.

--영속성
-- 트랜잭션이 정상적으로 종료된다면 그 결과는 시스템 오류가 발생하더라도 시스템에 영구적으로 적용된다.

--실습
USE tempdb;
CREATE TABLE BankBook
	(uName NVARCHAR(10),
	 uMoney INT,
		CONSTRAINT CK_money
		CHECK (uMoney >=0)
	);
GO
INSERT INTO BankBook VALUES(N'구매자', 1000);
INSERT INTO BankBook VALUES(N'판매자', 0);

--1. 현재 구매작 판매자 계좌로 500원을 송금하려면 우선 구매자 계좌에서 500원을 빼고 판매자 계좌에 더해줌
UPDATE BankBook SET uMoney = uMoney -500 WHERE uName = N'구매자';
UPDATE BankBook SET uMoney = uMoney +500 WHERE uName = N'판매자';
SELECT *FROM BankBook;

-- 위의 쿼리문은 다음과 같은 수행을 했을 것이다. (실행 X)
BEGIN TRAN
	UPDATE BankBook SET uMoney = uMoney -500 WHERE uName = N'구매자';
COMMIT TRAN

BEGIN TRAN
UPDATE BankBook SET uMoney = uMoney +500 WHERE uName = N'판매자';
COMMIT TRAN

--2. 이번에는 구매자가 판매자에게 600원을 송금
UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'구매자';
UPDATE BankBook SET uMoney = uMoney +600 WHERE uName = N'판매자';
SELECT *FROM BankBook;
--구매자 계좌에서 돈이 빠져나가지 않고 판매자 계좌에 600원이 입금되는 대형사고 발생
--이유는 다음과 같다. (실행 X)
BEGIN TRAN
	UPDATE BankBook SET uMoney = uMoney -500 WHERE uName = N'구매자';
	-- 오류가 발생되어 수행이 안됨(현재 트랜잭션인 1번 트랜잭션에 롤백이 일어날 것으로 예상)
COMMIT TRAN

BEGIN TRAN
	UPDATE BankBook SET uMoney = uMoney +500 WHERE uName = N'판매자';
	-- 정상적으로 수행됨
COMMIT TRAN
-- 결국 1번 트랜잭션과 2번 트랜잭션이 서로 관계없이 독립적으로 수행되어 이러한 논리적 오류가 발생된 것

--3. 이러한 경우는 두 개의 UPDATE를 하나의 트랜잭션으로 묶어야 한다. 
-- 먼저 '판매자'의 계좌를 원래대로 만듬
UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'판매자';
-- 두개의 UPDATE를 묶는다.
BEGIN TRAN
	UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'구매자';
	UPDATE BankBook SET uMoney = uMoney +600 WHERE uName = N'판매자';
COMMIT TRAN
SELECT *FROM BankBook; -- 묶어줘도 같은 오류가 발생
-- 왜냐면 제약 조건의 논리적 오류는 롤백이 되지 않기 때문에 제약 조건의 오류 발생 시에 강제로 롤백을 시켜줘야 한다.
-- 즉, 첫 번째 UPDATE에서 구매자 계좌에서 600원을 뺏을 때, 오류가 발생되어 그 행만 실행이 되지 않은 것일 뿐, 롤백이 수행된 것이 아님
-- 다시 '판매자'의 계좌를 원래대로 만듬
UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'판매자';
--TRY CATCH 구문을 이용
BEGIN TRY
	BEGIN TRAN
		UPDATE BankBook SET uMoney = uMoney -600 WHERE uName = N'구매자';
		UPDATE BankBook SET uMoney = uMoney +600 WHERE uName = N'판매자';
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SELECT *FROM BankBook;


--명시적 트랜잭션과 암시적 트랜잭션 
USE tempdb;
--1-1 현재 트랜잭션의 개수를 저장할 테이블 생성
CREATE TABLE testTbl (id int IDENTITY); -- INSERT 테스트용
CREATE TABLE tranTbl (save_id int, tranNum int); -- 트랜잭션 개수를 저장

--1-2 testTbl에 트리거를 생성 (아직 트리거를 배우지 않음)
CREATE TRIGGER trgTranCount
		ON testTbl
		FOR INSERT
	AS
		DECLARE @id int;
		SELECT @id = id FROM inserted;
		INSERT INTO tranTbl VALUES (@id, @@TRANCOUNT);
-- testTbl에 Insert가 발생될 경우 testTbl의 id와 현재 발생된 트랜잭션의 개수(시스템 함수 @@TRANCOUNT)를 tranTbl에 자동으로 저장한다는 의미
 GO
-- 아래 구문을 3번쯤 실행
INSERT INTO testTbl DEFAULT VALUES;
-- 데이터 확인
SELECT *FROM testTbl;
SELECT *FROM tranTbl;
-- 결과를 확인해보면 tranNum이 0이 아니므로, 각 insert를 실행 시마다 트랜잭션이 발생됨을 확인할 수 있다. 즉 자동 커밋 트랜잭션이 사용되고 있다는 의미

---- 명시적 트랜잭션
--1.1
BEGIN TRAN
	PRINT 'BEGIN 안의 트랜잭션 개수==> ' + CAST (@@TRANCOUNT AS CHAR(3));
COMMIT TRAN
PRINT 'COMMIT 후에 트랜잭션 개수==> ' + CAST (@@TRANCOUNT AS CHAR(3));
-- 명시적 트랜잭션에 의해서 트랜잭션이 발생되는 것을 확인할 수 있다.

--1.2 명시적으로 중첩된 트랜잭션을 확인
BEGIN TRAN
	BEGIN TRAN
		PRINT 'BEGIN 2개 안의 트랜잭션 개수==> ' + CAST (@@TRANCOUNT AS CHAR(3));
	COMMIT TRAN
		PRINT 'BEGIN 1개 안의 트랜잭션 개수==> ' + CAST (@@TRANCOUNT AS CHAR(3));
COMMIT TRAN
PRINT 'COMMIT 후에 트랜잭션 개수==> ' + CAST (@@TRANCOUNT AS CHAR(3));

--1.3 롤백을 시켜본다면? SELECT가 어떤 값이 나올지 예상한다면?
CREATE TABLE #tranTest (id int);
INSERT INTO #tranTest VALUES(0);
GO
BEGIN TRAN --1번 트랜잭션
	UPDATE #tranTest SET id =111;
	BEGIN TRAN --2번 트랜잭션
		UPDATE #tranTest SET id =222;
		SELECT *FROM #tranTest;
	ROLLBACK TRAN -- 첫 번째 롤백
		SELECT *FROM #tranTest;
ROLLBACK TRAN -- 두 번째 롤백 (오류)
SELECT *FROM #tranTest;
--롤백은 바로 앞의 트랜잭션까지만 롤백하는 것이 아니라, 모든 트랜잭션을 롤백하기 때문에 두 번째 롤백은 오류

--1.4 만약 원하는 지점까지만 롤백을 하고 싶다면? SAVE TRAN 사용
BEGIN TRAN --1번 트랜잭션
	UPDATE #tranTest SET id =111;
	SAVE TRAN [tranPoint1]
	BEGIN TRAN --2번 트랜잭션
		UPDATE #tranTest SET id =222;
		SELECT *FROM #tranTest;
	ROLLBACK TRAN [tranPoint1] -- 첫 번째 롤백 ([tranPoint1]까지 롤백)
		SELECT *FROM #tranTest;
ROLLBACK TRAN -- 두 번째 롤백 (오류)
SELECT *FROM #tranTest;
GO

---- 암시적 트랜잭션
--2.1 암시적 트랜잭션을 사용하는 설정
SET IMPLICIT_TRANSACTIONS ON;

--2.2 몇개의 문장을 수행
USE tempdb;
CREATE DATABASE tranDB;
GO

USE tranDB;
CREATE TABLE tranTbl (id int); -- 이 순간에 트랜잭션이 시작
GO

INSERT INTO tranTbl VALUES(1);
INSERT INTO tranTbl VALUES(2);

SELECT *FROM tranTbl;

--3.3 새창에서 아래의 쿼리를 실행하면 tranTbl에 작동 중인 트랜잭션이 커밋되지 않아서 계속해서 쿼리를 실행하는 중으로 뜸
USE tranDB;
SELECT *FROM tranTbl;

--3.4 원래의 쿼리창에서 롤백시킴
ROLLBACK TRAN;
-- 그러면 쿼리를 실행하는 중이 오류메시지로 변경되어있는 것을 볼 수 있다.
GO
--3.5 결과 
CREATE TABLE tranTbl (id int); -- 이 순간에 트랜잭션이 시작
GO
INSERT INTO tranTbl VALUES(1);
SELECT @@TRANCOUNT; -- 1
BEGIN TRAN --트랜잭션 1개 추가
		INSERT INTO tranTbl VALUES(2);
		SELECT @@TRANCOUNT; --2
COMMIT TRAN --  -1

SELECT @@TRANCOUNT; -- 1 

BEGIN TRAN --트랜잭션 1개 추가
		INSERT INTO tranTbl VALUES(3);
		SELECT @@TRANCOUNT; --2
ROLLBACK TRAN  --  -2

SELECT @@TRANCOUNT; -- 0
SELECT *FROM tranTbl; -- 이미 롤백되어 없다(오류)
GO
--3.6 다시 자동 커밋 트랜잭션 모드로 변경 
SET IMPLICIT_TRANSACTIONS OFF;
