--8장 테이블과 뷰  

USE tempdb;
GO 
CREATE DATABASE tableDB;

--테이블을 만들고 생긴 dbo는 스키마의 이름이다. 

--입력 실수 또는 삭제로 다시 입력할 경우 IDENTITY 값이 설정된 NUM 열은 처음으로 돌아가지 않고
--계속 증가된 값으로 입력이 되는데 이럴 경우에는 
USE tableDB;
DBCC CHECKIDENT('buyTbl');
DBCC CHECKIDENT('buyTbl',RESEED,0); -- DBCC CHECKIDENT('테이블이름',RESEED,초기값);
--이렇게 설정해주면 된다.

------------T-SQL로 생성
USE tableDB;
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
FOREIGN KEY REFERENCES userTbl(userID), --외래 키 설정 
prodName NCHAR(6) NOT NULL, --물품명
groupName NCHAR(4), --분류
price INT NOT NULL, --단가
amount SMALLINT NOT NULL -- 수량
);
GO
----NOT NULL 생략하면 NULL이 디폴트이며 적어주는 것이 좋긴함
--IDENTITY(SEED, INCREMENT) 값도 생략하면 자동으로 IDENTITY(1,1)이며 적어주는 것이 좋긴함

INSERT INTO userTbl VALUES('LSG', N'이승기', 1987, N'서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTbl VALUES('KBS', N'김범수', 1979, N'경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTbl VALUES('KKH', N'김경호', 1971, N'전남', '019', '3333333', 177, '2007-7-7');

INSERT INTO buyTbl VALUES('KBS', N'운동화',  NULL, 30, 2);
INSERT INTO buyTbl VALUES('KBS', N'노트북', N'전자',1000,1);
INSERT INTO buyTbl VALUES('JYP', N'모니터', N'전자',200,1); -- 오류

--제약조건 
--PRIMARY KEY 제약조건

--아까 위처럼 바로 PRIMARY키를 입력해줘도 되지만 기본키를 정의할 때 다음과 같이 정의 할 수 있다
CREATE TABLE userTbl2 -- 회원테이블
(userID CHAR(8) NOT NULL PRIMARY KEY, --사용자 아이디
);

--이것을 아래와 같이 기본 키의 이름을 지정하는 것이다. 

CREATE TABLE userTbl3 -- 회원테이블
(userID CHAR(8) NOT NULL
	CONSTRAINT PK_userTbl_userID PRIMARY KEY, );
GO
-- 이렇게 정의하거나 
-- 모든열을 정의하고 나서 맨 마지막에 정의 할 수도 있다. 
CREATE TABLE userTbl4 -- 회원테이블
(userID CHAR(8) NOT NULL, --사용자 아이디
name   NVARCHAR(10) NOT NULL, -- 이름
birthYear INT NOT NULL, --출생년도
addr NCHAR(2) NOT NULL, --지역(경기, 서울, 경남 식으로 2글자만 입력)
mobile1 CHAR(3), -- 휴대폰의 국번(011, 016, 017, 019, 010 등)
mobile2 CHAR(8), -- 휴대폰의 나머지 전화번호(하이폰 제외)
height SMALLINT, --키
mDate DATE -- 회원가입일
CONSTRAINT PK_userTbl4_userID PRIMARY KEY -- 이렇게 마지막 행에 정의 가능 
);
GO
-- 마지막으로 또하나의 방법은 ALTER TABLE문을 사용하는 것이다. 
--모든 열을 정의하고 나서 아래와 같이 더 추가해준다. 

ALTER TABLE userTbl -- userTbl을 변경하자 
	ADD CONSTRAINT PK_userTbl_userID -- 제약조건을 추가하자 추가할 제약조건 이름은 PK_userTbl_userID
	PRIMARY KEY (userID); -- 추가할 제약조건은 기본 키 제약 조건이다. 그리고 제약 조건을 설정할 열은 userID 열이다.
GO

--기본키가 하나의 열로만 구성해야 하는 것이 아니다. 필요에 따라서 두 개 이상으로 설정가능.
--만약 제품코드가 AAA가 냉장고, BBB가 세탁기, CCC가 TV라고 가정하면 현재 제품코드만으로는 
-- 중복될 수밖에 없으므로, 기본 키로 설정할 수 없어 제품 일련번호도 마찬가지로 품번을 
-- 0001번부터 부여하는 체계라서 기본 키로 설정할 수가 없으므로 '제품코드 + 제품일련번호'를 키로 설정

CREATE TABLE prodTbl
(prodCode NCHAR(3) NOT NULL,
 prodID NCHAR(4) NOT NULL,
 prodDate SMALLDATETIME NOT NULL,
 prodCur NCHAR(10) NULL
);
GO
ALTER TABLE prodTbl
		ADD CONSTRAINT PK_prodTbl_proCode_prodID
		PRIMARY KEY (prodCode, prodID);
GO

--또는 CREATE TABLE 구문 안에 직접 사용 가능
DROP TABLE prodTbl;
GO
CREATE TABLE prodTbl
(prodCode NCHAR(3) NOT NULL,
 prodID NCHAR(4) NOT NULL,
 prodDate SMALLDATETIME NOT NULL,
 prodCur NCHAR(10) NULL,
 CONSTRAINT PK_prodTbl_proCode_prodID
		PRIMARY KEY (prodCode, prodID)
);

EXEC sp_help prodTbl -- 테이블 확인 

----------------------------------------------------
--FOREIGN KEY 제약조건
-- 외래 키 테이블에 데이터를 입력할 때는 꼭 기준 테이블을 참조 해서 입력하므로, 기준 테이블에 이미 데이터가 존재해야 한다. 
-- 앞에 실습에서 buyTbl에 JYP(조용필)이 입력이 안되는 것을 확인했는데 그것은 외래 키 제약 조건을 위반했기 때문이다. 
--1.
CREATE TABLE buyTbl --회원 구매 테이블
(num INT IDENTITY NOT NULL PRIMARY KEY,
userID CHAR(8) NOT NULL --아이디(FK)
FOREIGN KEY REFERENCES userTbl(userID), --외래 키 설정 (첫번 째 방법)
prodName NCHAR(6) NOT NULL, --물품명
);
GO
--2.
CREATE TABLE buyTbl --회원 구매 테이블
(num INT IDENTITY NOT NULL PRIMARY KEY,
userID CHAR(8) NOT NULL --아이디(FK)
	CONSTRAINT FK_userTbl_buyTbl --외래 키 이름 생성
	FOREIGN KEY REFERENCES userTbl(userID), --외래 키 설정 (두번 째 방법)
prodName NCHAR(6) NOT NULL,); --물품명
GO
--3.
CREATE TABLE buyTbl --회원 구매 테이블
(num INT IDENTITY NOT NULL PRIMARY KEY, -- 순번(IDENTITY는 자동 증가 쿼리문)(PK)
userID CHAR(8) NOT NULL --아이디(FK)
prodName NCHAR(6) NOT NULL, --물품명
groupName NCHAR(4), --분류
price INT NOT NULL, --단가
amount SMALLINT NOT NULL -- 수량
CONSTRAINT FK_userTbl_buyTbl --외래 키 이름 생성
	FOREIGN KEY REFERENCES userTbl(userID),); --맨 마지막에 외래 키 설정 (세번 째 방법)
GO
--4. 
CREATE TABLE buyTbl --회원 구매 테이블
(num INT IDENTITY NOT NULL PRIMARY KEY, -- 순번(IDENTITY는 자동 증가 쿼리문)(PK)
userID CHAR(8) NOT NULL --아이디(FK)
prodName NCHAR(6) NOT NULL, --물품명
groupName NCHAR(4), --분류
price INT NOT NULL, --단가
amount SMALLINT NOT NULL -- 수량
);
GO
ALTER TABLE buyTbl -- buyTbl을 수정한다.
		ADD CONSTRAINT FK_userTbl_buyTbl -- 제약 조건을 더한다. 제약 조건 이름은 'FK_userTbl_buyTbl'로 한다.
		FOREIGN KEY (userID) -- 외래 키 제약 조건을 buyTbl의 userID에 설정한다,
		REFERENCES userTbl(userID); --참조할 기준 테이블은 userTbl의 userID 열이다. 
GO

--###참고 
--sp_help 저장 프로시저 외에도 sp_helpconstraint 저장 프로시저로 제약 조건을 확인할 수 있다.
--또는 카탈로그 뷰를 사용할 수 있다. 기본 키와 관련된 카탈로그 뷰는 sys.key_onstraints이며, 외래 키와 관련된 것은 sys.foreign_keys이며
-- 사용법은 SELECT * FROM 카탈로그뷰_이름으로 확인하면 된다. 
------------------------------------------------------------------------------------------------
--UNIQUE 제약조건
-- 중복되지 않는 유일한 값을 입력해야 하는 제약조건.
-- 기본 키와 거의 비슷하며 차이점은 UNIQUE는 NULL 값을 허용한다는 점뿐이다. 단 NULL도 한 개만 허용된다.
-- NULL값이 두 개라면 이미 유일하지 않다는 것이다. 
-- 보통 회원 테이블에서는 이메일 주소를 Unique로 설정하는 경우가 많이 있다. 
--표현법 
--1.
CREATE TABLE userTbl -- 회원테이블
(userID CHAR(8) NOT NULL PRIMARY KEY, --사용자 아이디
--------
 email char(30) NULL UNIQUE
);
GO
--2. 
CREATE TABLE userTbl -- 회원테이블
(userID CHAR(8) NOT NULL PRIMARY KEY, --사용자 아이디
--------
 email char(30) NULL 
		CONSTRAINT AK_email UNIQUE
);
GO
--3.
CREATE TABLE userTbl -- 회원테이블
(userID CHAR(8) NOT NULL PRIMARY KEY, --사용자 아이디
--------
 email char(30) NULL,
CONSTRAINT AK_email UNIQUE (email)
);
GO
------------------------------------------------------------------------------------------------
--CHECK 제약 조건
--CHECK 제약 조건은 입력되는 데이터를 점검하는 기능이다.
-- 키에 마이너스 값이 들어올 수 없게 한다거나, 출생 연도가 1900년 이후이고 현재 시점 이전 이어야 한다든지 등의 조건을 지정한다. 

--1.출생 연도가 1900년 이후이고 현재 시점 이전
ALTER TABLE userTbl
	ADD CONSTRAINT CK_birthYear
	CHECK (birthYear >= 1900 AND birthYear <= YEAR(GETDATE()));
GO

--2. 휴대폰 국번 체크
ALTER TABLE userTbl
	ADD CONSTRAINT CK_mobile1
	CHECK (mobile1 IN ('010', '011', '016', '017', '018', '019'));
GO

--3. 키는 0이상이어야 함
ALTER TABLE userTbl
	ADD CONSTRAINT CK_height
	CHECK (height >= 0);
GO

--4. WITH CHECK, WITH NOCHECK 
-- 기존 입력된 데이터가 CHECK 제약 조건에 맞지 않을 경우에 어떻게 처리할 것인지 결정해주는 것
-- 만약 012을 입력했는데 그냥 넘어가게 하고 싶을 경우
ALTER TABLE userTbl
	WITH NOCHECK
	ADD CONSTRAINT CK_mobile1
	CHECK (mobile1 IN ('010', '011', '016', '017', '018', '019'));
GO
------------------------------------------------------------------------------------------------
--DEFAULT 정의 
-- DEFAULT는 값을 입력하지 않았을 때, 자동으로 입력되는 기본 값을 정의하는 방법이다. 
-- 예를 들어 출생년도를 입력하지 않으면 그냥 현재의 연도를 입력, 주소를 특별히 입력하지 않았다면 서울이 입력, 키를 입력하지 않았다면 170
USE tempdb;
CREATE TABLE userTbl -- 회원테이블
(userID CHAR(8) NOT NULL PRIMARY KEY, --사용자 아이디
 name   NVARCHAR(10) NOT NULL, -- 이름
 birthYear INT NOT NULL DEFAULT YEAR(GETDATE()), --출생년도
 addr NCHAR(2) NOT NULL DEFAULT N'서울', --지역(경기, 서울, 경남 식으로 2글자만 입력)
 mobile1 CHAR(3), -- 휴대폰의 국번(011, 016, 017, 019, 010 등)
 mobile2 CHAR(8), -- 휴대폰의 나머지 전화번호(하이폰 제외)
 height SMALLINT NULL DEFAULT 170, --키
 mDate DATE unique -- 회원가입일 
);
--ALTER TABLE 사용 
USE tempdb;
CREATE TABLE userTbl -- 회원테이블
(userID CHAR(8) NOT NULL PRIMARY KEY, --사용자 아이디
 name   NVARCHAR(10) NOT NULL, -- 이름
 birthYear INT NOT NULL DEFAULT YEAR(GETDATE()), --출생년도
 addr NCHAR(2) NOT NULL DEFAULT N'서울', --지역(경기, 서울, 경남 식으로 2글자만 입력)
 mobile1 CHAR(3), -- 휴대폰의 국번(011, 016, 017, 019, 010 등)
 mobile2 CHAR(8), -- 휴대폰의 나머지 전화번호(하이폰 제외)
 height SMALLINT NULL DEFAULT 170, --키
 mDate DATE unique -- 회원가입일 
);
GO
ALTER TABLE userTbl
	ADD CONSTRAINT CD_birthYear
		DEFAULT YEAR(GETDATE()) FOR birthYear;
GO
ALTER TABLE userTbl
	ADD CONSTRAINT CD_addr
		DEFAULT N'서울' FOR addr;
GO
ALTER TABLE userTbl
	ADD CONSTRAINT CD_height
		DEFAULT 170 FOR height;
GO
-- 데이터 입력
-- default 문은 DEFAULT로 설정된 값을 자동 입력한다. 
INSERT INTO userTbl VALUES('LHL', N'이해리', default, default, '011' ,'1234567' , default, '2019.12.12');
-- 열이름이 명시되지 않으면 DEFAULT로 설정된 값을 자동 입력한다. 
INSERT INTO userTbl(userID, name) VALUES('KAY', N'김아영');
-- 값이 직접 명기되면 DEFAULT로 설정된 값은 무시된다. 
INSERT INTO userTbl VALUES('WB', N'원빈', 1982, N'대전', '019' ,'9876543' , 176, '2017.5.5');
GO
SELECT * FROM userTbl;
GO
------------------------------------------------------------------------------------------------
--NULL 값 허용 
-- 아무 것도 없다는 의미 공백(' ')이나 0과 같은 값과는 다르다는 점 주의 
--1. ANSI_NULL_DEFAULT OFF 후 테이블 생성
USE tempdb
CREATE DATABASE nullDB;
GO
ALTER DATABASE nullDB
	SET ANSI_NULL_DEFAULT OFF; -- 따로 실행하지 않아도 기본은 OFF
GO
USE nullDB;
CREATE TABLE t1 (id int);
GO
INSERT INTO t1 VALUES (NULL);
EXEC sp_help t1; --Nullable yes로 되어있음 왜? 현재 쿼리창의 옵션 중에 ANSI_NULL_DFLT_ON 옵션이 ON으로 설정되어 있기 때문
--이 세션 옵션이 데이터베이스 옵션보다 더 우선 적용되기 때문에 아무 것도 붙이지 않으면 NULL을 붙인 것과 동일 한 효과를 주는 것이다. 
--2. 세션의 옵션을 변경 후에 실행
USE tempdb;
DROP DATABASE nullDB;
GO
CREATE DATABASE nullDB;
GO
ALTER DATABASE nullDB
	SET ANSI_NULL_DEFAULT OFF; -- 따로 실행하지 않아도 기본은 OFF
GO
SET ANSI_NULL_DFLT_ON OFF;
USE nullDB;
CREATE TABLE t1 (id int);
GO
INSERT INTO t1 VALUES (NULL);
EXEC sp_help t1; --Nullable NO로 되어있음
-- ANSI_NULL_DFLT_ON 설정은 쿼리창을 닫으면 원래대로 돌아감
-- 결론적으로 NULL과 NOT NULL을 직접 붙여주는 것을 권장