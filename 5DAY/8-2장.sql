--8-2장 

--스파스 열
-- 간단히 NULL 값에 대해 최적화된 저장소가 있는 일반 열로 정의할 수 있다.
-- 즉, NULL 값이 많이 들어갈 것으로 예상되는 열을 스파스 열로 지정해 놓으면, 공간 절약 효과가 커진다.
-- 그러나 NULL 값이 별로 없는 열이라면 오히려 저장 공간의 크기가 더 필요해진다. 

--1. 테스트 db 생성
USE tempdb;
CREATE DATABASE sparseDB;
--2.
USE sparseDB;
CREATE TABLE charTbl (id int identity, data char(100) NULL);
CREATE TABLE sparseCharTbl (id int identity, data char(100) SPARSE NULL); --확실히 위의 charTbl 보다 값이 작음 
--(테이블 속성에서 저장소에서 확인)
--3. 테이블 데이터 4만건 입력 data 열에는 75%를 null 값으로 입력 
DECLARE @i INT = 0
WHILE @i < 10000
BEGIN 
	INSERT INTO charTbl VALUES(null); -- null 값 3회
	INSERT INTO charTbl VALUES(null);
	INSERT INTO charTbl VALUES(null);
	INSERT INTO charTbl VALUES(REPLICATE('A', 100)); --실제 데이터 1회
	INSERT INTO sparseCharTbl VALUES(null); -- null 값 3회
	INSERT INTO sparseCharTbl VALUES(null);
	INSERT INTO sparseCharTbl VALUES(null);
	INSERT INTO sparseCharTbl VALUES (REPLICATE('A', 100)); --실제 데이터 1회
	SET @i += 1
END

--null 값이 거의 없는 열에 SPARSE 예약어를 지정하면 그 크기는?
TRUNCATE TABLE charTbl; -- 전체 행 데이터 삭제
TRUNCATE TABLE sparseCharTbl; -- 전체 행 데이터 삭제
GO
DECLARE @i INT = 0
WHILE @i < 40000

BEGIN
INSERT INTO charTbl VALUES (REPLICATE('A',100)) ;
INSERT INTO sparseCharTbl VALUES(REPLICATE('A' ,100)); -- 널 값이 없으니 오히려 크기가 charTbl보다 커짐 
SET @i += 1
END

USE tempdb
DROP DATABASE sparseDB;
-- 스파스 열은 다음과 같은 몇 가지 제약 사항이 있다. 
-- geometry, geography, image, text, ntext, timestamp, UDT(user Define data Type)에는 설정할 수 없다. 
-- 당연히 NULL을 허용해야 하며, IDENTITY 속성을 사용할 수 없다.
-- FILESTREAM 특성을 포함할 수 없다.
-- DEFAULT 값을 지정할 수 없다.
-- 스파스 열을 사용하면 행의 최대 크기가 8,060바이트에서 8,018 바이트로 줄어든다.
-- 스파스 열이 포함된 테이블은 압축할 수가 없다. 
-- 위 제약 사항을 참조해서 스파스 열을 적절하게 잘 활용하면 공간 절약의 효과를 얻을 수 있다. 
------------------------------------------------------------------------------------------------

-- 임시 테이블
-- 임시 테이블은 이름처럼 임시로 잠깐 사용되는 테이블 
-- 테이블을 만들 때 테이블 이름 앞에 #, ##을 붙이면 임시 테이블로 생성된다. 임시 테이블은 TEMPDB에 생성될 뿐, 나머지 사용법 등은 일반 테이블과 동일하게 사용 가능

-- #을 앞에 붙인 테이블은 로컬 임시 테이블이라고 부르며, 테이블을 생성한 사람만 사용할 수 있다. (즉, 다른 사용자는 해당 테이블 존재를 모름)
-- ##을 앞에 붙인 테이블은 전역 임시 테이블이라고 부르며, 모든 사용자가 사용할 수 있는 테이블

-- 임시 테이블 삭제 시점
--1. 사용자가 DROP TABLE로 삭제
--2. SQL SERVER가 다시 시작되면 삭제
--3. 로컬 임시 테이블은 생성한 사용자의 연결이 끊기면 삭제 (즉 쿼리창이 닫히면 삭제)
--4. 전역 임시 테이블은 생성한 사용자의 연결이 끊기고 이 테이블을 사용 중인 사용자가 없을 때 삭제

-- 실습
USE tableDB;
CREATE TABLE #tempTbl (ID INT, txt NVARCHAR(10));
GO
CREATE TABLE ##tempTbl (ID INT, txt NVARCHAR(10));
GO

INSERT INTO #tempTbl VALUES(1, N'지역임시테이블');
INSERT INTO ##tempTbl VALUES(1, N'전역임시테이블');
GO

--조회 (임시 테이블은 MASTER에서도 조회 가능함)
SELECT * FROM #tempTbl;
SELECT * FROM ##tempTbl;

--새로운 쿼리창을 열면 ##은 조회가 되지만 #은 조회가 안됨
BEGIN TRAN
	INSERT INTO ##tempTbl VALUE(2. N'새 쿼리창에서 입력');
-- BEGIN TRAN이 나온 후 INSERT, UPDATE, DELETE 등이 나오면 COMMIT TRAN이 나올 때까지는 실제로 완전히 적용된 상태가 아니다. 즉 해당 테이블을 사용 중으로 본다.
-- 트랜잭션을 커밋하고, 다시 조회하면 전역 임시 테이블도 더 이상 사용하는 사용자가 없어 자동 삭제된다.
COMMIT TRAN;
SELECT *FROM ##tempTbl;

------------------------------------------------------------
--테이블 삭제
DROP TABLE 테이블이름;
-- 단, 외래 키 제약 조건의 기준 테이블은 삭제할 수 없다. 먼저 외래 키가 생성된 외래 키 테이블을 삭제해야 삭제 가능

------------------------------------------------------------
-- 테이블 수정
-- ALTER TABLE 문을 사용
-- 이미 생성된 테이블에 추가/변경/수정/삭제는 모두 ALTER TABLE 사용

---- 수정1 (열 추가)
USE tableDB;
ALTER TABLE userTbl
		ADD homepage NVARCHAR(30) --열추가
		DEFAULT 'http://www.hanb.co.kr' -- 디폴트 값
		NULL;
GO
EXEC sp_help userTbl;

---- 수정2 (열 삭제)
USE tableDB;
ALTER TABLE userTbl
		DROP COLUMN mobile1;
GO
-- 제약 조건이 있으면 문제가 생김 

---- 수정3 (열의 데이터 형식 변경)
USE tableDB;
ALTER TABLE userTbl
	ALTER COLUMN name NVARCHAR(20) NULL;
-- 제약 조건이 있으면 문제가 생김 

--열의 이름 변경
EXEC sp_rename 'userTbl.name', 'username', 'COLUMN'; --되도록이면 열의 이름은 변경하지 않는게 좋음 (스크립트 및 저장 프로시저 손상 방지)
-- 다른 방법으론 해당 테이블 오른쪽 클릭 후 디자인.

---- 수정4 (열의 제약 조건 추가 및 삭제)
USE tableDB;
ALTER TABLE userTbl
	DROP CONSTRAINT CD_height; -- 제약 조건 이름
GO

--실습 
-- 1. 테이블 다시 설정
USE tableDB;
DROP TABLE buyTbl, userTbl;
GO
CREATE TABLE userTbl
( userID char(8),
name nvarchar(10),
birthYear int,
addr nchar(2),
mobile1 char(3),
mobile2 char(8),
height smallint,
mDate date
);
GO
CREATE TABLE buyTbl
( num int IDENTITY,
userid char(8),
prodName char (6),
groupName nchar(4),
price int,
amount smallint
);
GO

--2. 데이터 입력 
INSERT INTO userTbl VALUES('LSG', N'이승기', 1987, N'서울' , '011' , '1111111' , 182 ,'2008-8-8') ; 
INSERT INTO userTbl VALUES('KBS', N'김범수', NULL, N'경남', '011', '2222222', 173, '2012-4-4'); 
INSERT INTO userTbl VALUES('KKH', N'김경호', 1871, N'전남' , '019' , '3333333' ,177,'2007-7-7') ; 
INSERT INTO userTbl VALUES('JYP', N'조용필', 1950, N'경기', '011', '4444444', 166, '2009-4-4'); 
GO 
INSERT INTO buyTbl VALUES('KBS', N'운동화' , NULL , 30, 2); 
INSERT INTO buyTbl VALUES('KBS', N'노트북', N'전자', 1000, 1); 
INSERT INTO buyTbl VALUES('JYP', N'모니터', N'전자', 200, 1); 
INSERT INTO buyTbl VALUES('BBK', N'모니터', N'전자', 200, 5); 
GO 

--3. 제약 조건 생성 
ALTER TABLE userTbl
ADD CONSTRAINT PK_userTbl_userID
PRIMARY KEY (userID);
-- 오류 발생 PRIMARY KEY로 지정할려면 NOT NULL로 열이 설정되어 있어야함 
ALTER TABLE userTbl
ALTER COLUMN userID char (8) NOT NULL;
GO
ALTER TABLE userTbl
	ADD CONSTRAINT PK_userTbl_userID
		PRIMARY KEY (userID);
GO
ALTER TABLE buyTbl
	ADD CONSTRAINT PK_buyTbl_num
		PRIMARY KEY (num);
GO
--BUYTBL의 NUM에는 NOT NULL을 지정하지 않았는데 오류가 나지 않고 PRIMARY KEY로 지정되어 있다.
--왜냐하면 IDENTITY 속성을 지정하면 자동으로 NOT NULL 속성을 가지기 때문이다.

--4. 외래 키 설정 
ALTER TABLE buyTbl
	ADD CONSTRAINT FK_userTbl_buyTbl
		FOREIGN KEY (userID)
		REFERENCES userTbl (userID);
-- BUYTBL에 BBK의 구매기록이 있는데 BBK 아이디가  USERTBL에 존재하지 않아 충돌됨
-- 데이터가 많은 경우도 있기 때문에 기존의 입력된 값이 서로 불일치 하더라도 무시하고 외래 키 제약 조건을 맺어줄 필요가 있다. 
-- WITH NOCHECK를 활용 생략하면 WITH CHECK가 기본값 
ALTER TABLE buyTbl WITH NOCHECK 
	ADD CONSTRAINT FK_userTbl_buyTbl
		FOREIGN KEY (userID)
		REFERENCES userTbl (userID);
GO
--테스트로 값 입력
INSERT INTO buyTbl VALUES('KBS', N'청바지', N'의류', 50, 3);
INSERT INTO buyTbl VALUES('BBK', N'메모리', N'전자', 80, 1); --BBK가 아직 USERTBL에 없기 때문에 오류가 생김
-- 이럴 때는 잠깐 외래 키 제약 조건을 비활성화 시키고 데이터를 모두 입력 후 외래 키 제약 조건을 활성화 시킨다. 
ALTER TABLE buyTbl
	NOCHECK CONSTRAINT FK_userTbl_buyTbl ; -- NOCHECK CONSTRAINT 제약_조건_이름 (비활성화)
GO
INSERT INTO buyTbl VALUES('BBK', N'메모리', N'전자', 80, 10);
INSERT INTO buyTbl VALUES('SSK', N'책', N'서적', 15, 5);
INSERT INTO buyTbl VALUES('EJW', N'책', N'서적', 15, 2);
INSERT INTO buyTbl VALUES('EJW', N'청바지', N'의류', 50, 1);
INSERT INTO buyTbl VALUES('BBK', N'운동화', NULL, 30, 2);
INSERT INTO buyTbl VALUES('EJW', N'책', N'서적', 15, 1);
INSERT INTO buyTbl VALUES('BBK', N'운동화', NULL, 30, 2);
GO
ALTER TABLE buyTbl
	CHECK CONSTRAINT FK_userTbl_buyTbl; -- CHECK CONSTRAINT 제약_조건_이름 (다시 활성화)
GO

--5. USERTBL의 출생년도를 1900~ 현재까지만 설정
ALTER TABLE userTbl
	ADD CONSTRAINT CK_birthYear
	CHECK
		(birthYear >= 1900 AND birthYear <= YEAR(GETDATE()));
-- 위 구문 오류 (입력시에 김범수의 출생년도 NULL, 김경호의 출생년도를 1871로 잘못입력 했기 때문. WITH NOCHECK로 무시!

ALTER TABLE userTbl
	WITH NOCHECK -- 제약 조건을 생성할 때만 무시하며 쿼리문이 끝나면 다시 제약 조건이 발동
	ADD CONSTRAINT CK_birthYear
	CHECK
		(birthYear >= 1900 AND birthYear <= YEAR(GETDATE()));

-- USERTBL 데이터 입력

INSERT INTO userTbl VALUES('SSK', '성시경', 1979, '서울',  NULL,  NULL,     186, '2013-12-12');
INSERT INTO userTbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO userTbl VALUES('YJS', '윤종신', 1969, '경남',  NULL,  NULL,     170, '2005-5-5');
INSERT INTO userTbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO userTbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO userTbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');

--6. 회원이 자신의 ID를 변경해달라고 한다. BBK를 VVK로 변경 
UPDATE userTbl SET userID = 'VVK' WHERE userID = 'BBK'; --BBK는 이미 BUYTBL에 구매한 기록이 있어 바뀌지 않음 
--제약조건 비활성화 후 변경
ALTER TABLE buyTbl
		NOCHECK CONSTRAINT FK_userTbl_buyTbl;
GO
UPDATE userTbl SET userID = 'VVK' WHERE userID = 'BBK';
GO
ALTER TABLE buyTbl
		CHECK CONSTRAINT FK_userTbl_buyTbl;
GO
-- 구매 테이블의 사용자에게 물품 배송을 위해 회원 테이블과 조인시켜보기
-- 즉, 구매한 회원 아이디, 회원 이름, 구매한 제품, 주소, 연락를 출력
SELECT B.userid, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS [연락처]
	FROM buyTbl B
		INNER JOIN userTbl U
			ON B.userid = U.userID
GO
-- 12건을 입력했는데 8건만 나왔다? 구매 테이블 다시 확인
SELECT COUNT(*) FROM buyTbl;
-- 12건이 잘 나오므로 외부 조인으로 구매 테이블의 내용을 모두 출력
SELECT B.userid, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS [연락처]
	FROM buyTbl B
		LEFT OUTER JOIN userTbl U
			ON B.userid = U.userID
	ORDER BY B.userid;
GO
-- BBK라는 아이디를 VVK로 변경해서 이러한 현상이 발생한 것임. 따라서 원래 것으로 돌려놔야함

ALTER TABLE buyTbl
NOCHECK CONSTRAINT FK_userTbl_buyTbl;
GO
UPDATE userTbl SET userID = 'BBK' WHERE userID = 'VVK';
GO
ALTER TABLE buyTbl
CHECK CONSTRAINT FK_userTbl_buyTbl;

-- 앞에서와 같은 문제를 없애기 위해, 회원 테이블의 userID가 바뀔 때, 이와 관련된 구매 테이블의 userID도 자동 변경되도록 한다. 
ALTER TABLE buyTbl
	DROP CONSTRAINT FK_userTbl_buyTbl;
GO
ALTER TABLE buyTbl WITH NOCHECK
	ADD CONSTRAINT FK_userTbl_buyTbl
		FOREIGN KEY (userID)
		REFERENCES userTbl (userID)
		ON UPDATE CASCADE; -- 외래 키 제약 조건을 삭제한 후에 다시 온으로 변경 
GO

-- 다시 VVK로 변경해보고 BUYTBL도 바뀌었는지 확인 
UPDATE userTbl SET userID = 'VVK' WHERE userID= 'BBK';
GO
SELECT B.userid, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS [연락처]
FROM buyTbl B
	INNER JOIN userTbl U
		ON B.userid = U.userid
	ORDER BY B.userid;
GO

-- VVK 회원이 탈퇴하면 구매한 기록도 삭제가 되는지 확인 
DELETE userTbl WHERE userID = 'VVK'; -- 역시나 제약 조건 때문에 오류
-- 오류 수정 
ALTER TABLE buyTbl
	DROP CONSTRAINT FK_userTbl_buyTbl;
GO
ALTER TABLE buyTbl WITH NOCHECK
	ADD CONSTRAINT FK_userTbl_buyTbl
		FOREIGN KEY (userID)
		REFERENCES userTbl (userID)
		ON UPDATE CASCADE
		ON DELETE CASCADE;
GO
DELETE userTbl WHERE userID= 'VVK';
GO
SELECT * FROM buyTbl;

--7. userTbl에서 CHECK 제약 조건이 걸린 출생년도 열을 삭제 
ALTER TABLE userTbl
		DROP COLUMN birthYear; -- 오류
GO
-- 제약 조건 CK_birthYear 삭제 후 열 삭제
ALTER TABLE userTbl
		DROP CK_birthYear; -- 오류
GO
ALTER TABLE userTbl
		DROP COLUMN birthYear; -- 오류
GO
SELECT *FROM userTbl --확인 
GO 






