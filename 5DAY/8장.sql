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
CREATE TABLE userTbl1 -- 회원테이블
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
CREATE TABLE buyTbl1 --회원 구매 테이블
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



--UNIQUE 제약조건
--CHECK 제약 조건
--DEFAULT 정의 
--NULL 값 허용 



