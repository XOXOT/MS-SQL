------------13장 트리거

-- 트리거는 테이블 또는 뷰와 관련되어 DML 문(INSERT / UPDATE / DELETE 등)의 이벤트가 발생될 때 작동하는 데이터베이스 개체
-- 테이블 또는 뷰에 부착되는 프로그램 코드라고 봐도 무방 
-- 저장 프로시저와 거의 비슷한 문법
-- 트리거가 부착된 테이블에 이벤트(입력, 수정, 삭제)가 발생되면 자동으로 부착된 트리거가 실행
-- 저장 프로시저와 거의 비슷하지만 직접 실행시킬 수 없고 오직 해당 테이블이나 뷰에 이벤트가 발생되면 실행
-- 저장 프로시저와 달리 매개변수를 지정하거나 반환값(RETURN)을 사용할 수도 없다

--실습 1
-- 간단한 트리거 생성

--1-1. TEMPDB에 간단한 테이블 생성
USE tempdb;
CREATE TABLE testTbl (id INT, txt NVARCHAR(5));
GO
INSERT INTO testTbl VALUES(1, N'원더걸스');
INSERT INTO testTbl VALUES(2, N'애프터스쿨');
INSERT INTO testTbl VALUES(3, N'에이오에이');
GO

--1-2. testTbl에 트리거 부착
CREATE TRIGGER testTrg --트리거 이름
ON testTbl -- 트리거를 부착할 테이블
AFTER DELETE, UPDATE -- 삭제, 수정 후에 작동하도록 설정
AS
	PRINT(N'트리거가 작동했습니다');
GO

--1-3. 데이터를 삽입, 수정, 삭제 (한 줄씩 선택하여 실행)
INSERT INTO testTbl VALUES(4,N'나인뮤지스');

UPDATE testTbl SET txt = N'에이핑크' WHERE id = 3;

DELETE testTbl WHERE id = 4;

--트리거가 부착된 테이블에 INSERT가 수행되면 1개의 행이 영향을 받음이라는 메시지만 나오지만
-- UPDATE와 DELETE가 수행되자 자동으로 트리거가 지정한 SQL 문인 PRINT도 실행하는 것을 확인 가능하다.
GO


-------------트리거 종류
--트리거(정확히 DML 트리거)는 아래와 같이 구분 가능하다. 

--AFTER 트리거
-- 테이블에 INSERT / UPDATE / DELETE 등의 작업이 일어났을 때 작동하는 트리거 
-- 테이블에서만 작동함 

-- 실습
--1. 회원 테이블에 update나 insert를 시도하면, 수정 또는 삭제된 데이터를 별도의 테이블에 보관하고 변경된 일자와 변경한 사람을 기록

--1-1. 복원
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

--1-2. update나 insert를 시도하면, 변경되기 전의 데이터를 저장할 테이블 하나 생성 
USE sqlDB;
DROP TABLE buyTbl; -- 구매테이블은 실습에 필요없으므로 삭제
CREATE TABLE backup_userTbl
(	userID char(8) NOT NULL PRIMARY KEY,
	name nvarchar (10) NOT NULL,
	birthYear int NOT NULL,
	addr nchar (2) NOT NULL,
	mobile1 char(3),
	mobile2 char(8),
	height smallint,
	mDate date,
	modType nchar(2), --변경된 타입. '수정' 또는 '삭제'
	modDate date, --변경된 날짜 
	modUser nvarchar(256) -- 변경한 사용자
)
GO

--1-3. 변경 또는 삭제가 발생했을 때 작동하는 트리거를 userTbl에 부착
CREATE TRIGGER trg_BackupUserTbl --트리거 이름
ON userTbl -- 트리거를 부착할 테이블
AFTER UPDATE,DELETE -- 삭제, 수정 후에 작동하도록 지정
AS
	DECLARE @modType NCHAR(2) --변경 타입
	IF (COLUMNS_UPDATED() > 0) -- 업데이트 되었다면
		BEGIN
			SET @modType = N'수정'
		END
	ELSE -- 삭제되었다면
			BEGIN
					SET @modType = N'삭제'
			END

	--delete 테이블의 내용(변경전의 내용)을 백업테이블에 삽입
INSERT INTO backup_userTbl
		SELECT userID, name, birthYear, addr, mobile1, mobile2,
				height, mDate, @modType, GETDATE(), USER_NAME() FROM deleted;
-- 여기서 마지막 행에 deleted 테이블이 나왔는데 UPDATE 또는 DELETE가 수행되기 전의 데이터가 잠깐 저장되어 있는 임시 테이블이라고 생각
GO

--1.4 데이터 업데이트 및 삭제
UPDATE userTbl SET addr = N'몽고' WHERE userID = 'JKW';
DELETE userTbl WHERE height >= 177;
GO

--1.5 당연히 USERTBL에는 수정이나 삭제가 적용되었을 것이다. 방금 수정 또는 삭제된 내용이 잘 보관되어 있는지 확인 
SELECT *FROM backup_userTbl;
GO

--1-6 이번에는 DELETE 대신 TRUNCATE TABLE 문으로 작성(TRUNCATE TABLE 테이블이름 구문은 DELETE TABLE 테이블이름과 동일한 효과)
TRUNCATE TABLE userTbl;
GO

--1-7 백업 테이블 확인
SELECT *FROM backup_userTbl; --변경 없음 
-- 백업 테이블에 삭제된 내용이 들어가지 않았다. 이유는 TRUNCATE TABLE로 삭제 시에는 트리거가 작동하지 않기 때문이다. 
GO

--1-8 userTbl에 절대 새로운 데이터가 입력되지 못하도록 설정하고 만약 누군가 수정이나 삭제를 시도하면 경고 메시지를 출력
CREATE TRIGGER trg_insertUserTbl
ON userTbl
AFTER INSERT -- 삽입 후에 작동하도록 지정
AS
RAISERROR(N'데이터의 입력을 시도했습니다.', 10, 1)
RAISERROR(N'귀하의 정보가 서버에 기록되었습니다.' ,10,1)
RAISERROR(N'그리고 입력한 데이터는 적용되지 않았습니다.' ,10,1)
ROLLBACK TRAN;
-- RAISERROR은 오류를 강제로 발생시키는 함수 그리고 ROLLBACK TRAN을 만나면 사용자가 시도한 INSERT는 롤백되어 테이블 적용X
GO

--1-9 데이터를 입력해보자
INSERT INTO userTbl VALUES (N'ABC', N'에비씨', 1977, N'서울', N'011', N'1111111', 181,'2019-12-25');
-- 오류 메시지가 출력되고 롤백된다. 
GO

----트리거가 생성하는 임시 테이블 
	-- 트리거에서 INSERT / UPDATE / DELETE 작업이 수행되면 임시로사용되는 시스템 테이블이 두개 있는데 INSERTED / DELETED이다
	-- 이 두 테이블은 사용자가 임의로 변경 작업을 할 수는 없고 단지 참조만 할 수 있다. 
	-- INSERT는 INSERTED 테이블에 1개 DELETE는 DELETED 테이블에 1개 저장하지만
	-- UPDATESMS 두개의 테이블 모두 저장하므로 가장 성능이 나쁨 
	-- INSERTED / DELETED 테이블은 임시 테이블이라 트리거가 종료되면 자동 소멸됨
GO


--INSTEAD OF 트리거 (BEFORE 트리거)
	-- AFTER 트리거는 테이블에 이벤트가 작동한 후에 실행되지만, INSTEAD OF 트리거는 이벤트가 발생하기 전에 작동하는 트리거
	-- 뷰와 테이블 모두 작동
	-- 주로 뷰 업데이트가 가능하도록 할 때 사용
	-- INSTEAD OF 트리거가 작동을 시작하면 INSERT / UPDATE / DELETE 문은 무시되므로 주의해야함
	-- 즉, 해당 INSERT / UPDATE / DELETE 대신에 INSTEAD OF 트리거가 작동하는 것

-- 택배회사가 있으면 고객테이블과 구매테이블의 정보를 조합해서 배송 정보 뷰를 생성한다면 이 배송 정보 뷰는 배송 담당자가 태블릿PC를 
-- 이용해서 배송시에 조회하게 될 것이다. 그런데 배송 담당자가 해당 고객에게 물건을 배송할 때, 가끔은 고객이 직접 배송담당자에게
-- 새로운 주문을 요청하는 경우가 발생한다. 그럴 때 현장에서 직접 태블릿PC를 이용해서 배송 정보 뷰에 새로운 고객 정보 및 구매 정보를 입력해야한다. 

--- 실습2 
-- INSTEAD OF 트리거 실습 

--2-1. 복원
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

--2-2. 배송정보 뷰를 생성 
USE sqlDB;
GO
CREATE VIEW uv_deliver --배송정보를 위한 뷰
AS
	SELECT b.userid, u.name, b.prodName, b.price, b.amount, u.addr
	FROM buyTbl b
		INNER JOIN userTbl u
		ON b.userid = u.userid;
GO
--2-3. 배송 담당자는 배송 시 계속 배송 정보 뷰를 확인하면서 배송
--2-3-1. 배송 담당자가 사용할 배송 정보 뷰를 확인 
SELECT *FROM uv_deliver;
GO

--2-3-2. 새로운 고객 '존밴이'에게 주문 요청을 받았다. 배송 정보 뷰에 주문사항을 입력
INSERT INTO uv_deliver VALUES ('JBI', N'존밴이', N'구두', 50,1,N'인천');
-- 배송 정보 뷰는 복합 뷰이기 때문에 데이터를 입력할 수 없다. 이럴 때 배송 정보 뷰에 INSTEAD OF 트리거를 부착해서 해결
GO

--2-4. 배송정보 뷰에 INSTEAD OF 트리거 생성
--2-4-1 배송 정보 뷰에 입력되는 정보 중에서 고객 테이블과 구매 테이블에 입력될 것을 분리해서 입력하도록 지정 
CREATE TRIGGER trg_insert
ON uv_deliver
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO userTbl(userid, name, birthYear, addr, mDate)
		SELECT userid, name, 1900 , addr, GETDATE() FROM inserted
	INSERT INTO buyTbl(userid, prodName, price, amount)
		SELECT userid, prodName, price, amount FROM inserted
END;
-- uv_deliver 뷰에 INSERT가 시도되면 우선 INSERT되는 내용이 INSERTED 테이블에 입력된다. 
-- 그러므로 INSERTED 테이블의 내용에서 각각 필요한 내용을 고객 테이블과 구매 테이블에서 분리해서 입력하면 되는 것이다
-- 원래 uv_deliver 뷰에서 수행된 INSERT 구문은 무시된다. 
GO

--2-4-2 다시 존밴이에게 받은 주문을 입력
INSERT INTO uv_deliver VALUES ('JBI', N'존밴이', N'구두', 50,1,N'인천');
GO

--2-4-3 각 테이블에 데이터가 잘 입력되어있는지 확인
SELECT *FROM userTbl WHERE userID = 'JBI';
SELECT *FROM buyTbl WHERE userID = 'JBI';
-- 정상적으로 트리거 작동
-- INSTEAD OF 트리거를 활용하면 데이터 삽입 및 수정이 불가능한 복합 뷰를 업데이트 가능한 뷰로 변경할 수 있다.
GO

--2-5. 생성된 트리거의 정보를 확인
EXEC sp_helptrigger uv_deliver;
-- ISINSERT / ISUPDATE / ISDELETE는 INSERT / UPDATE / DELETE 트리거 여부를 확인한다. 값이 1이면 설정된 것이다.
-- 이 TRG_INSERT 트리거는 INSERT 트리거이면서, INSTEAD OF 트리거임을 확인할 수 있다. 
GO

--2-5-1. 해당 트리거 내용 확인
EXEC sp_helptext trg_insert;
GO

--2-6. 트리거 변경
--2-6-1. 트리거의 내용을 변경하려면 ALTER TRIGGER 

--2-6-2. 트리거의 이름을 변경하려면 sp_rename 시스템 저장 프로시저를 사용
EXEC sp_rename 'dbo.trg_insert', 'dbo.trg_uvInsert'
GO

--2-6-3. 트리거를 삭제하려면 DROP TRIGGER를 사용
DROP TRIGGER dbo.trg_uvInsert;
-- 삭제가 안됨 이유는 sp_rename 저장 프로시저를 사용해서 그렇다. sp_rename 저장 프로시저로 이름은 바뀌지만
-- sys.sql_modules 카탈로그 뷰의 내용은 변경하지 않기 때문에 삭제되지 않는다. 
GO

--2-6-3. 카탈로그 뷰 확인 
SELECT *FROM sys.sql_modules; -- 이름이 바뀌지 않은 trg_insert 확인 
-- 결론적으로 sp_rename으로 변경하는 것은 바람직하지 않으므로 DROP하고 다시 CREATE하는 방법을 사용 
GO

--2-6-4. 뷰를 삭제하면 트리거는 뷰에 부착된 것이므로 같이 삭제된다. 
DROP VIEW uv_deliver;
GO


---------기타 트리거에 관한 사항 
-- 다중 트리거
	-- 하나의 테이브에 동일한 트리거가 여러 개 부착되어 있는 것을 말한다. 
	-- 예로 AFTER INSERT 트리거가 한 개 테이블에 2개 이상 부착되어 있을 수 있다.
	
-- 중첩 트리거
	-- 트리거가 또 다른 트리거를 작동하는 것을 말한다. 
	-- 1. 고객이 물건을 구매하게 되면, 물건을 구매한 기록이 ‘구매 테이블에 INSERT 된다. 
	-- 2. 구매 테이블에 부착된 INSERT 트리거가 작동한다. 내용은 ‘물품 테이블의 남은 개수를 구매한 개수만큼 빼는 @UPDATE를 한다(인터넷 쇼핑몰에서 물건을 구매하면 즉시 남은 수량이 하나 줄어드는 것을 보았을 것이다. 
	-- 3.물품 테이블에 장착된 UPDATE 트리거가 작동한다. 내용은 ‘배송 테이블에 배송할 내용을 @INSERT 하는 것이다. 
	
	-- 하나의 ‘물건 구매(INSERT)' 작업으로 2개의 트리거가 연속적으로 작동했다. 이런 것은 중첩 트리거라고 한다. 
	-- 이와 같은 중첩 트리거는 32단계까지 사용이 가능하다. 
	-- SQL Server는 기본적으로 중첩트리거를 허용하며, 만약 중첩트리거를 허용하지 않으려면 서버 구성 옵션 중에 'nested triggers'를 OFF시켜야 한다. 
	-- 중첩트리거를 허용하지 않도록 설정한 후에는, 트리거를 작동시키려면 직접 테이블에 INSERT나UPDATE 작업을수행해야만한다. 위의 예에서 물품 테이블의 UPDATE 트리거를 작동시키려면 직접 UPDATE 문으로 물품 테이블의 데이터를 변경해야만한다. 
	-- 중첩트리거는 때때로 시스템의 성능에 좋지 않은 영향을 미칠 수 있다. 
	-- 위의 경우에 고객이 물건 을 구매하는 INSERT 작업이 일어나면 트랜잭션이 시작할 것이다. 이 트랜잭션은 마지막 배송 테이블에 정상적으로 입력이 수행되면 트랜잭션이 종료(커밋)된다. 즉, 만약 마지막 배송 테이블에 INSERT 작업이 실패한다면 그 앞의 모든 작업은 자동으로 ROLLBACK된다. 이것은 시스템에 부 담이 되므로 성능에 나쁜 영향을 끼칠 소지가 있다.

-- 재귀 트리거
	-- 트리거가 작동해서 다시 자신의 트리거를 작동시키는 것을 말함
	-- 간접 재귀, 직접 재귀 두 가지 종류가 있다. 
	-- 간접 재귀 트리거는 두 테이블이 서로 트리거로 물려 있는 경우를 말한다. 
		-- 1. INSERT 작업이 일어나면 A 테이블의 트리거가 작동해서 B 테이블에 
		-- 2. INSERT작업을 하게 되고, B데이블에서도 트리거가 작동해서 
		-- 3. INSERT 작업을 수행하게 된다. 그리고 다시 A 테이블의 트리거가 작동해서 INSERT가 작동하게 되는 순환 구조를 갖는다. 
	-- 직접 재귀 트리거는 자신의 테이블에 자신이 순환적으로 트리거를 발생시키는 구조
		-- 재귀 트리거는 32단계까지 반복되며, 반복 중에 문제가 발생시에는 모든 것이 는 구조를 갖는다. 
		-- 재귀 트리거는 ROLLBACK된다. 
		-- 재귀 트리거도 프로그래밍 언어와 마찬가지로 재귀를 빠져나올 수 있는 루틴을 만들어야 한다.
		-- 그렇지 않으면 무한루프를 돌게 된다. 
	-- 재귀 트리거는 기본적으로 허용되어 있지 않다. 재귀 트리거를 허용하려면 ALTER DATABASE를 사용하여
	-- RECURSIVE_TRIGGERS 설정을 해야한다.
GO

---- 지연된 이름 확인
-- 트리거를 정의 시에 해당 개체(주로 테이블)이 없더라도 트리거가 정의되는 것을 말함
-- 실제로 개체의 존재여부는 트리거 실행 시에 체크하게 된다.
GO

---- 트리거 작동 순서
-- 하나의 테이블에 여러 개의 AFTER 트리거가 부착되어 있다면, 트리거의 작동 순서를 지정할 수 있다. 
-- & INSTEAD OF 트리거의 경우에는 DML 문이 작동하기 이전에 작동하는 트리거이므로 순서를 지정하는 것이 의미가 없다. 

-- 몇 가지 주의할 점이 있는데, 작동 순서 전체를 지정할 수 없으며 처음과 끝에 작동할 트리거만을 지정할 수 있다. 
-- 즉, INSERT/UPDATE/DELETE 트리거당 FIRST, LAST를 지정할 수 있으므로 총 6개를 지정할 수 있다. 
-- 예로 들어, trgA, trgB, trgC, trgD 네 개의 INSERT 트리거가 한 테이블에 부착되어 있다면 다음과 같이 작동 순서를 지정할 수 있다.

sp_settriggerorder @triggername= 'dbo.trgA', @order= 'First', @stmttype = 'INSERT';
sp_settriggerorder @triggername= 'dbo.trgD', @order='Last', estmttype = 'INSERT';

-- trgA는 가장 먼저 작동하고, trgD는 가장 나중에 작동한다. 
-- 그 외 trgB, trgC는 작동 순서를 지정 할 수 없는 None'이 된다. 
-- 또한, ALTER TRIGGER로 트리거를 수정하게 되면, 지정된 수행 순서 는 모두 취소되므로 다시 순서를 지정해야 한다. 
GO

-- 실습4
-- 기타 트리거 작동 실습 이번 실습의 전제조건은 한 번에 한 행씩 입력 또는 변경해야함
--4-1. 연습용 DB 생성
USE tempdb;
CREATE DATABASE triggerDB;
GO
--4-2. 중첩 트리거를 실습할 테이블 생성.
USE triggerDB;
GO
CREATE TABLE orderTbl -- 구매테이블
(orderNo INT IDENTITY, -- 구매 일련번호
userID NVARCHAR (5), -- 구매한 회원 아이디
prodName NVARCHAR (5), -- 구매한 물건
orderAmount INT ); -- 구매한 개수 
GO
CREATE TABLE prodTbl -- 물품 테이블
( prodName NVARCHAR(5), -- 물건 이름 
account INT ); -- 남은 물건수량
GO
CREATE TABLE deliverTbl -- 배송 테이블
(deliverNo INT IDENTITY, -- 배송 일련번호
prodName NVARCHAR(5), -- 배송할 물건
amount INT); -- 배송할 물건개수
GO
-- 데이터 입력
INSERT INTO prodTbl VALUES(N'사과', 100);
INSERT INTO prodTbl VALUES(N'배', 100);
INSERT INTO prodTbl VALUES(N'귤', 100);
GO
-- 재귀 트리거 실습용 테이블 생성
CREATE TABLE recuA (id INT IDENTITY, txt NVARCHAR(10)); -- 간접 재귀 트리거용 테이블 A
GO
CREATE TABLE recuB (id INT IDENTITY, txt NVARCHAR(10)); -- 간접 재귀 트리거용 테이블 B
GO
CREATE TABLE recuAA (id INT IDENTITY, txt NVARCHAR(10)); -- 직접 재귀 트리거용 테이블 AA
GO

--4-3. 중첩 트리거가 수행될 수 있도록 서버 구성 옵션인 nested triggers가 on인지 확인(디폴트는 ON)
EXEC sp_configure 'nested triggers';
-- run_value가 1이면 on 상태
GO

--4-4. 트리거를 구매 테이블과 물품 테이블에 부착
CREATE TRIGGER trg_order
ON orderTbl
AFTER INSERT
AS
	PRINT N'1. trg_order를 실행합니다.'
	DECLARE @orderAmount INT
	DECLARE @prodName NVARCHAR(5)

	SELECT @orderAmount = orderAmount FROM inserted
	SELECT @prodName = prodName FROM inserted

	UPDATE prodTbl SET account -= @orderAmount
	WHERE prodName = @prodName
GO
--배송 테이블에 새 배송 건을 입력하는 트리거
CREATE TRIGGER trg_prod
ON prodTbl
AFTER UPDATE
AS
	PRINT N'2. trg_prod를 실행합니다.'
	DECLARE @prodName NVARCHAR(5)
	DECLARE @amount INT
	SELECT @prodName = prodName FROM inserted
	SELECT @amount = D.account - I.account
		FROM inserted I, deleted D -- (변경 전의 개수 - 변경 후의 개수) = 주문 개수

	INSERT INTO deliverTbl(prodName, amount) VALUES(@prodName, @amount);
GO

--4-5. 고객이 물건을 구매한 INSERT 작업 수행
INSERT INTO orderTbl VALUES('JOHN', N'배', 5); -- 트리거 두 개 모두 작동 완료
GO

--4-6. 중첩 트리거가 잘 작동했는지 세 테이블을 모두 확인

SELECT *FROM orderTbl;
SELECT *FROM prodTbl;
SELECT *FROM deliverTbl;
GO

--4-7. 배송 테이블의 열 이름을 변경해서 INSERT가 실패하도록 하자
EXEC sp_rename 'dbo.deliverTbl.prodName', 'productName', 'column';
GO

--4-8. 다시 데이터를 입력
INSERT INTO orderTbl VALUES ('DANG', '사과', 9); --트리거는 작동했으나, 마지막 열 이름 때문에 배송테이블에 INSERT가 실패함
GO

--4-9. 세 테이블을 모두 확인
SELECT *FROM orderTbl;
SELECT *FROM prodTbl;
SELECT *FROM deliverTbl;
-- 변경되지 않음 (롤백 되었음)
GO

---- 간접 재귀 트리거 실습

--5. 간접 재귀 트리거
--5-1. triggerDB에 간접 재귀 트리거가 허용되어 있는지 데이터베이스 옵션 'RECURSIVE_TRIGGERS'를 ON으로 설정해야함
USE triggerDB;
SELECT name, is_recursive_triggers_on FROM sys.databases
WHERE name = 'triggerDB';
-- 0으로 되어있어 1로 바꿔야함
GO

--5-2. ON으로 설정
ALTER DATABASE triggerDB
SET RECURSIVE_TRIGGERS ON;

--5-3. 두 테이블이 서로 물려있는 간접 재귀 트리거를 테이블A와 테이블B에 부착
CREATE TRIGGER trg_recuA
ON reCuA
AFTER INSERT
AS
	DECLARE @id INT
	SELECT @id = trigger_nestlevel() -- 현재 트리거 레벨 값
	
	PRINT N'트리거 레벨 ==› ' + CAST(@id AS CHAR (5))
	INSERT INTO recuB VALUES (N'간접 재귀 트리거')
GO

CREATE TRIGGER trg_recuB
ON recuB
AFTER INSERT
AS
	  DECLARE @id INT
	  SELECT @id = trigger_nestlevel() -- 현재 트리거 레벨 값

	  PRINT N'트리거 레벨==>' + CAST (@id AS CHAR(5))
	  INSERT INTO recuA VALUES (N'간접 재귀 트리거')
GO

--5-4. INSERT가 잘되는지 실행
INSERT INTO recuA VALUES(N'처음 입력값');
--32단계가 넘어서자 중지되었다 만약 32단계 제한이 없으면 무한 루프 했을 것이다. 

--5-5. 테이블에 무엇이 있는지 확인
SELECT *FROM recuA;
SELECT *FROM recuB;
-- 아무것도 들어있지 않다 왜냐면 마지막에 발생한 오류가 모든 트리거의 트랜잭션을 취소시켰기 때문

--5-6, 재귀를 빠져나올 수 있는 루틴을 추가해야한다. (위의 코드 수정)
CREATE TRIGGER trg_recuA
ON reCuA
AFTER INSERT
AS
	IF((SELECT TRIGGER_NESTLEVEL() ) >= 32)
		RETURN

	DECLARE @id INT
	SELECT @id = trigger_nestlevel() -- 현재 트리거 레벨 값
	
	PRINT N'트리거 레벨 ==› ' + CAST(@id AS CHAR (5))
	INSERT INTO recuB VALUES (N'간접 재귀 트리거')
GO

CREATE TRIGGER trg_recuB
ON recuB
AFTER INSERT
AS
	  IF((SELECT TRIGGER_NESTLEVEL() ) >= 32)
		  RETURN

	  DECLARE @id INT
	  SELECT @id = trigger_nestlevel() -- 현재 트리거 레벨 값

	  PRINT N'트리거 레벨==>' + CAST (@id AS CHAR(5))
	  INSERT INTO recuA VALUES (N'간접 재귀 트리거')
GO

--5-7. 수정 후 INSERT가 잘되는지 실행
INSERT INTO recuA VALUES(N'처음 입력값');
--32단계가 넘어서자 루프 문을 빠져나왔다. 

--5-8. 테이블에 무엇이 있는지 확인
SELECT *FROM recuA;
SELECT *FROM recuB;
-- 데이터가 잘 들어가 있다.
-- ID의 값이 1부터 시작하지 않은 것은 INSERT 실패 값이 남아있기 때문에 IDENTITY 값은 계속 증가하기 때문이다.


--CLR 트리거
-- T-SQL 저장 프로시저 대신 .NET Framework에서 생성되는 트리거

