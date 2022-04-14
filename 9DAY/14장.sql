--------------14장

--전체 텍스트 검색 
-- 긴 문자로 구성된 구조화되지 않은 텍스트 데이터(EX. 신문기사) SQL 부가적 기능
-- 저장된 텍스트의 키워드 기반의 쿼리를 위해서 빠른 인덱싱이 가능 
-- 신문기사와 같이, 텍스트로 이루어진 문자열 데이터의 내용을 가지고 생성한 인덱스를 말한다.
-- SQL SEVER에서 생성한 일반적인 인덱스와는 몇 가지 차이점이 있다. 
	-- 일반 인덱스는 테이블 당 여러 개를 생성일 수 있지만, 전제 텍스트 인덱스는 테이블 당 하니만 생성할 수 있다. 
	-- 일반 안넥스는 Insert. Update. Delete 되면 인덱스도 자동으로 업데이트 된다.
	-- 전체 텍스트 인덱스에 데이터를 추가하는 채우기는 일정 예약이나 특별한 요청에 의해서 수행되거나, 새로운 데이티들 lnsert 시에 자동으로 수행되도록 한다.
	-- 전체 텍스트 인덱스는 char, varchar, nchar, nvarchar, text, ntext, image, xml, varbinary (max), FILESTREAM 등의 열에 생성이 가능
	-- 전체 텍스트 인덱스를 생성할 테이블에는 PRIMARY KEY나 UNIQUE KEY가 존재해야 한다. 
GO

-- 실습 
--1. 테이블 생성 
USE tempdb;
GO
CREATE DATABASE FulltextDB;
GO

USE FulltextDB;
CREATE TABLE FulltextTbl
(id int IDENTITY CONSTRAINT pk_id PRIMARY KEY, --고유 번호
 title NVARCHAR(15) NOT NULL, --영화 제목
 description NVARCHAR(max)); -- 영화 내용 요약
GO

 --2. 샘플 데이터 입력
INSERT INTO FulltextTbl VALUES('광해, 왕이 된 남자','왕위를 둘러싼 권력 다툼과 당쟁으로 혼란이 극에 달한 광해군 8년');
INSERT INTO FulltextTbl VALUES('간첩','남한 내에 고장간첩 5만 명이 암약하고 있으며 특히 권력 핵심부에도 침투해있다.');
INSERT INTO FulltextTbl VALUES('피에타',' 더 나쁜 남자가 온다! 잔혹한 방법으로 돈을 뜯어내는 악마같은 남자 스토리.');
INSERT INTO FulltextTbl VALUES('레지던트 이블 5','인류 구원의 마지막 퍼즐, 이 여자가 모든 것을 끝낸다.');
INSERT INTO FulltextTbl VALUES('파괴자들','사랑은 모든 것을 파괴한다! 한 여자를 구하기 위한, 두 남자의 잔인한 액션 본능!');
INSERT INTO FulltextTbl VALUES('킹콩을 들다',' 역도에 목숨을 건 시골소녀들이 만드는 기적 같은 신화 .');
INSERT INTO FulltextTbl VALUES('테드','지상최대 황금찾기 프로젝트! 500년 전 사라진 황금도시를 찾아라!');
INSERT INTO FulltextTbl VALUES('타이타닉','비극 속에 침몰한 세기의 사랑, 스크린에 되살아날 영원한 감동');
INSERT INTO FulltextTbl VALUES('8월의 크리스마스','시한부 인생 사진사와 여자 주차 단속원과의 미묘한 사랑')
INSERT INTO FulltextTbl VALUES('늑대와 춤을','늑대와 친해져 모닥불 아래서 함께 춤을 추는 전쟁 영웅 이야기');
INSERT INTO FulltextTbl VALUES('국가대표','동계올림픽 유치를 위해 정식 종목인 스키점프 국가대표팀이 급조된다.');
INSERT INTO FulltextTbl VALUES('쇼생크 탈출','그는 누명을 쓰고 쇼생크 감옥에 감금된다. 그리고 역사적인 탈출.');
INSERT INTO FulltextTbl VALUES('인생은 아름다워','귀도는 삼촌의 호텔에서 웨이터로 일하면서 또 다시 도라를 만난다.');
INSERT INTO FulltextTbl VALUES('사운드 오브 뮤직','수녀 지망생 마리아는 명문 트랩가의 가정교사로 들어간다');
INSERT INTO FulltextTbl VALUES('매트릭스',' 2199년.인공 두뇌를 가진 컴퓨터가 지배하는 세계.');
GO

--3. 아직 전체 텍스트 인덱스를 만들지 않았지만 이 상태에서 '남자'라는 단어를 검색
SELECT *FROM FulltextTbl WHERE description LIKE '%남자%';
-- 스캔을 한 것을 볼 수 있는데 이는 테이블 검색과 동일하게 모든 데이터 페이지를 검색한 결과.
-- 지금 데이터가 몇 건 되지 않아서 문제가 없지만, 대용량의 데이터라면 SQL SERVER에 상당한 부하가 생길 것이다.
GO

--4. 전체 텍스트 카탈로그 생성
--4-1. 기존 카탈로그 정보 확인
SELECT *FROM sys.fulltext_catalogs; --아무것도 만들지 않아 나오지 않음
GO

--4-2. 카탈로그 생성
CREATE FULLTEXT CATALOG movieCatalog AS DEFAULT;
GO

--4-3. 카탈로그 정보 다시 확인
SELECT *FROM sys.fulltext_catalogs; --'is_default'가 1인 것은 이 카탈로그가 디폴트 카탈로그라는 뜻
GO

--5. 전체 인덱스 생성 
--5-1. 인덱스 생성
CREATE FULLTEXT INDEX ON FulltextTbl (description)
		KEY INDEX pk_id
		ON movieCatalog
		WITH CHANGE_TRACKING AUTO;

-- CREATE FULLTEXT INDEX ON FulltextTbl (description)
	-- FulltextTbl 테이블의 description 열에 전체 텍스트 인덱스를 생성

-- KEY INDEX pk_id
	-- 생성 시에 키 열은 앞에서 Primary Key로 지정한 pk_id로 설정

-- ON movieCatalog 
	-- 생성되는 카탈로그는 movieCatalog에 생성되도록 한다.
	-- 카탈로그 생성 시에 디폴트를 movieCatalog로 설정했으므로, 이 옵션은 생략해도 된다.

-- WITH CHANGE_TRACKING AUTO
	-- 변경된 내용의 유지관리는 SQL SERVER가 자동으로 관리하도록 설정한다.(이 옵션은 변경이 많이 일어날 경우에 시스템 성능에 나쁜 영향을 줄 수 있다.)

GO

--5-2. 정보 확인
SELECT *FROM sys.fulltext_indexes; --is_enabled가 1이라는 것이 전체 텍스트가 활성화 중인 것이다. 

--5-3. 이번에는 전체 텍스트 인덱스가 생성된 '단어'나 '문구'는 어떤 것들인지 확인
SELECT *FROM sys.dm_fts_index_keywords(DB_ID(), OBJECT_ID('dbo.FulltextTbl'));
-- 'display_term'은 인덱스가 생성된 단어나 문구
-- 'column_id'는 몇 번째 열인지 의미
-- 'document_count'는 몇 번이나 들어 있는지 뜻함
GO

--6. 전체 텍스트 인덱스의 크기를 줄이기 위해서 '중지 목록'을 만들고, 필요없는 '중지 단어'를 추가
--6-1. 앞에서 생성한 전체 텍스트 인덱스 삭제
DROP FULLTEXT INDEX ON FULLtextTbl; 
GO

--6-2. 중지 목록을 생성 
	-- 데이터 베이스 --> 원하는 DB --> 저장소 --> 전체 텍스트 중지 목록
	-- 여기서 '시스템 중지 목록에서 만들기'의 의미는 기존 SQL SERVER가 가지고 있는 중지 목록의 내용도 포함한다는 의미
	-- 생성된 목록은 우클릭하여 중지 단어 추가 
CREATE FULLTEXT STOPLIST myStopList FROM SYSTEM STOPLIST -- 이렇게도 중지 목록 생성가능
ALTER FULLTEXT STOPLIST myStopList ADD '그리고' LANGUAGE 'Korean'; -- 이렇게 중지 단어 추가 가능
ALTER FULLTEXT STOPLIST myStopList ADD '극' LANGUAGE 'Korean'; -- 이렇게 중지 단어 추가 가능

--6-3. 전체 텍스트 인덱스 생성 (방금 생성한 중지 목록인 myStopList를 옵션으로 지정)
CREATE FULLTEXT INDEX ON FulltextTbl (description)
KEY INDEX pk_id
ON movieCatalog
WITH CHANGE_TRACKING AUTO, STOPLIST = myStopList;
GO

--6-4. 다시 전체 텍스트 인덱스가 생성된 단어나 문구는 어떤 것들이 있나 조회
SELECT *FROM sys.dm_fts_index_keywords(DB_ID(), OBJECT_ID('dbo.FulltextTbl'));
GO

--7. 전체 텍스트 검색
--7-1. '남자'라는 단어를 검색
SELECT *FROM FulltextTbl WHERE CONTAINS(description, '남자'); --인덱스를 사용하여 검색했다는 것을 볼 수 있음
GO

--7-2. AND조건과 OR조건을 검색
SELECT * FROM FulltextTbl
WHERE CONTAINS (description, '남자 AND 여자');
SELECT * FROM FulltextTbl
WHERE CONTAINS (description, '남자 OR 여자');
GO

--7-4. CONTAINS와 FREETEXT 차이
SELECT * FROM FulltextTbl
	WHERE CONTAINS (description, '전쟁이야기');
GO
SELECT * FROM FulltextTbl
WHERE FREETEXT (description,'전쟁이야기'); --FREETEXT가 중간에 다른 글자가 삽입되어 있어도 유연하게 검색해줌
GO

--7-5. CONTAINSTABLE 사용
SELECT *FROM CONTAINSTABLE(FulltextTbl, *,'남자');
-- key는 전체 텍스트 인덱스로 생성된 키(pk_id) 값이며, rank는 해당 열의 일치되는 가중치 값 이 값은 0~1000까지 나올 수 있으며 높을수록 해당하는 값고 더욱 일치하게 된다.
-- 하지만 해당 값만으로 데이터 확인이 어려우니 아래와 같이 조인을 이용하여 주로 사용한다. 
SELECT f.id, C.RANK AS [가중치], f.title, f.description
FROM FulltextTbl AS f
	INNER JOIN CONTAINSTABLE (FulltextTbl, *, '남자') AS C
	ON f.id = C.[KEY]
ORDER BY C.RANK DESC;
GO
--FREETEXTTABLE도 CONTAINSTABLE과 비슷한 결과가 나오지만 조금 더 유연한 검색을 수행해줌
SELECT *FROM FREETEXTTABLE(FulltextTbl, *,'남자');
GO

--7-6. 전체 텍스트 카탈로그 백업 및 복원 
--복원
BACKUP DATABASE FulltextDB TO DISK = 'D:\DB\SQL\9DAY\FulltextDB.bak' WITH INIT;

--삭제 후 복원
USE tempdb;
DROP DATABASE FulltextDB;
GO
RESTORE DATABASE FulltextDB FROM DISK = 'D:\DB\SQL\9DAY\FulltextDB.bak' WITH REPLACE;
GO

--다시 전체 텍스트 인덱스가 생성된 단어, 문구는 어떤 것들이 있나 확인 
USE FulltextDB;
SELECT *FROM sys.dm_fts_index_keywords(DB_ID(), OBJECT_ID('dbo.FulltextTbl'));
GO

----8. 전체 텍스트 인덱스 및 전체 텍스트 카탈로그 삭제
-- 전체 텍스트 카탈로그 삭제 
DROP FULLTEXT CATALOG movieCatalog; -- 전체 텍스트 인덱스가 들어있어 삭제 불가 따라서 전체 텍스트 인덱스 먼저 삭제해야함
GO
-- 전체 텍스트 인덱스 삭제 후 다시 전체 텍스트 카탈로그 삭제
DROP FULLTEXT INDEX ON FulltextTbl; 
DROP FULLTEXT CATALOG movieCatalog; 
GO