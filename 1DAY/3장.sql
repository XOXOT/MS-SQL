--SQL 3장 2022-04-04

--SELECT * FROM	memberTBL;
--GO

--SELECT memberName, memberAddress from memberTBL;

--select *from memberTBL where memberName = '지운이';

--create table "my testTBL" (id INT); //테이블 생성 쿼리문

--DROP TABLE [my testTBL]; //테이블 삭제 쿼리문 

--select * from productTBL where productName = '세탁기';

------------------------------------------------------------------
--인덱스(책 맨뒤의 찾아보기 느낌)

--USE ShopDB; -- ShopDB에 쓸 것이다
--SELECT Name, ProductNumber, ListPrice, Size INTO indexTBL FROM AdventureWorks2016CTP3.Production.Product;
--GO --AdventureWorks안의 indexTBL을 ShopDB 테이블로 복사하는 코드 
--SELECT * FROM indexTBL; -- ShopDB 안의 테이블 이름 

--SELECT * FROM indexTBL WHERE Name = 'minipump'; --인덱스를 사용하지 않고  테이블 스캔(테이블 전체를 검색)
--create INDEX idx_indexTBL_Name ON indexTBL(Name); 
--실행 계획 포함란에 Index Seek(인덱스를 사용) 즉 책 전체를 사용하는 것이 아닌 찾아보기에서 minipump를 찾고 거기에 써있는 페이지를 바로 펴서 검색하는 기능과 같다.

------------------------------------------------------------------
--뷰(가상의 테이블) 사용자 입장에서는 테이블과 동일하게 보이지만, 뷰는 실제 행 데이터를 가지고 있지 않음 
CREATE VIEW uv_memberTBL -- 뷰 생성 
AS
SELECT memberName, memberAddress FROM memberTBL; -- 생성 할 뷰의 데이터 선택

SELECT *FROM uv_memberTBL; --만든 뷰 조회 

------------------------------------------------------------------

--저장 프로시저(SQL문을 하나로 묶어서 편리하게 사용하는 기능)

SELECT * FROM memberTBL WHERE memberName = '당탕이';
SELECT * FROM productTBL WHERE productName = '냉장고';
--이러한 두개의 쿼리문을 

CREATE PROCEDURE myProc --프로시저 생성 CREARE PROCEDURE 이름 AS 원하는 쿼리문 GO
AS
SELECT * FROM memberTBL WHERE memberName = '당탕이';
SELECT * FROM productTBL WHERE productName = '냉장고';
GO

EXECUTE myProc; -- EXECUTE 프로시저 호출
------------------------------------------------------------------
--DROP문 
--DROP 개체종류(VIEW나 PROCEDURE 등등) 해당 이름
--DROP PROCEDURE myProc; -- myProc 프로시저 삭제
------------------------------------------------------------------

--트리거(테이블에 INSERT나 DELETE UPDATE 작업이 발생되면 실행되는 코드)
-- 예를 들어 당탕이가 회원탈퇴를 했는데 나중에 탈퇴한 사람이 누구인가를 알 수 없기 때문에 당탕이의 행 데이터를 다른 곳에 먼저 저장을 자동으로 해줌

--1. 회원 테이블에 새로운 회원을 새로 입력
INSERT INTO memberTBL VALUES ('Figure', '연아', '경기도 군포시 당정동'); --데이터 삽입 INSERT INTO 테이블명 (컬럼명 (생략하면 전체) VALUES (컬럼에 들어갈 데이터) 

--2. 새로운 회원 주소를 바꾸자
UPDATE memberTBL SET memberAddress = '서울 강남구 역삼동' WHERE memberName = '연아'; --데이터 업데이트 UPDATE 테이블명 SET 컬럼명 WHERE 조건

--3. 새로운 회원이 탈퇴를 했으니 회원 테이블에서 삭제
DELETE memberTBL WHERE memberName = '연아';

--4. 전체 memberTBL 조회 (연아 삭제 확인)
SELECT * FROM memberTBL;

--5. 지워진 데이터를 보관할 테이블을 만듬 (삭제 날짜 추가)
CREATE TABLE deletedMemberTBL
(memberID char(8), memberName nchar(5), memberAddress nchar(20), deleteDate date);

CREATE TRIGGER trg_deletedMemberTBL
ON memberTBL 
AFTER DELETE
AS
INSERT INTO deletedMemberTBL SELECT memberID, memberName, memberAddress, GETDATE() FROM deleted; --GETDATE()는 현재 날짜

--6. 회원 테이블 확인
SELECT * FROM memberTBL;

--7. 당탕이 삭제
DELETE memberTBL WHERE memberName = '당탕이';

--8. 회원 테이블 및 백업 테이블 확인
SELECT * FROM memberTBL; --회원테이블
SELECT * FROM deletedMemberTBL; -- 백업 테이블 

------------------------------------------------------------------

-- 백업 

USE ShopDB;
SELECT * FROM productTBL;

-- ShopDB 오른쪽 클릭 후 테스크 -> 백업 ShopDB(데이터 베이스 선택) 백업할 위치 지정
--ShopDB.bak 파일 생성 

--사고 발생 시키기
--DELETE FROM productTBL; 

--조회 
SELECT * FROM productTBL;

USE tempDB; --비어있는 DB를 선택하여 ShopDB와 관련된 쿼리창을 전부 종료
-- 데이터베이스 오른쪽 클릭 후 데이터베이스 복원 위에서 백업한 BAK 파일 불러옴 

   USE ShopDB
   GO 
   SP_CHANGEDBOWNER 'sa'

   sp_helpdb 'ShopDB'

   SELECT NAME, OWNER_SID FROM SYS.DATABASES;

   SELECT SID FROM SYS.SYSLOGINS;
