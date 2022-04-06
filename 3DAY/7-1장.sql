-------7장 

--데이터 형식

----숫자 
BIT
TINYINT
SMALLINT 
INT
DECIMAL(P,N) 
FLOAT(N)

----문자 
CHAR
NCHAR
VARCHAR 
NVARCHAR

----날짜 
DATETIME2
DATE
TIME 

----기타
CURSOR
TABLE
XML
GEOMETRY 

-------변수 

USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE; --백업한 파일 복원 쿼리문 

--DECLARE는 휘발성 변수로 실행 후에 사라지므로 나중에 다시 쓸 때는 선언한 부분까지 긁어서 실행해야한다. 
USE sqlDB;
DECLARE @myVar1 INT;
DECLARE @myVar2 SMALLINT, @myVar3 DECIMAL(5,2);
DECLARE @myVar4 NCHAR(20);

SET @myVar1 = 5;
SET @myVar2 = 3;
SET @myVar3 = 4.25;
SET @myVar4 = '가수 이름==>>';

SELECT @myVar1;
SELECT @myVar2+@myVar3;
SELECT @myVar4, Name FROM userTbl WHERE height >180;

-- TOP 구분의 내부 변수를 사용 
DECLARE @myVar1 INT;
SET @myVar1 =3;
SELECT TOP(@myVar1) Name, height FROM userTbl ORDER BY height;

---------- 데이터 형식과 관련된 시스템 함수

--명시적 변환
--구매 테이블에서 평균 구매 개수 
USE sqlDB;
SELECT AVG(amount) AS [평균 구매 개수] FROM buyTbl;
--CAST
SELECT AVG(CAST(amount AS FLOAT)) AS [평균구매개수] FROM buyTbl; --cast를 사용하여 float 형식으로 변환
--CONVERT
SELECT AVG(CONVERT(FLOAT, amount)) AS [[평균구매개수] FROM buyTbl; --CONVERT를 사용하여 float 형식으로 변환
--TRY_CONVERT -CONVERT와 다르게 반환에 실패할 경우 NULL값을 반환
SELECT AVG(TRY_CONVERT(FLOAT, amount)) AS [[평균구매개수] FROM buyTbl; --TRY_CONVERT를 사용하여 float 형식으로 변환

--단가/수량의 결과
SELECT price, amount, price/amount AS [단가/수량] FROM buyTbl; --정수라서 정확한 값이 아니다.
--CAST
SELECT price, amount, CAST(CAST(price AS FLOAT)/amount AS DECIMAL(10,2)) AS [단가/수량] FROM buyTbl; --cast를 사용하여 float 형식으로 변환
--CONVERT
SELECT price, amount, CONVERT(FLOAT, price) /CONVERT(DECIMAL(10,2),amount) AS [단가/수량] FROM buyTbl; --좀 다름?
SELECT price, amount, CONVERT(DECIMAL(10,2),CONVERT(FLOAT, price)/amount) AS [단가/수량] FROM buyTbl; -- 이게 정답 
--TRY_CONVERT
SELECT price, amount, TRY_CONVERT(FLOAT, price) /TRY_CONVERT(DECIMAL(10,2),amount) AS [단가/수량] FROM buyTbl; --좀 다름?
SELECT price, amount, TRY_CONVERT(DECIMAL(10,2),TRY_CONVERT(FLOAT, price)/amount) AS [단가/수량] FROM buyTbl; -- 이게 정답

--참고 CONVERT함수에서 이진데이터와 문자 데이터의 상호변환도 가능
SELECT CONVERT(NCHAR(2), 0X48C555B1,0);

--특별히 문자열을 변환할 경우 PARSE나 TRY_PARSE를 사용할 수 있다.
SELECT PARSE('2019년 9월 9일' AS DATE); -- 2019-09-09로 바뀜
SELECT PARSE('123.45' AS INT); --오류 
SELECT TRY_PARSE('123.45' AS INT); --오류 나면 NULL 값 출력 해줌 따라서 프로그래밍에서 오류가 나도 계속 진행할 때 TRY를 잘 사용함 
GO

--암시적인 형변환
DECLARE @myVar1 CHAR(3);
SET @myVar1 = '100';
SELECT @myVar1 + '200'; --문자와 문자를 더함 (정상)
SELECT @myVar1 + 200; -- 문자와 정수를 더함(정상: 정수로 암시적 형 변환)
SELECT @myVar1 + 200.0; -- 문자와 실수를 더함(정상: 실수로 암시적 형 변환)

--명시적 변환
DECLARE @myVar1 CHAR(3);
SET @myVar1 = '100';
SELECT @myVar1 + '200'; --문자와 문자를 더함 (정상)
SELECT CAST(@myVar1 AS INT) + 200; -- 문자와 정수를 더함(정상: 정수로 암시적 형 변환)
SELECT CAST(@myVar1 AS DECIMAL(5,1)) + 200.0; -- 문자와 실수를 더함(정상: 실수로 암시적 형 변환)

--숫자에서 문자로 변환할 때 문자의 자릿수를 잘 고려해야함
DECLARE @myVar2 DECIMAL(10,5);
SET @myVar2 = 10.12345;
SELECT CAST(@myVar2 AS NCHAR(8)); --5로 할 경우 오버플로우 발생! 따라서 8로 변환

--실수를 정수로 변환 할 때 자릿수가 잘릴 수 있다는 점 고려
DECLARE @myVar3 DECIMAL(10,5);
SET @myVar3 = 10.12345;
SELECT CAST(@myVar3 AS INT); --다 잘림

DECLARE @myVar4 DECIMAL(10,5);
SET @myVar4 = 10.12345;
SELECT CAST(@myVar4 AS DECIMAL(10,2)); --둘 째 자리까지 표현
GO

----------------스칼라 함수 

--MAX 지정자

--1. max형 데이터 정의
USE tempdb;
CREATE TABLE maxTbl
(col1 VARCHAR(MAX),
 col2 NVARCHAR(MAX));
--2. 기존의 각각 1,000,000(백만)개 문자의 대량 데이터를 입력
INSERT INTO maxTbl VALUES(REPLICATE('A',1000000), REPLICATE('가',1000000));
--3. 입력된 값 크기 확인 
SELECT LEN(col1) AS [VARCHAR(MAX)], LEN(col2)AS [NVARCHAR(MAX)] FROM maxTbl; --전체 들어가지지 않음 각각 8000, 4000문자만 들어감
--4. VARCHAR(MAX)및 NVARCHAR(MAX) 데이터 형식에 8000바이트가 넘는 양을 입력하려면 입력할 문자를 CAST함수나 CONVERT 함수로 형 변환을 시켜야함
DELETE FROM maxTbl;
INSERT INTO maxTbl VALUES(
	REPLICATE(CAST('A' AS VARCHAR(MAX)), 1000000),
	REPLICATE(CONVERT(VARCHAR(MAX), '가'), 1000000));
SELECT LEN(col1) AS [VARCHAR(MAX)], LEN(col2) AS [NVARCHAR(MAX)] FROM maxTbl;
--5. 'A'는 'B'로 '가'는 '나'로 변경 
UPDATE maxTbl SET col1 = REPLACE((SELECT col1 FROM maxTbl), 'A', 'B'),
				  col2 = REPLACE((SELECT col2 FROM maxTbl), '가', '나');
--6. 데이터가 잘 변경되었는지 확인 (양이 많으므로 뒷부분을 출력) - REVERSE나 SUBSTRING 함수 사용
SELECT REVERSE((SELECT col1 FROM maxTbl));
SELECT SUBSTRING((SELECT col2 FROM maxTbl), 99991, 10); 
--7. 데이터 변경 함수 STUFF, UPDATE에서 제공해주는 열이름, WRITE함수를 이용해서 데이터를 변경 (성능 확인) WRITE 함수가 아주 빠름 

--8. STUFF를 이용하여 데이터 마지막 10글자를 'C'와 '다'로 변경
UPDATE maxTbl SET
	col1 = STUFF((SELECT col1 FROM maxTbl), 999991, 10, REPLICATE('C', 10)),
	col2 = STUFF((SELECT col2 FROM maxTbl), 999991, 10, REPLICATE('다', 10));

--9. WRITE 함수를 이용하여 마지막 5글자 'D'와 '라'로 변경
UPDATE maxTbl SET col1.WRITE('DDDDD',999996,5) , col2.WRITE('라라라라라',999996,5); --WRITE 함수가 아주 빠름 

--10. 데이터가 잘 변경되었는지 확인 (양이 많으므로 뒷부분을 출력) 
SELECT REVERSE((SELECT col1 FROM maxTbl));
SELECT REVERSE((SELECT col2 FROM maxTbl));

------순위 함수 
--1. 회원 테이블에서 키가 큰 순으로 순위를 정하고 싶을 경우 ROW_NUMBER() 함수를 사용한다. 
USE sqlDB;
SELECT ROW_NUMBER() OVER(ORDER BY height DESC) [키큰순위], name, addr, height FROM userTbl;
--2. 동일한 키일 경우 이름순으로 정렬
SELECT ROW_NUMBER() OVER(ORDER BY height DESC, name ASC) [키큰순위], name, addr, height FROM userTbl;
--3. 이번에는 전체 순위가 아닌 지역별 순위를 출력, 지역을 나눈 후 키 큰 순위. PARTITION BY 사용
SELECT addr, ROW_NUMBER() OVER(PARTITION BY addr ORDER BY height DESC, name ASC) [지역별키큰순위], name, height FROM userTbl;
--4. 같은 키 동일 등수처리 DENSE_RANK() 함수 사용
SELECT DENSE_RANK() OVER(ORDER BY height DESC) [키큰순위], name, addr, height FROM userTbl;
--5. 2등이 중복이므로 3등을 빼고 4등부터 순위를 매김 RANK()함수 사용
SELECT RANK() OVER(ORDER BY height DESC) [키큰순위], name, addr, height FROM userTbl;
--6. 전체 인원을 키순으로 세운 후 몇개의 그룹으로 분할 하는 NTILE 함수 
SELECT NTILE(2) OVER(ORDER BY height DESC) [반번호], name, addr, height FROM userTbl; --반을 2개로 나눈 경우
--6. 전체 인원을 키순으로 세운 후 몇개의 그룹으로 분할 하는 NTILE 함수 
SELECT NTILE(3) OVER(ORDER BY height DESC) [반번호], name, addr, height FROM userTbl; --동일하게 할당한 후 처음 그룹부터 하나씩 배당 하므로 1이 증가 
SELECT NTILE(4) OVER(ORDER BY height DESC) [반번호], name, addr, height FROM userTbl; -- 마찬가지로 1반 한명 2반 한명