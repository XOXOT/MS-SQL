----- 9장 인덱스

--인덱스의 장점
--1. 검색 속도가 무척 빨라질 수 있다. (항상 그런 것은 아니다)
--2. 그 결과 해당 쿼리의 부하가 줄어들어서, 시스템 전체의 성능이 향상된다. 

-- 인덱스의 단점
--1. 인덱스가 데이터베이스 공간을 차지해서 데이터베이스 크기의 10% 정도의 추가 공간이 필요
--2. 처음 인덱스를 생성하는 데 시간이 많이 소요될 수 있다.
--3. 데이터의 변경 작업(INSERT, UPDATE, DELETE)이 자주 일어날 경우에는 오히려 성능이 나빠질 수 있다.

-- 인덱스의 종류 
-- 클러스터형 인덱스(영어사전), 비클러스터형 인덱스(책 뒤의 찾아보기)
-- 클러스터형 인덱스는 테이블당 한 개만 생성 가능하며 행 데이터를 인덱스로 지정한 열에 맞춰서 자동 정렬 가능
-- 비클러스터형 인덱스는 테이블당 여러 개 생성 가능

-- UserTbl을 정의할 때 userID를 기본 키로 정의 했기 때문에 자동으로 userID 열에 클러스터형 인덱스가 생성됨
-- 위의 설명과 같이 기본 키는 하나만 생성이 가능하므로 마찬가지로 클러스터형 인덱스도 테이블 당 한 개만 생성 가능하다.

EXEC sp_helpindex userTbl -- 자동으로 clustered가 있는 것을 확인할 수 있다. 

--만약 비클러스터를 만들고 싶다면?
CREATE TABLE userTbl 
(userID CHAR(8) NOT NULL PRIMARY KEY NONCLUSTERED, -- 기본 키 정의 옆에 넌클러스터를 붙여줌 
name   NVARCHAR(10) NOT NULL,
birthYear INT NOT NULL, 
addr NCHAR(2) NOT NULL,
mobile1 CHAR(3), 
mobile2 CHAR(8), 
height SMALLINT, 
mDate DATE 
);
-- 이렇게 되면 userTbl에 클러스터형 인덱스가 없으므로 한 개의 클러스터형 인덱스를 만들 여분이 있게 된다. 
-- 테이블 생성 시 인덱스를 만들려면 반드시 제약 조건을 사용해야 하며, 인덱스가 만들어 지는 제약 조건은 primary key 또는 unique 뿐이다. 

--unique 제약 조건도 생성해보자.
CREATE TABLE tbl2
		(a INT PRIMARY KEY,
		 b INT UNIQUE, 
		 c INT UNIQUE, 
		 d INT
		);
GO
EXEC sp_helpindex tbl2;

-- 강제로 TBL2의 PRIMARY KEY를 비클러스터 인덱스로 지정 
CREATE TABLE tbl3
		(a INT PRIMARY KEY NONCLUSTERED,
		 b INT UNIQUE, 
		 c INT UNIQUE, 
		 d INT
		);
GO
EXEC sp_helpindex tbl3;

-- 강제로 UNIQUE에 클러스터 인덱스 지정
CREATE TABLE tbl4
		(a INT PRIMARY KEY NONCLUSTERED,
		 b INT UNIQUE CLUSTERED, 
		 c INT UNIQUE, 
		 d INT
		);
GO
EXEC sp_helpindex tbl4;
GO
-- 클러스터 두 개 (오류 뜸)
CREATE TABLE tbl5
		(a INT PRIMARY KEY NONCLUSTERED,
		 b INT UNIQUE CLUSTERED, 
		 c INT UNIQUE CLUSTERED,  -- 클러스터 인덱스는 무조건 하나만 오류뜸
		 d INT
		);
GO
EXEC sp_helpindex tbl5;
GO 
-- UNIQUE에만 명시하고 PRIMARY KEY에 넌클러스터 안한다면? --자동으로 넌클러스터 처리가 된다. 
CREATE TABLE tbl6
		(a INT PRIMARY KEY,
		 b INT UNIQUE CLUSTERED, 
		 c INT UNIQUE,  -- 클러스터 인덱스는 무조건 하나만 오류뜸
		 d INT
		);
GO
EXEC sp_helpindex tbl6;
GO 

--클러스터형 인덱스는 행 데이터를 자신의 열을 기준으로 정렬한다고 했는데 한번 알아보자
USE tempdb;
CREATE TABLE userTbl3 -- 회원테이블
(userID CHAR(8) NOT NULL PRIMARY KEY, --사용자 아이디
name   NVARCHAR(10) NOT NULL, -- 이름
birthYear INT NOT NULL, --출생년도
addr NCHAR(2) NOT NULL, --지역(경기, 서울, 경남 식으로 2글자만 입력)
);

INSERT INTO userTbl3 VALUES('LSG', N'이승기', 1987, N'서울');
INSERT INTO userTbl3 VALUES('KBS', N'김범수', 1979, N'경남');
INSERT INTO userTbl3 VALUES('KKH', N'김경호', 1971, N'전남');
INSERT INTO userTbl3 VALUES('JYP', N'조용필', 1950, N'경기');
INSERT INTO userTbl3 VALUES('SSK', N'성시경', 1979, N'서울'); 
GO
SELECT *FROM userTbl3; --입력과 다르게 USERID 값을 기준으로 정렬된 것을 볼 수 있다.

--B-Tree
-- 균형트리는 자료구조에서 나오는 범용적으로 사용되는 데이터의 구조
-- 이 구조는 주로 인덱스를 표현할 때와 그 외에서도 많이 사용된다. 
-- 노드는 트리 구조에서 데이터가 존재하는 공간이다.
-- 루트 노드는 가장 상위에 있는 노드
-- 리프 노드는 가장 말단에 있는 노드 
-- 루트와 리프 사이는 그냥 중간 수준 노드 
-- SQL SERVER에서 이 노드에 해당되는 것은 페이지다. (페이지는 8Kbyte)
-- 아무리 작은 데이터를 한 개만 저장해도 한 개 페이지(8Kbyte)를 차지하게 된다는 의미
-- B-Tree 구조가 아니라면 리프 페이지만 존재하여 그냥 처음부터 검색하게 된다. 
-- B-Tree 구조면 SELECT 속도가 급격하게 향상됨 

-- 만약 리프 페이지에 빈 공간이 없다면 페이지 분할 작업이 일어남. 

------------------- 클러스터 
USE tempdb;
CREATE TABLE clusterTbl
( userID char(8) NOT NULL,
  name nvarchar(10) NOT NULL
);
GO
INSERT INTO clusterTbl VALUES('LSG', '이승기');
INSERT INTO clusterTbl VALUES('KBS', '김범수');
INSERT INTO clusterTbl VALUES('KKH', '김경호');
INSERT INTO clusterTbl VALUES('JYP', '조용필');
INSERT INTO clusterTbl VALUES('SSK', '성시경');
INSERT INTO clusterTbl VALUES('LIB', '임재범');
INSERT INTO clusterTbl VALUES('YJS', '윤종신');
INSERT INTO clusterTbl VALUES('EJW', '은지원');
INSERT INTO clusterTbl VALUES('JKW', '조관우');
INSERT INTO clusterTbl VALUES('BBK', '바비킴');

SELECT * FROM clusterTbl; --입력한 순서와 동일
GO
ALTER TABLE clusterTbl
		ADD CONSTRAINT PK_clusterTbl_userID
				PRIMARY KEY (userID);
SELECT * FROM clusterTbl; --userID로 오름차순 정렬 왜냐면 PRIMARY KEY로 지정했으므로 클러스터형 인덱스가 생성되었다. 
-- 클러스터형 인덱스는 데이터의 검색 속도가 비클러스터형 인덱스보다 더 빠르다.
GO
---------------- 비클러스터
USE tempdb;
CREATE TABLE nonclusterTbl
( userID char(8) NOT NULL,
  name nvarchar(10) NOT NULL
);
GO
INSERT INTO nonclusterTbl VALUES('LSG', '이승기');
INSERT INTO nonclusterTbl VALUES('KBS', '김범수');
INSERT INTO nonclusterTbl VALUES('KKH', '김경호');
INSERT INTO nonclusterTbl VALUES('JYP', '조용필');
INSERT INTO nonclusterTbl VALUES('SSK', '성시경');
INSERT INTO nonclusterTbl VALUES('LIB', '임재범');
INSERT INTO nonclusterTbl VALUES('YJS', '윤종신');
INSERT INTO nonclusterTbl VALUES('EJW', '은지원');
INSERT INTO nonclusterTbl VALUES('JKW', '조관우');
INSERT INTO nonclusterTbl VALUES('BBK', '바비킴');

SELECT * FROM nonclusterTbl; --입력한 순서와 동일
GO
ALTER TABLE nonclusterTbl
		ADD CONSTRAINT PK_nonclusterTbl_userID
				UNIQUE (userID);
SELECT * FROM nonclusterTbl; --비클러스터는 변화 없음 
-- 비클러스터는 클러스터형 인덱스와 달리 '페이지 번호 + #오프셋'이 기록되어 바로 데이터의 위치를 가리키게 된다. 

INSERT INTO clusterTbl VALUES('FNT', '푸니타');
INSERT INTO clusterTbl VALUES('KAI', '카아이');

INSERT INTO nonclusterTbl VALUES('FNT', '푸니타');
INSERT INTO nonclusterTbl VALUES('KAI', '카아이');

-- 클러스터형 인덱스의 생성시에는 데이터 페이지 전체가 다시 정렬된다. -- 이미 대용량의 데이터가 입력된 상태라 면 업무시간에 클러스터형 인덱스를 생성하는 것은 심각한 시스템 부하를 줄 수 있으므로 신중하게 생각해야 한다.-- 클러스터형 인덱스는 인덱스 자체의 리프 페이지가 곧 데이터다. 인덱스 자체에 데이터가 포함이 되어있다고 볼 수있다. -- 비클러스터형보다 검색 속도는 더 빠르다. 하지만, 데이터의 입력/수정/삭저는 더 느리다. -- 클러스터 인덱스는 성능이 좋지만 테이블에 한 개만 생성할 수 있다. -- 그러므로 어느 열에 클러스터형 인덱스를 생성하느냐 따라서 시스템의 성능이 달라질 수 있다.-- 비클러스터형 인덱스의 생성 시에는 데이터 페이지는 그냥 둔 상태에서 별도의 페이지에 인덱스를 구성한다.-- 비클러스터형 인덱스는 인덱스 자체의 리프 페이지는 데이터가 아니라, 데이터가 위치하는 포인터(RID)다. -- 클러스터형보다 검색 속도는 더 느리지만, 데이터의 입력/수정/삭제는 덜 느리다. -- 비클러스터형 인덱스는 여러 개 생성할 수가 있다. 하지만, 함부로 남용할 경우에는 -- 오히려 시스템 성늘을 떨어뜨리는 결과를 초래할 수 있으므로 꼭 필요한 열에만 생성하는 것이 좋다.-----------------------클러스터 비클러스터형 인덱스 혼합 USE tempdb;
CREATE TABLE mixedTbl
( userID char(8) NOT NULL,
  name nvarchar(10) NOT NULL,
  addr nchar(2)
);
GO
INSERT INTO mixedTbl VALUES('LSG', '이승기', '서울');
INSERT INTO mixedTbl VALUES('KBS', '김범수', '경남');
INSERT INTO mixedTbl VALUES('KKH', '김경호', '전남');
INSERT INTO mixedTbl VALUES('JYP', '조용필', '경기');
INSERT INTO mixedTbl VALUES('SSK', '성시경', '서울');
INSERT INTO mixedTbl VALUES('LIB', '임재범', '서울');
INSERT INTO mixedTbl VALUES('YJS', '윤종신', '경남');
INSERT INTO mixedTbl VALUES('EJW', '은지원', '경북');
INSERT INTO mixedTbl VALUES('JKW', '조관우', '경기');
INSERT INTO mixedTbl VALUES('BBK', '바비킴', '서울');
GO
ALTER TABLE mixedTbl
		ADD CONSTRAINT PK_mixedTbl_userID
				PRIMARY KEY (userID);
GO
ALTER TABLE mixedTbl
		ADD CONSTRAINT PK_mixedTbl_name
				UNIQUE (name);
GO
EXEC sp_helpindex mixedTbl;

SELECT addr FROM mixedTbl WHERE name = '임재범';

SELECT * FROM mixedTbl WHERE userID = 'LJB';

SELECT * FROM mixedTbl;

-------------------------------------------------
-- 인덱스 생성/변경/삭제

---- 인덱스 생성 
--PAD_INDEX와 FILLFACTOR 
--PAD_INDEX의 기본값은 OFF이며 만약 ON으로 설정되었다면 FILLFACTOR에 설정된 값이 의미를 갖게 된다. 
--이는 인덱스 페이지를 생성할 때 얼마만큼의 여유를 두겠냐는 의미
--이 값을 지정하지 않으면 SQL SERVER는 인덱스 생성시에 인덱스 페이지는 두 개의 레코드를 입력할 공간만 남겨 놓고 꽉 채운다. 

--SORT_IN_TEMPDB
--ON으로 설정하면 디스크의 분리 효과가 발생해 인덱스를 생성하는데 드는 시간을 줄일 수가 있다. 디폴트는 OFF
--인덱스도 생성할 때 필요로 하는 임시 파일의 읽기/쓰기 작업을 TEMPDB에서 수행하겠다는 의미

--ONLINE 
--ONLINE의 디폴트는 OFF이다. ON으로 설정하면 인덱스 생성 중에도 기본 테이블에 쿼리가 가능
--잠시라도 중단되어서 안되는 시스템에서 유용

--MAXDOP
--인덱스 생성 시에 사용할 CPU의 개수를 강제로 지정
--최대 64까지 지정할 수 있다.

--DATA_COMPRESSION
--인덱스를 압축할 것인지를 지정
GO

---- 인덱스 변경

--REBUILD
--인덱스를 삭제하고 다시 생성하는 효과
--만약, 비클러스터형 인덱스에 어떠한 이유로 불일치가 생긴다면, 다시 생성해서 문제를 해결할 수도 있다. 
--아래의 예문 SQLDB의 USERTBL에 생성된 비클러스터형 인덱스의 문제를 해결해줌

USE sqlDB;
ALTER INDEX ALL ON userTbl
	REBUILD
	WITH (ONLINE=ON); -- 대용량 데이터베이스일 경우 오프라인 후에 전체 인덱스의 재생성이 오래걸릴 수 있으므로 ONLINE=ON을 하면 인덱스 재생성 중에도 시스템이 계속 가동됨(시스템이 느려질 수 있음)

--REORGANIZE
--인덱스를 다시 구성해준다. REBUILD와 달리 인덱스를 삭제하고 다시 생성해주는 것은 아니다. 
--이 옵션을 사용하는 경우는 테이블을 오랫동안 사용하면 인덱스가 조각화되어 있는 것을 모아주는 효과를 내서 시스템 성능에 약간 도움을 줄 수 있다.
GO

---- 인덱스 제거
DROP INDEX 테이블이름.인덱스이름
--기본키 제약 조건과 유니크 제약 조건으로 자동 생성된 인덱스는 DROP INDEX로 제거 할 수 없다.
--이 경우에는 ALTER TABLE 구문으로 제약 조건을 제거하면 인덱스도 자동으로 제거 된다. 
--DROP INDEX로 시스템 테이블의 인덱스를 제거할 수 없다. 
--인덱스를 모두 제거할 때는 비클러스터형부터 제거하는 것이 좋다. 
GO

---- 실습 
--1. 복원
USE tempdb
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO 
--2. 데이터 확인 
USE sqlDB;
SELECT *FROM userTbl;
GO

EXEC sp_helpindex userTbl; --여기서 보이는 인덱스는 클러스터형 인덱스며, 중복되지 않는 인덱스다. 즉 UNIQUE CLUSTERED INDEX
GO

--클러스터형 인덱스가 이미 있으므로 이 테이블에는 이제 클러스터형 인덱스를 생성할 수 없다. 
--주소에 단순 비클러스터형 인덱스 생성 '단순'은 중복을 허용한다는 의미로 고유와 반대라고 생각

CREATE INDEX idx_userTbl_addr
		ON userTbl(addr);
GO
EXEC sp_helpindex USERTBL;

--김범수와 성시경이 1979년으로 중복이여서 출생년도에는 고유 비클러스터형 인덱스를 생성할 수 없음
--따라서 이름에 고유 비클러스터형 인덱스를 생성
CREATE UNIQUE INDEX idx_userTbl_name
		ON userTbl(name);
GO
EXEC sp_helpindex USERTBL;
-- 하지만 실제 사용 시에는 이름이 중복되는 사람이 많으므로 이렇게 하면 안되고 주민번호나 학번 이메일 주소로 설정해야함

-- 따라서 이름과 출생년도 열을 조합해서 인덱스 생성
CREATE NONCLUSTERED INDEX idx_userTbl_name_birthYear
		ON userTbl(name, birthYear);
GO
EXEC sp_helpindex USERTBL;

--아래와 같은 쿼리문에 사용하지만 이런 쿼리가 거의 사용하지 않는다면 이 인덱스는 성능에 나쁜 영향을 준다. 
SELECT *FROM userTbl WHERE name = '윤종신' AND birthYear = '1969';
GO

--휴대폰 국번 열에 인덱스를 생성
CREATE NONCLUSTERED INDEX idx_userTbl_mobile1
		ON userTbl(mobile1);
GO
SELECT *FROM userTbl WHERE mobile1 = '011';
-- 국번 종류가 얼마되지 않아 없는게 더 낫다. (실행 계획에서도 Clustered Index Scan으로 나와 인덱스를 사용하지 않고 전체 테이블을 검색한 것과 똑같은 것임)

--인덱스 제거 
EXEC sp_helpindex USERTBL;

DROP INDEX USERTBL.idx_userTbl_addr;
DROP INDEX USERTBL.idx_userTbl_mobile1;
DROP INDEX USERTBL.idx_userTbl_name;
DROP INDEX USERTBL.idx_userTbl_name_birthYear;

DROP INDEX USERTBL.PK__userTbl__CB9A1CDF5C49B816; --제약 조건으로 생성된 인덱스는 DROP INDEX 구문으로 삭제할 수 없다. 

EXEC sp_help USERTBL; --조회
EXEC sp_help buyTbl; -- 조회

--따라서 다음과 같이 참조 하고 있는 FK를 삭제하고 삭제를 한다.
ALTER TABLE buyTbl
	DROP CONSTRAINT FK__buyTbl__userID__25869641;
GO
ALTER TABLE USERTBL
	DROP CONSTRAINT PK__userTbl__CB9A1CDF5C49B816;
GO
EXEC sp_help USERTBL; --조회 